# FILE POLICY — adaptive, auto-chosen (never ask the user a file count)

Pick the file set yourself from the project's **type and size**. The user is never asked
"how many files". Base set is the user's proven system (CLAUDE.md + PROJEKT_<NAME>.md +
TASKS.md + DONE.md + README.md + `.claude/`); scale it up or down by size.

## Size tiers

### Tiny (a script, a one-off, a throwaway experiment, a tiny mod)
- `CLAUDE.md` (lean operating manual, doubles as the spec)
- `README.md`
- `.claude/` only if hooks/agents are actually needed.
- Memory: harness auto-memory seed only.

### Standard (most projects — apps, sites, tools, services, research)
The proven **4-file system + README + `.claude/`**:
- `CLAUDE.md` — auto-loaded every session, the **lean** operating manual. Keep it short.
- `PROJEKT_<NAME>.md` — the project bible: the filled Definition of Ready (facts, stack,
  scope, sitemap/architecture, phases, locked decisions). Read on demand.
- `TASKS.md` — §1 user's inbox · §2 agent handoff.
- `DONE.md` — completed-work log + session reviews.
- `README.md` — standard repo entry point.
- `.claude/` — `settings.local.json` (hooks), `agents/` (project sub-agents).

### Large (multi-surface products, SaaS, long-running, deploy-heavy, multi-contributor)
Standard **plus**:
- `STATUS.md` — current state, separate from the historical `DONE.md` log.
- `DEPLOYMENT.md` — deploy/hosting/release runbook.
- Optionally split the bible (e.g. `ARCHITECTURE.md`) if `PROJEKT_<NAME>.md` gets unwieldy.

## Type nudges (add on top of the size tier)
- `build-business` → also a `prompts/` folder (the 7 ready-to-run assets), `MARKET.md`,
  `OFFER.md`, `OUTREACH.md` as the system fills in.
- `website` → README documents run/build/deploy; bible holds sitemap + design tokens ref.
- `data-ml` / `quant-strategy` → an `EVAL.md` / `BACKTESTS.md` with honest results.
- `research-decision` → a `berichte/` (reports) folder + a decision matrix doc.
- `content-writing` → an outline/chapters structure instead of code docs.
- `oss-library` → `CHANGELOG.md`, `LICENSE`, `CONTRIBUTING.md` from the start.
- `game-dev` → an `assets/` + `design/` (GDD) folder; bible holds the core-loop spec.
- `llm-app` → an `EVAL.md` (eval set + scores) + `prompts/` + `guardrails.md`.
- `hardware-embedded` → a `firmware/` + `HARDWARE.md` (board, pinout, power budget, flash steps).
- `creative-media` → an `assets/` + `pipeline.md` (produce→review→publish) + a content calendar.
- `simulation` → a `VALIDATION.md` (analytic/benchmark cases, tolerances, convergence) + `notebooks/`.
- `ecommerce-store` → a `catalog/` + `STORE.md` (products, payments, shipping, channels).

## Discipline (from the user's existing projects)
- **Keep `CLAUDE.md` lean** — it is the only file loaded every session. Detail lives in the
  bible, read on demand.
- **Fold new doc needs into existing files** — don't spawn parallel docs. `README.md` is the
  one carve-out from the file rule.
- Don't leave checked `[x]` items in TASKS; move finished work to `DONE.md`.
