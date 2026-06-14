# AUTONOMY — how far Claude may act (per action class)

Configure per platform AND per action class. Default conservative; raise deliberately.

| Action class | Tier 1 (default) | Tier 2 | Tier 3 |
|---|---|---|---|
| Draft copy / generate creatives | auto | auto | auto |
| Schedule into review `queue/` | auto | auto | auto |
| **Publish a post** | human approves each | auto for a pre-approved calendar (whitelist) | auto (logged) |
| Reply to comments/DMs | draft → human | auto for low-risk FAQs | auto (logged) |
| **Launch / change ad spend** | **always human-confirmed** | **always human-confirmed** | **always human-confirmed** |
| DM real people / outreach | human approves each | human approves each | gated whitelist |

## Always-gated (never bypass, any tier)
- Anything **public + irreversible** (a published post, a sent DM).
- Anything that **spends money** (ad launch/budget change).
- Posting to a **new subreddit/community** for the first time.
- Anything touching a sensitive/regulated topic or a complaint/PR risk.

## How the gate works
Drafts + scheduled items land in `queue/`; the user reviews and approves. Every auto action is
logged. When in doubt, drop a tier and ask.
