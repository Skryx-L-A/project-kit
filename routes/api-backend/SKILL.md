---
name: api-backend
description: Stand up a production-shaped REST/GraphQL API or backend service in a project folder from the user's answers — data model + reversible migrations, auth, input validation, tested endpoints, and a deploy path. A project-kit sub-skill loaded by new-project's routing whenever the user wants to BUILD AN API / backend / web service / endpoints / a server with a database. Supabase-first option; composes with website/saas. Not for static sites or pure CLIs.
---

# api-backend — build a real backend service

## What this sub-skill is for
Standing up a **server-side API** (REST or GraphQL) with a real persistence layer: a
schema with reversible migrations, authentication + authorization, request validation,
an automated test suite, and a deploy path. Loaded by `new-project` when the project is
(or contains) a backend service. Composes under `saas` (with `website`) and pairs with
`data-ml` when the API serves a model.

## Mandatory grill-questions (fold into the Definition of Ready)
- **Surface:** REST or GraphQL? Public, internal, or first-party-only? Versioning policy?
- **Data:** Postgres (Supabase) vs. self-hosted DB? Core entities + relations? Expected
  scale / read-vs-write shape? Multi-tenant — and if so, isolation by row (RLS) or schema?
- **Auth:** who authenticates (users / services / both)? Mechanism (Supabase Auth, JWT,
  session, API keys, OAuth)? **Authorization model** — roles/RBAC, ownership, row-level?
- **Validation & contract:** schema-validated inputs (zod/pydantic)? OpenAPI/GraphQL SDL
  as the published contract? Error format and status-code conventions?
- **Migrations:** how are they run, and **is every migration reversible** (down path)?
- **Non-functional:** rate limits, idempotency for writes, pagination, observability/logging,
  secrets handling. Deploy target (Supabase Edge Functions, container, serverless, VPS)?

## Project sub-agents to generate (`.claude/agents/`)
- **endpoint-builder** — implements one endpoint/resolver at a time with its validation
  + tests, green before reporting (delegate-by-default for endpoint work).
- **schema-migrator** — authors forward **and** reversible-down migrations, runs them
  up/down on a scratch DB to prove reversibility (delegate-by-default for schema work).
- **api-tester** — writes/runs the endpoint + contract test suite (happy path, auth
  failures, validation errors, edge cases); reports red/green honestly, never weakens a
  test to make it pass.
- **security-reviewer** — adversarial authz/injection/secret-leak review of new endpoints
  before they're called done (delegate-by-default before any merge of money/PII paths).

## Tools / CLIs / MCP / skills needed
- **Supabase MCP** (chain): `apply_migration`, `execute_sql`, `list_tables`,
  `deploy_edge_function`, `generate_typescript_types`, `get_advisors`, `get_logs`,
  `create_branch` for a safe migration sandbox. Run `list_tables` before any schema change.
- **n8n MCP** (chain) when the API fronts or triggers automations/webhooks.
- Runtime: Node + a framework (Fastify/Hono/NestJS) **or** Python (FastAPI) — install via
  the project's package manager. DB client + a migration tool (Supabase CLI, Prisma,
  Drizzle, or Alembic). `pip`/`npm` install hints surfaced at environment-readiness, never
  auto-installed.
- Validation: zod (TS) or pydantic (Py). Contract: OpenAPI generator or GraphQL codegen.
- **Global skills/agents to chain:** `deep-research` (auth/framework trade-offs),
  `code-review` (before risky commits), `verify` (run the API and hit real endpoints),
  `security-review` (before exposing anything public), `market-researcher` (agent) for
  facts on third-party APIs/SDKs/pricing the backend depends on.

## File / asset nudges (on top of the base set)
- `API.md` — the contract: endpoints/resolvers, request/response schemas, auth rules,
  error format. Keep it the source of truth; generate OpenAPI/SDL from it where possible.
- `migrations/` — ordered, **reversible** migration files (each with a down).
- `schema.sql` or an ERD note — the canonical data model.
- `.env.template` — every required secret as a key with NO value; real `.env` is
  git-ignored (never commit credentials).
- `tests/` — endpoint + contract tests; `openapi.yaml` / `schema.graphql` published artifact.
- `DEPLOY.md` — how migrations and the service ship to the chosen target.

## Stack defaults & done-bar
**Default stack:** Supabase Postgres + Auth + Row-Level Security, an Edge Function or
FastAPI/Fastify layer, schema-validated inputs, migrations via the Supabase CLI, tests in
pytest/vitest. Swap freely from the grill answers.
**Done-bar (all must hold):**
1. Every endpoint/resolver has passing tests (happy path + auth-failure + validation-error).
2. Every migration is **reversible** — proven by running it up then down on a scratch DB.
3. **Authorization is enforced and tested** — an unauthorized request is provably rejected,
   not just authentication.
4. Inputs are schema-validated; the published contract (OpenAPI/SDL) matches the code.
5. The service runs and answers a real request locally (`verify`), secrets via env only.

## Guardrails
- **Authz is not auth.** Logging a user in is not the same as checking they may touch *this*
  row. Test the rejection path explicitly; default-deny.
- **Migrations must be reversible** and tested both directions before "done" — an
  irreversible migration is an incident waiting to happen.
- **Never trust input.** Validate at the boundary; parameterize every query (no string-built
  SQL); treat all client data as hostile.
- **Secrets never enter the repo or chat.** Keys live in env / the platform vault; ask the
  user to paste them, never invent or assume them.
- **No green-washing tests.** A failing test is information; weaken the system, not the test.
- **Confirm destructive/outward-facing actions** — applying a migration to a shared/remote
  DB, deploying a public endpoint — before executing (irreversible, off-machine).
- Commits under the user's own name only — never add a Claude co-author trailer.
