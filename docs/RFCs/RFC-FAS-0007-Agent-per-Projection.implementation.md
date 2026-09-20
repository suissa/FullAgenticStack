# RFC-FAS-0007 — Agent per Projection Implementation Profile

**Pairs with:** RFC-FAS-0007-Agent-per-Projection.semantic.md

## Reference rule

Every independent projection receives a dedicated semantic owner.

Preferred naming:

```text
{ProjectionName}Agent
```

Examples:
- CustomerReadProjectionAgent
- InventoryCacheProjectionAgent
- IntentVectorProjectionAgent
- EntityGraphProjectionAgent
- SalesDashboardProjectionAgent

## Responsibilities

A Projection Agent owns:
- projection schema/contract;
- source lineage;
- event/listen subscriptions;
- materialization;
- freshness;
- validation;
- rebuild;
- healing;
- migration/evolution;
- evidence.

It does not gain canonical source authority.

## Propagation

Reference propagation is CDC/Outbox-driven.

```text
Authoritative Write
   ↓
Outbox/Event
   ↓
Projection Agent listens
   ↓
Apply projection
   ↓
Validate
   ↓
Emit consumed/updated evidence
```

## Missing projection behavior

When a query requires a projection that does not exist, the system SHOULD emit a semantic requirement describing the needed projection/schema.

An Entity Data Manager Agent decides whether to:
- reuse an existing projection;
- extend an existing projection;
- create a new projection;
- reject the request if creation is outside authority.

## Database independence

Projection Agents may target:
- PostgreSQL views/tables;
- MongoDB collections;
- Redis keys/structures;
- Qdrant collections;
- Neo4j/Cozo graphs;
- Meilisearch indexes;
- DuckDB analytical tables;
- other stores selected by the Technology Profile.

## Rebuild

Rebuild MUST derive from authoritative evidence rather than copying another potentially stale projection.

## Healing

Projection healing MAY:
- replay missing source events;
- recreate indexes;
- rebuild materialization;
- correct derived schema/configuration.

It MUST NOT rewrite authoritative history merely to make the projection pass.

## Tests

Implementation Agents SHOULD generate:
- lineage tests;
- stale detection;
- replay/rebuild tests;
- duplicate event idempotency;
- source-authority protection;
- schema evolution tests.
