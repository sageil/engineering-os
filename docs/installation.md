# Installation

Run `./scripts/install.sh --profile balanced` for the default installation.

Environment variables:

- `AGENTS_SKILLS_DIR`: skill destination, default `~/.agents/skills`
- `CODEX_HOME`: Codex configuration directory, default `~/.codex`

Use `--symlink` for local development. Stable releases should normally be
copied so later source edits do not silently alter installed behavior.
