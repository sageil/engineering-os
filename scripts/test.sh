#!/usr/bin/env bash
set -euo pipefail
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
"$ROOT/scripts/validate.sh"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

run_profile() {
  local profile=$1
  local expected=$2
  local home="$TMP/$profile"
  mkdir -p "$home"
  HOME="$home" "$ROOT/scripts/install.sh" --profile "$profile" --agents keep >/dev/null
  actual=$(find "$home/.agents/skills" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')
  [[ "$actual" -eq "$expected" ]] || { echo "$profile installed $actual skills, expected $expected" >&2; exit 1; }
  HOME="$home" "$ROOT/scripts/uninstall.sh" --agents keep >/dev/null
  remaining=$(find "$home/.agents/skills" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
  [[ "$remaining" -eq 0 ]] || { echo "$profile uninstall left skills behind" >&2; exit 1; }
}
run_profile lightweight 5
run_profile balanced 10
run_profile strict 10

# Existing AGENTS.md and skill are restored.
HOME_DIR="$TMP/restore"
mkdir -p "$HOME_DIR/.agents/skills/engineering-quality"
printf 'original policy\n' > "$HOME_DIR/.agents/AGENTS.md"
printf 'original skill\n' > "$HOME_DIR/.agents/skills/engineering-quality/original.txt"
HOME="$HOME_DIR" "$ROOT/scripts/install.sh" --profile lightweight --agents replace >/dev/null
HOME="$HOME_DIR" "$ROOT/scripts/uninstall.sh" --agents restore >/dev/null
grep -q '^original policy$' "$HOME_DIR/.agents/AGENTS.md"
grep -q '^original skill$' "$HOME_DIR/.agents/skills/engineering-quality/original.txt"

# Modified AGENTS.md is preserved by the safe default.
HOME_DIR="$TMP/modified"
mkdir -p "$HOME_DIR/.agents"
printf 'before\n' > "$HOME_DIR/.agents/AGENTS.md"
HOME="$HOME_DIR" "$ROOT/scripts/install.sh" --profile lightweight --agents replace >/dev/null
printf '\nuser edit\n' >> "$HOME_DIR/.agents/AGENTS.md"
HOME="$HOME_DIR" "$ROOT/scripts/uninstall.sh" --agents keep >/dev/null
grep -q 'user edit' "$HOME_DIR/.agents/AGENTS.md"

echo "Smoke tests passed for all profiles, restoration, and edit preservation."
