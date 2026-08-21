---
name: research-before-solution
description: >-
  Establish decision-sufficient evidence before proposing engineering solutions.
  Use when unknown facts about the existing system, environment, dependencies,
  external capabilities, constraints, ownership, or failure model could invalidate
  a candidate solution, remove or add a credible option, or materially change the
  ranking among options. Applies to architecture, design, integration, reliability,
  security, performance, migration, platform, data, and technology decisions after
  any concrete observed failure requiring causal isolation has been bounded.
  Do not use for reproducing or diagnosing an observed failure, active incidents,
  routine repository inspection, ordinary implementation with an already selected
  mechanism, completed-change review, execution planning, or low-risk mechanical work.
---

# Research Before Solution

## Purpose

Prevent expensive reasoning about solutions that are impossible, redundant, unsafe, unsupported, or based on false assumptions.

Research is not a preface to solutioning. Its job is to **shrink the solution space before solution construction consumes effort**.

Treat model knowledge as a source of questions and hypotheses, never as evidence.

## Non-negotiable invariant

Do not propose, recommend, sketch, rank, or elaborate code, product, architecture, configuration, process, dependency, service, infrastructure, or operational changes until the research gate is complete.

A solution-shaped user request does not bypass this invariant.

Do not use candidate solutions to decide what evidence to seek. Research questions must come from the decision, material unknowns, falsifiable explanations, feasibility constraints, and the existing system.

If a candidate later reveals a material unverified prerequisite, leave solution mode and return to research.

## State machine

Maintain exactly one state:

- `researching`: Material decision uncertainty remains and practical evidence can still reduce it.
- `complete`: The research gate passes. Viability extraction and candidate screening are unlocked.
- `blocked`: Decision-relevant evidence is identifiable but inaccessible or requires missing authority.
- `insufficient-evidence`: Available evidence cannot responsibly establish or distinguish viable options.

Only `complete` unlocks any solution work.

The allowed transition is:

`researching -> complete -> viability contract -> candidate screen -> solution options`

A material unknown discovered after `complete` forces:

`solution work -> researching`

Never silently carry a material unknown forward as a caveat.

## 1. Frame the decision

State:

- the exact decision to be made;
- affected scope and observable outcome;
- success conditions;
- known constraints and invariants;
- reported facts versus inferred explanations; and
- the unknowns that could change feasibility or ranking.

A material unknown is any unknown that could:

- invalidate a candidate class;
- enable a candidate class;
- remove or introduce a credible option;
- materially reorder options;
- change a durable ownership or system boundary;
- change the required confidence before acting; or
- make a recommendation irresponsible.

Exclude questions that cannot affect the decision.

Scale research depth to consequence, reversibility, novelty, and uncertainty.

For existing systems, include uncertainty about current ownership, extension points, shared abstractions, callers, data ownership, deployment boundaries, compatibility obligations, security boundaries, and operational constraints whenever any could affect the option space.

When the skill is explicitly requested for a bounded decision, inspect the owning artifacts and load-bearing assumptions, then apply the same gate without unnecessary ceremony.

## 2. Plan evidence before searching

Read [evidence-method.md](references/evidence-method.md).

For each material unknown, identify:

- the claim that must be established;
- the strongest practical evidence for that claim;
- the safest way to obtain it;
- what observation would falsify the leading explanation; and
- how the result would affect feasibility or ranking.

Prefer direct inspection and reproducible observation over descriptions of behavior.

Use current primary sources for external facts that vary by product version, environment, date, deployment mode, or provider policy.

For repository decisions, inspect as applicable:

- repository instructions and working-tree state;
- entry point and owning execution path;
- callers and dependency direction;
- configuration, persistence, state, and trust boundaries;
- focused tests and fixtures;
- runtime evidence when behavior matters;
- semantically adjacent implementations;
- existing owners and extension points;
- shared abstractions and test infrastructure;
- deployment and compatibility constraints; and
- current external dependency or platform capabilities.

Search semantically, not only by exact names.

Keep research read-only by default. Use state-changing experiments only with authority and a clear target, risk, recovery path, and observation method.

## 3. Build a decision evidence record

Track every material claim with:

- classification;
- exact source or observation;
- applicable version, environment, and time;
- limitations;
- supporting and contradicting evidence;
- decision effect; and
- confidence appropriate to the evidence.

Use these decision effects:

- `FEASIBILITY`: can enable or eliminate a candidate class.
- `RANKING`: changes tradeoffs among otherwise viable candidates.
- `IMPLEMENTATION`: matters after a mechanism is selected.
- `NON-MATERIAL`: cannot change the decision.

