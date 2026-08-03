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
  `CLAUDE.md` so sessions actually use them) — but delegate-by-default only covers *routing
  the work to the agent*, never *trusting its report without checking*. A subagent runs
  invisibly to the user; the calling session reads the agent's actual output (diff, test run,
  render) before treating the task as done, the same way it would verify its own work.
- **A generated agent is a leaf: it does not spawn further sub-agents.** If a job is too big
  for one agent, that is a sign the job needs breaking into separate, individually-generated
  agents up front — not a reason to let one agent delegate further on its own.
- **Publishing, deploying, or otherwise sending something outward** (a `git push`, a package
  publish, a release, a live deploy, a sent message) is never something a generated agent
  executes on its own initiative — it prepares the action and hands it back for the user (or
  the calling session, after its own check) to confirm and run. See step 8 (REPO) of
  `SKILL.md` for the pattern the kit already uses: `git init` and a first commit happen
  freely, but creating the public GitHub repo waits for explicit confirmation.
- Reuse the kit's reusable agent templates in `KIT/skills/new-project/agent-templates/` as
  starting points; specialise
  them with the project's real names, paths, and rules.
- Keep honesty agents (eval/backtest/security) genuinely adversarial — they exist to catch
  the builder, not rubber-stamp it. Where a task is genuinely multi-step and was delegated,
  prefer a *separate* reviewer agent for the check, not the same agent grading its own work.
- Register auto-load via the project's `.claude/settings.local.json` (a SessionStart note
  pointing sessions at the agents) and a line in `CLAUDE.md`.

The project bible records which agents were generated and why.
