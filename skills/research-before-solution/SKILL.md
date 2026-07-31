---
name: research-before-solution
description: Research complex, ambiguous, consequential, disputed, unfamiliar, or potentially outdated engineering issues before proposing solutions. Use for diagnosis, architecture and design questions, reliability, security, performance, integrations, incidents after stabilization, or implementation requests when correctness depends on repository evidence, runtime evidence, current external primary sources, historical context, or causal analysis. Enforce a hard gate that blocks solution options, recommendations, plans, and implementation until decision-relevant research is complete. Do not trigger for trivial, explicit, low-risk mechanical work whose relevant behavior is already verified.
---

# Research Before Solution

## Contract

Treat model knowledge as a source of questions and hypotheses, never as evidence.
Use two ordered phases:

1. Research what is true.
2. Present solution options only after the research gate passes.

Do not leak solutions into research.
Propose research actions when needed, but do not propose code, product, architecture, configuration, process, or operational changes.
Do not let a solution-shaped request bypass the gate.

Maintain one research verdict:

- `researching`: Continue gathering or testing decision-relevant evidence.
- `complete`: Unlock solution options because the completion gate passes.
- `blocked`: Stop because identifiable evidence exists but is inaccessible or requires missing authority.
- `insufficient-evidence`: Stop because the available evidence cannot support or distinguish responsible options.

Only `complete` unlocks solution work.

## 1. Frame the decision

State the exact question, affected scope, observable symptoms, constraints, and decision the research must enable.
Separate reported symptoms from inferred causes.
Identify unknowns that could change the option set or its ranking.
Exclude research that cannot affect the decision.

Use a proportional path for a low-consequence task that explicitly invokes this skill.
Inspect the owning artifact and load-bearing assumptions, then apply the same gate without unnecessary ceremony.

## 2. Plan the evidence

Identify the strongest practical evidence for each material question and how to obtain it.
Match evidence to the claim instead of using one universal hierarchy.
Read [evidence-method.md](references/evidence-method.md) for evidence classes, source selection, external research, causal standards, and contradiction handling.

Prefer direct inspection and reproducible observation over descriptions of behavior.
Use current primary sources for external facts that vary by version, environment, or date.
Inspect the owning execution path, callers, boundaries, configuration, persistence, tests, and runtime signals when they affect the question.
Use history only when timing or intent is decision-relevant.

Keep research read-only by default.
Use state-changing experiments only with authority and a clear target, risk, recovery path, and observation method.

## 3. Build the evidence record

Track each decision-relevant claim with:

- classification;
- exact source or observation;
- applicable version, environment, and time;
- limitations;
- supporting and contradicting evidence;
- effect on the decision.

Do not count repeated claims from one origin as independent corroboration.
Do not treat documentation, tests, source, runtime observations, and human reports as interchangeable.
Summarize decision-useful evidence for the user rather than dumping raw notes.

## 4. Challenge the leading explanation

Treat the first explanation as a hypothesis.
Develop credible alternatives when they exist.
Seek observations that would falsify the leading explanation.
Use a controlled comparison or reproduction before claiming causation when practical.
Label causal claims as inference when control is unavailable, and preserve the remaining alternatives.

When a failure requires systematic reproduction and causal isolation, return `Routing request: causal-debugging` for a new routing decision.
Do not activate another skill from inside this skill or ask causal debugging to choose a correction.

## 5. Reconcile the record

Resolve contradictions by checking source authority, scope, version, environment, timing, and whether each source describes intended or observed behavior.
Expose contradictions that cannot be resolved.
Convert assumptions into research steps when practical.
Retain unknowns only when they remain genuinely unresolved.

## 6. Apply the research gate

Set the verdict to `complete` only when every statement is true:

- The decision, scope, and success conditions are clear.
- The real owning path and material boundaries have been inspected.
- Every decision-relevant claim has proportionate evidence.
- Credible competing explanations have been tested or bounded.
- Material contradictions have been resolved or exposed with known consequences.
- Remaining unknowns cannot materially change the available options or their ranking.
- No practical, safe, accessible investigation is likely to change the decision materially.
- The record explains what is known, how it is known, and what is not known without fabricated certainty.

Require decision sufficiency, not absolute certainty.
Do not declare completion merely because time, context, or accessible sources ran out.

If the gate fails, continue researching or return `blocked` or `insufficient-evidence` with the smallest useful next research action.
Do not provide solution options in either failure state.

## 7. Construct solution options

Enter only after recording `Research verdict: complete`.
Read [options-method.md](references/options-method.md) before constructing options.

Restate the evidence-backed problem, constraints, and invariants.
Develop only credible, materially distinct options.
Include deletion, rollback, deferral, configuration, or doing nothing when the evidence makes them credible.
Do not invent weak alternatives to create the appearance of choice.

When options change durable boundaries, data ownership, trust, distribution, deployment, or migration, identify architecture analysis as an optional request-only capability.
Do not activate it without a new routing decision and an explicit user request.
Return to research if an option introduces a material unverified assumption.

Recommend only when evidence distinguishes the options.
Use a conditional recommendation or decline to recommend when uncertainty prevents responsible ranking.

## Output

Present results in this order:

### Research

- Question and scope
- Material evidence with exact artifact locations or citations
- Competing explanations and falsification results
- Contradictions, limitations, and remaining unknowns
- `Research verdict: complete | blocked | insufficient-evidence`

Stop unless the verdict is `complete`.

### Solution options

- Decision criteria
- Credible options and tradeoffs
- Recommendation when justified
- Verification and conditions that would change the decision

Keep the result proportional.
Expose enough evidence for another engineer to challenge it.

## Boundaries

Do not create an execution plan.
Do not implement a selected option.
Do not review a completed change.
Return the selected option to ordinary authorized execution by default.
When the user requests a transition plan and material transition hazards remain, return `Routing request: execution-planning` for a new routing decision.

## Failure conditions

Fail the skill when recall is presented as current fact, a solution is chosen before evidence collection, research searches only for confirmation, documentation is presented as runtime proof, tests are presented as production history, correlation is presented as causation, inaccessible evidence is treated as supporting evidence, file count substitutes for relevant evidence, research continues after further evidence cannot change the decision, or options appear before a `complete` verdict.