For repository changes, also establish:

- what currently owns the relevant responsibility;
- which callers depend on it;
- what related mechanisms already exist;
- which invariants must remain true;
- whether a new responsibility would overlap an existing owner; and
- known facts that rule out solution classes.

Do not count repeated claims from one origin as independent corroboration.

Do not treat documentation, tests, source, runtime observations, human reports, or model recall as interchangeable evidence.

Summarize decision-useful evidence rather than dumping raw notes.

## 4. Challenge the leading explanation

Treat the first plausible explanation as a hypothesis, not a conclusion.

Develop only competing explanations that could change feasibility, the credible option set, or its ranking.

Seek observations that discriminate among them.

Use controlled comparison or reproduction before claiming causation when practical. When control is unavailable, label causal claims as inference and preserve residual alternatives.

Do not brainstorm candidate solutions as a way to find research questions.

When a concrete observed failure requires systematic reproduction and causal isolation, stop and return:

`Routing request: causal-debugging`

Do not activate another skill from inside this skill and do not ask causal debugging to choose a correction.

## 5. Hunt for solution killers

Before declaring research complete, actively seek facts that could make an attractive solution class non-viable.

Ask neutral questions such as:

- Does the upstream system actually expose the required capability?
- Does the current version support the assumed contract?
- Is there already an owner or extension point for this responsibility?
- Do compatibility requirements rule out the migration shape?
- Do latency, ordering, consistency, residency, trust, or recovery constraints rule out a boundary?
- Is operational authority available for a new dependency or service?
- Does the proposed mechanism require a deployment topology that is not true here?
- Would the mechanism duplicate state or ownership already present?

Do not ask only "Can we use X?" Ask what **any** viable solution must satisfy, then test candidate classes against those facts later.

Before the gate, explicitly ask:

> What fact, if different from my current belief, would eliminate, introduce, or materially reorder the likely solution space?

If a practical, safe, accessible check can answer it, perform that check.

## 6. Reconcile the record

Resolve contradictions by checking source authority, scope, version, environment, timing, and whether each source describes intended or observed behavior.

Expose unresolved contradictions and their decision consequence.

Convert assumptions into research steps when practical.

When multiple mechanisms appear to own the same responsibility, determine whether they are intentionally distinct, compatibility layers, migration states, generated or vendored code, or genuinely duplicated ownership. Do not infer semantic duplication from textual similarity alone.

Retain an unknown only when it is genuinely unresolved and either non-material or sufficient to justify `blocked` / `insufficient-evidence`.

## 7. Apply the research gate

Set:

`Research verdict: complete`

only when every statement is true:

- The decision, scope, success conditions, and relevant invariants are clear.
- The real owning path and material boundaries have been inspected.
- Existing ownership and adjacent mechanisms have been inspected when they could affect feasibility or ranking.
- Established extension points and repository patterns have been identified when they constrain the decision.
- External capability, compatibility, or version claims that could eliminate a solution class have current applicable evidence.
- Every material decision-relevant claim has proportionate evidence.
- Credible competing explanations that could change the decision have been tested or bounded.
- Material contradictions are resolved or exposed with known consequences.
- Every known `FEASIBILITY` fact can be expressed as a concrete viability constraint.
- Remaining unknowns cannot materially change the available options or their ranking.
- No practical, safe, accessible investigation is likely to eliminate, introduce, or materially reorder a credible candidate.
- The record makes clear what is known, how it is known, what is inferred, and what remains unknown.

Require decision sufficiency, not absolute certainty.

Do not declare `complete` because time, context, patience, or accessible sources ran out.

If the gate fails, continue research or return `blocked` / `insufficient-evidence` with the smallest useful next observation.

In `researching`, `blocked`, or `insufficient-evidence`, do **not** provide:

- candidate technologies;
- possible architectures;
- implementation sketches;
- recommended dependencies;
- "one approach would be...";
- pros/cons of unverified solutions; or
- fallback solution brainstorming.

## 8. Extract the viability contract

Enter only after `Research verdict: complete`.

Before generating candidates, translate evidence into:

### `MUST`
Conditions every viable option must satisfy.

### `MUST NOT`
Conditions every viable option must avoid.

### `REQUIRES`
Capabilities, authorities, contracts, topology, or dependencies that must exist.

### `PRESERVE`
Existing invariants, compatibility, ownership, trust, data, recovery, or operational properties that must remain true.

### `NON-MATERIAL UNKNOWN`
Unresolved facts proven unable to change feasibility or ranking.

