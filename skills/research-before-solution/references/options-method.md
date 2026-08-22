# Options Method

## Purpose

Spend detailed reasoning only on candidates that survive known reality.

Candidate generation is not the first solution step. **Viability screening is.**

## Preserve the research boundary

Begin only after:

`Research verdict: complete`

Do not add unsupported facts during option generation.

The evidence record and viability contract define the admissible solution space.

If any candidate introduces a material decision-relevant assumption, stop solution work and return to research. Do not hide the assumption in a risks section and continue.

## Build the viability contract

Before generating candidates, restate evidence-backed:

- observable outcome;
- affected scope;
- current owner;
- hard constraints;
- invariants;
- compatibility obligations;
- deployment and operational boundaries;
- required external capabilities; and
- remaining non-material uncertainty.

Express the contract as:

### `MUST`
Conditions every viable option satisfies.

### `MUST NOT`
Conditions every viable option avoids.

### `REQUIRES`
Capabilities, contracts, authority, topology, or dependencies that must exist.

### `PRESERVE`
Existing correctness, compatibility, ownership, trust, data, recovery, or operational properties that remain true.

### `NON-MATERIAL UNKNOWN`
Unresolved facts established not to affect feasibility or ranking.

Every item must trace to evidence.

"Cleaner", "modern", "standard", "scalable", "simple", "best practice", and model familiarity are not viability constraints unless tied to decision-relevant evidence.

## Generate candidate shapes, not designs

Search from the least expansive credible mechanism:

1. Accept the current behavior.
2. Clarify or remove the requirement.
3. Delete, disable, or roll back behavior.
4. Change configuration or use an existing supported capability.
5. Extend the current owning mechanism.
6. Make a narrow local change.
7. Consolidate responsibility into an existing appropriate abstraction.
8. Refactor the owning abstraction.
9. Introduce a genuinely new dependency, service, datastore, queue, or infrastructure mechanism.

Generate only enough detail to test eligibility.

Do not design schemas, APIs, workers, retry policies, deployment topology, or implementation structure during candidate screening unless that detail is necessary to determine feasibility.

## Cheap candidate screen

For each candidate shape, test every relevant viability constraint.

Classify:

- **eligible** - no known constraint disqualifies it and every material prerequisite is evidenced;
- **rejected** - known evidence or a constraint disqualifies it;
- **research-needed** - feasibility depends on a material unverified prerequisite.

A candidate is not `eligible` merely because it is technically possible in general.

A candidate is not `eligible` when its feasibility depends on words such as:

- likely;
- probably;
- normally;
- should;
- presumably;
- typically; or
- "we can assume".

### Rejected

Stop reasoning about it.

Do not elaborate a rejected candidate's architecture merely to explain why it fails.

Record the shortest evidence-backed rejection when it prevents repeat investigation.

Example:

> Rejected: provider webhooks - current provider documentation for this product exposes no push/event capability.

That is enough. Do not then design signing, retries, endpoints, or queues for it.

### Research-needed

Return to research.

Do not present it to the user as an option with a caveat.

Do not compare it against eligible candidates until the prerequisite is established.

### Eligible

Only eligible candidates may enter detailed option analysis.

## Construct credible options

Include only materially distinct eligible candidates.

Treat differently named options using the same mechanism as one option.

Do not force a minimum option count.

Include deletion, rollback, configuration, reuse, consolidation, deferral, or doing nothing when evidence makes them credible.

For a new reusable abstraction, require evidence that:

- the responsibility is not already owned appropriately;
- existing extension points are insufficient;
- the abstraction owns a semantically coherent responsibility;
- callers and state boundaries remain comprehensible; and
- the new mechanism does not create ambiguous or duplicate ownership.

## Analyze eligible options

For each eligible option, identify:

- mechanism and scope;
- evidence it addresses;
- evidence-backed prerequisites;
- preserved and changed behavior;
- failure modes and second-order effects;
- security and compatibility implications;
- reversibility, cleanup, and lifetime ownership cost;
- migration/rollout implications when material; and
- focused verification capable of disproving success.

Distinguish verified consequences from predictions.

Label predictions with their assumptions.

If analysis exposes a material prerequisite that should have been checked earlier, stop and return to research. Do not reward sunk reasoning by continuing.

## Compare and recommend

Compare against the same evidence-backed criteria.

Explain decisive tradeoffs rather than hiding them in a score.

Identify the strongest rejected **eligible** option and why it lost when a recommendation is possible.

Recommend only when one option is materially stronger for the stated outcome.

Use a conditional recommendation only when the condition is genuinely outside the current research boundary and does not conceal a practically resolvable material unknown.

Decline to recommend when evidence does not justify a ranking.

A recommendation must be based on evidence-backed criteria, not familiarity, novelty, architectural taste, or how much detail has already been generated.
