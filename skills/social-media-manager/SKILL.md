---
name: social-media-manager
description: Autonomously manages social media accounts — creates ads, writes and schedules posts, posts to subreddits/Reddit, and engages/replies — across X, Reddit, LinkedIn, Instagram, Facebook, and TikTok, for a business or brand. A project-kit skill. Triggers when the user wants to run or manage social media, make ads or ad creatives, post to Reddit/subreddits, schedule content, grow a channel, or handle community engagement. Composes creative-media for visuals and build-business for offers. Publishing and ad spend always pass a configurable approval gate.
---

# social-media-manager — run the accounts, make the ads, post to Reddit

Turn "run my socials" into a **standing operation**: Claude plans content, writes copy,
generates ad creatives, posts (including to subreddits), schedules, and engages — **with
every public or money-spending action behind a configurable approval gate** (`AUTONOMY.md`).
Emphasis: **creating ads** and **posting to communities (Reddit/subreddits)**.

> **No social MCP exists in this environment.** X/Reddit/LinkedIn/TikTok have no MCP here, so
> posting runs through (a) the platform's **own API** with app credentials the user provides,
> (b) **n8n** nodes for scheduling/posting, or (c) **browser automation** (claude-in-chrome /
> playwright) as a fallback for UI-only flows. Creatives come from the **higgsfield** skills.
> Pick per platform in `platforms/*` and wire what the user authorizes.

---

## What it is
A multi-platform manager. Use the parts the goal needs; they compose.
- **Platforms** (`platforms/*`) — per-network posting, scheduling, ToS: `reddit.md` (deep),
  `x-twitter.md`, `linkedin.md`, `instagram-facebook.md`, `tiktok.md`.
- **Ads** (`ads/*`) — `ad-creation.md` (hooks, copy, creative gen, A/B), `ad-platforms.md`
  (Meta/Google/Reddit/TikTok campaign setup, targeting, tracking, launch).
- **Playbooks** (`playbooks/*`) — `content-engine.md` (plan→create→schedule→publish→engage→
  measure), `engagement.md` (replies/DMs/community).
- **`copy-rules.md`** — how every post/ad must be written (name real platforms, no bare lists,
  lead with what it does, balanced messaging, tone). Read it before drafting any copy.
- **`AUTONOMY.md`** — how far Claude may act per action class. **`GUARDRAILS.md`** — hard rules.

## Mandatory grill-questions (fold into the Definition of Ready)
- **Goal** — awareness, leads, sales, community, traffic? Sets platforms + metrics.
- **Platforms** — which accounts, and what's the priority order?
- **Brand voice** — tone, do/don'ts, banned topics, emoji use (default none — ask), examples.
- **Accounts & access** — for each platform: API app credentials/OAuth, or browser-session
  access, or "drafts only"? What can Claude actually reach? (→ environment readiness)
- **Autonomy level** — per action class (draft / schedule-to-queue / publish / spend). Default
  conservative; raise deliberately. (→ `AUTONOMY.md`)
- **Cadence + volume** — posts/week per platform; ad budget + ceiling.
- **Reddit specifics** — which subreddits, are you an established account there, what's the
  self-promo ratio you'll hold? (→ `platforms/reddit.md`)
- **Compliance context** — sponsored/#ad disclosure needs, regulated industry?, regions.

## Autonomy tiers (summary — full in `AUTONOMY.md`)
1. **Draft-only** — write copy + generate creatives, nothing leaves.
2. **Schedule-to-queue** — schedule into a review queue / native scheduler; human approves.
3. **Publish (gated)** — auto-publish a whitelisted, low-risk class (e.g. a pre-approved
   content calendar) with logging.
4. **Spend (always gated)** — launching/raising ad budget ALWAYS needs explicit confirmation.
Per platform + action class. Public/irreversible/spend actions never bypass the gate.

## Project sub-agents to generate (into `.claude/agents/`)
- **content-strategist** *(delegate-by-default)* — turns goals into a content plan/calendar.
- **copywriter** *(delegate-by-default)* — platform-native copy (hooks, AIDA/PAS), per voice.
- **ad-creative-generator** *(delegate-by-default)* — drives the higgsfield skills for image/
  video creatives + variants; scores with the virality predictor.
