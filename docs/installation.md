# Installation

The installer controls skill visibility because portable Markdown instructions cannot reliably prevent every agent from overactivating visible skills.
New installations default to the `automatic` profile.

## Profiles

Install the three narrowly automatic capabilities:

```bash
./scripts/install.sh --profile automatic --agents keep
```

Install all seven capabilities only when an external router gates context or users deliberately request capabilities:

```bash
./scripts/install.sh --profile full --agents keep
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
An installation created before profile state existed migrates to the `automatic` profile unless the update command selects another profile explicitly.

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

Dry run reports selection, obsolete-skill reconciliation, backups, policy, and state operations without writing target files.

## Updating

Preserve the recorded profile:

```bash
./scripts/update.sh --agents keep
```

Change the exposed set deliberately:

```bash
./scripts/update.sh --profile automatic --agents keep
```

Before changing managed files, update verifies each installed skill against its recorded hash.
A modified managed skill stops the update before any managed target changes.
An unchanged obsolete skill is removed, or its pre-installation backup is restored.

## Backups

When installation replaces an untracked skill with the same name, it copies the original directory under `.engineering-os/backups/skills/` and records the mapping.
When global policy replacement overwrites an existing file, it stores a permission-restricted backup under `.engineering-os/backups/agents/`.

## Uninstalling

```bash
./scripts/uninstall.sh
```

The uninstaller removes unchanged managed skills and restores pre-installation skill backups.
It preserves modified skills.
It keeps a modified global policy by default.

## Recovery

If installation stops during preflight, no managed targets have changed.
If directory replacement fails, the installer attempts to restore the previous target before reporting failure.
Backups remain whenever user-owned content may still need recovery.
