---
name: simulation
description: Stand up a scientific-computing / numerical SIMULATION project in a project folder from the user's answers — physics, orbital mechanics, signal/numerical, agent-based, or Monte-Carlo modeling — implemented against governing equations and validated honestly against a known analytic or benchmark case. A project-kit sub-skill loaded by new-project's routing whenever the user wants to BUILD a simulation / model / solver / numerical experiment. Distinct from data-ml: this is modeling-from-equations, not learning-from-data. Validation, units, and convergence are mandatory.
---

# simulation — model from equations, then prove it reproduces a known case

## What this sub-skill is for
Standing up a **scientific-computing / numerical simulation**: encode a model's governing
equations, integrate/solve them, and **validate the result against a case whose answer is
already known** (an analytic solution or an accepted benchmark). Loaded by `new-project`
for physics, orbital mechanics, signal/numerical, agent-based, or Monte-Carlo work. This is
**modeling, not machine learning** — there is no training set; correctness comes from the math
and from reproducing known results, not from a holdout. The organizing idea: **an unvalidated
simulation is a hypothesis, not a result.**

## Mandatory grill-questions (fold into the Definition of Ready)
- **Domain & model:** what system, and what are the **governing equations / model**? (ODE/PDE,
  N-body, Maxwell, rigid-body, agent rules, stochastic process — name it.) What's fixed by
  physics vs. a modeling choice?
- **Fidelity vs. speed:** real-time/interactive, or batch high-fidelity? Acceptable error?
  Stiffness — do you need an implicit solver?
- **Language:** Python (numpy/scipy/numba), Julia, or C++? (Python to prototype; numba/Julia/
  C++ if the inner loop must be fast.)
- **Solver / integrator:** which scheme (RK4 / symplectic / implicit / Verlet / FFT-based),
  fixed vs. adaptive step, and **why that one** for this system's stability/conservation needs?
- **Units system:** SI? non-dimensionalized? **Pick one and enforce it everywhere** — silent
  unit mismatches are the classic simulation bug.
- **Validation cases:** which **analytic solution or published benchmark** will prove it
  right (e.g. two-body Kepler orbit, harmonic oscillator energy, a manufactured solution)?
  What tolerance counts as "matches"?
- **Visualization:** what plots/animations make the result legible and the validation visible?

## Project sub-agents to generate (`.claude/agents/`)
- **model-implementer** — encodes the governing equations and the integrator/solver in the
  chosen language; keeps the numerics readable and the units explicit (delegate-by-default
  for the core solver).
- **numerical-validator** — **adversarial** (mirror of an honest-eval auditor): runs the
  analytic/benchmark cases, checks error vs. tolerance, **convergence under step/grid
  refinement**, conservation laws (energy/momentum/mass), and **unit consistency**; flags a
  sim that only *looks* right. **Delegate-by-default before any output is reported as real.**
  Never tunes the model to pass — only validates and reports.
- **viz-builder** — produces the plots/animations, including the **validation overlay**
  (simulated vs. analytic) so correctness is visible, not just asserted.

## Tools / CLIs / MCP / skills needed
- Python + `.venv`: numpy, scipy, matplotlib/plotly, `numba` for hot loops, `jupyter` for
  exploration. Domain libs where they fit: `astropy` + `poliastro` (orbital mechanics),
  `sympy` (deriving/checking analytic cases), `pint` (unit-checked quantities). Julia or a
  C++/pybind core if the grill demands speed. Install via `pip` at environment-readiness
  (surface and offer, never auto-install).
- **Global skills/agents to chain:** `deep-research` (**lead with this** — get the governing
  equations, the right integrator, and a documented benchmark with citations *before*
  coding), `verify` (run the sim + validation end-to-end on a fresh checkout), `code-review`
  (numerical correctness, indexing, stability), `market-researcher` (agent) for facts on
  models/constants/published reference results.

## File / asset nudges (on top of the base set)
- **`VALIDATION.md`** — the honest proof doc: the benchmark/analytic case(s), the tolerance
  chosen up front, the achieved error, the **convergence table** (error vs. step/grid size),
  conservation-law checks, the units system, and **stated assumptions / regimes where the
  model breaks**. Failures are recorded straight.
- `MODEL.md` — the governing equations, derivation/source, parameters, and the units
  convention.
- `src/` — production solver code (notebooks import from it; not the reverse).
- `validation/` — runnable scripts that reproduce each benchmark and emit the error/figure.
- `figures/` — generated plots/animations, including the simulated-vs-analytic overlay.
- `notebooks/` — exploration only; clear outputs before commit.

## Stack defaults & done-bar
**Default stack:** Python 3.x + `.venv`, numpy/scipy core with numba on hot loops,
matplotlib for figures, a fixed RNG seed for any Monte-Carlo, units pinned via `pint` or a
documented SI convention, validation scripts in `validation/`. Swap to Julia/C++ per the grill.
**Done-bar (all must hold):**
1. The sim **reproduces a known analytic or benchmark case within the stated tolerance**.
2. **Convergence is demonstrated** — error shrinks at the expected order as the step/grid
   refines (table in `VALIDATION.md`).
3. **Units are consistent end-to-end** and **conservation laws hold** to tolerance where the
   physics requires them.
4. The whole pipeline (run → validate → figure) executes reproducibly on a fresh checkout.
5. `VALIDATION.md` records the case, tolerance, achieved error, convergence, and assumptions.

## Guardrails
- **An unvalidated sim is never presented as correct.** No result leaves the project until it
  has reproduced a known case; "the plot looks plausible" is not validation.
- **State tolerances, convergence, and conservation explicitly** — a number without an error
  bar and a convergence check is not trustworthy. Report the order of accuracy you actually
  achieved, not the one you hoped for.
- **Enforce one units system everywhere** and check it; the most common silent bug is a unit
  mismatch that produces clean-looking, wrong numbers.
- **Document every assumption and the valid regime** — where the model linearizes, what it
  ignores, where it diverges from reality. An honest "valid only for small angles" beats a
  hidden failure.
- **The numerical-validator never tunes the model to hit a target** — it audits; fixing the
  math is the implementer's job, and a failing check is information, not an obstacle.
- Mark unverified claims as unverified. NO emojis in any output, plots-text, or UI. Commits
  under the user's own name only (Skryx-L-A) — never add Claude as a co-author. Never commit
  secrets / API keys (e.g. for data or compute services).
