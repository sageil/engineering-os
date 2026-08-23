---
name: testing
description: >-
  Design or assess meaningful behavior tests when the user explicitly requests test design,
  a test-quality audit, behavior-versus-implementation analysis, mutation-aware test analysis,
  or test consolidation, replacement, or removal for a defined subject.
  Do not use for running tests, reporting coverage alone, routine test writing during implementation,
  general change review, acceptance review, failure diagnosis, or implementation of test changes.
---

# Testing

## Purpose

Decide whether tests provide meaningful evidence for accepted behavior through the correct public interface.

Identify which tests to retain, strengthen, consolidate, replace, or remove without treating test count or coverage as a proxy for value.

## Responsibility

Own the design and assessment of test evidence for a defined subject.

Do not own routine test execution, implementation, general patch review, acceptance against a product contract, or causal diagnosis of a failing test.

## Required inputs

Establish:

- the subject under test;
- the behavior or contract that needs protection;
- the layer at which the claim is made;
- the public interface that owns evidence for that claim;
- the relevant existing tests or proposed cases;
- the implementation path only to understand reachability, boundaries, and hidden coupling;
- applicable repository testing policy and shared test infrastructure;
- sources of nondeterminism, shared state, external I/O, cleanup, retries, and timing when they can affect repeatability; and
- known regressions or operating evidence when they are available.

Tests establish encoded expectations.
They do not establish production history or product intent by themselves.

If the accepted behavior is unknown and would change the test design, return `Test-design verdict: insufficient-evidence` and identify the smallest owner decision or authoritative artifact required.

## Reference guidance

Before designing tests or classifying existing tests, read [behavior-testing-examples.md](references/behavior-testing-examples.md) completely.

Use its examples to distinguish public behavior from implementation structure, select the correct evidence layer, design factories, detect coverage theater, challenge boundaries, choose relevant execution scope, and avoid implementation-shaped test organization.

Do not substitute evaluation fixtures or this entrypoint summary for the example guidance.

Read the following references when the selected scope needs them:

- Read [test-quality-properties.md](references/test-quality-properties.md) for a test-quality audit, suite health assessment, or a claim about understandability, maintainability, repeatability, atomicity, necessity, granularity, speed, or test-first history.
- Read [mutation-test-design.md](references/mutation-test-design.md) when conditions, arithmetic, boolean combinations, collection operations, optional values, ordering, or meaningful side effects can hide weak assertions.
- Read [special-test-evidence.md](references/special-test-evidence.md) when the scope includes characterization or golden-master tests, snapshots, asynchronous retry helpers, timers, randomness, browser components, or user journeys.

Do not load a conditional reference when its subject is outside the selected scope.

## Expectation authority

Separate three different forms of evidence:

- an authoritative contract defines accepted behavior;
- an observed production or legacy behavior establishes compatibility evidence; and
- a test records an expectation that may or may not have either authority.

A characterization, approval, snapshot, or golden-master test can detect change without proving correctness.

Do not preserve suspicious observed behavior as accepted behavior, and do not remove it without resolving compatibility risk or replacing its change-detection value.

If the authority of an expectation changes the recommendation and is unknown, return `Test-design verdict: insufficient-evidence`.

## Evidence layers

Match the claim to the narrowest public interface that honestly proves it.

| Claim | Interface that owns the evidence |
| --- | --- |
| Domain or application behavior | Exported domain or application operation and its result or side effects |
| Persistence behavior | Repository or persistence boundary against the real supported datastore behavior when material |
| HTTP API contract | Request and response through the registered HTTP boundary |
| Component behavior | Rendered output, public properties, accessible state, and public events |
| Browser behavior | Browser navigation, lifecycle, visible state, and browser-observed network activity |
| User journey | Accessible user actions and user-visible outcomes across the real journey |
| External integration contract | The owned adapter boundary against a representative provider response or controlled substitute |

Do not use evidence from a lower layer to claim that a higher layer works.

A direct HTTP request can prove an API contract.
It cannot prove that a browser control, cookie policy, redirect, loading state, error state, or rendering path works.

