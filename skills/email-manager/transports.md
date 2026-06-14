# Transports — how sending gets wired (beyond drafts)

The Gmail MCP here **drafts but does not send**. When the user wants to go past draft-only,
wire ONE transport and put the autonomy gate (`AUTONOMY.md`) in front of it.

## Options
1. **Human send (default, safest)** — Claude saves the draft; the user reviews and clicks send
   in Gmail. Zero new credentials, full control. Recommended until trust is established.
2. **SMTP** — send via the user's mail server / Gmail SMTP (app password). Wire a tiny send
   step (script or n8n) that takes an approved draft id → sends. App password in `.env`.
3. **Send API (Resend / SendGrid)** — for higher volume / transactional or marketing email
   (also gets CAN-SPAM furniture). API key in `.env`. Good for the ops/marketing side.
4. **n8n** — an approval-gated workflow: draft lands in a queue → user approves → n8n sends via
   Gmail/SMTP/API node. Adds logging + retry.

## Full send + read via a Gmail app password (when the MCP can't send/read)
The Gmail MCP can't send, and may also lack read scopes. The most reliable way to give Claude
**send + read + summarize** on a personal Gmail is a **Gmail app password** + a tiny stdlib
tool (no Google Cloud project, no extra deps):
- **Send** via SMTP (`smtp.gmail.com:465`, SSL).
- **Read / summarize** via IMAP (`imap.gmail.com:993`, SSL; Gmail search via `X-GM-RAW`).

Setup the user does once: enable **2-Step Verification** → create an **App password** → put
`GMAIL_ADDRESS` + `GMAIL_APP_PASSWORD` in `.env` (gitignored). Then a `gmail.py` with
`send`/`read` subcommands does the rest; gate `send` behind an explicit `--confirm`. (This skill
ships a reference implementation pattern; the agent generates it into the project.) Reading is
safe/auto; sending stays behind the autonomy gate.

## Rule
No transport sends anything that didn't pass the configured autonomy gate. Auto-send categories
must be an explicit whitelist. Log every send. On any doubt (new recipient, money, legal,
external), fall back to human send. **Never commit the app password / `.env`.**

## Secrets (`.env`, gitignored)
`SMTP_HOST/USER/PASS`, or `RESEND_API_KEY` / `SENDGRID_API_KEY`, `MAIL_FROM`.
