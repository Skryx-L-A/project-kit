---
name: content-writing
description: Build and set up a content-writing project — a book, course, documentation set, article, guide, or long-form written work — structured by outline and chapters and exported to a polished format. This is a project-kit sub-skill loaded by new-project routing. Use WHENEVER the user wants to write, draft, author, or ghostwrite a book, course, e-book, manual, docs, article, newsletter, or any substantial prose deliverable.
---

# content-writing — books, courses, docs, and long-form prose

This sub-skill stands up a **content / writing** project: a substantial written work organised by
outline and chapters, drafted iteratively, and exported to a polished format (PDF / DOCX / slides).
It treats structure, voice, and audience-fit as first-class — the deliverable is prose, not code,
so it uses an outline-and-chapter skeleton instead of source/build folders.

---

## What this sub-skill is for
Long-form written deliverables: a book or e-book, an online course/curriculum, a documentation set
or manual, a multi-part article or guide series, a newsletter run. Not for website copy that lives
inside a site (`website`), not for a research report whose point is a decision (`research-decision`,
though it composes when a book is research-heavy). Composes with `website` when the content also
ships as a published site.

## Mandatory grill-questions (fold into the Definition of Ready)
Lock these before drafting a single section:
- **Format** — book / e-book / course / docs / article series / manual. Each implies a different
  structure (chapters vs. modules+lessons vs. reference pages). **Recommend confirming the format
  before outlining.**
- **Audience** — who reads it, their prior knowledge, what they should be able to do afterward.
  Drives reading level, tone, and assumed background.
- **Goal & key takeaways** — what the reader/learner walks away with; the through-line of the work.
- **Length & depth** — target word/page count (or lesson count), and depth per unit. Sets the
  outline's granularity.
- **Outline** — the chapter/module breakdown. **Get the outline approved before any drafting** —
  this is the gate; drafting against an unapproved outline wastes work.
- **Voice & language** — tone (authoritative / friendly / academic), language/locale, and any style
  guide or sample to match.
- **Source material** — does the user supply research/notes/transcripts, or do we research? Any
  facts/claims that need verification or citation?
- **Export targets** — final formats (PDF, DOCX, EPUB, slide deck) and any layout/branding
  requirements.

## Project sub-agents to generate (into `<project>/.claude/agents/`)
- **`outliner`** *(delegate-by-default)* — turns the brief into a structured chapter/module
  outline with per-unit goals and key points; iterates with the user until the outline is approved
  (the gate). Chains `doc-coauthoring`.
- **`drafter`** *(delegate-by-default)* — writes each chapter/lesson to the approved outline in the
  project's voice and target length; works unit-by-unit, never dumps the whole book at once.
- **`editor`** — line-and-structure edits for clarity, consistency, voice, and flow; checks
  continuity across chapters and flags claims needing sources.
- Plus the kit defaults: `reviewer` (audits drafts against outline + audience + length) and
  `verifier` (confirms the export actually builds and reads correctly in the target format).

## Tools / CLIs / MCP / skills needed
Check in environment-readiness; offer install, never auto-install:
- **Export tooling** — `pdf` (final PDF + assembly/merge), `docx` (manuscripts, TOC, headings,
  letterhead), `pptx` (course/slide companion), `xlsx` only if the work needs data tables.
  `pandoc` for EPUB/format conversion if a book needs it.
- **CHAIN these GLOBAL skills (the core of this type):**
  - `doc-coauthoring` — the structured co-authoring workflow: context transfer, iterative
    refinement, reader-verification. Drive outlining and drafting through it.
  - `pdf` / `docx` / `pptx` — produce the polished export(s).
  - `deep-research` — when chapters need sourced facts; cite and mark verified vs. reasoned.
  - `verify` — confirm the exported artifact opens and reads as intended.

## File / asset nudges (on top of the base set)
Beyond CLAUDE.md, PROJEKT_<NAME>.md, TASKS.md, DONE.md, README, `.claude/` — use a manuscript
skeleton, not a code tree:
- `OUTLINE.md` — the approved chapter/module structure with per-unit goals (the source of truth).
- `chapters/` (or `modules/`) — one Markdown file per chapter/lesson, drafted in order.
- `STYLE.md` — voice, tone, terminology, formatting, and language/locale conventions.
- `research/` + `sources.md` — supporting notes and the citation list, if the work is sourced.
- `assets/` — figures, diagrams, cover art; `export/` — the built PDF/DOCX/EPUB/deck outputs.
- `front-matter/` — title page, TOC, preface/intro, about — for book/manual formats.

## Stack defaults & done-bar
**Defaults:** Markdown chapters under `chapters/`, an approved `OUTLINE.md` as source of truth, a
`STYLE.md` voice guide, `doc-coauthoring` driving the write loop, exported to PDF/DOCX (EPUB for
books) via the document skills. Draft unit-by-unit; never generate the whole work in one pass.
**Done-bar (all true):** the outline is **approved** by the user; **every chapter/lesson is
drafted** to its outlined goal and within target length; the editor pass is done (consistent voice,
no continuity breaks, claims sourced or flagged); the work is **exported** cleanly to the target
format(s) and the export opens and reads correctly.

## Guardrails
- **Outline approval is a gate** — do not bulk-draft against an unapproved outline.
- **Honesty in claims:** any fact, statistic, quote, or citation must be real and verifiable — mark
  verified vs. reasoned, and flag anything the user must confirm. Never invent sources or data.
- **No plagiarism** — write original prose; quote and attribute properly; study references for
  patterns, don't lift text.
- **Match the agreed voice and length** — don't pad to hit a count or drift off the style guide;
  flag if the target length doesn't fit the material.
- **AI-writing honesty** — if the user intends to publish, be candid about disclosure norms and
  don't dress up thin material as authoritative.
- **No emojis in the deliverable** unless the user's style guide explicitly calls for them
  (standing user rule: typographic symbols only by default).
- **Commits under the user's own name only (Skryx-L-A); never add Claude as a co-author.**
