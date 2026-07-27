#!/usr/bin/env bash
set -euo pipefail
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST_ROOT="${HOME}/.agents/skills"
DEST="${DEST_ROOT}/adversarial-code-review"
mkdir -p "$DEST_ROOT"
rm -rf "$DEST"
cp -R "$SOURCE_DIR" "$DEST"
echo "Installed adversarial-code-review to $DEST"
