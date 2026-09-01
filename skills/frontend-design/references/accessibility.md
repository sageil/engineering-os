# Accessible Interface Design

Use this reference when the designed interface includes interactive controls, forms, navigation, dynamic state, media, data visualization, complex layout, or other accessibility-relevant behavior.
Use current applicable accessibility standards and platform guidance for normative claims.

## Semantics and structure

Use native elements and platform controls when they provide the required semantics and behavior.
Maintain a meaningful document or screen structure, reading order, landmark structure, heading hierarchy, and accessible name.
Use accessibility attributes only when native semantics do not express the required role, state, relationship, or live update.

Do not add a role without implementing its required keyboard and state behavior.
Do not hide a focusable or meaningful element from assistive technology.

## Keyboard and focus

Make every interactive outcome available without a pointer when the platform supports keyboard input.
Keep focus order consistent with the meaningful reading and interaction order.
Show a visible focus indicator and preserve it across themes and states.

For dialogs, menus, popovers, and other composite widgets, define initial focus, contained navigation when required, dismissal, and focus restoration.
Do not use positive tab order values to repair a structurally incorrect sequence.

## Names, instructions, errors, and status

Give controls stable programmatic names and expose their current value, state, validation, and relationship.
Associate instructions and error messages with the affected controls.
Make errors identifiable without color alone and provide a correction path.

Announce material asynchronous status changes without moving focus unexpectedly.
Do not announce routine or rapidly changing content so often that it obscures the task.

## Visual access

Use applicable contrast requirements for text, controls, focus, and meaningful graphics.
Do not encode status or meaning only through color, position, sound, or motion.
Support text resizing, zoom, narrow reflow, content expansion, and user font settings without loss of information or operation.

Keep content visible when focus, virtual keyboards, magnification, sticky regions, or safe areas change the viewport.
Use pointer targets and spacing appropriate to the platform and task.

## Motion, time, and media

Respect reduced-motion preferences and avoid motion that is required to understand or operate the interface.
Provide control over time limits, moving content, autoplay, and interruptions when applicable.
Provide applicable captions, transcripts, descriptions, and nonvisual alternatives for meaningful media and graphics.

## Verification

Inspect semantic and accessibility trees where available.
Exercise keyboard-only operation, focus order and restoration, names and states, error recovery, zoom or reflow, contrast, reduced motion, and relevant screen-reader paths.
Use automated checks for detectable rules, then manually verify behavior that tools cannot establish.

An automated zero-violation result does not prove accessibility.
A source-code pattern does not prove rendered semantics, focus behavior, contrast, or assistive-technology output.
