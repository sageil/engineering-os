---
name: technical-writing
description: >-
  Apply a layered technical-writing standard based on Diátaxis, Google developer
  style, Simplified Technical English, and Global English. Use only when the user
  explicitly requests creation or review of technical documentation, an RFC, a
  README, a pull request description, or a commit message. Do not use for ordinary
  replies, product UI strings, technical research, correctness review, implementation,
  or document layout and file-format work.
---

# Technical writing

The goal is writing a tired engineer understands on the first read.
Four layers get you there, one question each: what kind of document is this, how do sentences address the reader, how much does each sentence carry, and can any sentence be read two ways.
Apply all four.

Three rules sit above the layers:

- **Cut every word that does no work.** If the sentence survives without a word, the word goes. "In order to" is "to". "It is important to note that" is nothing.
- **Use the short, everyday word.** "Use", not "utilize". "Help", not "facilitate". "Do", not "perform". A long word has to buy its length with precision.
- **When a rule makes a sentence worse, fix the sentence another way or leave it alone.** The rules serve the reader. A sentence that follows every rule and sounds like a machine wrote it has failed.

The codebase is the word list.
Write the real symbol, file, flag, or command name, not a synonym or a description of it.

Do not invent jargon.
Use the words a developer would say out loud: "move", "delete", "a budget that only decreases", not "evacuate", "ratchet", or "endgame".
A named pattern is fine when the document says what it means the first time.
Add new repeated offenders and their replacements to the global communication policy.

## Vary the rhythm

The layers decide what a document says and how much each sentence carries.
A document can obey all of them and still read as machine-written: every sentence clipped short, no view anywhere, and nothing specific.

- Mix sentence lengths on purpose. Short sentences land a point. Longer sentences carry a fact with its condition or consequence.
- One thought per sentence does not mean one length per sentence. Split the sentence that carries two thoughts. Keep the long sentence that carries one.
- Have a view where the mode allows it. Explanation weighs trade-offs, so state the judgment instead of only listing pros and cons. Reference stays dry.
- Be specific over sterile. Not "schema changes can cause issues" but "a column rename fails the build".

## Pick the mode first (Diátaxis)

One document has one mode.
Two questions select it: does the content inform action or understanding, and does it serve learning or work?

- Action and learning: **tutorial**.
- Action and work: **how-to**.
- Understanding and work: **reference**.
- Understanding and learning: **explanation**.

Use the compass on a whole document or on one sentence.
Use it whenever the correct mode is not clear.
Gut feel is often wrong here.

**Tutorial: learning by doing.** You are the teacher. The learner's success is your job, not theirs. Open by saying what the learner will build, not what they will "learn". Every step produces a visible result, early and often. Tell them what they should see: the expected output, the prompt change, or the log line. Cut explanation to one clause and a link. Teaching pauses break the lesson. Stay concrete. Write as "we", in commands: "First, do x. Now, do y."

**How-to: steps to a goal.** Solve a problem a person has, not an operation the machine can perform. Assume competence. Skip teaching. Keep only action, without digressions, background, or completeness for its own sake. Link those instead. Allow forks and judgment: "If you want x, do y." Name the guide by the task: "How to calibrate the radar array", not "Radar array calibration".

**Reference: facts for lookup.** Describe only. Do not instruct, persuade, or give an opinion. State facts, options, limits, and errors without unsupported hedging. Mirror the structure of the thing described so that code and documentation can be navigated together. Put material where readers expect it. Generate from code where possible so that it stays true.

**Explanation: understanding and why.** Cover one bounded topic that can be read away from the product. Each title must tolerate an implicit "About" in front. Anchor the document on a real why question. Give context about design decisions, history, constraints, and alternatives. Opinion is allowed here and nowhere else.

Do not mix modes.
Do not put reference tables inside a tutorial, tutorial hand-holding inside reference, or arguments inside a how-to.
Split and link instead.

Source: diataxis.fr, fetched 2026-07-18.

## Write sentences to the reader (Google developer style)

- Talk to the reader as "you", in the present tense. Use "will" only for things that genuinely happen later.
- Say who does what: "the compiler checks", not "is checked". Passive is fine only when the actor is unknown or beside the point.
- Write instructions as commands: "Click Submit." State facts plainly. Never write "should be done".
- Put the condition before the instruction: "To delete the document, click Delete." The reader can skip what does not apply.
- Put the common case first. Put exceptions after it.
- Sound like a knowledgeable friend. Do not use buzzwords, figurative language, or "please" in instructions. Never use "simply", "easy", or "quickly" in a procedure.
- Do not pre-announce future support, and do not start consecutive sentences with the same phrase.
- Read an awkward sentence aloud. If it stays awkward, rewrite it.
- Link with words that state where the link goes, such as the page title or a short description. Never write "click here". Prefer a sentence of context on the page over a link away from it.
- Headings carry the point, not only the topic. Use sentence case. A task heading is a bare verb phrase. A concept heading is a noun phrase. Use one h1 per page and do not skip levels.
- Use numbered lists for sequences and bullets for other lists. Introduce a list with a complete sentence. Keep items parallel.
- Put code in code font and user-interface elements in bold. Use serial commas. Do not write "etc.". State that a list is partial when necessary.

