# Customization

Keep universal policy focused on behavior that must remain true across nearly every engineering task.
Place repository-specific constraints in that repository's agent instructions, code, tests, automation, or documentation.

## Customize activation before workflow

Adjust the skill description when agent discovery or activation is incorrect.
Update `routing.yaml` only to keep maintainer inventory and evaluation metadata synchronized.
Do not rely on body instructions to solve a routing problem because the cost has already been incurred after activation.

Add explicit negative triggers when adjacent skills compete.
Keep names, descriptions, docs, manifest entries, maintainer routing metadata, installer profiles, and contract fixtures synchronized.

## Customize methods with references

Put language, framework, platform, organization, or domain-specific methods in a directly linked reference file.
Load the reference only when that variant applies.
Do not copy the same method into several skill bodies.

## Customize global policy carefully

Add a global rule only when it must remain true across nearly every engineering task and cannot live in a stronger artifact.
A concise universal writing standard belongs in the global policy because it applies to every prose surface without creating a separate responsibility.
Do not add an artifact-specific workflow, architecture preference, or project convention to the global policy.

## Preserve responsibility boundaries

Do not make `execution-planning` compare solutions.
Do not make `adversarial-review` implement corrections.
Do not make `architecture-assessment` review patches, select redesigns, issue launch verdicts, create plans, or implement corrections.
Do not make `security-testing` infer authority, command incidents, replace threat modeling, issue launch verdicts, or implement remediation.
Do not make `knowledge-promotion` automatically write memory.
Do not make `technical-writing` research missing engineering facts, approve correctness, choose durable placement, or change exact technical identifiers.
Do not make `frontend-design` own behavior-only changes, visual critique, product strategy, or backend implementation.
Do not make `threat-modeling` scan, exploit, command incidents, or implement remediation.
Do not make `operational-readiness` execute deployments, command incidents, or turn generic checklists into blockers.

When a new capability appears necessary, first determine whether it is a conditional method, a reference, a global invariant, or a genuinely separate responsibility.
Require a valuable non-overlapping responsibility, a precise activation boundary, expert method beyond generic prompting, a falsifiable output, and safe composition before adding another installed skill.
Prefer no skill when no distinct specialized responsibility is unresolved.
