#!/usr/bin/env python3
from __future__ import annotations

import re
import sys
from pathlib import Path

REQUIRED_REFERENCES = {
    "security.md",
    "data-and-migrations.md",
    "distributed-systems.md",
    "api-compatibility.md",
    "performance.md",
    "testing.md",
}


def fail(message: str) -> None:
    print(f"ERROR: {message}", file=sys.stderr)
    raise SystemExit(1)


def main() -> None:
    root = Path(sys.argv[1] if len(sys.argv) > 1 else ".").resolve()
    skill = root / "SKILL.md"
    if not skill.is_file():
        fail("SKILL.md is missing")

    text = skill.read_text(encoding="utf-8")
    match = re.match(r"\A---\n(.*?)\n---\n", text, flags=re.DOTALL)
    if not match:
        fail("SKILL.md must begin with YAML front matter")

    front_matter = match.group(1)
    if not re.search(r"(?m)^name:\s*engineering-quality\s*$", front_matter):
        fail("front matter name must be engineering-quality")
    if not re.search(r"(?m)^description:\s*>?\s*$", front_matter):
        fail("front matter must include a description")

    refs = root / "references"
    missing = sorted(name for name in REQUIRED_REFERENCES if not (refs / name).is_file())
    if missing:
        fail(f"missing references: {', '.join(missing)}")

    required = ["README.md", "VERSION", "LICENSE", "CHANGELOG.md", "evals/trigger-cases.csv", "evals/behaviour-cases.yaml"]
    missing_files = [name for name in required if not (root / name).is_file()]
    if missing_files:
        fail(f"missing package files: {', '.join(missing_files)}")

    installer = root / "scripts" / "install.sh"
    if not installer.is_file():
        fail("scripts/install.sh is missing")

    print(f"OK: {root}")
    print("Skill manifest, references, scripts, and eval fixtures are present.")


if __name__ == "__main__":
    main()
