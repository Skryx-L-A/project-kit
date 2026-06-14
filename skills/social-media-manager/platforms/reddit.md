# Platform — Reddit (deep)

Reddit punishes marketers and rewards members. Treat every subreddit as its own country with
its own laws. The fastest way to fail is to post like an advertiser.

## Access
- **PRAW** (Python Reddit API Wrapper): create a Reddit app (script/web) → `client_id`,
  `client_secret`, `user_agent`, plus the account's OAuth (username/password or refresh token).
  Keys in `.env`. PRAW handles submit, comment, read rules, flair.
- **Browser automation** (claude-in-chrome / playwright) — fallback when API is blocked or for
  flows PRAW can't do; fragile, human-gated.

## Rules-first posting (the reddit-poster sub-agent)
1. **Read the subreddit rules** (`subreddit.rules`) + sidebar + pinned posts BEFORE drafting.
   Many ban links, self-promo, or require a format/flair. Obey them literally.
2. **Check eligibility** — minimum karma + account-age gates; some subs auto-remove new/low
   accounts. If the account doesn't qualify, say so; don't try to evade.
3. **Flair** — set the required post flair; wrong/no flair = auto-removed.
4. **Format** — match the sub's norm (text post vs link, title conventions, no clickbait where
   banned).
5. **Self-promo ratio** — hold the ~**90/10 rule**: at least 9 genuinely useful, non-promo
   contributions for every 1 that promotes you. Reddit's own self-promotion guidance.
6. **Timing** — post when the sub is active (varies by sub/timezone); space submissions.
7. **Engage** — reply to comments as a real person; don't drop and ghost.

## Shadowban / spam-filter avoidance
- No identical cross-posting blasts, no link-only history, no URL shorteners, no vote rings.
- Vary content; build comment karma first; don't post the same link to many subs fast.
- If posts vanish only for logged-out viewers → shadowbanned/filtered; stop and reassess.

## Hard nos (also in GUARDRAILS)
No vote manipulation, no sock-puppets/astroturfing, no ban evasion, no mass-DM. These get the
account (and brand) nuked and are off the table.

## Done-bar
A draft passes the sub's rules + flair + eligibility checks, holds the self-promo ratio, and
only posts after the approval gate.
