---
name: engineering-testing
description: >
  Use when designing, writing, reviewing, or improving tests and verification strategy for software behavior, interfaces, migrations, reliability, or regressions.
---

# Engineering Testing

Tests exist to provide decision-grade evidence, not coverage theatre.

## Start with the claim

Name the invariant or behavior the test must establish. Test observable outcomes at the lowest level that still exercises the risk.

## Strong tests

- fail for the target defect;
- survive harmless refactoring;
- control time, randomness, ordering, and external state;
- cover rejection and failure paths;
- make failures diagnostic;
- avoid mocks that bypass the behavior under test.

## Strategies

Use examples, boundary tests, properties, contracts, integration tests, concurrency tests, failure injection, migration tests, and end-to-end tests according to risk. Do not use every layer by default.

## Gate

Before calling verification sufficient, explain what each important test proves, what it cannot prove, and whether it would catch the claimed regression.
