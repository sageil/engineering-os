# Contributing

Change Engineering OS only to address an observed behavioral problem.

## Required change record

Provide:

- failing or deficient model behavior;
- raw task and output artifact;
- owning skill or global invariant;
- smallest proposed text or reference change;
- positive case;
- negative or restraint case;
- adjacent-skill conflict case when applicable;
- paired evaluation result;
- no-skill routing impact;
- token and tool-call impact;
- limitations and model coverage.

Do not add prose because it sounds wise.
Do not expand several skills to address one failure.

## Skill design

Keep one responsibility per installed skill.
Put all activation conditions in the frontmatter description.
Use imperative instructions in the body.
Define inputs, verdicts, gates, output, boundaries, and failure conditions.
Keep `SKILL.md` below 500 lines and move conditional detail into directly linked references.

Do not add per-skill README, changelog, version, or license files.
Do not add provider-specific metadata to the portable skill core.
Update `routing.yaml` and installer profile expectations when activation policy changes.

## Evaluation first

Add or update a case that fails before editing skill text.
Run the paired baseline and candidate conditions.
Prefer deterministic acceptance checks.
Preserve raw outputs and environment identity.

If the candidate does not improve the targeted behavior, revert the prose change and reconsider the intervention.

## Review

Review trigger overlap, responsibility drift, context cost, stale version guidance, concrete-template anchoring, safety, authority, and cross-skill handoff effects.
Treat a false positive or unnecessary activation as a product defect.
Reject a skill that merely restates reliable baseline engineering behavior.

## Validation

Run:

```bash
./scripts/validate.sh
./scripts/test.sh
```

Report structural checks separately from behavioral evaluation.
