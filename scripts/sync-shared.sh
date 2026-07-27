#!/usr/bin/env bash
set -euo pipefail
# Shared files are maintainer references. Each SKILL.md remains independently
# complete so runtime skill loading never depends on relative cross-package files.
echo "No generated skill fragments. Review shared definitions manually for drift."
