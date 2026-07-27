#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROFILE=balanced
TARGET="${HOME}/.agents/skills"
while [[ $# -gt 0 ]]; do case "$1" in --profile) PROFILE="$2"; shift 2;; --target) TARGET="$2"; shift 2;; *) echo "Unknown argument: $1" >&2; exit 2;; esac; done
mkdir -p "$TARGET"
case "$PROFILE" in
  lightweight) SKILLS=(engineering-investigation engineering-decision engineering-quality engineering-communication adversarial-code-review);;
  balanced|strict) mapfile -t SKILLS < <(find "$ROOT/skills" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort);;
  *) echo "Unknown profile: $PROFILE" >&2; exit 2;;
esac
for skill in "${SKILLS[@]}"; do rm -rf "$TARGET/$skill"; cp -R "$ROOT/skills/$skill" "$TARGET/$skill"; done
echo "Installed ${#SKILLS[@]} Engineering OS skills to $TARGET ($PROFILE profile)."
