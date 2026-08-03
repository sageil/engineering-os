---
name: adversarial-review
description: Independently challenge a proposed or completed engineering change for correctness, safety, compatibility, maintainability, operability, and suitability. Use for pull requests, branches, commits, patches, diffs, migrations, configuration, infrastructure, or implementation plans when the user requests review, audit, approval, or merge-readiness assessment. Report only findings introduced, exposed, or materially worsened by the reviewed change and supported by evidence. Do not use to implement requested work, perform a general repository audit, manufacture criticism, or review artifacts that have not been provided or inspected.
---

# Adversarial Review

## Contract

Attempt to disprove the change's material claims without assuming the change is wrong.
Treat false positives as review defects.
Anchor findings to the reviewed scope and report only concerns that survive refutation.

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

Identify the few invariants that control review risk, including authorization, data integrity, compatibility, recovery, user access, and bounded resources when relevant.

## 3. Model the change in context

Trace changed entry points, callers, boundaries, state transitions, persistence, external calls, retries, timeouts, concurrency, error propagation, deployment, recovery, and cleanup as needed.
Identify newly reachable states, weakened assumptions, and behavior removed by the change.

When current system behavior or an external contract is materially unknown, stop and return `Routing request: research-before-solution` for a new routing decision.
Do not report a finding while its load-bearing premise remains researchable and unverified.

## 4. Construct failure hypotheses

Express serious concerns as falsifiable statements containing:

- triggering condition;
- changed mechanism;
- violated invariant;
- observable consequence;
- evidence needed to confirm or refute it.

Prioritize security, data loss, unsafe transitions, major correctness, compatibility, concurrency, recovery, accessibility, and credible resource exhaustion before lower-impact concerns.
Do not enumerate irrelevant edge cases.

## 5. Test and refute concerns

Inspect safeguards, constraints, types, callers, configuration, framework guarantees, tests, runtime evidence, and official version-specific documentation as applicable.
Seek disconfirming evidence after a concern appears plausible.

Discard a candidate finding when reachability, trigger, invariant, consequence, or change relevance cannot be established.
Do not report style preferences, speculative risk, generic best practice, or pre-existing issues that the change does not materially worsen.

Read [findings-and-severity.md](references/findings-and-severity.md) before finalizing findings.

## 6. Review tests as evidence

Identify which claim each test supports, whether it exercises the changed path, whether assertions observe the real outcome, and whether mocks bypass the material boundary.
Check whether the test would fail if the defect remained.
Treat skipped or unavailable tests as missing evidence.

For defect corrections, look for fail-before, pass-after, essential-change sensitivity, and adjacent-behavior preservation when practical.

## 7. Review transition and operation

For persistent data, public interfaces, infrastructure, configuration, distributed components, or long-running work, inspect mixed versions, partial rollout, interruption, retries, idempotency, rollback limits, recovery, observability, and cleanup.
Reject a safe-looking steady state with an unsafe transition.

Assess new operational obligations only when they create a concrete near-term correctness, recovery, or ownership problem.

## 8. Review artifact-specific detail

For a code or configuration change, inspect the actual diff for unintended behavior, unrelated refactoring, widened interfaces, weakened validation, hidden defaults, compatibility regression, dead code, resource leaks, sensitive logging, accidental dependencies, generated churn, and divergence from the accepted solution.
For an implementation plan, inspect missing or unsafe intermediate states, ambiguous ownership, incompatible sequencing, unverifiable checkpoints, interruption and retry gaps, impossible rollback, missing recovery, and unfinished cleanup.
Do not redesign the subsystem when a smaller correction restores the invariant.

## 9. Calibrate findings

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

## 10. Reach a verdict

Set `ready` only when material claims have sufficient evidence and no blocking finding survives.
Use `insufficient-evidence` when an unavailable load-bearing check prevents a responsible verdict.
Do not convert absence of findings into proof of correctness.

## Output

List findings first, ordered by severity.
For each finding, provide the location, evidence, impact, conditions, and correction direction.

Then provide:

- Review scope and limitations
- Verification performed
- Rejected candidate findings when their rejection is decision-useful
- `Review verdict: ready | ready-with-nonblocking-findings | not-ready | insufficient-evidence | contradictory-requirements`

Use a concise no-findings response when no actionable finding survives.

## Boundaries

Do not implement corrections unless requested.
Do not review the entire repository when the scope is a diff.
Do not report pre-existing issues unless the change newly depends on, exposes, or worsens them.
Do not create findings to justify the review.
Do not replace a system-level operational-readiness or go-no-go assessment.

## Failure conditions

Fail the skill when a concern is reported before verification, style is presented as correctness, severity reflects effort instead of impact, unavailable tests are treated as passing, the review ignores transition risk, the applicable diff or plan artifact is not inspected, findings lack reachability or consequence, or a no-findings result is avoided to appear useful.
