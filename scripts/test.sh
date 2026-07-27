#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
"$ROOT/scripts/validate.sh"
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
HOME="$TMP" "$ROOT/scripts/install.sh" --profile lightweight --target "$TMP/skills-light" >/dev/null
[[ $(find "$TMP/skills-light" -mindepth 1 -maxdepth 1 -type d | wc -l) -eq 5 ]]
HOME="$TMP" "$ROOT/scripts/install.sh" --profile balanced --target "$TMP/skills-balanced" >/dev/null
expected=$(find "$ROOT/skills" -mindepth 1 -maxdepth 1 -type d | wc -l)
actual=$(find "$TMP/skills-balanced" -mindepth 1 -maxdepth 1 -type d | wc -l)
[[ "$actual" -eq "$expected" ]]
echo "Smoke tests passed for lightweight and balanced profiles."
