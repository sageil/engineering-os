---
name: frontend-design
description: Design and implement a new or substantially changed visual direction for a product interface when layout, typography, color, imagery, motion, or copy need judgment.
---

# Frontend design

## Contract

Turn the user's product context into a working interface with a coherent visual system that is specific to the subject.
Distinctiveness comes from relevant design decisions, not from novelty alone.

Maintain one state:

- `framing`: Material product context or constraints remain unresolved.
- `direction-ready`: The visual direction and conserved constraints are explicit.
- `implementing`: The approved direction is being applied in code.
- `verifying`: The rendered interface is being inspected against the brief and constraints.
- `complete`: The interface is implemented and the available visual checks support the completion claim.
- `blocked`: Required context, authority, assets, or rendering access is unavailable.

Use this transition:

`framing -> direction-ready -> implementing -> verifying -> complete`

Return to `framing` when a new constraint could materially change the direction.
Resume interrupted work by rechecking the working tree, the selected direction, and the last verified rendered state.

## 1. Establish the design boundary

Inspect the user brief, repository instructions, current implementation, and directly affected interface before choosing a direction.
Inspect existing components, tokens, fonts, assets, brand rules, interaction patterns, and content when they can constrain the work.

Identify:

- the product or subject;
- the intended audience;
- the interface's primary job;
- required content and behavior;
- authoritative visual sources;
- existing design-system and brand constraints;
- the permitted change surface;
- technical, accessibility, performance, and asset constraints.

If a missing product rule or visual authority could materially change the result, ask for the smallest required decision.
Do not invent a client history, product identity, audience, or brand preference.
Use only context that belongs to the current task or an explicit relevant user preference.

Choose the applicable boundary:

- For a new interface, define a visual system from the subject and brief.
- For an existing product, extend its visual language unless the user explicitly requests a new one.
- For an authoritative mockup or reference, preserve its defining structure and appearance.

## 2. Select a visual direction

State a compact direction that connects the subject, audience, and interface job to concrete visual choices.
Define only the tokens and roles that the interface needs.
Do not require a fixed number of colors, typefaces, layout devices, or decorative elements.

Make each choice do a clear job:

- Use typography to establish hierarchy, voice, and reading rhythm.
- Use color to communicate hierarchy, state, emphasis, and brand identity.
- Use layout to express content relationships and task priority.
- Use imagery and icons when they add meaning or establish the subject.
- Use motion to explain state or strengthen a deliberate transition.
- Use one signature element only when it reinforces the brief.

Treat familiar design patterns as review signals, not forbidden styles.
A common pattern is acceptable when it is the best fit for the subject and constraints.
Reject decoration that could move unchanged to an unrelated product.

Review the direction before implementation.
Change any choice that conflicts with the brief, the existing product, or the interface's primary job.

## 3. Implement the interface

Read [accessibility.md](references/accessibility.md) when the interface includes interactive controls, forms, navigation, dynamic state, media, data visualization, complex layout, or another accessibility-relevant surface.

Follow the repository's established framework, component, styling, and asset conventions.
Reuse or extend existing components and tokens before creating parallel ones.
Keep product behavior outside the requested change stable.

Implement real interface states and content that are available from the brief or repository.
Include applicable loading, empty, error, disabled, success, and overflow states.
Do not hide missing content behind generic marketing copy or placeholder data.

Use semantic structure and native controls where practical.
Keep all interactions operable by keyboard.
Provide visible focus, sufficient contrast, clear labels, useful error messages, responsive reflow, and reduced-motion behavior.
Keep pointer targets usable and prevent fixed content from obscuring focused controls.

Do not add a dependency, download an asset, or introduce an external service without authority from the user or repository.
Do not change the product scope to support the visual concept.

## 4. Verify the rendered result

Render the interface in the available local environment.
Inspect the relevant narrow and wide layouts, important content states, and primary interactions.
Check hierarchy, alignment, spacing, overflow, legibility, focus order, focus visibility, and motion behavior.
Check the browser console when it is available.

Compare the rendered result with the brief, authoritative references, and conserved design-system rules.
Fix observed defects before returning `complete`.
If rendering is unavailable, return `blocked` and identify the smallest action needed to verify the interface.

## Output

Provide:

1. the implemented interface;
2. a concise statement of the selected visual direction;
3. the material design-system or brand constraints preserved;
4. the rendered states and layouts inspected;
5. unresolved limitations or unavailable checks;
6. `Frontend-design verdict: complete | blocked`.

## Boundaries

Do not use this skill for visual critique without implementation.
Do not turn a routine frontend correction into a redesign.
Do not replace an authoritative design because a different style appears more distinctive.
Do not select product strategy, business rules, architecture, or dependencies.
Do not expand a frontend request into unrelated backend work.
Do not treat interface copy as technical documentation.
Do not activate `testing` for the rendered inspection required by this skill.

## Failure conditions

Fail when the work invents material product context, discards an existing design system without authority, prioritizes novelty over usability, relies on unauthorized assets, changes behavior outside scope, or claims completion without rendered evidence.
