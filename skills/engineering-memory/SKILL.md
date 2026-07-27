---
name: engineering-memory
description: >
  Apply whenever reading, writing, updating, retrieving, reconciling, promoting,
  or deleting persistent memory used across sessions, including CLAUDE.md,
  AGENTS.md, project memory, durable notes, engineering journals, decision logs,
  repository memory, and institutional knowledge stores. Preserve only knowledge
  that materially improves future engineering judgment. Treat memory as
  historical evidence rather than present truth. Prefer code, tests,
  configuration, documentation, and decision records over duplicate memory.
  Verify volatile or consequential memories before acting, resolve conflicts
  immediately, scope every rule correctly, and actively remove knowledge that
  has become stale, redundant, superseded, or enforceable elsewhere.
---

# Engineering Memory

Memory exists to improve future judgment.

It does not exist to preserve session history, duplicate the repository, archive
conversations, or collect facts that can be cheaply rediscovered.

Memory is cached understanding.

Reality is authoritative.

A healthy memory system becomes more accurate, more scoped, more useful, and
often smaller over time.

The required lifecycle is:

> Observe → Distill → Place → Persist → Retrieve → Verify → Apply → Promote,
> update, supersede, or forget.

## Memory Constitution

### Judgment over recall

The value of memory is not measured by how much it remembers. It is measured by
whether a future engineer makes a better decision because the memory existed.

Persist knowledge that improves technical judgment, architectural consistency,
operational safety, collaboration, debugging, migration decisions, review
quality, or avoidance of repeated mistakes.

Do not persist information merely because it may be useful someday.

### Reality over memory

A memory records what was believed, decided, or observed at a point in time. It
is not proof of the current state.

When memory conflicts with current evidence:

1. investigate the conflict
2. prefer the more authoritative and current source
3. correct, supersede, or delete the memory
4. do not leave the contradiction unresolved

Never let memory overrule easily available live evidence.

### Placement before persistence

Before storing knowledge in memory, decide where it belongs.

Prefer, when appropriate:

1. an enforced invariant in code, schema, permissions, or configuration
2. an automated test, lint rule, CI check, policy, or deployment guard
3. authoritative project documentation or a runbook
4. an architecture or decision record
5. an issue or investigation record for unresolved work
6. persistent memory

Memory is appropriate when the knowledge materially improves future judgment,
cannot be encoded more reliably elsewhere, would otherwise disappear, is
expensive or risky to rediscover, or must influence future work across sessions.

The best memory is often temporary scaffolding until the system itself encodes
the knowledge.

### Rationale over raw facts

Prefer preserving why something matters.

Weak memory:

> The worker retries three times.

Better memory:

> The queue worker already retries failed jobs. Adding application-level retries
> can duplicate non-idempotent operations.

A fact without its consequence is easy to misuse.

### Institutional knowledge over session history

Do not persist chronological session notes, conversation summaries, temporary
debugging state, command transcripts, abandoned ideas, routine repository
facts, or information already maintained authoritatively elsewhere.

Persist decisions and rationale, non-obvious constraints, durable lessons,
recurring failure modes, important exceptions, stable collaboration
preferences, corrections that should change future behaviour, and historical
context required to understand current choices.

### Scope before generalization

Every memory applies somewhere: global, organization, team, project,
repository, component, service, environment, workflow, or individual
collaborator.

Do not turn a repository-specific convention into a universal rule. Do not
apply one person's preference to everyone. Use the narrowest scope that
preserves the memory's value.

### Evidence before confidence

Confidence must come from evidence.

Do not store unresolved speculation as durable knowledge. Low-confidence ideas
belong in working notes, issues, investigations, experiments, or design drafts.

Durable memory should normally be supported by explicit human instruction, an
accepted engineering decision, direct repository or system inspection, repeated
verified observation, production incident analysis, authoritative platform
documentation, or an enforceable system artifact.

### Negative pressure

Memory has permanent cost: context usage, retrieval noise, verification burden,
contradiction risk, maintenance, scope confusion, stale guidance, and false
confidence.

