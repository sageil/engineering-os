#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="${1:-${HOME}/.agents/skills}"
find "$ROOT/skills" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | while read -r s; do rm -rf "$TARGET/$s"; done
echo "Removed Engineering OS skills from $TARGET"
