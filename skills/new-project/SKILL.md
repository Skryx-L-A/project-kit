---
name: new-project
description: Stand up a brand-new project folder end-to-end — grill the plan to a full Definition of Ready, then auto-scaffold the perfect file/memory structure, project-specific sub-agents, and tooling for it. Use WHENEVER the user wants to start/create/set up a new project, a new project folder, a new repo, a new app/site/tool/business/research/anything — even if they only say "neues Projekt", "new project", "let's build X", "I want to start X", or "set up a folder for X". Run automatically at the very start of any new effort; the user should never have to point at this folder. Routes to type-specific sub-skills (build-business, website, api-backend, data-ml, quant-strategy, game-mod, game-dev, llm-app, hardware-embedded, creative-media, simulation, ecommerce-store, research-decision, content-writing, oss-library, browser-extension, bot-automation, saas, cli-tool, desktop-app, mobile-app, ai-agent-mcp) and a generic fallback.
---

# new-project — the project bootstrapper

You are standing up a **new project folder** for the user. This skill is the single,
self-contained operating manual for doing that perfectly, every time, in any session
(local **or cloud**), without the user having to explain the process.

**The user only has to say something like "neues Projekt" / "new project" / "let's build
X". You take it from there.** Drive the whole bootstrap autonomously; stop only at the
genuine decision points the Definition of Ready surfaces.

This kit is **extensible by design**: new sub-skills, skills, ultra-skills, agents, and
tools can be added at any time. See `docs/EXTENDING.md` at the kit root.

---

## The kit root

This skill is installed as a symlink into `~/.claude/skills/new-project`, but its real home
(with the CLI, docs, and all sibling sub-skills) is the **project-kit repo**. Locate it once
at the start, in this order, and remember the path as `KIT`:

1. `$PROJECT_KIT_HOME` if set.
2. `~/AI/project-kit` (the default).
3. `find ~ -maxdepth 4 -type d -name project-kit 2>/dev/null | head -1`.

Everything this skill needs (`templates/`, `policies/`, `scaffold.sh`) lives **inside this
skill folder**, so it works even if `KIT` cannot be found. `KIT` is only needed to reach the
type-specific sub-skills under `KIT/skills/<name>/` and the docs.

**Local grounding (optional, private):** if `KIT/local/GROUNDING.md` exists, read it — it maps
each sub-skill to the user's own real projects so you can tailor examples and conventions. It
is gitignored (never public); the committed sub-skills stay generic.

---

## The flow (run top to bottom)

### 0 — Pre-flight
- Confirm you are about to create a project, not edit an existing one. If the user pointed
  at an existing folder, ask whether to bootstrap *into* it or create a fresh one.
- New projects are created under `~/AI/<kebab-name>` unless the user says otherwise.

### 1 — GRILL FIRST (mandatory gate, never skip)
Run the **grill-me** discipline: interview the user relentlessly, **one question at a time,
each with a recommended answer**, walking down every branch of the decision tree, until the
**Definition of Ready is fully resolved**. Explore the codebase / web / the user's existing
projects to answer anything you can instead of asking.

- Read `DEFINITION_OF_READY.md` (in this folder) — that is the gate. Nothing gets built,
  no folder, no code, until every mandatory item is locked.
- The DoR is **Full+ and open-ended**: this is the most important moment of a project.
  Keep asking as new questions surface. Better to over-ask now than rework later.
- Use the `AskUserQuestion` tool for the interview where it fits (recommended option first,
  labelled "(Recommended)"); fall back to plain one-at-a-time questions otherwise.

### 2 — BUSINESS BRANCH (early DoR fork)
Early in the grill, resolve the project's relationship to a business. Read
`BUSINESS_BRANCH.md`. Four routes:
- **(a) New business** → load the `build-business` sub-skill (the 7-day system).
- **(b) Existing business** → **ask whether a business profile / memory / MD structure
  already exists and what to adopt** — never rebuild blindly. Link the project to the shared
  business profile (`~/.claude` memory + `~/AI/_business/<name>/`).
- **(c) Part of a business** (one feature/campaign) → scope to the component, inherit the
  profile's context.
- **(d) No business** → skip everything commercial.

### 3 — ROUTE & COMPOSE SUB-SKILLS
From the answers, detect **all** applicable project types and **stack** their sub-skills
(projects are hybrid — a SaaS pulls `website` + `api-backend` + `build-business`). Read
`ROUTING.md` for the type→sub-skill map and composition rules. Anything with no type match
uses `generic-project`. Load each matched sub-skill from `KIT/skills/<name>/SKILL.md` and
fold its extra grill-questions into step 1 and its deliverables into step 6.

### 4 — ENVIRONMENT READINESS
Read `ENVIRONMENT_READINESS.md`. Check that every tool/CLI/runtime/MCP the chosen stack and
sub-skills need is actually present, plus the user's available tools. For anything missing:
**point it out and offer to install it** (never auto-install). For anything needing a
secret/login/API key: **ask the user to log in or paste the key** — never invent or assume
credentials, never commit them.

### 5 — DECIDE STRUCTURE (adaptive, never ask the user the count)
- **Files:** apply `policies/file-policy.md` to auto-pick the right file set for this
  project's type and size. The user is **never** asked how many files.
- **Memory:** apply `policies/memory-policy.md` to auto-pick the memory strategy (harness
  auto-memory + seed always; combined in-repo + private when a repo exists; memory-only when
  there is no repo).

### 6 — BUILD PROJECT-SPECIFIC SUB-AGENTS (before any task starts)
Read `SUBAGENT_GENERATION.md`. Generate the project's own sub-agents into
`<project>/.claude/agents/` tailored to the stack and sub-skills, and wire them to
auto-load, so the project is **as ready as possible** before work begins.

### 7 — SCAFFOLD, THEN FILL
- Run `scaffold.sh` (in this folder) to lay down the deterministic skeleton + placeholder
  files chosen in step 5.
- Then **fill every placeholder** from the grilled DoR: `CLAUDE.md` (lean operating manual),
  `PROJEKT_<NAME>.md` (the project bible = the filled DoR), `TASKS.md`, `DONE.md`, plus any
  type-specific assets the sub-skills produce.
- Seed the memory per step 5.

### 8 — REPO (optional)
Repo choice (public / private / none) comes from the DoR. If a repo is wanted:
`git init`, write the project `.gitignore` (personal/secret files out), set the commit
identity to the user's own name (no AI co-author), first commit, and create the GitHub repo
**only after confirming with the user** (it is public and outward-facing).

### 9 — HANDOFF
Tell the user, in their own terms: what was created, the file/memory layout chosen and why,
which sub-skills/sub-agents were loaded, what is still flagged/unknown, and a concrete first
step. Drop a `TASKS.md §2` handoff so the next session resumes cleanly.

---

## Hard rules
- **Grill before build. Always.** No folder, no code, before the DoR is locked.
- **Adaptive, not interrogating:** decide file count and memory strategy yourself.
- **Never leak personal/secret data** into a public repo — `.gitignore` it.
- **Never auto-install or auto-credential** — point out, offer, and ask.
- **Honesty:** mark unverified claims (e.g. marketing numbers) as unverified; ground answers.
- **Extensible:** when the user wants a new project type, add a sub-skill (see `docs/EXTENDING.md`).
