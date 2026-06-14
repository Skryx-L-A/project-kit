# Contributing

This is primarily one person's bootstrap kit, but it's public so anyone can clone and adapt it.

- Add a project type → see `docs/EXTENDING.md`.
- Keep `SKILL.md` files self-contained and trigger-accurate; use real tool names.
- Never commit secrets or personal data. `.gitignore` covers the usual; double-check before PRs.
- Commit style: imperative subject; the author's own name only (no AI co-author trailers).
- Test a change with `./install.sh --force` then a dry-run scaffold:
  `project-kit new --name "Test" --tier large --dry-run`.