Adding an entry should require justification. Deleting, merging, or promoting
an entry should be normal maintenance. Default to not storing.

### Proportional metadata

Not every memory needs a large schema. Use only the metadata needed to preserve
correct future interpretation.

Routine durable knowledge may need claim or rule, why, scope, trigger, source,
and date. Volatile, consequential, or exception-based knowledge may also need
evidence, confidence, revalidation condition, expiry or removal condition,
owner, supersedes, and related decision or artifact.

### Active forgetting

Forgetting is a core memory operation.

Delete, merge, archive, or supersede knowledge when it becomes derivable from
the system, code or automation now enforces it, documentation becomes
authoritative, the decision is reversed, the constraint disappears, the
technology changes, the memory duplicates another entry, the scope was wrong,
or the entry no longer affects decisions.

Keeping obsolete memory is not caution. It is negligence.

## 1. Determine the Memory Operation

Identify whether the task involves writing, retrieving, applying, correcting,
reconciling, promoting, pruning, deleting, session-start loading, or
restructuring persistent memory.

Reading old memory safely is as important as writing new memory well.

## 2. Classify the Knowledge

Classify the knowledge as one of:

- **Decision:** choice, context, rationale, alternatives, trade-offs, scope, and revisit conditions
- **Constraint:** limitation, reason, scope, consequence, and expiry condition
- **Lesson:** reusable conclusion, trigger, and failure avoided
- **Preference:** durable, correctly scoped collaboration preference
- **Exception:** normal rule, scoped deviation, justification, and removal condition
- **Invariant:** condition that must remain true; prefer enforcement outside memory
- **Historical context:** only when needed to explain current choices
- **Temporary state:** not durable unless transition history matters and expiry is explicit
- **Open question:** belongs in an issue, task, investigation, or design document

Do not allow uncertainty to harden into memory.

## 3. Apply the Persistence Gate

Before creating durable memory, establish:

- **Future value:** likely to improve a future decision or prevent repeated mistakes
- **Non-derivability:** not already obvious or cheaply recoverable from authoritative sources
- **Durability:** stable enough to survive the session, or explicitly revalidated
- **Evidence:** supported, not guessed
- **Scope:** narrow enough to avoid accidental generalization
- **Placement:** memory is better than code, automation, docs, ADR, issue, or runbook
- **Economics:** expected value exceeds context, verification, maintenance, contradiction, and privacy costs

If any material condition fails, do not persist the entry.

## 4. Choose the Correct Knowledge Location

Encode in code, schema, or configuration when the rule must always be enforced.
Encode in tests or automation when regression should fail automatically. Put
supported behaviour in project documentation, architectural choices in ADRs,
operational procedures in runbooks, unresolved work in issues or investigations,
and only the remaining judgment-improving context in persistent memory.

When memory identifies a systemic rule that should be enforced, promote it. Do
not let memory become a permanent substitute for engineering controls.

## 5. Distill the Entry

Do not copy raw conversations, logs, or long narratives into memory.

Distill the smallest reusable unit of knowledge. A good entry answers:

- What should be remembered?
- Why does it matter?
- When does it apply?
- What decision should it affect?
- What supports it?
- When should it be rechecked or removed?

Prefer one decision-bearing idea per entry.

## 6. Write the Memory

Use direct, human-readable language. State the rule or conclusion first,
explain why, name the trigger, and include proportional metadata.

### Minimal format

```markdown
## <Concise title>

**Scope:** <project, repository, component, person, workflow, or global>  
**Established:** <YYYY-MM-DD>  
**Source:** <human decision, repository inspection, incident, ADR, experiment>

<Decision, constraint, lesson, or preference.>

**Why:** <Rationale and consequence.>

**Use when:** <Trigger or situation where this should influence work.>
```

### Extended format

Use for volatile, high-consequence, exception-based, or frequently disputed
knowledge.

