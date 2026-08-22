# OAuth and OpenID Attack Tests

Use this reference to turn a failed or unknown control into an attacker path and a decisive negative test.

## Minimum attacker capabilities

Model applicable capabilities:

- a web attacker who controls sites, endpoints, clients, issuers, resources, browsers, and accounts;
- a network attacker on any hop not protected by authenticated cryptography;
- a reader of authorization responses through history, referrers, logs, mobile URI collision, or compromised endpoints;
- a reader of authorization requests, including a `plain` PKCE challenge;
- a holder of a stolen access or refresh token;
- deployment-specific insiders, XSS, SSRF, supply-chain compromise, key theft, tenant administration, or operational access.

State the attacker's starting access and limits.
Do not assume an attacker lacks a valid account or client.

## Decisive negative tests

### Redirect and callback

- Change redirect scheme, host, port, path, query, encoding, userinfo, fragment, sibling domain, and suffix.
- Exercise success, error, denial, silent, login-return, and logout-return redirects.
- Swap state, nonce, verifier, code, issuer, and browser session across concurrent transactions.
- Replay every one-time value.
- Require rejection before code exchange, token use, or session creation.

### PKCE and code lifecycle

- Redeem with missing, wrong, reused, or cross-client verifier.
- Supply a verifier for a code whose request had no challenge.
- Redeem a code twice and concurrently.
- Use the wrong client, redirect URI, issuer, or expired transaction.

### Issuer, metadata, and keys

- Start with issuer A and return issuer B.
- Substitute token endpoint, UserInfo endpoint, or key set across issuers.
- Return metadata whose issuer differs from the requested issuer.
- Attempt unsafe Discovery redirects and internal destinations.
- Use an attacker-controlled `jku`, `x5u`, key type, or algorithm.

### Access and refresh tokens

- Present a token to the wrong audience, endpoint, action, or token type.
- For sender constraint, omit proof, change key or certificate, change method or URI, use stale proof, and replay proof.
- Rotate refresh token R1 to R2, then replay R1 and require family or grant revocation.
- Attempt scope, resource, tenant, or role escalation on refresh.
- Distinguish client-only and user grants even when identifiers collide.

### Browser and proxy

- Load third-party content from authorization and callback pages and inspect referrer leakage.
- Attempt framing of login, authorization, consent, device, and error pages.
- Send `postMessage` from sibling, alternate scheme or port, `null`, and wildcard origins.
- Supply trusted forwarded, client-certificate, scheme, host, IP, and proof headers from the public side.
- Verify that direct access to the protected internal application path is blocked.

### Identity

- Reject ID Tokens with wrong issuer, key, algorithm, audience, authorized party, time, nonce, assurance, or flow hash.
- Reject UserInfo with absent or different subject.
- Reject account linking based only on a matching email or display identifier.
- Confirm that refresh does not satisfy a new authentication-age or step-up requirement.

## Safe test rules

- Test only systems, tenants, clients, and accounts within explicit authority.
- Prefer local, disposable, or dedicated test deployments and synthetic identities.
- Use fake token markers when cryptographic validity is not relevant.
- When real artifacts are required, minimize privilege and lifetime and redact all output.
- Do not place tokens, secrets, codes, cookies, keys, or customer identity data in prompts, fixtures, screenshots, issues, or reports.
- Do not revoke, rotate, or probe production by implication.
- A negative test passes only when the protected action fails closed before any durable or externally visible authorization effect.
