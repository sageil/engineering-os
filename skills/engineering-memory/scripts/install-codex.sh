#!/usr/bin/env bash
set -euo pipefail
src="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dest="${HOME}/.agents/skills/engineering-memory"
mkdir -p "$(dirname "$dest")"
rm -rf "$dest"
cp -R "$src" "$dest"
echo "Installed engineering-memory to $dest"
