---
name: architecture-evolution
description: Evaluate materially different system structures and expensive-to-reverse engineering choices after relevant research is complete. Use only when the user requests structural option analysis involving responsibility boundaries, dependency direction, data ownership, consistency, trust, deployment topology, distributed coordination, resilience, operability, scalability, migration, or long-term ownership. Do not use automatically during implementation, for local design details, for generic architecture commentary, for speculative future scale without evidence, or before the research gate passes.
---

# Architecture Evolution

## Contract

Evaluate how a system can evolve without losing correctness, operability, reversibility, or ownership clarity.
Consume an evidence-complete problem statement and a credible structural option set.
Do not invent missing requirements or select a final option on unsupported assumptions.

Maintain one verdict:

- `evaluated`: Material architectural consequences and differentiators are established.
- `research-required`: A load-bearing fact must return to `research-before-solution`.
- `no-architecture-decision`: The issue is local and does not justify structural change.
- `unsafe`: No presented option preserves a required invariant or credible transition.

## 1. Confirm the input

Require:

- `Research verdict: complete`;
- observable outcome and constraints;
- current system model;
- invariants;
- credible options;
- material uncertainty.

Return `research-required` when current behavior, scale, ownership, trust, data, or operational assumptions remain decision-relevant and unverified.
Return `no-architecture-decision` when a supported local mechanism solves the outcome without durable structural change.

## 2. Model the current system

Read [architecture-model.md](references/architecture-model.md) for boundary, state, failure, feedback, and evolution analysis.

Map only decision-relevant:

- responsibilities and owners;
- dependency direction;
- state and sources of truth;
- consistency and concurrency guarantees;
- trust and authorization boundaries;
- synchronous and asynchronous flows;
- deployment and versioning units;
- failure propagation and recovery;
- observability and operational control;
- known constraints and measured load.

Distinguish actual current structure from intended diagrams or documentation.

## 3. Define architectural invariants

State what every acceptable option must preserve.
Include data integrity, authorization, compatibility, recovery, bounded resource use, diagnosability, and ownership when material.
Do not optimize a quality attribute that was not established as decision-relevant.

## 4. Evaluate each option

For each credible option, determine:

- responsibility boundaries and coupling;
- data ownership and consistency model;
- trust boundaries and attack surface;
- failure modes, isolation, retry, and recovery;
- operational duties and observability;
- deployment, version skew, and compatibility;
- migration states and rollback limits;
- capacity assumptions and degradation behavior;
- team ownership and coordination requirements;
- removal, replacement, or exit path;
- new permanent obligations.

Treat caches, queues, retries, replicas, services, shared databases, event streams, feature flags, and compatibility layers as systems with ongoing obligations, not implementation conveniences.

## 5. Test system effects

Ask what happens when the option succeeds at scale and when one dependency partially fails.
Trace amplification, backpressure, delayed feedback, hidden state, incentives, operator behavior, and failure displacement.
Identify whether local simplification creates global complexity.

Require evidence for scale, availability, consistency, and organizational claims.
Prefer the existing platform or a simpler boundary when distribution has not earned its cost.

## 6. Evaluate evolution and transition

Model coexistence between current and target states.
Inspect partial rollout, mixed versions, data conversion, interruption, retry, rollback, cleanup, and decommissioning.
Reject options whose safe transition is less credible than their steady state.

## 7. Reach a verdict

Set `evaluated` only when:

- all options are compared against the same evidence-backed invariants;
- decisive differences are explicit;
- principal failure and second-order effects are understood;
- ownership and operational obligations are named;
- migration and exit are credible;
- conditions that would favor another option are known.

Set `unsafe` when no option satisfies the invariants and transition requirements.
Do not dilute an unsafe verdict with a cosmetic recommendation.

## Output

- Current architecture relevant to the decision
- Invariants and verified constraints
- Option-by-option structural analysis
- Failure, operational, migration, and ownership comparison
- Conditions that change the evaluation
- `Architecture verdict: evaluated | research-required | no-architecture-decision | unsafe`

Return the analysis to `research-before-solution` for final option ranking and recommendation.

## Boundaries

Do not create an implementation plan.
Do not write an architecture document merely because a diagram is possible.
Do not recommend new infrastructure to solve an unverified future concern.
Do not approve an option without a credible transition and exit.

## Failure conditions

Fail the skill when architecture is judged by aesthetics, current reality is inferred from diagrams alone, scale is assumed, distributed components are treated as free, failure and operations are deferred, local and global effects are collapsed, team ownership is ignored, or an option is approved without migration and exit analysis.
