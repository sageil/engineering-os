#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
required=(
  SKILL.md README.md CHANGELOG.md LICENSE VERSION
  references/readme.md references/pr-descriptions.md references/adrs-and-rfcs.md
  references/runbooks.md references/migration-guides.md references/api-docs.md
  references/release-notes.md evals/trigger-cases.yaml evals/behavior-cases.yaml
)
for path in "${required[@]}"; do
  test -f "$ROOT/$path" || { echo "Missing $path" >&2; exit 1; }
done
grep -q '^name: engineering-communication$' "$ROOT/SKILL.md"
grep -q '^description:' "$ROOT/SKILL.md"
echo "Package structure is valid."
