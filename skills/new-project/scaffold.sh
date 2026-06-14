#!/usr/bin/env bash
# scaffold.sh — deterministic skeleton generator for new-project (project-kit)
# Lays down the file set + placeholder files for a tier. Claude fills the placeholders after.
#
# Usage:
#   scaffold.sh --name "<Project Name>" --tier tiny|standard|large [options]
# Options:
#   --path <dir>        target dir (default: ~/AI/<kebab-name>)
#   --git               run `git init` + write .gitignore
#   --status            force add STATUS.md
#   --deployment        force add DEPLOYMENT.md
#   --prompts-dir       add a prompts/ folder (build-business)
#   --reports-dir       add a berichte/ folder (research-decision)
#   --dry-run           print what would happen, create nothing
set -euo pipefail

SELF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TPL="$SELF_DIR/templates"

NAME="" TIER="standard" TARGET="" DO_GIT=0 ADD_STATUS=0 ADD_DEPLOY=0 ADD_PROMPTS=0 ADD_REPORTS=0 DRY=0
while [ $# -gt 0 ]; do
  case "$1" in
    --name) NAME="$2"; shift 2;;
    --tier) TIER="$2"; shift 2;;
    --path) TARGET="$2"; shift 2;;
    --git) DO_GIT=1; shift;;
    --status) ADD_STATUS=1; shift;;
    --deployment) ADD_DEPLOY=1; shift;;
    --prompts-dir) ADD_PROMPTS=1; shift;;
    --reports-dir) ADD_REPORTS=1; shift;;
    --dry-run) DRY=1; shift;;
    *) echo "unknown arg: $1" >&2; exit 2;;
  esac
done
[ -n "$NAME" ] || { echo "scaffold.sh: --name required" >&2; exit 2; }

# slug helpers
slug() { echo "$1" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g'; }
SLUG="$(slug "$NAME")"
SLUG_UPPER="$(echo "$SLUG" | tr '[:lower:]-' '[:upper:]_')"
DATE="$(date +%Y-%m-%d)"
[ -n "$TARGET" ] || TARGET="$HOME/AI/$SLUG"

emit() { # emit <template> <dest>
  local src="$TPL/$1" dst="$TARGET/$2"
  if [ "$DRY" = 1 ]; then echo "  would write $dst"; return; fi
  mkdir -p "$(dirname "$dst")"
  sed -e "s/{{PROJECT_NAME}}/${NAME//\//\\/}/g" \
      -e "s/{{PROJECT_SLUG_UPPER}}/$SLUG_UPPER/g" \
      -e "s/{{DATE}}/$DATE/g" \
      "$src" > "$dst"
}

echo "scaffold: '$NAME'  tier=$TIER  ->  $TARGET"
[ "$DRY" = 1 ] && echo "(dry run)"
[ "$DRY" = 1 ] || mkdir -p "$TARGET"

# always
emit CLAUDE.md.tmpl  "CLAUDE.md"
emit README.md.tmpl  "README.md"

case "$TIER" in
  tiny)
    : ;;  # CLAUDE.md + README only
  standard|large)
    emit PROJEKT.md.tmpl "PROJEKT_${SLUG_UPPER}.md"
    emit TASKS.md.tmpl   "TASKS.md"
    emit DONE.md.tmpl    "DONE.md"
    if [ "$DRY" = 0 ]; then
      mkdir -p "$TARGET/.claude/agents"
      cp "$TPL/settings.local.json.tmpl" "$TARGET/.claude/settings.local.json"
    else
      echo "  would create .claude/agents/ + settings.local.json"
    fi
    ;;
  *) echo "unknown tier: $TIER" >&2; exit 2;;
esac

[ "$TIER" = large ] && { ADD_STATUS=1; ADD_DEPLOY=1; }
[ "$ADD_STATUS" = 1 ] && emit STATUS.md.tmpl "STATUS.md"
[ "$ADD_DEPLOY" = 1 ] && emit DEPLOYMENT.md.tmpl "DEPLOYMENT.md"
[ "$ADD_PROMPTS" = 1 ] && { [ "$DRY" = 0 ] && mkdir -p "$TARGET/prompts" || echo "  would create prompts/"; }
[ "$ADD_REPORTS" = 1 ] && { [ "$DRY" = 0 ] && mkdir -p "$TARGET/berichte" || echo "  would create berichte/"; }

if [ "$DO_GIT" = 1 ]; then
  if [ "$DRY" = 0 ]; then
    cp "$TPL/gitignore.tmpl" "$TARGET/.gitignore"
    ( cd "$TARGET" && git init -q && git add -A )
    echo "  git initialised (+ .gitignore). Set identity + commit after filling placeholders."
  else
    echo "  would git init + write .gitignore"
  fi
fi

echo "done. Skeleton laid. Now FILL every {{PLACEHOLDER}} from the Definition of Ready."
