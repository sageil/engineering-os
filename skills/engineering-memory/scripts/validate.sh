#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
test -f "$root/SKILL.md"
grep -q '^name: engineering-memory$' "$root/SKILL.md"
grep -q '^description: >' "$root/SKILL.md"
test -f "$root/README.md"
test -d "$root/references"
test -d "$root/evals"
find "$root" -type f -name '*.md' -o -name '*.yaml' >/dev/null
echo "engineering-memory package is valid"
