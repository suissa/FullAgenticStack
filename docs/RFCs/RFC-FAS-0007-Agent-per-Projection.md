# RFC-FAS-0007 — Agent per Projection

**Status:** Draft Standard  
**Category:** Standards Track  
**Version:** 0.3.0  
**Last Updated:** 2026-09-20  
**Dependencies:** RFC-FAS-0000, RFC-FAS-0006

Normative keywords **MUST**, **MUST NOT**, **SHOULD**, **SHOULD NOT**, and **MAY** define requirement strength.


## 1. Purpose

A Projection is a derived semantic view. FullAgenticStack treats independent projections as supervised capabilities rather than passive data structures.

## 2. Semantic model

A Projection P is derived from source evidence S using derivation semantics F.

Conceptually:

P = F(S, rules, context)

The projection owner is responsible for preserving the validity of this relationship.

## 3. Normative requirements

### FAS-PROJ-001 — Explicit owner
Every independent projection SHOULD have one explicit Agent or equivalent semantic owner.

### FAS-PROJ-002 — Source knowledge
The owner MUST know the projection's source authority and derivation semantics.

### FAS-PROJ-003 — Validity
The owner SHOULD be capable of determining whether the projection satisfies declared validity conditions.

### FAS-PROJ-004 — Rebuild
The owner SHOULD support semantic rebuild when sufficient source evidence is available.

### FAS-PROJ-005 — Healing
The owner MAY heal a projection if healing does not mutate source authority beyond granted permissions.

### FAS-PROJ-006 — Lineage
A projection SHOULD expose lineage sufficient to explain its derivation.

### FAS-PROJ-007 — Authority isolation
Projection maintenance MUST NOT silently change authoritative source state.

### FAS-PROJ-008 — Independent lifecycle
A projection SHOULD be able to report its own lifecycle state independently of the source.

## 4. Lifecycle

Typical semantic lifecycle:
Declared → Materialized → Validated → Serving → Stale or Invalid → Rebuilt or Healed.

The exact implementation mechanism is non-normative.

## 5. Preconditions

A projection SHOULD NOT be considered valid unless:
- its source authority is known;
- its derivation semantics are known;
- required source evidence is available;
- no known invariant violation remains unresolved.

## 6. Postconditions

A successful materialization or rebuild SHOULD produce a projection whose declared validity conditions hold.

## 7. Failure semantics

- **SourceUnavailable**
- **ProjectionInvalid**
- **ProjectionStale**
- **DerivationFailure**
- **LineageIncomplete**
- **RebuildFailed**

## 8. Evidence

The owner SHOULD expose projection identity, source identity, derivation version, freshness or validity status, and rebuild/healing evidence.

## 9. Non-conforming example

A materialized view is modified by arbitrary business code with no owner, source lineage or validity semantics.

## Agent implementation guidance

An implementation Agent MUST treat semantic requirements as authoritative and technology choices as bindings. It MAY choose languages, libraries, data engines, protocols, process boundaries and deployment topology when those choices preserve every normative invariant.

The Agent SHOULD maintain traceability from RFC requirement to semantic capability, implementation artifact, verification test and runtime evidence.

## Compatibility and evolution

Minor revisions MAY clarify wording without silently changing the meaning of stable requirement identifiers. Breaking semantic changes SHOULD receive new identifiers or a new major version.


## Machine-actionable requirement annotations

| Requirement | Class | Activation condition | Required evidence | Adversarial property |
|---|---|---|---|---|
| FAS-PROJ-001 | CONDITIONAL | independent_projection_exists | projection ownership map | independent projection has no owner |
| FAS-PROJ-002 | CONDITIONAL | independent_projection_exists | source/derivation contract | owner cannot identify source authority or derivation |
| FAS-PROJ-003 | CONDITIONAL | projection_serves_results | validity test | projection serves while validity is unknown |
| FAS-PROJ-004 | CONDITIONAL | projection_rebuild_expected | rebuild evidence | projection cannot be rebuilt from sufficient source evidence |
| FAS-PROJ-005 | OPTIONAL | projection_healing_supported | healing trace | healing mutates authoritative source without authority |
| FAS-PROJ-006 | CONDITIONAL | projection_exists | lineage evidence | projection derivation cannot be explained |
| FAS-PROJ-007 | CONDITIONAL | projection_maintenance_occurs | source mutation test | maintenance silently changes source authority |
| FAS-PROJ-008 | CONDITIONAL | projection_exists | lifecycle status evidence | projection cannot report valid/stale/invalid state |
