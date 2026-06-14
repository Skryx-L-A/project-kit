---
name: browser-extension
description: Build/set up a browser-extension project — a Chrome/Firefox/Edge add-on with content scripts, a background service worker, and a popup/options UI — from the user's grilled answers. Project-kit sub-skill loaded by new-project routing whenever someone wants to build a browser extension, add-on, Chrome/Firefox plugin, or web-page-injecting tool. Defaults to Manifest V3, minimal permissions, and a store-ready listing; can drive claude-in-chrome/playwright to test the loaded extension live.
---

# browser-extension — the add-on builder sub-skill

## What this sub-skill is for
Standing up a real, installable **browser extension**: a Chrome/Firefox/Edge add-on built on
**Manifest V3**, with content scripts, a background service worker, and a popup/options UI. It
covers the bits that make an extension actually shippable — permission minimisation, cross-browser
packaging, and store-listing assets. Loaded by `new-project` routing for add-on/plugin requests.

## Mandatory grill-questions (fold into the Definition of Ready)
Lock these before scaffolding — they decide manifest, permissions, and store fit:
- **Core job** — what does it do on which pages? In-page UI, background processing, or both?
- **Target browsers** — Chrome only, or Chrome + Firefox (+ Edge)? (Affects manifest quirks + packaging.)
- **Host permissions** — which sites/origins does it touch? Push toward `activeTab`/optional permissions over broad `<all_urls>`.
- **Permissions list** — storage, scripting, tabs, alarms, notifications, etc. — justify each; drop anything not strictly needed.
- **Data & network** — does it call an external API or backend? Where does user data go? Any auth/keys?
- **UI surfaces** — popup, options page, side panel, injected overlay, context menu? Which are needed?
- **Storage** — `chrome.storage.local` vs `.sync`; what's persisted and is any of it sensitive?
- **Distribution** — Chrome Web Store, Firefox AMO, both, or unlisted/self-hosted? (Sets the listing + review burden.)
- **Privacy posture** — what the privacy policy must state; whether a remote-code/CSP review applies.

## Project sub-agents to generate (into `.claude/agents/`)
- **manifest-permissions-auditor** *(delegate-by-default)* — reviews `manifest.json` on every change: minimises permissions/host access, validates MV3 structure, flags anything a store reviewer would reject.
- **content-script-builder** *(delegate-by-default)* — writes content scripts + DOM injection/overlay UI safely (isolated world, no clobbering host pages, idempotent injection).
- **background-worker-builder** *(delegate-by-default)* — owns the MV3 service worker: event-driven, no long-lived state assumptions, message passing, alarms.
- **extension-test-driver** — loads the unpacked extension and exercises it live via `claude-in-chrome`/`playwright`; checks popup, injection, and message flow.
- **store-listing-author** — drafts Web Store / AMO listing copy, permission justifications, screenshots checklist, and the privacy policy.

## Tools / CLIs / MCP / skills needed
Check in environment-readiness; offer install, never auto-install:
- **Node 20+ / package manager**; a bundler tuned for extensions (**Vite + CRXJS**, or `wxt`/`webextension-polyfill` for cross-browser).
- **web-ext** (`npm i -g web-ext`) for Firefox run/lint/sign; Chrome for `chrome://extensions` unpacked loading.
- **MCP:** `claude-in-chrome` (load + drive the real extension in the user's Chrome — invoke the `claude-in-chrome` skill first) and/or `playwright` for automated flow tests; `magic` (21st.dev) for popup/options UI.
- **CHAIN global skills:** `frontend-design` for the popup/options/overlay UI; `web-aeo` only if a marketing landing page is wanted; `code-review` + `verify` before packaging.

## File / asset nudges (on top of the base set)
Beyond CLAUDE.md, PROJEKT_<NAME>.md, TASKS.md, DONE.md, README, `.claude/`:
- `src/manifest.json` (or a manifest generator) — MV3, with Chrome/Firefox variants if cross-browser.
- `src/content/`, `src/background/`, `src/popup/`, `src/options/` — the standard surfaces.
- `src/lib/messaging.ts` — typed runtime message contracts between worker/content/popup.
- `icons/` — 16/32/48/128 px icon set (no emoji; typographic/drawn marks only).
- `store/` — listing copy, **permission justifications**, screenshots, promo tiles, `PRIVACY.md`.
- `PERMISSIONS.md` — every permission + host with a one-line "why we need it".
- `dist/` build output + a `package` script that zips the store-ready artifact.

## Stack defaults & done-bar
**Default stack:** Manifest V3, TypeScript, **Vite + CRXJS** (or `wxt`), `webextension-polyfill`
for cross-browser, `chrome.storage` for state, `web-ext` for Firefox tooling. Minimal-permission
manifest by default — start from `activeTab` and add only what the grilled scope proves necessary.

**"Finished/working" means** (checkable bar):
- Loads as an **unpacked extension** in Chrome with no manifest/console errors, and (if targeted) in Firefox via `web-ext run`.
- The core job works live on a real target page — content injection, popup, and background message flow all verified (driven via `claude-in-chrome`/`playwright`).
- **Permissions are minimal** — every entry in the manifest is justified in `PERMISSIONS.md`; no unused or over-broad host access.
- `web-ext lint` (Firefox) passes; the MV3 structure passes a store-reviewer sanity check.
- A **store-ready zip** builds, and the listing assets + privacy policy + permission justifications exist.
- State persists/clears as designed; no secrets baked into the bundle.

## Guardrails
- **Permission minimisation is mandatory** — prefer `activeTab` + optional permissions; broad `<all_urls>`/host access must be explicitly justified or removed. Stores reject over-asking.
- **No remote code execution** — MV3 forbids it; bundle all logic, don't `eval` or load remote scripts.
- **Content scripts must not break host pages** — isolated world, namespaced, idempotent injection, clean teardown.
- **Privacy honesty:** the privacy policy must truthfully state what data is collected and where it goes; no silent exfiltration of page content or PII.
- **Never invent or commit credentials/API keys** — user pastes them; keys stay out of the bundle and git.
- **No emojis in the UI** — typographic symbols or drawn marks only (user's standing rule).
- **Commits under the user's name only (Skryx-L-A); never add Claude as co-author.**
