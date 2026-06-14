# MEMORY POLICY — adaptive, auto-chosen

Pick the memory strategy yourself from the answers. Two building blocks:

- **Harness auto-memory** — the private per-project store at
  `~/.claude/projects/<project>/memory/` (one fact per file with frontmatter
  `type: user|feedback|project|reference`; one-line pointers in `MEMORY.md`). Lives **outside**
  any repo, so it never leaks into a public project.
- **In-repo project docs** — the shareable bible `PROJEKT_<NAME>.md` (+ type docs) committed
  with the project.

## Which strategy

| Situation | Strategy |
|---|---|
| **No repo** (local-only project) | **Memory only**: seed harness auto-memory. The bible still exists as a local file but isn't published. |
| **Repo exists** (public or private) | **Combined**: shareable facts → in-repo bible; private/durable facts (contacts, keys-context, personal preferences, business profile) → harness auto-memory. |
| **Existing business** | Link to the **shared business profile** (memory + `~/AI/_business/<name>/`); seed only project-specific deltas, don't duplicate the profile. |

## What to seed on scaffold (always)
Write these as auto-memory facts (verify-before-trust, convert relative dates to absolute):
- `type: project` — the goal, stack, scope, and the **key locked decisions** from the grill.
- `type: project` — where the project lives, repo URL/visibility, deploy target.
- `type: reference` — external resources (dashboards, tickets, accounts) the project uses.
- `type: feedback` — any working-style guidance the user gave during the grill (+ the why).
- Add a one-line pointer for each in the project's `MEMORY.md` index.

## Public-repo safety
For a **public** repo: never seed secrets or personal data into committed files. Anything
sensitive goes to harness auto-memory (private) or a `.gitignore`d local file — never the
bible, never `CLAUDE.md`. Cross-check the `.gitignore` before the first commit.
