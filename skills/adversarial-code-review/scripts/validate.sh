#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
required=(
  SKILL.md README.md LICENSE VERSION CHANGELOG.md
  references/security.md references/data-and-migrations.md
  references/concurrency-and-distributed-systems.md
  references/api-compatibility.md references/frontend-accessibility.md
  references/performance.md references/testing.md
  evals/trigger-cases.yaml evals/false-positive-cases.yaml
  evals/true-positive-cases.yaml evals/severity-calibration.yaml
  evals/no-findings-cases.yaml evals/recommendation-quality.yaml
)
for file in "${required[@]}"; do
  test -s "$ROOT/$file" || { echo "Missing or empty: $file" >&2; exit 1; }
done
grep -q '^name: adversarial-code-review$' "$ROOT/SKILL.md"
grep -q '^description:' "$ROOT/SKILL.md"
echo "Package validation passed."
