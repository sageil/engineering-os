#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
test -f "$root/SKILL.md"
grep -q '^name: engineering-investigation$' "$root/SKILL.md"
grep -q '^description:' "$root/SKILL.md"
echo "engineering-investigation package is valid"
