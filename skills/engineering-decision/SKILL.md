---
name: engineering-decision
description: >
  Use when choosing among credible engineering actions or deciding whether any change should be made. Apply to build-vs-buy, architecture, prioritization, rollback, deprecation, investment, and high-consequence trade-offs.
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
