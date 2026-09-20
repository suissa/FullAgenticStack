# RFC-FAS-0015 — Human-Agent Authority

Status: Draft Standard  
Category: Standards Track  
Version: 0.1.0

## Principle

Agents operate under explicit authority; autonomy is not equivalent to unrestricted permission.

### FAS-AUTH-001
Every protected Action MUST execute under an identifiable authority context.

### FAS-AUTH-002
Authority MUST define permitted scope and SHOULD define relevant constraints such as duration, value, target or resource class.

### FAS-AUTH-003
An Agent MUST NOT infer additional authority merely from natural-language intent.

### FAS-AUTH-004
The system MUST support human approval when required by policy.

### FAS-AUTH-005
The system MAY support delegated autonomous authority when its scope is explicit and verifiable.

### FAS-AUTH-006
Human-in-the-Loop, Human-on-the-Loop and delegated Agent authority are valid modes when explicitly defined.

### FAS-AUTH-007
Authority decisions SHOULD produce evidence suitable for later explanation and audit.
