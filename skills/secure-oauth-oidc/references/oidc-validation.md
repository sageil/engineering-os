# OpenID Connect Validation

Use this reference for ID Tokens, UserInfo, Discovery, multi-issuer login, account binding, refresh continuity, and logout.

## Keep objects separate

| Object | Intended consumer and purpose | Never use as |
| --- | --- | --- |
| ID Token | Relying party authentication assertion. | API bearer token or general authorization decision. |
| Access token | Intended resource-server authorization credential. | Proof of browser login or substitute ID Token. |
| Authorization code | Token-endpoint one-time credential. | Identity or reusable session credential. |
| Refresh token | Authorization-server grant-continuation credential. | Resource-server credential or fresh authentication. |
| `state` | Callback correlation and CSRF binding. | Issuer validation, identity, or PKCE verifier. |
| PKCE | Authorization-code binding to a client instance. | Client authentication, issuer validation, or sender constraint. |
| `nonce` | ID Token binding to one authentication transaction. | Universal OAuth CSRF defense or public-client PKCE replacement. |

Request OIDC with the `openid` scope.
A pure OAuth response without an ID Token has not authenticated the user to the client.

## Bind the transaction before redirect

Store expected issuer, client ID, exact redirect URI, response type and mode, scopes and resources, state, nonce, PKCE verifier and challenge, creation and expiry time, and initiating session binding.

On callback, select this stored transaction before code exchange.
Do not select an issuer, token endpoint, key URL, or algorithm from untrusted response or token fields.

For multiple issuers:

1. bind the intended issuer to the initiating transaction;
2. validate response issuer identification before sending a code to any token endpoint;
3. require exact equality with the stored issuer;
4. use only endpoints, metadata, keys, and algorithms bound to that issuer.

## Keep one discovery trust chain

Require this equality chain:

```text
selected issuer
  = configuration-request issuer
  = metadata issuer
  = authorization-response issuer
  = ID Token issuer
```

Compare issuer strings exactly.
Do not normalize case, Unicode, paths, or trailing slashes.
Require HTTPS and block unsafe Discovery destinations when user input can influence issuer selection.
Never follow token-controlled `jku` or `x5u` locations.
Refresh keys only from the already trusted issuer metadata, with bounded frequency and safe rotation.

## Validate the ID Token atomically

Before any session, account link, UserInfo identity, access-token use, or protected request:

1. load the expected transaction, issuer, audience, algorithms, keys, nonce, and assurance policy;
2. parse JOSE headers and claims as attacker-controlled data;
3. decrypt only under negotiated algorithms and keys when encryption applies;
4. verify cryptographic protection with an allowed algorithm and expected issuer key;
5. require exact expected `iss`;
6. require valid `sub` and an `aud` containing the issuer-specific client ID;
7. validate `azp` when applicable;
8. require and validate `exp` and `iat`, plus `nbf` when used, under a documented clock policy;
9. require the transaction nonce when one was sent and enforce its replay policy;
10. enforce requested `max_age`, `auth_time`, `acr`, and essential claims;
11. validate `at_hash`, `c_hash`, JARM, and profile claims when required;
12. consume the transaction and create the session in one race-safe operation.

Discard all returned tokens on any failure.
Use a maintained OIDC validator configured with expected context.
Do not implement JOSE or key-selection cryptography from scratch.

## Subject and UserInfo

Bind the local federated identity to `(iss, sub)`.
Do not key accounts by email, phone, display name, username, or an unqualified `sub`.

Call only the validated issuer's UserInfo endpoint with an access token intended for it.
Require UserInfo `sub` to equal the validated ID Token `sub` exactly.
Discard the UserInfo response on mismatch.

Treat account linking and issuer migration as privileged workflows with explicit anti-takeover controls.

## Refresh and logout

Validate every new ID Token returned during refresh.
Require stable `iss`, `sub`, and complete audience from the original authentication.
Do not treat token refresh as fresh user authentication.

Local logout, OpenID Provider logout, refresh-token revocation, access-token expiry, and downstream session termination are separate events.
Apply only the exact logout and session specifications in use and test each promised effect.

## Required negative cases

Reject wrong, missing, replayed, expired, cross-session, or concurrently reused transaction values.
Reject wrong issuer, endpoint, key source, algorithm, token type, audience, authorized party, time, nonce, flow hash, UserInfo subject, and refresh continuity.
Assert atomic failure: no session, account link, token cache, protected request, or authenticated UI state exists after rejection.
