---
name: oss-library
description: Build/set up a publishable open-source library — a PyPI, npm, or crates.io package — from the user's grilled answers. Project-kit sub-skill loaded by new-project routing whenever someone wants to ship a reusable package/library/SDK, "publish a module", make an installable dependency, or open-source a piece of code. Bakes in semantic versioning, a chosen LICENSE, a README with real examples, CHANGELOG, tests, and green CI so the package is actually installable and documented.
---

# oss-library — the publishable-package builder sub-skill

## What this sub-skill is for
Standing up a **reusable, publishable library**: a Python package (PyPI), a JS/TS package (npm),
or a Rust crate (crates.io). The deliverable is not just code — it's a package other people can
`pip install` / `npm install` / `cargo add`, read docs for, and trust. Public repo by default.
This composes with `ai-agent-mcp` when the library is itself an SDK or MCP toolkit.

## Mandatory grill-questions (fold into the Definition of Ready)
Lock these before any code:
- **Registry & language** — PyPI/Python, npm/Node(TS), or crates.io/Rust? Sets the whole toolchain.
- **Package name** — available on the registry? (check before committing to it) and import name.
- **LICENSE** — which one? Ask explicitly: **MIT** (default, permissive), Apache-2.0 (patent grant),
  BSD-3, MPL-2.0, GPL/AGPL (copyleft). Don't pick for the user — it's a real legal choice.
- **Public API surface** — what functions/classes/types are exported and *stable*? What's internal?
- **SemVer baseline** — start at `0.1.0` (pre-1.0, breaking allowed) vs. committing to `1.0.0` stability.
- **Supported versions/platforms** — Python 3.x range / Node LTS range / Rust MSRV; OS matrix.
- **Docs depth** — README-only, or a docs site (Sphinx/mkdocs / TypeDoc / `cargo doc` + docs.rs)?
- **Dependencies & policy** — minimise deps; any with restrictive licenses? Pin strategy.
- **Release trigger** — manual `tag → publish`, or automated on a GitHub release? Who holds the token?

## Project sub-agents to generate (into `.claude/agents/`)
- **api-designer** *(delegate-by-default)* — designs the public API for ergonomics + stability; guards the
  surface, flags breaking changes against the current minor.
- **docs-writer** *(delegate-by-default)* — writes README, examples, docstrings/JSDoc/rustdoc, and the docs
  site; every public symbol gets a usage example.
- **release-engineer** — owns SemVer bumps, CHANGELOG entries (Keep-a-Changelog), tagging, and the publish
  step; refuses to publish on red CI or a dirty changelog.
- **ci-setup** — builds/maintains the GitHub Actions matrix (lint, type-check, test across versions) and the
  publish workflow; chains `update-config` for any local hooks.
- **test-author** — writes/extends the test suite + coverage; treats untested public API as not done.

## Tools / CLIs / MCP / skills needed
Check in environment-readiness; offer install, never auto-install:
- **Python:** 3.11+, `uv` or `pip`/`build`, `hatchling`/`setuptools`, `pytest`, `ruff`, `mypy`, `twine`
  (publish). Docs: `sphinx` or `mkdocs-material`.
- **Node/TS:** Node 20+, `pnpm`/`npm`, `tsup`/`tsc`, `vitest`/`jest`, `eslint`, `tsd` for type tests,
  `npm publish --provenance`. Docs: `typedoc`.
- **Rust:** stable toolchain, `cargo`, `cargo test`, `clippy`, `rustfmt`, `cargo publish`, docs.rs.
- **`gh` CLI** for repo + release; registry token stored as a repo/CI secret (ask the user; never invent).
- **CHAIN these GLOBAL skills:** `cli-anything` if the library ships a CLI; `claude-api` if it wraps the
  Anthropic SDK (read it before any model id); `code-review` + `verify` before each release;
  `update-config` for repo/CI hooks.

## File / asset nudges (on top of the base set)
Beyond CLAUDE.md, PROJEKT_<NAME>.md, TASKS.md, DONE.md, README, `.claude/`:
- **LICENSE** (the chosen one) at repo root — required for "open source" to mean anything.
- `CHANGELOG.md` (Keep-a-Changelog) — every release documented.
- Manifest: `pyproject.toml` / `package.json` / `Cargo.toml` with metadata, classifiers, repo URL.
- `src/<pkg>/` (or `src/`) + `tests/`; a `py.typed` / `.d.ts` / typed signatures so consumers get types.
- `.github/workflows/ci.yml` (test matrix) + `release.yml` (publish on tag/release).
- `examples/` — runnable snippets that double as the README examples.
- `CONTRIBUTING.md` + `CODE_OF_CONDUCT.md` (public repo) and an issue/PR template.
- `docs/` if a docs site was chosen.

## Stack defaults & done-bar
**Default stack:** match the user's language. Python → `pyproject.toml` (hatchling) + `pytest` + `ruff`/`mypy`
+ `twine`, MIT, start `0.1.0`. TS → `tsup` ESM+CJS + types + `vitest` + `eslint`, MIT. Rust → `cargo` +
`clippy`/`rustfmt`, MIT/Apache-2.0 dual is common. GitHub Actions CI matrix; manual-tag publish unless the
user wants automated release.

**"Finished/working" means** (checkable bar):
- **Published** to the registry and **installable** in a clean env (`pip install` / `npm i` / `cargo add` then
  import/use the public API).
- **CI green** across the declared version matrix (lint + type-check + tests).
- **Documented:** README with install + at least one real runnable example; every public symbol has a docstring;
  docs site builds if chosen.
- **SemVer + CHANGELOG** correct for the published version; `LICENSE` present.
- A consumer smoke test (fresh project importing the package) passes.

## Guardrails
- **Public by default = public forever** — no secrets, tokens, private data, or internal paths in the repo or
  package; verify before first publish.
- **SemVer honesty** — a breaking change to the public API is a major bump (or a documented 0.x break); never
  ship a breaking change as a patch.
- **License correctness** — don't bundle code under an incompatible license; the LICENSE choice is the user's.
- **No phantom features** — README/docs describe only what's implemented and tested; no aspirational claims.
- **Publish tokens are secrets** — stored in CI/secret store, asked from the user, never committed.
- **No emojis in CLI/library output or UI** (user's standing rule).
- **Commits under the user's name only (Skryx-L-A); never add Claude as co-author.**
