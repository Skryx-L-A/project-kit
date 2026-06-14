---
name: generic-project
description: The FALLBACK project-kit sub-skill loaded by new-project routing for ANY project with no specific type match — life-admin, an event, a hardware build, a personal system, a one-off, whatever. Use WHENEVER the user wants to start, set up, organise, or run a project that doesn't fit website / app / API / data / business / research / writing / game-mod / any other type. Makes zero code or business assumptions.
---

# generic-project — the catch-all fallback for anything

This sub-skill is the **fallback**: it runs when no specific type matches. It makes **no
assumptions** about code, a business, a stack, or a deliverable. It could be a hardware build, an
event, a move, a life-admin system, a personal automation, a hobby project — anything. Its job is
to give *any* project the kit's spine — a Definition of Ready, adaptive files, a memory seed, and a
basic review/verify safety net — without forcing a shape the project doesn't have.

---

## What this sub-skill is for
Truly anything with no clearer type: organising an event, planning a build, a personal system, a
research-free decision, a logistics project, a hobby. If a more specific sub-skill fits even
partially, route there instead (or compose) — `generic-project` is only for the genuine remainder.
It stays deliberately general so it never imposes engineering or marketing structure that doesn't
apply.

## Mandatory grill-questions (fold into the Definition of Ready)
Keep these general — adapt wording to whatever the project actually is:
- **What is this, in one sentence** — what the project is and why it exists, for a stranger.
- **The user's own done-bar** — what "finished / working / handled" means *to the user*. This
  project's done-bar is whatever the user states; pin it precisely. **Recommend making it concrete
  and checkable.**
- **Who it's for / who's involved** — audience, stakeholders, or just the user.
- **Deliverables & artifacts** — what tangible things come out (a plan, a built object, an event, a
  set of documents, a habit) — drives which files to create.
- **Constraints & deadlines** — time, money, space, legal, physical, dependencies on others.
- **Steps / phases** — the rough sequence from zero to the user's done-bar.
- **What's explicitly out of scope** — to keep the project bounded.
- **Decision points** — branches the user wants to think through (offer to chain `grill-me` or
  `council` for the real ones).

## Project sub-agents to generate (into `<project>/.claude/agents/`)
Minimal and general — no domain agents unless the project clearly grows one:
- **`reviewer`** *(delegate-by-default)* — reviews whatever artifacts the project produces (docs,
  plans, configs, files) for correctness, consistency, and gaps against the stated done-bar; adapts
  to the medium rather than assuming code.
- **`verifier`** — checks that the project actually meets the **user's own done-bar**: confirms the
  deliverables exist, are correct, and the stated finish condition is genuinely met (running an app
  *only if* there is one; otherwise checking the real-world outcome).
- Add a purpose-built agent only if a real sub-domain emerges during grilling; otherwise keep it to
  these two and stay light.

## Tools / CLIs / MCP / skills needed
Almost nothing is assumed — pull tools in only as the project reveals a need:
- **Document tooling** *(if the project produces documents)* — `pdf` / `docx` / `xlsx` / `pptx` as
  the format requires; `doc-coauthoring` for any structured writing.
- **CHAIN global skills opportunistically, not by default:**
  - `grill-me` — for a project with real unresolved decisions/branches.
  - `deep-research` — if any part needs sourced facts.
  - `council` — for a genuine high-stakes tradeoff.
  - `verify` — if there's anything runnable to confirm.
- Check environment-readiness only for tools the project actually turns out to need; offer install,
  never auto-install. Don't provision a stack the project doesn't have.

## File / asset nudges (on top of the base set)
Beyond CLAUDE.md, PROJEKT_<NAME>.md, TASKS.md, DONE.md, README, `.claude/` — keep it adaptive and
minimal; create only what the project actually needs:
- `NOTES.md` — a catch-all working log / scratch space for an open-ended project.
- `assets/` or `files/` — only if the project has real artifacts/attachments.
- `decisions.md` — a lightweight log if the project has branches worth recording.
- Domain folders **only when warranted** (e.g. `parts/` for a hardware build, `agenda/` for an
  event). Do not pre-create folders the project may never use — let structure follow the work.

## Stack defaults & done-bar
**Defaults:** intentionally none — no language, no framework, no business assumptions. The base
file set + a memory seed (goal, key decisions, constraints) + the two general agents, then shape
everything else to the actual project. Reach for a more specific sub-skill the moment the project
reveals a matching type.
**Done-bar:** **the user's own stated done-bar, verbatim** — there is no built-in finish line for a
catch-all project. Pin it as concretely and checkably as the user will allow during grilling, then
`verifier` confirms exactly that condition (and nothing it invented).

## Guardrails
- **Make no assumptions** — don't assume code, a repo, a business, a stack, or a deliverable shape;
  ask or infer from the project, never impose a template.
- **The done-bar is the user's** — never substitute your own notion of "done"; if it's vague, push
  to make it concrete, but it remains theirs.
- **Stay light** — create only the files, agents, and tools the project genuinely needs; resist
  gold-plating an open-ended project into something heavier than it is.
- **Honesty over optimism** — report real status and gaps; don't claim a non-code outcome is "done"
  without checking the actual real-world condition.
- **Route away when a type appears** — if a real type emerges mid-project, switch to or compose the
  matching sub-skill instead of forcing it through the generic path.
- **No emojis in any output/UI** (user's standing rule).
- **Commits (if any repo) under the user's own name only (Skryx-L-A); never add Claude as a co-author.**
