# Architecture Model

## Boundaries and ownership

For every component, identify the responsibility, owned state, authority, callers, dependencies, deployment unit, operator, and removal owner.
Treat ambiguous ownership as an architectural risk when failure or change would require coordination.
Prefer boundaries that align authority with responsibility.

## State and consistency

Identify each source of truth, derived copy, cache, index, replica, event, and durable workflow state.
State who can write, how conflicts resolve, what ordering is guaranteed, and how stale or duplicate data is detected.
Do not hide consistency decisions behind the word eventual.

## Failure model

Consider crash, timeout, partial response, duplication, reordering, corruption, overload, dependency unavailability, version skew, credential failure, and operator error when relevant.
Trace whether failure is isolated, amplified, delayed, retried, masked, or reported as success.
Identify recovery authority and evidence of restored integrity.

## Feedback and second-order effects

Map feedback loops, delays, backpressure, incentives, adaptive behavior, and pressure accumulation.
Ask which obligation appears if adoption succeeds.
Check whether retries amplify load, queues conceal overload, caches create invalidation systems, metrics distort behavior, or automation removes human visibility.

## Security and trust

Identify identities, trust transitions, authorization decisions, sensitive data flows, secrets, isolation, and auditability.
Keep authentication, authorization, validation, and encryption as distinct controls.
Place enforcement at the boundary that owns the protected resource.

## Operability

Require signals that distinguish healthy, degraded, and failed states.
Identify configuration ownership, capacity limits, deployment control, rollback or roll-forward, diagnostics, on-call burden, and recovery procedures.
An option that cannot be diagnosed or recovered is not operationally complete.

## Evolution

Evaluate current-to-target states, compatibility windows, mixed versions, data transitions, and cleanup.
Name the condition under which the option should be simplified, replaced, split, merged, or removed.
Preserve an exit path before dependence makes exit impractical.
