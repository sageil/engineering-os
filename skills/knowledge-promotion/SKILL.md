---
name: knowledge-promotion
description: Preserve verified, reusable engineering knowledge in the strongest appropriate durable artifact while preventing stale or unnecessary memory growth. Use only when the user explicitly requests durable knowledge capture for an accepted decision, completed incident learning, repeated verified failure pattern, or durable constraint. Select enforcement, tests, automation, documentation, ADRs, or runbooks before generic agent memory, but do not treat a capture request as authority to implement production code, schema, configuration, CI, monitoring, or test changes. Do not trigger automatically after another skill, for routine session summaries, temporary state, speculative lessons, or facts that are cheap to rediscover.
---

# Knowledge Promotion

## Contract

Improve future judgment without creating a stale parallel source of truth.
Distill verified learning and place it in the strongest artifact that can carry or enforce it.
Default to not persisting when future value is unclear.

Maintain one verdict:

- `promote`: Select the stronger artifact and create or update it only when that artifact class is explicitly authorized.
- `record`: Persist a scoped decision or lesson because no stronger artifact fits.
- `already-encoded`: Existing code, automation, documentation, or decision record is authoritative.
- `do-not-store`: Knowledge is temporary, speculative, sensitive, duplicated, cheap to rediscover, or not decision-useful.
- `authority-required`: The target artifact or shared knowledge store cannot be changed without permission.

## 1. Identify the knowledge unit

State the smallest reusable decision, constraint, invariant, lesson, exception, or failure pattern.
Preserve why it matters, when it applies, what evidence supports it, and what future decision it should change.
Do not persist raw conversation, command transcripts, abandoned ideas, or chronological session history.

## 2. Verify durability

Require:

- evidence or accepted human decision;
- narrow scope;
- future decision value;
- stability or revalidation condition;
- absence of unresolved contradiction;
- authorized and privacy-safe content.

When the lesson is still a hypothesis, stop and return `Routing request: research-before-solution` for a new routing decision.
Return `do-not-store` when knowledge cannot pass the durability gate.

## 3. Select the strongest artifact

Read [artifact-placement.md](references/artifact-placement.md) before writing.

Prefer in order when applicable:

1. Code, schema, permissions, types, or configuration that enforce the invariant.
2. Test, lint rule, CI check, deployment guard, or monitoring alert that detects violation.
3. Authoritative product, architecture, operational, or contributor documentation.
4. ADR or accepted decision record that preserves rationale and reversal conditions.
5. Issue or investigation record for unresolved future work.
6. Scoped persistent memory only when the knowledge cannot live more reliably elsewhere.

Do not maintain duplicate authoritative copies.
Replace old guidance with a pointer only when context still improves judgment.
A request to preserve knowledge authorizes placement analysis, not production enforcement changes.
When code, schema, permissions, configuration, tests, CI, deployment guards, monitors, or alerts are the strongest artifact but that artifact class was not explicitly authorized, return the proposed artifact and required authority without modifying it.

## 4. Distill and write within authority

Record:

- conclusion or rule;
- scope;
- rationale and consequence;
- source evidence or decision;
- trigger for use;
- assumptions;
- revalidation, supersession, or removal condition;
- owner when maintenance matters.

Use one decision-bearing idea per record.
Keep the language direct and human-readable.
Do not use low-confidence durable memory.

## 5. Reconcile existing knowledge

Search the target scope for duplicates, contradictions, stale guidance, superseded decisions, and stronger artifacts.
Compare scope, authority, date, version, and intended versus observed state.
Update, narrow, merge, supersede, promote, or delete rather than appending a conflicting entry.

Do not let memory overrule current observed reality.

## 6. Protect sensitive information

Do not persist credentials, tokens, private keys, session data, unnecessary personal data, confidential content outside its authorized store, speculative judgments about people, or sensitive infrastructure details without an approved purpose and location.
Store the minimum information needed for the legitimate future decision.

## 7. Apply the promotion gate

Choose `promote` or `record` only when:

- the knowledge is verified or explicitly decided;
- future value exceeds context and maintenance cost;
- scope is precise;
- placement is stronger than available alternatives;
- provenance and revalidation are sufficient;
- privacy and authority are satisfied;
- conflicting stale knowledge is resolved.

Do not write anything when the verdict is `do-not-store` or `authority-required`.

## Output

- Knowledge unit and scope
- Evidence or decision source
- Placement alternatives considered
- Selected artifact and rationale
- Revalidation or removal condition
- Change made only when authorized
- `Knowledge verdict: promote | record | already-encoded | do-not-store | authority-required`

## Boundaries

Do not automatically create memory after every task.
Do not use memory as a substitute for repository inspection.
Do not store unresolved work as a durable conclusion.
Do not implement production enforcement solely because the user requested knowledge capture.
Do not write to shared artifacts without user authority.

## Failure conditions

Fail the skill when session history is archived as knowledge, speculation becomes fact, repository-specific guidance becomes global, sensitive data is persisted, stronger artifacts are ignored, duplicate sources of truth are created, stale knowledge is appended instead of reconciled, or a write occurs without authority.
