---
name: engineering-refactoring
description: >
  Use when improving internal structure without intentionally changing externally observable behavior.
---

# Engineering Refactoring

Refactoring changes structure while preserving behavior and invariants. It is not a hidden feature rewrite.

## Preconditions

Establish current behavior, affected contracts, and sufficient characterization evidence. Separate structural change from behavior change whenever practical.

## Strategy

Prefer small reversible transformations, continuous verification, and deletion of duplication or accidental complexity. Preserve compatibility boundaries until migration is explicit.

## Smells are hypotheses

Duplication, large modules, conditionals, and indirection are not automatic defects. Refactor only when structure causes concrete change cost, defects, opacity, or ownership confusion.

## Gate

The final diff must preserve observable behavior, reduce a named source of entropy, and avoid speculative abstraction.
