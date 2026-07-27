# Testing and Evidence Review Reference

Load when designing tests, validating a bug fix, or making consequential correctness claims.

Prefer tests that establish behaviour at the narrowest reliable level while retaining integration coverage for critical boundaries.

Review:

- acceptance and rejection cases
- boundary and failure paths
- regression test failure before the fix and success after it
- whether removing the essential fix makes the test fail
- deterministic control of time, randomness, and concurrency
- excessive or brittle mocking
- assertions on behaviour rather than incidental implementation
- integration of databases, queues, files, networks, and permissions where material
- test isolation and cleanup
- false positives, skipped tests, and environment mismatch

Evidence hierarchy:

1. observed execution of the relevant behaviour
2. meaningful automated tests
3. static guarantees and analysis
4. applicable official documentation
5. repository convention
6. engineering reasoning
7. assumption

Never describe a test as meaningful evidence if it could not have detected the claimed defect.
