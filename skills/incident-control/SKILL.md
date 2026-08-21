---
name: incident-control
description: >-
  Control active production incidents that threaten users, data, money, security,
  compliance, or service availability. Use when harm is ongoing or likely to escalate
  and the immediate responsibility is command, containment, stabilization, evidence
  preservation, recovery, and clear status communication. Permit only the narrow
  emergency exception needed for controlled reversible mitigation before full research
  is complete. Do not use for ordinary bugs, post-incident analysis, planned maintenance,
  speculative risks, or implementation after the system is stable.
---

# Incident Control

## Contract

Reduce harm while preserving evidence, decision authority, and recovery options.
Prioritize safety and stabilization over root-cause completeness.
Use the smallest controlled mitigation supported by current observations.

Maintain one incident state:
- `declared`
- `containing`
- `stabilized`
- `recovering`
- `monitoring`
- `resolved`
- `blocked`

Do not skip directly from action taken to resolved.
When impact recurs, return to `containing` and re-establish scope, controls, and update cadence.

## 1. Declare and establish command

Record start time, current impact, affected users/systems, severity, incident lead, action authority, communication owner, and next update time.
Create one authoritative timeline and decision log.
Separate observations, interpretations, decisions, actions, and results.

Do not infer scope from the first report.

## 2. Protect what matters most

Prioritize:
1. Human safety.
2. Security and unauthorized access containment.
3. Data and financial integrity.
4. Prevention of irreversible effects.
5. Service availability and performance.
6. Evidence preservation.

Do not trade hidden corruption for apparent availability.

## 3. Bound impact

Determine affected identities, tenants, regions, versions, data, operations, and time window.
Identify whether impact is growing, stable, or shrinking.
Find amplification paths such as retries, queues, automation, replication, caches, and dependent systems.

Do not delay a safe containment action merely to complete the impact map.

## 4. Choose controlled mitigation

Read [incident-operations.md](references/incident-operations.md).

Every consequential action requires an **action lease**:
- observed condition it addresses;
- hypothesis for why the action should reduce harm;
- exact target and maximum blast radius;
- expected benefit;
- risk and possible worse outcome;
- owner and authority;
- observation window;
- verification signal;
- abort threshold;
- reversal, containment, or expiry condition.

An emergency mitigation is authorized only for the bounded lease.
Do not let a temporary mitigation silently become a permanent design decision.

Prefer traffic reduction, isolation, disablement, rollback, read-only mode, rate limiting, or feature containment when safer than speculative code.

Change one major factor at a time when the situation permits.

## 5. Preserve evidence

Preserve timestamps, logs, traces, configuration, deployed versions, relevant state, commands, decisions, and external responses before destructive cleanup when practical.
Protect sensitive evidence and record access.

## 6. Verify stabilization

Set `stabilized` only when:
- active harm is controlled or bounded;
- no known amplification path remains uncontrolled;
- critical data/security integrity has evidence-backed status;
- mitigation behavior is observed, not assumed;
- monitoring detects recurrence;
- command and communication remain active;
- temporary action leases are still valid, reversed, or explicitly transferred.

Stabilized does not mean root cause established.

After stabilization, keep incident control as supervisory context.
A new routing decision may select one bounded working skill without transferring operational command.

## 7. Recover deliberately

Require an approved recovery path with current state, target state, intermediate states, observation, abort conditions, retry behavior, data validation, and rollback/roll-forward limits.

When recovery crosses persistent state, incompatible versions, or coordinated systems and the user requests a recovery plan, return:
`Routing request: execution-planning`

Restore in bounded units and verify user behavior, integrity, security, dependencies, and capacity.

## 8. Monitor and resolve

Enter `monitoring` only after recovery criteria pass.
Define monitoring window, recurrence signals, thresholds, and owner.

Set `resolved` only when impact ended, integrity implications are verified or transferred, recovery/cleanup are complete, recurrence detection is active, communication is complete, follow-up work has owners, and no required operational action remains hidden.

## Output

- Incident state, severity, lead, and update time
- Observed impact and uncertainty
- Timeline of decisions, actions, and results
- Current action leases and controls
- Integrity and recurrence evidence
- Blockers and required authority
- Active working skill and bounded responsibility
- `Incident state: declared | containing | stabilized | recovering | monitoring | resolved | blocked`

## Boundaries

Do not perform full post-incident analysis during active harm.
Do not deploy speculative permanent fixes into an unstable system when safer mitigation exists.
Do not declare root cause from incident correlation.
Do not close while integrity, recovery, or cleanup remains.

## Failure conditions

Fail when command is ambiguous, interventions destroy evidence, actions lack bounded scope/verification/expiry, reversible mitigation is ignored for speculative code, a temporary mitigation becomes permanent without research, communication hides uncertainty, stabilization is inferred from silence, integrity is unverified, or resolution is declared with unfinished recovery.
