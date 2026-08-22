---
name: requirements-hardening
description: >-
  Create or tighten an authoritative product or behavior requirement artifact when the
  user explicitly requests specification, acceptance criteria, example mapping, gap
  analysis, or pre-implementation requirement review. Use for fuzzy intent or existing
  stories, specifications, acceptance criteria, and UI state requirements. Do not use
  for story splitting, implementation planning, code review, implementation acceptance,
  architecture selection, or requirements whose accountable owner is unavailable.
---

# Requirements Hardening

## Contract

Turn intent into explicit, testable behavior without inventing product decisions.
The conversation establishes the decisions.
The artifact preserves them.

Use one mode:

- `discovery`: intent exists but agreed rules and examples do not;
- `audit`: an existing requirement artifact needs gaps, contradictions, or unverifiable wording resolved.

Maintain one verdict:

- `requirements-ready`
- `needs-decisions`
- `blocked`

## 1. Establish authority and artifact home

Identify:

- accountable decision owner;
- actor and intended outcome;
- current source-of-truth artifact or the approved location for a new artifact;
- affected surfaces and accepted linked decisions;
- known exclusions, release constraints, and risk-relevant perspectives;
- authority to write confirmed updates.

Do not create a parallel source of truth silently.
When write authority is absent, return proposed updates in the response and do not mutate the artifact.

If the accountable owner cannot be identified for a material product decision, return `blocked` or park the decision with its required owner.

## 2. Build or read the requirement map

In `discovery` mode, maintain a structured map:

```text
outcome: <actor, capability, and value>
rules:
  - rule: <one business or behavior rule in domain language>
    examples:
      - <concrete precondition, trigger, and observable outcome>
    questions:
      - <material unresolved decision>
cross-cutting questions:
candidate terms:
exclusions:
```

Ask one material question at a time.
Recommend an answer only when evidence or established tradeoffs justify it.
Otherwise ask neutrally and do not anchor the owner to invented options.

In `audit` mode, map each existing normative statement, example, question, exclusion, and linked surface before finding gaps.
Do not rewrite before you understand the current meaning.

When synonyms, overloaded terms, renames, or context-dependent vocabulary can change requirement meaning, read [domain-language.md](references/domain-language.md).
Keep candidate terms separate from accepted language.

## 3. Challenge rules and examples

For every rule, test:

- counterexample: what condition would change the outcome;
- zero, one, many, minimum, maximum, and boundary behavior;
- invalid input, permission failure, dependency failure, timeout, retry, concurrency, and stale state when applicable;
- actors, roles, locale, time, accessibility, privacy, security, observability, and recovery where they can change the required behavior;
- success, partial, empty, loading, error, cancellation, and interrupted states for user journeys;
- whether the wording has one observable outcome and can be verified without a follow-up question.

Read [gap-checklists.md](references/gap-checklists.md) for the artifact type under review.
Do not apply every checklist item when it cannot change this requirement.

## 4. Triage only material gaps

Classify each supported gap:

- `blocking`: implementation cannot proceed responsibly or will likely implement the wrong behavior;
- `should-address`: omission creates credible rework, defect, or unverifiable completion;
- `optional`: bounded improvement that does not prevent the current requirement from being used.

Do not manufacture gaps or promote taste into a requirement.
An evidence-backed clean audit is valid.

Before asking, state the artifact sections reviewed, gap counts by class, and the highest-impact unresolved area.

## 5. Close gaps interactively

For each blocking and should-address gap:

1. state one gap and its consequence;
2. ask one concrete owner decision, or a tightly related pair only when separation would lose meaning;
3. refine vague answers until the outcome is observable;
4. draft the exact artifact update in the owner's vocabulary;
5. show the proposed update and obtain confirmation;
6. write only the confirmed update when authorized;
7. record contradictions created or resolved.

Park an unresolved decision with owner, consequence, and review date.
Do not claim it is closed.

## 6. Apply the readiness gate

Set `requirements-ready` only when:

- actor, outcome, authority, and source artifact are explicit;
- each material rule has concrete examples and survived counterexample review;
- blocking and should-address gaps are resolved or explicitly parked with owners and consequences;
- acceptance wording is observable and independently decidable;
- material roles, failures, boundaries, state changes, and quality constraints are explicit;
- contradictions across linked requirements and UI states are resolved;
- candidate terms and exclusions are visible;
- every term that can materially change behavior is accepted or parked with an accountable owner and consequence;
- no unresolved decision can materially change the required behavior.

Set `needs-decisions` when owner decisions remain but useful requirements work can continue.
Set `blocked` when authority or a load-bearing source is unavailable.

## Output

Report:

1. source artifact, authority, mode, scope, and exclusions;
2. requirement map or mapped existing criteria;
3. supported gaps and resolution state;
4. confirmed artifact updates or proposed updates when write authority is absent;
5. parked decisions with owners, consequences, and dates;
6. candidate domain terms;
7. `Requirements verdict: requirements-ready | needs-decisions | blocked`.

## Boundaries

Use `story-splitting` after the behavior is clear but the outcome is too broad.
Use `acceptance-review` after implementation to prove the authoritative criteria.
Use `research-before-solution` for unresolved engineering mechanisms or architecture.
Use `execution-planning` only after a solution is selected and hazardous transition planning is requested.
Do not turn database, service, API, UI, and tests into separate product requirements.

## Failure conditions

Fail when owner decisions are invented, a questionnaire replaces a conversation, vague answers remain unverifiable, confirmed decisions are not preserved, unconfirmed text is written, an empty gap list is manufactured into criticism, a parked blocker is called resolved, or the skill starts splitting, solution design, planning, code review, or implementation.
