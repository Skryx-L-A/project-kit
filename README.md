# project-kit

**Say "new project". Get a perfectly-prepared project folder.**

project-kit is a self-contained bootstrap system for Claude Code. Tell any session — local or
cloud — *"neues Projekt" / "new project" / "let's build X"* and it runs one disciplined flow:

1. **Grills the plan** to a full **Definition of Ready** (the most important moment of a
   project) — one question at a time, each with a recommended answer, never building blind.
2. **Routes** the answers to the matching **type sub-skills** (and stacks several for hybrid
   projects).
3. **Checks the environment** — missing tools/CLIs get an install offer; missing keys/logins
   get a request. Never auto-installs, never invents credentials.
4. **Auto-picks the file & memory structure** by project type and size (you're never asked
   "how many files").
5. **Generates the project's own sub-agents** before any task starts.
6. **Scaffolds + fills** the folder, seeds memory, and (optionally) sets up the repo.

No more going through a setup conversation by hand every time. The process *is* the repo.

## Install

### Option A — as a Claude Code plugin (recommended: download & wire in two lines)
```
/plugin marketplace add Skryx-L-A/project-kit
/plugin install project-kit@project-kit
```
That clones the repo as a marketplace and wires **all** skills (and the `new-project`
orchestrator) into Claude automatically — nothing to symlink. Update later with
`/plugin marketplace update project-kit`; remove with `/plugin uninstall project-kit`.

### Option B — script install (no plugin system / dev use)
```bash
git clone https://github.com/Skryx-L-A/project-kit ~/AI/project-kit   # or wherever
cd ~/AI/project-kit && ./install.sh
```
Symlinks every skill into `~/.claude/skills/` (repo stays the single source of truth) and links
the `project-kit` CLI. `--copy` to copy instead, `--force` to overwrite, `--no-claude-md` to
skip the optional global trigger entry, `--uninstall` to remove.

> Use **one** install path, not both — the plugin and the symlinks would otherwise register the
> same skills twice. If you installed via `install.sh` and switch to the plugin, run
> `./install.sh --uninstall` first.

## Use
Just tell Claude:
> neues Projekt — ich will <X> bauen

…and let it grill + scaffold. Or use the manual CLI fallback:
```bash
project-kit new --name "My Thing" --tier standard --git
project-kit list      # show the type sub-skills
```

## The sub-skills
`build-business` (the 7-day business ultraskill) · `website` · `saas` · `api-backend` ·
`data-ml` · `quant-strategy` · `cli-tool` · `desktop-app` · `mobile-app` · `browser-extension`
· `bot-automation` · `ai-agent-mcp` · `oss-library` · `game-mod` · `research-decision` ·
`content-writing` · `generic-project` (fallback for anything else).

Projects are **composable** — a SaaS that must make money pulls `saas` + `website` +
`api-backend` + `build-business`.

## Per-project structure it produces
The user's proven system, scaled to project size:
`CLAUDE.md` (lean, auto-loaded) · `PROJEKT_<NAME>.md` (the bible = filled Definition of
Ready) · `TASKS.md` · `DONE.md` · `README.md` · `.claude/` (hooks + project sub-agents);
`STATUS.md` + `DEPLOYMENT.md` for large projects; type-specific assets on top.

## Memory & privacy
Private/durable facts → harness auto-memory (outside any repo). Shareable facts → the in-repo
bible. Personal/secret data is **`.gitignore`d** and never committed — safe for public repos.

## Extensible by design
New project types, skills, ultra-skills, and agents drop in anytime — see
[`docs/EXTENDING.md`](docs/EXTENDING.md). Architecture: [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md).

## Layout
```
project-kit/
├── .claude-plugin/       # plugin + marketplace manifests (download & wire via /plugin)
├── install.sh            # script-install fallback (symlink into ~/.claude/skills)
├── bin/project-kit       # manual CLI fallback
├── skills/
│   ├── new-project/      # the orchestrator: DoR, routing, policies, templates, scaffold.sh,
│   │   └── agent-templates/   #   reusable sub-agent templates (specialised per project)
│   ├── build-business/   # the 7-day business ultraskill (system, prompts, rubric, merged)
│   └── <type>/SKILL.md   # one sub-skill per project type
└── docs/                 # ARCHITECTURE, EXTENDING, CONTRIBUTING
```

## Credits & honesty
The `build-business` ultraskill operationalises the framework from JP Middleton's *"How to
start a 1-person business using Claude in 7 days"* and merges public founder/startup skill
repos (credited in `skills/build-business/merged/SOURCES.md`). Marketing/revenue claims from
the source are flagged as **unverified** throughout.

MIT licensed. Built in the open so anyone can clone and use it.
