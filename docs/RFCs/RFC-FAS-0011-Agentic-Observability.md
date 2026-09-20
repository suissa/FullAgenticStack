# RFC-FAS-0011 — Agentic Observability

**Status:** Draft Standard  
**Category:** Standards Track  
**Version:** 0.2.0  
**Last Updated:** 2026-09-20  
**Dependencies:** RFC-FAS-0000, RFC-FAS-0004

Normative keywords **MUST**, **MUST NOT**, **SHOULD**, **SHOULD NOT**, and **MAY** define requirement strength.


## 1. Purpose

Agentic systems require evidence sufficient for machines and humans to reason about execution.

Observability is an architectural responsibility, not an optional logging feature.

## 2. Normative requirements

### FAS-OBS-001 — Machine-readable evidence
Relevant execution MUST produce machine-readable evidence.

### FAS-OBS-002 — Correlation
Evidence SHOULD correlate Intent, Behavior, Action, authority decision, effects and final result.

### FAS-OBS-003 — Decision explainability
The system SHOULD retain enough evidence to explain why a capability or Action was selected.

### FAS-OBS-004 — Observation/authority separation
Recording or observing an occurrence MUST NOT grant authority over the observed domain.

### FAS-OBS-005 — Outcome distinguishability
Evidence MUST distinguish accepted success, semantic failure and unresolved outcome.

### FAS-OBS-006 — Technology neutrality
Logs, metrics, traces, Events, Proofs and other mechanisms are implementation forms. Required semantic evidence is normative.

### FAS-OBS-007 — Evidence integrity
Where evidence is used for audit, governance or conformance, its integrity SHOULD be protected according to risk.

### FAS-OBS-008 — Bounded sensitive data
Observability SHOULD preserve necessary evidence without unnecessarily copying sensitive content.

## 3. Minimum questions

A conforming system SHOULD be able to answer:
- What was requested?
- What did the system understand?
- What was authorized?
- What capability was selected?
- What Actions occurred?
- What effects occurred?
- Was the result accepted?
- What failed, if anything?

## 4. Failure semantics

- **EvidenceMissing**
- **EvidenceIncomplete**
- **CorrelationLost**
- **EvidenceTampered**
- **OutcomeUnknown**
- **SensitiveEvidenceLeak**

## 5. Postconditions

A protected execution SHOULD finish with enough evidence for another Agent or human reviewer to reconstruct the semantically relevant path.

## 6. Non-conforming example

A protected Action mutates authoritative state but leaves no correlation to the Intent or authority under which it executed.

## Agent implementation guidance

An implementation Agent MUST treat semantic requirements as authoritative and technology choices as bindings. It MAY choose languages, libraries, data engines, protocols, process boundaries and deployment topology when those choices preserve every normative invariant.

The Agent SHOULD maintain traceability from RFC requirement to semantic capability, implementation artifact, verification test and runtime evidence.

## Compatibility and evolution

Minor revisions MAY clarify wording without silently changing the meaning of stable requirement identifiers. Breaking semantic changes SHOULD receive new identifiers or a new major version.
