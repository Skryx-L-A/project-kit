# Mode — Triage

Read the inbox, decide what matters, label it, surface the rest as a digest. Uses the Gmail
MCP label tools (read/search/label only — no send).

## Steps
1. **Fetch** unread/recent via `search_threads` (e.g. `is:unread newer_than:2d`).
2. **Classify** each thread → a taxonomy label (create once via `create_label`):
   `P1-urgent`, `P2-reply-needed`, `P3-fyi`, `Receipts`, `Newsletters`, `Calendar`,
   `Support`, `Sales/Lead`, `Vendor`, `Spam-suspect`, `Phishing-suspect`.
3. **Priority score** from: sender importance (known contact / VIP list), explicit deadline,
   question directed at the user, money/legal/PII, thread age.
4. **Spam/phishing detection** — flag mismatched display-name vs address, urgent money/
   credential asks, lookalike domains, unexpected attachments/links. Label `Phishing-suspect`,
   never act on the request, surface to the user.
5. **Auto-archive** safe noise (receipts already filed, newsletters) per the user's config;
   never archive anything `P1`/`P2`/`Support`/money-legal.
6. **Digest** — produce a daily digest: counts per label, the P1/P2 list with one-line
   summaries + "needs a reply", and anything flagged.

## Output
Applied labels + a digest message (not sent — shown to the user / saved as a draft-note).

## Config
VIP senders, the label taxonomy, auto-archive whitelist, digest cadence.
