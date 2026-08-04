## 0.7.0 — 2026-08-04
- Only the three independently-invokable skills (`new-project`, `email-manager`,
  `social-media-manager`) still live under `skills/` and get registered/symlinked. The 24
  type and operational sub-skills (`agency-automations`, `ai-agent-mcp`, `api-backend`,
  `bot-automation`, `browser-extension`, `build-business`, `cli-tool`, `content-writing`,
  `creative-media`, `data-ml`, `desktop-app`, `ecommerce-store`, `game-dev`, `game-mod`,
  `generic-project`, `hardware-embedded`, `llm-app`, `mobile-app`, `oss-library`,
  `quant-strategy`, `research-decision`, `saas`, `simulation`, `website`) moved unchanged to
  a new `routes/` directory: `new-project` already read them by path
  (`KIT/skills/<name>/SKILL.md`), never through the Skill tool, so registering them cost
  ~3,400 tokens of `description` frontmatter in every session — including sessions that never
  touch project creation — for no routing benefit. `routes/<name>/SKILL.md` is the same file,
  reachable exactly as before through `new-project`'s `ROUTING.md`; `install.sh` never
  touches `routes/`, so nothing there gets symlinked. Every `skills/<name>` reference to a
  moved sub-skill was updated across `new-project`'s `SKILL.md`/`ROUTING.md`/
  `DEFINITION_OF_READY.md`, `docs/ARCHITECTURE.md`, `docs/EXTENDING.md`, `README.md`, and
  `bin/project-kit`'s `list` command (which previously only scanned `skills/` and would have
  silently stopped listing the 24 sub-skills). Added `bin/measure-skill-tokens.sh` to catch a
  future regression where a sub-skill drifts back into `skills/`.

## 0.6.0 — 2026-08-03
- Sub-agent generation and delegation guidance brought up to the current understanding of how
  a calling session, a subagent, and outward-facing actions should relate: `SUBAGENT_GENERATION.md`
  now states that "delegate-by-default" covers routing work, not trusting a report without
  checking the actual output; that a generated agent is a leaf and does not spawn further
  sub-agents; and that publishing/deploying/sending is prepared by an agent but only executed
  after the user confirms. `new-project/SKILL.md` step 6 and `ai-agent-mcp/SKILL.md` (the
  skill/subagent/MCP meta-tooling builder) point at the same rules; `email-manager/SKILL.md`'s
  domain-agent section gets the same verification clause.
- Four `release-engineer`/`deploy-runner` sub-agents (`cli-tool`, `desktop-app`, `oss-library`,
  `agency-automations`) now prepare the publish/release/deploy step but run it only after the
  user confirms, instead of publishing on their own — an outward, hard-to-reverse action
  shouldn't be a delegate's own call.
- `ai-agent-mcp`, `llm-app`: removed hardcoded, stale Claude model ids (`claude-opus-4-8`,
  `claude-sonnet-4-6`) from the "which model" grill question and stack defaults — both files
  already told the reader to read `claude-api` and never hardcode/guess model ids, so the
  hardcoded list above it was self-contradicting and would go stale again regardless. Now both
  consistently point at `claude-api` and pick by fit for the job.
- `workflows/README.md`: dropped the reference to an unverified "Workflow tool" and described
  the folder's scripts against the same rules as a generated agent (checked per stage, nothing
  published without confirmation).

## 0.5.1 — 2026-07-29
- `new-project` routing gap closed: a single document/report/presentation/CV with no research
  matrix and not book-length had no route and fell to `generic-project` unexplained. Added one
  `ROUTING.md` row + a matching note in `generic-project/SKILL.md` pointing at the global
  `document-design` (layout/genre) + `docrender` (render-check) skills — no new sub-skill, since
  `document-design` already self-triggers on these request words.
- `game-dev`, `content-writing`: updated the PPTX/DOCX mentions added in 0.5.0 — `document-design`
  now has a real PPTX/DOCX generator path (own decision-gate, not template-fill), not just
  Typst/Touying with PPTX as a fallback.

## 0.5.0 — 2026-07-29
- Wire in the new design/document tooling (built in the 2026-07-29 design-tooling research,
  `~/AI/design-research/BEFUND.md`) across the sub-skills that own a real visual or document
  surface: `slop-detect` (deterministic anti-slop lint) as a mandatory ship gate, `design-bausteine`
  (four-part build brief + fan-out) at design start, `design-critique` (two isolated passes) before
  client/public/store-facing work ships, and `document-design` + `docrender` for anything that
  produces a real PDF/deck (report, proposal, CV, pitch deck, book export).
- `website`: full build order documented (inspiration → `design-bausteine` → build → Tweaks-Bar →
  `slop-detect` gate → self-audit → `design-critique` for client work) plus a `collateral/` nudge
  for PDF companion pieces.
- `saas`, `ecommerce-store`, `browser-extension`: same design chain added where the surface is real
  HTML/CSS (app screens, custom storefront/theme, popup/options UI).
- `mobile-app`, `desktop-app`: `design-bausteine` + `design-critique` added; `slop-detect` explicitly
  scoped to Electron's renderer only (it reads CSS/Tailwind, not native Swift/Kotlin/Qt/Tauri UI).
- `research-decision`, `content-writing`, `game-dev`: `document-design`/`docrender` added for the
  report, book/manual export, and pitch deck respectively, alongside the existing `pdf`/`docx`/`pptx`
  mentions (not replacing them).
- `creative-media`, `social-media-manager`: `design-bausteine`'s four-part brief added for
  thumbnail/brand-visual and ad-creative generation.
- Not touched, with reason (see the session write-up): `oss-library` (no fixed-page document/UI
  deliverable), `build-business`/`agency-automations` (internal Markdown assets / a runtime layer,
  no shipped visual surface), `llm-app` (delegates its UI to `website`/`saas`, which already carry
  the chain).
- Noted as an open routing gap, not resolved here: a project that is purely a one-off
  document/report/presentation/CV (no research matrix, not book-length) has no dedicated
  `new-project` route today and falls to `generic-project`; see the session result file for the
  proposal.

## 0.4.1 — 2026-07-10
- Docs: new-project describes the plugin install path (marketplace) alongside the legacy symlink; add repo CLAUDE.md with contributor rules.

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
