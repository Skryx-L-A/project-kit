# Ads — Creation (deep)

End-to-end ad production: angle → copy → creative → variants → ready-to-launch set.

## 1. Angle / hook
- Start from the offer + ICP (pull from `build-business`). List pains/desires.
- Hook frameworks: problem-agitate, big promise, pattern-interrupt, social proof, us-vs-them,
  question, before/after. Write 5–10 hooks; the hook is 80% of performance.

## 2. Copy
- Frameworks: **AIDA** (attention-interest-desire-action), **PAS** (problem-agitate-solve),
  **BAB** (before-after-bridge). One clear CTA. Match platform length + native tone.
- Model winners: pull competitor ads from the **Facebook Ad Library** (chain the ad-analyzer
  pattern) and extract the structure — don't copy verbatim.

## 3. Creative (visual)
- Generate with the **higgsfield** skills: `higgsfield-generate` (image/video), product shots
  via `higgsfield-product-photoshoot`, consistent faces/spokesperson via `higgsfield-soul-id`,
  marketplace/listing cards via `higgsfield-marketplace-cards`.
- Match the platform spec (aspect ratio, safe zones, length). Put the hook on-frame early.

## 4. Score + variant
- Run video creatives through the **virality_predictor** (hook strength, retention, attention);
  iterate weak hooks before spending.
- Build **A/B variants**: vary one thing at a time (hook, creative, CTA, audience). Name them
  systematically so results are readable.

## 5. Output
An **ad set**: 3–5 copy variants × 2–3 creatives × the targeting (see `ad-platforms.md`),
ready to launch — but launching/spending is **always gated** (`../AUTONOMY.md`).

## Guardrails
Honest claims only (no fake results/scarcity), FTC disclosure where relevant, own/licensed +
rights-cleared assets, no deepfakes of real people without consent.
