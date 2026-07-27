#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required=(
  "$ROOT/SKILL.md"
  "$ROOT/README.md"
  "$ROOT/LICENSE"
  "$ROOT/VERSION"
)

for file in "${required[@]}"; do
  [[ -f "$file" ]] || { echo "Missing required file: $file" >&2; exit 1; }
done

grep -q '^name: plan-gate$' "$ROOT/SKILL.md" || {
  echo "SKILL.md is missing the expected name" >&2
  exit 1
}

grep -q '^description:' "$ROOT/SKILL.md" || {
  echo "SKILL.md is missing a description" >&2
  exit 1
}

find "$ROOT/references" -type f -name '*.md' | grep -q . || {
  echo "No reference files found" >&2
  exit 1
}

find "$ROOT/evals" -type f -name '*.yaml' | grep -q . || {
  echo "No evaluation files found" >&2
  exit 1
}

echo "plan-gate package validation passed"
