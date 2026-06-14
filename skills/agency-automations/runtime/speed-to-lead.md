# runtime/speed-to-lead.md — instant response + conversational follow-up state machine

**Goal:** a new lead is auto-replied **inside the 5-minute window** (responding within 5 min
makes a lead ~21x more likely to qualify than at 30 min, ~400% lift in conversion vs an hour
later), then walked through a short conversational follow-up that ends in a **booked
appointment** — with hard retry/stop limits and TCPA-safe sends throughout.

This file is the runtime spec. Copy/wording comes from `build-business/pillars/speed-to-lead.md`
(the 5-message nurture). Channels and compliance furniture come from `integrations/messaging.md`
and `COMPLIANCE.md`.

---

## 1. Triggers (inbound wiring) — built by `webhook-builder`

### A. Web form
- **Preferred:** a real **webhook** the form POSTs to (n8n Webhook node URL, or an api-backend
  `POST /webhooks/lead` route). Form fields → normalise to a canonical lead object
  `{ source, name, phone (E.164), email, message, consent_captured_at, page_url, created_at }`.
- **Verify the source.** Sign the request (shared secret / HMAC header) so a public webhook URL
  can't be spammed with fake leads. Reject unsigned or malformed payloads.
- If the form is a third-party embed with no webhook, use its native integration or, as a last
  resort, drive the dashboard with `claude-in-chrome`/playwright to export — but a webhook is the
  done-bar.
- **Consent gate:** the form MUST have its own consent checkbox/text capturing express consent to
  be contacted by SMS/email; store `consent_captured_at`. No consent → do not enter the SMS flow
  (email-only transactional reply at most). See COMPLIANCE.md "one-to-one consent".

### B. Facebook / Instagram Lead Ads
- Use the **Facebook Lead Ads Trigger** (n8n) or a Meta webhook subscription on the api-backend.
- Subscribe the **Page** to the `leadgen` field of your **App**; on the `leadgen` webhook event
  you receive a `leadgen_id`, then call the Graph API (`GET /{leadgen_id}` with a page access
  token) to fetch the full field_data. Permissions: `leads_retrieval`, `pages_show_list`,
  `pages_manage_metadata`, and a Page access token; the App must pass App Review for live leads.
- **Known gotcha (wire around it):** Facebook allows **one webhook URL per App**. Switching the
  same App between a test and a production URL **overwrites** the registered webhook. Use a
  **separate App** (or a stable gateway URL that branches internally) for test vs prod so you
  don't silently kill the client's live lead flow. Document which App owns the prod webhook.
- Verify the `X-Hub-Signature-256` header against the App secret on every delivery.
- Lead Ads ToS: you may only use the data to contact that lead, and you must honor your privacy
  policy — see COMPLIANCE.md "Facebook Lead Ads ToS".

### Both sources converge on the same normalised lead → enqueue into the state machine.

---

## 2. Instant reply (the 5-minute window) — first, separately from the sequence

The **very first** action on lead-receipt, before any branching:
1. **De-dupe** on phone+email within a short window (re-delivered webhooks, double form submits).
   Idempotency key = `source:lead_id` or `phone:hash(message):minute`. If seen → drop.
2. **Check suppression**: is this contact opted-out / on the STOP list? If yes → no SMS (email
   transactional only if consented). Always check before sending.
3. **Send the instant acknowledgement** on the primary channel (SMS first — 98% open rate):
   - Personalised, references what they asked about, includes the **booking link**, and carries
     the **STOP/HELP opt-out furniture** (required on the first and ongoing marketing messages).
   - Example shape (final copy from build-business): `"Hi {first}, thanks for reaching out to
     {biz} about {service}. Want the next available time? Book here: {cal_link}. Reply STOP to
     opt out."`
4. **Notify the business** internally (email/Slack/SMS to the owner) with the lead details, so a
   human can jump in if the lead replies with something the machine shouldn't handle.
5. **Log** the send + the provider message SID; the delivery webhook (see messaging.md) flips the
   message to `delivered`/`failed`. The done-bar checks *delivered within 5 min*, not just queued.

Measure window compliance: store `lead.created_at` and `first_reply.delivered_at`; alert if the
delta exceeds the SLA (target < 60s; hard ceiling 5 min).

---

## 3. The follow-up STATE MACHINE — built by `sequence-engine`

Persist one **conversation row** per lead (Supabase table or n8n Data Table):
`{ lead_id, state, attempt, next_action_at, channel, last_inbound_at, booked, stopped, reason }`.
A scheduler (n8n schedule trigger every minute, or an api-backend worker) wakes rows whose
`next_action_at <= now()` and advances them. **Idempotent**: advancing must be safe to re-run.

### States

