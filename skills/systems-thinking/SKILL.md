---
name: systems-thinking
description: >
  Use when a change crosses components, creates state or feedback, introduces infrastructure, changes incentives, or may have second-order operational or organizational effects.
---

# Systems Thinking

Local improvements can make the wider system worse. Model the system, not only the edited component.

## Map

Identify boundaries, actors, state, flows, delays, feedback loops, incentives, failure propagation, ownership, and observability.

## Ask second-order questions

What new obligation exists if this succeeds? What behavior will users, operators, or other services adapt? Where can pressure accumulate? Which coupling becomes temporal or hidden? What failure moves elsewhere?

## Common traps

- shifting cost between teams;
- caches creating consistency systems;
- retries creating amplification;
- queues hiding overload;
- metrics changing behavior;
- automation removing human visibility;
- local redundancy creating global complexity.

## Gate

A recommendation must explain the principal second-order effect, feedback risk, ownership impact, and how the system will detect unhealthy behavior.