Source: developers.google.com/style, fetched 2026-07-18.

## Make statements load one at a time (STE rules)

- Write one instruction per sentence and one thought per sentence elsewhere.
- Split instructions longer than about 20 words and other sentences longer than about 25 words.
- Put the warning or condition before the step that it controls: "If hot oil touches your skin, injuries can occur."
- Keep "the" and "a": "Remove backup file" has two meanings. "Remove the backup file" has one.
- Give each word one meaning and one job, then keep it. If "check" means inspect, do not also use it for restrain.
- Pick one word per action and keep it: "start", not "start" in one place and "initiate" in another.
- Write procedures as direct commands, never as narration or in the passive: "Install the component", not "the component must be installed".
- Avoid "-ing" words where possible. They have many grammatical jobs and can cause ambiguity.

Source: asd-ste100.org (Issue 9, 2025), fetched 2026-07-18. The numbered rules and dictionary are in the specification PDF. The principles above are the transferable core.

## Leave no sentence open to two readings (Global English)

- Keep words such as "only" and "not" next to the word that they change: "only fails on growth" and "fails only on growth" have different meanings.
- Break up long noun strings: "the proto import budget check script" becomes "the script that checks the proto-import budget".
- Make every "it", "they", and "this" point at one clear thing. Repeat the noun when in doubt. Never use "this" or "which" to point at a whole clause.
- Do not drop verbs: "Phase 1 moves the converters and Phase 2 the runtime" leaves Phase 2 without a verb. Give it one.
- Keep the small words that show structure. "Ensure that the switch is off" keeps "that" because it makes the sentence parse one way. Never trade clarity for word count.
- Repeat the article in a series when it prevents ambiguity: "the client and the host", not "the client and host", when they are two things.
- State which parts "and" or "or" joins when a sentence can group two ways. "Both...and", "either...or", and "if...then" remove ambiguity.
- Use periods, not semicolons. Replace a long dash with a new sentence.
- Make text in parentheses a full grammatical unit or its own sentence. Never form plurals with "(s)".
- Do not use slashes. Write "a, b, or both" instead of "a/b" or "and/or".
- Call each thing by one name everywhere. A document that calls one thing "the gate", "the ratchet", and "the budget check" teaches three things. Do not reword unchanged sentences between edits.
- Skip idioms, colloquialisms, Latin abbreviations, and metaphors. A non-native reader, a translator, and an agent all parse plain constructions best.

Source: Kohl, The Global English Style Guide (SAS Press). Guideline text fetched from the Internet Archive and the SAS sample chapter, 2026-07-18.

## Voice and repository specifics

- Apply the global communication policy to every document that this skill touches. The global policy owns AI vocabulary, filler, hedging, and formatting rules.
- Pull request descriptions and commit messages are writing. Every layer except Diátaxis applies to them.
- Product user-interface strings are not documentation. Use the product's copy guidelines for those.
- Indent code snippets with tabs. Write real paths and real symbols. Make every count or tree claim true at the commit that contains it, and include the command that regenerates it.

## Worked example

Before:

> Configuration of the proto import ratchet budget script parameters is performed via budget.json. Note that it's important to remember that running with --write, which updates the committed budget to reflect the current count, should only be done when lowering it. If exceeded, CI fails.

After:

> `budget.mjs` reads the committed budget from `budget.json` and counts the files that import protos. If the count exceeds the budget, CI fails. Run `budget.mjs --write` only to lower the budget.

The fixes, by layer: "configuration is performed" becomes "`budget.mjs` reads", so someone does something (Google). "Ratchet" goes away. The script's real filename does the naming (jargon rule). The five-noun string breaks up into plain clauses (Global English). The hedge "note that it's important to remember" is deleted because it does no work. The failure condition moves ahead of the step that it explains (STE).
The buried "should only be done when lowering" becomes a command with "only" next to its verb (STE). "If exceeded" gets a subject: the count (Global English).

## Review checklist

Apply this checklist to any prose that this skill covers.
Item 1 applies only to document sets.

1. Is each file one Diátaxis mode, with links where modes meet?
2. Is every instruction written as a command, with its condition in front?
3. Does any sentence carry two instructions or two thoughts? Split it.
4. Can any word be cut without losing meaning? Cut it.
5. Is "only" next to the word that it changes? Does every "it" point at one thing? Does every clause keep its verb?
6. Does each thing have exactly one name across the documents?
7. Would a developer say these words aloud? Replace invented metaphors and fancy synonyms with the plain word or the real symbol name.
8. Are all symbols, paths, and counts real at this commit, with the commands that regenerate the counts?
