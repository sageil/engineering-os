#!/usr/bin/env bash
set -euo pipefail
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
"$ROOT/scripts/validate.sh"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

# A standard install manages every packaged skill.
HOME_DIR="$TMP/standard"
mkdir -p "$HOME_DIR"
HOME="$HOME_DIR" "$ROOT/scripts/install.sh" --agents keep >/dev/null
actual=$(find "$HOME_DIR/.agents/skills" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')
[[ "$actual" -eq 10 ]] || { echo "Standard install added $actual skills, expected 10" >&2; exit 1; }
if grep -q '^PROFILE=' "$HOME_DIR/.agents/.engineering-os/install-state.env"; then
  echo "Install state retained a profile" >&2
  exit 1
fi
HOME="$HOME_DIR" "$ROOT/scripts/uninstall.sh" --agents keep >/dev/null
remaining=$(find "$HOME_DIR/.agents/skills" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
[[ "$remaining" -eq 0 ]] || { echo "Uninstall left skills behind" >&2; exit 1; }

# Existing AGENTS.md and skill are restored.
HOME_DIR="$TMP/restore"
mkdir -p "$HOME_DIR/.agents/skills/engineering-quality"
printf 'original policy\n' > "$HOME_DIR/.agents/AGENTS.md"
printf 'original skill\n' > "$HOME_DIR/.agents/skills/engineering-quality/original.txt"
HOME="$HOME_DIR" "$ROOT/scripts/install.sh" --agents replace >/dev/null
HOME="$HOME_DIR" "$ROOT/scripts/uninstall.sh" --agents restore >/dev/null
grep -q '^original policy$' "$HOME_DIR/.agents/AGENTS.md"
grep -q '^original skill$' "$HOME_DIR/.agents/skills/engineering-quality/original.txt"

# Modified AGENTS.md is preserved by the safe default.
HOME_DIR="$TMP/modified"
mkdir -p "$HOME_DIR/.agents"
printf 'before\n' > "$HOME_DIR/.agents/AGENTS.md"
HOME="$HOME_DIR" "$ROOT/scripts/install.sh" --agents replace >/dev/null
printf '\nuser edit\n' >> "$HOME_DIR/.agents/AGENTS.md"
HOME="$HOME_DIR" "$ROOT/scripts/uninstall.sh" --agents keep >/dev/null
grep -q 'user edit' "$HOME_DIR/.agents/AGENTS.md"

# Leaving a managed AGENTS.md unchanged during update preserves its ownership state.
HOME_DIR="$TMP/update"
mkdir -p "$HOME_DIR"
HOME="$HOME_DIR" "$ROOT/scripts/install.sh" --agents replace >/dev/null
HOME="$HOME_DIR" "$ROOT/scripts/update.sh" --agents keep >/dev/null
grep -q '^AGENTS_ACTION=replace$' "$HOME_DIR/.agents/.engineering-os/install-state.env"
HOME="$HOME_DIR" "$ROOT/scripts/uninstall.sh" --agents restore >/dev/null
[[ ! -e "$HOME_DIR/.agents/AGENTS.md" ]] || { echo "Uninstall left a managed AGENTS.md behind" >&2; exit 1; }

echo "Smoke tests passed for full installation, restoration, edit preservation, and update ownership."
