# Engineering Memory

A portable Agent Skill for curating durable engineering knowledge across sessions.

## What it does

- Decides whether knowledge belongs in memory at all
- Prefers code, tests, docs, ADRs, and runbooks over duplicate memory
- Adds scope, rationale, provenance, and revalidation guidance
- Verifies volatile memories before consequential use
- Resolves contradictions and promotes enforceable knowledge
- Actively prunes stale, redundant, or unsafe entries

## Install for Codex

```bash
./scripts/install-codex.sh
```

Or copy this directory to:

```text
~/.agents/skills/engineering-memory
```

## Validate

```bash
./scripts/validate.sh
```

## Package layout

- `SKILL.md` — governing memory standard
- `references/` — focused guidance for storage, staleness, privacy, and maintenance
- `evals/` — trigger and behavior scenarios
- `scripts/` — installation and validation helpers
