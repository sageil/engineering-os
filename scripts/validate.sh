#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
[[ "$(cat "$ROOT/VERSION")" == "2.0.0" ]]
test -f "$ROOT/kernel/engineering-constitution.md"
test -f "$ROOT/manifest.yaml"
count=0
while IFS= read -r -d '' file; do
  grep -q '^---$' "$file"
  grep -q '^name:' "$file"
  grep -q '^description:' "$file"
  count=$((count+1))
done < <(find "$ROOT/skills" -name SKILL.md -print0)
[[ $count -ge 17 ]]
for f in "$ROOT/scripts"/*.sh; do bash -n "$f"; done
echo "Validated Engineering OS v2 with $count skills."
