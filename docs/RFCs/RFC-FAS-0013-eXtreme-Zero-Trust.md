# RFC-FAS-0013 — eXtreme Zero Trust

**Status:** Draft Standard  
**Category:** Standards Track  
**Version:** 0.2.0  
**Last Updated:** 2026-09-20  
**Dependencies:** RFC-FAS-0000, RFC-FAS-0015

Normative keywords **MUST**, **MUST NOT**, **SHOULD**, **SHOULD NOT**, and **MAY** define requirement strength.


## 1. Purpose

eXtreme Zero Trust extends explicit trust verification across humans, Agents, Runtime components, services, devices, data responsibilities and infrastructure.

No component is trusted solely because of network location, previous interaction or architectural role.

## 2. Governing principle

Never assume authority. Establish identity, scope, permission and evidence appropriate to risk.

## 3. Normative requirements

### FAS-XZT-001 — Explicit authentication
Protected interactions MUST authenticate the initiating identity to a degree appropriate to risk.

### FAS-XZT-002 — Explicit authorization
Protected effects MUST be explicitly authorized.

### FAS-XZT-003 — Bounded trust
Trust MUST be bounded by scope and SHOULD be bounded by time.

### FAS-XZT-004 — Delegation containment
An Agent MUST NOT inherit unrestricted authority from its invoker.

### FAS-XZT-005 — Internal components are not implicitly trusted
Internal components MUST NOT be considered trusted merely because they execute inside the same network, host, process group or deployment.

### FAS-XZT-006 — Verifiable evidence
Identity, authority and protected-effect evidence SHOULD be independently verifiable where risk requires it.

### FAS-XZT-007 — Protected exchange
Protected communication SHOULD provide confidentiality, integrity, authenticity and replay resistance according to risk.

### FAS-XZT-008 — Passwordless Extreme profile
The Extreme profile MUST satisfy RFC-FAS-0014.

### FAS-XZT-009 — Continuous applicability
Trust evaluation SHOULD remain valid for the current context; historical authorization MUST NOT automatically authorize materially changed context.

## 4. Authority invariant

Effective Agent authority MUST be contained by:
- delegated authority;
- applicable policy;
- current context;
- validity period where applicable.

## 5. Preconditions

Before a protected effect:
- relevant identity MUST be sufficiently established;
- effective authority MUST cover the requested effect;
- required proof MUST be valid;
- applicable context MUST not invalidate the authority.

## 6. Failure semantics

- **IdentityUnverified**
- **AuthorityExpired**
- **AuthorityOutOfScope**
- **ProofInvalid**
- **TrustContextInsufficient**
- **ReplayDetected**
- **ContextChanged**

## 7. Technology neutrality

Specific cryptographic algorithms, credential formats and transport protocols belong to Security or Technology Profiles unless separately standardized.

## 8. Non-conforming example

An internal Agent can execute any protected Action because traffic originates from a private network.

## Agent implementation guidance

An implementation Agent MUST treat semantic requirements as authoritative and technology choices as bindings. It MAY choose languages, libraries, data engines, protocols, process boundaries and deployment topology when those choices preserve every normative invariant.

The Agent SHOULD maintain traceability from RFC requirement to semantic capability, implementation artifact, verification test and runtime evidence.

## Compatibility and evolution

Minor revisions MAY clarify wording without silently changing the meaning of stable requirement identifiers. Breaking semantic changes SHOULD receive new identifiers or a new major version.
