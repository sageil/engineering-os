# Engineering Quality Agent Skill

A model-agnostic Agent Skill for deliberate engineering decisions, minimal implementation, calibrated evidence, and adversarial verification.

## Contents

- `SKILL.md` — mandatory engineering constitution and lifecycle.
- `references/` — focused review guides loaded only when relevant.
- `evals/` — trigger and behaviour fixtures for regression testing.
- `scripts/install.sh` — user-level Codex installation helper.
- `scripts/validate-package.py` — structural validation.

## Install for Codex

```bash
unzip engineering-quality.zip
cd engineering-quality
./scripts/install.sh
```

The default destination is `~/.codex/skills/engineering-quality`. Override it with:

```bash
AGENT_SKILLS_HOME=/custom/skills ./scripts/install.sh
```

## Manual install

Copy the `engineering-quality` directory into your harness's user- or system-level skills directory. The harness must support the open Agent Skills convention and discover a directory containing `SKILL.md`.

## Explicit use

```text
Use the $engineering-quality skill to review and implement this change.
```

The description is intentionally broad enough for implicit activation during consequential engineering work. Whether implicit activation occurs depends on the harness.

## Validate

```bash
python3 scripts/validate-package.py .
```

## Evaluate

`evals/trigger-cases.csv` tests when the skill should or should not activate. `evals/behaviour-cases.yaml` contains scenario-level expectations for solution selection and adversarial verification.

Treat these fixtures as a starting suite. Add every real failure or false-positive invocation as a regression case.

## Versioning

This package uses semantic versioning. Changes that materially alter the engineering standard or expected output behaviour should increment the major version.
