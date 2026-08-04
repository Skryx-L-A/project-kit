# Runtime — Reviews & Referrals

Turn happy customers into public reviews and warm referrals, compliantly.

## Flow
1. **Request** — after a purchase/visit (trigger from CRM event or a list), send SMS+email:
   thank-you + a raffle/incentive for *honest feedback* + "rate 1–5".
2. **Rating capture** — collect the 1–5 (reply keyword or a hosted micro-form).
3. **Routing**
   - **4–5** → send the Google review deep-link (`https://search.google.com/local/writereview?placeid=<PLACE_ID>`).
   - **1–3** → send a **private feedback form** for service recovery (NOT Google), notify the owner.
   - **Never gate the public Google ask on the rating** — Google bans review-gating. Everyone
     may reach Google; low ratings *additionally* get private recovery. (See `../COMPLIANCE.md`.)
4. **Auto-response** — when a new review posts (poll GBP API), draft+post an owner reply
   (see `../integrations/google-business.md`). Thank reviewer, then trigger the referral ask.
5. **Referral** — after a public review, send a shareable referral link
   (`/r/<contact_id>`); each friend who signs up adds raffle entries. Track in `state`.

## State (store these)
- `reviews(contact_id, rating, channel, requested_at, posted_at, gbp_review_id, responded)`
- `referrals(contact_id, ref_code, clicks, signups, raffle_entries)`

## Sub-agent: review-automation
Owns send → capture → route → GBP poll/respond → referral. Enforces the no-gating rule.

## Done-bar
A 4–5 path reaches Google, a 1–3 path reaches the private form + owner alert, a posted review
gets an auto-reply, and a referral signup increments raffle entries — verified end to end.
