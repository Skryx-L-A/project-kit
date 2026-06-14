# ROUTING — detect project types and compose sub-skills

Projects are **hybrid**. Detect **every** applicable type from the grill answers and **stack**
the matching sub-skills — their grill-questions, their generated sub-agents, their files, and
their deliverables all compose. Load each from `KIT/skills/<name>/SKILL.md`.

## Type → sub-skill map

| If the project is… | Load sub-skill |
|---|---|
| A website / landing / marketing site / portfolio / blog / web UI | `website` |
| A desktop / cross-platform app (Electron, Qt, native) | `desktop-app` |
| A mobile app (iOS / Android / Flutter / RN) | `mobile-app` |
| A CLI / dev tool | `cli-tool` |
| A REST/GraphQL API or backend service | `api-backend` |
| A data / ML / model project (pipeline, training, eval) | `data-ml` |
| A trading / quant strategy | `quant-strategy` |
| A skill / sub-agent / MCP server (meta tooling) | `ai-agent-mcp` |
| A game mod | `game-mod` |
| A research / decision project | `research-decision` |
| A book / course / docs / writing project | `content-writing` |
| A publishable open-source library / package | `oss-library` |
| A browser extension | `browser-extension` |
| A Discord/Telegram bot or workflow automation | `bot-automation` |
| A full-stack SaaS product | `saas` (itself pulls `website` + `api-backend` + often `build-business`) |
| A game built from scratch (engine, gameplay, assets) | `game-dev` |
| An LLM-powered product (chatbot, RAG, agent app, fine-tune) | `llm-app` |
| Firmware / embedded / microcontroller / robotics / IoT | `hardware-embedded` |
| A creative-media pipeline (video/image gen, channel, ads, thumbnails) | `creative-media` |
| A scientific-computing / numerical simulation (physics, orbital, Monte-Carlo) | `simulation` |
| An e-commerce store / storefront (Shopify-first) | `ecommerce-store` (composes `website`; chain `build-business` for acquisition) |
| Building a business / agency / making money | `build-business` (the ultraskill) |
| Anything with **no** clear type match | `generic-project` (fallback) |

## Composition rules

- **Stack, don't pick one.** A SaaS that needs paying customers = `saas` + `build-business`.
  A data product with a dashboard = `data-ml` + `website`. A CLI that ships on PyPI =
  `cli-tool` + `oss-library`.
- **Business branch is orthogonal.** `build-business` is loaded only by the business fork
  (route **a**, new business). A `website` for an *existing* business links to the business
  profile but does **not** pull `build-business`, so no marketing rebuild.
- **Merge, don't duplicate.** When two sub-skills both want a sub-agent or file, create one
  that serves both. Resolve conflicting conventions toward the user's proven patterns.
- **Each sub-skill self-describes** its mandatory grill-questions, the sub-agents it
  generates, the files/assets it adds, and the tools/CLIs it needs. Fold all of those into
  the main flow (grill → readiness → scaffold).

## Adding a new type

New project types are expected over time (oriented on the user's real projects). To add one,
create `KIT/skills/<new-type>/SKILL.md` and add a row here. See `docs/EXTENDING.md`.
