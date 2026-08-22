# Existing Solution Evaluation

Use this method when the unresolved decision introduces, replaces, or materially expands a generic dependency, framework, tool, service, platform primitive, or custom subsystem.

This reference operates inside `research-before-solution`.
It does not create a second active skill or bypass the research gate.

## 1. Define the job before candidates

State the observable job, users, operators, lifetime, scale, criticality, reversibility, and hard constraints.
Separate solution-neutral needs from the vocabulary of an attractive product.

Define a bespoke baseline that is real enough to compare:

- behavior and guarantees it must provide;
- code and integration surface;
- upgrade, security, test, operation, support, and exit ownership;
- constraints that could make it smaller or safer than adoption.

Do not assume either reuse or bespoke work wins.

## 2. Inspect local and built-in capability first

Inspect manifests, lockfiles, configuration, nearby code, accepted decisions, platform services, and existing owners.

Check, in order:

1. existing repository capability;
2. language standard library or open standard;
3. current framework, runtime, browser, database, operating system, or platform primitive;
4. dependency or service already owned by the team;
5. new maintained library, tool, application, or service;
6. bespoke implementation.

Existing local code does not win by default.
Verify fit, support, coherence, and lifecycle condition.

## 3. Gather current primary evidence

Treat versions, support windows, maintenance, security status, price, license, and provider policy as volatile.
Verify them from current primary sources.

Record the exact version or tier, evidence date, source, limitation, and decision effect.
Prefer official documentation, source repositories, package registries, standards, security advisories, license files, service terms, and reproducible benchmarks.

Popularity, marketing, stars, download counts, and generated comparison pages can identify candidates.
They cannot select one.

If live evidence for a load-bearing claim is unavailable, return to the research verdict and stop at `blocked` or `insufficient-evidence` as applicable.

## 4. Apply hard gates

Reject a candidate when current evidence shows that it fails a required constraint, such as:

- incompatible runtime, framework, protocol, data, or deployment model;
- unacceptable security, privacy, residency, or compliance behavior;
- license or procurement incompatibility;
- unsupported required feature or scale;
- unacceptable maintenance or support state;
- missing operational authority;
- no responsible migration or exit path.

Do not spend detailed comparison effort on a rejected candidate.

## 5. Compare total ownership

Compare only viable candidates against the bespoke baseline.
Use dimensions that can change the decision:

- functional and non-functional fit;
- integration and wrapper mechanism;
- failure, recovery, and observability behavior;
- security response and update ownership;
- testing and environment fidelity;
- migration, compatibility, data portability, and exit;
- operational staffing and support;
- lifecycle cost and lock-in;
- removal of existing mechanism versus addition of a second path.

Do not rank by initial implementation effort alone.
Do not add numerical weights unless the decision owner supplied and justified them.

## 6. Decide proportionally

Use one outcome:

- `adopt`: use an existing capability substantially as provided;
- `adapt`: use it behind a bounded local integration;
- `combine`: use a small number of complementary capabilities;
- `build`: the bespoke baseline is the smallest responsible option;
- `defer`: decision evidence or timing does not support commitment;
- `do-nothing`: the current capability is sufficient.

State decisive evidence, rejected candidates worth recording, uncertainty, ownership consequences, and what would change the recommendation.
Return the result through the parent skill's candidate screen and solution output.

## Failure conditions

Fail when candidates define the requirements, external facts come from model recall, popularity selects the result, the bespoke baseline is omitted, integration and exit burden are ignored, or a material prerequisite remains only a caveat.
