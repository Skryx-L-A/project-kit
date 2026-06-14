---
name: website
description: Build/set up a website project — a marketing site, landing page, portfolio, blog, agency, or business site — from the user's grilled answers. Project-kit sub-skill loaded by new-project routing whenever someone wants to build/design/redesign a website or web UI. Defaults to Astro 5 static, DSGVO-safe self-hosted assets, BITV/WCAG-AA accessibility, German UI with English code, Netlify deploy.
---

# website — the site builder sub-skill

## What this sub-skill is for
Standing up a real, deployable **website** project: marketing/business site, landing page,
portfolio, blog, agency site, or any public web UI. It mirrors content-driven school/organisation
sites — content-driven, privacy-first, accessible, German-facing.
It is loaded by `new-project` routing and composes cleanly into `saas` when a site is one layer
of a larger product.

## Mandatory grill-questions (fold into the Definition of Ready)
Before a single component is built, these MUST be locked:
- **Purpose & primary CTA** — what one action should a visitor take (book / buy / contact / read)?
- **Audience & language** — who, and which locale(s)? Default German UI / English code; confirm if multilingual (i18n now or later).
- **Content source** — does the user supply copy/photos, or do we draft? Real photos vs. placeholder? **Photo consent** for any people shown.
- **Brand tokens** — colours, type, logo. If none, design-start chains the inspiration skills to derive them.
- **Pages & content model** — page list + which content is a **collection** (blog posts, team, services) vs. one-off.
- **CMS need** — will a non-dev edit content? If yes, git-based CMS (Decap/Sveltia) vs. none.
- **Legal pages** — Impressum + Datenschutzerklärung required (German sites: almost always). Cookie/consent banner needed?
- **Hosting & domain** — Netlify default; custom domain owned? DNS access?
- **Accessibility bar** — confirm BITV/WCAG-AA as the non-negotiable target (public-sector → BITV 2.0).
- **No-emoji rule** — restate: typographic symbols only in the UI, never emoji.

## Project sub-agents to generate (into `.claude/agents/`)
- **frontend-screen** *(delegate-by-default)* — builds a single page/section to spec from tokens; owns layout, responsive, motion. Chain `frontend-design` + `magic`.
- **accessibility-reviewer** *(delegate-by-default)* — audits each screen against BITV/WCAG-AA: contrast, focus order, alt text, semantic landmarks, keyboard nav; blocks merge on failures.
- **content-collection-author** — drafts/structures content-collection entries (blog, services, team) in the project's German voice with frontmatter validation.
- **seo-aeo-agent** — fills meta/OpenGraph, sitemap, schema.org JSON-LD, and `/llms.txt`; chains the `web-aeo` skill.
- **privacy-compliance-checker** — verifies no external CDN/Google-Fonts calls, self-hosted assets only, Impressum/Datenschutz present, consent handled.

## Tools / CLIs / MCP / skills needed
Check in environment-readiness; offer install, never auto-install:
- **Node 20+ / npm or pnpm**, **Astro 5** (`npm create astro@latest`). `astro`, `vite` on PATH.
- **Netlify CLI** (`npm i -g netlify-cli`) for deploy + preview.
- **MCP:** `claude-in-chrome` or `playwright` for live visual/a11y checks; `Figma` if a design file exists; `magic` (21st.dev) for UI component scaffolds.
- **CHAIN these GLOBAL skills automatically at design start** (per the user's standing rule, no asking): `framer-inspiration` → `design-harvest` → `frontend-design`; and `web-aeo` once content exists. Use `higgsfield-generate` only for original imagery the user explicitly wants.

## File / asset nudges (on top of the base set)
Beyond CLAUDE.md, PROJEKT_<NAME>.md, TASKS.md, DONE.md, README, `.claude/`:
- `src/styles/tokens.css` — the single source of design tokens (colour/type/spacing).
- `src/content/` — content collections + `config.ts` schemas.
- `src/fonts/` — **self-hosted** font files (woff2) + `@font-face`; NO Google Fonts / CDN.
- `public/` — `robots.txt`, `sitemap.xml` (or @astrojs/sitemap), `/llms.txt`, favicon set.
- `cms/` or `admin/` — Decap/Sveltia config if a CMS was chosen.
- `legal/` source for Impressum + Datenschutzerklärung pages.
- `design/` — harvested inspiration refs + token notes from the chained skills.
- `netlify.toml` — build + headers (CSP, security headers).

## Stack defaults & done-bar
**Default stack:** Astro 5 static output, TypeScript, `tokens.css`, content collections, self-hosted
fonts, `@astrojs/sitemap`, optional Decap/Sveltia git CMS, Netlify deploy from `main`. Reach for
Next.js only if the project genuinely needs SSR/app-server behaviour (then it likely belongs in `saas`).

**"Finished/working" means** (checkable bar):
- `astro build` is clean; site deploys and loads on the target host.
- Lighthouse: Performance, Accessibility, Best-Practices, SEO all ≥ 90 (a11y = 100 target).
- BITV/WCAG-AA verified: keyboard-navigable, visible focus, contrast passes, every image has meaningful alt.
- **Zero external network calls** to Google Fonts / CDNs (verify in the network panel).
- Impressum + Datenschutzerklärung present and linked; consent handled if cookies are set.
- Responsive from 320px to wide desktop; primary CTA reachable on every relevant page.
- `/llms.txt` + schema.org JSON-LD present.

## Guardrails
- **DSGVO first:** no third-party CDN, no Google Fonts, no analytics that ships PII without consent — IP-leak is a real legal risk. Self-host everything.
- **Accessibility is a gate, not a nice-to-have** — BITV/WCAG-AA failures block "done".
- **No emojis in the UI** — typographic symbols only (user's standing rule).
- **Honesty in copy:** flag any factual claim (stats, certifications, testimonials) for the user/client to confirm before publish; never invent credentials or quotes.
- **Photo/consent:** no images of identifiable people without confirmed consent.
- **Inspiration ≠ copying:** study patterns/tokens from `framer-inspiration`/`design-harvest`; never lift copyrighted assets or markup.
- **Commits under the user's name only (Skryx-L-A); never add Claude as co-author.**
