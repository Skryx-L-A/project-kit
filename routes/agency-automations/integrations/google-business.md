# Integrations — Google Business Profile (reviews)

Used by the reviews & referrals runtime to **fetch new reviews** and **post owner replies**.

## Setup
- Google Cloud project → enable the **Business Profile APIs** (My Business Account Management
  + Business Profile Performance + the Reviews endpoint via the v4 legacy API, access-gated).
- **OAuth** (the business owner consents) → store refresh token. Scope:
  `https://www.googleapis.com/auth/business.manage`.
- Identify the `accounts/<id>/locations/<id>` for the business.

## Operations
- **List/poll reviews**: pull reviews for the location on a schedule; diff against
  `state.reviews.gbp_review_id` to find new ones.
- **Reply**: `PUT accounts/*/locations/*/reviews/*/reply` with the drafted owner response.
  Keep replies specific, grateful, and policy-safe; no incentives mentioned in the reply.

## Notes / gotchas
- Review API access requires Google approval; until granted, fall back to a notification +
  manual reply, or browser automation as a last resort (fragile; prefer the API).
- Never fabricate reviews or reply as the customer. Replies are the owner's voice.

## Secrets
`GOOGLE_OAUTH_CLIENT_ID`, `GOOGLE_OAUTH_CLIENT_SECRET`, `GBP_REFRESH_TOKEN`, location id.
