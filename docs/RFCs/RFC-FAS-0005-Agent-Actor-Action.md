# RFC-FAS-0005 — Agent-Actor-Action Model

Status: Draft Standard  
Category: Standards Track  
Version: 0.1.0

## Semantic model

Agent coordinates. Actor owns bounded execution state. Action performs one bounded capability.

### FAS-A3-001
An Agent MUST represent a semantic responsibility boundary, not a specific class, process or language construct.

### FAS-A3-002
An Actor SHOULD own execution-local state required to perform or supervise Actions within its responsibility.

### FAS-A3-003
An Action MUST represent a bounded capability with explicit inputs, outputs, invariants and evidence.

### FAS-A3-004
An Action MUST NOT silently expand its authority beyond the capability requested by the governing Intent and policies.

### FAS-A3-005
An Agent MAY coordinate multiple Actors and Actions.

### FAS-A3-006
An Action MAY be implemented deterministically, probabilistically, symbolically or by composition, provided its semantic contract is preserved.

### FAS-A3-007
Action identity SHOULD remain stable across implementation technologies.
