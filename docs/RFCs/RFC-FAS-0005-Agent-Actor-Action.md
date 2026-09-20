# RFC-FAS-0005 — Agent-Actor-Action Model

**Status:** Draft Standard  
**Category:** Standards Track  
**Version:** 0.3.0  
**Last Updated:** 2026-09-20  
**Dependencies:** RFC-FAS-0000, RFC-FAS-0004

Normative keywords **MUST**, **MUST NOT**, **SHOULD**, **SHOULD NOT**, and **MAY** define requirement strength.


## 1. Purpose

This RFC defines Agent, Actor and Action as semantic execution roles.

## 2. Semantic roles

**Agent:** coordinates responsibility around one or more Intents or Behaviors.

**Actor:** owns bounded execution-local state and supervision context.

**Action:** performs one bounded executable capability.

These are semantic roles, not required code constructs.

## 3. Normative requirements

### FAS-A3-001 — Agent responsibility
An Agent MUST represent an explicit semantic responsibility boundary.

### FAS-A3-002 — Actor locality
Actor-owned state SHOULD be bounded to the execution or responsibility it supervises.

### FAS-A3-003 — Action boundedness
An Action MUST have bounded purpose, inputs, outputs and authority.

### FAS-A3-004 — Explicit invariants
Each protected Action MUST declare or inherit the invariants it preserves.

### FAS-A3-005 — No authority expansion
An Action MUST NOT silently exceed authority granted by the governing execution context.

### FAS-A3-006 — Stable semantic identity
Action identity SHOULD remain stable across implementation-language changes.

### FAS-A3-007 — Composition
Behaviors MAY compose Actions sequentially, conditionally, concurrently or through other orchestration semantics.

### FAS-A3-008 — Evidence
Action completion MUST expose enough semantic success or failure evidence for Runtime acceptance.

## 4. Action semantic contract

A well-specified Action SHOULD identify:
- name and purpose;
- inputs and outputs;
- preconditions and postconditions;
- invariants;
- authority;
- side effects;
- failure semantics;
- evidence;
- idempotency expectations where relevant.

## 5. Failure semantics

- **PreconditionNotMet**
- **InvariantThreatened**
- **AuthorityInsufficient**
- **ExecutionFailed**
- **PostconditionNotMet**
- **EvidenceMissing**

## 6. Normative example

An Action that calculates an invoice total MAY use any suitable implementation. It MUST NOT also authorize payment unless payment authority belongs to its semantic contract.

## 7. Non-conforming example

A generic Action accepts arbitrary prompts and may mutate any system state. Its purpose and authority are unbounded and cannot provide reliable semantic guarantees.

## Agent implementation guidance

An implementation Agent MUST treat semantic requirements as authoritative and technology choices as bindings. It MAY choose languages, libraries, data engines, protocols, process boundaries and deployment topology when those choices preserve every normative invariant.

The Agent SHOULD maintain traceability from RFC requirement to semantic capability, implementation artifact, verification test and runtime evidence.

## Compatibility and evolution

Minor revisions MAY clarify wording without silently changing the meaning of stable requirement identifiers. Breaking semantic changes SHOULD receive new identifiers or a new major version.


## Machine-actionable requirement annotations

| Requirement | Class | Activation condition | Required evidence | Adversarial property |
|---|---|---|---|---|
| FAS-A3-001 | REQUIRED | agent_exists | responsibility contract | Agent has no bounded semantic responsibility |
| FAS-A3-002 | REQUIRED | actor_state_exists | state-boundary evidence | Actor state leaks across unrelated responsibility |
| FAS-A3-003 | REQUIRED | action_exists | Action contract | Action purpose/input/output/authority is unbounded |
| FAS-A3-004 | REQUIRED | protected_action_exists | invariant declaration/test | protected Action has no declared/inherited invariants |
| FAS-A3-005 | REQUIRED | action_executes | authority evidence | Action exceeds execution authority |
| FAS-A3-006 | REQUIRED | implementation_binding_changes | cross-binding identity evidence | technology change changes semantic Action identity |
| FAS-A3-007 | OPTIONAL | behavior_composes_actions | composition evidence | composition violates declared ordering/constraint semantics |
| FAS-A3-008 | REQUIRED | action_completes | success/failure evidence | Runtime cannot distinguish Action outcome |
