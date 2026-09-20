# RFC-FAS-0004 — Agentic Runtime Implementation Profile

**Pairs with:** RFC-FAS-0004-Agentic-Runtime.semantic.md

## Primary implementation

The reference Agentic Runtime is implemented in **Zig 0.16**.

The application layer should declare work; the Runtime owns execution semantics.

## Runtime pipeline

Current pipeline:

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

### Intake
Receives normalized request/context.

### Resolver
Resolves canonical Intent and candidate capability.

### Binding
Binds Intent/Behavior/Actions to executable owners and technology implementations.

### Healing
Detects recoverable execution conditions and invokes bounded supervision.

### Proof
Builds evidence/proofs required for later governance and acceptance.

### Governor
Applies policy, authority and constraint checks.

### Orchestration
Executes declared Action topology.

### Acceptance
Determines whether Action outcome actually satisfies the Intent/postconditions.

### Persistence
Persists authoritative state/evidence/events according to responsibility.

## Broker and Actor model

The Runtime uses a lightweight in-memory messaging model for local Actor communication. Each Actor has supervision responsibility for its bounded Actions.

External messaging MAY use NATS, EventStoreDB streams or other bindings depending on project profile.

## Local state

Actor execution state SHOULD remain local and bounded.

Reference local event/snapshot policy:
- Event Sourcing for bounded Actor state;
- snapshot cadence configurable, currently commonly `snapshot_every=10`;
- local event payloads typically small and semantic.

## Error philosophy

The user-facing objective is not to expose raw implementation errors when supervised recovery remains possible.

Failures SHOULD become semantic failure conditions and flow through supervision/healing before final escalation.

## Allowed self-modification boundary

In the AllasCode Runtime profile:
- Action code healing is bounded to `implementation.zig`;
- system configuration healing is bounded to `configs/core.yml`;
- other generated/specification files are treated as read-only and can be reset.

## Evidence

Every stage SHOULD emit correlated evidence. The Runtime should be able to reconstruct:
Intent → binding → authority → Action → proof → acceptance → persistence.
