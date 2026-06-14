---
name: creative-media
description: Build/set up a creative-media project — AI image/video/audio generation, a YouTube or ads channel, thumbnails, short-form, or brand visuals — from the user's grilled answers. Project-kit sub-skill loaded by new-project routing whenever someone wants to make videos, generate images, run a content channel, design thumbnails, produce ads, or build brand visuals. Chains higgsfield-generate (+ soul-id, product-photoshoot), design-harvest, pptx, and the virality predictor, and bakes in a repeatable produce→review→publish pipeline.
---

# creative-media — a repeatable produce→review→publish pipeline

## What this sub-skill is for
Standing up a **creative-media project**: a repeatable pipeline that turns a concept into
published assets — AI image/video/audio generation, a YouTube or short-form channel, an ads
operation, thumbnails, or brand visuals. Loaded by `new-project` for any "make videos / generate
images / run a channel / produce ads / design thumbnails / brand visuals" request. The whole skill
is organized around one idea: **build a pipeline (concept → generate → review → publish) that can
run again, not just one lucky asset.**

## Mandatory grill-questions (fold into the Definition of Ready)
Lock these before generating anything:
- **Medium** — image, video, audio, or mixed? Decides the generation model + the whole pipeline.
- **Platform + format/aspect** — YouTube long-form (16:9), Shorts/Reels/TikTok (9:16), feed posts
  (1:1/4:5), display ads (set sizes)? Pin the exact aspect ratio(s) and duration now.
- **Brand / style** — palette, typography, tone, references. Harvest tokens from references with
  `design-harvest`. Consistency across assets matters more than any single hero piece.
- **Volume / cadence** — how many assets per week, and the publishing rhythm? The pipeline must
  sustain that cadence, not just produce one piece.
- **Identity consistency** — recurring faces (use `higgsfield-soul-id` to train a Soul) or recurring
  products (use `higgsfield-product-photoshoot`)? Lock identity *before* batch-generating.
- **Edit / assembly flow** — where raw generations get cut, captioned, scored, and exported (an NLE,
  a script, higgsfield's tools). No emojis in any on-screen text/overlays.
- **Publish + rights** — who posts, where, and is every input (faces, music, product, stock)
  cleared for the intended use? AI-disclosure required on the target platform?
- **Success metric** — what "this works" means: a published asset, a tested hook, a `virality_predictor`
  score over a bar, or a filled content calendar.

## Project sub-agents to generate (into `<project>/.claude/agents/`)
- **`concept-writer`** *(delegate-by-default)* — turns the brief into concepts, hooks, scripts, and
  generation prompts on-brand and on-format; keeps a backlog feeding the pipeline's cadence.
- **`asset-generator`** *(delegate-by-default)* — runs the higgsfield generation: `generate_image`,
  `generate_video`, `generate_audio`, applying the trained Soul (`--soul-id`) or product-photoshoot
  mode for consistency, and organizing outputs by campaign/episode.
- **`thumbnail-designer`** — designs thumbnails/covers/key art that read at small sizes, on-brand,
  emoji-free; chains `design-harvest` for reference patterns and the higgsfield image tools.
- **`virality-checker`** *(delegate-by-default for video)* — runs `virality_predictor`
  (`brain_activity`) on cut videos for hook strength, attention, retention, and distraction risk;
  reports the score honestly and flags weak hooks before publish.
- Plus the kit default `reviewer` (brand/format/rights review before publish).

## Tools / CLIs / MCP / skills needed
Check in environment-readiness; offer install, never auto-install:
- **CHAIN the higgsfield MCP + skills** as the generation core: `higgsfield-generate`
  (`generate_image` / `generate_video` / `generate_audio`, image-to-image, image-to-video,
  Marketing Studio for ads with avatars/products/hooks), `higgsfield-soul-id` (train a face for
  identity-consistent output), `higgsfield-product-photoshoot` (brand/product visuals),
  `higgsfield-marketplace-cards` (listing/product image sets), and `virality_predictor` for video.
  Use `media_upload_widget` / `media_import_url` for the user's own input media.
- **CHAIN `design-harvest`** — pull palette/typography/spacing/component tokens from reference sites
  for the brand system and thumbnails. **CHAIN `framer-inspiration`** if the project ships a site.
- **CHAIN the `pptx` skill** for pitch/brand decks and the `magic` MCP for any web UI/overlay
  templates. `docx` for scripts/treatments if wanted.
- **Editing/encoding** — `ffmpeg` (cut/caption/encode/aspect-convert), an NLE if hand-edited.
  Verify `ffmpeg` is present. **CHAIN global skills:** `deep-research` (platform/format/trend
  facts), `verify`, `code-review` (if the pipeline is scripted), `cli-anything` (wrap a GUI editor
  like Shotcut/Inkscape headlessly).

## File / asset nudges (on top of the base set)
Beyond CLAUDE.md, PROJEKT_<NAME>.md, TASKS.md, DONE.md, README, `.claude/`:
- `BRAND.md` — palette, type, tone, do/don'ts, the trained Soul/product reference ids, and the
  emoji-free overlay rule. The consistency contract.
- `PIPELINE.md` — the repeatable concept → generate → review → publish steps, who/what runs each,
  and the per-format spec (aspect, duration, safe areas).
- `CALENDAR.md` — the publishing cadence + a content backlog.
- `assets/` split into `raw/` (generations), `edited/`, `published/`, `thumbnails/`; large media
  `.gitignore`d or Git-LFS.
- `assets/RIGHTS.md` — provenance + license + usage-right + AI-disclosure status per input/output.
  Non-optional.

## Stack defaults & done-bar
**Default stack:** higgsfield for generation (GPT Image 2-class for images/design/text, Seedance for
video, `generate_audio` for sound; Soul for consistent faces, product-photoshoot for products),
`design-harvest` for brand tokens, `ffmpeg` for assembly/encode/aspect, `virality_predictor` to
score video, `pptx` for decks. Assets organized in `assets/`, big media kept out of git or in LFS.
**Done-bar (all true):** a **repeatable produce→review→publish pipeline** is documented in
`PIPELINE.md` and runnable again at the chosen cadence; the **first real asset(s) are generated**,
on-brand, in the correct format/aspect, and emoji-free; identity consistency holds where required
(Soul/product); for video, hooks pass the `virality_predictor` bar or weak ones are flagged; every
input/output has a recorded right in `assets/RIGHTS.md`.

## Guardrails
- **Disclose AI-generated media** where the platform or law requires it; record disclosure status in
  `RIGHTS.md`. Don't pass synthetic media off as a real photograph where that would mislead.
- **Rights / licensing** — every face, voice, song, product, and stock input must be cleared for the
  intended commercial use before it ships; record provenance per asset.
- **No deepfakes of real people without consent** — only generate a real person's likeness/voice
  with their explicit permission (the Soul-ID identity flow is for consented faces only).
- **Honest performance** — report `virality_predictor` scores straight; don't dress up a weak hook
  as strong, and don't claim reach/engagement you haven't measured.
- **No emojis in any on-screen text, overlay, thumbnail, caption, or UI** (user's standing rule) —
  typographic symbols or designed glyphs only.
- **Never commit secrets / platform API keys / publish tokens.**
- **Commits under the user's own name only (Skryx-L-A); never add Claude as a co-author.**
