# Ads — Platforms (setup, targeting, tracking, launch)

| Platform | Best for | Structure | Targeting | Tracking |
|---|---|---|---|---|
| **Meta (FB/IG)** | local + e-com + lead gen | Campaign → Ad Set (budget/audience) → Ads | interests, lookalikes, custom audiences, geo/radius | Meta Pixel + Conversions API |
| **Google** | high-intent search + YouTube | Campaign → Ad Group → Ads/Keywords | keywords (search), audiences (display/YT) | GA4 + Google tag / conversion actions |
| **Reddit** | niche communities | Campaign → Ad Group → Ads | subreddit + interest targeting | Reddit Pixel |
| **TikTok** | younger, video-native, awareness | Campaign → Ad Group → Ads | interest/behavior, lookalikes | TikTok Pixel / Events API |

## Setup essentials
- **Pixel / conversion tracking installed and verified** before spending — otherwise you're
  blind. Confirm events fire (purchase, lead, etc.).
- **Budget discipline**: start small, one variable per test, kill losers, scale winners.
- **Audience**: start broad-ish on Meta/TikTok (algo finds buyers), tight intent on Google.

## Launch
- Via the platform's **Marketing API** (where the user grants app access) or hand the prepared
  ad set to the user to launch in the native Ads Manager.
- **Spend is ALWAYS gated** — Claude prepares and recommends; a human confirms budget + go.

## Reporting
Pull performance (CPL/CPA, CTR, ROAS) on a cadence → `metrics.md`; recommend cuts/scales.
