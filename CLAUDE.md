# project-kit — Claude instructions

Public Claude Code plugin (github.com/Skryx-L-A/project-kit): the `new-project`
bootstrapper + 26 type sub-skills + build-business. On this Mac the LIVE install path
is the **plugin** (marketplace, auto-installed via settings.json) — never run
`install.sh` here (Linux-era symlink installer; plugin supersedes it).

## Working in this repo
- This repo is the source of truth for skill content; the plugin cache
  (`~/.claude/plugins/cache/project-kit/...`) is a copy — edit HERE, never the cache.
- After changes: bump VERSION + CHANGELOG.md, commit as Skryx-L-A (English, no
  co-author trailer). A push updates what the marketplace serves.
- Keep committed skills GENERIC — personal project examples belong ONLY in
  `local/GROUNDING.md` (gitignored). Never leak project names, hosts, or paths from
  there into committed files.
- Skills must stay self-contained (templates/policies/scaffold inside the skill
  folder) and cross-platform (no Linux-isms: no `readlink -f`, no /home paths).
- Test changes by triggering the skill (e.g. `new-project` on a throwaway) before
  committing — done-bar is "triggers + scaffolds correctly", not "reads well".

## Knowledge base
Vault branch: `~/Knowledge/20-projects/project-kit/`. Search before bigger changes;
distill session results there after.
