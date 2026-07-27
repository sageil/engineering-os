#!/usr/bin/env bash
set -euo pipefail
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
VERSION=$(cat "$ROOT/VERSION")
[[ "$VERSION" == "3.0.0" ]] || { echo "Unexpected VERSION: $VERSION" >&2; exit 1; }
test -f "$ROOT/AGENTS.md"
test -f "$ROOT/kernel/engineering-constitution.md"
test -f "$ROOT/manifest.yaml"
test -f "$ROOT/profiles/lightweight.skills"
test -f "$ROOT/profiles/balanced.skills"
test -f "$ROOT/profiles/strict.skills"
count=0
find "$ROOT/skills" -name SKILL.md | while IFS= read -r file; do
  grep -q '^---$' "$file"
  grep -q '^name:' "$file"
  grep -q '^description:' "$file"
  grep -q '^## Capability handoff' "$file"
done
count=$(find "$ROOT/skills" -name SKILL.md | wc -l | tr -d ' ')
[[ "$count" -eq 10 ]] || { echo "Expected 10 skills, found $count" >&2; exit 1; }
for profile in lightweight balanced strict; do
  while IFS= read -r skill || [[ -n "$skill" ]]; do
    [[ -z "$skill" ]] || test -f "$ROOT/skills/$skill/SKILL.md"
  done < "$ROOT/profiles/$profile.skills"
done
for file in "$ROOT/scripts"/*.sh; do bash -n "$file"; done
if grep -RIn --exclude=validate.sh -E 'find .*-(printf|print0)|mapfile|readarray' "$ROOT/scripts" >/dev/null 2>&1; then
  echo "GNU-only or Bash 4-only construct found in scripts" >&2
  exit 1
fi
echo "Validated Engineering OS $VERSION with $count skills."
