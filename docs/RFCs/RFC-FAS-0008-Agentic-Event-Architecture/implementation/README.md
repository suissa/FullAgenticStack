# RFC-FAS-0008 — Agentic Event Architecture Implementation Profile

**Pairs with:** RFC-FAS-0008-Agentic-Event-Architecture.semantic.md

## Event identity

Preferred event labels:

```text
{Agent}.{Intent}.Ok
{Agent}.{Intent}.Error
```

Domain facts MAY use additional semantic names where needed, but request/command and occurred fact MUST remain distinct.

## Emit/listen

The preferred architecture language is:
- **emit** an Event;
- **listen** for an Event.

Avoid coupling semantics to broker-specific “pub/sub” terminology.

## Event stores

### Local
**BadgerDB** is the preferred local Event Sourcing store for bounded Actor state in the Zig Runtime.

### Global
**EventStoreDB/Kurrent-compatible store** is the preferred durable global event stream authority.

## Messaging

Depending on deployment, event transport MAY use:
- in-memory Runtime broker;
- NATS;
- Kafka where scale/integration justifies it;
- EventStoreDB subscriptions;
- QUIC or other internal transport.

Transport is replaceable; Event identity and causal semantics are not.

## Outbox

State-changing authoritative writes SHOULD use an Outbox/CDC pattern so state persistence and event publication cannot silently diverge.

## Replay

Consumers MUST declare whether replay:
- rebuilds a projection;
- rehydrates Actor state;
- re-executes side effects;
- is observation-only.

External/irreversible effects MUST be protected from unsafe replay.

## Idempotency

Projection/event consumers SHOULD maintain idempotent application by semantic event identity/correlation.

## Causality

Events SHOULD preserve:
- correlation ID;
- causation reference;
- canonical Intent;
- Agent/Action identity;
- outcome;
- event-time and ingest-time where temporal correctness matters.

## Temporal evolution

For advanced temporal projections, Cozo or an equivalent temporal graph layer MAY retain longitudinal relationships while EventStoreDB remains the durable event history.

## Tests

Agents SHOULD implement:
- duplicate-delivery tests;
- replay safety;
- causal correlation;
- outbox atomicity;
- projection rebuild;
- command-vs-event distinction.
