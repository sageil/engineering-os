# Adversarial Code Review

A high-signal Agent Skill for reviewing pull requests, branches, commits, patches, and diffs.

## What it optimizes for

- Truth discovery rather than comment volume
- Invariant-based reasoning
- Reachable failure paths
- Low false-positive rates
- Evidence-calibrated severity
- Minimal, proportionate recommendations
- Honest no-finding and insufficient-evidence outcomes

## Install for Codex

```bash
./scripts/install-codex.sh
```

Or copy/symlink this directory into:

```text
~/.agents/skills/adversarial-code-review
```

## Invoke

```text
$adversarial-code-review review this branch against main
```

The skill can also trigger implicitly when the harness supports Agent Skills discovery.

## Package layout

- `SKILL.md` — governing review standard
- `references/` — optional specialized review guides
- `evals/` — trigger, false-positive, severity, no-finding, and recommendation cases
- `scripts/` — installation and validation helpers
