---
name: desktop-app
description: Build and set up a desktop / cross-platform application project (Electron, Qt/Python, or Tauri) with per-OS packaging, code signing, auto-update, and a GitHub-Release-plus-download-page distribution flow. This is a project-kit sub-skill loaded by new-project routing. Use WHENEVER the user wants to build, create, or ship a desktop app, a native GUI, a tray/menu-bar utility, a cross-platform installer, or anything that runs as an installed program on Windows / macOS / Linux.
---

# desktop-app — installed cross-platform applications

This sub-skill stands up a **desktop application** that users download and install on
Windows, macOS, and/or Linux. It mirrors the proven release flow of a cross-platform Python+Qt
desktop app with local ML weights (e.g. a local-speech tool): Python + Qt control center,
local model weights, packaged online + offline installers, GitHub Releases, a Netlify download
site, big assets on Hugging Face, Windows build on a remote host, portable offline build in a
container. Distribution is treated as a first-class deliverable, not an afterthought.

---

## What this sub-skill is for
A program that runs as an installed binary with a real OS presence (window, tray/menu-bar,
notifications, file associations), shipped as signed per-OS installers. Use it for GUI tools,
utilities, and tray apps — not for web UIs (`website`), pure command-line tools (`cli-tool`),
or mobile (`mobile-app`), though it composes with `cli-tool` when the app also ships a launcher.

## Mandatory grill-questions (fold into the DoR)
1. **Framework** — Electron (web stack, biggest bundle), Qt/Python (native
   feel, PySide6/PyQt), or Tauri (Rust core, tiny bundle, system webview). **Recommended: Qt/Python**
   for a native feel unless web UI reuse forces Electron. Lock this before any code.
2. **Target OSes** — which of Windows / macOS / Linux, and the minimum versions. Each adds a
   packaging + signing + CI lane.
3. **Code signing** — do you have (or will you get) an Apple Developer ID + notarization, and a
   Windows Authenticode cert? If not, ship unsigned and warn users of the OS gatekeeper prompts.
4. **Auto-update** — needed? (electron-updater / Tauri updater / Sparkle / custom check against
   GitHub Releases). Define the update channel and the signing key for update artifacts.
5. **Offline / heavy assets** — large models or data (like bundled ML weights)? Decide
   online-installer-fetches-on-first-run vs. offline multi-part bundle, and where big files live
   (Hugging Face / GitHub Release assets / CDN).
6. **Distribution surface** — GitHub Release + a download page (Netlify)? Confirm
   the download-site repo and the artifact naming scheme.
7. **Build hosts** — can all target OSes be built here, or is a remote build host needed (e.g.
   SSH to a Windows machine for the Windows lane)? Flag any cross-build gaps now.
8. **Data & privacy** — local-only vs. cloud; where user data/config lives per-OS; any telemetry
   (default: none, opt-in only).

## Project sub-agents to generate (`<project>/.claude/agents/`)
- **`packager`** *(delegate-by-default)* — produces per-OS installers (NSIS/MSI, dmg/pkg,
  AppImage/deb/rpm or Tauri bundles); owns the build matrix and artifact naming.
- **`release-engineer`** *(delegate-by-default)* — cuts the GitHub Release, uploads artifacts +
  checksums, syncs the download page, pushes big assets to Hugging Face; never invents version tags.
- **`installer-tester`** — installs each artifact on a clean target, verifies launch, signing,
  auto-update, and offline-asset fetch; reports honestly when a lane is broken.
- **`ui-reviewer`** — checks the GUI against the done-bar and the **no-emoji rule** (typographic
  symbols / drawn elements only in UI and notifications).
- Plus the kit defaults: `reviewer` (diff/PR) and `verifier` (launches the app to confirm behaviour).

## Tools / CLIs / MCP / skills needed
- **Runtime/build:** Node + the framework toolchain (electron-builder / `@tauri-apps/cli` /
  Rust+cargo) **or** Python + PySide6/PyQt + PyInstaller/briefcase. Check in environment-readiness.
- **Signing/notary:** `codesign`/`notarytool` (macOS), `signtool`/`osslsigncode` (Windows) — only
  if signing was chosen; flag missing certs, never fabricate credentials.
- **Distribution:** `gh` (GitHub Releases), `netlify-cli` (download page), `huggingface_hub` /
  `git-lfs` for big assets. Container runtime (Docker/Podman) for the portable offline build
  (glibc-pinned) and remote `ssh` to a build host for OS lanes that can't build locally.
- **CHAIN global skills:** `cli-anything` (if wrapping an existing GUI into an agent-drivable CLI),
  `verify` (run the built app), `code-review`, `doc-coauthoring` (README + install docs),
  `update-config` (permissions/hooks for build commands). For the desktop UI itself, the
  `framer-inspiration` / `design-harvest` skills inform layout even though it isn't a website.

## File / asset nudges (on top of the base set)
- `packaging/` — per-OS build configs (electron-builder.yml / tauri.conf.json / PyInstaller specs).
- `packaging/signing/` — signing notes + a `.gitignore`d slot for certs/secrets (never committed).
- `.github/workflows/release.yml` — the build matrix + release pipeline.
- `download-site/` (or a linked repo) — the download page.
- `assets/` + an `ASSETS.md` documenting where heavy files live and how the online installer fetches them.
- `INSTALL.md` — per-OS install, the unsigned-app gatekeeper steps, and uninstall.

## Stack defaults & done-bar
**Default stack:** Qt/Python (PySide6) + PyInstaller, signed where certs exist, auto-update
checked against GitHub Releases, online installer + optional offline bundle, download page on
Netlify, big assets on Hugging Face — i.e. the Python+Qt local-weights pattern. (Switch to Electron/Tauri if grilled.)
**Done-bar (all true):** a signed (or knowingly-unsigned) installer for each target OS installs
on a clean machine; the app launches, shows its window/tray, and survives a restart; auto-update
applies a newer release end-to-end; offline assets resolve on first run; a GitHub Release exists
with artifacts + checksums and the download page links to them; `INSTALL.md` is accurate.

## Guardrails
- **No emojis in the app UI or notifications** — typographic symbols or drawn elements only (standing user rule).
- **Honesty about signing:** if the app is unsigned, say so plainly and document the OS warnings — never imply it's trusted.
- **Never commit certs, signing keys, notary creds, or API tokens** — `.gitignore` them; ask the user to supply them.
- **Don't claim a build lane works until `installer-tester` proves it** on that OS; report cross-build gaps instead of faking them.
- **Commit under the user's own name only (Skryx-L-A)** — never add Claude as a co-author.
- **Verify big-asset licensing** before redistributing models/data; record provenance in `ASSETS.md`.
