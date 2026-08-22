---
name: adversarial-review
description: >-
  Independently challenge a proposed or completed engineering change for correctness,
  safety, compatibility, maintainability, operability, and suitability. Use for pull
  requests, branches, commits, patches, diffs, migrations, configuration, infrastructure,
  or implementation plans when the user requests review, audit, approval, or merge-readiness.
  Report only findings introduced, exposed, or materially worsened by the reviewed change
  and supported by evidence. Do not use for criterion-by-criterion satisfaction of one
  authoritative acceptance contract, implementation, general repository audit, manufactured
  criticism, or artifacts that have not been inspected.
---

# Adversarial Review

## Contract

Attempt to disprove the change's material claims without assuming the change is wrong.
Treat false positives as review defects.
Anchor findings to the reviewed scope and report only concerns that survive refutation.

Maintain one verdict:
- `ready`
- `ready-with-nonblocking-findings`
- `not-ready`
- `insufficient-evidence`
- `contradictory-requirements`

## 1. Establish scope and baseline

Identify the exact review artifact, baseline, repository instructions, intended outcome, acceptance criteria, generated-file boundaries, exclusions, and verification tools.

For code/configuration, identify the exact diff.
For a plan, identify selected solution, evidence-backed current state, target state, invariants, transition assumptions, and execution constraints.

Do not claim review of content that was not inspected.
Preserve unrelated work.

Record whether the review has a fresh read-only context, whether the reviewer authored material parts of the change, and what prior conclusions were supplied.
Do not claim independent confirmation when the review context is not independent.

## 2. Understand intent and invariants

Determine changed behavior and what must remain true.
Use the request, accepted design, tests, interfaces, surrounding code, and relevant documentation.
Do not invent business requirements.

Check scope fidelity against the original objective and accepted constraints.
Identify unrequested additions, removed or weakened required behavior, altered exclusions, and skipped, deleted, or weakened tests.
Report them only when they materially change the accepted outcome or its evidence.

Identify the few invariants that control review risk.

## 3. Model the change in context

Trace changed entry points, callers, boundaries, state transitions, persistence, external calls, retries, timeouts, concurrency, error propagation, deployment, recovery, and cleanup as needed.

Identify newly reachable states, weakened assumptions, and behavior removed by the change.

When current system behavior or an external contract is materially unknown, stop and return:
`Routing request: research-before-solution`

Do not report a finding while its load-bearing premise remains researchable and unverified.

## 4. Construct failure hypotheses

Express serious concerns as falsifiable statements:
- triggering condition;
- changed mechanism;
- violated invariant;
- observable consequence;
- evidence needed to confirm or refute.

Prioritize material security, data, correctness, compatibility, concurrency, recovery, accessibility, and resource risks.
Do not enumerate irrelevant edge cases.

## 5. Test and refute concerns

Inspect safeguards, constraints, types, callers, configuration, framework guarantees, tests, runtime evidence, and official version-specific documentation as applicable.

Seek disconfirming evidence after a concern appears plausible.
Discard a candidate finding when reachability, trigger, invariant, consequence, or change relevance cannot be established.

Read [findings-and-severity.md](references/findings-and-severity.md).

## 6. Review tests as evidence

Identify which claim each test supports, whether it exercises the changed path, whether assertions observe the real outcome, and whether mocks bypass the material boundary.
Check whether the test would fail if the defect remained.
Treat skipped or unavailable tests as missing evidence.

## 7. Review transition and operation

For persistent data, public interfaces, infrastructure, configuration, distributed components, or long-running work, inspect mixed versions, partial rollout, interruption, retries, idempotency, rollback limits, recovery, observability, and cleanup.

Reject a safe-looking steady state with an unsafe transition.

## 8. Calibrate findings without redesigning

For every finding, require:
- exact location;
- concise defect statement;
- triggering scenario;
- violated invariant or requirement;
- observable impact;
- supporting evidence;
- severity and confidence;
- smallest responsible **correction property** when useful.

A correction property states what must become true, not which architecture to adopt.

Good:
> Preserve tenant identity through asynchronous processing.

Bad:
> Replace the queue with Kafka and add a new auth service.

If multiple materially different corrections could restore the invariant, do not select among them.
Return only the correction property and, when solution choice is consequential, request `research-before-solution`.

Do not let reviewer preference become an alternate design process.

## 9. Reach a verdict

Set `ready` only when material claims have sufficient evidence and no blocking finding survives.
Use `insufficient-evidence` when an unavailable load-bearing check prevents a responsible verdict.
Do not convert absence of findings into proof of correctness.

## Output

Findings first, ordered by severity.

Then:
- review scope and limitations;
- independence and scope-fidelity limitations;
- verification performed;
- rejected candidate findings when decision-useful;
- `Review verdict: ready | ready-with-nonblocking-findings | not-ready | insufficient-evidence | contradictory-requirements`

## Boundaries

Do not implement corrections unless requested.
Do not review the entire repository when scope is a diff.
Do not report pre-existing issues unless the change newly depends on, exposes, or worsens them.
Do not create findings to justify the review.
Do not replace operational-readiness assessment.
Do not choose a new architecture merely because a finding exists.
Use `acceptance-review` when the primary question is whether every criterion in one authoritative contract is satisfied.
Use `secure-oauth-oidc` when the primary request is a protocol-specific OAuth or OpenID Connect security assessment rather than review of one defined change.
Keep acceptance and general review verdicts separate when the user requests both.

## Failure conditions

Fail when a concern is reported before verification, style is presented as correctness, severity reflects effort instead of impact, unavailable tests are treated as passing, transition risk is ignored, the applicable artifact is not inspected, findings lack reachability or consequence, a correction direction becomes an unsolicited redesign, or a no-findings result is avoided to appear useful.