A raw source-string assertion proves that text exists in a file.
It cannot prove rendered structure, accessibility, interaction, navigation, or browser behavior.

## Behavior evidence gate

For each test, identify:

1. the behavior claim in domain language;
2. the observable input, action, and outcome;
3. the public interface that owns the claim;
4. the defect or realistic behavior change the test would detect;
5. whether a behavior-preserving internal refactor would keep the test valid; and
6. whether another test already proves the same behavior at an equal or stronger boundary.

Do not classify a test as valuable only because it executes production lines, covers a branch, uses a real object, or previously failed.

Do not classify a test as useless only because it uses mocks, asserts an interaction, or targets an exported module.

The claim and evidence boundary determine value.

## Interaction assertions

Treat an interaction assertion as behavior evidence when the interaction is an observable contract exposed through the public interface.

Examples include:

- a callback supplied by the caller;
- a message published through an owned output port;
- a transaction committed through a declared persistence boundary;
- a cancellation propagated to a supplied operation; or
- an external request contract owned by an adapter.

Treat an interaction assertion as implementation-coupled when it spies on an internal collaborator that the caller did not supply and does not verify a meaningful observable outcome.

Do not mock the function being tested.

Do not let a mock bypass the material boundary whose behavior the test claims to prove.

## Refactor-resistance check

Challenge each test with a plausible behavior-preserving refactor.

Examples include:

- inline or extract a private helper;
- replace one internal collaborator with another;
- reorder internal operations that have no observable ordering contract;
- rename or reorganize internal modules;
- replace an internal cache or collection; or
- consolidate equivalent internal branches.

If the behavior remains accepted but the test fails only because internal structure changed, classify the test as implementation-coupled.

Do not apply this check to an interaction whose order, target, or payload is itself part of the accepted public contract.

## Mutation-aware challenge

Use realistic behavior mutations to test assertion strength.

Apply the operator-specific examples in [mutation-test-design.md](references/mutation-test-design.md) when the subject contains the relevant constructs.

Consider mutations such as:

- invert or remove a condition;
- change an equality or boundary value;
- return the wrong result variant;
- omit a required side effect;
- publish before durable completion;
- change meaningful ordering;
- map an error to the wrong public outcome;
- omit authorization or scope filtering;
- accept malformed boundary input; or
- retain state after cancellation or failure.

For each material mutation, identify the test that would fail.

If no test would fail, record a behavior-evidence gap.

Do not require an automated mutation harness when a focused counterexample establishes the gap.
Do not claim mutation effectiveness unless the mutation was actually applied and the relevant test failed.

Use just-below, exact, and just-above values for meaningful numeric boundaries.
Use mixed boolean values to distinguish `&&` from `||`.
Avoid identity-only examples such as adding zero or multiplying by one when they cannot distinguish the intended operation from a mutation.

## Test-quality properties

When the user requests a quality audit, assess the applicable properties from [test-quality-properties.md](references/test-quality-properties.md).

Do not calculate an aggregate quality score.
The properties have different importance for different subjects.

Mark speed as unknown without execution or trustworthy timing evidence.
Mark test-first history as unknown without a captured failing run, development trace, or relevant history.

Do not infer repeatability from one passing run.
Inspect or exercise time, randomness, concurrency, network access, persistent state, ordering, cleanup, and retry behavior when they are material.

## Asynchronous and browser evidence

Apply the examples in [special-test-evidence.md](references/special-test-evidence.md) when the selected scope is asynchronous or browser-facing.

An asynchronous assertion must observe the settled outcome.
A retry callback must not perform the action under test because the callback can run more than once.
Arbitrary sleeps and blanket retries do not prove readiness or repair nondeterminism.

For browser and user-journey claims, require an accessible browser action or browser-owned lifecycle event plus the user-visible outcome.
Network observation can strengthen that evidence, but a test-created direct request cannot replace it.

## Fixtures and factories

Apply the complete factory examples and counterexamples in [behavior-testing-examples.md](references/behavior-testing-examples.md).

Use a fixture or factory when repeated or nested setup becomes clearer behind a named builder.

Keep one-off values inline.

