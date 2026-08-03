---
name: technical-communication
description: Create or substantially rewrite technical communication so a defined human audience can accurately understand, decide, act, or recover using verified source material. Use only when the user explicitly requests a README, technical guide, runbook, ADR, RFC, migration guide, API documentation, release note, decision memo, substantial technical explanation, or translation of complex technical material into human language. Preserve exact commands, identifiers, domain distinctions, constraints, and uncertainty while reducing avoidable jargon and cognitive load. Do not use for ordinary conversation, short status updates, simple proofreading, code comments, implementation, technical research, correctness or security review, active incident communication, operational-readiness assessment, deciding what knowledge should be stored, or document layout and file-format work.
---

# Technical Communication

## Contract

Enable the intended reader to form an accurate mental model and complete the intended action or decision with the least necessary effort.

Optimize in this order:

1. Truth
2. Reader outcome
3. Clarity
4. Brevity
5. Tone

Never trade accuracy for simplicity.
Never trade usefulness for completeness.
Never use polished prose to conceal missing evidence.

Maintain one verdict:

- `ready`: The artifact is accurate, usable, appropriately detailed, and supported by the available sources.
- `ready-with-unknowns`: The artifact is usable, and its non-blocking unknowns or assumptions are visible.
- `source-incomplete`: Missing evidence prevents accurate communication of a load-bearing claim, instruction, or decision.
- `source-conflict`: Available sources disagree in a way that could change the reader's understanding or action.
- `not-applicable`: The request does not require the distinctive communication method owned by this skill.

## 1. Establish the communication brief

Identify:

- the artifact being created or revised;
- the primary reader;
- what the reader already knows;
- what the reader must understand, decide, or do;
- the consequence of misunderstanding;
- the authoritative source material;
- required format, voice, terminology, and length;
- material assumptions and unknowns.

Choose one primary reader.
Serve secondary readers through progressive disclosure rather than compromising the primary path.

Infer obvious context when the assumption is low-risk and would not materially change the artifact.
State material assumptions.
Request missing information only when different answers would produce materially different communication.

## 2. Establish the truth boundary

Inspect the available source material before drafting consequential claims.

Separate:

- observed behavior;
- documented behavior;
- accepted decisions;
- supported inference;
- unresolved uncertainty.

Preserve exact commands, flags, configuration keys, API names, error messages, version constraints, security boundaries, and domain distinctions.

Do not invent missing facts, examples, compatibility claims, outcomes, or recovery steps.
Do not resolve contradictory sources through smoother wording.

Return `source-incomplete` when a missing fact could make the reader take an incorrect action.
Return `source-conflict` when authoritative sources disagree and the conflict cannot be resolved through inspection.

## 3. Design the reader's path

Choose the structure that matches the reader's dominant job.

For action:

> Outcome -> prerequisites -> action -> verification -> failure and recovery -> reference

For a decision:

> Decision -> recommendation -> evidence -> material tradeoffs -> risks and unknowns -> next action

For understanding:

> Direct answer -> working mental model -> concrete example -> important boundaries -> implications

For adopting a change:

> What changed -> who is affected -> required action -> timing -> verification -> rollback or recovery

Use the selected path as a spine, not a mandatory template.
Include only sections that improve the reader's result.

Place background where the reader first needs it.
Do not make readers study architecture before they can understand the immediate outcome.
Do not force readers to reconstruct the intended order from scattered details.

## 4. Calibrate technical language

Prefer an ordinary word when it preserves the full meaning.

Retain the technical term when it is:

- the exact name of an interface or system element;
- necessary to preserve a domain distinction;
- a term the reader must recognize elsewhere;
- the most precise available expression;
- required for effective searching or troubleshooting.

Define an unfamiliar term where the reader first needs it.
Use the term consistently after defining it.

For example:

> The service is idempotent: repeating the same request produces the same final state instead of creating another record.

Do not replace precise terminology with vague language merely to sound accessible.
Do not rename identifiers, commands, types, states, or error messages.

Avoid:

- unexplained abbreviations;
- stacked technical nouns;
- unnecessary implementation detail;
- abstract descriptions where a concrete example would be clearer;
- analogies that hide an important limitation;
- claims that something is simple, easy, obvious, or intuitive.

Explain a mechanism only when it changes the reader's action, decision, interpretation, or recovery path.

For mixed audiences, provide a plain-language conclusion first and the exact technical detail immediately after it.

## 5. Draft for human understanding

