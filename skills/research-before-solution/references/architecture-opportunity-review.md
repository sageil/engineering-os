# Architecture Opportunity Review

Use this method when the decision is where architecture investment is worthwhile across a repository or bounded subsystem.
This is read-only opportunity discovery inside `research-before-solution`.
It does not authorize a general rewrite or create a separate architecture workflow.

## Bound the review

State the repository or subsystem boundary, decision owner, business or operating outcome, review horizon, and evidence window.
Identify areas that are explicitly out of scope.
Do not treat repository-wide access as authority to redesign every component.

## Find decision-relevant pressure

Look for evidence that architecture impedes current or credible near-term outcomes:

- repeated co-change across files, packages, schemas, or deployables;
- repeated caller orchestration, mapping, validation, retry, or recovery policy;
- policy or domain knowledge leaking across a boundary;
- cyclic dependencies, provider details, or transport details crossing inward;
- test setup that must reproduce internal call chains to observe one outcome;
- defects, incidents, or operational work concentrated at a seam;
- ownership, trust, transaction, data, runtime, or deployment boundaries that disagree;
- changes that require coordination across independently owned parts; and
- obsolete abstractions that preserve no current invariant.

Use history, callers, tests, runtime evidence, ownership records, and incidents when they are available and applicable.
Textual similarity alone does not prove harmful coupling.

## Protect useful thin boundaries

A thin adapter can still own a valuable translation, security, deployment, compatibility, failure-isolation, or test boundary.
Do not recommend collapse only because a component has little code.
Establish what independent property the boundary preserves and who depends on it.

## Preserve research-gate discipline

During research, record pressures, protected boundaries, counterevidence, and unknowns only.
Do not form or rank architecture opportunity candidates before `Research verdict: complete` and the viability contract exist.

## Form opportunity candidates after the gate

Describe candidates as responsibility changes, not implementation plans:

- deepen a contract so callers stop carrying policy;
- collapse a pass-through layer that owns no independent property;
- split an incoherent owner along an evidenced boundary;
- move a seam to align trust, data, transaction, runtime, or deployment ownership;
- repair dependency direction;
- restore locality for behavior that changes together; or
- make an existing contract state its real obligations.

Include no-investment-now as a valid candidate.
Do not define exact interfaces before a candidate survives the research gate.

## Require counterevidence

For each candidate, record:

- observed pressure and exact artifacts;
- current owner and affected callers;
- invariant or outcome harmed by the current shape;
- evidence that the pressure is repeated rather than incidental;
- independent property preserved by the current boundary;
- credible counterevidence;
- facts that would weaken or eliminate the candidate; and
- the smallest next read-only observation that could change its rank.

Classify evidence strength as `strong`, `worth-exploring`, or `speculative`.
Report confidence separately from evidence strength.
Do not convert missing history or tests into positive evidence.

## Output contribution

Add these items to the research record before the gate:

- reviewed boundary and evidence window;
- architecture pressures with exact evidence;
- protected boundaries and counterevidence;
- confidence and remaining material unknowns; and
- the smallest bounded next evidence step.

After the gate, add:

- ranked eligible opportunity candidates or a supported no-investment result; and
- the smallest bounded design step.

After one opportunity becomes an eligible solution target, apply the ordinary architecture and module-contract references as applicable.
