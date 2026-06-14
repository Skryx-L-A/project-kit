---
name: cli-tool
description: Build and set up a command-line tool project — a clean CLI with subcommands, --help, and proper exit codes, a real test suite, and a pip/npm publish path. This is a project-kit sub-skill loaded by new-project routing. Use WHENEVER the user wants to build, create, or ship a CLI, a command-line tool, a terminal utility, a dev tool, or a binary/script that's run from the shell and (optionally) published to PyPI or npm.
---

# cli-tool — command-line tools

This sub-skill stands up a **command-line tool** with a clean, predictable UX (subcommands,
`--help`, sane exit codes), a genuine test suite, and a publish path to PyPI or npm. It follows
the pattern of small, well-named launcher CLIs that install via pip/npm and just work on PATH.
When the tool is meant for the public, it composes with the `oss-library` sub-skill.

---

## What this sub-skill is for
A program invoked from the shell: a one-shot command, a multi-subcommand tool, or a daemon/CLI
hybrid. Use it for dev tools and terminal utilities; not for GUI apps (`desktop-app`), web UIs
(`website`), or backends (`api-backend`). Pairs with `oss-library` for public packages and with
`cli-anything` when the goal is to wrap an existing GUI app into an agent-drivable CLI.

## Mandatory grill-questions (fold into the DoR)
1. **Language/ecosystem** — Python (Click/Typer, pip) or Node (Commander/oclif/yargs, npm).
   **Recommended: Python + Typer** for a fast, ergonomic CLI, unless the target users live
   in npm. Lock this first.
2. **Command name & shape** — the binary name (short, memorable) and whether
   it's single-command or has subcommands (`tool sub --flag`). Confirm the name is free on PyPI/npm.
3. **CLI UX contract** — global flags (`--help`, `--version`, `--quiet`, `--json`), exit-code
   convention (0 ok, non-zero per failure class), and whether output is human-readable, JSON, or both.
4. **Distribution** — published to PyPI/npm, or a standalone single-file binary (PyInstaller /
   `pkg` / Bun)? If public, this composes `oss-library`. Decide the version scheme (SemVer).
5. **Config & state** — does it read config/env/stdin? Where does config live (XDG / `~/.config`)?
   Does it need network/API keys (then env-var or keyring, never hard-coded)?
6. **Test strategy** — pytest (Python) or jest/vitest (Node); how subcommands and exit codes get
   asserted; whether a CI matrix across OSes/versions is needed.
7. **Distribution & support OSes** — Linux/macOS/Windows; shell-completion scripts wanted?

## Project sub-agents to generate (`<project>/.claude/agents/`)
- **`cli-ux-reviewer`** *(delegate-by-default)* — audits help text, flag/subcommand consistency,
  exit codes, error messages, and `--json` output; enforces the UX contract above.
- **`release-engineer`** *(delegate-by-default)* — bumps the version, builds the wheel/sdist or
  npm tarball, publishes to PyPI/npm, tags + cuts a GitHub Release; never invents version numbers.
- **`docs-writer`** *(delegate-by-default)* — keeps README usage, the man-page/`--help` text, and
  the changelog in sync with the actual commands.
- **`test-author`** — writes/extends pytest|jest coverage for new subcommands, flags, and exit codes,
  and runs them green before reporting done.
- Plus the kit defaults: `reviewer` (diff/PR) and `verifier` (runs the CLI end-to-end).

## Tools / CLIs / MCP / skills needed
- **Python path:** `python` + `pip`/`pipx`, a CLI lib (Typer/Click), `pytest`, `build` + `twine`
  for publishing; `pyinstaller` if shipping a binary. Check in environment-readiness.
- **Node path:** `node` + `npm`/`pnpm`, Commander/oclif/yargs, jest/vitest, `npm publish`; `pkg`/Bun
  for a single-file binary.
- **Release:** `gh` for GitHub Releases; PyPI/npm tokens supplied by the user (never fabricated).
- **CHAIN global skills:** `oss-library` sub-skill (mandatory if public — license, README, CI,
  publish hygiene), `cli-anything` (if wrapping an existing GUI into a CLI), `verify` (run the CLI),
  `code-review`, `doc-coauthoring` (README/usage docs), `update-config` (allow the test/publish commands).

## File / asset nudges (on top of the base set)
- `src/<pkg>/cli.py` (or `bin/<tool>.js`) — the entrypoint with subcommands wired to `--help`/exit codes.
- `pyproject.toml` (with `[project.scripts]`) **or** `package.json` (with `bin`) — the console-script mapping.
- `tests/` — pytest|jest suite asserting commands, flags, and exit codes; a CI workflow to run it.
- `USAGE.md` (or man page) + a `CHANGELOG.md` (Keep-a-Changelog) — kept in sync with the commands.
- `completions/` — optional bash/zsh/fish shell-completion scripts.
- `.github/workflows/` — test on PRs + publish on tag.

## Stack defaults & done-bar
**Default stack:** Python 3.12 + Typer, `pyproject.toml` console-script, pytest, GitHub Actions
(test + publish on tag), PyPI distribution — i.e. the small, well-named launcher-CLI pattern.
(Switch to Node/Commander if the audience is npm.)
**Done-bar (all true):** `tool --help` and `tool --version` work; every subcommand has help and the
right exit code (0 success, non-zero on failure); the test suite passes in CI; a fresh
`pip install`/`npm install` puts the command on PATH and it runs; `--json` output (if promised) is
valid; README/usage and changelog match the real commands; a tagged GitHub Release (and PyPI/npm
publish, if public) has gone out end-to-end.

## Guardrails
- **No emojis in CLI output** — typographic symbols only; keep stdout machine-parseable and stderr for diagnostics.
- **Exit codes are a contract:** never exit 0 on failure; document each non-zero code.
- **Never hard-code or commit API keys/tokens** — read from env/keyring; `.gitignore` secrets; ask the user to supply publish tokens.
- **Don't claim it's published until `release-engineer` confirms** the package is live and `pip/npm install` actually resolves it.
- **Commit under the user's own name only (Skryx-L-A)** — never add Claude as a co-author.
- **Respect SemVer** — breaking flag/subcommand changes are a major bump; note them in the changelog.
