# Requirement Gap Checklists

Use only the section that matches the artifact under review.
Treat each item as a question about applicability, not a requirement to add content.

## Product or behavior specification

- Actor, capability, value, success outcome, and explicit exclusions.
- Preconditions, trigger, observable outcome, and one independently decidable result per rule.
- Happy, alternate, partial, failure, cancellation, retry, and recovery paths.
- Zero, one, many, empty, missing, duplicate, minimum, maximum, and overflow conditions.
- Actor and role differences, permission changes, impersonation, and service identities.
- Concurrent changes, idempotency, stale state, ordering, and interrupted workflows.
- Time zone, daylight-saving transition, locale, text expansion, right-to-left layout, number, date, and currency behavior.
- Performance, capacity, reliability, security, privacy, accessibility, audit, and observability outcomes when user or operator behavior depends on them.
- Definition of completion: built, deployed, enabled, observed, or accepted by a named owner.

## Acceptance criteria

- Each criterion identifies actor, precondition, trigger, and observable outcome.
- Each criterion has one outcome that can pass or fail independently.
- Words such as fast, seamless, intuitive, robust, clean, responsive, and works well have concrete behavior or measures.
- Every happy path has applicable validation, permission, dependency, timeout, concurrency, quota, offline, and stale-data outcomes.
- Boundaries cover empty, missing, minimum, maximum, very long, Unicode, whitespace, duplicate, zero, negative, large, and precision-sensitive values when applicable.
- Performance measures identify workload and percentile or bound.
- Accessibility behavior identifies keyboard, focus, name, role, state, error association, contrast, motion, and zoom requirements where applicable.
- Security and privacy behavior identifies authorization, rate limit, audit, retention, deletion, and personal-data visibility where applicable.
- Completion and production observation are explicit when test success alone is not the outcome.

## UI and journey states

- Initial, loading, empty, partial, success, validation error, authorization failure, not found, dependency failure, timeout, offline, stale, rate-limited, and read-only states.
- Shortest and longest content, zero or many items, missing media, broken media, Unicode, right-to-left, and text expansion.
- Hover, focus, active, selected, disabled, pending, optimistic, dragging, cancellation, and retry behavior.
- Mobile, tablet, desktop, narrow, wide, high zoom, reduced motion, high contrast, light, and dark presentation where supported.
- Accessible name, role, state, focus order, keyboard path, screen-reader announcement, touch target, error association, and non-color signaling.
- Back, forward, refresh, deep link, multi-tab, mid-session permission change, and underlying-record deletion.
- Create, edit, delete, confirm, undo, conflict, and recovery lifecycle.

## Cross-artifact checks

- A rule in one artifact has the same actor, state, vocabulary, and outcome in linked criteria and UI states.
- Every UI state maps to an accepted rule or is identified as a design proposal.
- Every criterion maps to a visible or externally observable result where one is required.
- Intentional deferrals are explicit and do not remove safety, authorization, integrity, or compatibility that must hold from the first release.
- Candidate domain terms are defined or parked rather than silently normalized.
- Historical notes and superseded drafts are not treated as current authority.
