# RFC-FAS-0011 — Agentic Observability Implementation Profile

**Pairs with:** RFC-FAS-0011-Agentic-Observability.semantic.md

## Reference observability stack

Preferred components:
- **OpenTelemetry** for common telemetry instrumentation/export;
- **ClickHouse** for high-volume logs/evidence analytics;
- **Tempo** for distributed traces;
- **Grafana** for visualization/operational dashboards;
- **SSE/NDJSON** for direct Runtime evidence/event streaming to tools and UIs.

## Evidence model

Every Runtime stage and relevant Action SHOULD emit structured evidence correlated by:
- correlation ID;
- canonical Intent;
- Agent;
- Actor;
- Action;
- authority decision;
- proof reference;
- outcome;
- duration;
- timestamp.

## Semantic events

Observability is not restricted to generic logs.

Preferred evidence names follow semantic execution such as:
- IntentReceived;
- IntentResolved;
- ActionStarted;
- AuthorityAccepted/Rejected;
- Action.Ok/Error;
- HealingStarted/Completed;
- AcceptanceAccepted/Rejected.

## Logs

ClickHouse SHOULD receive normalized structured logs/evidence suitable for historical investigation and analytical queries.

## Traces

Tempo SHOULD retain distributed trace relationships across GatewayAgent, Runtime stages, Agents/Actions and data responsibilities.

## Metrics

Operational metrics SHOULD include:
- Intent resolution latency;
- Action latency;
- success/error/inconclusive counts;
- healing attempts;
- authority rejections;
- projection lag;
- event/outbox lag;
- cache hit/miss;
- conformance violations.

## Streaming

Runtime observability MAY be exposed through SSE/NDJSON so dashboards and Agents can consume live execution evidence without coupling to internal stores.

## Data protection

Observability Agents MUST minimize personal/sensitive data and follow project LGPD/GDPR mapping.

Secrets MUST NOT be emitted to telemetry.

## Tests

Implementation Agents SHOULD validate:
- correlation completeness;
- evidence reconstruction;
- trace continuity;
- no silent protected state changes;
- sensitive-data redaction;
- tamper/integrity controls where evidence is used for conformance.
