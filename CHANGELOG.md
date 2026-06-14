# Changelog

## 0.4.0 — 2026-06-14
- social-media-manager: add account-creation.md — a real-world, browser-assisted account-creation
  playbook (Claude drives, user solves CAPTCHA/phone; verification codes via the IMAP gmail tool;
  per-platform reality for Mastodon/X/Instagram/Reddit/Lemmy/TikTok/Facebook/YouTube; file-upload
  limits; posting-method + unattended-scheduling summary). Referenced from SKILL.md.

## 0.3.2 — 2026-06-14
- social-media-manager: add copy-rules.md (name real platforms not vague "and beyond"; no bare
  lists — lead-in sentence required; lead with what the product does, balanced messaging not one
  single angle; tone). Referenced from SKILL.md; brand.md owns per-product message order.

## 0.3.1 — 2026-06-14
- email-manager/transports.md: document full send + read/summarize via a Gmail app password
  (SMTP send + IMAP read), the reliable path when the Gmail MCP can't send or lacks scopes.

## 0.3.0 — 2026-06-14
- Add 3 operational skills: agency-automations (the running delivery layer for build-business —
  speed-to-lead webhooks, reactivation, reviews/referrals, messaging/CRM/booking/Google-Business
  integrations, TCPA/CAN-SPAM/GDPR compliance enforced), social-media-manager (ads + Reddit/
  subreddit posting + multi-platform scheduling/engagement, autonomy tiers + approval gate),
  email-manager (Gmail-MCP draft-first inbox: triage/draft/summarize/support, send gate).
- Routed as composable operational skills in ROUTING.md; README updated.

## 0.2.0 — 2026-06-14
- Add 6 new type sub-skills: game-dev, llm-app, hardware-embedded, creative-media, simulation,
  ecommerce-store. Routed in ROUTING.md, file-policy nudges added. 22 type sub-skills total.

## 0.1.0 — 2026-06-14
- Initial project-kit.
- `new-project` orchestrator skill: grill → Definition of Ready → business branch → routing →
  environment readiness → adaptive file/memory policy → project sub-agent generation →
  scaffold + fill → optional repo → handoff. Self-contained (templates, policies, scaffold.sh).
- 16 type sub-skills + generic fallback: build-business, website, saas, api-backend, data-ml,
  quant-strategy, cli-tool, desktop-app, mobile-app, browser-extension, bot-automation,
  ai-agent-mcp, oss-library, game-mod, research-decision, content-writing, generic-project.
- `build-business` ultraskill: full 7-day system (7 prompts, 4-criteria market rubric, 3
  service pillars, paid-ads loop, sales trainer) + merged founder/startup frameworks; sources
  credited; marketing claims flagged unverified.
- `install.sh` (symlink/copy, CLAUDE.md trigger entry, uninstall), `bin/project-kit` CLI,
  reusable agent templates, docs (ARCHITECTURE, EXTENDING, CONTRIBUTING).
