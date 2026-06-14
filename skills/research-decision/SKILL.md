---
name: research-decision
description: Build and set up a research-and-decision project — a structured investigation that compares candidates against criteria to reach a sourced, logged recommendation. This is a project-kit sub-skill loaded by new-project routing. Use WHENEVER the user wants to research a question, weigh options, compare alternatives, build a decision matrix, or decide between candidates (which X to choose) by a deadline.
---

# research-decision — sourced research that ends in a logged decision

This sub-skill stands up a **research / decision** project: a question, a set of candidates, a set
of criteria, and a deadline — driven to a cited, defensible recommendation. It mirrors a prior
research/decision project: a small fixed doc system, a `berichte/` (reports)
folder, a decision matrix scoring finalists on criteria, a portfolio of evidence, and the decision
deliberately deferred to a date. Honesty is the whole product: every claim is sourced and marked
verified vs. reasoned.

---

## What this sub-skill is for
Answering a real decision with evidence: "which university / broker / framework / car / vendor /
strategy", a feasibility study, a buy/build/skip call, a thorough literature scan. The output is a
**recommendation + scored matrix + a logged decision**, not code. Composes with `content-writing`
when the result is a long report, and with `build-business` when the decision is a business one.

## Mandatory grill-questions (fold into the Definition of Ready)
Lock these before any research starts:
- **The decision / question** — one precise sentence: what is being decided, for whom, and why now.
- **Candidates** — the concrete options under comparison (and how open the field is — fixed
  shortlist vs. "find the candidates too").
- **Criteria & weights** — the dimensions that matter and their relative importance (cost, fit,
  risk, freedom, deadline pressure…). These become the matrix columns. **Recommend deriving weights
  explicitly with the user, not assuming them.**
- **Deadline(s)** — the real decision date and any per-candidate deadlines (e.g. application
  windows). Finalists often each have different cut-offs — capture every one.
- **What "decided" looks like** — the artifact + action that closes this: a logged choice, an
  application sent, a "defer until September" gate. Define the done state.
- **Evidence bar** — how strong must sources be (peer-reviewed / official / practitioner-ok)? What
  needs primary sources vs. acceptable reasoning?
- **Reversibility & stakes** — one-way vs. two-way door; what's the cost of being wrong. Drives how
  hard to grill and whether to convene `council`.
- **Scope in/out** — which candidates/criteria are explicitly excluded, to bound the research.

## Project sub-agents to generate (into `<project>/.claude/agents/`)
- **`source-finder`** *(delegate-by-default)* — fans out across the web/literature to gather
  primary and high-quality sources per candidate/criterion; returns cited findings with URLs, never
  unsourced claims. Chains the `deep-research` skill.
- **`claim-verifier`** *(delegate-by-default)* — adversarially checks each load-bearing claim,
  marks it **verified (with source)** vs. **reasoning/inference**, flags contradictions and stale
  data, and downgrades anything it can't substantiate.
- **`decision-matrix-builder`** — maintains the criteria × candidates matrix, scores cells from the
  verified evidence, applies the weights, and surfaces the ranking + sensitivity (what flips it).
- Plus the kit defaults: `reviewer` (audits the report for unsourced or overconfident claims) and
  `verifier` (re-checks that conclusions actually follow from the logged evidence).

## Tools / CLIs / MCP / skills needed
Check in environment-readiness; offer install, never auto-install:
- **Research MCPs/tools** — `WebSearch`/`WebFetch`; domain MCPs when relevant (PubMed, Consensus,
  Scholar Gateway, Clinical Trials for medical/academic; Semrush for market questions).
- **Document tooling** — `xlsx` for the scoring matrix as a real spreadsheet; `pdf`/`docx` to
  export the final report; `pptx` if a decision briefing deck is wanted.
- **CHAIN these GLOBAL skills (the core of this type):**
  - `deep-research` — multi-source, fact-checked, cited research per candidate/criterion.
  - `council` — convene the four-voice decision council on the real tradeoff before recommending,
    especially for one-way-door, high-stakes calls.
  - `doc-coauthoring` — structure the final recommendation/report.
  - `verify` — sanity-check that the recommendation follows from the matrix.

## File / asset nudges (on top of the base set)
Beyond CLAUDE.md, PROJEKT_<NAME>.md, TASKS.md, DONE.md, README, `.claude/` — mirror a small fixed
4-file + reports layout:
- `berichte/` (reports) — one cited write-up per candidate (and per major criterion), each marking
  verified vs. reasoned claims, with a sources list.
- `decision-matrix.md` (+ a `decision-matrix.xlsx`) — criteria × candidates, weights, scores, and
  the resulting ranking + sensitivity notes.
- `candidates/` — a profile per option (facts, deadlines, pros/cons, open questions).
- `DECISION_LOG.md` — the running record: options considered, the chosen one (or the "defer to
  <date>" gate), the reasoning, and what would change the call later.
- `sources.md` — the bibliography/URL list backing every claim.

## Stack defaults & done-bar
**Defaults:** a small fixed Markdown doc system + a `berichte/` folder + a
weighted decision matrix (as both `.md` and `.xlsx`) + a `DECISION_LOG.md`; `deep-research` for
gathering, `council` for the call, sources cited inline throughout. Defer the decision to the real
deadline rather than forcing it early when the field is genuinely open.
**Done-bar (all true):** every criterion is scored for every candidate from **verified, cited**
evidence; a clear recommendation (or an explicit "decide on <date>" gate) is written with its
reasoning; the decision is recorded in `DECISION_LOG.md`; per-candidate deadlines are captured and
none has silently lapsed; the report distinguishes verified facts from reasoning throughout.

## Guardrails
- **Cite or flag — never assert unsourced.** Every load-bearing claim carries a source or is marked
  explicitly as reasoning/inference. No fabricated statistics, quotes, or citations, ever.
- **Verified vs. reasoned is a visible distinction** in every report — the reader must always know
  which is which.
- **Don't fake confidence or completeness** — surface gaps, contradictions, and stale data; say "I
  could not verify X" rather than smoothing it over.
- **Honour every deadline** — track per-candidate cut-offs; never let a window lapse unflagged.
- **Separate evidence from recommendation** — score on the evidence first, then recommend; convene
  `council` for high-stakes one-way-door calls instead of deciding solo.
- **No emojis in any deliverable UI/output** (user's standing rule).
- **Commits under the user's own name only (Skryx-L-A); never add Claude as a co-author.**
