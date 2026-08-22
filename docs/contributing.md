# Contributing

Change Engineering OS to address an observed problem or a clearly established capability gap.

## Required change record

Provide:

- the responsibility being added, removed, or corrected;
- evidence for an observed problem, or first-principles reasoning for a new non-overlapping responsibility;
- the owning skill, reference, routing rule, or global invariant;
- positive activation and explicit exclusions;
- inputs, authority, method, verdicts, gate, output, and failure conditions;
- adjacent-skill boundaries and handoff effects;
- no-skill routing impact;
- affected contract fixtures;
- context and operating cost considerations;
- known limitations and unresolved evidence.

Do not add prose because it sounds wise.
Do not expand several skills to address one responsibility.
Do not require an artificial model comparison when responsibility and design quality can be established directly.

## Skill design

Keep one responsibility per installed skill.
Put all activation conditions in the frontmatter description.
Use imperative instructions in the body.
Define inputs, verdicts, gates, output, boundaries, and failure conditions.
Keep `SKILL.md` below 500 lines and move conditional detail into directly linked references.

Do not add per-skill README, changelog, version, or license files.
Do not add provider-specific metadata to the portable skill core.
Update `routing.yaml` when the packaged skill inventory or cross-skill evaluation metadata changes.
Update installer profile expectations separately when installation behavior changes.

## Contract maintenance

Add or update fixtures that exercise the changed contract.
Prefer deterministic assertions for routing, authority, verdict, and artifact requirements.
Use realistic input artifacts and do not encode the expected diagnosis in the prompt.
Fixtures guard claimed behavior, but passing them does not prove broad model quality.

## Review

Review trigger overlap, responsibility drift, context cost, stale guidance, concrete-template anchoring, safety, authority, and cross-skill handoff effects.
Treat false activation, unsupported conclusions, hidden authority expansion, and misleading completion as product defects.
Reject a skill that merely restates universal behavior or duplicates an existing responsibility.

## Validation

Run:

```bash
./scripts/validate.sh
./scripts/test.sh
```

Report structural validation, contract coverage, and any field evidence as separate claims.
