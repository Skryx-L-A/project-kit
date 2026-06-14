---
name: mobile-app
description: Build and set up a mobile application project (iOS, Android, Flutter, React Native, or Expo) with screen scaffolding, signing, store-listing assets, and an EAS/native build-and-submit pipeline to the App Store and Google Play. This is a project-kit sub-skill loaded by new-project routing. Use WHENEVER the user wants to build, create, or ship a mobile app, a phone/tablet app, an iOS or Android app, or anything published to the App Store or Play Store.
---

# mobile-app — iOS / Android applications

This sub-skill stands up a **mobile application** that ships to the App Store and/or Google
Play. It nails the platform, the build-and-submit pipeline, signing, and the store listings up
front — the parts that block a release no matter how good the app is — and scaffolds the screen
structure so building starts on solid ground.

---

## What this sub-skill is for
An app that runs on phones/tablets and is distributed through the mobile stores (or via TestFlight
/ internal track first). Use it for native and cross-platform mobile; not for desktop installs
(`desktop-app`), web apps (`website`), or backends (`api-backend`) — though it commonly composes
with `api-backend` when the app has a server.

## Mandatory grill-questions (fold into the DoR)
1. **Platform/framework** — iOS-only (Swift/SwiftUI), Android-only (Kotlin/Compose), or
   cross-platform: Flutter, React Native (bare), or **Expo (managed)**. **Recommended: Expo** for a
   solo dev shipping both stores fast, unless a native-only requirement forces otherwise. Lock first.
2. **Target stores & accounts** — App Store, Play, or both? Confirm an Apple Developer account
   ($99/yr) and a Google Play Console account ($25 once) exist — without them you cannot submit.
3. **Signing** — Apple: bundle ID, certs, provisioning profiles (or EAS-managed credentials).
   Android: a keystore (decide who holds it; back it up — losing it blocks all future updates).
4. **Min OS versions & devices** — minimum iOS/Android, phone-only vs. tablet/iPad, orientations.
5. **Screens & navigation** — list the core screens and the nav model (tabs/stack/drawer) so the
   scaffold matches the real app, not a generic template.
6. **Backend & data** — standalone, or an API (compose `api-backend`)? Auth, offline behaviour,
   and where user data lives. Any push notifications (APNs/FCM)?
7. **Permissions & privacy** — camera/mic/location/contacts/health; the iOS privacy nutrition
   label and Android Data-safety form must be answered truthfully before submission.
8. **Build pipeline** — EAS Build/Submit (Expo/RN), Xcode Cloud / Fastlane, or Gradle/Fastlane.
   macOS is required for iOS builds — confirm a Mac or a cloud build (EAS) is available.

## Project sub-agents to generate (`<project>/.claude/agents/`)
- **`screen-builder`** *(delegate-by-default)* — implements a screen + its navigation to the
  done-bar, wired to the project's component and state conventions.
- **`store-listing-writer`** *(delegate-by-default)* — drafts App Store / Play listings: title,
  subtitle, description, keywords, what's-new, and a screenshot/asset shot-list per device size.
- **`build-submitter`** — runs EAS/native build + submit, manages credentials and TestFlight /
  internal-track uploads; never fabricates version/build numbers.
- **`store-compliance-reviewer`** *(delegate-by-default)* — checks against App Store Review
  Guidelines + Play policies and the privacy/data-safety disclosures before each submission.
- Plus the kit defaults: `reviewer` (diff/PR) and `verifier` (runs the app on a simulator/device).

## Tools / CLIs / MCP / skills needed
- **Toolchain:** Node + `expo` / `eas-cli` (Expo/RN) **or** Xcode + `swift`/`xcodebuild` (iOS) /
  Android Studio + Gradle SDK (Android); Flutter SDK if Flutter. Check in environment-readiness.
- **Release:** `fastlane` (metadata, screenshots, submission), `gh` for the source repo. iOS
  builds need macOS — flag if absent and route to EAS cloud builds.
- **Assets:** an icon/splash generator and a device-frame screenshot tool for store images.
- **CHAIN global skills:** `verify` (run on simulator/device), `code-review`,
  `doc-coauthoring` (store copy + README + privacy policy), `update-config` (allow build/submit
  commands). For UI inspiration the `framer-inspiration` / `design-harvest` skills inform layout
  and tokens even though it's not a website.

## File / asset nudges (on top of the base set)
- `app/` or `src/screens/` — the scaffolded screen tree matching the grilled nav model.
- `store/ios/` + `store/android/` — listing copy, keywords, what's-new, and the screenshot shot-list.
- `store/assets/` — icon, splash, and per-device-size screenshot frames.
- `credentials/` — `.gitignore`d slot for keystore, provisioning profiles, and API keys (never committed).
- `eas.json` / `fastlane/` — the build-and-submit config.
- `PRIVACY.md` — the privacy policy + the truthful answers for the iOS label and Play data-safety form.

## Stack defaults & done-bar
**Default stack:** Expo (managed RN) + EAS Build/Submit, TypeScript, file-based navigation,
Fastlane for store metadata/screenshots, both stores targeted. (Switch to native or Flutter if grilled.)
**Done-bar (all true):** the app builds a release artifact for each target platform; it installs
and runs on a real device (or TestFlight / internal track) and survives a cold start; signing and
credentials are valid and backed up; the store listing (copy + screenshots + privacy disclosures)
is complete and passes the compliance reviewer; an internal/TestFlight build has been submitted
successfully end-to-end.

## Guardrails
- **No emojis in the app UI or notifications** — typographic symbols or drawn elements only (standing user rule).
- **Truthful store disclosures:** privacy labels, data-safety, and permission usage strings must match what the app actually does — misrepresentation gets apps pulled.
- **Never commit keystores, provisioning profiles, certs, or API keys** — `.gitignore` them; warn that a lost Android keystore permanently blocks updates.
- **Don't claim store-readiness until the compliance reviewer passes** and a build has actually submitted; report blockers honestly.
- **Commit under the user's own name only (Skryx-L-A)** — never add Claude as a co-author.
- **No dark patterns / forced reviews / hidden subscriptions** — they violate both stores' policies.
