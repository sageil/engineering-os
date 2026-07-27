---
name: engineering-decision
description: >
  Compare credible alternatives and choose the strongest practical action
  using evidence, risk, reversibility, complexity, and lifetime cost.
---


# Engineering Decision

A decision is not a preference with confident wording. It is a commitment justified by evidence, constraints, economics, and consequences.

## Required lifecycle

> Frame the outcome → identify invariants → establish evidence and uncertainty → generate credible options → evaluate consequences and economics → challenge the leading option → decide, defer, or investigate → record reversal conditions.

## Constitution

- Include **do nothing**, **delete**, **defer**, and **rollback** when credible.
- Separate intended outcome from requested mechanism.
- Do not optimize one quality attribute while silently degrading another.
- A decision must name what would make it wrong.
- Prefer reversible commitments while uncertainty is high.
- Decision authority matters: identify who owns irreversible trade-offs.

## Decision dimensions

Evaluate only material dimensions: correctness, safety, value, simplicity, compatibility, time-to-value, ownership cost, opportunity cost, reversibility, blast radius, operability, and second-order effects.

## Gate

Proceed only when you can state the selected action, strongest alternative, decisive evidence, remaining assumptions, expected consequences, and reversal trigger. If evidence is insufficient, choose investigation—not false certainty.

## Output

For significant decisions: **Decision**, **Why now**, **Evidence**, **Alternatives**, **Trade-offs**, **Risks**, **Reversal conditions**, **Next validation**. Keep it proportional.

## Integrated discipline: Engineering Economics

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

## Capability handoff

Do not remain in this capability after its responsibility is complete. Use the
smallest next capability whose activation conditions are satisfied. Preserve the
evidence, assumptions, risks, and unresolved uncertainty produced here.

### Usually entered from

- Engineering Investigation
- Engineering Debugging
- Architecture and Reliability
- Incident Response
- Engineering Review

### Usually hands off to

- **Engineering Planning** when execution is consequential, cross-cutting, or difficult to reverse.
- **Engineering Quality** when implementation is straightforward and justified.
- **Engineering Communication** when approval or explanation is required.
- **Engineering Memory** when the decision is durable institutional knowledge.

At every handoff, identify the next capability, the artifact or evidence being
passed, the unresolved question or required outcome, and any stop condition that
must remain visible. Return to an earlier capability whenever new evidence
invalidates the current path.
