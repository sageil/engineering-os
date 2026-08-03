# Engineering OS Observation Kit

This directory provides dimensions and scenarios for collecting operating evidence.
It is not a release gate and does not require comparative runs.

## Observation unit

For any recorded task, preserve the decision-relevant context:

- repository commit or immutable artifact;
- requirements and acceptance criteria;
- environment and dependencies;
- model and reasoning configuration;
- agent scaffold and tool permissions;
- available policy and skill context;
- deterministic verifier when applicable;
- raw output, tool trace, outcome, cost, and limitations.

One real trajectory can establish that a particular event occurred.
It cannot establish general superiority, causation, or model-independent behavior.

## Optional contexts

Choose only contexts that answer the question being investigated:

- no Engineering OS context;
- global policy only;
- one selected skill;
- automatic profile;
- dynamically context-gated suite;
- full discovery as an overactivation stress condition;
- an earlier release or alternate routing policy.

Holding other inputs constant can help isolate a disputed mechanism, but such comparison is optional.
Do not manufacture repeated trials when repository evidence, a verified field failure, or a direct contract defect already answers the engineering question.

## Scoring and interpretation

Prefer deterministic acceptance checks for code and operational tasks.
Use calibrated human judgment for evidence quality, decision usefulness, communication, and other outcomes that cannot be reduced responsibly.
Report safety constraints separately from average quality.

Report each model, scaffold, environment, and task class explicitly when those differences affect interpretation.
Do not hide failures inside an aggregate score.
Do not turn an arbitrary numeric threshold into authority to keep or delete a skill.

## Design decisions

Use observations together with responsibility boundaries, expert-method review, safety analysis, contract fixtures, and context cost.
Revise a skill when evidence exposes a concrete defect.
Retain or add a skill when it owns a valuable non-overlapping responsibility and its design and evidence support the claims being made.
