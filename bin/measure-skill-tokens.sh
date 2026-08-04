#!/usr/bin/env bash
# measure-skill-tokens.sh — sum the `description:` field of every SKILL.md directly under
# skills/ (the set Claude Code registers and loads into every session) and estimate the
# token cost at ~4 chars/token. Point of the script: catch regressions where a sub-skill
# that should live under routes/ (path-loaded only, e.g. by new-project) ends up back
# under skills/ and silently taxes every session again.
set -euo pipefail

KIT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_DIR="$KIT/skills"

total_chars=0
count=0

for f in "$SKILLS_DIR"/*/SKILL.md; do
  [ -f "$f" ] || continue
  desc="$(sed -n 's/^description: //p' "$f" | head -1)"
  chars=${#desc}
  total_chars=$((total_chars + chars))
  count=$((count + 1))
  printf '  %-28s %6d chars\n' "$(basename "$(dirname "$f")")" "$chars"
done

tokens=$((total_chars / 4))
echo "---"
echo "skills registered: $count"
echo "description chars: $total_chars"
echo "estimated tokens (chars/4): $tokens"
