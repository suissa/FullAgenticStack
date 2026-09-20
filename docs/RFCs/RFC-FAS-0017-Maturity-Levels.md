# RFC-FAS-0017 — FullAgenticStack Maturity Levels

**Status:** Draft Standard  
**Category:** Informational / Conformance Guidance  
**Version:** 0.2.0  
**Last Updated:** 2026-09-20  
**Dependencies:** RFC-FAS-0000, RFC-FAS-0016

Normative keywords **MUST**, **MUST NOT**, **SHOULD**, **SHOULD NOT**, and **MAY** define requirement strength.


## 1. Purpose

Maturity describes architectural depth. It does not replace formal conformance.

## 2. Level 0 — AI-Enhanced

AI exists as a feature, but the application remains primarily interface-, endpoint- or service-driven.

Typical form: traditional application plus AI feature.

This level is not FullAgenticStack.

## 3. Level 1 — Agentic Interface

Natural language can invoke real application capabilities.

Required semantic shift:

natural-language request → real system capability.

## 4. Level 2 — Agentic Orchestration

A Runtime or equivalent semantic orchestrator resolves Intent to specialized Agents or capabilities.

The human no longer needs to select internal topology.

## 5. Level 3 — FullAgenticStack

Agency spans multiple major system responsibilities, including interface, application/domain and data.

Independent responsibilities begin to receive explicit Agent ownership.

## 6. Level 4 — FullAgenticStack Native

The system is designed around semantic primitives such as:
- Intent;
- Agent;
- Actor;
- Behavior;
- Action;
- Event;
- Policy;
- Proof;
- Supervisor;
- Projection.

Applications become increasingly declarative, and Runtime-owned orchestration becomes the default.

## 7. Level 5 — FullAgenticStack Extreme

The architecture combines:
- multimodal Intent;
- dynamic Agentic interfaces;
- polyglot Action bindings;
- explicit agentic data responsibilities;
- Agent-per-Projection;
- continuous evidence;
- supervision and healing;
- eXtreme Zero Trust;
- passwordless and email-independent identity;
- explicit Human-Agent authority.

## 8. Normative maturity rules

### FAS-MAT-001 — No technology counting
Maturity MUST NOT be inferred from the number of LLMs, Agents, databases or services.

### FAS-MAT-002 — Cumulative semantics
A higher level SHOULD preserve the semantic capabilities of preceding levels.

### FAS-MAT-003 — Evidence
Maturity claims SHOULD reference conformance evidence where formal profiles exist.

### FAS-MAT-004 — Framework neutrality
Using a named Agent framework alone MUST NOT qualify a system for a maturity level.

### FAS-MAT-005 — Architectural meaning
The determining factor is which semantic responsibilities are agentic and governed, not which products are installed.

## 9. Maturity vs conformance

Maturity = architectural depth.

Conformance = verified normative requirements.

A system may target Level 5 while still failing FAS-Extreme conformance because required evidence or invariants are incomplete.

## Agent implementation guidance

An implementation Agent MUST treat semantic requirements as authoritative and technology choices as bindings. It MAY choose languages, libraries, data engines, protocols, process boundaries and deployment topology when those choices preserve every normative invariant.

The Agent SHOULD maintain traceability from RFC requirement to semantic capability, implementation artifact, verification test and runtime evidence.

## Compatibility and evolution

Minor revisions MAY clarify wording without silently changing the meaning of stable requirement identifiers. Breaking semantic changes SHOULD receive new identifiers or a new major version.
