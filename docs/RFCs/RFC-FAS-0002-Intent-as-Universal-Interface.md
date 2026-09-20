# RFC-FAS-0002 — Intent as the Universal Software Interface

**Status:** Draft Standard  
**Category:** Standards Track  
**Version:** 0.2.0  
**Last Updated:** 2026-09-20  
**Dependencies:** RFC-FAS-0000, RFC-FAS-0001

Normative keywords **MUST**, **MUST NOT**, **SHOULD**, **SHOULD NOT**, and **MAY** define requirement strength.


## 1. Purpose

Intent is the universal semantic interface between humans, Agents and executable software capabilities.

## 2. Formal capability invariant

Let U be the set of human-facing capabilities and N the set of accepted natural-language expressions.

For every capability c in U, there MUST exist an expression i in N such that resolving i selects c or a Behavior capable of fulfilling c.

## 3. Intent semantic model

An Intent SHOULD contain or resolve:
- requested goal;
- target domain;
- relevant entities;
- parameters;
- contextual constraints;
- required authority;
- interpretation evidence where needed.

Intent describes **WHAT** is desired. Behavior describes **HOW** it can be satisfied.

## 4. Normative requirements

### FAS-INTENT-001 — Universal intent access
Every human-facing capability MUST have at least one natural-language invocation path.

### FAS-INTENT-002 — Canonical identity
Semantically equivalent expressions SHOULD resolve to the same canonical Intent identity.

### FAS-INTENT-003 — Surface independence
Intent identity SHOULD remain stable across supported channels, languages and modalities.

### FAS-INTENT-004 — Topology independence
Intent MUST NOT encode implementation topology as part of its semantic identity unless topology is itself part of the requested outcome.

### FAS-INTENT-005 — Goal preservation
Once accepted, the semantic objective of an Intent MUST NOT be silently changed.

### FAS-INTENT-006 — Explicit reinterpretation
A materially different interpretation MUST become a new candidate Intent or require explicit resolution.

### FAS-INTENT-007 — No implicit authority
Resolving an Intent MUST NOT imply authorizing it.

### FAS-INTENT-008 — Multiple Behaviors
Multiple Behaviors MAY satisfy the same Intent if applicable policies and invariants remain satisfied.

### FAS-INTENT-009 — Honest failure
Failure to understand or fulfill an Intent MUST be represented explicitly rather than fabricated as successful execution.

## 5. Preconditions

Resolution requires enough semantic information to distinguish materially different goals. Missing information MAY be requested interactively.

## 6. Postconditions

Resolution MUST yield:
- one canonical Intent suitable for orchestration; or
- an explicit ambiguous, incomplete, unsupported or unsafe state.

## 7. Failure semantics

- **AmbiguousIntent**
- **UnsupportedIntent**
- **IncompleteIntent**
- **ConflictingIntent**
- **UnsafeInterpretation**
- **ResolutionUnavailable**

## 8. Evidence

Intent resolution SHOULD preserve:
- input correlation;
- selected canonical Intent;
- resolved entities and parameters;
- uncertainty when material;
- relevant alternative interpretations when explanation is required.

## 9. Normative example

“Send Maria the invoice”, the equivalent request in another language, and an audio message expressing the same goal MAY all resolve to the same canonical Intent.

## 10. Non-conforming example

A system sees the word “invoice” and always invokes invoice creation without distinguishing create, send, cancel, inspect or pay. Lexical similarity has replaced semantic goal resolution.

## Agent implementation guidance

An implementation Agent MUST treat semantic requirements as authoritative and technology choices as bindings. It MAY choose languages, libraries, data engines, protocols, process boundaries and deployment topology when those choices preserve every normative invariant.

The Agent SHOULD maintain traceability from RFC requirement to semantic capability, implementation artifact, verification test and runtime evidence.

## Compatibility and evolution

Minor revisions MAY clarify wording without silently changing the meaning of stable requirement identifiers. Breaking semantic changes SHOULD receive new identifiers or a new major version.
