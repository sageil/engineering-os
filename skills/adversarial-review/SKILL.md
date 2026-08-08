---
name: adversarial-review
description: Independently challenge a proposed or completed engineering change for correctness, safety, compatibility, maintainability, operability, and suitability. Use for pull requests, branches, commits, patches, diffs, migrations, configuration, infrastructure, or implementation plans when the user requests review, audit, approval, or merge-readiness assessment. Report only findings introduced, exposed, or materially worsened by the reviewed change and supported by evidence.
Do not use to implement requested work, perform a general repository audit, manufacture criticism, or review artifacts that have not been provided or inspected.
---
# Adversarial Review

## Contract

Attempt to disprove the change's material claims without assuming the change is wrong.
Treat false positives as review defects.
Anchor findings to the reviewed scope and report only concerns that survive refutation.
A review is incomplete if it considers only local correctness and ignores repository ownership, semantic duplication, or the quality of supporting tests.

Maintain one verdict:
- `ready`: No blocking finding survived and available evidence supports the claimed scope.
- `ready-with-nonblocking-findings`: Only supported nonblocking findings remain.
- `not-ready`: At least one supported blocking finding remains.
- `insufficient-evidence`: Change approval or merge readiness cannot be determined from available artifacts or verification.
- `contradictory-requirements`: Applicable requirements cannot be satisfied together without a decision.

## 1. Establish scope and baseline

Identify the exact review artifact, baseline, repository instructions, intended outcome, acceptance criteria, generated-file boundaries, excluded artifacts, and available verification tools.
For a code or configuration change, identify the exact diff.
For an implementation plan, identify the selected solution, evidence-backed current state, target state, invariants, transition assumptions, and execution constraints.
Do not claim review of content that was not inspected.
Preserve unrelated working-tree changes.

## 2. Understand intent and invariants

Determine what behavior changes and what must remain true.
Use the request, accepted design, tests, interfaces, surrounding code, and relevant documentation.
Do not invent business requirements.
Identify the few invariants that control review risk, including authorization, data integrity, compatibility, recovery, user access, bounded resources, canonical ownership, and source-of-truth boundaries when relevant.

## 3. Model the change in context

Trace changed entry points, callers, boundaries, state transitions, persistence, external calls, retries, timeouts, concurrency, error propagation, deployment, recovery, and cleanup as needed.
Inspect semantically similar implementations, extension points, and shared abstractions when they are relevant to ownership or duplication.
Identify newly reachable states, weakened assumptions, behavior removed by the change, and responsibilities that changed owners.
When current system behavior or an external contract is materially unknown, stop and return `Routing request: research-before-solution` for a new routing decision.
Do not report a finding while its load-bearing premise remains researchable and unverified.

## 4. Construct failure hypotheses

Express serious concerns as falsifiable statements containing:

- triggering condition;
- changed mechanism;
- violated invariant;
- observable consequence;
- evidence needed to confirm or refute it.

Prioritize security, data loss, unsafe transitions, major correctness, compatibility, concurrency, recovery, accessibility, credible resource exhaustion, duplicated sources of truth, and ownership ambiguity before lower-impact concerns.
Do not enumerate irrelevant edge cases.

## 5. Test and refute concerns

Inspect safeguards, constraints, types, callers, configuration, framework guarantees, tests, runtime evidence, official version-specific documentation, existing owners, and adjacent implementations as applicable.
Seek disconfirming evidence after a concern appears plausible.
Discard a candidate finding when reachability, trigger, invariant, consequence, change relevance, or duplicated responsibility cannot be established.
Do not report style preferences, speculative risk, generic best practice, or pre-existing issues that the change does not materially worsen.
Read [findings-and-severity.md](references/findings-and-severity.md) before finalizing findings.

## 6. Review tests as evidence

Identify which claim each test supports, whether it exercises the changed path, whether assertions observe the real outcome, and whether mocks bypass the material boundary.
Check whether the test would fail if the defect remained.
Treat skipped or unavailable tests as missing evidence.
For defect corrections, look for fail-before, pass-after, essential-change sensitivity, and adjacent-behavior preservation when practical.

Also inspect whether tests:

- duplicate existing fixtures, factories, builders, setup, or assertion helpers;
- mirror the production algorithm instead of independently validating behavior;
- exist primarily to increase coverage or execute branches;
- assert trivial language, framework, getter, setter, or wiring behavior;
- test mock configuration rather than production behavior;
- duplicate an already-supported behavioral claim without adding meaningful evidence.