- **reddit-poster** — rules-aware posting to subreddits: checks subreddit rules/flair, holds
  the self-promo ratio, avoids karma/age gates and shadowban patterns.
- **scheduler** — queues/schedules across platforms; spaces posts; respects best-time windows.
- **engagement-responder** — drafts replies to comments/DMs; escalates sensitive ones.
- **brand-safety-reviewer** *(adversarial — before any publish)* — fails the action if a post
  risks ToS (automation/spam limits, fake engagement), missing #ad disclosure, Reddit
  self-promo/astroturf rules, brand-unsafe content, or skips the approval gate.

## Tools / CLIs / MCP / skills to chain
Check in environment-readiness; offer install, never auto-install or invent credentials.
- **higgsfield skills** — `higgsfield-generate` (image/video), `higgsfield-soul-id` (consistent
  faces), `higgsfield-product-photoshoot`, `higgsfield-marketplace-cards`; **higgsfield MCP**
  `generate_image` / `generate_video`, **`virality_predictor`** (score video before posting),
  marketing studio. Primary creative engine.
- **creative-media sub-skill** — compose it for the full produce→publish media pipeline.
- **build-business sub-skill** — source of the offer/ICP/angles for ad copy.
- **n8n MCP** — scheduling + cross-posting automation; approval-gated publish workflows.
- **claude-in-chrome / playwright** — browser automation for platforms without API access
  (e.g. Reddit posting, LinkedIn) — a fallback, ToS-aware, human-gated.
- **magic** — generate any companion UI (a small dashboard/approval queue) if wanted.
- **design-harvest** + **web-aeo** — reference design + discoverability for linked content.
- **Reddit**: PRAW (Python Reddit API Wrapper) with a Reddit app (client id/secret + OAuth).
- Platform APIs (X, Meta Graph, LinkedIn, TikTok) — user provides app creds; keys in `.env`.

## File / asset nudges (on top of the base project set)
- `.env.example` — every platform's app id/secret/token named (real `.env` gitignored).
- `brand/voice.md` — tone, do/don'ts, banned topics, examples; the single source of voice.
- `calendar/` — the content calendar (planned → drafted → scheduled → published).
- `ads/` — ad sets (copy + creative refs + targeting + budget) per campaign.
- `assets/` — generated creatives (or references to where they live).
- `queue/` — the approval queue: drafts awaiting human go before publish/spend.
- `metrics.md` — what's tracked per platform + a weekly review note.

## Stack defaults & done-bar
**Default:** higgsfield for creatives + virality scoring; n8n for scheduling/cross-post;
PRAW/browser for Reddit; platform APIs where the user grants them; a `queue/` approval gate in
front of every publish/spend. Reddit posting is **rules-first** (read each subreddit's rules).

**Done-bar (verified, not reasoned):** a configured account can produce a **scheduled post**
and a complete **ad set** through the approval gate; **Reddit posts respect each subreddit's
rules + the self-promo ratio**; the virality predictor scored any video before it queued; and
**nothing published or spent without passing the autonomy gate**.

## Guardrails (standing footer — enforced; full in `GUARDRAILS.md`)
- **Nothing public or money-spending without the approval gate.** Publishing and ad budget are
  gated by default.
- **Platform ToS**: respect automation/rate limits; **no fake engagement, no bot networks, no
  vote manipulation, no mass-DM spam, no astroturfing**.
- **Reddit**: follow each subreddit's rules + the ~90/10 self-promo guideline; participate as a
  real member, not a spammer. Never manipulate votes or sock-puppet.
- **Disclosure**: FTC `#ad`/sponsorship disclosure where required; honesty in claims.
- **No emojis** by default unless the brand voice explicitly calls for them (ask first).
- **Commits under the user's own name only (Skryx-L-A); never add Claude as co-author.**
- **Never commit account secrets/tokens** — `.env` only (gitignored).
