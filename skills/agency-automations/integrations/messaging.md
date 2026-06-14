# Integrations — Messaging (SMS + Email)

## SMS — Twilio (default)
- **Number**: buy a local/toll-free number; **A2P 10DLC register** the brand + campaign
  (US) — unregistered traffic is filtered/blocked. Toll-free needs verification too.
- **Send**: `POST /Messages` (Account SID + Auth Token). Use a Messaging Service for
  number pooling + sticky sender.
- **Inbound + delivery**: configure the number's webhook → your runtime (reply handling,
  STOP/HELP). Subscribe to status callbacks for delivered/undelivered/failed.
- **Compliance furniture**: first message identifies the business; every message path supports
  **STOP** (opt-out) and **HELP**; honor quiet hours (no marketing 9pm–8am local).
- **Throttle**: respect 10DLC throughput tier; queue bulk reactivation, don't burst.

## Email — Resend or SendGrid
- **Domain auth**: SPF + DKIM + DMARC on the sending domain. Without it → spam folder.
- **Send**: REST API with an API key (gitignored). Use a dedicated subdomain (e.g. `mail.`).
- **Compliance furniture**: every email has a working **unsubscribe** link + the business's
  **physical postal address** (CAN-SPAM); honor unsubscribe instantly.
- **Bounce/complaint**: handle webhook events → suppress hard bounces + spam complaints.

## Secrets (`.env`, gitignored; document in `.env.example`)
`TWILIO_SID`, `TWILIO_TOKEN`, `TWILIO_FROM`/messaging service SID, `RESEND_API_KEY` (or
`SENDGRID_API_KEY`), `MAIL_FROM`, `MAIL_DOMAIN`.

## Readiness gate
If the number isn't 10DLC-registered or the domain isn't authenticated, **nothing sends** —
surface as a hard blocker and walk the user through registration; don't fake it.
