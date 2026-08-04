# runtime/reactivation.md — bulk SMS + email database reactivation

**Goal:** wake a client's **dormant** contacts (old leads / past customers) with a throttled,
multi-channel campaign, handle replies conversationally into a **booking**, and honor opt-outs —
without torching the sending number or domain reputation, and without sending to anyone who never
consented. Typical response rate is 5-15%; it is one of the highest-ROI motions, which is exactly
why it attracts the most compliance risk. **Consent provenance is the gate** — see COMPLIANCE.md.

Copy comes from `build-business/pillars/reactivation.md`. Sending mechanics from
`integrations/messaging.md`. Storage from `integrations/crm-and-booking.md`.

---

## 0. The consent gate (do this before anything else — it can stop the whole campaign)
- For the list being reactivated, **prove opt-in**: when/how did each contact agree to be
  contacted by SMS/email? An old "we have their number from a purchase" is **not** SMS marketing
  consent under TCPA. If the list has no documented consent, **refuse the SMS blast** — offer an
  email-only re-permission ("are you still interested?") path or a compliant alternative.
- Record the consent basis per contact in the store. compliance-reviewer **fails the build** if a
  reactivation SMS targets contacts with no consent record.
- A2P 10DLC: the sending number must be brand+campaign registered (since Feb 2025 carriers block
  100% of unregistered traffic). The registered campaign use-case must match (marketing/low-volume
  mixed). No registration → nothing sends. See COMPLIANCE.md.

---

## 1. Contact import from the CRM — built by `webhook-builder` / a one-off import flow
- **Source options:** CRM export (CSV), CRM API, or a UI-only CRM scraped via
  claude-in-chrome/playwright as a last resort.
- **Normalise** each row to `{ contact_id, name, phone(E.164), email, last_activity_at,
  last_purchase_at, tags, consent_basis, consent_at, opt_out (bool), source }`. Drop rows with no
  reachable channel; flag rows with no consent_basis for the gate above.
- **Validate** phones (E.164, line-type lookup to skip landlines for SMS) and emails (syntax +
  optionally a verification API to cut bounces — protects domain reputation).
- **De-dupe** on phone/email; merge tags. Land into `contacts` (Supabase table or n8n Data Table).
- **Scrub against the suppression list** (global opt-outs, prior STOPs, hard bounces) on import —
  never re-import a number someone already opted out of.

## 2. Segment the dormant leads
Define "dormant" *with the client* (don't guess) and write the rule down:
- e.g. `last_activity_at` older than 90 days (cold lead) vs 12-18 months (lapsed customer) — and
  message each segment differently (a stale quote vs a long-gone buyer get different angles).
- Exclude: active/in-pipeline contacts, current opportunities, anyone messaged in the last N days,
  opted-out, invalid channel, and (for SMS) no-consent rows.
- Tag segments (`reactivation_cold`, `reactivation_lapsed`) so reporting and follow-up branch on them.
- Cap the campaign size to what the sending reputation + 10DLC throughput can absorb (see §3).

## 3. Send + throttling (protect reputation, stay under limits)
**SMS (Twilio):**
- Throttle to your number's permitted **MPS** and the 10DLC campaign's daily throughput; spread the
  blast over hours/days, not a single burst (a sudden spike looks like spam and trips carrier
  filtering). Use a queue with a steady drip (e.g. messages/min) rather than a fan-out.
- **Quiet hours:** only send 8am-9pm in each contact's local timezone; queue the rest.
- Personalise (name, last interaction) but keep every message carrying **STOP/HELP**.
- One number can only do so much volume — for large lists use a messaging service / number pool,
  but ensure all numbers are under the same registered campaign and don't "snowshoe" (spreading to
  evade filters is a violation).

**Email (SendGrid/Resend):**
- **Warm up / ramp**: for a large dormant list, increase volume gradually over several days rather
  than blasting day one — dormant addresses bounce and complain more, which can tank the domain.
- Send from an **authenticated domain** (SPF/DKIM/DMARC aligned) — see messaging.md. Consider a
  subdomain dedicated to reactivation so a reputation hit doesn't touch transactional mail.
- Every email needs a working **unsubscribe link + the business's physical postal address**
  (CAN-SPAM). Honor unsubscribes within 10 business days (do it instantly via webhook).
- Watch the bounce/complaint webhook in real time; **pause the campaign automatically** if
  complaint rate or bounce rate crosses a threshold (e.g. >0.1% complaints) — don't ride a domain
  into a blocklist.

**Sequencing across channels:** typical pattern is email first, then SMS to non-openers/non-
responders after a delay, each step throttled and opt-out-aware. Cap total touches (default 3-4
over the campaign); stop on reply, booking, or opt-out.

## 4. Reply handling → booking — `sequence-engine`
- Same intent-detection + state machine spine as speed-to-lead (`runtime/speed-to-lead.md` §3),
  scoped to reactivation: an inbound reply → `CLASSIFY` → `BOOKING` on positive intent, FAQ answer
  on a question, `HUMAN_HANDOFF` on anything sensitive.
- A "yes / still interested" reply gets the booking link or proposed slots; a booking flips the
  contact to `reactivated` and stops further campaign touches to them.
- Keep conversation state per contact; never run the broadcast steps and a live conversation
  against the same person simultaneously (a reply pauses their broadcast cadence).

## 5. Opt-out handling (mandatory, both channels)
- **SMS:** STOP/UNSUBSCRIBE/CANCEL/END/QUIT/STOPALL → carrier auto-suppresses *and* you must record
  it: set `opt_out=true`, add to the global suppression list, stop all flows for that contact.
  HELP → return the HELP text. Never message an opted-out contact again on any campaign.
- **Email:** unsubscribe click → suppress that address (and ideally the linked contact across
  channels) immediately; respect it forever. List-Unsubscribe header set on every send.
- **Cross-channel suppression:** an opt-out on one channel should suppress marketing on the other
  for the same person where the contact is linked — store opt-outs at the contact level, not just
  the message level.
- The suppression list is the single source of truth and is checked before **every** send.

## 6. Done-bar (verify LIVE — on a tiny consented test segment, not the real list)
- Import → segment → a throttled test send goes out at the configured drip rate (not a burst).
- A test contact replying "yes" reaches a booking; the contact is marked `reactivated` and removed
  from further sends.
- STOP / unsubscribe immediately suppresses across the campaign and is recorded; a re-run does not
  message them.
- Bounce/complaint webhook is wired and the auto-pause threshold fires in a forced test.
- compliance-reviewer passes: consent on file for every targeted contact, STOP on every SMS,
  unsubscribe + physical address on every email, quiet hours respected, 10DLC registered.
