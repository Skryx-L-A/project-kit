---
name: data-ml
description: Stand up a data / machine-learning project in a project folder from the user's answers — a reproducible data pipeline, training, and HONEST evaluation with hard leakage and overfit guardrails. A project-kit sub-skill loaded by new-project's routing whenever the user wants to BUILD a model / ML pipeline / data pipeline / classifier / predictor / do training/eval/analysis on data. Leakage discipline and an honest EVAL.md are mandatory. Composes with api-backend/website for serving.
---

# data-ml — build a model on an honest holdout

## What this sub-skill is for
Standing up a **data / ML project**: ingest + clean data into a reproducible pipeline,
train a model, and **evaluate it honestly** on a holdout that was never touched during
development. Loaded by `new-project` for any pipeline/training/eval/analysis project.
Pairs with `api-backend` (serve the model) and `website` (a dashboard). The whole skill is
organized around one non-negotiable idea: **the eval number must be trustworthy.**

## Mandatory grill-questions (fold into the Definition of Ready)
- **Task:** prediction / classification / clustering / forecasting / analysis? The target
  variable, and exactly what a prediction is *used for*.
- **Data:** sources, size, license/consent, refresh cadence. **Is there a time dimension?**
  (If yes, splits must respect time — no random shuffle across time.)
- **The split, decided up front:** train / validation / **test** ratios, split *strategy*
  (random / grouped-by-entity / temporal), and a **locked holdout** opened only at the end.
- **Leakage audit:** which features could encode the target or the future? Any feature
  computed using information unavailable at prediction time? Group leakage (same
  user/entity in train and test)? Target derived from a feature?
- **Metrics:** the honest success metric(s) **chosen before seeing results**, plus a
  naive/baseline to beat. What number would mean "ship" vs. "this doesn't work"?
- **Reproducibility:** seed policy, environment pinning, where artifacts/checkpoints live.

## Project sub-agents to generate (`.claude/agents/`)
- **data-explorer** — profiles and cleans data, reports distributions, missingness, and
  leakage *suspects* (delegate-by-default for EDA); read-mostly, never silently mutates raw.
- **experiment-runner** — runs training/eval experiments reproducibly (fixed seed, pinned
  env), logs each run with config + metrics; reports results without editorializing.
- **eval-honesty-checker** — **adversarial** auditor (mirrors a `backtest-analyst`-style role):
  hunts target leakage, train/test contamination, group leakage, metric cherry-picking, and
  baseline gaming; flags overfit aggressively. **Delegate-by-default before any result is
  reported as real.** Never changes model/feature code — only audits and reports.

## Tools / CLIs / MCP / skills needed
- Python + `.venv` (with a disciplined honest-eval workflow): pandas/polars, scikit-learn,
  optionally PyTorch/LightGBM/XGBoost; `jupyter`/`jupytext` for notebooks. Install via
  `pip` at environment-readiness (surface, offer, don't auto-install).
- Experiment tracking: a lightweight logged-runs CSV/JSON at minimum, or MLflow/Weights &
  Biases if the user wants it. `dvc` or a `data/` manifest for data versioning.
- **Supabase MCP** (chain) if features/predictions are stored in Postgres; **n8n MCP**
  (chain) for scheduled pipeline runs/retraining triggers.
- **Global skills/agents to chain:** `deep-research` (method/architecture choice with
  evidence), `code-review` (pipeline correctness), `verify` (run the pipeline end-to-end),
  `market-researcher` (agent) for facts on datasets/APIs/licenses. For trading-flavored data
  work, the `backtest-analyst` agent's honest-eval bar is the model to imitate.

## File / asset nudges (on top of the base set)
- **`EVAL.md`** — the honest results doc: the locked metric(s), the baseline, holdout
  numbers, the split strategy used, the leakage audit performed, and **known limitations /
  where the model fails**. Bad-but-honest numbers go here unedited.
- `data/` with `raw/` (read-only, never mutate), `interim/`, `processed/`; a `DATA.md`
  describing every source, its license/consent, and the split definition.
- `notebooks/` — exploration only; **production logic lives in `src/`**, not notebooks
  (notebooks import from `src/`; clear all outputs before commit; no secrets in cells).
- `experiments/` — one logged run per config (params + metrics + seed + git SHA).
- `models/` — checkpoints (git-ignored if large; tracked via manifest). `.env.template`.

## Stack defaults & done-bar
**Default stack:** Python 3.x + `.venv`, pandas/polars + scikit-learn, fixed global seed,
jupytext-paired notebooks for EDA, results logged to `experiments/` and summarized in
`EVAL.md`. Swap the model library per the grill.
**Done-bar (all must hold):**
1. The pipeline runs **end-to-end reproducibly** from raw → metric on a fresh checkout.
2. Train/validation/**test** split is defined up front, respects time/groups, and the
   **test holdout was opened exactly once**, at the end.
3. A **leakage audit passed** the `eval-honesty-checker` (no target/temporal/group leakage).
4. The model **beats the documented baseline** on the untouched holdout — or `EVAL.md`
   honestly states it does not.
5. `EVAL.md` records metric, baseline, holdout result, split, audit, and limitations.

## Guardrails
- **Leakage is the default failure mode — assume it until disproven.** Compute features only
  from information available at prediction time. Never let the target (or anything derived
  from it) into the features. Never let the same entity straddle train and test.
- **Touch the test set once.** Every peek at the holdout to tune anything contaminates it; if
  contaminated, it is no longer a holdout — say so.
- **Respect time.** For any time-indexed data, split by time (or walk-forward); a random
  shuffle leaks the future into the past.
- **Pick the metric before the result, and report the baseline.** No metric-shopping after
  the fact; a model that doesn't beat a trivial baseline hasn't learned anything.
- **An honest bad result is a success; a flattered number is a failure.** Report
  Sharpe-of-shame numbers straight. The `eval-honesty-checker` never edits model code to
  make results look better.
- **Raw data is read-only**, and **secrets/PII never enter the repo, notebooks, or chat.**
- Mark unverified claims as unverified; commits under the user's own name only — no Claude
  co-author.
