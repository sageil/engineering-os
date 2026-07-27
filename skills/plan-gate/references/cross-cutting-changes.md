# Cross-Cutting Change Planning Reference

For work spanning multiple modules or owners:

- identify the source of truth for the affected invariant
- map callers, consumers, and compatibility commitments
- separate independently deployable changes
- define integration checkpoints
- avoid simultaneous broad refactors
- identify generated artifacts and their sources
- keep the diff reviewable
- establish which phase can be safely rolled back independently

Decompose by independently verifiable outcomes, not arbitrary file groups.
