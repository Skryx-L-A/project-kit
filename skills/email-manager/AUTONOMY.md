# AUTONOMY — how far Claude may act on the inbox

Autonomy is **set once with the user, written to `email-profile.md`, and enforced on every
run**. It is a ladder: start low, climb only on explicit opt-in. The default for a freshly
connected inbox is **Tier 2**. When a single message is ambiguous about which tier applies,
**drop to the lower tier** for that message.

The golden rule that sits above all three tiers:

> **The Gmail MCP cannot send. So Tiers 1–2 are physically draft-only.** "Auto-send" (Tier 3)
> is only possible by wiring a separate transport (`transports.md`) and is gated to a named
> whitelist. If no transport is wired, Tier 3 collapses to Tier 2 — which is the safe default,
> not a failure.

---

## The three tiers

### Tier 1 — Read + summarize (observe only)
Claude may: `search_threads`, `get_thread`, `list_drafts`, `list_labels`, read, summarize,
extract action items, propose (but not apply) labels.
Claude may **not**: create/apply/remove labels, archive, draft, or send. **Zero writes** to
the inbox.
Use it for: "just tell me what's in my inbox", first-time audits, untrusted contexts, or any
inbox the user hasn't fully handed over yet.

### Tier 2 — Triage + label + draft (DEFAULT)
Everything in Tier 1, plus:
- `create_label` / `update_label` — set up and maintain the taxonomy (`labels.md`).
- `label_thread` / `label_message` / `unlabel_*` — apply the taxonomy.
- **Archive** obvious noise (remove `INBOX` label) per the triage rules — reversible.
- `create_draft` — save on-voice reply drafts.

Claude still **never sends**. A human opens Gmail, reviews the draft, and sends. This is the
skill's home base and where the done-bar lives: sorted inbox + stack of ready drafts.

What Tier 2 deliberately does **not** do without confirmation, even though it "could" draft it:
draft replies to **new recipients**, anything **legal/financial**, or anything flagged by the
security-reviewer — those get drafted *and* labeled `Needs-Human`, never quietly queued as if
routine.

### Tier 3 — Auto-send a whitelist (opt-in, transport required)
Only available when **both** are true:
1. The user has wired a transport (`transports.md`: SMTP, Resend/SendGrid, or n8n send).
2. The user has explicitly enabled **specific categories** in `email-profile.md`.

Even then, auto-send is allowed **only** for low-stakes, high-confidence, reversible-in-spirit
categories, e.g.:
- Receipt / order acknowledgements ("we got your message, ticket #123").
- Routine FAQ answers that exactly match an approved macro at high confidence.
- Internal status pings to known internal addresses.
- Calendar/meeting confirmations to an existing, known recipient.

Everything outside the named whitelist stays Tier 2 (draft-only). The auto-send confidence
threshold should be high (e.g. macro match ≥ the configured bar AND no escalation flag); below
it, draft and route to a human.

---

## Actions that ALWAYS require explicit human confirmation (no tier overrides this)

Regardless of tier — including Tier 3 — Claude must stop and get a human yes before:

- **Anything sent externally** that isn't on the enabled auto-send whitelist.
- **Anything irreversible** — sending, deleting a thread, deleting a label with content,
  emptying a folder.
- **Anything to a new recipient** — an email address not seen in this account's history /
  contacts / CRM. New recipients are a classic exfiltration and BEC vector.
- **Anything touching money** — invoices, payment details, refunds, wire instructions,
  changing bank/payment details, gift cards, discounts beyond policy.
- **Anything legal** — contracts, disputes, cancellations with penalties, anything with
  legal-sounding language, NDAs, threats of action.
- **Anything with PII / secrets** — sending SSNs, card numbers, passwords, API keys, health
  data, or attaching documents that contain them. (And never *forward* these at all — see
  `GUARDRAILS.md`.)
- **Anything the security-reviewer flagged** — phishing, spoofing, impersonation, suspicious
  requests. These are flagged and stopped, never auto-handled.

When in doubt, **draft + label `Needs-Human` + summarize why**, and let the person decide.

---

## Per-category configuration

Autonomy is not one global dial — it is **per category**, written in `email-profile.md`. A
sensible support-inbox starter:

```yaml
# email-profile.md  (excerpt)
default_tier: 2
auto_send:
  enabled: false          # flips to true only with a wired transport
  transport: null          # smtp | resend | sendgrid | n8n
  whitelist:
    receipt_ack:    { tier: 3, confidence_min: 0.95 }
    faq_macro:      { tier: 3, confidence_min: 0.90, must_match_macro: true }
    meeting_confirm:{ tier: 3, known_recipient_only: true }
  # everything not listed = tier 2 (draft only)
never_auto:               # hard tier-2 cap even if listed above by mistake
  - money
  - legal
  - pii
  - new_recipient
  - flagged_by_security
vips:                     # always escalate, never auto-handle
  - boss@company.com
  - "*@biginvestor.vc"
quiet_hours: "20:00-08:00 Europe/Berlin"   # no auto-send outside these
```

Rules of precedence: `never_auto` and a security flag **beat** any whitelist entry. `vips`
beat everything — VIP mail is always routed to a human. `quiet_hours` suppresses auto-send
(drafts still get written, just not sent) so the inbox doesn't fire emails at 3am.

---

## Climbing the ladder safely

1. Run a few days at **Tier 2** and let the user review the drafts. Track agreement: how often
   did they send the draft unchanged vs. rewrite it? High agreement on a category is the
   signal it's safe to promote.
2. Promote **one category at a time** to Tier 3, lowest-stakes first (receipts before FAQ).
3. Keep an **audit log** (`audit-log.md` or Supabase) of every auto-sent message so a human can
   spot-check and roll the category back instantly if it misfires.
4. Any single bad auto-send → drop that category back to Tier 2 and review before re-enabling.
