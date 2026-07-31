# Options Method

## Preserve the research boundary

Begin only after `Research verdict: complete`.
Do not add unsupported facts during option generation.
Return to research when an option introduces a decision-relevant assumption.

## Define the decision

Restate the observable outcome, affected scope, constraints, invariants, evidence-backed problem model, remaining non-material uncertainty, and criteria that distinguish a strong option.
Use criteria appropriate to the issue rather than a fixed scorecard.
Consider correctness, safety, simplicity, compatibility, resilience, performance, operability, maintainability, reversibility, and lifetime ownership only when material.

## Construct credible options

Search from the least expansive credible mechanism:

1. Accept the current behavior.
2. Clarify or remove the requirement.
3. Delete, disable, or roll back behavior.
4. Change configuration or use an existing supported capability.
5. Make a narrow local change.
6. Refactor the owning abstraction.
7. Add a dependency, service, or infrastructure.

Include only options that survive the evidence.
Treat differently named options with the same mechanism as one option.
Do not force a minimum option count.

## Analyze options

For every option, identify:

- mechanism and scope;
- evidence it addresses;
- assumptions and dependencies;
- preserved and changed behavior;
- failure modes and second-order effects;
- security and compatibility implications;
- reversibility, cleanup, and ownership cost;
- focused verification capable of disproving success.

Distinguish verified consequences from predictions.
Label predictions with their assumptions.

## Compare and recommend

Explain decisive tradeoffs instead of hiding them in a score.
Identify the strongest rejected option and why it lost when a recommendation is possible.
Recommend only when one option is materially stronger for the stated outcome.
Decline to recommend when evidence does not justify a ranking.
