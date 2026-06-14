---
name: llm-app
description: Build/set up an LLM-powered PRODUCT — a chatbot, RAG-over-documents app, agent app, or fine-tune — from the user's grilled answers. Project-kit sub-skill loaded by new-project routing whenever someone wants to build an AI app, a chatbot, RAG, "chat with my docs", an LLM agent product, or fine-tune a model. Chains claude-api + Supabase pgvector + skill-creator evals, and bakes in grounded citations, an eval set, and hallucination/jailbreak/PII guardrails.
---

# llm-app — ship an LLM product that's grounded and evaluated

## What this sub-skill is for
Standing up an **LLM-powered product**: a chatbot, **RAG** over the user's documents, an **agent
app** that calls tools, or a **fine-tune** for a narrow task. Loaded by `new-project` for any
"build an AI app / chat with my data / RAG / LLM agent" request. This is distinct from
`ai-agent-mcp` (which *authors* skills/subagents/MCP servers as meta-tooling) and from `data-ml`
(generic model training/eval). The whole skill is organized around two non-negotiables:
**answers are grounded with citations, and an eval set + guardrails prove it before "done".**

## Mandatory grill-questions (fold into the Definition of Ready)
Lock these before any code:
- **Approach** — **RAG** (ground on documents) vs. **fine-tune** (teach a narrow style/format) vs.
  **prompt-only** (good system prompt + tools). Default to prompt-only → RAG; fine-tune only when
  prompting+RAG demonstrably fall short. Justify the pick.
- **Base model** — chain `claude-api` for current ids: `claude-opus-4-8` (most capable),
  `claude-sonnet-4-6`, `claude-haiku-4-5-20251001`, `claude-fable-5`. Default to the newest capable
  that fits cost+latency; never guess model ids/pricing from memory.
- **Vector store + chunking** (RAG) — **Supabase pgvector by default**; chunk size/overlap,
  embedding model, and how chunks map back to a citeable source. How is retrieval *evaluated*?
- **Data sources + ingestion** — where docs come from, formats (PDF/HTML/markdown), refresh
  cadence, and the ingestion pipeline (parse → chunk → embed → upsert). Licensing/consent of the
  corpus.
- **Eval set + success threshold** — a held-out set of question→expected-grounded-answer cases,
  the metric (groundedness / answer correctness / citation accuracy), and **the pass threshold
  decided before seeing results**. No eval set = not Ready.
- **Guardrails** — hallucination policy (must cite or say "I don't know"), jailbreak resistance,
  and **PII handling** (redact/never-store). These are required, not optional.
- **Streaming + prompt-caching** — stream tokens to the UI? Cache the system prompt / retrieved
  context to cut cost+latency (chain `claude-api` for caching mechanics).
- **Cost budget** — per-query and monthly ceiling; pick model + caching + retrieval depth to fit it.

## Project sub-agents to generate (into `<project>/.claude/agents/`)
- **`rag-indexer`** *(delegate-by-default)* — owns ingestion: parse → chunk → embed → upsert into
  pgvector, keeps source→chunk citation links intact, and re-indexes on data refresh.
- **`eval-harness`** *(delegate-by-default)* — builds/runs the eval set (groundedness, citation
  accuracy, answer correctness, latency/cost), reports pass/fail against the threshold honestly,
  and **blocks "done" on red**. Chains the `skill-creator` eval harness.
- **`prompt-engineer`** — writes/tightens the system prompt, retrieval-to-prompt assembly, and the
  cite-or-refuse instruction; tunes for groundedness without over-refusing.
- **`guardrail-reviewer`** *(delegate-by-default, adversarial)* — red-teams the app: jailbreak/prompt-
  injection attempts, PII leakage, and hallucination probes (ungrounded or out-of-corpus questions).
  Reports breaks plainly; never edits prompts to hide a failure.

## Tools / CLIs / MCP / skills needed
Check in environment-readiness; offer install, never auto-install:
- **Anthropic SDK** — `npm i @anthropic-ai/sdk` or `pip install anthropic`; `ANTHROPIC_API_KEY`
  from the user (never invent), in `.env` (never committed).
- **Supabase MCP** (chain) — Postgres + **pgvector** for the vector store; use it to create the
  table, the `vector` column, and the similarity index, and to run retrieval SQL.
- **Ingestion tooling** — a PDF/HTML parser (the `pdf` skill for PDFs), an embedding model, and a
  chunker. Streaming UI (SSE/WebSocket) if a frontend.
- **CHAIN these GLOBAL skills automatically:** `claude-api` (model ids, params, **tool use**,
  **prompt caching**, token counting — read before touching any model id or LLM behaviour),
  `skill-creator` (build + run + measure the eval set with variance analysis), `code-review` +
  `verify` before "done". Compose with `website`/`saas`/`api-backend` if it ships a real UI/backend.

## File / asset nudges (on top of the base set)
Beyond CLAUDE.md, PROJEKT_<NAME>.md, TASKS.md, DONE.md, README, `.claude/`:
- **`EVAL.md`** — the honest results doc: the eval set description, the metric + threshold, the
  scores (groundedness, citation accuracy, latency, cost/query), guardrail red-team results, and
  **where it fails / hallucinates**. Bad-but-honest numbers go here unedited.
- `evals/` — the held-out cases + a runner + a results log. Non-optional here.
- `prompts/` — versioned system prompt(s) and the retrieval-to-prompt template.
- `ingestion/` — the parse→chunk→embed→upsert pipeline; `corpus/` (or a manifest) with source
  provenance/licensing; a `CORPUS.md`.
- `.env.example` — `ANTHROPIC_API_KEY`, Supabase keys (templates only; never the real `.env`).

## Stack defaults & done-bar
**Default stack:** Anthropic SDK with the newest capable model (default `claude-opus-4-8`, drop to
`claude-sonnet-4-6` / `claude-haiku-4-5-20251001` for cost/latency), RAG over **Supabase pgvector**,
prompt caching on the system prompt + retrieved context, streaming responses, evals via
`skill-creator`'s harness, secrets in `.env`.
**Done-bar (all true):**
1. Answers are **grounded with citations** back to source chunks — or the app says "I don't know"
   rather than inventing.
2. The **eval set passes its documented threshold** on a held-out set, run by `eval-harness`.
3. **Guardrails hold** under `guardrail-reviewer`'s red-team (jailbreak resisted, PII not leaked,
   out-of-corpus questions refused not hallucinated) — or `EVAL.md` states the residual risk.
4. `EVAL.md` records the metric, threshold, scores, and known failure modes.
5. `code-review` + `verify` clean; README shows setup + one real grounded example.

## Guardrails
- **Honest eval — no cherry-picking.** The eval set and threshold are fixed before results; report
  the real numbers (including bad ones). `eval-harness`/`guardrail-reviewer` never edit prompts to
  flatter a score.
- **Cite or abstain.** The app must ground answers in retrieved sources or say it doesn't know —
  never present an ungrounded guess as fact. **Flag hallucination risk** wherever retrieval is thin.
- **PII handling** — redact/never-store PII per the grilled policy; never log raw user PII or paste
  it into chat; document what's retained.
- **Never hardcode or guess API keys, model ids, pricing, or params** — keys live in `.env`
  (templates committed, real keys never); read `claude-api` for everything model-shaped.
- **Least-privilege tools** for agent apps — give the model only the tools it needs; validate tool
  inputs; treat tool output as untrusted (prompt-injection surface).
- **No emojis in any app/chat UI or output** (user's standing rule) — typographic symbols only.
- **Commits under the user's own name only (Skryx-L-A); never add Claude as a co-author.**
