---
name: learning-and-knowledge-capture
description: >
  Use after meaningful engineering work, incidents, investigations, decisions, or repeated friction to determine what should permanently change.
---

# Learning and Knowledge Capture

Learning is a change to the system, not a summary of what happened.

## Ask

What surprised us? Which assumption failed? What made detection or recovery slow? What would prevent recurrence or reduce decision cost next time?

## Placement hierarchy

Prefer: invariant in code or schema → test or automation → documentation/runbook → ADR → scoped memory → nothing. Do not create artifacts without future value.

## Distill

Capture the reusable principle, trigger, rationale, and evidence. Avoid timelines unless needed for incident analysis. Assign ownership and removal/revalidation conditions.

## Gate

A learning action must reduce recurrence, detection time, recovery time, uncertainty, or cognitive load. If it changes nothing, it is documentation theatre.
