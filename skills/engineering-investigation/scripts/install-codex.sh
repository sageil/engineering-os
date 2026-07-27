#!/usr/bin/env bash
set -euo pipefail
src="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dst="${AGENTS_SKILLS_DIR:-$HOME/.agents/skills}/engineering-investigation"
mkdir -p "$(dirname "$dst")"
rm -rf "$dst"
cp -R "$src" "$dst"
echo "Installed engineering-investigation to $dst"
