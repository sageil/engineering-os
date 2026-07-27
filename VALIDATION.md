# Validation

Engineering OS 3.0.0 was validated as a complete installable package.

## Package checks

- 10 skill directories are present.
- Every skill contains valid frontmatter, a `SKILL.md`, `README.md`, `VERSION`, `CHANGELOG.md`, and `LICENSE`.
- Every skill contains an explicit capability handoff section.
- Every manifest skill resolves to a package with matching frontmatter.
- The manifest references the packaged global policy.
- Shell scripts pass `bash -n`.
- Installer scripts avoid GNU `find -printf`, `mapfile`, and `readarray`.

## Smoke tests

- A standard installation installs and removes all 10 skills.
- An existing skill is backed up and restored.
- An existing `AGENTS.md` is backed up and restored.
- A post-install edit to `AGENTS.md` is preserved by the safe default.
- Updating skills without replacing a managed `AGENTS.md` preserves its uninstall ownership.
