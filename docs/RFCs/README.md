# FullAgenticStack RFC Series

The FullAgenticStack RFC series is split into three synchronized layers for every RFC:

- `*.semantic.md` — normative, technology-independent meaning, invariants, authority, failure semantics, evidence and conformance.
- `*.implementation.md` — the current AllasCode/FullAgenticStack reference implementation: languages, runtime, databases, protocols, deployment patterns and operational choices.
- `*.implemented.zig` — executable Zig 0.16 reference contract implementing the semantic invariants and concrete implementation profile as types, validation logic, boundaries and tests.

## Precedence rule

```text
semantic > implementation
```

If an implementation profile conflicts with the paired semantic RFC, the semantic RFC wins.

Implementation files are allowed to evolve faster than semantic RFCs.

## Required Agent read order

Before implementing a FullAgenticStack project, an AI Agent SHOULD load in this order:

1. the developer/project goal;
2. all applicable `*.semantic.md` RFCs;
3. all paired `*.implementation.md` RFCs;
4. all paired `*.implemented.zig` executable reference contracts;
5. project-local Technology Profile and constraints;
6. existing source code, configuration and tests;
7. current conformance evidence if any.

Then derive:

```text
Project Goal
   +
Semantic RFCs
   +
Implementation RFCs
   +
Existing Project Context
      ↓
Capability Inventory
      ↓
Intent / Agent / Actor / Action Plan
      ↓
Technology Bindings
      ↓
Implementation
      ↓
Positive + Adversarial Tests
      ↓
Runtime Evidence
      ↓
Conformance Report
```

An Agent MUST NOT alter semantic requirements merely to fit the current implementation profile.

## RFC pairs

| RFC | Semantic | Implementation |
|---|---|---|
| 0000 | Semantic-First and Agent-Readable Specification | Reference authoring, language and generation profile |
| 0001 | FullAgenticStack Core Architecture | Zig Runtime + universal POST Intent gateway |
| 0002 | Intent as Universal Software Interface | Canonical labels, resolver, vector aliases, 2flow binding |
| 0003 | Multimodal Intent Ingress | Text/audio/image, GatewayAgent, WhatsApp-first |
| 0004 | Agentic Runtime | Zig 0.16 Runtime pipeline and bounded execution |
| 0005 | Agent-Actor-Action | A³, Atomic Actions, supervisors, skills |
| 0006 | Agentic Data Architecture | PostgreSQL/MongoDB/Redis/Qdrant/Neo4j/Cozo/EventStoreDB/BadgerDB/etc. |
| 0007 | Agent per Projection | Projection Agents, CDC/Outbox, rebuild/healing |
| 0008 | Agentic Event Architecture | emit/listen, EventStoreDB, BadgerDB, NATS/Kafka bindings |
| 0009 | Agentic Frontend and A2UI | UIAgent, GatewayAgent, TypeScript, WebSocket/SSE, offline-first |
| 0010 | Polyglot Agent Actions | Zig/Rust/Go/TypeScript/Python/Prolog/Haskell + WASM |
| 0011 | Agentic Observability | OpenTelemetry, ClickHouse, Tempo, Grafana, SSE/NDJSON |
| 0012 | Self-Healing and Supervision | Supervisor, CodeManager, CodeHealerAgent, SystemHealerAgent |
| 0013 | eXtreme Zero Trust | QUIC, TLS 1.3, mTLS, DPoP, Ed25519/X25519/ML-KEM, UbiQ walls |
| 0014 | Passwordless Agentic Identity | Passkeys/WebAuthn, WhatsApp-first, no passwords/email identity |
| 0015 | Human-Agent Authority | Governor, delegated authority, Human-in/on-the-Loop, Prolog policies |
| 0016 | FullAgenticStack Conformance | CI evaluator, BLAKE3 fingerprints, TLA+/Alloy where useful |
| 0017 | FullAgenticStack Maturity Levels | Concrete migration path from AI-Enhanced to FAS-Extreme |

## Current reference language profile

Preferred languages by responsibility:

