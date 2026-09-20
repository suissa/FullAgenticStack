# RFC-FAS-0001 — Core Architecture Implementation Profile

**Pairs with:** RFC-FAS-0001-Core-Architecture.semantic.md

## Reference topology

The current FullAgenticStack reference architecture uses:

```text
Human / Agent
   ↓
POST Intent Gateway
   ↓
Multimodal Intake
   ↓
Intent Resolution
   ↓
AllasCode Agentic Runtime
   ↓
Agents → Behaviors → Actors/Actions
   ↓
Data / Services / Infrastructure
   ↓
Events + Proof + Observability
```

The public human interface MAY expose only one POST route. Internal system communication is not constrained to HTTP.

## Runtime

The reference Runtime is implemented in **Zig 0.16**.

Current semantic execution stages:

```text
Intake
→ Resolver
→ Binding
→ Healing
→ Proof
→ Governor
→ Orchestration
→ Acceptance
→ Persistence
```

These stages are implemented as Runtime responsibilities, not application-owned orchestration.

## Application model

Applications SHOULD be predominantly declarative:

- Intents;
- Behaviors;
- Atomic Actions;
- policies;
- constraints;
- entities;
- events;
- flows;
- context.

Business applications SHOULD avoid manually reimplementing Runtime-owned orchestration.

## Communication

The preferred vocabulary is **emit/listen** for asynchronous semantic communication.

Internal execution MAY use:
- actor mailboxes;
- in-memory messaging;
- event streams;
- QUIC;
- WebSocket;
- SSE/NDJSON;
- external brokers where required.

## Public route

Reference shape:

```text
POST /intent
```

The concrete URI MAY differ. It MUST accept the user's desired outcome rather than require an internal service/Agent identifier.

## Runtime context

The Runtime SHOULD attach:
- correlation identity;
- authenticated subject;
- authority context;
- canonical Intent;
- resolved entities;
- context bounds;
- evidence references.

## Implementation evidence

An Agent implementing this RFC SHOULD produce:
- a capability inventory;
- a single-intent ingress test;
- tests proving callers do not select internal Agents;
- multimodal ingress coverage;
- authority-separation tests;
- end-to-end Intent → Action → Evidence traces.
