#!/usr/bin/env bash
# install.sh — wire project-kit into Claude so `new-project` (+ sub-skills) trigger anywhere.
# Fallback installer. The recommended path is the Claude Code plugin:
#   /plugin marketplace add Skryx-L-A/project-kit  &&  /plugin install project-kit@project-kit
# Don't use both — they'd register the same skills twice.
#
#   ./install.sh                 # symlink all skills into ~/.claude/skills (repo = source of truth)
#   ./install.sh --copy          # copy instead of symlink (for people who'll move/delete the repo)
#   ./install.sh --force         # overwrite existing skills of the same name
#   ./install.sh --no-claude-md  # skip adding the global CLAUDE.md trigger entry
#   ./install.sh --uninstall     # remove the symlinks/copies this kit installed
set -euo pipefail

KIT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$KIT/skills"
SKILLS_DST="$HOME/.claude/skills"
CLAUDE_MD="$HOME/.claude/CLAUDE.md"
BIN_DST="$HOME/.local/bin"
MODE="symlink" FORCE=0 DO_CLAUDE_MD=1 UNINSTALL=0

while [ $# -gt 0 ]; do
  case "$1" in
    --copy) MODE="copy"; shift;;
    --force) FORCE=1; shift;;
    --no-claude-md) DO_CLAUDE_MD=0; shift;;
    --uninstall) UNINSTALL=1; shift;;
    *) echo "unknown arg: $1" >&2; exit 2;;
  esac
done

mkdir -p "$SKILLS_DST" "$BIN_DST"

marker_begin="<!-- project-kit:begin -->"
marker_end="<!-- project-kit:end -->"

if [ "$UNINSTALL" = 1 ]; then
  for d in "$SKILLS_SRC"/*/; do
    name="$(basename "$d")"; target="$SKILLS_DST/$name"
    if [ -L "$target" ] || [ -d "$target" ]; then
      # only remove if it points back at our repo (symlink) or we own it
      if [ -L "$target" ] && [ "$(readlink -f "$target")" = "$(readlink -f "$d")" ]; then
        rm -f "$target"; echo "removed symlink $name"
      fi
    fi
  done
  [ -L "$BIN_DST/project-kit" ] && rm -f "$BIN_DST/project-kit" && echo "removed bin/project-kit"
  if [ -f "$CLAUDE_MD" ]; then
    sed -i "/$marker_begin/,/$marker_end/d" "$CLAUDE_MD" && echo "removed CLAUDE.md entry"
  fi
  echo "uninstalled."; exit 0
fi

echo "project-kit install ($MODE) from $KIT"
count=0
for d in "$SKILLS_SRC"/*/; do
  name="$(basename "$d")"; target="$SKILLS_DST/$name"
  if [ -e "$target" ] || [ -L "$target" ]; then
    if [ "$FORCE" = 1 ]; then rm -rf "$target"; else echo "  skip $name (exists; --force to overwrite)"; continue; fi
  fi
  if [ "$MODE" = symlink ]; then ln -s "$d" "$target"; else cp -r "$d" "$target"; fi
  echo "  + $name"; count=$((count+1))
done
echo "installed/linked $count skills into $SKILLS_DST"

# convenience CLI
if [ -f "$KIT/bin/project-kit" ]; then
  ln -sf "$KIT/bin/project-kit" "$BIN_DST/project-kit"
  echo "  + bin/project-kit -> $BIN_DST (ensure ~/.local/bin is on PATH)"
fi

# global CLAUDE.md trigger entry (idempotent, fallback to the skill)
if [ "$DO_CLAUDE_MD" = 1 ]; then
  touch "$CLAUDE_MD"
  if grep -q "$marker_begin" "$CLAUDE_MD"; then
    echo "  CLAUDE.md entry already present"
  else
    cat >> "$CLAUDE_MD" <<EOF

$marker_begin
## \`new-project\` / project-kit — use it to start ANY new project

When the user wants to **start / create / set up a new project** (folder, repo, app, site,
tool, business, research — anything), invoke the **\`new-project\`** skill. Its home is the
**project-kit** repo (default \`~/AI/project-kit\`), which describes the whole process:
grill the plan to a full Definition of Ready, then auto-scaffold the right file/memory
structure, project-specific sub-agents, and tooling, routing to the matching type sub-skills
(build-business, website, api-backend, data-ml, quant-strategy, game-mod, research-decision,
content-writing, oss-library, browser-extension, bot-automation, saas, cli-tool, desktop-app,
mobile-app, ai-agent-mcp, or a generic fallback). The user should never have to point at the
folder — trigger it automatically at the start of any new project.
$marker_end
EOF
    echo "  + added project-kit entry to $CLAUDE_MD"
  fi
fi

echo "done."
