# COMPLIANCE — enforced, not optional

The `compliance-reviewer` sub-agent reads every template + flow and **fails the build** on any
violation below. These are blockers.

## SMS (TCPA + carrier)
- **Prior express consent** for every contact on a list — documented provenance (when/how
  opted in). No consent → do not send. Reactivating a bought/scraped list is a violation.
- **STOP** opt-out honored instantly on every number; **HELP** supported; first message
  identifies the business.
- **Quiet hours**: no marketing SMS before 8am / after 9pm in the recipient's local time.
- **A2P 10DLC** brand+campaign registration before sending (US). Unregistered = blocked.

## Email (CAN-SPAM / GDPR)
- Working **unsubscribe** + honored within 10 days (do it instantly); **physical postal
  address** in every commercial email; no deceptive subject/headers.
- For EU contacts: lawful basis / consent (GDPR); easy withdrawal.

## Google reviews
- **Never gate** the public review ask on the rating (no review-gating). Everyone can reach
  Google; low ratings additionally get private recovery.
- Incentivise **honest feedback**, never a *positive* review. No buying/faking reviews.
- Owner replies are the owner's voice; never impersonate the customer.

## Data / PII
- No real customer PII in a public repo (synthetic data in examples/tests).
- Secrets in `.env` only; rotate on exposure. Retain contact data only as long as needed;
  honor deletion requests.

## Facebook Lead Ads
- Respect the Lead Ads / Marketing API ToS; only the webhook + CRM sync patterns, no scraping
  of users.

## Reviewer checklist (must all pass before go-live)
- [ ] Every SMS template has STOP/HELP + business identity.
- [ ] Every list has documented consent provenance.
- [ ] Quiet-hours + throttle enforced; sender 10DLC-registered.
- [ ] Every email has unsubscribe + physical address.
- [ ] Review flow does NOT gate Google on rating; no positive-review incentive.
- [ ] No secrets/PII committed.