Prefer fewer high-signal tests over many low-value tests.
Do not require abstraction of trivial repeated test code when doing so would reduce clarity.
The concern is duplicated ownership and maintenance burden, not eliminating every repeated line.

## 7. Review transition and operation

For persistent data, public interfaces, infrastructure, configuration, distributed components, or long-running work, inspect mixed versions, partial rollout, interruption, retries, idempotency, rollback limits, recovery, observability, and cleanup.
Reject a safe-looking steady state with an unsafe transition.
Assess new operational obligations only when they create a concrete near-term correctness, recovery, or ownership problem.

## 8. Review repository-native ownership and duplication

For code or configuration changes, determine what owned the relevant responsibility before the change and what owns it afterward.
Explicitly search for semantic duplication introduced or materially worsened by the diff.
Inspect for duplicated business rules, validation, transformations, mappings, serialization, error-handling policy, state transitions, helpers, utilities, services, adapters, configuration mechanisms, fixtures, factories, builders, setup, and assertion helpers.
Treat two implementations that must remain behaviorally synchronized as a maintainability finding unless the architecture explicitly requires the duplication.
Do not flag superficial textual similarity.
Before reporting duplication, establish that the implementations own the same concept, invariant, policy, or responsibility.
Distinguish intentional duplication such as generated code, vendored code, compatibility layers, migration states, platform-specific implementations, or deliberately isolated boundaries.

For each meaningful new abstraction or reusable mechanism, ask:

1. What responsibility does it own?
2. What owned that responsibility before this change?
3. Does an existing abstraction already own all or part of it?
4. Could the existing owner have been reused or extended?
5. Does the new mechanism create another source of truth?
6. Will multiple implementations now need to remain behaviorally synchronized?

A new abstraction is not automatically better because code was moved behind another name or file.

## 9. Review artifact-specific detail

For a code or configuration change, inspect the actual diff for unintended behavior, unrelated refactoring, widened interfaces, weakened validation, hidden defaults, compatibility regression, dead code, resource leaks, sensitive logging, accidental dependencies, generated churn, unnecessary new files, unnecessary wrappers, semantic duplication, duplicated test infrastructure, and divergence from the accepted solution or established repository conventions.
For an implementation plan, inspect missing or unsafe intermediate states, ambiguous ownership, incompatible sequencing, unverifiable checkpoints, interruption and retry gaps, impossible rollback, missing recovery, unfinished cleanup, and plans that introduce a parallel owner where an established owner exists.
Do not redesign the subsystem when a smaller correction restores the invariant.

## 10. Calibrate findings

For every finding, require:

- exact location;
- concise defect statement;
- triggering scenario;
- violated invariant or requirement;
- observable impact;
- supporting evidence;
- severity and confidence;
- smallest responsible correction direction when useful.

Do not provide a full implementation unless the user separately requests changes.
Do not soften a blocking finding because the correction is expensive.
Do not block on a valid but low-impact issue when delivery delay costs more than the expected harm.
Semantic duplication may be blocking when it creates competing sources of truth for material behavior; minor local repetition should not be exaggerated.

## 11. Reach a verdict

Set `ready` only when material claims have sufficient evidence and no blocking finding survives.
Use `insufficient-evidence` when an unavailable load-bearing check prevents a responsible verdict.
Do not convert absence of findings into proof of correctness.
Do not treat green tests or high coverage as proof of repository quality.

## Output

List findings first, ordered by severity.
For each finding, provide the location, evidence, impact, conditions, and correction direction.
Then provide:

- Review scope and limitations
- Verification performed
- Duplication and ownership assessment when relevant
- Test-evidence assessment when relevant
- Rejected candidate findings when their rejection is decision-useful
- `Review verdict: ready | ready-with-nonblocking-findings | not-ready | insufficient-evidence | contradictory-requirements`

Use a concise no-findings response when no actionable finding survives.

## Boundaries

Do not implement corrections unless requested.
Do not review the entire repository when the scope is a diff, except for targeted repository searches needed to establish ownership, duplication, or affected callers.
Do not report pre-existing issues unless the change newly depends on, exposes, or worsens them.
Do not create findings to justify the review.
Do not replace a system-level operational-readiness or go-no-go assessment.

## Failure conditions

Fail the skill when a concern is reported before verification, style is presented as correctness, severity reflects effort instead of impact, unavailable tests are treated as passing, the review ignores transition risk, the applicable diff or plan artifact is not inspected, findings lack reachability or consequence, repository ownership is ignored when relevant, semantic duplication is ignored or inferred only from textual similarity, low-value tests are praised merely because they increase coverage, or a no-findings result is avoided to appear useful.
