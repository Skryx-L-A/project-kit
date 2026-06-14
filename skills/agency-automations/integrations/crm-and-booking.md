# Integrations — CRM + Booking

## Contact + conversation store
Pick by engine:
- **n8n Data Tables** — lightest; fine for a single client's lists + state.
- **Supabase (Postgres)** — recommended default: tables `contacts`, `conversations`
  (state machine cursor), `opt_outs`, `reviews`, `referrals`, `message_log`. Row-level
  security; service key server-side only.
- **Client's existing CRM** (GoHighLevel-style) — read/write via its API; only add the
  missing pieces, don't rebuild.

## Conversation state
The sequence engine persists, per contact: current state, next-run timestamp, attempt count,
last inbound, suppression flag. Must be **idempotent** on re-delivered webhook events.

## Booking
- **Cal.com** (default, API + hosted pages) or **Google Calendar** (events API) or the
  client's CRM calendar.
- On a "yes" reply, send the booking link or hold a slot; on booking confirmation, advance the
  state machine to "booked" and stop follow-ups.

## Secrets
`SUPABASE_URL`, `SUPABASE_SERVICE_KEY`, `CALCOM_API_KEY` / Google OAuth client, CRM API key.
