---
name: engineering-communication
description: >
  Transfer an accurate mental model to the intended audience with minimal
  ambiguity, cognitive load, and unsupported confidence.
---


# Engineering Communication

Writing is not documentation.

Writing is the transfer of understanding.

A document succeeds when the reader builds the correct mental model with the
least necessary effort.

The objective is not to sound professional.

The objective is not to sound intelligent.

The objective is not to sound like an AI trying not to sound like an AI.

The objective is to help another human understand, decide, build, operate,
debug, or use something correctly.

Every decision in this skill follows from that objective.

The communication lifecycle is:

> Understand the reader → determine the information they need → organize it in
> the order they will need it → write naturally → remove unnecessary cognitive
> load → verify the mental model → polish only what remains.

## Communication Constitution

### Truth before style

Style cannot rescue incorrect understanding.

Always optimize for the reader forming the correct mental model.

If a shorter sentence creates a wrong understanding, it is worse writing.

If a longer explanation prevents misunderstanding, it is better writing.

Correctness outranks elegance.

### Readers before authors

Write for what the reader needs.

Not for what the author knows.

Not for what the implementation happened to do.

Not for what feels complete.

Every paragraph should answer a question the reader actually has.

### Attention is a finite resource

Every sentence spends the reader's attention.

Every paragraph spends working memory.

Every section delays the answer they came for.

Every heading asks for another decision.

Nothing is free.

Every element must justify its cost.

### Understanding before completeness

Do not try to explain everything.

Explain what the intended reader needs to:

- make a decision
- perform an action
- understand a concept
- avoid a mistake
- recover from failure

Everything else is optional.

### Progressive disclosure

Readers need different information at different times.

Reveal complexity only when earlier understanding depends on it.

Prefer:

Quick start → Common tasks → Configuration → Troubleshooting → Architecture → Reference

Do not begin with architecture unless architecture is the reason the reader
opened the document.

### Concrete before abstract

Prefer actual behaviour over general description.

Prefer examples over definitions.

Prefer observable outcomes over implementation intent.

When possible, show.

Only explain after the reader has something concrete to anchor the explanation.

### Human before corporate

Write like an experienced engineer helping another engineer.

Not like marketing.

Not like legal.

Not like an academic paper.

Not like an LLM trying to sound helpful.

Natural writing has:

- uneven sentence lengths
- occasional short paragraphs
- contractions where appropriate
- direct statements
- concrete nouns
- active verbs
- understated confidence
- natural rhythm

It does not constantly announce what it is about to say.

### Evidence before confidence

State only what the document can support.

If something depends on version, configuration, deployment, environment, or
assumptions, say so.

Do not write with more certainty than the evidence allows.

### Simplicity before cleverness

Choose the explanation requiring the least interpretation.

Do not impress.

Do not entertain.

Do not optimize for elegance.

Optimize for immediate understanding.

## 1. Identify the Reader

Determine:

- who is reading
- what they already know
- what they need to know
- what they need to do
- what mistakes they are likely to make
- what they will probably search for

Do not write for everyone.

Write for the primary reader.

## 2. Identify the Reader's Goal

Determine why they opened the document.

Examples:

- install something
- fix something
- understand something
- review something
- operate something
- decide something
- use something
- migrate something
- design something

The first section should move them toward that goal immediately.

Do not begin with history, philosophy, or definitions.

Begin with progress.

## 3. Build the Information Hierarchy

Order information by dependency.

Readers should never need future information to understand the present section.

Prefer:

Goal → Prerequisites → Action → Verification → Explanation → Reference

Readers should understand more after every section than before it.

Never force them to reconstruct the intended order.

## 4. Draft Naturally

Write as though explaining the subject to a capable colleague.

Use:

> Run:

instead of:

> The following command may be used.

Use:

> Create a file named...

instead of:

> It is recommended that users create...

Prefer verbs.

Prefer concrete nouns.

Prefer examples.

Avoid unnecessary ceremony.

## 5. Remove AI Writing

The document should never sound generated.

Avoid AI habits.

### Do not announce the obvious

Avoid:

- This section explains...
- The following discusses...
- It is important to understand...
- As mentioned previously...
- Overall...
- In conclusion...
- Whether you are...
- This comprehensive guide...
- In today's...

There is no need to tell readers what they are already experiencing.

### Do not narrate structure

Avoid mechanical “First, second, finally” sequencing unless the order itself
matters.

