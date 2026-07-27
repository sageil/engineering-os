---
name: change-management
description: >
  Use when preparing, sequencing, deploying, migrating, rolling out, rolling back, deprecating, or removing a consequential change.
---

# Change Management

A correct implementation can still fail through an unsafe transition. Design the journey from old state to new state.

## Required model

Identify current state, target state, intermediate states, compatibility window, rollout unit, observation signals, stop conditions, rollback limits, data transformations, and cleanup.

## Prefer

- backward-compatible sequencing;
- small blast-radius releases;
- feature flags with ownership and removal dates;
- expand-and-contract migrations;
- rehearsed rollback or roll-forward;
- explicit success and abort thresholds.

## Beware

Irreversible writes, mixed-version incompatibility, hidden manual steps, flag combinations, incomplete backfills, and rollback that restores code but not data.

## Gate

Do not approve rollout until partial deployment, interruption, retry, recovery, observation, and cleanup are addressed.
