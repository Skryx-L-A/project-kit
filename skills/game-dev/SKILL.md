---
name: game-dev
description: Build/set up a game project FROM SCRATCH — a 2D or 3D game in Godot, Unity, Unreal, or the web (Phaser/Three.js) — from the user's grilled answers. Project-kit sub-skill loaded by new-project routing whenever someone wants to build, make, or prototype a game, a playable demo, or a game loop. Chains higgsfield for assets/audio/browser-game generation and magic for menus/UI, and bakes in a playable-vertical-slice done-bar.
---

# game-dev — build a playable game from scratch

## What this sub-skill is for
Standing up a **new game built from nothing**: a real engine project with a playable core loop,
art/audio pipeline, and a build that runs on the target platform. Loaded by `new-project` for any
"make a game / prototype this idea / build a playable demo" request. This is distinct from
`game-mod` (modding an *existing* game's install). The whole skill is organized around one idea:
**ship a small, playable slice before scaling scope** — a game you can actually play beats a
beautiful engine project that never reaches a loop.

## Mandatory grill-questions (fold into the Definition of Ready)
Lock these before opening the engine:
- **Engine + why** — Godot (open, fast 2D/3D, default), Unity (asset ecosystem/mobile), Unreal
  (high-end 3D), or web (Phaser for 2D, Three.js/Babylon for 3D, ships in a browser). Pick from
  scope + target, not familiarity alone; justify it.
- **2D vs 3D** — decides art pipeline, physics, and team-of-one feasibility. 3D triples scope.
- **Genre + the core loop** — name the genre and the one verb-loop the player repeats (move-shoot,
  match-clear, build-defend). Everything else is decoration until the loop is fun.
- **Scope / MVP** — what the **vertical slice** is: one level, one mechanic, one enemy, win+lose.
  Cut everything not in the slice. What's explicitly out of v1?
- **Target platform** — PC (Win/Linux/macOS), web, mobile (iOS/Android), or console? Drives the
  engine export and input model. Pick one to ship first.
- **Art pipeline** — own art, asset-store/licensed, or AI-generated (higgsfield)? Resolution,
  style, and whether sprites/models are placeholder-now / final-later.
- **Audio** — music + SFX source (own, licensed, higgsfield `generate_audio`)? Even placeholder.
- **Multiplayer?** — single-player first almost always; if multiplayer is core, name the model
  (local, P2P, authoritative server) — it is a scope multiplier, flag it loudly.
- **Save/progression + monetization** — needed for v1 or deferred? Don't build economy before loop.

## Project sub-agents to generate (into `<project>/.claude/agents/`)
- **`gameplay-loop-builder`** *(delegate-by-default)* — implements and tunes the core loop
  (input → state → feedback), keeps the slice playable every commit, resists feature creep.
- **`asset-pipeline`** *(delegate-by-default)* — generates/imports/optimizes sprites, models,
  audio, and atlases into the engine's import settings; chains the higgsfield skills; tracks
  asset provenance/licensing.
- **`level-designer`** — builds the slice's level(s)/scenes, tuning pacing, difficulty, and
  spawn/encounter layout against the loop.
- **`playtest-runner`** — builds for the target platform, launches the game, plays the loop, and
  reports crashes, soft-locks, and broken interactions honestly (this is the `verifier` role).
- Plus the kit default `reviewer` (diff/PR correctness).

## Tools / CLIs / MCP / skills needed
Check in environment-readiness; offer install, never auto-install:
- **The engine** — Godot (single binary, easiest on Linux), Unity Hub + editor, Unreal (heavy),
  or Node + a web bundler (Vite) for Phaser/Three.js. Verify it launches and can export.
- **Export/build toolchain** — Godot export templates; platform SDKs for mobile/console; for web,
  a static bundle. Confirm a build for the *target* platform actually produces a runnable artifact.
- **CHAIN the higgsfield MCP + skills** for the asset pipeline: `higgsfield-generate`
  (`generate_image` for sprites/textures/concept art, `generate_video` for cutscenes/trailers,
  `generate_audio` for music/SFX), `higgsfield-soul-id` for a consistent character face, and for a
  *browser* game the game-creation flow — `get_game_creation_instructions` then
  `get_game_creation_bundle_file`, with `deploy_game` / `publish_game` to ship it.
- **CHAIN the magic MCP** (21st.dev) for menus, HUD, and UI screens; `framer-inspiration` /
  `design-harvest` for the marketing/landing page if the game ships with a site.
- **CHAIN global skills:** `deep-research` (engine/genre patterns), `verify` (launch + play the
  build), `code-review`, `cli-anything` (wrap a GUI art tool headlessly), `pptx` (a pitch deck).

## File / asset nudges (on top of the base set)
Beyond CLAUDE.md, PROJEKT_<NAME>.md, TASKS.md, DONE.md, README, `.claude/`:
- `GAMEDESIGN.md` — the one-page design doc: core loop, win/lose, controls, the v1 slice scope,
  and the explicit out-of-scope list. The anti-scope-creep contract.
- `src/` (or engine project dir) — game code/scenes; `assets/` split into `art/`, `audio/`,
  `fonts/` with a provenance note per source (own / licensed / AI-generated).
- `assets/LICENSES.md` — every asset's source + license + redistribution right. Non-optional.
- `builds/` — `.gitignore`d platform builds; large binaries via Git LFS or kept out of the repo.
- `playtests/` — short logged notes per playtest (what broke, what felt good).

## Stack defaults & done-bar
**Default stack:** Godot 4 (2D or 3D) with GDScript, exporting to the chosen platform; web games on
Phaser 3 (2D) or Three.js (3D) bundled with Vite; assets AI-generated via higgsfield as
placeholders, replaced as the slice firms up; audio via `generate_audio`; UI via magic. Version the
project in git, keep big binaries out or in LFS.
**Done-bar (all true):** the **core loop runs end-to-end** — start, play the loop, reach win *and*
lose states — in a **build for the target platform** (not just the editor); it **launches and plays
without crashing or soft-locking**, confirmed by `playtest-runner` actually playing it; the vertical
slice is feature-complete to `GAMEDESIGN.md`; every shipped asset has a recorded license/right.

## Guardrails
- **Scope discipline is the top rule** — ship the small loop first. If a feature isn't in the v1
  slice in `GAMEDESIGN.md`, it waits. A playable tiny game beats an unfinished big one.
- **Honesty about "it's playable":** don't claim the loop works until `playtest-runner` has built
  for the target and actually played start→win/lose. Report crashes and soft-locks plainly.
- **Own or licensed assets only** — never ship art/audio/models you can't redistribute; record
  every source's license in `assets/LICENSES.md`. AI-generated assets: confirm the platform's
  commercial-use terms.
- **Multiplayer/online is a scope multiplier** — call out the cost before committing; default to
  single-player for v1 unless multiplayer is the whole point.
- **No emojis in any in-game UI, menu, or HUD text** (user's standing rule) — typographic symbols
  or drawn glyphs only.
- **Never commit secrets / store keys / signing certs.**
- **Commits under the user's own name only (Skryx-L-A); never add Claude as a co-author.**
