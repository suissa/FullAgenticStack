# RFC-FAS-0006 — Agentic Data Architecture Implementation Profile

**Pairs with:** RFC-FAS-0006-Agentic-Data-Architecture.semantic.md

## Reference data responsibilities

The FullAgenticStack/AllasCode reference data plane maps semantic responsibilities as follows.

### Write
Preferred authority: **PostgreSQL**.

All canonical writes flow through the Write responsibility. Direct mutation of derived stores is not authoritative.

### Read
Preferred polyglot binding: **MongoDB** for read-optimized projections.

A full-Postgres profile MAY use PostgreSQL read projections instead.

### Cache
Preferred binding: **Redis**.

Cache is never canonical authority.

### Vector
Preferred binding: **Qdrant**.

Vector records SHOULD contain canonical labels/aliases plus stable entity identifiers so semantic retrieval resolves back to authoritative entities.

### Graph
Preferred bindings:
- **Neo4j** for general graph projections and traversal;
- **Cozo** for semantic-temporal graph responsibilities and temporal/cognitive relationship modeling.

### Events
Preferred bindings:
- **EventStoreDB/Kurrent-compatible event store** for global durable event streams;
- **BadgerDB** for local bounded Event Sourcing in the Zig Runtime/Actor context.

### Observability
Preferred bindings:
- **ClickHouse** for high-volume logs/evidence analytics;
- **Tempo** for traces;
- OpenTelemetry-compatible collection and Grafana-compatible visualization.

## Supported deployment modes

### full-postgres
PostgreSQL implements the major responsibilities through extensions and specialized projections.

### junior
PostgreSQL plus extensions simulates specialized responsibilities with minimal operational complexity.

### polyglot
Reference mapping:
- Write → PostgreSQL
- Read → MongoDB
- Cache → Redis
- Vector → Qdrant
- Graph → Neo4j / Cozo where appropriate
- Events → EventStoreDB
- Local ES → BadgerDB
- Search → Meilisearch
- Analytics → DuckDB/Cassandra depending workload
- Logs → ClickHouse
- Traces → Tempo
- Secrets → Infisical

### embedded
Reference mapping:
- SQLite → local Event Sourcing/outbox and transactional state where appropriate;
- RocksDB → local read/cache structures;
- DuckDB → analytics/backup;
- file-based YAML/JSON outbox where SQLite outbox is intentionally avoided.

## CQRS

Writes MUST flow through the Write authority.

Read, cache, vector and graph responsibilities are derived projections and MAY have independent freshness.

## CDC / Outbox

Preferred propagation model:

```text
Write
  ↓
Outbox
  ↓
Projection Supervisors
  ├─ Read
  ├─ Cache
  ├─ Vector
  ├─ Graph
  └─ Search/Analytics
  ↓
consumed evidence/event
```

An Entity Data Manager/Agent SHOULD decide whether a missing projection is reused, created or rebuilt.

## Read authority

Which derived responsibility answers a query is configurable by context:
- cache;
- read projection;
- vector;
- graph.

This does not transfer canonical write authority.

## Agent instructions

When implementing a project, choose the lightest data mode that satisfies the project goal and environment. Do not deploy the polyglot profile merely because it exists.

The Agent MUST still preserve all seven semantic responsibilities required by the selected conformance profile.