Every item must be traceable to the evidence record. Do not convert preferences, convention, elegance, familiarity, or model intuition into constraints.

## 9. Screen candidate shapes cheaply

Read [options-method.md](references/options-method.md).

Search from the least expansive credible mechanism. Screen candidate **shapes** before detailed design.

For each candidate shape, classify:

- `eligible`: survives all known viability constraints and has no material unsupported prerequisite;
- `rejected`: known evidence or a viability constraint disqualifies it;
- `research-needed`: feasibility depends on a material unverified prerequisite.

Do not elaborate `rejected` candidates.

Do not present `research-needed` candidates as solution options. Return to `researching`, resolve the prerequisite when practical, rebuild the viability contract if needed, and screen again.

Record a rejected candidate only when its rejection is decision-useful, such as preventing repeated work on an attractive but impossible approach.

## 10. Construct solution options

Enter only when:

- `Research verdict: complete`;
- the viability contract exists; and
- at least one candidate is `eligible`.

Restate the evidence-backed problem, viability constraints, invariants, and existing ownership.

Develop only materially distinct `eligible` options.

Include deletion, rollback, deferral, configuration, reuse, or doing nothing when evidence makes them credible.

For an existing repository, search solution shapes in this order when credible:

1. Use existing behavior unchanged.
2. Extend the existing owning mechanism.
3. Consolidate responsibility into an existing appropriate abstraction.
4. Introduce a genuinely new mechanism.

This is a search discipline, not a predetermined recommendation.

Do not create a new reusable abstraction without establishing:

- the current owner;
- relevant alternatives inspected;
- why reuse or extension is insufficient;
- why new ownership is semantically distinct; and
- how ambiguous or duplicated ownership is avoided.

When options change durable boundaries, data ownership, trust, distribution, deployment, consistency, or long-term ownership, read [architecture-model.md](references/architecture-model.md) before ranking them.

Keep structural analysis inside this skill rather than activating a separate architecture skill.

If detailed option analysis reveals a material unknown, stop solution work and return to `researching`.

Recommend only when evidence distinguishes the options. Use a conditional recommendation or decline to recommend when evidence does not justify a responsible ranking.

## Output protocol

Use this order.

### Research

- Question and scope
- Material evidence with exact artifact locations or citations
- Existing ownership and relevant mechanisms when decision-relevant
- Competing explanations and falsification results
- Contradictions, limitations, and remaining unknowns
- `Research verdict: researching | complete | blocked | insufficient-evidence`

If the verdict is not `complete`, stop.

### Viability contract

- `MUST`
- `MUST NOT`
- `REQUIRES`
- `PRESERVE`
- `NON-MATERIAL UNKNOWN`

### Candidate screen

Report only decision-useful candidate shapes:

- eligible candidates;
- rejected candidates whose rejection prevents repeated wasted work.

A `research-needed` classification means return to research, not continue output.

### Solution options

- Decision criteria
- Credible options and decisive tradeoffs
- Reuse, extension, consolidation, or new ownership implications
- Recommendation when justified
- Verification capable of disproving success
- Conditions that would change the decision

Keep the result proportional. Expose enough evidence for another engineer to challenge it.

## Boundaries

Do not create an execution plan.

Do not implement a selected option.

Do not review a completed change.

Return a selected option to ordinary authorized execution by default.

When the user requests a transition plan and material transition hazards remain, return:

`Routing request: execution-planning`

for a new routing decision.

## Failure conditions

The skill fails when any of these occur:

- model recall is presented as current fact;
- a solution is chosen, sketched, or ranked before the research gate passes;
- candidate solutions influence what evidence is sought before decision constraints are established;
- research searches only for confirmation;
- documentation is presented as runtime proof;
- tests are presented as production history;
- correlation is presented as causation;
- inaccessible evidence is treated as supporting evidence;
- file count substitutes for relevant evidence;
- existing ownership is ignored when it could change feasibility or ranking;
- external capability or version assumptions are not checked when they could invalidate a solution class;
- a known feasibility constraint is discovered only after substantial candidate elaboration when it was reasonably checkable earlier;
- a candidate is elaborated despite contradicting known evidence;
- a material prerequisite is left as "likely", "probably", convention, familiarity, or a footnote instead of being researched;
- `complete` is declared while an accessible check could still eliminate, introduce, or materially reorder a candidate;
- a `research-needed` candidate is presented as a solution option;
- research continues after further evidence cannot change the decision; or
- options appear before `Research verdict: complete`, a viability contract, and candidate screening.
