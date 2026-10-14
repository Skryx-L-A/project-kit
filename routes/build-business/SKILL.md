---
name: build-business
description: Stand up a complete one-person AI-agency / local-business operation in a project folder, driven by the user's answers. Operationalises the full 7-day "start a 1-person business with Claude" system — pick a market, target franchises, and build the three service pillars (database reactivation, reviews & referrals, speed-to-lead), then get clients with paid ads and a sales trainer — and layers well-known startup/founder methods on top. Use ONLY when the user wants to BUILD A BUSINESS / agency / make money / get clients / find a market / create offers. Loaded by new-project's business branch (route a, new business). Not for projects that merely happen to be commercial — those link to an existing business profile instead.
---

# build-business — the 7-day business system (ultraskill)

This sub-skill turns "I want to build a business" into a **ready-to-run operation inside a
project folder**, automatically, from the user's answers. It is inspired by a public video on
starting a one-person AI business in seven days and offers a day-by-day plan, a four-part
market rubric and **seven ready-to-run prompts** as concrete project assets, plus pointers to
well-known startup and founder methods. All wording in this skill is original to this
repository; see `merged/SOURCES.md`.

> **Honesty:** the video that inspired the structure promotes a paid program, and the
> revenue and result figures it quotes are **unverified marketing**; present any such figure as
> unverified. The **plan, prompts, tools and routine are concrete and reusable**, and that is
> what this skill provides.

---

## What it builds (the deliverables)
When loaded, after grilling the business inputs, this skill produces (into the project):
- `MARKET.md` — the chosen market + the 3 researched candidates scored on the 4 criteria.
- `SHIP.md` — the target ICP: top franchise/network brands + the Facebook referral motion.
- `prompts/` — the **7 ready-to-run prompts** (below), pre-filled with the user's inputs.
- `pillars/reactivation.md`, `pillars/reviews-referrals.md`, `pillars/speed-to-lead.md` —
  the three sellable service systems, generated for this market.
- `acquisition/ads.md` — the Facebook Ad Library analysis loop + ad anatomy.
- `sales/trainer.md` + `sales/seven-step-framework.md` — the sales trainer (drill + review).
- `OFFER.md` — the packaged offer + pricing (built with the value-equation method).
- A `build-business` set of project sub-agents (see `SUBAGENT_GENERATION.md`).

---

## Grill these business inputs first (fold into the DoR)
1. **Your situation** — experience, connections (family/friends), available budget for tools.
2. **Market** — do you have a lean already, or should Day-1 research pick it?
3. **Country** + approximate market size (Day-2 input).
4. **Business/brand name** (real or placeholder) for the campaign assets.
5. **Primary service / offer** focus (e.g. weight-loss, TRT) and the desired conversion
   action (e.g. "book a free in-person consultation").
6. **Raffle/incentive** to use in reviews & referrals (e.g. $1,000 gift card, free year).
7. **Delivery stack** — how the SMS/email automations actually run (CRM/GHL/n8n/Twilio/etc.)
   and what the user already has (→ environment readiness).
8. **Goal** — first client / first $X month / replace a job — sets the phase plan.

## The 7-day flow (each day = a file in `system/`)
- **Day 1 — Choose your market** → `system/day-1-market.md` (+ `rubrics/market-criteria.md`).
- **Day 2 — Choose your ship (ICP/franchises)** → `system/day-2-ship.md`.
- **Day 3 — Pillar 1: Database reactivation** → `system/day-3-reactivation.md`.
- **Day 4 — Pillar 2: Reviews & referrals** → `system/day-4-reviews-referrals.md`.
- **Day 5 — Pillar 3: Speed-to-lead** → `system/day-5-speed-to-lead.md`.
- **Day 6 — Get clients with paid ads** → `system/day-6-paid-ads.md`.
- **Day 7 — Sales trainer** → `system/day-7-sales-trainer.md`.

Run them in order; each builds an asset the next depends on. The user can do "just a few
hours a day" — but you (the agent) generate the assets in one pass from their answers, then
they execute.

## The 7 prompts (the reusable asset)
Stored, ready-to-run and pre-filled, in `prompts/`:
1. `prompts/1-market-picker.md` — deep research → 3 markets vs. 4 criteria (uses the rubric).
2. `prompts/2-ship-finder.md` — top-10 franchise/network brands, real names only.
3. `prompts/3-reactivation.md` — full SMS+email database-reactivation campaign.
4. `prompts/4-reviews-referrals.md` — SMS+email reviews+referrals with raffle + 1–5 routing.
5. `prompts/5-speed-to-lead.md` — 5-message instant nurture sequence.
6. `prompts/6-ad-analyzer.md` — break competitor Facebook ads into winning patterns.
7. `prompts/7-sales-trainer.md` — 7-step sales framework, drill + review modes.

## Merged frameworks (layered on top — see `merged/`)
- **`merged/startup-backbone.md`** — idea-to-traction sequencing (Lean Canvas, Business Model
  Canvas, validation, thirteen-week cash plan), written independently.
- **`merged/offer-and-economics.md`** — value-equation offer design, unit economics
  (CAC/LTV/payback), pricing and n8n automation, written independently.
- **`merged/gtm-and-outreach.md`** — go-to-market planning, outreach, competitor research and
  conversion optimisation, written independently.
- **`merged/SOURCES.md`** — the public material that inspired this skill, with licenses and
  caveats.

## Hard rules for this skill
- **Decisiveness over perfection** (the system's core thesis): pick a market and move within
  a week; don't rabbit-hole research.
- **Flag marketing claims as unverified.** Never repeat the inspiring video's numbers as fact.
- **Compliance:** SMS/email reactivation must respect consent / opt-out / TCPA-GDPR rules —
  add an opt-out line to every generated SMS, and note consent requirements in each pillar.
- **No real customer PII** committed to a public repo.
- **Environment readiness:** the automations need a delivery stack (CRM/n8n/Twilio/email) and
  API keys — flag what's missing, offer install, ask the user to connect accounts/keys.
