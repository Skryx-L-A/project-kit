# ENVIRONMENT READINESS — make the project as ready as possible before work starts

Before any task begins, verify the machine actually has what the chosen stack and the matched
sub-skills need. The goal: the user never hits "command not found" or "missing key" mid-build.

## What to check
1. **Runtimes & package managers** the stack needs — e.g. `node`/`npm`/`pnpm`, `python3`/
   `pip`/`uv`, `cargo`, `go`, `dotnet`, `flutter`, etc.
2. **CLIs & tools** the sub-skills declare — e.g. `git`, `gh`, `netlify`/`vercel`,
   `docker`, `astro`, `eas`, `yt-dlp`, `ffmpeg`, a Proton/UE4SS toolchain for game mods, etc.
3. **The user's already-available tools** — discover what is on PATH and prefer it; don't
   reinstall what exists. (`command -v <tool>`; check the user's existing projects/venvs.)
4. **MCP servers / skills** the project will lean on (browser automation, design-harvest,
   higgsfield, etc.).
5. **Secrets / accounts** — API keys, logins, tokens the stack or deploy target needs.

## How to act on gaps — strict rules
- **Missing tool/CLI/runtime:** *point it out and offer to install it.* Show the exact
  install command and wait for a yes. **Never auto-install.**
- **Missing secret / key / login:** *ask the user to log in or paste the key.* Tell them
  exactly which service and scope. **Never invent, guess, or hardcode a credential, and never
  commit one** (it goes in `.env`/secret store, which is `.gitignore`d).
- **Optional/nice-to-have:** mention it once, don't block on it.
- Record the readiness result in the project bible (`PROJEKT_<NAME>.md`) so a later session
  knows what is installed and what is still pending.

## Quick probe snippet (adapt per stack)
```bash
for t in git gh node npm python3 pip docker; do
  command -v "$t" >/dev/null 2>&1 && echo "ok   $t -> $(command -v $t)" || echo "MISS $t"
done
```
Then, for anything `MISS`, surface a one-line "want me to install <t>? (`<install cmd>`)".
