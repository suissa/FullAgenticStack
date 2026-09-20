# RFC-FAS-0012 — Self-Healing and Supervision

Status: Draft Standard  
Category: Standards Track  
Version: 0.1.0

## Principle

Failure handling is an architectural responsibility.

### FAS-HEAL-001
A supervised Action SHOULD expose failures as semantic conditions rather than opaque implementation exceptions.

### FAS-HEAL-002
A Supervisor SHOULD determine whether a failure is recoverable, retryable, substitutable or requires escalation.

### FAS-HEAL-003
Healing MUST preserve the original Intent and applicable authority constraints.

### FAS-HEAL-004
A healing attempt MUST NOT silently broaden authority.

### FAS-HEAL-005
Healing SHOULD generate evidence describing the detected condition, selected recovery strategy and outcome.

### FAS-HEAL-006
Human escalation MUST remain available when autonomous recovery is not authorized or cannot preserve required invariants.

### FAS-HEAL-007
Specific retry libraries, workflow engines or recovery products are non-normative.
