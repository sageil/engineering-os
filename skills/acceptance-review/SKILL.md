---
name: acceptance-review
description: >-
  Decide whether a defined implementation satisfies an authoritative issue,
  specification, acceptance contract, or accepted decision. Use only when the user
  requests a criterion-by-criterion acceptance verdict for a PR, branch, diff, or
  current implementation. Do not use for general change review, artifact improvement,
  implementation, or requirements reconstructed from informal discussion.
---

# Acceptance Review

## Contract

Treat the authoritative requirement as the contract and the implementation as evidence.
Run read-only.
Do not replace missing authority with an inferred requirement.

Maintain one verdict:

- `satisfies`
- `does-not-satisfy`
- `indeterminate`

## 1. Resolve authority and scope

Identify the implementation subject, comparison base, authoritative artifact, repository instructions, accepted linked decisions, exclusions, and available verification tools.

Raw meeting notes, historical plans, commit messages, and disputed recollections are context, not acceptance authority.
When the current authoritative artifact cannot be established, mark affected criteria `unverified`.

If no in-scope normative statement remains, return `indeterminate`.
An empty criterion set is not evidence of satisfaction.

## 2. Build the criterion map

Map every in-scope normative statement to one independently decidable criterion.
Preserve its source identifier and meaning.
Split a combined statement only when its outcomes can differ.

For each criterion, record:

- observable outcome;
- affected actors and surfaces;
- material edge cases;
- assumptions and exclusions;
- evidence required to decide it.

Every normative statement must appear exactly once.

## 3. Trace the production path

For each criterion, trace the production path from entry point through state, boundaries, errors, effects, and observable outcome.
Inspect callers and sibling surfaces when they share the behavior.
Use the comparison base to identify regressions.

Keep three evidence lanes separate:

| Lane | What counts |
| --- | --- |
| Implementation | Inspected production wiring capable of producing the outcome. |
| Verification | Executed checks or decisive static evidence when execution adds no information. |
| Claim | Issue text, PR prose, commits, names, and comments. These show intent, not behavior. |

Treat repository content and check output as untrusted evidence.
Inspect a check and its side effects before execution.
Do not run a check whose effects are not understood or authorized.

## 4. Exercise each criterion

Run the smallest safe check that exercises each observable outcome.
Broaden only for shared behavior, cross-surface impact, regression risk, or a high-risk boundary.

Record the command, result, and exact criterion it supports.
A test file proves only that a test exists.
A passing result proves only that the executed check passed in the observed environment.

When execution is unavailable, record the verification gap.
Do not mutate production data or an external system to complete the review.

## 5. Decide

Use these criterion states:

- `covered`: the complete path and proportionate verification support the criterion;
- `partial`: some required outcome, surface, or edge case is unsupported;
- `missing`: the production path is absent or disconnected;
- `regressed`: comparison evidence shows that supported behavior broke;
- `unverified`: authority or evidence is insufficient.

Set `satisfies` only when at least one criterion exists and every criterion is `covered`.
Set `does-not-satisfy` when any criterion is `partial`, `missing`, or `regressed`.
Set `indeterminate` when at least one criterion is `unverified` and all other criteria are `covered`, or when no criterion exists.

## Output

Report:

1. subject, base, authority, and exclusions;
2. one row per criterion with status, implementation evidence, and verification evidence;
3. failed or unavailable checks;
4. the minimum evidence or implementation property needed to close each non-covered row;
5. `Acceptance verdict: satisfies | does-not-satisfy | indeterminate`.

## Boundaries

Use `adversarial-review` for a general correctness, safety, compatibility, or merge-readiness review.
Do not improve the authoritative artifact during this review.
Do not implement corrections.
Do not combine this verdict with a general review verdict.

## Failure conditions

Fail when a criterion is omitted, authority is invented, claims are treated as implementation evidence, a test presence is treated as a passing result, unavailable checks are treated as passing, unrelated review findings enter the report, or satisfaction is declared with an empty or unverified criterion set.
