---
name: saas
description: Build/set up a SaaS project — a multi-tenant web app with auth, billing, and a backend — from the user's grilled answers. Project-kit sub-skill loaded by new-project routing whenever someone wants to build a SaaS, web app, subscription product, dashboard, or "app people log into and pay for". Composes the website + api-backend sub-skills (and build-business when it must make money) rather than duplicating them; defaults to Stripe billing, auth, and a Supabase/Postgres option.
---

# saas — the SaaS composer sub-skill

## What this sub-skill is for
Standing up a real **SaaS product**: a multi-tenant web application people sign up for, log into,
and pay for. This is a **composition** sub-skill — it does not re-implement the frontend or API,
it **stacks** existing sub-skills and adds the SaaS-specific spine: tenancy, auth, billing,
entitlements, and the money loop. Loaded by `new-project` routing for app/subscription products.

## Mandatory grill-questions (fold into the Definition of Ready)
Lock these before scaffolding — they shape tenancy, schema, and billing:
- **Tenancy model** — single-tenant per customer, shared DB with row-level isolation, or schema-per-tenant? (Default: shared DB + tenant_id + RLS.)
- **Who logs in** — individual users, teams/orgs, or both? Roles/permissions needed?
- **Auth approach** — email+password, magic link, OAuth (Google/GitHub), SSO? MFA required?
- **Billing model** — flat subscription, tiers, usage-based, seats, free trial, freemium? Currency + tax/VAT handling (German/EU → MwSt + reverse charge)?
- **Entitlements** — what does each plan unlock; how is a gated feature enforced server-side?
- **Core domain** — the one thing the product does; the minimal data model for it.
- **Compliance scope** — DSGVO/GDPR (data export + deletion), SOC2-lite, PII handling, data residency.
- **Does it need to make money on day one** — if yes, also load `build-business` for offer/pricing/GTM.
- **Self-serve vs. sales-led** — onboarding flow + whether there's a public marketing site (→ `website`).

## Project sub-agents to generate (into `.claude/agents/`)
- **tenancy-architect** *(delegate-by-default)* — owns the multi-tenant data model + isolation; reviews every query/migration for tenant-scoping and RLS correctness.
- **auth-flow-builder** *(delegate-by-default)* — implements signup/login/session/roles; verifies no auth bypass, secure cookies, password/MFA handling.
- **billing-integrator** *(delegate-by-default)* — Stripe checkout, subscriptions, webhooks, customer portal, entitlement sync; tests the webhook→plan-state loop end to end.
- **api-contract-agent** — owns endpoint contracts, validation, and error shapes (chains the `api-backend` sub-skill's agents).
- **frontend-screen** — app screens (inherited from the `website` sub-skill) for dashboard/settings/billing UI.
- **security-reviewer** — checks authz on every route, secret handling, rate limits, OWASP basics before "done".

## Tools / CLIs / MCP / skills needed
Check in environment-readiness; offer install, never auto-install:
- **Node 20+ / package manager**, the chosen web framework (Next.js default for app surface; Astro for the marketing site).
- **Stripe CLI** (`stripe`) for local webhook forwarding + test events; Stripe account + test keys (ask the user to paste, never invent).
- **Supabase** — MCP `Supabase` server for project/schema/migrations/RLS/types, or self-hosted Postgres + Prisma/Drizzle if the user prefers.
- **MCP:** `Supabase` (DB/auth/edge), `playwright`/`claude-in-chrome` (flow + checkout testing), `n8n` (lifecycle automations), `magic` (UI).
- **COMPOSE these sub-skills (don't duplicate):** `website` (marketing + app UI + DSGVO/a11y), `api-backend` (server, DB, contracts), and `build-business` (offer, pricing, acquisition) when it must earn revenue.
- **CHAIN global skills:** `frontend-design`/`framer-inspiration`/`design-harvest` for UI; `web-aeo` for the marketing surface; `code-review` + `verify` before shipping flows.

## File / asset nudges (on top of the base set)
Beyond CLAUDE.md, PROJEKT_<NAME>.md, TASKS.md, DONE.md, README, `.claude/`:
- `apps/web/` + `apps/api/` (or a monorepo) — app surface and backend, from the composed sub-skills.
- `db/migrations/` + `db/schema` — tenant-aware schema with RLS policies.
- `ARCHITECTURE.md` — tenancy decision, auth flow, billing/entitlement map (the load-bearing decisions).
- `billing/` — Stripe products/prices config + webhook handlers + entitlement table.
- `.env.example` — every key named (Stripe, DB, auth) with NO real values; real keys stay out of git.
- `SECURITY.md` — authz model, data export/deletion (DSGVO) procedure, secret rotation notes.
- `marketing/` — the public site (from `website`) if self-serve.

## Stack defaults & done-bar
**Default stack:** Next.js (app surface) + Astro (marketing site), TypeScript, Supabase
(Postgres + Auth + RLS) or Postgres+Drizzle, **Stripe** for billing, shared DB multi-tenancy with
`tenant_id` + row-level security, deployed to Vercel/Netlify + Supabase. Self-hosted fonts and
DSGVO/a11y rules from the `website` sub-skill carry over.

**"Finished/working" means** (checkable bar):
- A new user can **sign up → log in → reach a tenant-isolated workspace** — and cannot see another tenant's data (verified, not assumed).
- **Subscribe via Stripe (test mode) → webhook updates plan state → a gated feature unlocks**, end to end.
- Cancel/downgrade revokes entitlement; the customer portal works.
- Authorization is enforced **server-side** on every protected route (no client-only gating).
- DSGVO: a user can export and delete their data; PII is documented.
- Secrets are in env/secret store, never in the repo; `.env.example` is complete.
- The composed sub-skills' own done-bars (website a11y/perf, api contract tests) also pass.

## Guardrails
- **Tenant isolation is a security boundary, not a feature** — a cross-tenant data leak is a critical bug; gate "done" on a proven isolation test.
- **Authorize on the server, always** — never trust client-side plan/role checks for access.
- **Never invent or commit credentials** — Stripe/DB/auth keys are pasted by the user and `.gitignore`d.
- **Billing honesty:** test-mode only until the user explicitly goes live; never enable real charges silently.
- **DSGVO/GDPR:** data export + deletion paths exist; PII minimised and documented; no PII in a public repo.
- **Don't duplicate** the website/api-backend/build-business sub-skills — compose them; keep this skill to the SaaS spine.
- **Commits under the user's name only (Skryx-L-A); never add Claude as co-author.**
