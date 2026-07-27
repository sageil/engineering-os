---
name: incident-response
description: >
  Use during or immediately after a production incident, outage, security event, data issue, or rapidly degrading system.
---

# Incident Response

During an incident, the first obligation is to reduce harm without destroying evidence or creating a larger failure.

## Priorities

1. Protect people, data, money, and security.
2. Establish command, scope, and communication.
3. Stabilize and reduce blast radius with reversible actions.
4. Preserve evidence and timestamps.
5. Form and test hypotheses.
6. Recover service deliberately.
7. Verify recovery and monitor recurrence.
8. Learn without blame.

## Rules

- Do not deploy speculative fixes into an unstable system when safer mitigation exists.
- Record actions and observations separately from interpretations.
- Avoid simultaneous interventions that destroy causal information.
- Distinguish trigger, root cause, and systemic contributors.
- Communicate known facts, uncertainty, impact, ownership, and next update.

## Gate

Every action must state expected benefit, risk, reversibility, verification, and owner. Recovery is not complete until customer impact, data integrity, and monitoring are verified.
