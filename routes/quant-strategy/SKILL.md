---
name: quant-strategy
description: Stand up a standalone quantitative TRADING STRATEGY project in a project folder from the user's answers — a walk-forward, leakage-free backtest with realistic costs and slippage, an honest BACKTESTS.md, and a reflexion loop that PROPOSES but never auto-deploys. A project-kit sub-skill loaded by new-project's routing whenever the user wants to BUILD a trading/quant strategy, backtest an edge, or research a signal. Built on a disciplined honest-eval culture. Paper/research only by default.
---

# quant-strategy — a strategy that survives an honest backtest

## What this sub-skill is for
Standing up a **single, standalone trading strategy**: define the signal, backtest it
**honestly** (walk-forward, no lookahead, no leakage, realistic costs + slippage), and only
then judge whether it has an edge. Loaded by `new-project` for any quant/strategy/backtest
project. This is the lighter cousin of a full, disciplined honest-eval trading project and
inherits its sacred rule: **honest backtests above all** — a flattering equity curve is a
failure, an honest losing one is a success.

## Mandatory grill-questions (fold into the Definition of Ready)
- **Edge thesis:** what is the *mechanism* of the edge (why should this make money)? What
  would falsify it? Is it momentum / mean-reversion / carry / event / stat-arb?
- **Universe & data:** which instruments (crypto / equities / FX)? Data source, frequency,
  history length, **survivorship-bias-free?** Point-in-time correct (no restated data)?
- **Costs reality:** commissions, **slippage model**, spread, borrow/funding, market impact.
  What fill assumption (close, next-open, mid, VWAP)? These are decided up front, not tuned.
- **Validation design:** **walk-forward** windows (train/test roll), out-of-sample fraction,
  and a **locked final holdout** opened once. How many parameters — and the overfit budget?
- **Lookahead audit:** does any signal at bar *t* use bar-*t* (or future) information for a
  fill at bar *t*? Any indicator computed on the full series instead of expanding window?
- **Risk & sizing:** position sizing, max drawdown tolerance, leverage, stop logic.
- **Mode:** paper/research/backtest-only (default) — live is a separate, manual decision.

## Project sub-agents to generate (`.claude/agents/`) — honest-eval roster
- **quant-engineer** — implements the strategy + backtester modules in Python **with pytest
  tests, green before reporting**; fail-closed on money/risk logic; never flips to live
  (delegate-by-default for strategy code).
- **backtest-analyst** — runs the backtest and evaluates it **honestly**: total/annualized
  return, Sharpe, Sortino, **max drawdown**, trade count, win-rate, profit-factor, cost share
  of gross, exposure. Flags Sharpe > 3 / win-rate > 70% as leakage suspects, fragile results
  (< 5 trades or one window), and IS-vs-OOS gaps > 2× as overfit. **Never changes strategy
  code.** Delegate-by-default before any result is believed.
- **quant-strategy-scout** — researches the strategy/signal against public evidence (papers,
  practitioner blogs, repos): edge thesis, evidence quality, known pitfalls, feasibility.
  Read-only.
- **trading-reflexion** — reads the ledger/reports/logs and **proposes 1–2 concrete
  experiments** (hypothesis → test → criterion) into the task queue; honors a "don't
  re-propose discarded ideas" rule. **Proposes only — never deploys, never edits strategy
  or risk code.**

## Tools / CLIs / MCP / skills needed
- Python + `.venv` (honest-eval pattern): pandas/polars, numpy, a backtest engine
  (vectorbt / backtrader / custom event-driven), pyarrow for parquet, pytest. Install at
  environment-readiness (surface + offer; never auto-install). Use a dedicated venv python.
- Data: a free market-data source (free-data-only by default); cache to parquet.
- **Supabase MCP** (chain) only if storing runs/trades in Postgres; **n8n MCP** (chain) for
  scheduled research/backtest runs.
- **Global skills/agents to chain:** `deep-research` and the **`quant-strategy-scout`**
  agent for the edge thesis with evidence; the **`backtest-analyst`** agent for the honest
  eval; `market-researcher` (agent) for broker/fee/data-source facts; `code-review` and
  `verify` on the backtester before trusting any number.

## File / asset nudges (on top of the base set)
- **`BACKTESTS.md`** — the honest results doc: per-run return/Sharpe/Sortino/**max
  drawdown**/trades/win-rate/profit-factor, the **walk-forward setup**, the **cost &
  slippage assumptions**, the lookahead/leakage audit done, OOS result, and known failure
  regimes. Bad-but-honest results recorded straight.
- `STRATEGY.md` — the edge thesis, entry/exit rules, parameters, and falsification criteria.
- `RISK.md` — sizing, leverage, drawdown limits, kill-switches.
- `data/` (parquet cache, git-ignored if large; manifest tracked), `backtests/` (one logged
  run per config: params + metrics + seed + git SHA), `research/reflexion-journal.md`.
- `.env.template` (keys only, no values; real `.env` git-ignored).

## Stack defaults & done-bar
**Default stack:** Python + `.venv`, pandas + a vectorized/event-driven backtester,
point-in-time parquet data, walk-forward validation, results logged to `backtests/` and
summarized in `BACKTESTS.md`. Paper/research mode only by default.
**Done-bar (all must hold):**
1. The strategy passes an **honest out-of-sample / walk-forward** test with the locked
   holdout opened exactly once.
2. Backtest includes **realistic costs + slippage**; the edge survives a cost +50% stress
   (or `BACKTESTS.md` honestly states it does not).
3. **No lookahead/leakage** — audited by `backtest-analyst`; bar-*t* fills use only ≤ *t*−1
   information; indicators use expanding/rolling windows, not the full series.
4. All assumptions (data, costs, fills, sizing) are **documented in `BACKTESTS.md`**.
5. The reflexion loop **proposes** experiments into the queue and **never auto-deploys**.

## Guardrails
- **Honest backtests are sacred.** An overfit/leaky positive result is worthless and
  dangerous; an honest negative result is a real finding. Never tune the backtester to make a
  strategy look good.
- **No lookahead, ever.** A signal must not use information unavailable at decision time;
  fills must use realistic, executable prices. The `backtest-analyst` flags any violation.
- **Walk-forward, not single-split fitting.** One in-sample fit proves nothing; roll the
  windows and keep a final untouched holdout.
- **Costs and slippage are not optional.** A strategy that only works at zero cost has no
  edge. Model spread, commission, slippage, and (where relevant) funding/borrow.
- **Beware overfitting the parameter search.** Track the parameter/overfit budget; treat
  Sharpe > 3 or win-rate > 70% at high frequency as a leakage suspect until proven otherwise.
- **Paper/research only by default.** Never enable live trading, set a live mode, or place
  real orders; going live is a separate, explicit, human decision with a stop-and-confirm
  gate (e.g. a `TRADING_MODE=live` invariant that defaults off).
- **Reflexion proposes, never deploys** — and never edits strategy/risk code.
- Mark unverified edge claims as unverified; commits under the user's own name only — no
  Claude co-author.
