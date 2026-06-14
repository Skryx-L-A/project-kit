---
name: agency-automations
description: Builds the RUNNING automations a local-business/agency actually delivers — speed-to-lead, database reactivation, reviews & referrals — wiring webhooks, SMS/email messaging, follow-up sequences, and booking into a live system. Project-kit sub-skill loaded by new-project routing, or composed by build-business, whenever the user wants to DELIVER and RUN automations (not just plan them). Defaults to n8n; can drop to a custom api-backend or an existing GHL-style SaaS. Compliance (TCPA, A2P 10DLC, CAN-SPAM, GDPR, Google review policy) is enforced, not optional.
---

# agency-automations — the runtime layer that makes the strategy RUN

## What this sub-skill is for
`build-business` plans the *strategy and copy* for a local-business agency's three service
pillars. **This skill is the delivery/runtime layer that makes those pillars actually fire** —
real webhooks, real SMS/email, a real follow-up state machine, real bookings. When the user
says "now make it run", "wire it up", "deliver this to a client", or "set up the automation",
this is what builds the live system.

The three pillars it delivers (each has a reference file under `runtime/`):
1. **Speed-to-lead** (`runtime/speed-to-lead.md`) — form/Lead-Ads webhook → instant reply
   inside the 5-minute window → conversational follow-up state machine → booking.
2. **Database reactivation** (`runtime/reactivation.md`) — bulk SMS+email to dormant CRM
   contacts, throttled, with reply→booking and opt-out handling.
3. **Reviews & referrals** (`runtime/reviews-referrals.md`) — review request with feedback
   capture, Google auto-response after a review posts, then a referral ask with a tracked link.

It is **engine-agnostic** (see `platforms.md`): build it in n8n (default), as a custom
api-backend, or on top of a GHL-style SaaS the client already pays for.

> **Relationship to siblings:** `build-business` = strategy + copy (the *what* and the *words*).
> `bot-automation` = the generic trigger→handler→deploy engine. **This skill** = the
> business-specific runtime that composes both. If the user only wants the plan, stay in
> build-business; the moment they want it to *send a real message*, you are here.

---

## Mandatory grill-questions (fold into the Definition of Ready)
Lock these before any wiring — most map directly onto compliance and cannot be skipped:
- **Which pillar(s) now?** Speed-to-lead, reactivation, reviews/referrals — or all three.
- **Engine** — n8n (default) / custom api-backend / existing GHL-style SaaS? (→ `platforms.md`)
- **Lead sources** — web form (which? webhook or embed), Facebook/Instagram Lead Ads, both?
- **Channels** — SMS (Twilio?), email (SendGrid/Resend?), or both. Which is primary?
- **Sender identity** — Twilio number bought & **A2P 10DLC registered**? Email domain with
  **SPF/DKIM/DMARC**? Without these, nothing sends — flag as a hard blocker, not a TODO.
- **Consent provenance** — for *every* contact list and form: when/how was consent captured?
  Reactivation of a list with no opt-in is a TCPA violation — refuse to send it.
- **CRM + calendar** — where do contacts/conversation-state live, and what's the booking link
  (Cal.com / Google Calendar / GHL calendar)? (→ `integrations/crm-and-booking.md`)
- **Business hours / timezone** — quiet-hours window (no marketing SMS 9pm–8am local; TCPA).
- **Raffle/incentive** for referrals — and is it an *honest-feedback* incentive (allowed) or a
  *positive-review* incentive (banned by Google)? (→ COMPLIANCE.md)
- **Volume** — contacts to reactivate, expected daily lead count → throttle + 10DLC tier.

## Project sub-agents to generate (into `.claude/agents/`)
- **webhook-builder** *(delegate-by-default)* — stands up the inbound triggers: web-form
  webhook, Facebook Lead Ads subscription (handles the single-webhook-per-app gotcha),
  signature verification, and the lead-normalising step. Builds in the chosen engine.
- **sequence-engine** *(delegate-by-default)* — implements the follow-up **state machine**
  (states, timers, retry/stop logic) for speed-to-lead and reactivation; idempotent on
  re-delivered events; persists state to the store.
- **review-automation** — review-request send, 1-5 feedback capture, Google auto-response on
  new reviews (GBP API), referral link + raffle-entry tracking. **Must not gate** the Google
  ask on the rating (review-gating is banned) — enforces the compliant pattern.
