---
name: technical-communication
description: >-
  Create or substantially rewrite a technical artifact or coordinated documentation set
  so a defined human audience can accurately understand, decide, act, or recover using
  verified source material. Use only when the user explicitly requests a README, feature
  or configuration guide, in-product help, runbook, ADR, RFC, migration guide, API
  documentation, release note, decision memo, substantial technical explanation, or
  translation of complex technical material into human language. Do not use for ordinary
  conversation, short status updates, simple proofreading, implementation, technical
  research, correctness/security review, active incident communication, operational
  readiness, knowledge-placement decisions, or document layout/file-format work.
---

# Technical Communication

## Contract

Enable the primary reader to form an accurate mental model and complete the intended action or decision with the least necessary effort.
For a documentation set, give each reader task and substantive topic one clear home.

Optimize in this order:
1. Truth
2. Reader outcome
3. Clarity
4. Brevity
5. Tone

Never trade accuracy for simplicity or visible uncertainty for polished prose.

Maintain one verdict:
- `ready`
- `ready-with-unknowns`
- `source-incomplete`
- `source-conflict`
- `not-applicable`

## 1. Establish the communication brief

Identify artifact/set, primary reader, reader outcome, consequence of misunderstanding, authoritative sources, required format/voice/terminology/length, in-scope surfaces, and material unknowns.

Choose one primary reader.
Serve secondary readers through progressive disclosure.
Infer only low-risk context that cannot materially change the artifact.

## 2. Establish evidence, provenance, and coverage

Inspect owning sources before drafting consequential claims.
Separate observed behavior, documented behavior, accepted decisions, supported inference, and unresolved uncertainty.
Do not treat existing prose as proof.

For volatile claims such as provider capabilities, versions, defaults, supported platforms, commands, limits, generated references, and operational procedures, record:
- owning source;
- applicable version/environment;
- evidence date or release applicability when relevant;
- condition that would require revalidation.

Build a working coverage map:
`Reader job | claim/action | authoritative evidence | canonical document | revalidation trigger | entry points`

Preserve exact commands, flags, configuration keys, API names, UI labels, errors, versions, security boundaries, and domain distinctions.

Return `source-incomplete` when missing evidence could make the reader act incorrectly.
Return `source-conflict` when authoritative disagreement cannot be resolved.

## 3. Design the reader path

For action:
`Outcome -> prerequisites -> action -> verification -> failure/recovery -> reference`

For decision:
`Decision -> recommendation -> evidence -> tradeoffs -> risks/unknowns -> next action`

For understanding:
`Direct answer -> mental model -> example -> boundaries -> implications`

For adopting change:
`What changed -> who is affected -> required action -> timing -> verification -> rollback/recovery`

Coordinate documentation sets so each exact procedure, matrix, default table, recovery sequence, or detailed mechanism has one canonical home.

## 4. Explain AI-assisted behavior carefully

Separate application guarantees from model behavior and provider variability.
Treat scores, predictions, generated summaries, and automated checks as advisory unless verified behavior makes them authoritative.
Do not imply generated text is source evidence or remote processing is local/private.

## 5. Write for human understanding

Lead with the answer, outcome, decision, or required action.
Use direct sentences, concrete nouns, active verbs, and one main idea per paragraph.
Retain technical terms when they preserve exact interfaces or necessary distinctions.
Never rename identifiers, states, commands, types, or errors to sound accessible.

Use verified examples early when they reduce abstraction.

## 6. Make action and decision safety explicit

For an action, include prerequisites, exact action, expected observable result, success check, likely failure signals, and safe recovery/escalation.

For a decision, include decision rule, material alternatives, tradeoffs, risks, assumptions that could reverse the recommendation, and next responsible action.

For volatile operational instructions, make the revalidation trigger visible enough that stale instructions are not silently reused.

## 7. Challenge and validate the artifact

Review from the reader's starting knowledge.
Confirm purpose, action/decision, prerequisites, success signal, failure modes, recovery, material constraints, and source freshness.

For a documentation set, verify canonical ownership, commands, labels, settings, capabilities, defaults, versions, examples, links/anchors, and removal of stale claims.

Run authorized repository documentation checks when available.

Set `ready` only when load-bearing claims are supported and any volatile claim has sufficient provenance to remain trustworthy for the intended use.
Set `ready-with-unknowns` only when every remaining unknown is visible and non-blocking.

## Output

1. Completed artifact
2. Intended reader and outcome
3. Source, coverage, freshness, and documentation checks
4. Material assumptions, unknowns, or source conflicts
5. Unsupported claims deliberately excluded
6. `Communication verdict: ready | ready-with-unknowns | source-incomplete | source-conflict | not-applicable`

## Boundaries

Do not treat rewriting as correctness evidence, choose architecture, resolve engineering decisions, approve security/launch risk, command an active incident, decide durable knowledge placement, or implement engineering changes.

When another unresolved responsibility blocks accurate communication, return a routing request with only the missing question, relevant evidence, constraints, and resume condition.

## Failure conditions

Fail when prose is treated as evidence, exact identifiers are casually renamed, volatile claims lack applicable provenance, stale source material is polished rather than corrected, source conflict is hidden, generated content is presented as authoritative evidence, or communication work silently resolves an engineering decision.
