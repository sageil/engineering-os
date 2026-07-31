---
name: incident-control
description: Control active production incidents that threaten users, data, money, security, compliance, or service availability. Use when harm is ongoing or likely to escalate and the immediate responsibility is command, containment, stabilization, evidence preservation, recovery, and clear status communication. Permit only the narrow emergency exception needed for reversible mitigation before full research is complete. Do not use for ordinary bugs, post-incident analysis, planned maintenance, speculative risks, or implementation after the system is stable.
---

# Incident Control

## Contract

Reduce harm while preserving evidence, decision authority, and recovery options.
Prioritize safety and stabilization over root-cause completeness.
Use the smallest reversible mitigation supported by current observations.

Maintain one incident state:

- `declared`: Impact is active and command is being established.
- `containing`: Actions are reducing blast radius or preventing escalation.
- `stabilized`: Impact is controlled and the system is safe for deliberate investigation.
- `recovering`: Service or data restoration is underway through an approved path.
- `monitoring`: Recovery criteria are met and recurrence signals are under observation.
- `resolved`: Impact, integrity, recovery, monitoring, communication, and ownership are verified.
- `blocked`: Required authority, access, ownership, or safe action is unavailable.

Do not skip directly from action taken to resolved.

## 1. Declare and establish command

Record start time, current impact, affected users or systems, severity, incident lead, action authority, communication owner, and next update time.
Create one authoritative timeline and decision log.
Separate observations, interpretations, decisions, actions, and results.

Do not infer scope from the first report.
State uncertainty explicitly.

## 2. Protect what matters most

Prioritize:

1. Human safety.
2. Security and unauthorized access containment.
3. Data and financial integrity.
4. Prevention of irreversible effects.
5. Service availability and performance.
6. Evidence preservation.

Adapt the ordering when the incident establishes a different immediate harm.
Do not trade hidden data corruption for apparent availability.

## 3. Bound impact

Determine affected identities, tenants, regions, versions, data, operations, and time window using available evidence.
Identify whether impact is growing, stable, or shrinking.
Find amplification paths such as retries, queues, automation, replication, caches, and dependent systems.

Do not delay a safe containment action merely to complete the impact map.

## 4. Choose controlled mitigation

Read [incident-operations.md](references/incident-operations.md) before consequential operational action.

For every proposed action, state:

- observed condition it addresses;
- expected benefit;
- blast radius;
- risk and possible worse outcome;
- reversibility and rollback limit;
- owner and authority;
- verification signal;
- abort threshold.

Prefer traffic reduction, isolation, disablement, rollback, read-only mode, rate limiting, or feature containment when they are safer than speculative code changes.
Change one major factor at a time when the situation permits.

## 5. Preserve evidence

Preserve timestamps, logs, traces, configuration, deployed versions, relevant state, commands, decisions, and external responses before destructive cleanup when practical.
Protect sensitive evidence and record access.
Do not preserve data outside authorized stores or increase exposure in the name of investigation.

## 6. Verify stabilization

Set `stabilized` only when:

- active harm is controlled or bounded;
- no known amplification path remains uncontrolled;
- critical data and security integrity have an evidence-backed status;
- mitigation behavior is observed, not assumed;
- monitoring can detect recurrence;
- command and communication remain active.

Stabilized does not mean root cause established.

After stabilization, return the unresolved investigation responsibility for a new routing decision between `research-before-solution`, `causal-debugging`, or no skill.
Keep incident control responsible for operational safety until resolution.

## 7. Recover deliberately

Require an approved recovery path with current state, target state, intermediate states, observation, abort conditions, retry behavior, data validation, and rollback or roll-forward limits.
When the user requests a recovery plan and recovery crosses persistent state, incompatible versions, or coordinated systems, return `Routing request: execution-planning`.
Do not activate the planning skill from inside incident control.

Restore in bounded units.
Verify user-visible behavior, data integrity, security, dependencies, and capacity at each meaningful step.

## 8. Monitor and resolve

Enter `monitoring` only after recovery criteria pass.
Define monitoring window, recurrence signals, thresholds, and owner.

Set `resolved` only when:

- user impact has ended;
- data, money, security, and compliance implications are verified or explicitly transferred to an owner;
- recovery and cleanup are complete;
- recurrence detection is active;
- status communication is complete;
- follow-up investigation and corrective work have owners;
- no required operational action remains hidden as follow-up.

## Output

- Incident state, severity, lead, and update time
- Observed impact and uncertainty
- Timeline of decisions, actions, and results
- Current containment or recovery controls
- Integrity and recurrence evidence
- Blockers and required authority
- `Incident state: declared | containing | stabilized | recovering | monitoring | resolved | blocked`

Keep status updates short and operationally useful.

## Boundaries

Do not perform a full post-incident analysis during active harm.
Do not deploy speculative permanent fixes into an unstable system when safer mitigation exists.
Do not declare root cause from incident correlation.
Do not close the incident while required integrity or recovery work remains.

## Failure conditions

Fail the skill when command is ambiguous, multiple uncontrolled interventions destroy evidence, actions lack verification or owners, reversible mitigation is ignored for speculative code, communication hides uncertainty, stabilization is inferred from silence, data integrity is unverified, or resolution is declared with unfinished recovery or cleanup.
