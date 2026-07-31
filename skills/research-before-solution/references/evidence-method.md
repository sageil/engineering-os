# Evidence Method

## Classify claims

Use these labels consistently:

- **Observed:** Directly inspected or measured in the relevant environment.
- **Reproduced:** Observed through a documented, repeatable procedure.
- **Documented:** Stated by an applicable specification, primary documentation, test contract, or decision record.
- **Reported:** Supplied by a person, ticket, log excerpt, or secondary account but not independently verified.
- **Derived:** Follows from cited evidence through an explicit inference.
- **Assumed:** Accepted temporarily without supporting evidence.
- **Unknown:** Not established by available evidence.

Do not upgrade a claim because it is plausible or repeated.

## Match sources to questions

| Question | Prefer | Do not confuse with |
| --- | --- | --- |
| What is happening now? | Reproduction, runtime state, traces, measurements | Intended behavior or old logs |
| What does the implementation do? | Owning source path, dependencies, configuration | Documentation summaries |
| What should happen? | Accepted requirements, specifications, contract tests | Incidental current behavior |
| Why did it happen? | Controlled comparison, change isolation, relevant history | Temporal correlation |
| What does an external system support? | Current official documentation, specification, provider response | Model recall or third-party summary |
| What is established scientifically? | Primary research and strong syntheses appropriate to the claim | Marketing or anecdotes |
| Why was a design chosen? | Decision records, review discussion, relevant history | Present-day inference from code shape |

Treat authority as claim-specific.
Runtime evidence can establish present behavior but not intended behavior.
Tests can establish encoded expectations but not production history.
Source can establish an execution path but not prove it ran during a reported event.
Documentation can establish a stated contract but not compliance.

## Inspect engineering reality

Start with the narrowest artifact set that can establish ownership and behavior.
Expand only for a decision-relevant question.

Inspect as applicable:

1. Repository instructions and working-tree state.
2. Entry point and owning execution path.
3. Callers, boundaries, transformations, configuration, and persistence.
4. Focused tests and fixtures that encode expected behavior.
5. Logs, traces, metrics, stored records, and reproducible probes.
6. Version history or decision records when timing or intent matters.
7. Current external primary sources for dependencies and platform behavior.

Cite exact files and symbols or line locations for code claims.
Record commands, inputs, environment, and relevant output for runtime claims.
Record version or publication date for external claims whose applicability can change.

## Research external facts

Browse when a material fact may be outdated, niche, disputed, version-specific, or outside the inspected system.
Prefer official documentation, standards, source repositories, release notes, and original research.
Use secondary sources to discover primary evidence or disagreements, not as automatic authority.
Check applicability to the exact product version, deployment mode, model, environment, and date.

Never cite a search-result summary as evidence.
Never treat model memory as an external source.

## Test explanations

For each credible explanation, identify expected observations, falsifying observations, the safest discriminating check, and residual ambiguity.
Prefer controlled comparisons that change one material factor at a time.
When control is impossible, seek independent converging evidence and reduce conclusion strength.
Do not claim causation solely because a change preceded an outcome.

## Reconcile contradictions

Check whether conflicting sources address the same claim, version, environment, input, and time window.
Distinguish intended from observed state.
Check for stale, sampled, transformed, or second-hand evidence.
Consider whether the contradiction reveals multiple paths or hidden state.

Preserve unresolved contradictions.
Do not average incompatible evidence into false confidence.

## Bound research

Continue while a practical check could change the option set, ranking, or required confidence.
Stop when the research gate passes even if non-material curiosities remain.
Return `blocked` when evidence is identifiable but inaccessible.
Return `insufficient-evidence` when accessible evidence cannot responsibly distinguish the issue.