| State | Entered when | Action on enter | On inbound reply | On timer |
|---|---|---|---|---|
| `NEW` | lead received | (instant reply already sent in §2) → set `state=AWAITING_REPLY_1`, `next_action_at=+1h` | → `CLASSIFY` | → `FOLLOWUP_1` |
| `AWAITING_REPLY_1` | after instant reply | none | → `CLASSIFY` | when timer hits → `FOLLOWUP_1` |
| `FOLLOWUP_1` | no reply after step 1 | send nurture msg 2 (value/social proof + booking link + STOP); `attempt+=1`; `next_action_at=+1 business day` | → `CLASSIFY` | → `FOLLOWUP_2` |
| `FOLLOWUP_2` | no reply | send nurture msg 3 (objection/FAQ + link + STOP); `next_action_at=+2 business days` | → `CLASSIFY` | → `FOLLOWUP_3` |
| `FOLLOWUP_3` | no reply | send nurture msg 4 (last value angle); `next_action_at=+3 business days` | → `CLASSIFY` | → `BREAKUP` |
| `BREAKUP` | no reply after full sequence | send msg 5 ("should I close your file?" + link + STOP); `next_action_at=+2 days` | → `CLASSIFY` | → `CLOSED_NO_RESPONSE` |
| `CLASSIFY` | any inbound text | run intent detection (see below) → branch | — | — |
| `BOOKING` | positive/booking intent | send the booking link / propose 2-3 slots; if calendar API, create a hold; `next_action_at=+1h` to confirm | confirm → `BOOKED`; reschedule → re-propose | nudge once, then back to `CLASSIFY` |
| `BOOKED` | appointment confirmed | stop sequence; notify owner; (optional) reminder sub-flow | — | — |
| `HUMAN_HANDOFF` | complex/angry/out-of-scope reply | pause automation; alert owner; do not auto-send | owner takes over | — |
| `OPTED_OUT` | reply matches STOP | suppress contact; send one confirmation if required; **terminal** | — | — |
| `CLOSED_NO_RESPONSE` | breakup timer elapsed | mark cold; stop | re-entry only on a new lead event | — |

### Intent detection in `CLASSIFY`
- **Deterministic first:** STOP/UNSUBSCRIBE/STOPALL/CANCEL/END/QUIT → `OPTED_OUT`; HELP → send
  HELP text, stay. These are required keyword handlers (carrier + TCPA).
- **Then classify the rest** (keyword rules for a light build; `claude-api` for a smart build —
  read claude-api before choosing a model): `booking_intent` (yes/book/time/when/schedule) →
  `BOOKING`; `question` → answer from the FAQ then re-offer booking; `negative/angry/legal/price-
  complaint/"who is this"` → `HUMAN_HANDOFF`; `unclear` → one clarifying question, stay.
- Never let the classifier send into quiet hours — queue the action to the next allowed window.

### Retry / stop logic (hard limits — non-negotiable)
- **Max touches:** total outbound marketing messages per lead is capped (default 5 over the
  sequence). Past the cap with no reply → `CLOSED_NO_RESPONSE`. Never loop.
- **Stop conditions (any halts the machine immediately):** STOP/opt-out reply; `BOOKED`;
  `HUMAN_HANDOFF`; max touches reached; hard delivery failure (invalid number / repeated bounce)
  → suppress and stop.
- **Quiet hours:** no marketing SMS outside business hours / before 8am or after 9pm local; the
  timer that lands in quiet hours is pushed to the next open window.
- **Backoff on soft failures:** carrier 4xx / rate-limit → retry with exponential backoff (e.g.
  1m, 5m, 30m) up to N, then mark failed and notify; don't hammer the provider.
- **De-dupe re-deliveries:** the same webhook arriving twice must not double-send — idempotency
  key on every transition.

---

## 4. Booking
- Booking link from `integrations/crm-and-booking.md` (Cal.com link, GHL calendar, or Google
  Calendar appointment schedule). On a confirmed booking, write `booked=true`, stop the sequence,
  notify the owner, and (optionally) start a reminder sub-flow (24h + 1h before).
- If using a calendar **API**, the `BOOKING` state can hold a slot and confirm; if only a link,
  rely on the booking system's own webhook ("appointment created") to flip `BOOKED`.

## 5. Done-bar for this pillar (verify LIVE)
- Real form submit AND a real Lead-Ads test lead each get an instant reply **delivered < 5 min**.
- A test lead replying "yes" reaches `BOOKING` → a booking link/hold → `BOOKED`.
- A non-replying test lead walks the timers to `CLOSED_NO_RESPONSE` without exceeding the touch cap.
- Texting STOP at any point → `OPTED_OUT`, no further messages, suppression recorded.
- compliance-reviewer passes every template (STOP present, quiet-hours respected, consent on file).
