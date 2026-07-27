# Engineering Communication

A model-agnostic Agent Skill for writing and editing technical documentation in clear, human language.

It applies to READMEs, PR descriptions, ADRs, RFCs, migration guides, runbooks, API documentation, release notes, reports, and other substantial prose.

## Install for Codex

```bash
./scripts/install-codex.sh
```

This installs the skill to:

```text
~/.agents/skills/engineering-communication
```

## Package contents

- `SKILL.md` — governing communication standard
- `references/` — document-specific guidance
- `evals/` — trigger and behavior fixtures
- `scripts/` — installation and package validation

## Validate

```bash
./scripts/validate-package.sh
```
