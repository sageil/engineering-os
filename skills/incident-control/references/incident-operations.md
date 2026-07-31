# Incident Operations

## Operational action card

Before a consequential action, record:

- timestamp;
- owner and approver;
- observed condition;
- intended effect;
- exact target and scope;
- expected signal and observation window;
- possible adverse effect;
- abort threshold;
- rollback or containment action;
- result.

Do not authorize an action from an unresolved target such as a wildcard, broad environment variable, or uncertain region.

## Security incidents

Contain access, preserve authentication and authorization evidence, rotate or revoke credentials deliberately, and prevent further exfiltration.
Assume credentials and logs may be sensitive.
Do not notify an attacker through uncontrolled changes when coordinated response is required.
Engage the responsible security and legal authority when applicable.

## Data integrity incidents

Stop ongoing corrupting writes when safe.
Separate availability from integrity.
Preserve affected and known-good state, define the corruption window, and validate semantics before restoration.
Do not overwrite evidence with an unverified restore.

## Availability incidents

Check saturation, dependency failure, retry amplification, traffic shape, recent changes, capacity, and load shedding.
Prefer controlled degradation over total failure when product and safety constraints allow it.
Verify that mitigation does not create hidden loss or duplicate irreversible effects.

## Communication

State observed impact, current state, actions underway, risks, owner, and next update.
Avoid speculative root cause and unsupported recovery times.
Update when the state changes or the promised time arrives, even when no new conclusion exists.

## Recovery

Use bounded rollout, explicit success and abort thresholds, and integrity validation.
Keep command active through recovery and the monitoring window.
Record permanent corrective work separately from incident resolution criteria.