```markdown
## <Concise title>

**Type:** Decision | Constraint | Lesson | Preference | Exception | Context  
**Scope:** <narrowest valid scope>  
**Established:** <YYYY-MM-DD>  
**Source:** <specific provenance>  
**Evidence:** <artifact, observation, decision, or verified behaviour>  
**Confidence:** High | Medium  
**Volatility:** Stable | Slow-changing | Fast-changing  
**Owner:** <person or team, when relevant>  
**Supersedes:** <older entry or decision, when applicable>

<The durable knowledge.>

**Why:** <Rationale, trade-offs, or failure avoided.>

**Use when:** <Decision trigger.>

**Revalidate when:** <Version, architecture, ownership, deployment, or policy change.>

**Remove or promote when:** <Condition for deletion, enforcement, or stronger placement.>
```

Do not use Low confidence for durable memory. Investigate further or keep it in
temporary notes.

## 7. Calibrate Confidence and Volatility

Use **High confidence** for explicit durable human decisions, accepted ADRs,
enforced system artifacts, repeated verified observations, direct inspection of
current authoritative state, or confirmed production behaviour.

Use **Medium confidence** for one strong source or incomplete but useful context
with clear revalidation conditions. Medium-confidence memory must not drive
high-consequence actions without verification.

Classify volatility as stable, slow-changing, or fast-changing. Avoid durable
storage of fast-changing facts unless necessary, and verify before consequential
use.

## 8. Retrieve Selectively

Do not load all memory merely because it exists.

Retrieve only entries likely to affect the current task. Filter by scope,
trigger, component, decision type, objective, and consequence.

Before relying on an entry, determine relevance, scope, specificity,
supersession, volatility, intended action, and cost of being wrong.

Irrelevant memory consumes context and biases decisions.

## 9. Apply Source Precedence

Use this default authority order when sources disagree:

1. current explicit human instruction for the present task
2. current direct observation of the live system or environment
3. enforced system artifact such as code, schema, permissions, tests, or CI
4. current repository source and configuration
5. current authoritative documentation for the applicable version
6. accepted ADR, policy, or decision record
7. scoped persistent memory
8. reasoned inference
9. assumption

This order may vary by question. Distinguish intended, implemented, documented,
remembered, and live state instead of collapsing them into one answer.

## 10. Verify Before Consequential Use

Verification depth should depend on:

> consequence × volatility × uncertainty ÷ verification cost

Verify before acting when memory concerns current system state, the action is
destructive or difficult to reverse, security or data is involved, the memory
is fast-changing, confidence is medium, architecture changed, another source
disagrees, or verification is cheap.

State whether a claim came from memory or current verification when the
distinction matters.

## 11. Resolve Contradictions

When a new observation or entry conflicts with memory:

1. identify the conflicting claims
2. compare scope
3. compare authority
4. compare dates and volatility
5. distinguish intended from actual state
6. verify load-bearing facts
7. update, supersede, narrow, merge, or delete the stale entry
8. preserve history only when it still informs decisions

Do not create a second entry that merely disagrees with the first.

## 12. Promote Valuable Memory

When memory repeatedly influences important work, ask whether it should move to
code, schema, policy, tests, linting, CI, deployment guards, docs, ADRs,
runbooks, or onboarding guides.

After promotion, delete the duplicate memory or replace it with a short pointer
plus rationale when future judgment still benefits from the context.

Do not maintain two competing authoritative copies.

## 13. Prune and Forget

Review memory when adding related knowledge, finding contradictions, changing
architecture or ownership, upgrading major versions, learning from incidents,
adding documentation or automation, correcting entries repeatedly, or when the
store becomes hard to scan.

For each entry, choose: keep, clarify, narrow, merge, promote, supersede,
archive, or delete.

Delete stale, duplicated, derivable, unenforced, rationale-free, incorrectly
scoped, obsolete, contradicted, or unsafe-to-apply entries.

## 14. Protect Privacy and Sensitive Information

Never persist passwords, API keys, tokens, private keys, session cookies,
credentials, sensitive personal data, unnecessary private conversations,
confidential data outside its authorized store, speculative judgments about
people, ephemeral emotional observations, or security-sensitive infrastructure
details without approved reason and location.

