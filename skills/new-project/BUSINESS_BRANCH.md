# BUSINESS BRANCH — the early 4-way fork

Resolve this early in the grill. It decides whether commercial machinery (markets, offers,
marketing, sales) is in scope at all, and how the project connects to a business.

Ask, recommended-answer style: **"Is this project a new business, part of an existing
business, or not a business at all?"**

## (a) New business
- The user wants to build a business / agency / make money from scratch.
- → Load the **`build-business`** ultraskill. It grills the business-specific inputs and
  operationalises the full 7-day system into the project folder.

## (b) Existing business
- The project serves a business that already exists.
- **Do NOT rebuild blindly.** First ask:
  - Does a **business profile** already exist (in `~/.claude` memory or `~/AI/_business/<name>/`)?
  - Is there existing **memory / MD structure** for this business?
  - What should be **adopted / reused / linked**, and what is genuinely new?
- Link the project to the shared business profile so multiple projects share one source of
  truth. Pull market/offer/ICP/brand context from it instead of re-deriving. No marketing
  rebuild unless asked.

## (c) Part of a business
- The project is one component (a single feature, campaign, microsite, tool) of a business.
- Scope the project to that component. Inherit context from the business profile (as in b).
  Keep the project folder small and focused; it reports up to the business umbrella.

## (d) No business
- Personal, research, learning, open-source-for-its-own-sake, life-admin, hobby.
- Skip everything commercial. Route on the non-commercial type(s) only (e.g.
  `research-decision`, `content-writing`, `game-mod`, or `generic-project`).

---

## The shared business profile

Location (both, kept in sync):
- **Private, durable facts** → harness auto-memory under `~/.claude/projects/.../memory/`
  (one fact per file; index in `MEMORY.md`).
- **Shareable business facts** → `~/AI/_business/<name>/` (offer, ICP, brand, assets index,
  positioning). Created on first existing-business project; reused by all later ones.

When a business profile exists, every new project for that business **reads it first** and
links to it (e.g. a line in the project's `CLAUDE.md`: "Business: see `~/AI/_business/<name>/`").
