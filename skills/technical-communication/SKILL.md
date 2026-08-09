---
name: technical-communication
description: Create or substantially rewrite a technical artifact or coordinated documentation set so a defined human audience can accurately understand, decide, act, or recover using verified source material. Use only when the user explicitly requests a README, feature or configuration guide, in-product help, runbook, ADR, RFC, migration guide, API documentation, release note, decision memo, substantial technical explanation, or translation of complex technical material into human language. Preserve exact commands, identifiers, domain distinctions, constraints, and uncertainty while reducing avoidable jargon, duplication, and cognitive load. Do not use for ordinary conversation, short status updates, simple proofreading, code comments, implementation, technical research, correctness or security review, active incident communication, operational-readiness assessment, deciding whether knowledge should be stored, or document layout and file-format work.
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

Never trade accuracy for simplicity, usefulness for completeness, or visible uncertainty for polished prose.

Maintain one verdict:

- `ready`: The artifact is accurate, usable, appropriately detailed, and supported.
- `ready-with-unknowns`: The artifact is usable, and visible non-blocking unknowns cannot cause an incorrect action.
- `source-incomplete`: Missing evidence blocks a load-bearing claim, instruction, or decision.
- `source-conflict`: Available sources disagree in a way that could change understanding or action.
- `not-applicable`: The request does not require this skill's distinctive method.

## 1. Establish the communication brief

Identify:

- the artifact or documentation set;
- the primary reader and what they already know;
- what they must understand, decide, or do;
- the consequence of misunderstanding;
- the authoritative source material;
- the required format, voice, terminology, and length;
- the files and product surfaces in scope;
- material assumptions and unknowns.

Choose one primary reader.
Serve secondary readers through progressive disclosure instead of compromising the primary path.
Infer only low-risk context that cannot materially change the artifact.
Request missing information only when different answers would produce materially different communication.

## 2. Establish evidence and coverage

Inspect the owning sources before drafting consequential claims.
Separate observed behavior, documented behavior, accepted decisions, supported inference, and unresolved uncertainty.
Do not treat existing prose as proof.

For a documentation-set revision, inspect the relevant user-visible surfaces, such as:

- interface routes, labels, controls, and in-product help;
- APIs and command-line entry points;
- settings, defaults, validation, and capability catalogs;
- deployment, migration, operations, permissions, states, and failure handling;
- supported formats and focused tests or examples that define observable behavior.

Build a working coverage map:

> Reader job | feature or claim | authoritative evidence | canonical document | entry points that should link to it

Mark omissions, stale claims, contradictions, and repeated explanations before editing.
Use the map as an editing aid, not mandatory output.

Preserve exact commands, flags, configuration keys, API names, UI labels, error messages, versions, security boundaries, and domain distinctions.
Do not invent facts, examples, compatibility claims, outcomes, or recovery steps.
Do not smooth over conflicting sources.

Return `source-incomplete` when missing evidence could make the reader act incorrectly.
Return `source-conflict` when inspection cannot resolve an authoritative disagreement.

## 3. Design the reader's path

Use the reader's dominant job as the document spine.

For action:

> Outcome -> prerequisites -> action -> verification -> failure and recovery -> reference

For a decision:

> Decision -> recommendation -> evidence -> tradeoffs -> risks and unknowns -> next action

For understanding:

> Direct answer -> working mental model -> example -> boundaries -> implications

For adopting a change:

> What changed -> who is affected -> required action -> timing -> verification -> rollback or recovery

Use only the sections that improve the reader's result.
Place background where the reader first needs it.
Do not require architecture knowledge before the immediate outcome is clear.

### Coordinate a documentation set

Give each document one dominant job.
Use overviews for orientation, procedures for action, references for exact mappings, and explanations for mechanisms and boundaries.
Do not make every document repeat all four forms.

Keep each exact command sequence, provider matrix, default table, recovery procedure, or detailed mechanism in one canonical location within the authorized set.
Elsewhere, state the reader-specific consequence briefly and link to that location with a descriptive label.
Retain enough local context for the link to make sense.
Keep prerequisites, warnings, and recovery guidance next to the action they constrain even when details live elsewhere.
Update, consolidate, or delete stale prose instead of appending another version.

## 4. Explain AI behavior through progressive disclosure

For an AI-assisted feature, explain applicable information in this order:

> Reader outcome -> evidence used -> scope and exclusions -> prerequisites and privacy -> normal behavior and controls -> limits, fallback, failure, and recovery -> necessary internals

Separate application guarantees from model behavior and provider variability.
Treat scores, predictions, generated summaries, and automated checks as advisory unless verified behavior makes them authoritative.
Do not imply that an AI score proves correctness, generated text is source evidence, or local software remains private when a configured endpoint is remote.

