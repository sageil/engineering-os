# Testing Review Reference

Load when tests change or when verification quality determines merge safety.

Ask:

- Which invariant does each test establish?
- Does it exercise the changed path?
- Does it observe the real outcome?
- Can it fail for the target defect?
- Do mocks bypass the boundary under review?
- Are failure, concurrency, timing, ordering, and integration behaviours relevant?

For bug fixes, prefer evidence that fails before the fix and passes after it.
