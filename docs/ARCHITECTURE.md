# Architecture

## The idea
The setup *conversation* you'd otherwise repeat for every project is encoded as a repo.
A skill (`new-project`) is the entry point; the repo is its knowledge base.

## Flow
```
user: "neues Projekt"
        │
        ▼
 new-project (SKILL.md)  ── trigger (skill description) + ~/.claude/CLAUDE.md fallback entry
        │
        ├─ 1. GRILL  → DEFINITION_OF_READY.md   (gate: nothing builds until locked)
        ├─ 2. BUSINESS BRANCH → BUSINESS_BRANCH.md (new / existing / part / none)
        ├─ 3. ROUTE  → ROUTING.md → stack matching routes/<type>/SKILL.md (composable)
        ├─ 4. READINESS → ENVIRONMENT_READINESS.md (offer install / request keys)
        ├─ 5. STRUCTURE → policies/file-policy.md + policies/memory-policy.md (adaptive)
        ├─ 6. AGENTS → SUBAGENT_GENERATION.md → <project>/.claude/agents/
        ├─ 7. SCAFFOLD → scaffold.sh + templates/  → then FILL placeholders from the DoR
        ├─ 8. REPO (optional) → git init + .gitignore + GitHub (after confirm)
        └─ 9. HANDOFF → TASKS.md §2
```

## Why a skill + a repo (not just one)
- **Skill** = the trigger that works everywhere, including cloud sessions (skills are global,
  fire on their `description`).
- **Repo** = the single source of truth for the process, templates, policies, and all
  sub-skills — public, shareable, versioned. `install.sh` symlinks the `skills/` entries out
  of it so there's no drift.

## `skills/` vs `routes/`
Only the three entry-point skills (`new-project`, `email-manager`, `social-media-manager`)
live under `skills/` and get registered/symlinked — their `description` frontmatter is what
Claude Code loads into every session. The 24 type and operational sub-skills live under
`routes/` instead: `new-project` reads them by path (`KIT/routes/<name>/SKILL.md`), never
through the Skill tool, so registering them would only cost context (~3,400 tokens of
`description` fields) without adding a way to reach them. `install.sh` never touches
`routes/` — nothing to symlink there.

## Self-containment
`new-project/` carries everything it needs (templates, policies, scaffold.sh) so the symlinked
skill works without finding the repo root. The repo root is only needed to reach the type
sub-skills (under `routes/`) and docs.

## Composition
Routing stacks multiple sub-skills for hybrid projects; their grill-questions, sub-agents,
files, and deliverables merge (no duplication). The business branch is orthogonal to type.

## Adaptivity
File count and memory strategy are chosen by policy from type + size + repo presence — the
user is never asked a count.
