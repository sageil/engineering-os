# Incident Operations

## Operational action lease

Before a consequential action, record:
- timestamp;
- owner and approver;
- observed condition;
- causal/operational hypothesis;
- intended effect;
- exact target and maximum scope;
- expected signal and observation window;
- possible adverse effect;
- abort threshold;
- rollback, containment, or expiry condition;
- result.

An action lease ends when its observation window expires, its abort threshold is crossed, its purpose is satisfied, or incident command explicitly renews it.

Do not authorize an action from an unresolved target such as a wildcard, broad environment variable, or uncertain region.
Do not convert emergency permission into standing authority.

## Security incidents

Contain access, preserve authentication/authorization evidence, rotate or revoke credentials deliberately, and prevent further exfiltration.
Assume credentials and logs may be sensitive.
Do not notify an attacker through uncontrolled changes when coordinated response is required.

## Data integrity incidents

Stop ongoing corrupting writes when safe.
Separate availability from integrity.
Preserve affected and known-good state, define the corruption window, and validate semantics before restoration.
Do not overwrite evidence with an unverified restore.

## Availability incidents

Check saturation, dependency failure, retry amplification, traffic shape, recent changes, capacity, and load shedding.
Prefer controlled degradation over total failure when constraints allow it.
Verify mitigation does not create hidden loss or duplicate irreversible effects.

## Communication

State observed impact, current state, actions underway, risks, owner, and next update.
Avoid speculative root cause and unsupported recovery times.

## Recovery

Use bounded rollout, explicit success/abort thresholds, and integrity validation.
Keep command active through recovery and monitoring.
Record permanent corrective work separately from incident resolution criteria.