Lead with the answer, outcome, decision, or required action.

Use direct sentences, concrete nouns, and active verbs.
Name the actor responsible for an action.
Keep one main idea in each paragraph.
Make causal relationships explicit.
Use headings that tell the reader what they will obtain or accomplish.

Prefer:

> Run the migration before starting the new application version.

Instead of:

> It should be noted that execution of the migration process is required prior to application startup.

Prefer:

> The request failed because the token expired.

Instead of:

> The request encountered an authentication-related failure condition.

Show a verified example early when it reduces abstraction.
Place explanation after the action unless the explanation is required to perform the action safely.

Remove:

- ceremonial introductions;
- statements about what the document will discuss;
- repeated conclusions;
- corporate claims without evidence;
- inflated adjectives;
- mechanical transitions;
- caveats that do not change the reader's behavior;
- process narration that does not help the reader.

Judge language by function rather than by a fixed word blacklist.
Keep a specialized word when it earns its place.
Delete an ordinary word when it does not.

## 6. Make action and recovery explicit

When the artifact asks the reader to act, include:

- required prerequisites;
- the exact action;
- the expected observable result;
- a way to verify success;
- likely failure signals;
- safe recovery or escalation guidance.

Place warnings next to the action they constrain.
Do not bury required conditions in background sections.

When the artifact supports a decision, include:

- the decision being made;
- the decision rule;
- material alternatives;
- meaningful tradeoffs;
- assumptions that could reverse the recommendation;
- the next responsible action.

Do not report success using an internal event when the reader needs an externally observable outcome.

## 7. Challenge the artifact

Review the artifact from the reader's starting knowledge, not the author's.

Confirm that the reader can answer:

- What is this?
- Why does it matter to me?
- What should I do or decide?
- What must already be true?
- How do I know it worked?
- What could fail?
- How do I recover or escalate?
- Which assumptions or constraints matter?

Find the first point where the reader would need information they have not yet received.
Move, define, demonstrate, or remove the obstruction.

Check every technical term.
Define it, retain it as known audience vocabulary, or replace it with a more direct expression.

Check every factual claim against the available sources.
Remove unsupported confidence.

Delete a sentence when its removal does not change the reader's action, decision, mental model, risk awareness, or recovery ability.

Do not force uniform sentence lengths, symmetrical sections, or identical bullet structures.
Let the subject determine the shape of the writing.

## 8. Apply the communication gate

Set `ready` only when:

- load-bearing claims are supported;
- the primary reader and intended result are clear;
- the information appears in the reader's order of need;
- technical detail is precise but not gratuitous;
- unfamiliar necessary terminology is explained;
- required actions and decisions are unambiguous;
- success is observable;
- relevant failure and recovery paths are present;
- material assumptions and limitations are visible;
- no paragraph makes the reader work without a corresponding benefit.

Set `ready-with-unknowns` only when the remaining unknowns are visible and cannot cause the reader to take an incorrect action.

Do not polish an artifact that fails the gate.
Correct its truth boundary, reader path, or explanation.

## Output

Return:

1. The completed artifact
2. The intended reader and reader outcome
3. Material assumptions, unknowns, or source conflicts
4. Unsupported claims deliberately excluded
5. `Communication verdict: ready | ready-with-unknowns | source-incomplete | source-conflict | not-applicable`

Keep the supporting note brief unless the user requests an editorial explanation.

## Boundaries

Do not treat rewriting as evidence that a technical claim is correct.
Do not choose an architecture or resolve an engineering decision.
Do not implement code, configuration, infrastructure, or documentation storage policy.
Do not approve security, correctness, launch readiness, or operational risk.
Do not decide whether knowledge deserves durable preservation.
Do not command communication during an active incident.
Do not activate another skill for a substep of this responsibility.

Return a routing request when a different unresolved responsibility prevents accurate communication.
Pass only the exact missing question, relevant evidence, material constraints, and the condition required to resume.

## Failure conditions

Fail the skill when:

- invented facts make the prose appear complete;
- simplification removes a load-bearing distinction;
- jargon is replaced with vague language;
- unexplained terminology blocks the intended reader;
- background delays the answer without improving safety;
- exact commands or identifiers are paraphrased;
- required warnings are separated from the constrained action;
- examples contradict the actual interface;
- assumptions are presented as established facts;
- a reader cannot verify success;
- recovery guidance is omitted from a consequential procedure;
- polished language conceals uncertainty;
- the document optimizes for sounding professional rather than helping the reader succeed.
