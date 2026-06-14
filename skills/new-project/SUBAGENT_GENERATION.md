# SUB-AGENT GENERATION — build the project's own agents before work starts

A new project should arrive **as ready as possible**: its own purpose-built sub-agents
already written into `<project>/.claude/agents/` and wired to auto-load, before the first
task runs. Tailor them to the stack and the matched sub-skills — do not ship generic agents.

## How to decide which agents to generate
Derive from the DoR + matched sub-skills. Typical patterns:

| Project shape | Generate agents like |
|---|---|
| `website` | `frontend-screen` (build a page to the done-bar), `accessibility-reviewer`, `design-harvester` |
| `api-backend` / `saas` | `endpoint-builder`, `schema-migrator`, `api-tester`, `security-reviewer` |
| `data-ml` | `data-explorer`, `experiment-runner`, `eval-honesty-checker` (leakage/overfit) |
| `quant-strategy` | `quant-engineer`, `backtest-analyst` (honest), `strategy-scout` |
| `cli-tool` / `oss-library` | `cli-ux-reviewer`, `release-engineer`, `docs-writer` |
| `build-business` | `market-researcher`, `offer-architect`, `copy-writer`, `ad-analyst`, `sales-trainer` |
| `research-decision` | `source-finder`, `claim-verifier`, `decision-matrix-builder` |
| `game-mod` | `mod-deployer`, `compat-checker` (Proton/loader gotchas) |
| any | `reviewer` (diff/PR), `verifier` (runs the app to confirm behaviour) |

## Authoring rules
- One agent per file in `<project>/.claude/agents/<name>.md`, with frontmatter
  (`name`, `description`, `tools`) and a tight system prompt scoped to this project's stack,
  conventions, and done-bar.
- Make domain agents **delegate-by-default** for their area (state this in the project
  `CLAUDE.md` so sessions actually use them).
- Reuse the kit's reusable agent templates in `KIT/agents/` as starting points; specialise
  them with the project's real names, paths, and rules.
- Keep honesty agents (eval/backtest/security) genuinely adversarial — they exist to catch
  the builder, not rubber-stamp it.
- Register auto-load via the project's `.claude/settings.local.json` (a SessionStart note
  pointing sessions at the agents) and a line in `CLAUDE.md`.

The project bible records which agents were generated and why.
