# Extending project-kit

Extensibility is a first principle: new sub-skills, ultra-skills, agents, and tools drop in at
any time. Nothing here is closed.

## Add a new project-type sub-skill
1. Create `skills/<new-type>/SKILL.md` with frontmatter (`name: <new-type>`, a trigger-rich
   `description`) and the standard body sections:
   - **What this sub-skill is for**
   - **Mandatory grill-questions** (folded into the Definition of Ready)
   - **Project sub-agents to generate**
   - **Tools / CLIs / MCP / skills needed** (for environment readiness + chaining)
   - **File / asset nudges**
   - **Stack defaults & done-bar**
   - **Guardrails**
2. Add a row to `skills/new-project/ROUTING.md` (type → sub-skill) and, if it has structural
   file needs, a nudge in `skills/new-project/policies/file-policy.md`.
3. Run `./install.sh --force` to (re)link it. Done — `new-project` will route to it.

> Orient new types on the user's real projects and what would have made them easy to start.
> When a project type recurs, make it a sub-skill instead of re-improvising.

## Add an "ultra-skill" (a deep, merged sub-skill)
Follow `build-business` as the template: a `SKILL.md` orchestrator plus subfolders
(`system/`, `prompts/`, `rubrics/`, `merged/`, `assets/`). Research and **merge** the best
public skills/repos and any source material (video transcript, articles), keep a
`merged/SOURCES.md` crediting everything, and flag unverified claims. Build it once, deeply.

## Add reusable agent templates
Drop a `<name>.md` (frontmatter `name`/`description`/`tools` + system prompt) into `agents/`.
The `new-project` flow specialises these into a project's `.claude/agents/`.

## Conventions
- Keep every `SKILL.md` self-contained enough to symlink into `~/.claude/skills/` alone.
- Use **real** tool/skill/agent/MCP names that exist in the environment when chaining.
- Honour the user's standing rules: no emojis in app UIs; commits under the user's own name
  only (no AI co-author); never commit secrets/personal data (especially in a public repo).
- Keep the main `new-project/SKILL.md` lean — push detail into reference files it points to.

## Roadmap (open)
- More type sub-skills oriented on the user's projects (e.g. hardware/IoT, video/media,
  e-commerce store, course platform).
- Per-type reusable agent libraries.
- A richer business-profile schema under `~/AI/_business/<name>/`.
