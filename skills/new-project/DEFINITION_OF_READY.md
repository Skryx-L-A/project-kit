# Definition of Ready (DoR) — the gate before any build

This is the **most important moment of a new project**. Nothing gets scaffolded, no folder,
no code, until every **mandatory** item below is locked. The list is **Full+ and
open-ended**: keep asking as new questions surface; add project-specific questions from the
matched sub-skills. Over-ask now to avoid rework later.

Grill **one question at a time, each with a recommended answer**. Answer from the codebase /
web / the user's existing projects whenever you can, instead of asking.

---

## A. Mandatory — must be locked before scaffolding

1. **Name** — project name (→ `~/AI/<kebab-name>`, repo name, skill triggers).
2. **One-sentence goal** — what this project is, in one line a stranger would understand.
3. **Audience / who uses or reads it** — and their technical level.
4. **Business relationship** (the early fork — see `BUSINESS_BRANCH.md`): new business /
   existing business / part of a business / no business. For *existing*: does a profile /
   memory / MD structure already exist, and what should be adopted vs. rebuilt?
5. **Project type(s)** — one or many (composable). Drives sub-skill routing (`ROUTING.md`).
6. **Stack / toolchain** — languages, frameworks, key libraries, hosting target.
7. **Scope — in and out** — what is explicitly in v1 and what is explicitly *not*.
8. **Repo choice** — public / private / none. (Public ⇒ strict `.gitignore` of personal data.)
9. **Done-bar** — the concrete, checkable definition of "this is finished / working".
10. **Key locked decisions** — every branch the grill resolved (record them; they go into
    the project bible so they are not re-litigated).
11. **Constraints** — language of UI vs. code, DSGVO/privacy, accessibility, **no emojis in
    app UIs** (user standing rule), licensing, brand, deadlines.
12. **Autonomy level** — how much the agent drives without pausing (default: high autonomy,
    stop only at real decisions / risky ops).

## B. Strongly expected — resolve before building, may be filled during scaffold

13. **Risks & open questions** — what could go wrong; what is still unknown/flagged.
14. **Milestone / phase plan** — the rough sequence from zero to done-bar.
15. **Needed skills / sub-agents / MCP / tools / CLIs** — and which are missing (→
    `ENVIRONMENT_READINESS.md`).
16. **Deploy / hosting / distribution target** — where it ships, how it is released.
17. **Memory topics** — what durable facts to seed (goal, stack, decisions, contacts).
18. **Success metrics** — if measurable (users, revenue, accuracy, performance).

## C. Type-specific — pulled in by the matched sub-skill(s)

Each sub-skill under `KIT/skills/<name>/SKILL.md` contributes its own mandatory questions —
e.g. `build-business` adds market/budget/country/offer; `website` adds brand/pages/CMS;
`data-ml` adds dataset/eval/leakage guardrails; `quant-strategy` adds data source/backtest
honesty. Fold those into the grill before scaffolding that part.

---

## Gate check

Before calling `scaffold.sh`, confirm out loud (to yourself, then summarise for the user):
- [ ] All of **section A** answered and recorded.
- [ ] Business branch resolved; existing-business adoption handled, not blindly rebuilt.
- [ ] All applicable types detected and their sub-skills' mandatory questions answered.
- [ ] Environment readiness checked; missing tools flagged/offered; creds requested.
- [ ] File set and memory strategy chosen (adaptively, not by asking the user a count).

If any box is unchecked, **keep grilling**. Only then scaffold.

> The user has explicitly asked to be grilled as thoroughly as possible here and has invited
> you to keep asking whenever new questions arise. Honour that — depth at this gate is the
> whole point of the kit.
