#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILLS_HOME="${AGENT_SKILLS_HOME:-$HOME/.codex/skills}"
DEST="$SKILLS_HOME/engineering-quality"

mkdir -p "$SKILLS_HOME"

if [[ -e "$DEST" ]]; then
  backup="$DEST.backup.$(date +%Y%m%d%H%M%S)"
  mv "$DEST" "$backup"
  echo "Existing installation moved to: $backup"
fi

cp -R "$SOURCE_DIR" "$DEST"
rm -rf "$DEST/.git" 2>/dev/null || true

echo "Installed engineering-quality to: $DEST"
echo "Restart or reload your agent harness if the skill is not discovered immediately."
