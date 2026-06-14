---
name: bot-automation
description: Build/set up a bot or automation project — a Discord/Telegram bot OR a workflow automation (n8n, cron, scheduler) — from the user's grilled answers. Project-kit sub-skill loaded by new-project routing whenever someone wants to build a bot, automate a workflow, schedule a recurring job, wire up event triggers, or connect services. Chains the n8n MCP for workflow builds and bakes in hosting (always-on vs cron), secret handling, and a runs-on-schedule done-bar.
---

# bot-automation — the bot / workflow-automation builder sub-skill

## What this sub-skill is for
Standing up something that **runs on its own**: a chat **bot** (Discord/Telegram) that responds to
commands and events, or a **workflow automation** (n8n flow, cron job, or scheduler) that fires on a
trigger and does work without a human in the loop. The two share the same spine — triggers, a handler,
secrets, and a place to keep running — so this one sub-skill covers both and asks which.

## Mandatory grill-questions (fold into the Definition of Ready)
Lock these before any code:
- **Platform** — Discord bot / Telegram bot / n8n workflow / plain cron-or-scheduler script? (or a combo,
  e.g. a bot that also runs scheduled jobs.)
- **Triggers & events** — what fires it? Slash/command messages, reactions, joins (bots); webhook, schedule,
  inbound email, DB change (workflows). List every event it must handle.
- **Actions** — what does it do per trigger, and which external services/APIs does it touch?
- **Hosting model** — **always-on** (a long-lived process: needs a host — VPS, container, systemd user
  service, or n8n instance) vs. **scheduled/cron** (wakes, runs, exits). This drives the whole deploy shape.
- **Secrets** — bot tokens, API keys, webhook secrets. Where do they live? (env / secret store — never the repo.)
- **State** — stateless, or does it need a store (file, SQLite, Supabase/Postgres) for queues, dedupe, memory?
- **Rate limits & idempotency** — platform limits respected? Re-delivered events safe to re-run?
- **Permissions/scopes** — Discord intents / Telegram bot scopes / OAuth scopes kept minimal.

## Project sub-agents to generate (into `.claude/agents/`)
- **workflow-builder** *(delegate-by-default)* — builds n8n workflows via the n8n MCP, following its mandated
  order; validates before saving. (See the n8n chain below.)
- **bot-command-handler** *(delegate-by-default)* — implements bot commands/event handlers, registers slash
  commands, handles errors and rate limits, keeps replies clean (no emojis).
- **scheduler** — sets up cron/schedule triggers and the always-on-vs-cron deploy (systemd user unit, container,
  or n8n schedule node); chains `update-config` for any local hooks.
- **integration-tester** — drives a trigger end-to-end and asserts the action happened (message sent / row
  written / webhook delivered).

## Tools / CLIs / MCP / skills needed
Check in environment-readiness; offer install, never auto-install:
- **n8n MCP (chain this for any workflow build)** — follow its required order: `get_sdk_reference` →
  `get_suggested_nodes` → `search_nodes` → `get_node_types` (exact params) → write code → `validate_workflow`
  → `create_workflow_from_code` → `update_workflow`. Do not guess SDK/node params; read the reference first.
- **Bots:** Node 20+ (`discord.js`, `telegraf`/`grammy`) or Python (`discord.py`, `python-telegram-bot`).
  Register the bot in the platform's dev portal; the user pastes the token.
- **Scheduling:** system `cron`, a `systemd` user timer (matches the user's existing service pattern), or n8n's
  schedule trigger for always-on n8n.
- **MCP to chain:** `n8n` (workflows), `Supabase` (state/queue/dedupe store), `claude-in-chrome` / `playwright`
  (browser-driven steps a workflow can't reach via API).
- **CHAIN these GLOBAL skills:** `update-config` (hooks / scheduled-agent wiring), `cli-anything` if it must
  drive a GUI tool headlessly, `claude-api` if a handler/workflow calls Claude (read it before any model id),
  `verify` + `code-review` before "done".

## File / asset nudges (on top of the base set)
Beyond CLAUDE.md, PROJEKT_<NAME>.md, TASKS.md, DONE.md, README, `.claude/`:
- `.env.example` — every secret named (token, API keys, webhook secret); real `.env` is gitignored, never committed.
- **Bots:** `src/bot.*`, `src/commands/` (one file per command/handler), command-registration script.
- **n8n:** `workflows/<name>.json` export(s) + a notes file recording the node IDs/params used, so a flow can
  be rebuilt or version-controlled.
- **Cron/scheduler:** the script + a `*.service`/`*.timer` unit (or crontab line) + a deploy note.
- `runbook.md` — how to start/stop/restart, where logs go, how to rotate the token.
- `state/` or a Supabase schema if a store was chosen; `logs/` (gitignored).

## Stack defaults & done-bar
**Default stack:** Discord/Telegram bot → Node 20 + `discord.js`/`grammy`, slash commands, run as a long-lived
**systemd user service** (the user's standing pattern). Workflow → **n8n** built through its MCP (validated +
published), or a Python/Node script on a **systemd timer / cron** for simple scheduled jobs. Secrets in env;
state in SQLite or Supabase when needed.

**"Finished/working" means** (checkable bar):
- **Bot:** logs in, registers its commands, and **responds correctly** to each defined command/event in a live
  test; handles an unknown command and a rate-limit gracefully.
- **Workflow:** `validate_workflow` passes, the flow is created/published in n8n, and a manual `execute_workflow`
  produces the expected action.
- **Schedule:** the cron/timer/schedule trigger is installed and **actually fires** (verified by a real run, not
  just a config that looks right).
- Secrets load from env (not hardcoded); restart/runbook works; an end-to-end trigger→action test passes.

## Guardrails
- **Tokens/keys are secrets** — env or secret store only; ask the user to supply them; never invent, never commit.
  A leaked bot token = account takeover.
- **Minimal scopes/intents** — request only the Discord intents / Telegram / OAuth scopes the actions need.
- **Idempotency & rate limits** — handle re-delivered events without duplicate side-effects; respect platform limits.
- **No spam / compliance** — outbound messaging (DMs, broadcasts, email steps) must respect opt-out and platform
  ToS; don't build mass-DM or scraping bots that violate terms.
- **Validate before deploy** — never publish an unvalidated n8n workflow or push an untested handler live.
- **No emojis in bot replies or output** (user's standing rule) — typographic symbols only.
- **Commits under the user's name only (Skryx-L-A); never add Claude as co-author.**
