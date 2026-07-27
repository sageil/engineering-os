---
name: architecture-reliability
description: >
  Evaluate whether a system will remain understandable, operable, secure,
  performant, resilient, and economical as it evolves.
---


# Architecture Review

Architecture is the set of decisions that are expensive to reverse. Review evolution, ownership, and failure—not diagram aesthetics.

## Evaluate

- domain and responsibility boundaries;
- coupling and dependency direction;
- data ownership and consistency;
- security and trust boundaries;
- failure isolation and recovery;
- deployability and version skew;
- observability and operations;
- migration and exit strategy;
- organizational fit and ownership.

## Challenge scale claims

Require evidence for expected load, consistency needs, availability targets, and team boundaries. Prefer a modular monolith or existing platform when distributed architecture has not earned its cost.

## Gate

Approve only when the design names its invariants, failure model, ownership, migration path, operational obligations, strongest alternative, and conditions that justify future evolution.

## Integrated discipline: Systems Thinking

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

## Capability handoff

Do not remain in this capability after its responsibility is complete. Use the
smallest next capability whose activation conditions are satisfied. Preserve the
evidence, assumptions, risks, and unresolved uncertainty produced here.

### Usually entered from

- Engineering Investigation
- Engineering Decision
- a design, migration, platform, or reliability review

### Usually hands off to

- **Engineering Investigation** when current-system evidence is incomplete.
- **Engineering Decision** when an architectural choice must be selected.
- **Engineering Planning** when a migration or structural change is approved.
- **Engineering Quality** when implementation begins.
- **Engineering Review** when independent approval is required.

At every handoff, identify the next capability, the artifact or evidence being
passed, the unresolved question or required outcome, and any stop condition that
must remain visible. Return to an earlier capability whenever new evidence
invalidates the current path.
