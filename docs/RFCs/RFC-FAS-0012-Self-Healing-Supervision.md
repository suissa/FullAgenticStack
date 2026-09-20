# RFC-FAS-0012 — Self-Healing and Supervision

**Status:** Draft Standard  
**Category:** Standards Track  
**Version:** 0.2.0  
**Last Updated:** 2026-09-20  
**Dependencies:** RFC-FAS-0000, RFC-FAS-0004, RFC-FAS-0005

Normative keywords **MUST**, **MUST NOT**, **SHOULD**, **SHOULD NOT**, and **MAY** define requirement strength.


## 1. Purpose

Failure recovery is a first-class architectural responsibility. Self-healing means bounded recovery under explicit invariants and authority constraints. It does not mean unrestricted autonomous mutation.

## 2. Semantic supervision flow

Action → Failure Condition → Supervisor → Diagnosis → Authorized Recovery Strategy → Retry, Substitute, Reconfigure or Escalate → Evidence.

## 3. Normative requirements

### FAS-HEAL-001 — Semantic failure
Supervised Actions SHOULD expose failures as semantic conditions rather than opaque implementation exceptions.

### FAS-HEAL-002 — Recovery classification
A Supervisor SHOULD classify whether a failure is retryable, substitutable, healable, non-recoverable or requires human escalation.

### FAS-HEAL-003 — Goal preservation
Healing MUST preserve the governing Intent unless an explicit reinterpretation is accepted.

### FAS-HEAL-004 — Authority preservation
Healing MUST NOT broaden authority.

### FAS-HEAL-005 — Invariant preservation
A healing strategy MUST NOT be accepted if it violates required invariants.

### FAS-HEAL-006 — Evidence
Healing SHOULD produce evidence describing detected condition, diagnosis, selected strategy and outcome.

### FAS-HEAL-007 — Human escalation
Escalation MUST remain available when autonomous recovery is unauthorized or insufficient.

### FAS-HEAL-008 — Bounded retries
Retry behavior SHOULD be bounded by semantic or policy constraints so that healing cannot become unbounded repetition.

## 4. Preconditions

A Supervisor SHOULD know:
- the failed Action contract;
- relevant Intent;
- current authority context;
- invariants that must remain true;
- available recovery classes.

## 5. Postconditions

Healing ends in:
- recovered and accepted success;
- explicit unresolved failure;
- or escalation.

A recovered implementation state is not sufficient if the original Intent postconditions remain unsatisfied.

## 6. Failure semantics

- **RecoveryNotAuthorized**
- **RecoveryExhausted**
- **DiagnosisUncertain**
- **InvariantAtRisk**
- **EscalationRequired**
- **RecoveryProducedDifferentIntent**

## 7. Non-conforming example

After an authorization failure, a Supervisor disables authorization checks so the Action can execute. This is invariant destruction, not healing.

## Agent implementation guidance

An implementation Agent MUST treat semantic requirements as authoritative and technology choices as bindings. It MAY choose languages, libraries, data engines, protocols, process boundaries and deployment topology when those choices preserve every normative invariant.

The Agent SHOULD maintain traceability from RFC requirement to semantic capability, implementation artifact, verification test and runtime evidence.

## Compatibility and evolution

Minor revisions MAY clarify wording without silently changing the meaning of stable requirement identifiers. Breaking semantic changes SHOULD receive new identifiers or a new major version.