A factory must produce fresh, valid scenario data by default.
Make intentional invalidity explicit at the call site.
Reuse an existing production schema when it already owns the boundary contract.
Do not redefine the production contract inside test code.
Do not share mutable scenario objects across tests.

Do not create a new test helper, factory, or harness when an existing coherent one can be reused or extended.

## Redundancy and consolidation

Classify tests as redundant only when they prove the same accepted behavior at the same or a weaker evidence boundary without adding a material case, invariant, failure mode, or diagnostic value.

Textual similarity, shared imports, shared production coverage, or common setup do not prove redundancy.

Prefer parameterization when cases share one behavior rule and remain clear as a table.

Prefer separate tests when cases have materially different behavior claims, failure meaning, setup, or ownership.

Do not delete unique behavior evidence because another test executes the same code.

Do not retain duplicate cases only to preserve a test count or coverage percentage.

## Removal gate

Recommend removal only when at least one condition is established:

- the test proves no observable or contractual behavior;
- the test is coupled only to replaceable implementation structure;
- equal or stronger evidence already protects the same behavior;
- the behavior was explicitly removed from the accepted contract;
- the test proves framework or language behavior rather than product behavior; or
- the test is unreachable or obsolete under verified current ownership and configuration.

When removal would leave an accepted behavior without evidence, recommend replacement before removal.

Do not use test count, file length, runtime, mock count, coverage, or change frequency as a removal rule.
Use these only as cost signals after test value is established.

## Verdicts

Return one terminal verdict:

- `Test-design verdict: adequate` when the selected behavior has proportionate evidence at the correct boundaries and no material design defect is established.
- `Test-design verdict: strengthen` when accepted behavior lacks material positive, negative, boundary, failure, or side-effect evidence.
- `Test-design verdict: consolidate` when equal or stronger evidence can replace verified redundant cases without losing behavior protection.
- `Test-design verdict: replace` when current tests are implementation-coupled or use the wrong evidence layer, but the accepted behavior still needs protection.
- `Test-design verdict: remove` when verified cases satisfy the removal gate and no replacement is required.
- `Test-design verdict: mixed` when different selected cases require different actions.
- `Test-design verdict: insufficient-evidence` when the behavior contract, owner, interface, or relevant artifacts are not established.

## Output protocol

Report:

1. scope and authoritative behavior inputs;
2. the public evidence boundary for each material claim;
3. a concise behavior-evidence map;
4. retained tests and the behavior each protects;
5. tests to strengthen, consolidate, replace, or remove, with exact evidence;
6. material gaps and realistic mutations that would survive;
7. applicable quality-property ratings and unknowns when the request includes a quality audit;
8. the terminal test-design verdict; and
9. the focused verification that could disprove the verdict.

Separate observed facts from derived judgments.

Name exact tests, files, interfaces, and behavior claims.

## Boundaries

Keep this capability read-only.

Do not edit production code, tests, fixtures, configuration, or CI while this skill is active.

Do not turn the assessment into a general patch review.
Use `adversarial-review` when the user requests merge readiness or an independent review of a defined change.

Do not decide whether an implementation satisfies an authoritative product contract.
Use `acceptance-review` for that verdict.

Do not diagnose why a concrete test or behavior currently fails.
Return `Routing request: causal-debugging` when causal isolation is required.

Return accepted test implementation to ordinary authorized execution.

## Failure conditions

This capability fails when it:

- treats coverage or test count as test value;
- calls a test behavioral without naming its observable claim and evidence boundary;
- calls a test implementation-coupled only because it uses a mock;
- treats internal collaborator calls as product outcomes without an accepted interaction contract;
- uses an API test as proof of browser or user-journey behavior;
- recommends deletion without proving redundancy, obsolete behavior, wrong-layer evidence, or absence of a meaningful claim;
- preserves a test only because it adds coverage;
- invents product behavior to justify a test;
- treats an observed characterization baseline as proof of correct or accepted behavior;
- infers repeatability, speed, or test-first history without the required evidence;
- accepts a retry callback that can repeat the action under test;
- claims mutation effectiveness without executing the mutation and observing the failure;
- implements changes while the assessment is active; or
- expands into general change review, acceptance review, or failure diagnosis.
