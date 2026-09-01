# Agentic System Threat Analysis

Use this method when the scope includes models, prompts, retrieval, memory, agents, tools, delegated identities, generated content, or autonomous multi-step work.
Use current primary GenAI and agentic-security standards for version-sensitive taxonomy and control claims.

## Model the agentic execution path

Trace:

- system and developer instructions;
- user input and uploaded content;
- retrieved documents, search results, messages, and external responses;
- model and routing decisions;
- short-term context and durable memory;
- tool discovery, selection, arguments, identity, and effects;
- model output and downstream interpreters;
- iteration, delegation, retries, cancellation, and recovery; and
- logging, evaluation, feedback, training, and data-retention paths.

Classify every channel as instruction, trusted data, untrusted data, derived state, or executable effect.
Do not assume that placement in a prompt establishes trust.

## Authority and identity

Identify the human, service, tenant, agent, model, and tool identities present at each step.
Trace which identity authorizes each read, write, external call, durable memory change, or irreversible effect.

Check whether the agent can gain authority by selecting a tool, changing arguments, replaying prior context, following retrieved instructions, or delegating to another agent.
Check whether authorization is re-evaluated after delay, retry, memory recall, or privilege revocation.

Treat human confirmation as one possible control rather than a universal requirement.
Evaluate whether confirmation is informed, bound to the exact effect, resistant to misleading content, and required by the applicable authority policy.

## Credible threat paths

Consider only paths supported by the system model:

- direct or indirect instruction injection changes a protected decision or effect;
- untrusted retrieved or remembered content crosses into instruction authority;
- model output reaches code, query, shell, template, navigation, file, or external-effect sinks without a controlling boundary;
- a tool has broader identity, data scope, arguments, or effects than the task requires;
- delegated agents lose tenant, actor, approval, or policy context;
- durable memory creates cross-user leakage, persistence, poisoning, or unauthorized behavior;
- retrieval or embedding stores permit cross-tenant access, poisoning, stale authorization, or provenance loss;
- protected prompt, secret, personal, proprietary, or training data is disclosed;
- model, dataset, plugin, tool, package, or provider supply chains change without verified trust;
- iteration, fan-out, retries, context, tokens, or external effects can consume unbounded resources; and
- evaluation, monitoring, fallback, cancellation, or recovery cannot detect or contain unsafe outcomes.

Do not assign severity from the threat category alone.
Establish the authority gained, data or effect reached, persistence, blast radius, detectability, and recovery.

## Control evidence

Inspect actual instruction-data separation, provenance, input and output validation, tool schemas, allowlists, authorization, least privilege, sandboxing, tenant isolation, memory lifecycle, retrieval filters, rate and iteration bounds, approval binding, audit, anomaly detection, rollback, and kill controls.

Model output validation does not prevent the model from choosing an unauthorized goal.
Prompt instructions do not enforce tool authorization.
A sandbox limits some effects but does not establish data authority or business correctness.
An allowlisted tool can still accept unsafe arguments.

## Verification obligations

Define negative tests that exercise untrusted content at every applicable instruction and data boundary.
Test alternate tools, argument mutation, delayed and replayed work, revoked authority, cross-tenant retrieval and memory, downstream output sinks, iteration limits, cancellation, audit, and recovery.

Use synthetic protected data and bounded effects.
Do not test live destructive effects without separate authority.
