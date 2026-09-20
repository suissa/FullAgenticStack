# RFC-FAS-0010 — Polyglot Agent Actions

**Status:** Draft Standard  
**Category:** Standards Track  
**Version:** 0.2.0  
**Last Updated:** 2026-09-20  
**Dependencies:** RFC-FAS-0000, RFC-FAS-0005

Normative keywords **MUST**, **MUST NOT**, **SHOULD**, **SHOULD NOT**, and **MAY** define requirement strength.


## 1. Purpose

FullAgenticStack separates Action semantics from implementation language. Different Actions belonging to the same Agent MAY use different implementation technologies.

## 2. Normative requirements

### FAS-POLY-001 — Language independence
An Agent or Action MUST NOT be semantically defined by implementation language.

### FAS-POLY-002 — Per-Action binding
Different Actions within the same Agent MAY use different language, runtime or execution bindings.

### FAS-POLY-003 — Semantic contract
The Runtime MUST reason about capability contracts rather than language identity.

### FAS-POLY-004 — Equivalent behavior
Changing implementation technology MUST preserve Action semantics, authority, invariants and evidence obligations.

### FAS-POLY-005 — Developer constraints
The developer MAY constrain allowed languages, runtimes or interoperability boundaries.

### FAS-POLY-006 — Agent selection
When technology is not fixed, an implementation Agent MAY select it according to correctness, resource constraints, security, performance, portability and maintainability.

### FAS-POLY-007 — Boundary preservation
Cross-language communication MUST preserve all semantic information required for authority, failure and evidence.

## 3. Invariants

Technology substitution MUST NOT change:
- canonical Intent identity;
- Action purpose;
- authority scope;
- required postconditions;
- semantic failure meaning;
- evidence obligations.

## 4. Failure semantics

- **ContractMismatch**
- **BindingUnavailable**
- **SemanticSerializationLoss**
- **AuthorityContextLost**
- **EvidenceContextLost**
- **RuntimeIncompatible**

## 5. Evidence

An implementation SHOULD make it possible to determine which semantic Action contract a technology-specific component implements.

## 6. Non-conforming example

A language boundary converts every semantic failure into a success-shaped response, preventing the Runtime from evaluating postconditions.

## Agent implementation guidance

An implementation Agent MUST treat semantic requirements as authoritative and technology choices as bindings. It MAY choose languages, libraries, data engines, protocols, process boundaries and deployment topology when those choices preserve every normative invariant.

The Agent SHOULD maintain traceability from RFC requirement to semantic capability, implementation artifact, verification test and runtime evidence.

## Compatibility and evolution

Minor revisions MAY clarify wording without silently changing the meaning of stable requirement identifiers. Breaking semantic changes SHOULD receive new identifiers or a new major version.


## Machine-actionable requirement annotations

| Requirement | Class | Activation condition | Required evidence | Adversarial property |
|---|---|---|---|---|
| FAS-POLY-001 | REQUIRED | action_or_agent_exists | semantic contract independent of language | language name defines semantic identity |
| FAS-POLY-002 | OPTIONAL | multiple_bindings_used | per-Action binding map | same Agent cannot preserve contracts across bindings |
| FAS-POLY-003 | REQUIRED | runtime_binds_actions | contract-based dispatch evidence | Runtime dispatches by language identity rather than semantic capability |
| FAS-POLY-004 | REQUIRED | binding_changes | cross-binding conformance tests | technology substitution changes semantics/authority/evidence |
| FAS-POLY-005 | OPTIONAL | developer_constraints_exist | Technology Profile | Agent ignores explicit developer technology constraints |
| FAS-POLY-006 | OPTIONAL | technology_not_fixed | selection rationale | Agent chooses binding without considering stated constraints |
| FAS-POLY-007 | REQUIRED | cross_language_boundary_exists | round-trip semantic evidence | failure/authority/evidence context is lost at boundary |