A durable preference should describe how to collaborate, not profile the
person. Store the minimum information needed for the legitimate future purpose.

## 15. Session-Start Recall

When a session begins by loading old memory:

1. identify relevant entries
2. ignore unrelated entries
3. distinguish durable decisions from volatile state
4. check scope
5. identify superseded or contradictory entries
6. verify load-bearing fast-changing facts before acting
7. do not repeat memory to the user unless useful
8. do not treat memory as permission to skip repository inspection

Memory should accelerate orientation, not replace evidence gathering.

## 16. Human Corrections

Human corrections are high-value candidates, but not every correction should
be permanent.

Persist only when the correction reveals a durable preference, recurring
misunderstanding, project convention, decision principle, hidden constraint, or
likely recurring error. Distill the general lesson and verify that the
correction is intended to persist.

## 17. Memory Maintenance Gate

Before completing a memory task, check the affected scope for duplicates,
contradictions, stale volatile facts, unclear scope, missing rationale, expired
exceptions, promotable knowledge, sensitive information, and unresolved
hypotheses presented as facts.

Keep maintenance proportional; do not turn every write into a full audit.

## 18. Persistence Quality Gate

Before writing an entry, this statement must be defensible:

> This knowledge materially improves future judgment, is supported by evidence,
> belongs in persistent memory rather than a stronger artifact, is scoped
> correctly, preserves why it matters, includes proportional provenance and
> revalidation guidance, does not expose sensitive information, and is worth
> its long-term retrieval and maintenance cost.

If not, do not store it.

## 19. Retrieval Quality Gate

Before acting on remembered knowledge, this statement must be defensible:

> This memory is relevant to the current decision, applies to the current scope,
> has not been superseded, is sufficiently current and authoritative for the
> consequence of the action, and has been verified where volatility or risk
> requires it.

If not, verify, retrieve a more authoritative source, reduce the claim, ignore
it, or mark the decision unresolved.

## 20. Forgetting Quality Gate

Before retaining an entry during maintenance, this statement must be
defensible:

> This memory still changes future decisions, remains correctly scoped, is not
> more authoritatively encoded elsewhere, and provides more value than noise,
> verification burden, and contradiction risk.

If not, delete, merge, supersede, promote, or archive it.

## Memory Failure Conditions

The memory system fails when it stores session history instead of reusable
knowledge, duplicates repository facts without unique rationale, treats memory
as current truth, lets stale facts drive consequential actions, stores
unresolved hypotheses, applies local rules globally, persists temporary
requests as durable preferences, leaves contradictions unresolved, stores
secrets or unnecessary personal information, grows without pruning, relies on
memory for enforceable rules, maintains competing authoritative copies, stores
what happened without why it matters, loads irrelevant memory into every task,
confuses intended and live state, preserves expired exceptions, or retains
knowledge that no longer affects decisions.

## Ethical Standard

Do not optimize for remembering more.

Optimize for helping future humans and agents make better decisions with less
confusion.

Do not profile people. Do not hide uncertainty. Do not let remembered claims
outweigh current evidence. Do not preserve stale knowledge out of caution. Do
not use memory as a substitute for code, tests, documentation, policy, or human
judgment.

Remember deliberately. Verify proportionally. Forget actively.

## Final Test

Before persisting, retrieving, or retaining memory, be able to answer:

1. What future decision will this improve?
2. Why can it not be more reliably encoded elsewhere?
3. What type of knowledge is it?
4. What is its exact scope?
5. What evidence supports it?
6. Why does it matter?
7. When should it influence work?
8. How volatile is it?
9. What would require revalidation?
10. What would make it obsolete?
11. Does it conflict with existing knowledge?
12. Does it contain sensitive or unnecessary personal information?
13. Is its future value greater than its lifetime cost?

If any answer is missing for a material entry, do not treat the memory as ready.

The goal is not a memory store that knows everything.

The goal is a memory store that helps future engineers think better.
