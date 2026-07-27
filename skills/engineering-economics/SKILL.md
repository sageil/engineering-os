---
name: engineering-economics
description: >
  Use when assessing whether engineering work, complexity, infrastructure, dependencies, optimization, migration, or refactoring is worth its total cost.
---

# Engineering Economics

Engineering resources are finite. A technically valid solution can still be a bad investment.

## Evaluate expected value

Consider benefit, probability, time horizon, implementation cost, review cost, migration cost, maintenance, operations, incident exposure, opportunity cost, and deletion cost. Avoid invented precision; ranges and qualitative comparisons are often more honest.

## Burden of proof

New dependencies, abstractions, services, caches, queues, databases, configuration, optimizations, and compatibility layers must earn their lifetime cost.

## Biases to resist

- sunk-cost continuation;
- speculative scale;
- optimization without a constraint;
- building reusable machinery for one use;
- treating developer time as free;
- ignoring decommissioning and migration.

## Gate

Recommend work only when expected value exceeds total ownership and opportunity cost at the relevant confidence level. Otherwise simplify, defer, measure, or do nothing.
