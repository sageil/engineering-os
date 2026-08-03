---
name: operational-readiness
description: Assess whether a defined service, system, infrastructure component, major release, or critical workflow is ready to launch or enter sustained operation when the user explicitly requests an operational-readiness review, production-readiness review, launch assessment, or go-no-go decision. Evaluate user outcomes, service objectives, ownership, observability, capacity, dependencies, deployment, configuration, security, data integrity, failure handling, recovery, runbooks, and accepted risk using actual evidence. Do not use for patch review, routine deployment execution, active incidents, generic architecture discussion, implementation planning, or remediation implementation.
---

# Operational Readiness

## Contract

Determine whether the scoped system can deliver its required outcomes, expose degradation, contain failure, and recover under named ownership.
Treat readiness as an evidence-backed operating state, not a document-completion checklist.
Do not infer production readiness from passing unit tests, a successful build, or the existence of dashboards and runbooks.

Maintain one verdict:

- `ready`: Every release-blocking operational requirement has applicable evidence and no unaccepted blocking risk remains.
- `ready-with-accepted-risk`: Only explicitly owned and authorized nonblocking risks remain, with review conditions.
- `not-ready`: At least one credible blocking gap threatens a required user outcome, security objective, data invariant, recovery obligation, or sustainable ownership.
- `insufficient-evidence`: A load-bearing readiness claim cannot be verified from available artifacts or observations.
- `not-applicable`: The request concerns a local change or ordinary action without a meaningful operational launch boundary.

## 1. Establish the readiness decision

Require:

- the exact service, system, release, environment, and launch boundary;
- required user and business outcomes;
- critical security, data, compliance, and compatibility invariants;
- service objectives or other explicit health criteria;
- traffic, workload, dependency, and data assumptions;
- rollout, rollback, containment, and recovery commitments;
- operational owners and decision authority;
- available runtime, test, configuration, runbook, and exercise evidence.

Return `insufficient-evidence` when a missing load-bearing input prevents a responsible verdict.
Return `not-applicable` when no operational boundary or sustained ownership decision exists.

## 2. Trace critical journeys

Identify the few user, operator, data, and security journeys whose failure would invalidate readiness.
Trace each journey across entry points, dependencies, persistence, asynchronous work, configuration, deployment, observability, and recovery.
State expected, degraded, rejected, interrupted, and recovered behavior.

## 3. Inspect operational evidence

Read [readiness-model.md](references/readiness-model.md) for system objectives, capacity, observability, dependency, deployment, security, data, recovery, and ownership analysis.

For each applicable readiness claim, identify:

- requirement or invariant;
- exact evidence and environment;
- success and failure signal;
- limitation or untested condition;
- owner and operating action;
- condition that invalidates the evidence.

Prefer observed behavior and exercised recovery over intended configuration or document presence.

## 4. Challenge healthy-path confidence

Inspect dependency timeout and partial failure, overload, retry amplification, queue growth, version skew, configuration drift, credential failure, data corruption, interrupted rollout, rollback limits, operator error, and observability loss when applicable.
Ask whether the system fails safely, distinguishes degradation from success, preserves critical invariants, and gives an operator a bounded recovery action.
Do not require irrelevant catastrophe scenarios.

## 5. Evaluate ownership and sustainability

Identify who receives signals, makes rollout and recovery decisions, owns dependencies and capacity, maintains runbooks and access, and completes temporary cleanup.
Verify that escalation, decision authority, and communication expectations are usable under pressure.
Treat an unowned critical control, alert, dependency, or recovery step as a readiness gap.

## 6. Calibrate findings

For every finding, require:

- exact requirement or invariant;
- inspected evidence and missing evidence;
- reachable operational condition;
- user, data, security, or service consequence;
- existing safeguard and why it is insufficient;
- blocking status, confidence, owner, and correction direction;
- focused evidence capable of closing the finding.

Do not report generic best-practice gaps without a material readiness consequence.

## 7. Handle accepted risk

Accept a nonblocking risk only when the decision owner, scope, consequence, containment, observation signal, review condition, and expiry or removal event are explicit.
Do not use accepted risk to hide a violated critical invariant or unavailable recovery path.

## 8. Apply the readiness gate

Set `ready` only when:

- critical journeys and invariants have applicable evidence;
- health, degradation, and failure are distinguishable;
- capacity and dependency assumptions are bounded;
- rollout, interruption, rollback or containment, and recovery are credible;
- security and data implications have evidence-backed status;
- operational ownership and escalation are explicit;
- no required work remains disguised as follow-up.

Set `not-ready` when a supported blocking finding survives.
Use `insufficient-evidence` when a load-bearing check is unavailable rather than treating it as passing.

## Output

List blocking findings first, then accepted nonblocking risks.

Provide:

- Scope, environment, outcomes, invariants, and authority
- Critical journeys and readiness evidence
- Blocking findings with impact, owner, and closure evidence
- Accepted risks with review conditions
- Rollout, observability, recovery, and ownership summary
- Verification performed and unavailable checks
- `Readiness verdict: ready | ready-with-accepted-risk | not-ready | insufficient-evidence | not-applicable`

## Boundaries

Do not review an individual patch when adversarial review owns the request.
Do not execute deployment, load tests, failure injection, or recovery exercises without separate authority.
Do not command an active incident.
Do not create an implementation or transition plan.
Do not implement remediation.
Do not perform a full threat model when proactive attack-path analysis is a separate unresolved responsibility.

## Failure conditions

Fail the skill when readiness is inferred from document presence, unit tests substitute for operational evidence, nominal health hides data or security failure, unexercised recovery is called proven, accepted risk lacks an owner, follow-up hides blocking work, or a verdict exceeds the inspected environment and evidence.