- **compliance-reviewer** *(adversarial — invoke before anything goes live)* — reads every
  outbound template and flow and **fails the build** if: any SMS lacks STOP/opt-out, sender
  isn't 10DLC-registered, email lacks unsubscribe + physical address, a list has no consent
  provenance, marketing sends into quiet hours, or the review flow gates on rating. Treats
  these as blockers, not warnings. (See COMPLIANCE.md — this agent's checklist.)
- **deploy-runner** — publishes/validates the engine artifact (n8n validate→publish, or
  api-backend deploy), runs the live end-to-end test, and confirms the done-bar.

## Tools / CLIs / MCP / skills to chain
Check in environment-readiness; offer install, never auto-install or invent keys.
- **n8n MCP** (default engine) — follow its mandated order, never guess SDK/node params:
  `get_sdk_reference` → `get_suggested_nodes` → `search_nodes` → `get_node_types` (exact
  params) → write code → `validate_workflow` → `create_workflow_from_code` → `update_workflow`
  → `test_workflow`/`execute_workflow`. Use n8n **Data Tables** for contact/state storage if
  no external CRM. (→ `platforms.md` A)
- **Supabase MCP** — the state/CRM store when not using n8n Data Tables or a SaaS CRM:
  contacts, conversation state, opt-outs, raffle entries, message log. (→ `crm-and-booking.md`)
- **api-backend sub-skill** — **compose it** for the custom-engine path (B): typed webhook
  endpoints, queue/worker for the sequence timers, signed webhooks, migrations. Do not
  re-implement an API here; load api-backend and let it own the server.
- **bot-automation sub-skill** — the generic trigger/handler/deploy engine and hosting
  patterns (always-on vs cron) underneath; chain it for the runtime plumbing.
- **build-business sub-skill** — source of the *strategy and copy*: pull message wording,
  offer, ICP, and the raffle from its `pillars/` + `prompts/` rather than re-writing them.
- **claude-in-chrome / playwright** — for a SaaS or platform with **no API** (e.g. importing
  contacts, posting in a UI-only CRM, scraping a booking page) — drive the UI as a last resort.
- **claude-api** — read before any model id if a flow uses Claude to classify replies / draft
  responses (intent detection in the sequence engine).
- **code-review** + **verify** — before "done": review the flow/endpoints, then *verify live*.

## File / asset nudges (on top of the base project set)
Beyond CLAUDE.md, the project doc, TASKS.md, DONE.md, README, `.claude/`:
- `.env.example` — every secret named (Twilio SID/token/number, SendGrid/Resend key, Supabase
  URL/keys, FB app secret + verify token, GBP OAuth client, Cal.com key). Real `.env` gitignored.
- `runtime/` — one flow artifact per pillar (n8n `*.json` export + a node/param notes file, or
  the api-backend route + worker files).
- `templates/` — the SMS/email bodies, **each carrying its compliance furniture** (STOP/HELP on
  SMS; unsubscribe + physical address on email). Pull copy from build-business; don't hardcode.
- `state/` schema (Supabase migration or n8n Data Table definition): contacts, conversations,
  opt_outs, reviews, referrals, message_log.
- `COMPLIANCE.md` (copy into the project) + a `consent-log` note: where each list's opt-in lives.
- `runbook.md` — start/stop, where logs go, how to rotate keys, how to handle a STOP/bounce.

## Stack defaults & done-bar
**Default stack:** n8n (via MCP) as the engine; **Twilio** SMS (10DLC-registered) + **Resend or
SendGrid** email (authenticated domain); **Supabase** for contact + conversation state (or n8n
Data Tables for a light build); **Cal.com** booking link; **GBP API v4** for review replies.
Custom-control builds swap n8n for an **api-backend** (Supabase-backed). Client-owns-SaaS builds
target their **GoHighLevel/GHL-style** instance and only wire the missing pieces.

**"Finished / working" means (the done-bar — verified LIVE, not reasoned):**
- A **real form submission** (and a real Lead-Ads test lead) triggers an **instant auto-reply
  delivered within the 5-minute window** — confirmed by delivery webhook, not just "sent".
- The **follow-up sequence runs to a booking** in a test: the state machine advances through its
  steps on the timers, a "yes" reply produces a booking link / calendar hold, and a non-reply
  hits the stop condition.
- **Opt-out works**: texting **STOP** halts all further sends to that contact and records the
  suppression; replying with intent moves them to booking.
- **Review routing splits correctly**: a 4-5 path and a 1-3 path each resolve to the right
  destination **without gating the public Google ask on the rating** (everyone can still reach
  Google; low ratings additionally trigger private service-recovery) — and a posted review gets
  an auto-response via the GBP API.
- **compliance-reviewer passes** every template and flow; nothing went live before it did.

## Guardrails (standing footer — enforced)
- **Compliance is a blocker, not a checkbox.** No send without 10DLC registration, STOP on every
  SMS, unsubscribe + physical address on every email, and documented consent for the list. The
  Google review ask is **never gated on the rating**. See `COMPLIANCE.md` — it is mandatory.
- **No emojis in any UI, message body, or output** — typographic symbols only.
- **Commits under the user's own name only (Skryx-L-A); never add Claude as co-author.**
- **Never commit secrets / API keys** — `.env` only (gitignored), `.env.example` documents names.
- **No real customer PII committed** to a public repo — use synthetic data in examples/tests.
- **Validate before deploy** — never publish an unvalidated n8n flow or push an untested endpoint;
  never go live before the live end-to-end test and the compliance-reviewer pass.
