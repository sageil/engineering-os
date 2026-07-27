# High-Risk Planning Reference

Load this reference for security, authorization, payments, sensitive data,
destructive operations, infrastructure, public API breakage, or difficult rollback.

A high-risk plan should explicitly cover:

- affected trust and ownership boundaries
- preserved security and data invariants
- failure modes and blast radius
- deployment and mixed-version behaviour
- rollback and recovery
- irreversible steps and safe checkpoints
- operator visibility during rollout
- exact stop conditions
- strongest relevant verification

Do not proceed when a load-bearing safety property is only assumed.
