---
name: architecture-assessment
description: Assess an existing or proposed system architecture when the user requests an architecture audit, review, or fitness verdict. Do not use for patch review or solution design.
---

# Architecture Assessment

## Contract

Determine whether a defined architecture is fit for its stated outcomes, constraints, operating environment, and review horizon.
Assess the architecture that evidence establishes, not an idealized diagram or a generic maturity model.

Maintain one verdict:

- `fit`
- `fit-with-owned-risks`
- `not-fit`
- `insufficient-evidence`
- `not-applicable`

## 1. Establish the assessment boundary

Require an explicit request for an architecture audit, assessment, review, or fitness verdict.
Identify:

- the exact existing or proposed system boundary;
- relevant environment and review horizon;
- accountable architecture or system owner;
- required user and operator outcomes;
- quality, security, data, compatibility, and operating constraints;
- known change pressure, incidents, limits, and accepted risks;
- authoritative artifacts and observed runtime evidence; and
- explicit exclusions.

Return `not-applicable` when the subject has no meaningful architecture boundary, such as an isolated local presentation or text change.
Return `insufficient-evidence` when a missing load-bearing outcome, constraint, system fact, or artifact prevents a responsible fitness verdict.
Do not invent requirements, traffic, topology, ownership, or operating conditions.

## 2. Reconstruct the architecture from evidence

Read [assessment-evidence.md](references/assessment-evidence.md).

Build a reviewable system model before findings:

- components and responsibilities;
- callers and critical journeys;
- dependency direction and external dependencies;
- data ownership, writers, derived state, and consistency;
- trust, authorization, and sensitive-data boundaries;
- communication and integration contracts;
- deployment units, configuration, and operating owners;
- workload, capacity, latency, availability, and growth evidence; and
- failure, degradation, recovery, compatibility, and exit paths.

Separate current, proposed, documented, inferred, and unknown structure.
Treat diagrams and design documents as intended structure unless deployment or runtime evidence establishes the actual system.
Mark ambiguous nodes, edges, and boundaries individually rather than assigning confidence to the artifact as a whole.

## 3. Build the fitness matrix

Assess only properties that can affect the stated outcomes or constraints:

- outcome and constraint fit;
- responsibility boundaries, cohesion, coupling, change amplification, and ownership;
- data ownership, transaction boundaries, consistency, and lifecycle;
- communication, integration, compatibility, and failure semantics;
- workload, capacity, latency, growth, and cost proportionality;
- resilience, degradation, blast radius, and recovery;
- security, trust, isolation, and auditability;
- operability, observability, deployment, and support ownership; and
- evolution, migration feasibility, reversibility, cleanup, and exit.

Classify each applicable property:

- `supported`: direct evidence supports fitness for the stated horizon;
- `bounded`: evidence supports fitness within explicit limits that cover the stated need;
- `gap`: evidence shows a material outcome or constraint is not met;
- `unverified`: applicable fitness depends on missing or inadequate evidence; or
- `not-applicable`: evidence establishes that the property does not affect the scope.

Do not calculate an aggregate architecture score.
Different properties have different consequence, evidence strength, and ownership.
Do not treat an absent cache, queue, service, shard, region, pattern, or abstraction as a gap unless evidence establishes the constraint it must remove.

## 4. Trace representative scenarios

Trace the smallest set of scenarios that can disprove architecture fitness.
Include the normal critical journey and only the peak, failure, retry, recovery, compatibility, security, or change scenario that the evidence makes material.

For each scenario, state:

- initiating actor and outcome;
- components and boundaries crossed;
- state read or changed;
- authority and consistency decisions;
- latency, capacity, and dependency obligations;
- failure, degradation, and recovery behavior; and
- observable evidence of success or violation.

## 5. Challenge architecture claims

For each material mechanism, name the constraint it removes and the permanent obligation it creates.
Check whether ownership aligns with authority, state, deployment, and recovery.
Check whether the design exports policy, failure handling, consistency, or operational burden to callers and operators.
Check whether repeated changes cross unrelated owners or boundaries, require synchronized edits, or amplify one outcome change across many components.
Check whether redundancy has independent failure modes and whether recovery claims have exercised evidence.
Check whether capacity claims show assumptions, units, time windows, peak shape, headroom, and limiting resources.
Check whether integration patterns define delivery, ordering, idempotency, timeout, retry, duplicate, and uncertain-outcome behavior when applicable.

Seek counterevidence before reporting a finding.
Do not convert a familiar architecture pattern into proof of fitness.
Treat structural debt as established only when current architecture evidence shows material change, reliability, security, data, performance, or operating consequences.

## 6. Report supported findings

For every finding require:

- exact architecture surface;
- affected outcome or constraint;
- reachable scenario;
- observed or proposed mechanism;
- supporting and disconfirming evidence;
- material consequence and blast radius;
- severity and confidence;
- current owner; and
- the correction property needed for fitness.

A correction property states what must become true without choosing a replacement architecture.
Do not produce a redesign roadmap during an assessment.
When correction selection is consequential and requested, return `Routing request: research-before-solution` after the assessment verdict.

Prioritize decision areas by affected outcome, consequence, reachability, blast radius, evidence strength, and urgency.
Do not prioritize by architectural fashion, ease of correction, or the order of the fitness matrix.

## 7. Apply the assessment gate

Set `fit` only when every material applicable property is `supported`, `bounded`, or `not-applicable`, and no material unowned risk remains.
Set `fit-with-owned-risks` only when remaining nonblocking gaps have an authorized owner, consequence, containment, observation, review condition, and expiry or revisit event.
Set `not-fit` when at least one supported material gap prevents a stated outcome or constraint.
Set `insufficient-evidence` when an applicable load-bearing property remains `unverified` and prevents a responsible verdict.
Set `not-applicable` only when evidence establishes that the requested subject has no meaningful architecture boundary.

## Output

- Scope, environment, horizon, authority, outcomes, constraints
- Evidence-backed architecture model with uncertainty
- Architecture fitness matrix
- Representative scenario traces
- Findings and correction properties
- Prioritized decision areas without selected redesigns
- Owned risks and revisit conditions
- Verification performed and missing evidence
- `Architecture-assessment verdict: fit | fit-with-owned-risks | not-fit | insufficient-evidence | not-applicable`

## Boundaries

Do not review a patch, branch, migration plan, or other defined change for merge readiness.
Do not select or design a replacement architecture.
Do not issue a production launch or operational-readiness verdict.
Do not perform a threat model, protocol security assessment, or active security test.
Do not decide criterion-by-criterion acceptance against one authoritative contract.
Do not claim a net complexity reduction without the conserved behavior and whole-path mechanism comparison.
Do not implement remediation or create an execution plan.

## Failure conditions

Fail when the assessment scores document presence, treats intended topology as deployed fact, invents scale or requirements, penalizes absent fashionable components, reports findings without a reachable consequence, ignores counterevidence, recommends a rewrite without a new research decision, hides an unverified load-bearing property in narrative, or issues a verdict broader than the inspected scope and evidence.
