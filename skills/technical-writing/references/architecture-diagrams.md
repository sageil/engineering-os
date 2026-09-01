# Architecture Diagrams

Read this reference only when an architecture diagram is part of the requested technical document.
Do not create a diagram only to decorate prose that already answers the reader's question.

## Define the reader question

State the primary reader and the one question that the diagram must answer.
Choose the smallest view that answers that question:

- a context view for people and external systems;
- a container or component view for ownership and runtime boundaries;
- a sequence view for ordered interactions, retries, and failure paths;
- a data-flow view for stores, transformations, and trust transitions;
- a state view for lifecycle and durable transitions;
- a deployment view for processes, infrastructure, zones, and failure domains.

Split the diagram when one view mixes several reader questions.

## Build from verified facts

Use the same names as the code, configuration, interfaces, and accepted records.
Show a boundary only when evidence identifies its type, such as ownership, trust, transaction, deployment, runtime failure, or data authority.
Label an edge with its direction and interaction only when the protocol, delivery behavior, or dependency is known.
Mark inferred, proposed, and unverified elements explicitly.
Do not turn an inferred relationship into a verified one through visual certainty.

## Keep the visual precise

Use one meaning for each shape, line, color, and arrow style.
Include a legend when the notation is not self-explanatory.
Show the normal path and only the failure or recovery paths needed for the reader question.
Avoid crossed edges, unlabeled bidirectional arrows, decorative vendor icons, and generic boxes such as `service` or `database` when the exact identity is known.
Keep a text alternative that states the important relationships and unknowns.

## Verify the result

Compare every node, edge, boundary, and label with the source evidence.
Render the diagram and inspect its reading order, labels, contrast, and legibility at the expected display size.
Update or remove a diagram when the source of truth changes.
