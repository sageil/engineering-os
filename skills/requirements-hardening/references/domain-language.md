# Domain Language

Use this method when synonyms, overloaded terms, renames, or context-dependent vocabulary can change requirement meaning.
The goal is one explicit meaning inside the relevant bounded context, not one enterprise-wide glossary.

## Establish language authority

Identify the bounded context, accountable domain owner, current authoritative glossary or requirement artifact, and public contracts that use the term.
Do not create a parallel glossary when an owning artifact already exists.
Do not assume the same word has one meaning across different contexts.

## Record candidate terms

For each candidate, record:

- term and bounded context;
- proposed definition;
- concrete positive and counterexamples;
- synonyms or competing terms;
- terms it must not be confused with;
- affected rules, states, events, interfaces, and user language;
- accountable owner; and
- status: `candidate`, `accepted`, `parked`, `deprecated`, or `superseded`.

A candidate term is a proposal, not an accepted decision.
Silence is not approval and does not ban the term.

## Reconcile usage

Search the owning requirement and linked artifacts for contradictory definitions, hidden synonyms, and one term used for multiple states.
Preserve context-specific distinctions when they carry real meaning.
Do not normalize wording only for stylistic consistency.

When a public contract uses the term, identify compatibility, versioning, migration, and deprecation obligations before approving a rename.
Do not silently change externally consumed vocabulary.

## Confirm and preserve

Show the exact definition and affected requirement wording to the accountable owner.
Write only confirmed language when authorized.
Park unresolved language with owner, consequence, and review condition.

The requirements verdict cannot be `requirements-ready` when an unresolved term can materially change behavior, acceptance, authorization, state, or compatibility.
