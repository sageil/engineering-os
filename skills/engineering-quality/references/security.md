# Security Review Reference

Load for work involving authentication, authorization, untrusted input, secrets, sensitive data, multi-tenancy, files, network access, cryptography, or dependencies.

Evaluate the actual trust boundaries and abuse cases. At minimum, consider:

- authentication versus authorization
- object- and tenant-level access control
- server-side enforcement
- input validation, injection, and unsafe deserialization
- secrets in code, configuration, logs, errors, and telemetry
- least privilege and credential scope
- insecure defaults and fail-open behaviour
- file uploads, paths, redirects, outbound requests, and SSRF
- browser-origin concerns such as XSS and CSRF when applicable
- dependency provenance, maintenance, advisories, and update path
- replay, idempotency, rate limits, and abuse controls
- auditability of sensitive actions

Prefer established platform cryptography and identity mechanisms. Do not invent cryptographic protocols.

Verification should include negative authorization cases and attempts to cross trust or tenant boundaries.
