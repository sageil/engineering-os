# Validation

Engineering OS 3.0.0 was validated as a complete installable package.

## Package checks

- 10 skill directories are present.
- Every skill contains valid frontmatter, a `SKILL.md`, `README.md`, `VERSION`, `CHANGELOG.md`, and `LICENSE`.
- Every skill contains an explicit capability handoff section.
- All profile entries resolve to packaged skills.
- Shell scripts pass `bash -n`.
- Installer scripts avoid GNU `find -printf`, `mapfile`, and `readarray`.

## Smoke tests

- Lightweight installs and removes 5 skills.
- Balanced installs and removes 10 skills.
- Strict installs and removes 10 skills.
- An existing skill is backed up and restored.
- An existing `AGENTS.md` is backed up and restored.
- A post-install edit to `AGENTS.md` is preserved by the safe default.