Let headings provide structure.

### Avoid corporate filler

Avoid words like:

- robust
- powerful
- seamless
- cutting-edge
- enterprise-grade
- world-class
- next-generation
- best-in-class
- leverage
- utilize
- synergy
- comprehensive
- intuitive

When “use” is correct, do not write “utilize.”

When “works” is correct, do not write “provides robust functionality.”

### Remove empty transitions

Delete filler like:

- Furthermore
- Moreover
- Additionally
- It is worth noting
- Needless to say
- As you can see
- Generally speaking
- In many cases
- Simply
- Just

These rarely carry information.

### Avoid symmetrical writing

AI tends to produce balanced bullets, mirrored paragraphs, identical sentence
lengths, and perfectly repeated structures.

Allow rhythm to vary.

### Remove false balance

Do not qualify every statement.

Do not add caveats that do not change the reader's decision.

When something is true, say it.

When uncertainty matters, state the uncertainty precisely.

## 6. Reduce Cognitive Load

Ask:

> What is the reader thinking right now?

Then answer that.

Reduce:

- context switching
- forward references
- nested explanations
- unnecessary terminology
- multiple ideas per paragraph

Each paragraph should answer one question.

The first sentence should establish the point.

## 7. Challenge the Document

Before publishing, attack it.

Ask:

- If I knew nothing about this project, could I complete the task?
- Would I know why this exists?
- Would I know what success looks like?
- Would I know how to recover when something fails?
- What assumptions does this document make?
- Which important question remains unanswered?
- Where would I stop reading?
- Where would I become confused?
- Which section earns the least attention?

Delete or rewrite until the important questions are answered.

## 8. Remove the Author

Readers should not feel the author's effort, ego, excitement, or apology.

The document is about the reader's success.

## 9. Editing Pass

Every sentence must justify the reader's attention.

For every sentence ask:

- Does the reader need this?
- Does this create understanding?
- Does it repeat something?
- Can it be more concrete?
- Can it become an example?
- Can it move earlier?
- Can it disappear entirely?

Delete aggressively.

Keep facts.

Keep context.

Remove everything else.

## 10. Verify the Mental Model

After reading, can the intended reader correctly answer:

- What is this?
- Why would I use it?
- How do I start?
- What happens next?
- How do I know it worked?
- What breaks?
- How do I recover?
- What assumptions matter?

If not, the document is incomplete.

## 11. Document-Specific Guidance

Use the relevant file under `references/` when the task involves:

- README files
- PR descriptions
- ADRs and RFCs
- runbooks and troubleshooting
- migration guides
- API and developer documentation
- release notes and changelogs

The core principles remain mandatory even when a reference is loaded.

## 12. Final Communication Gate

Before publishing, this statement must be defensible:

> The intended reader can build the correct mental model, perform the intended
> action, avoid the important mistakes, recover from expected failure, and do so
> without unnecessary cognitive effort.

If not, rewrite.

Do not polish.

Rewrite.

## Failure Conditions

The document fails when it:

- sounds generated rather than written
- explains instead of communicating
- leads with background instead of outcomes
- wastes attention
- repeats itself
- hides important assumptions
- buries the action
- optimizes for completeness instead of usefulness
- uses corporate language instead of human language
- announces structure instead of creating it
- sounds more interested in appearing professional than helping the reader
- explains implementation before establishing purpose
- makes the reader work harder than necessary

## Final Test

The reader should finish thinking:

> I know exactly what this is, why it matters, what to do next, and what to do if
> something goes wrong.

They should never finish thinking:

> This sounds well written, but I am still not sure what I need to do.

## Capability handoff

Do not remain in this capability after its responsibility is complete. Use the
smallest next capability whose activation conditions are satisfied. Preserve the
evidence, assumptions, risks, and unresolved uncertainty produced here.

### Usually entered from

- documentation, proposals, ADRs, PR descriptions, reports, runbooks, or technical explanations

### Usually hands off to

- **Engineering Investigation** when claims lack sufficient grounding.
- **Engineering Decision** when writing exposes an unresolved choice.
- **Engineering Review** when accuracy or approval risk is material.
- **Engineering Memory** when durable institutional knowledge should be preserved.

At every handoff, identify the next capability, the artifact or evidence being
passed, the unresolved question or required outcome, and any stop condition that
must remain visible. Return to an earlier capability whenever new evidence
invalidates the current path.
