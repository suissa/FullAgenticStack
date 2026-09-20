# RFC-FAS-0016 — FullAgenticStack Conformance

**Status:** Draft Standard  
**Category:** Standards Track  
**Version:** 0.2.0  
**Last Updated:** 2026-09-20  
**Dependencies:** RFC-FAS-0000

Normative keywords **MUST**, **MUST NOT**, **SHOULD**, **SHOULD NOT**, and **MAY** define requirement strength.


## 1. Purpose

FullAgenticStack claims MUST be testable. Conformance is determined by semantic behavior, invariant preservation and evidence, not by branding or technology choice.

## 2. Requirement states

Each evaluated normative requirement MUST be reported as one of:
- **PASS**
- **FAIL**
- **NOT_APPLICABLE**
- **NOT_VERIFIED**

NOT_VERIFIED MUST NOT be treated as PASS.

## 3. Normative requirements

### FAS-CONF-001 — Traceability
Each evaluated requirement SHOULD identify supporting implementation artifacts, tests or runtime evidence.

### FAS-CONF-002 — Technology neutrality
A conformance test MUST NOT require a specific language, database, framework or vendor unless the tested profile explicitly requires one.

### FAS-CONF-003 — Evidence-based PASS
PASS MUST be supported by observable evidence.

### FAS-CONF-004 — Profile dependency
A higher conformance profile MUST satisfy required lower-profile requirements.

### FAS-CONF-005 — Honest uncertainty
Missing evidence MUST be reported as NOT_VERIFIED rather than inferred as success.

### FAS-CONF-006 — Reproducibility
Where practical, conformance tests SHOULD be reproducible by another Agent or human evaluator.

### FAS-CONF-007 — Negative verification
Conformance SHOULD include tests that attempt to violate important invariants.

### FAS-CONF-008 — Version identification
A report MUST identify the RFC versions evaluated.

## 4. Profiles

### FAS-Core

Requires:
- universal natural-language capability access;
- POST-equivalent semantic ingress;
- text, audio and image input;
- Intent resolution;
- Runtime-owned orchestration;
- interpretation/authority separation;
- machine-readable execution evidence.

### FAS-Native

Requires FAS-Core plus:
- explicit Agent/Actor/Action semantics;
- agentic data responsibilities;
- projection ownership where independent projections exist;
- event semantics;
- observability as a first-class responsibility;
- supervision and bounded healing.

### FAS-Extreme

Requires FAS-Native plus:
- eXtreme Zero Trust;
- passwordless identity;
- email-independent foundational identity;
- explicit Human-Agent authority;
- advanced dynamic Agentic frontend capability.

## 5. Conformance report structure

A report SHOULD contain:
- system identity;
- system version;
- profile claimed;
- RFC versions;
- requirement identifier;
- status;
- evidence reference;
- test reference;
- notes;
- evaluation time.

## 6. Negative tests

A conformance suite SHOULD attempt to:
- invoke a user-facing capability unavailable through Intent;
- cause a protected effect from interpretation alone;
- exceed delegated authority;
- treat cache or projection as silent authority;
- omit execution evidence;
- bypass required human approval;
- heal by weakening invariants;
- misreport unresolved execution as success.

## 7. Conformance invariant

A profile claim is valid only when the profile's required semantics are verified.

Branding, use of an Agent framework, number of LLMs, number of services or number of databases MUST NOT substitute for verification.

## 8. Example result

FAS-INTENT-001: PASS — all exposed user capabilities covered by intent suite.

FAS-MULTI-001: FAIL — audio ingress absent.

FAS-RUNTIME-003: PASS — protected Action governance tests successful.

FAS-DATA-010: NOT_VERIFIED — lineage evidence unavailable.

## Agent implementation guidance

An implementation Agent MUST treat semantic requirements as authoritative and technology choices as bindings. It MAY choose languages, libraries, data engines, protocols, process boundaries and deployment topology when those choices preserve every normative invariant.

The Agent SHOULD maintain traceability from RFC requirement to semantic capability, implementation artifact, verification test and runtime evidence.

## Compatibility and evolution

Minor revisions MAY clarify wording without silently changing the meaning of stable requirement identifiers. Breaking semantic changes SHOULD receive new identifiers or a new major version.
