# RFC-FAS-0007 — Agent per Projection

Status: Draft Standard  
Category: Standards Track  
Version: 0.1.0

## Principle

Independent projections are active semantic responsibilities and SHOULD have explicit Agent ownership.

### FAS-PROJ-001
Every independent projection SHOULD have a designated Agent or equivalent semantic owner.

### FAS-PROJ-002
The owner MUST know the projection's source authority, derivation rules and validity conditions.

### FAS-PROJ-003
The owner SHOULD be able to validate whether the projection is current and semantically consistent.

### FAS-PROJ-004
The owner SHOULD support rebuilding or healing a projection when its invariants are violated.

### FAS-PROJ-005
Projection maintenance MUST NOT silently mutate authoritative state unless explicitly authorized by a separate capability.

### FAS-PROJ-006
Projection ownership is normative; whether the projection is a table, index, materialized view, document collection, cache, vector space, graph or other structure is not.