Use a compact comparison table when request types or modes follow different exact rules.
Do not lead with model metadata, cache lifetime, runner behavior, or token calculations when the reader first needs scope and prerequisites.

## 5. Write for human understanding

Lead with the answer, outcome, decision, or required action.
Use direct sentences, concrete nouns, active verbs, and one main idea per paragraph.
Name the actor responsible for an action and make causal relationships explicit.
Use outcome-led headings, lists for choices or steps, and tables for repeated-field comparisons.

Prefer ordinary words when they preserve the full meaning.
Retain a technical term when it is an exact interface name, preserves a necessary distinction, is required for search or troubleshooting, or is the most precise expression.
Define an unfamiliar necessary term where the reader first needs it, then use it consistently.
Never rename identifiers, states, commands, types, or errors to sound accessible.

For mixed audiences, give the plain-language conclusion first and the exact technical detail immediately after it.
Show a verified example early when it reduces abstraction.
Place explanation after an action unless it is required for safe execution.

Use descriptive link text.
Do not identify interface elements only by color, position, shape, or direction.
Do not use analogies that hide limitations or claims that work is simple, easy, obvious, or intuitive.

Remove ceremonial introductions, repeated conclusions, unsupported corporate claims, inflated adjectives, mechanical transitions, irrelevant caveats, and process narration that does not help the reader.

## 6. Make action and decision safety explicit

For an action, include the prerequisites, exact action, expected observable result, success check, likely failure signals, and safe recovery or escalation.
Place warnings next to the constrained step.
Do not report success through an internal event when the reader needs an external outcome.

For a decision, include the decision, decision rule, material alternatives, tradeoffs, risks, assumptions that could reverse the recommendation, and next responsible action.

## 7. Challenge and validate the artifact

Review from the reader's starting knowledge.
Find the first point where the reader needs missing context, then move, define, demonstrate, or remove the obstruction.
Confirm that the reader can identify the purpose, required action or decision, prerequisites, success signal, failure modes, recovery, and material constraints.

For a documentation set, confirm that:

- every verified in-scope feature has a deliberate home;
- each document still serves its reader and dominant job;
- repeated procedures, matrices, defaults, and mechanisms have one canonical explanation;
- cross-references explain why their destination is useful;
- commands, labels, settings, capabilities, defaults, versions, and examples match owning sources;
- local links, anchors, and fragment targets resolve;
- no stale roadmap, compatibility, privacy, or correctness claim remains.

Run authorized, repository-specific documentation checks when available.
Keep verification proportional, such as link, anchor, fragment, spelling, generated-reference, rendered-structure, or diff checks.
Do not substitute unrelated implementation tests for documentation evidence.

Delete a sentence when its removal does not change the reader's action, decision, mental model, risk awareness, or recovery ability.
Do not force uniform sentence lengths or symmetrical sections.

Set `ready` only when load-bearing claims are supported, the reader path is usable, necessary terms are clear, success and recovery are observable, assumptions are visible, canonical content does not diverge, and checkable links and examples are valid.
Set `ready-with-unknowns` only when every remaining unknown is visible and non-blocking.
Correct the truth boundary or reader path before polishing an artifact that fails this gate.

## Output

Return:

1. The completed artifact
2. The intended reader and reader outcome
3. The source, coverage, and documentation checks performed
4. Material assumptions, unknowns, or source conflicts
5. Unsupported claims deliberately excluded
6. `Communication verdict: ready | ready-with-unknowns | source-incomplete | source-conflict | not-applicable`

Keep the supporting note brief unless the user requests editorial reasoning.

## Boundaries

Do not treat rewriting as correctness evidence, choose an architecture, resolve an engineering decision, approve security or launch risk, or command an active incident.
Within an authorized documentation set, reorganize and consolidate content only for the requested reader outcomes.
Do not decide whether new knowledge deserves durable preservation, select its artifact class, or implement code, tests, configuration, or infrastructure.
Do not activate another skill for a substep.

When another unresolved responsibility blocks accurate communication, return a routing request with only the missing question, relevant evidence, constraints, and resume condition.

## Failure conditions

Fail the skill when it:

- invents facts or presents assumptions as established behavior;
- removes a load-bearing distinction, warning, fallback, privacy boundary, or uncertainty;
- paraphrases an exact command, identifier, state, or error;
- uses vague language in place of necessary terminology;
- relies only on existing prose and misses verified product behavior;
- creates duplicate authoritative-looking content that can diverge;
- separates required context or recovery from the constrained action;
- presents AI-generated content or advisory scores as proof;
- omits observable verification or recovery from a consequential procedure;
- optimizes for sounding professional instead of helping the reader succeed.
