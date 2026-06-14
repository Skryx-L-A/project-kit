---
name: game-mod
description: Build and set up a game-mod project — a mod, patch, total conversion, or tweak for a specific game and engine, shipped through a mod loader and deployed to a real game install. This is a project-kit sub-skill loaded by new-project routing. Use WHENEVER the user wants to mod, patch, hack, retexture, rebalance, or extend a game, especially on Linux via Proton with a loader like UE4SS or Smithbox.
---

# game-mod — mods, patches, and total conversions for a specific game

This sub-skill stands up a **game-mod** project: a change to an existing game, packaged for its
mod loader and deployed into a real install. It mirrors common setups — e.g. **Elden Ring**
(Smithbox + Seamless Co-op on Linux; the row-name-strip gotcha; specific deploy paths) and the
**Gothic 1 Remake** (UE5.4, Proton-launched, UE4SS loader — which silently fails to load unless
`WINEDLLOVERRIDES="dwmapi=n,b"` is set). Linux + Proton + loader quirks are first-class concerns,
and **backing up saves and game files before any deploy** is non-negotiable.

---

## What this sub-skill is for
A mod for one named game + engine: balance tweaks, retextures, new items/quests, scripts, or a
total conversion — distributed via that game's mod loader and dropped into the game's mod folder.
Not for standalone games (those are their own project), not for engine/tooling work unrelated to a
shipping game. It composes with `cli-tool` if the mod needs a build/deploy script, and with
`content-writing` if it ships substantial lore/dialogue.

## Mandatory grill-questions (fold into the Definition of Ready)
Lock these before touching any game file:
- **Game + version + engine** — exact title, build/patch number, engine (e.g. UE5.4, FromSoft
  formats). Mods are version-fragile; pin the version now.
- **Mod loader / toolchain** — which loader, and is it installed? (UE4SS, Smithbox, BepInEx,
  Reframework, Vortex/MO2, native). **Default to the loader the user already runs for this game.**
- **Platform & launcher** — Linux/Proton (the common default here), native Linux, or Windows? Which
  Proton/GE build? Record the prefix path.
- **Loader gotchas** — capture them explicitly: UE4SS needs `WINEDLLOVERRIDES="dwmapi=n,b"` or it
  won't load; Smithbox strips row names on save (re-add them); per-game load order rules. Write
  these into `CLAUDE.md` so no session rediscovers them.
- **Deploy path** — the exact game/mods directory inside the Proton prefix or native install. Get
  the real path, do not guess.
- **What the mod does — scope in/out** — the concrete change set for v1 and what's explicitly out.
- **Online/multiplayer & anti-cheat** — does it touch online play (e.g. Seamless Co-op)? Flag
  ban/anti-cheat risk and EAC-off requirements up front.
- **Backup plan** — confirm saves + original game files (and a clean prefix snapshot) are backed
  up before the first deploy. This is a gate, not a suggestion.
- **Distribution** — private/personal only, or shared (Nexus/GitHub release)? Drives licensing
  and asset-provenance care.

## Project sub-agents to generate (into `<project>/.claude/agents/`)
- **`mod-deployer`** *(delegate-by-default)* — backs up saves + game files first, then builds and
  copies the mod into the real deploy path with the correct load order; sets/records required env
  (e.g. `WINEDLLOVERRIDES`); never deploys without a verified backup.
- **`compat-checker`** *(delegate-by-default)* — validates engine/loader/Proton compatibility,
  knows the per-game gotchas (UE4SS dwmapi override, Smithbox row-name strip), checks load-order
  conflicts with other installed mods, and flags game-version mismatches.
- **`asset-editor`** — handles the game-specific formats (param/regulation files, textures,
  scripts) safely, preserving names/IDs the tooling tends to drop.
- Plus the kit defaults: `reviewer` (diff/PR) and `verifier` (here = launches the game and
  confirms the mod actually loads in-game without crashing).

## Tools / CLIs / MCP / skills needed
Check in environment-readiness; offer install, never auto-install:
- **The game's mod loader + editor** — UE4SS, Smithbox, BepInEx, Reframework, etc. Verify it's
  installed and on the right version for the game build.
- **Proton / Wine tooling** — `protontricks`, the GE-Proton build, the prefix path; the
  `WINEDLLOVERRIDES` env for UE4SS-class loaders. Confirm the launcher (Steam/Heroic) injects it.
- **Backup tooling** — `rsync`/`tar` snapshots of saves + game dir + prefix before deploy; a
  documented restore command.
- **Format tools** — texture/converter/unpacker CLIs specific to the engine (e.g. UE pak tools,
  FromSoft format tools). Flag anything missing.
- **CHAIN global skills:** `deep-research` (find the exact loader/gotcha for an unfamiliar game),
  `verify` (launch the game to confirm load), `code-review`, `cli-anything` (wrap a GUI mod tool
  into a scriptable CLI), `doc-coauthoring` (install/usage README), `update-config`
  (permissions/hooks for the deploy + env commands).

## File / asset nudges (on top of the base set)
Beyond CLAUDE.md, PROJEKT_<NAME>.md, TASKS.md, DONE.md, README, `.claude/`:
- `mod/` — the mod source/assets (scripts, params, textures), engine-organised.
- `deploy/` — a deploy script + an `env.sh` carrying the required overrides (e.g.
  `WINEDLLOVERRIDES`), and the recorded real deploy path.
- `backups/` — `.gitignore`d save/game-file snapshots + a restore script; an `BACKUP.md`
  documenting what's backed up and how to roll back.
- `GOTCHAS.md` — the per-game loader quirks (UE4SS dwmapi, Smithbox row-name strip, load order),
  so they're never rediscovered the hard way.
- `INSTALL.md` — install the loader, set env, deploy, and uninstall/restore steps for the user.

## Stack defaults & done-bar
**Defaults:** Linux + Proton (GE) launch, the user's existing loader for that game, env overrides
recorded in `deploy/env.sh`, mandatory pre-deploy backup, mod source versioned in git, big binary
assets `.gitignore`d unless distribution requires them. Pin the game build version everywhere.
**Done-bar (all true):** original saves + game files are backed up with a tested restore; the mod
**loads in-game on the real install without crashing**, verified by actually launching the game;
the intended change is observable in-game; no anti-cheat/online violation if online play is in
scope; `GOTCHAS.md` + `INSTALL.md` are accurate enough for a clean re-deploy from scratch.

## Guardrails
- **Back up before every deploy** — saves, original game files, and (ideally) a prefix snapshot.
  Never write into a game install without a verified, restorable backup. This is the top rule.
- **Honesty about "it works":** don't claim the mod loads until `verifier` has launched the game
  and seen it load. Report crashes, missing-load (silent UE4SS failure), and version mismatches
  plainly instead of assuming success.
- **Anti-cheat / ban risk:** if the mod touches online play, state the ban/EAC risk explicitly and
  do not enable online unless the user confirms; mirror the Seamless Co-op caution.
- **Respect the loader's quirks** — set `WINEDLLOVERRIDES` for UE4SS, re-add Smithbox row names,
  honour load order. Record each gotcha in `GOTCHAS.md`.
- **Asset provenance & licensing** — for shared mods, verify you may redistribute every asset;
  don't ship copyrighted game assets you can't redistribute. Record provenance.
- **No emojis in any tool/UI output** the mod surfaces (user's standing rule).
- **Commits under the user's own name only (Skryx-L-A); never add Claude as a co-author.**
