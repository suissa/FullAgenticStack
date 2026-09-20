# RFC-FAS-0014 — Passwordless Agentic Identity

Status: Draft Standard  
Category: Standards Track  
Version: 0.1.0

## Principle

The highest FullAgenticStack security profile is passwordless by construction and does not use email as a mandatory foundational identity primitive.

### FAS-ID-001
A FullAgenticStack Extreme implementation MUST NOT require shared-secret passwords for human authentication.

### FAS-ID-002
A FullAgenticStack Extreme implementation MUST NOT require email as the primary authentication secret or mandatory identity anchor.

### FAS-ID-003
Human and Agent identities SHOULD be bound to verifiable credentials or proofs appropriate to their authority.

### FAS-ID-004
Authentication MUST be separable from authorization.

### FAS-ID-005
Possession of a communication identifier MUST NOT alone prove authority.

### FAS-ID-006
Agent identities SHOULD be uniquely attributable within the system's trust domain.

### FAS-ID-007
Specific credential technologies are non-normative and belong to the implementation profile.
