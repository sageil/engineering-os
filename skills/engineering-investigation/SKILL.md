---
name: engineering-investigation
description: >
  Apply before designing, planning, implementing, debugging, refactoring,
  reviewing, or recommending engineering changes whenever the correct
  explanation or solution is not already established. Use for ambiguous bugs,
  unfamiliar repositories, high-consequence work, competing explanations,
  unexpected behaviour, performance investigations, incidents, migrations, or
  any task where assumptions could materially change the outcome. Discover
  reality, compare credible hypotheses and existing solutions, and earn the
  right to change the system before editing it.
---

# Engineering Investigation

Engineering starts by reducing uncertainty, not by changing code.

The first explanation is a hypothesis. The first solution is a candidate. The
purpose of investigation is to discover what is true, not to confirm what first
seemed plausible.

Required lifecycle:

> Frame the question → inspect reality → identify invariants → build competing
> hypotheses → seek disconfirming evidence → compare explanations and existing
> solutions → decide whether evidence justifies planning or change.

## Investigation constitution

- Reality outranks intuition, memory, convention, and familiarity.
- Questions about current behaviour come before proposed fixes.
- Material assumptions must become verification tasks.
- A concern is not a conclusion until it survives attempts to refute it.
- Repository-specific evidence precedes generic external patterns.
- Existing solutions, deletion, configuration, and stronger invariants must be
  considered before new code or architecture.
- Investigation depth scales with consequence and uncertainty.
- Contradictory evidence invalidates the current model; stop and revise it.
- No change is justified merely because it is plausible.

## 1. Frame the investigation

State the question in terms of observable reality.

Prefer:

> Determine why expired sessions reach protected endpoints.

Over:

> Fix authentication.

Identify:

- observed behaviour
- expected behaviour
- affected user or system outcome
- constraints and acceptance criteria
- evidence that would distinguish success from failure

Do not assume the requested mechanism is the correct solution.

## 2. Establish evidence classes

Keep these distinctions explicit internally:

- **Observed:** directly inspected, executed, or measured
- **Derived:** follows from verified code, types, constraints, or documentation
- **Documented:** supported by authoritative documentation for the applicable version
- **Assumed:** plausible but unverified
- **Unknown:** insufficient evidence

Never present assumptions as observations. Never act on a material assumption
when verification is reasonably available.

## 3. Inspect the system before proposing change

Inspect only evidence that can affect the decision, including as relevant:

- repository instructions
- relevant source and surrounding code
- callers and downstream effects
- tests and fixtures
- types and interfaces
- configuration and feature flags
- schemas, transactions, and constraints
- dependency and runtime versions
- deployment and migration definitions
- logs, traces, and reproducible output
- nearby implementations and existing abstractions

Do not infer architecture, ownership, guarantees, or generated-code boundaries
from filenames alone.

## 4. Discover the affected invariants

Identify what must remain true.

Examples:

- authorization is enforced at the trust boundary
- one event creates at most one irreversible effect
- valid data survives migration and rollback
- supported clients remain compatible
- failures remain observable and recoverable
- resource use remains bounded

Investigate the invariant, not merely the edited file.

## 5. Build credible competing hypotheses

For ambiguous behaviour, identify the strongest realistic explanations. Do not
generate cosmetic variants to satisfy a quota.

For each hypothesis define:

- what it explains
- evidence that supports it
- evidence that would contradict it
- assumptions it depends on
- the cheapest decisive probe

One serious alternative is better than several artificial ones.

## 6. Falsify before accepting

Actively search for evidence that disproves the leading hypothesis.

Check whether:

- the path is unreachable
- validation or authorization occurs elsewhere
- types or constraints exclude the state
- framework behaviour already supplies the safeguard
- the symptom has a different upstream cause
- tests contradict the explanation
- the issue predates and is unaffected by the current change

Discard hypotheses that fail. Do not defend prior effort.

## 7. Prefer decisive, read-only probes

Use the least invasive action that can distinguish hypotheses:

- targeted search
- code and configuration inspection
- focused test execution
- logs or trace inspection
- type or schema checks
- reproduction without mutation
- official version-specific documentation

Instrument or edit only when read-only evidence cannot resolve a material
unknown. Keep experiments isolated and reversible.

## 8. Search for existing and simpler solutions

Before inventing a fix, investigate in this order when relevant:

1. clarify or remove the requirement
2. delete or simplify existing behaviour
3. strengthen an invariant or data model
4. use configuration
5. reuse an existing repository abstraction
6. use a supported framework or platform feature
7. use the standard library
8. make a small local implementation
9. add a dependency
10. introduce new infrastructure or architecture

Repository conventions matter, but they do not excuse obsolete or unsafe
practice. Verify version-sensitive guidance using authoritative sources.

## 9. Scale investigation by consequence and uncertainty

Increase rigour when either is high.

High-consequence areas include security, permissions, money, sensitive data,
persistent state, destructive actions, public APIs, concurrency, distributed
coordination, infrastructure, migrations, and difficult rollback.

A one-line change may require deep investigation. A broad mechanical change may
not.

## 10. Decide whether evidence is sufficient

Before planning or editing, this statement must be defensible:

> The current behaviour and affected invariant are understood; the leading
> explanation survived attempts to disprove it; credible alternatives and
> existing solutions were examined; material assumptions are explicit; and the
> selected direction is supported by repository or system evidence rather than
> familiarity.

If not, continue investigating, narrow the claim, or report that evidence is
insufficient.

## 11. Stop conditions

Stop and revise the investigation when:

- new evidence contradicts the leading explanation
- the ownership boundary differs from what was assumed
- the observed symptom cannot be reproduced or traced
- a simpler existing solution is discovered
- the task becomes materially broader or riskier
- a load-bearing assumption cannot be verified
- the proposed direction would violate an identified invariant

Do not improvise past contradictory evidence.

## 12. Communication

For non-trivial work, communicate only decision-useful results:

- what was observed
- what remains derived, assumed, or unknown
- which explanations were rejected and why
- which explanation currently has the strongest evidence
- which existing or simpler solutions were considered
- what evidence would still change the conclusion

Do not expose private chain-of-thought. Present evidence, conclusions,
trade-offs, and uncertainty.

## Failure conditions

The investigation fails when it:

- edits before understanding
- searches only for confirmation
- commits to the first plausible explanation
- treats assumptions as facts
- applies generic examples before inspecting the repository
- ignores existing solutions
- mistakes correlation for cause
- changes several variables in one experiment
- continues after contradictory evidence
- claims certainty beyond available evidence

## Final gate

Before consequential change, be able to answer:

1. What is actually happening?
2. What evidence establishes it?
3. Which invariant is affected?
4. Which credible explanations were considered?
5. What evidence rejected the alternatives?
6. What material assumptions remain?
7. What simpler or existing solutions were examined?
8. What observation would change the conclusion?

If a material answer is missing, the investigation is incomplete.
