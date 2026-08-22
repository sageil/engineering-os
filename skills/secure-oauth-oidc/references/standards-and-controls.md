# OAuth and OpenID Standards and Controls

Use current primary standards to determine what is required.
Vendor defaults, library examples, blog posts, and model recall do not override a stable specification, best current practice, or applicable profile.

## Source precedence

Apply sources in this order:

1. applicable regulation or ecosystem profile, with exact version and jurisdiction;
2. stable protocol specification, best current practice, updates, and errata;
3. platform best current practice;
4. interoperability or conformance profile;
5. exact-version library documentation for implementation evidence;
6. secondary material only for explanation or discovery.

When sources appear to conflict, check publication status, applicability, normative references, updates, obsoletes, and errata.
Do not resolve the conflict from memory.

## Stable baseline

- [RFC 9700 / BCP 240](https://www.rfc-editor.org/info/rfc9700/) is the OAuth 2.0 security best current practice.
- [RFC 6749](https://www.rfc-editor.org/info/rfc6749/) defines the OAuth 2.0 framework and remains subject to RFC 9700 updates.
- [RFC 6750](https://www.rfc-editor.org/info/rfc6750/) defines bearer-token use and error behavior.
- [RFC 7636](https://www.rfc-editor.org/info/rfc7636/) defines PKCE.
- [RFC 8252 / BCP 212](https://www.rfc-editor.org/info/rfc8252/) applies to native applications.
- [RFC 8414](https://www.rfc-editor.org/info/rfc8414/) defines authorization-server metadata.
- [RFC 8725 / BCP 225](https://www.rfc-editor.org/info/rfc8725/) defines JWT security practices.
- [RFC 8705](https://www.rfc-editor.org/info/rfc8705/) defines mutual-TLS client authentication and certificate-bound tokens.
- [RFC 9449](https://www.rfc-editor.org/info/rfc9449/) defines DPoP.
- [RFC 8707](https://www.rfc-editor.org/info/rfc8707/) defines resource indicators.
- [RFC 9207](https://www.rfc-editor.org/info/rfc9207/) defines issuer identification in authorization responses.
- [OpenID Connect Core 1.0, Errata Set 2](https://openid.net/specs/openid-connect-core-1_0.html) defines OIDC identity semantics and validation.
- [OpenID Connect Discovery 1.0, Errata Set 2](https://openid.net/specs/openid-connect-discovery-1_0.html) defines issuer metadata discovery.
- [FAPI 2.0 Security Profile Final](https://openid.net/specs/fapi-security-profile-2_0-final.html) applies only when that complete high-security confidential-client profile is selected.

OAuth 2.1 remains an active Internet-Draft until the official IETF Datatracker shows a published RFC.
Treat it as work in progress and use RFC 9700 as the stable security baseline.

For every high-stakes review, record the source URL, publication status, exact version, and access date.

## Requirement strength

- `MUST`, `MUST NOT`, and `REQUIRED` are violations when applicable behavior contradicts them.
- `SHOULD`, `SHOULD NOT`, and `RECOMMENDED` require implementation or a documented context-specific reason with compensating controls and residual risk.
- `MAY` permits an option and does not prove that the option is secure.

Normative strength and exploit severity are separate.
Apply severity from the evidenced attack path, assets, reachability, blast radius, detectability, and recovery.

## RFC 9700 control baseline

### Redirect and authorization

- Compare supplied redirect URIs to registered URIs with exact string matching.
- Permit only the RFC 8252 native localhost loopback-port exception.
- Do not expose an open redirector at a client or authorization server.
- Prevent callback CSRF with a one-time transaction binding whose guarantees are established.
- Bind multi-issuer authorization to the selected issuer and validate response issuer before code exchange.
- Do not send authorization responses over unencrypted transport except the defined native loopback case.
- Do not use HTTP 307 after a credential-bearing form submission.
- Do not enable CORS at the authorization endpoint.

### Authorization code and PKCE

- Public authorization-code clients must use PKCE.
- Authorization servers must support PKCE and enforce the verifier for a recorded challenge.
- Prefer PKCE for confidential code clients unless an applicable profile establishes another safe binding.
- Use a transaction-specific verifier and `S256` challenge.
- Reject a verifier when the original authorization request had no challenge.
- Make authorization codes short-lived and single-use.
- Treat a second redemption as a compromise signal and apply the required descendant-token response.

### Tokens and resources

- Do not use the resource-owner-password-credentials grant.
- Avoid front-channel access-token issuance unless every specified injection and leakage risk has evidenced mitigation.
- Never put access tokens in URI query parameters.
- Restrict access tokens to the intended resource and minimum privilege.
- Require every resource server to reject a token not intended for it.
- Prefer sender-constrained access tokens with DPoP or mTLS when architecture permits.
- For public clients, sender-constrain refresh tokens or rotate them with family reuse detection.
- Bind refresh tokens to the consented scope and resources and expire them after a defined inactivity period.

### Deployment

- Publish and consume validated metadata when available.
- Sanitize attacker-supplied security headers at a trusted TLS-terminating proxy.
- Protect and authenticate the proxy-to-application hop.
- Prevent framing of authorization, authentication, consent, device, and error pages.
- Use exact registered `postMessage` target and sender origins and never use a wildcard.
- Keep tokens, codes, credentials, keys, and personal claims out of logs, traces, URLs, errors, analytics, and fixtures.

## Applicability traps

- Exact redirect matching is not origin matching or URI normalization.
- A loopback-port exception does not permit wildcard hosts, paths, schemes, or browser clients.
- PKCE metadata support is not PKCE enforcement.
- Confidential client authentication does not prevent code injection by itself.
- OIDC `nonce` is not a general pure-OAuth defense or a public-client replacement for PKCE.
- A `cnf` claim or DPoP token type without resource-server proof validation is not sender constraint.
- Refresh replacement without retained family and reuse state is not replay detection.
- Selected FAPI controls do not establish FAPI conformance.
