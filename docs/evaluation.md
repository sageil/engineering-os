# Evaluation

Engineering OS separates package correctness from behavioral utility.

## Package validation

`scripts/validate.sh` checks manifest consistency, portable skill structure, routing invariants, absence of provider-specific metadata, frontmatter names, reference links, unresolved placeholders, file limits, evaluation presence, and shell syntax.
`scripts/test.sh` exercises automatic, full, custom, and none installation profiles together with update, obsolete-skill reconciliation, backup restoration, modified-file protection, global policy handling, dry run, and uninstall behavior inside temporary directories.

These checks do not establish that a skill improves model behavior.

## Behavioral evaluation

Evaluate every skill with paired runs:

1. Pin the same repository, task, environment, model, reasoning setting, tool permissions, and context.
2. Run without the candidate skill and record outputs, actions, verification, tokens, time, and task result.
3. Run with only the candidate skill added.
4. Repeat enough times to expose nondeterminism.
5. Use deterministic acceptance checks whenever behavior permits them.
6. Use blinded human judgment only for outcomes that cannot be reduced to deterministic checks.
7. Report uncertainty and preserve raw artifacts.

Do not mention the skill in the task prompt unless explicit invocation is the behavior under evaluation.
Do not leak the expected solution, suspected defect, or evaluator diagnosis into the candidate condition.

## Evaluation layers

### Trigger selection

Measure true activation, missed activation, false activation, and competition with adjacent skills.
Include trivial tasks that should activate no skill.
Include common verb traps such as build, test, verify, container, deploy, package, review logs, and run checks.
Score any skill activation as incorrect when the expected route is `none`.
Verify that one task action does not cause nested or sequential skill stacking without a new routing decision.

### Owned behavior

Measure the skill's unique responsibility and verdict gate.
Examples include premature solution rate for `research-before-solution`, unsupported root-cause rate for `causal-debugging`, and false-positive findings for `adversarial-review`.

### Cross-skill handoff

Measure whether a later skill preserves the earlier verdict, evidence, invariants, authority, uncertainty, and stop conditions.
Test invalid handoffs and returns to earlier skills.

### End-to-end outcome

Measure acceptance-criterion satisfaction, unsafe actions, regressions, completion honesty, recovery, and cleanup across realistic repository tasks.

### Efficiency

Measure input and output tokens, tool calls, elapsed time, unnecessary file reads, unnecessary plans, and irrelevant output.
An unchanged pass rate with large additional cost is not automatically a neutral result.

## Required metrics

Use the subset material to each case:

- deterministic task success;
- critical requirement satisfaction;
- unsupported claim rate;
- premature solution rate;
- false-positive and false-negative rate;
- unsafe or unauthorized action rate;
- routing precision and recall;
- unnecessary activation rate;
- no-skill selection accuracy;
- handoff integrity;
- token and tool-call overhead;
- elapsed time;
- calibrated uncertainty;
- user decision usefulness.

Predeclare the primary metric, safety constraints, and acceptable overhead before running a comparison.

## Release gate

A skill remains installable only when paired evaluation shows one of:

- a meaningful improvement in its predeclared outcome without material safety or task-success regression;
- a meaningful reduction in cost or time while preserving outcome quality;
- prevention of a high-consequence failure that the baseline exhibits.

Reject or revise a candidate when it adds context without changing behavior, creates false triggers, reduces task success, anchors the model on stale specifics, increases unsafe action, or erases uncertainty.
Demote a useful conditional method to a reference when it does not justify independent activation.
Move a universal invariant to the global policy when skill retrieval is the wrong enforcement mechanism.
Delete guidance the base model already performs reliably.

## Model and scaffold coverage

Test at least one strong and one economical model before calling behavior general.
Repeat critical cases across supported agent scaffolds because skill discovery, tool use, context budgeting, and instruction precedence differ.
Publish results by model and scaffold rather than averaging incompatible conditions.

Treat any unnecessary skill activation in the dedicated no-skill gate as a release blocker until the activation boundary or exposure mechanism is corrected.

## Current status

Version 4.1.0 is a structurally validated provider-neutral, context-gated redesign and behavioral evaluation candidate.
It must not be described as world-class until paired results satisfy the release gate and remain reproducible.
