# workflows/

Optional deterministic scripts that the kit or a project can run for a fixed multi-step
sequence — e.g. a "research → merge → build" pass when adding a new ultra-skill — instead of
leaving each step to ad-hoc subagent delegation. A script here still follows the same rules as
a generated agent: each stage is checked before the next runs, and nothing it produces gets
published/deployed without the user confirming. Empty for now; add scripts here as needed.
See `docs/EXTENDING.md`.
