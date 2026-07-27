# Installation

Run the interactive installer from the repository root:

```bash
./scripts/install.sh --profile balanced
```

Engineering OS installs discoverable skills into `~/.agents/skills` by default.
The global policy at `~/.agents/AGENTS.md` is optional and is never replaced
without explicit consent.

## Profiles

- `lightweight`: the five core delivery skills.
- `balanced`: the complete recommended engineering lifecycle.
- `strict`: balanced plus philosophy and technical-leadership capabilities.

## Non-interactive examples

```bash
./scripts/install.sh --profile balanced --agents keep
./scripts/install.sh --profile strict --agents replace
./scripts/install.sh --profile balanced --agents replace --dry-run
```

Custom paths are supported with `--skills-target` and `--agents-target`.

## Uninstall

```bash
./scripts/uninstall.sh
```

Pre-existing skills replaced by Engineering OS are backed up and restored when
safe. A replaced `AGENTS.md` is restored from its original backup. Modified
post-installation files are preserved rather than silently overwritten.
