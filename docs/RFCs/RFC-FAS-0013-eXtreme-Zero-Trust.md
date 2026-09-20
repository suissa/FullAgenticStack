# RFC-FAS-0013 — eXtreme Zero Trust

Status: Draft Standard  
Category: Standards Track  
Version: 0.1.0

## Principle

No human, Agent, Runtime, service, device, data system or infrastructure component is trusted solely because of network position, previous interaction or architectural role.

### FAS-XZT-001
Every protected interaction MUST be authenticated to the degree required by its risk and authority.

### FAS-XZT-002
Every protected effect MUST be explicitly authorized.

### FAS-XZT-003
Identity, authority and execution evidence SHOULD be independently verifiable.

### FAS-XZT-004
Trust MUST be bounded in scope and duration.

### FAS-XZT-005
An Agent MUST NOT inherit unrestricted authority from the human or Agent that invoked it.

### FAS-XZT-006
Communication channels and data exchanges SHOULD provide integrity and authenticity guarantees appropriate to their risk.

### FAS-XZT-007
Specific cryptographic algorithms and transport protocols are technology-profile decisions unless separately standardized.
