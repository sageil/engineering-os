#!/usr/bin/env bash
set -euo pipefail
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
VERSION=$(cat "$ROOT/VERSION")
[[ "$VERSION" == "3.0.0" ]] || { echo "Unexpected VERSION: $VERSION" >&2; exit 1; }
test -f "$ROOT/global-agents.md"
test -f "$ROOT/kernel/engineering-constitution.md"
test -f "$ROOT/manifest.yaml"
grep -q '^global_policy: global-agents.md$' "$ROOT/manifest.yaml"
count=0
find "$ROOT/skills" -mindepth 2 -maxdepth 2 -name SKILL.md | while IFS= read -r file; do
  grep -q '^---$' "$file"
  grep -q '^name:' "$file"
  grep -q '^description:' "$file"
  grep -q '^## Capability handoff' "$file"
done
count=$(find "$ROOT/skills" -mindepth 2 -maxdepth 2 -name SKILL.md | wc -l | tr -d ' ')
[[ "$count" -eq 10 ]] || { echo "Expected 10 skills, found $count" >&2; exit 1; }
manifest_count=0
while IFS= read -r skill; do
  test -f "$ROOT/skills/$skill/SKILL.md"
  grep -q "^name: $skill$" "$ROOT/skills/$skill/SKILL.md"
  manifest_count=$((manifest_count + 1))
done < <(awk '/^skills:$/ {in_skills=1; next} in_skills && /^[^ ]/ {exit} in_skills && /^  - / {sub(/^  - /, ""); print}' "$ROOT/manifest.yaml")
[[ "$manifest_count" -eq "$count" ]] || { echo "Manifest lists $manifest_count skills, found $count packages" >&2; exit 1; }
while IFS= read -r directory; do
  skill=${directory##*/}
  grep -q "^  - $skill$" "$ROOT/manifest.yaml"
done < <(find "$ROOT/skills" -mindepth 1 -maxdepth 1 -type d | LC_ALL=C sort)
for file in "$ROOT/scripts"/*.sh; do bash -n "$file"; done
if grep -RIn --exclude=validate.sh -E 'find .*-(printf|print0)|mapfile|readarray' "$ROOT/scripts" >/dev/null 2>&1; then
  echo "GNU-only or Bash 4-only construct found in scripts" >&2
  exit 1
fi
echo "Validated Engineering OS $VERSION with $count skills."