- **Zig 0.16** — Runtime, systems, edge, bounded high-performance Actions.
- **Rust** — high-assurance/high-performance Actions and security-sensitive components.
- **Go** — operational and network services.
- **TypeScript** — web/A2UI, gateways, tooling and adapters.
- **Python** — ML, model integration, data/analytical Actions.
- **Prolog** — legal/compliance/policy/symbolic reasoning.
- **Haskell** — formal/compiler/highly typed semantic transformations.
- **WASM** — portable external-language boundary.

Language binding is preferably selected per Action rather than per Agent.

## Current reference data profiles

### Polyglot

- Write → PostgreSQL
- Read → MongoDB
- Cache → Redis
- Vector → Qdrant
- Graph → Neo4j / Cozo
- Events → EventStoreDB/Kurrent-compatible
- Local Event Sourcing → BadgerDB
- Search → Meilisearch
- Analytics → DuckDB / Cassandra when justified
- Logs → ClickHouse
- Traces → Tempo
- Secrets → Infisical

### Full-Postgres / Junior

PostgreSQL plus extensions/projections MAY implement multiple semantic responsibilities when operational simplicity is preferred.

### Embedded

SQLite, RocksDB, DuckDB and file-based Outbox MAY implement the embedded profile.

## Configuration conventions

- TOML preferred for Runtime/core configuration.
- YAML preferred for Agent manifests, declarative application structure and project Technology Profiles.

## Machine-actionable requirement model

Normative RFCs expose or define:

- RequirementClass: REQUIRED / CONDITIONAL / OPTIONAL
- ActivationCondition
- RequiredEvidence
- VerificationProperty
- AdversarialProperty
- ProfileOverrides

Conformance adds:

- ConformanceTarget
- PASS / FAIL / NOT_APPLICABLE / NOT_VERIFIED / STALE
- CLAIMED / SELF_VERIFIED / INDEPENDENTLY_VERIFIED assurance
- capability coverage
- anti-masking
- fingerprint binding
- drift/staleness detection
- exact profile manifests

## Implementation Agent contract

An implementation Agent SHOULD:

1. parse the goal into desired capabilities and constraints;
2. discover existing architecture before proposing replacements;
3. map applicable semantic requirements;
4. read each paired implementation profile;
5. choose/adapt technology bindings;
6. create Intent/Agent/Actor/Action and data responsibility plans;
7. generate code/configuration;
8. generate invariant and adversarial tests;
9. generate evidence instrumentation;
10. run or prepare conformance evaluation.

The Agent MUST preserve semantic requirements even when the project uses technologies different from the reference implementation.

## Important distinction

```text
RFC semantic layer = what MUST remain true
RFC implementation layer = how we currently choose to make it true
Project goal = what the developer wants built
Technology Profile = project-specific constraints
Agent = derives the concrete implementation
```

This split is intentional: the same semantic FullAgenticStack architecture can be generated for a different technology stack without changing its architectural meaning.


## Executable RFC layer

Each RFC now has a third paired artifact:

```text
RFC-FAS-NNNN-Name.semantic.md
RFC-FAS-NNNN-Name.implementation.md
RFC-FAS-NNNN-Name.implemented.zig
```

The Zig file is the executable reference contract for Zig 0.16. It encodes semantic concepts as concrete types, enums, validation rules, state transitions, authority boundaries and tests.

An implementation Agent MAY translate the `.implemented.zig` reference to another project language, but the translated implementation MUST preserve the paired semantic RFC and SHOULD preserve the behavior demonstrated by the Zig tests.

The `.implemented.zig` file is not allowed to weaken the `.semantic.md` contract. If code and semantic RFC disagree, the semantic RFC is authoritative and the code must be repaired.

### Agent implementation loop

```text
Goal
  + semantic.md
  + implementation.md
  + implemented.zig
  + existing project
      ↓
adapt / generate concrete project implementation
      ↓
run invariant tests
      ↓
run adversarial tests
      ↓
collect evidence
      ↓
evaluate conformance
```
