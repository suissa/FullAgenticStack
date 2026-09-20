# RFC-FAS-0015 — Human-Agent Authority

**Status:** Draft Standard  
**Category:** Standards Track  
**Version:** 0.2.0  
**Last Updated:** 2026-09-20  
**Dependencies:** RFC-FAS-0000, RFC-FAS-0004

Normative keywords **MUST**, **MUST NOT**, **SHOULD**, **SHOULD NOT**, and **MAY** define requirement strength.


## 1. Purpose

Autonomy is not unlimited authority. This RFC defines how humans and Agents participate in protected decision-making.

## 2. Authority modes

A FullAgenticStack system MAY use:
- Human-in-the-Loop;
- Human-on-the-Loop;
- delegated Agent authority;
- deterministic automatic authority under explicit policy.

The applicable mode MUST be explicit for protected effects.

## 3. Normative requirements

### FAS-AUTH-001 — Authority context
Every protected Action MUST execute under an identifiable authority context.

### FAS-AUTH-002 — Explicit scope
Authority MUST define permitted scope and SHOULD define relevant limits such as duration, value, target, resource or frequency.

### FAS-AUTH-003 — No linguistic escalation
An Agent MUST NOT infer additional authority merely because a user requested an outcome in natural language.

### FAS-AUTH-004 — Human approval
The Runtime MUST be able to require human approval when policy demands it.

### FAS-AUTH-005 — Delegation
Delegated authority MAY permit autonomous execution when scope and constraints are explicit.

### FAS-AUTH-006 — Revocation
Delegated authority SHOULD be revocable unless the domain explicitly requires irrevocable effects.

### FAS-AUTH-007 — Evidence
Authority decisions SHOULD produce evidence suitable for later explanation and audit.

### FAS-AUTH-008 — Least authority
An Agent SHOULD receive no more authority than required to satisfy its assigned capability.

## 4. Formal execution constraint

An Action may execute only when its required authority is contained within effective authority for the current context.

## 5. Preconditions

Before protected execution:
- the authority subject MUST be identifiable;
- required authority MUST be known;
- current delegation or approval MUST cover the effect;
- applicable policy MUST permit execution.

## 6. Postconditions

The effect MUST remain within granted scope. Evidence SHOULD correlate the authority decision to the resulting Action.

## 7. Failure semantics

- **ApprovalRequired**
- **AuthorityInsufficient**
- **DelegationExpired**
- **ScopeViolation**
- **RevokedAuthority**
- **AuthorityContextMissing**

## 8. Non-conforming example

A user says “do whatever is necessary” and the Agent interprets the phrase as global authorization to modify unrelated resources.

## Agent implementation guidance

An implementation Agent MUST treat semantic requirements as authoritative and technology choices as bindings. It MAY choose languages, libraries, data engines, protocols, process boundaries and deployment topology when those choices preserve every normative invariant.

The Agent SHOULD maintain traceability from RFC requirement to semantic capability, implementation artifact, verification test and runtime evidence.

## Compatibility and evolution

Minor revisions MAY clarify wording without silently changing the meaning of stable requirement identifiers. Breaking semantic changes SHOULD receive new identifiers or a new major version.
