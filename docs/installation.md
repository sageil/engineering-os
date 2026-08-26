# Installation

The installer copies skill packages to an agent discovery directory.
New installations default to the `full` profile so every packaged skill is discoverable.

## Profiles

Install all sixteen capabilities:

```bash
./scripts/install.sh --agents keep
```

Install only the three narrowly automatic capabilities when reduced discoverability is explicitly required:

```bash
./scripts/install.sh --profile automatic --agents keep
```

Install no skills and optionally install the global policy:

```bash
./scripts/install.sh --profile none --agents replace
```

Install an exact subset:

```bash
./scripts/install.sh \
  --skills research-before-solution,adversarial-review \
  --agents keep
```

`--profile` and `--skills` are mutually exclusive.
The selected profile is recorded in installation state.
An update without a new selection preserves the recorded profile.
The current `manifest.yaml` inventory is authoritative.
The installer rejects unknown skill names, validates every packaged skill, and never removes unrelated skill directories.

## Global policy

The global policy is optional.
Keep an existing `AGENTS.md` unchanged:

```bash
./scripts/install.sh --agents keep
```

Back up and replace or create the configured `AGENTS.md`:

```bash
./scripts/install.sh --agents replace
```

`--agents replace` always replaces the target file, including when it changed after an earlier installation.

Interactive and non-interactive installation both default to keeping the existing policy.

## Custom targets

Use custom targets for the agent host's discovery and policy locations:

```bash
./scripts/install.sh \
  --profile automatic \
  --skills-target /path/to/discovered/skills \
  --agents-target /path/to/AGENTS.md \
  --agents keep
```

Installation state is stored beside the configured policy target under `.engineering-os/`.
Use the same `--agents-target` for update and uninstall so the correct state is loaded.

## Dry run

```bash
./scripts/install.sh --profile full --agents replace --dry-run
```

Dry run reports the selected installation operations without writing target files.

## Updating

Preserve the recorded profile:

```bash
./scripts/install.sh --agents keep
```

Change the exposed set deliberately:

```bash
./scripts/install.sh --profile automatic --agents keep
```

Before changing managed files, update verifies each installed skill against its recorded hash.
A modified managed skill stops the update before any managed target changes.
Managed skills no longer selected or present in the current manifest are removed or replaced by their pre-installation backup.
Incomplete installation state is rejected before any target changes.

To replace changed managed skills explicitly:

```bash
./scripts/install.sh --replace-modified --agents keep
```

`--replace-modified` backs up every changed managed skill under `.engineering-os/backups/modified-skills/` before replacement or removal.
The backup directory is outside the default skill discovery directory.
Selected skills are then replaced with the packaged versions, and the managed hashes are refreshed.
Replacement backups remain after later updates and uninstallation until the user removes them.
Without this option, changed managed skills continue to block the update.

## Backups

When installation replaces an untracked skill with the same name, it copies the original directory under `.engineering-os/backups/skills/` and records the mapping.
When `--replace-modified` replaces a changed managed skill, it preserves the changed directory under `.engineering-os/backups/modified-skills/`.
When global policy replacement overwrites an existing file, it stores a permission-restricted backup under `.engineering-os/backups/agents/`.

## Uninstalling

```bash
./scripts/uninstall.sh
```

The uninstaller removes unchanged managed skills and restores pre-installation skill backups.
It preserves modified skills.
It keeps a modified global policy by default.
It validates all skill hashes, backup paths, target types, and global-policy restoration state before removing anything.

## Recovery

If installation stops during preflight, no managed targets have changed.
If directory replacement fails, the installer attempts to restore the previous target before reporting failure.
Replacement backups are complete before any changed managed target is replaced or removed.
Managed hashes are refreshed only after every selected skill is installed.
Backups remain whenever user-owned content may still need recovery.
