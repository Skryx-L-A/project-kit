---
name: ai-agent-mcp
description: Build/set up an AI meta-tooling project — a Claude Code skill, a subagent, an MCP server, or an agent app — from the user's grilled answers. Project-kit sub-skill loaded by new-project routing whenever someone wants to build a skill, write a subagent, stand up an MCP server, or ship an agent/LLM app. Chains skill-creator + claude-api, picks the right Claude model, and bakes in an eval plan so triggering and tools are proven, not assumed.
---

# ai-agent-mcp — the agent/meta-tooling builder sub-skill

## What this sub-skill is for
Standing up **tooling that Claude (or another agent) runs**: a Claude Code **skill** (a folder
with SKILL.md), a **subagent** (a `.md` in `.claude/agents/` with frontmatter + system prompt),
an **MCP server** that exposes tools/resources, or a small **agent app** built on the Anthropic
SDK. This is the user's home turf — he builds skills and agents heavily — so the bar is high:
correct triggering, validated tools, and evals that prove it.

## Mandatory grill-questions (fold into the Definition of Ready)
Lock these before any code:
- **Form factor** — skill vs. subagent vs. MCP server vs. agent app? They have different shapes,
  runtimes, and "done" bars. If unsure, decide from how it's invoked (Claude reads a SKILL.md →
  skill; Claude delegates a scoped job → subagent; a tool surface other clients call → MCP; a
  standalone program driving the model → agent app).
- **Trigger surface** (skills/subagents) — what user phrasing or task shape must fire it, and what
  must NOT? The description line is the trigger; write it to match real intent, avoid false fires.
- **Claude model** — chain `claude-api` for current model ids: `claude-opus-4-8` (most capable),
  `claude-sonnet-4-6`, `claude-haiku-4-5-20251001`, `claude-fable-5`. Default to the newest/most
  capable that fits cost+latency; justify the pick.
- **Tools / permissions** — exactly which tools the skill/subagent/MCP gets, and the least-privilege
  set. For MCP: which tools/resources/prompts, their input schemas, and side-effect scope.
- **Eval plan** — what "works" means as runnable checks (trigger-accuracy cases, golden tool calls,
  refusal cases). No eval plan = not Ready.
- **Distribution** — local-only, committed into a repo's `.claude/`, or published/installable?
- **State & secrets** — does it need state, files, or API keys? Where do keys live (never committed)?

## Project sub-agents to generate (into `.claude/agents/`)
- **skill-author** *(delegate-by-default)* — authors/edits SKILL.md (frontmatter name+description +
  body) and subagent `.md` files to the kit's conventions; chains the `skill-creator` skill.
- **eval-runner** *(delegate-by-default)* — builds and runs the eval suite (trigger accuracy, tool-call
  goldens, variance analysis), reports pass/fail honestly, blocks "done" on red.
- **mcp-tool-designer** — designs MCP tool/resource schemas, names, and input validation; verifies each
  tool against the SDK reference and a smoke call.
- **prompt-author** — writes/tightens the system prompt and description line; reduces false triggers.

## Tools / CLIs / MCP / skills needed
Check in environment-readiness; offer install, never auto-install:
- **Node 20+** (MCP TypeScript SDK: `@modelcontextprotocol/sdk`) and/or **Python 3.11+** (`mcp`,
  `anthropic`). `npx @modelcontextprotocol/inspector` to test an MCP server interactively.
- **Anthropic SDK** — `npm i @anthropic-ai/sdk` or `pip install anthropic`; `ANTHROPIC_API_KEY` for
  agent apps (ask the user to paste it; never invent).
- **CHAIN these GLOBAL skills automatically:** `skill-creator` (author skills/subagents + run/measure
  evals), `claude-api` (model ids, params, tool-use, MCP, caching — read it before touching any
  model id or LLM behaviour), `update-config` (wire skills/MCP/hooks into settings.json), `code-review`
  + `verify` before "done". Use `cli-anything` if the agent app needs to drive a GUI tool headlessly.
- **MCP to chain:** the kit's own MCP servers as live references — e.g. `n8n` (`get_sdk_reference`),
  `claude-in-chrome` / `playwright`, `Supabase` — to study real tool-surface design.

## File / asset nudges (on top of the base set)
Beyond CLAUDE.md, PROJEKT_<NAME>.md, TASKS.md, DONE.md, README, `.claude/`:
- **Skill:** `SKILL.md` (frontmatter + body), optional `references/`, `scripts/`, `assets/`.
- **Subagent:** `.claude/agents/<name>.md` (frontmatter `name`, `description`, `tools` + system prompt).
- **MCP server:** `src/server.ts` (or `server.py`), tool/resource definitions, `package.json` /
  `pyproject.toml`, a `mcp.json` / install snippet, and `.mcp.json` registration example.
- **Agent app:** `src/agent.*`, a tool registry, a run loop, `.env.example` (keys, never the real `.env`).
- `evals/` — eval cases + a runner + a results log; this is non-optional here.
- `examples/` — sample invocations / transcripts showing the intended trigger and output.

## Stack defaults & done-bar
**Default stack:** skill/subagent = plain Markdown to kit conventions. MCP server = TypeScript on the
`@modelcontextprotocol/sdk` (Python `mcp` if the surrounding code is Python). Agent app = `@anthropic-ai/sdk`
with the newest capable model (default `claude-opus-4-8`, drop to `claude-sonnet-4-6` for cost/latency),
tool-use loop, prompt caching where it pays. Evals via `skill-creator`'s harness.

**"Finished/working" means** (checkable bar):
- **Skill/subagent:** triggers on the intended phrasing and stays quiet on near-misses (eval trigger-accuracy
  passes); frontmatter valid; body follows kit format.
- **MCP server:** starts; every tool validates against its schema and returns a correct smoke-test result in
  the Inspector; resources/prompts resolve; registration snippet works in a real client.
- **Agent app:** runs the loop end-to-end against the live API, calls tools correctly, handles errors/refusals.
- **Evals pass** (trigger accuracy + tool-call goldens + refusal cases) and are committed.
- `code-review` + `verify` clean; README shows install + one real example.

## Guardrails
- **Evals are the gate** — "it triggered once for me" is not done; prove it with the suite.
- **Least privilege** — give a skill/subagent/MCP only the tools it needs; document why each is granted.
- **Never hardcode or guess model ids/pricing/params** — read `claude-api`; default to the newest capable model.
- **Secrets never committed** — `.env.example` only; ask the user to supply real keys.
- **No emojis in any app/tool UI or output** (user's standing rule) — typographic symbols only.
- **Honest descriptions** — the description line must reflect what the tool actually does and fires on; no
  over-broad triggers that hijack unrelated requests.
- **Commits under the user's name only (Skryx-L-A); never add Claude as co-author.**
