---
name: knowledge-promotion
description: >-
  Preserve verified, reusable engineering knowledge in the strongest appropriate durable
  artifact while preventing stale or unnecessary memory growth. Use only when the user
  explicitly requests durable knowledge capture for an accepted decision, completed
  incident learning, repeated verified failure pattern, or durable constraint. Prefer
  enforcement, tests, automation, documentation, ADRs, or runbooks before generic agent
  memory. Do not trigger automatically after another skill, for routine session summaries,
  temporary state, speculative lessons, or facts that are cheap to rediscover.
---

# Knowledge Promotion

## Contract

Improve future judgment without creating a stale parallel source of truth.
Distill verified learning and place it in the strongest artifact that can carry or enforce it.
Default to not persisting when future value is unclear.

Maintain one verdict:
- `promote`
- `record`
- `already-encoded`
- `do-not-store`
- `authority-required`

## 1. Identify the knowledge unit

State the smallest reusable decision, constraint, invariant, lesson, exception, or failure pattern.
Preserve why it matters, when it applies, what evidence supports it, and what future decision it should change.

Do not persist raw conversation, transcripts, abandoned ideas, or chronological session history.

## 2. Verify durability

Require:
- evidence or accepted human decision;
- narrow scope;
- future decision value;
- stability;
- explicit invalidation/revalidation condition;
- absence of unresolved contradiction;
- authorized and privacy-safe content.

For each candidate knowledge unit, answer:

> What future observation, version, ownership change, contract change, environment change, or date would make this knowledge unsafe to rely on?

If no meaningful invalidation condition can be stated for volatile knowledge, prefer not to store it.

When the lesson is still a hypothesis, return:
`Routing request: research-before-solution`

## 3. Select the strongest artifact

Read [artifact-placement.md](references/artifact-placement.md).

Prefer:
1. enforcement artifact;
2. detection artifact;
3. authoritative documentation;
4. ADR/decision record;
5. issue/investigation record;
6. scoped persistent memory.

Do not maintain duplicate authoritative copies.
A capture request authorizes placement analysis, not production enforcement changes.

## 4. Distill and write within authority

Record:
- conclusion or rule;
- scope;
- rationale and consequence;
- source evidence or decision;
- trigger for use;
- assumptions;
- invalidation signal;
- revalidation method;
- supersession/removal condition;
- owner when maintenance matters.

Use one decision-bearing idea per record.
Do not use low-confidence durable memory.

## 5. Reconcile existing knowledge

Search for duplicates, contradictions, stale guidance, superseded decisions, and stronger artifacts.
Compare scope, authority, date, version, and intended versus observed state.
Update, narrow, merge, supersede, promote, or delete rather than appending conflict.

Do not let memory overrule current observed reality.

## 6. Protect sensitive information

Store the minimum information needed for the legitimate future decision.
Do not persist secrets, credentials, session data, unnecessary personal data, or confidential infrastructure detail outside an approved location.

## 7. Apply the promotion gate

Choose `promote` or `record` only when:
- verified/decided;
- future value exceeds maintenance cost;
- scope is precise;
- placement is strongest available;
- provenance is sufficient;
- invalidation/revalidation is explicit where volatility exists;
- privacy and authority are satisfied;
- conflicting stale knowledge is resolved.

## Output

- Knowledge unit and scope
- Evidence or decision source
- Placement alternatives considered
- Selected artifact and rationale
- Invalidation signal and revalidation/removal condition
- Change made only when authorized
- `Knowledge verdict: promote | record | already-encoded | do-not-store | authority-required`

## Boundaries

Do not automatically create memory after tasks.
Do not use memory instead of repository inspection.
Do not store unresolved work as durable conclusion.
Do not implement production enforcement solely because durable capture was requested.
Do not write shared artifacts without authority.

## Failure conditions

Fail when session history becomes knowledge, speculation becomes fact, repository-specific guidance becomes global, sensitive data is persisted, stronger artifacts are ignored, duplicate truth sources are created, volatile knowledge lacks an invalidation path, stale knowledge is appended rather than reconciled, or a write occurs without authority.
