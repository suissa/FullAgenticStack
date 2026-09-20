# RFC-FAS-0017 — Maturity Levels Implementation Profile

**Pairs with:** RFC-FAS-0017-Maturity-Levels.semantic.md

## Purpose

This implementation profile helps an Agent identify the concrete architecture expected at each maturity level in the current FullAgenticStack/AllasCode ecosystem.

## Level 0 — AI-Enhanced

Typical concrete architecture:
- normal frontend/backend/database;
- optional LLM/chatbot;
- no universal Intent requirement.

No FullAgenticStack conformance claim.

## Level 1 — Agentic Interface

Add:
- public Intent ingress;
- real capability invocation through natural language;
- text/audio/image input.

Existing backend MAY remain largely conventional.

## Level 2 — Agentic Orchestration

Add:
- GatewayAgent;
- IntentResolver;
- Runtime-owned Agent/capability routing;
- explicit authority separation;
- correlated evidence.

## Level 3 — FullAgenticStack

Add Agents across:
- interface;
- application/domain;
- data responsibilities;
- infrastructure/observability as appropriate.

Introduce explicit Write/Read/Cache/Vector/Graph/Event/Observability ownership.

## Level 4 — FullAgenticStack Native

Adopt:
- AllasCode Zig Runtime;
- Intent/Behavior/AtomicAction declarations;
- A³;
- supervisors;
- 2flow orchestration;
- Event Sourcing;
- projection Agents;
- self-healing;
- proof/governor/acceptance stages;
- declarative application architecture.

## Level 5 — FullAgenticStack Extreme

Add:
- A2UI dynamic frontend;
- per-Action polyglot optimization;
- complete Agent-per-Projection model;
- eXtreme Zero Trust;
- passwordless/email-independent identity;
- cryptographic Agent identity;
- explicit Human-Agent authority;
- continuous conformance evidence;
- PQC-capable security profile where required.

## Agent selection rule

The implementation Agent SHOULD target the maturity level specified in the project goal.

If no level is specified, it SHOULD infer the minimum level needed to satisfy the goal and report that inference before implementation planning.

It MUST NOT deploy Level-5 operational complexity when a lower level fully satisfies the project goal unless the developer explicitly requests the higher profile.

## Migration

When evolving an existing project:
1. inventory current capabilities;
2. determine current maturity/conformance;
3. identify semantic gaps;
4. add the smallest missing responsibilities;
5. preserve existing behavior where compatible;
6. re-run conformance after every material architecture change.
