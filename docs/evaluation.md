# Evaluation

Engineering OS separates package correctness, contract integrity, and evidence from real use.
None of these is a mechanical proxy for whether a skill is world-class.

## Package validation

`scripts/validate.sh` checks manifest consistency, portable skill structure, routing invariants, absence of provider-specific metadata, frontmatter names, reference links, unresolved placeholders, file limits, contract-case presence, and shell syntax.
`scripts/test.sh` exercises automatic, full, custom, and none installation profiles together with exact manifest selection, removed-managed-skill reconciliation, backup restoration, unrelated-skill preservation, modified-file protection, global policy handling, dry run, and uninstall behavior inside temporary directories.

These checks establish that the package is internally coherent and installable.
They do not establish model quality or production suitability.

## Contract fixtures

Files under `evals/` specify behavior that the suite claims to own.
They are executable specifications for routing, restraint, authority, verdicts, handoffs, and end-to-end invariants.
They are not proof that a model needs the skill, and they do not impose a comparative release gate.

Each skill must have cases covering the material parts of its contract:

- positive activation with decision-relevant inputs;
- negative activation and adjacent-skill boundaries;
- insufficient-evidence or blocked behavior;
- authority and mutation boundaries;
- the skill's terminal verdicts and output contract;
- handoff preservation when another responsibility becomes unresolved;
- restraint on ordinary work that should use no skill.

Use realistic raw artifacts rather than prompts that disclose the expected conclusion.
Assert material behavior and verdicts rather than exact prose.
When a skill contract changes, update the affected fixtures in the same change.

## Field evidence

Collect real operating evidence when available, especially for expensive, safety-critical, or frequently invoked capabilities.
Useful evidence includes task outcomes, prevented failure modes, unsupported claims, missed risks, unnecessary activation, user decisions, reversals, incident impact, token use, tool use, and elapsed time.

Preserve the task, environment identity, model and agent configuration, relevant artifacts, tool trace, output, and outcome when the evidence may affect a durable decision.
Separate observed facts from reviewer judgment and identify important confounders.
Comparative runs may answer a specific disputed question, but they are optional experiments rather than a prerequisite for contribution or release.

## Evidence use

Use evidence to locate defects and improve the owning contract.
Do not average incompatible models, scaffolds, tasks, or risk levels into a single quality score.
Do not treat one successful trajectory as proof of general behavior.
Do not treat an artificial fixture as more authoritative than verified failure or success in representative use.

Revise, narrow, demote, or delete a skill when evidence shows responsibility overlap, harmful activation, unsafe authority, misleading verdicts, systematic context waste, or a method that does not survive representative use.
Retain a skill when it owns a valuable non-overlapping responsibility and its method, boundaries, outputs, and operating evidence remain defensible.

## Current status

Version 4.4.0 is structurally validated and includes contract fixtures for its provider-neutral routing model.
Claims about effectiveness must identify the supporting artifact or observation and its limits.
