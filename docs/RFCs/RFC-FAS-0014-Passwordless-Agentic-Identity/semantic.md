# RFC-FAS-0014 — Passwordless Agentic Identity

**Status:** Draft Standard  
**Category:** Standards Track  
**Version:** 0.3.0  
**Last Updated:** 2026-09-20  
**Dependencies:** RFC-FAS-0000, RFC-FAS-0013

Normative keywords **MUST**, **MUST NOT**, **SHOULD**, **SHOULD NOT**, and **MAY** define requirement strength.


## 1. Purpose

The FullAgenticStack Extreme profile is passwordless by construction and does not require email as a foundational identity primitive.

## 2. Normative requirements

### FAS-ID-001 — No reusable passwords
A FullAgenticStack Extreme implementation MUST NOT require reusable shared-secret passwords for human authentication.

### FAS-ID-002 — Email independence
Email MUST NOT be required as the primary authentication secret or mandatory foundational identity anchor.

### FAS-ID-003 — Verifiable identity
Human and Agent identities SHOULD be bound to verifiable credentials or proofs appropriate to their authority.

### FAS-ID-004 — Authentication/authorization separation
Authentication MUST remain semantically separate from authorization.

### FAS-ID-005 — Communication identifiers are insufficient
Possession of a communication identifier alone MUST NOT prove protected authority.

### FAS-ID-006 — Agent attribution
Agent identity SHOULD be uniquely attributable within its trust domain.

### FAS-ID-007 — Secure recovery
Identity recovery MUST NOT silently weaken the guarantees of the primary identity model.

### FAS-ID-008 — Credential scope
Agent credentials SHOULD be scoped to the authority actually required.

## 3. Semantic identity flow

Identity Proof → Authentication → Authority Evaluation → Action Scope.

Identity is not itself permission.

## 4. Preconditions

A protected Action SHOULD receive an identity context whose validity and scope can be evaluated independently of natural-language content.

## 5. Postconditions

Successful authentication establishes identity or proof-of-possession semantics only. It MUST NOT imply unrestricted authorization.

## 6. Failure semantics

- **IdentityProofMissing**
- **IdentityProofInvalid**
- **RecoveryInsufficient**
- **IdentityAmbiguous**
- **CredentialExpired**
- **CredentialOutOfScope**

## 7. Non-conforming examples

- a reusable password is mandatory in the Extreme profile;
- an email link alone grants unrestricted account authority;
- an Agent reuses a human password;
- password fallback remains mandatory for recovery.

## Agent implementation guidance

An implementation Agent MUST treat semantic requirements as authoritative and technology choices as bindings. It MAY choose languages, libraries, data engines, protocols, process boundaries and deployment topology when those choices preserve every normative invariant.

The Agent SHOULD maintain traceability from RFC requirement to semantic capability, implementation artifact, verification test and runtime evidence.

## Compatibility and evolution

Minor revisions MAY clarify wording without silently changing the meaning of stable requirement identifiers. Breaking semantic changes SHOULD receive new identifiers or a new major version.


## Machine-actionable requirement annotations

| Requirement | Class | Activation condition | Required evidence | Adversarial property |
|---|---|---|---|---|
| FAS-ID-001 | REQUIRED | FAS-Extreme claim | authentication flow evidence | reusable shared-secret password is mandatory |
| FAS-ID-002 | REQUIRED | FAS-Extreme claim | identity model evidence | email is mandatory foundational identity anchor |
| FAS-ID-003 | REQUIRED | protected_identity_used | credential/proof evidence | identity lacks verifiable basis appropriate to authority |
| FAS-ID-004 | REQUIRED | authentication_occurs | authn/authz separation evidence | authentication automatically grants unrestricted authorization |
| FAS-ID-005 | REQUIRED | communication_identifier_used | authority test | identifier possession alone grants protected authority |
| FAS-ID-006 | REQUIRED | agent_identity_exists | attribution evidence | two Agents cannot be distinguished within trust domain |
| FAS-ID-007 | REQUIRED | identity_recovery_supported | recovery security tests | recovery weakens primary identity guarantees |
| FAS-ID-008 | REQUIRED | agent_credential_exists | credential scope evidence | Agent credential grants unrelated authority |
