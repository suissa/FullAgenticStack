# RFC-FAS-0002 — Intent as the Universal Software Interface

Status: Draft Standard  
Category: Standards Track  
Version: 0.1.0

## Principle

Intent is the universal semantic interface between humans, Agents and software capabilities.

### FAS-INTENT-001
For every user-accessible capability C, there MUST exist at least one natural-language expression I such that resolving I selects C or a behavior capable of fulfilling C.

### FAS-INTENT-002
Natural-language access MUST NOT be treated as an optional assistant when an equivalent user-facing capability exists elsewhere.

### FAS-INTENT-003
Intent resolution MUST be independent from transport and implementation topology.

### FAS-INTENT-004
An Intent SHOULD identify the requested goal, relevant entities, parameters, constraints, context and required authority.

### FAS-INTENT-005
A canonical Intent identity SHOULD remain stable across languages, channels and surface forms.

### FAS-INTENT-006
Once accepted, the semantic objective of an Intent MUST NOT be silently changed.

### FAS-INTENT-007
Intent describes WHAT is desired. Behavior describes HOW it can be satisfied.

### FAS-INTENT-008
Multiple Behaviors MAY satisfy the same Intent if policy and context allow them.

### FAS-INTENT-009
The same Intent SHOULD be invocable from any supported human or Agent interface without redefining the domain operation.
