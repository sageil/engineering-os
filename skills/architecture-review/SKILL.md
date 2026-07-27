---
name: architecture-review
description: >
  Use when evaluating a system design, major boundary, service split, data architecture, platform choice, or long-lived technical direction.
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
