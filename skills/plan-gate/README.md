# plan-gate

An evidence-backed planning skill for coding agents and agent harnesses.

It prevents premature edits by requiring the agent to inspect reality, identify
invariants and unknowns, define executable success criteria, constrain scope,
and stop to re-plan when evidence invalidates the current approach.

## Install for Codex

```bash
./scripts/install-codex.sh
```

Or copy the directory manually:

```bash
mkdir -p ~/.agents/skills
cp -R plan-gate ~/.agents/skills/plan-gate
```

## Invoke explicitly

```text
$plan-gate plan this migration before making changes
```

The skill can also be selected implicitly from its description.

## Package contents

- `SKILL.md` — governing planning standard
- `references/` — focused planning playbooks
- `evals/` — trigger, planning-quality, and re-planning scenarios
- `scripts/validate-package.sh` — structural validation
- `scripts/install-codex.sh` — user-level Codex installation

## Design goals

- evidence before sequencing
- outcomes and invariants before edits
- proportional planning depth
- explicit unknown verification
- executable success criteria
- minimal justified scope
- reversibility and stop conditions
- active re-planning when reality changes
