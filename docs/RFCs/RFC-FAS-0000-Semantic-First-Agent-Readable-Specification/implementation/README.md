# RFC-FAS-0000 — Implementation Profile

**Pairs with:** RFC-FAS-0000-Semantic-First-Agent-Readable-Specification.semantic.md  
**Profile:** AllasCode / FullAgenticStack Reference Implementation  
**Status:** Living Implementation Profile

## Precedence

The paired `.semantic.md` file is normative. This file describes the current preferred implementation used by the FullAgenticStack/AllasCode ecosystem.

If this file conflicts with the semantic RFC, the semantic RFC wins.

## Agent read order

Before implementing a project, an Agent MUST load:

1. all applicable `*.semantic.md` RFCs;
2. the paired `*.implementation.md` files;
3. the project goal supplied by the developer;
4. project-local architecture, constraints and existing code;
5. project-local Technology Profile if present.

The Agent then derives an implementation plan and MUST preserve the semantic invariants even when adapting technologies.

## Current language profile

Preferred languages:

- **Zig 0.16** — Agentic Runtime, low-level runtime modules, supervisors, edge/security components, high-performance Actions;
- **TypeScript** — web/A2UI clients, gateway/application integration, developer tooling;
- **Go** — network services and operational services where simple concurrency and deployment are valuable;
- **Rust** — high-assurance/high-performance Actions and cryptographic or systems components;
- **Prolog** — policy, legal/compliance and symbolic reasoning;
- **Haskell** — formal or highly typed transformations/compiler work where advantageous;
- **Python** — ML, data science, model integration, experimentation and analytical Actions;
- **WASM** — planned neutral boundary for external languages and portable Actions.

Technology choice is per capability or Action, not per entire application.

## Configuration profile

- TOML is preferred for Runtime/core configuration.
- YAML is preferred for Agent manifests and declarative application descriptions.
- Project implementation bindings SHOULD be explicit and separated from semantic RFCs.

## Generation model

The implementation Agent SHOULD derive:

```text
Semantic RFCs
    +
Implementation RFCs
    +
Project Goal
    +
Existing Project Context
        ↓
Capability Graph
        ↓
Action/Agent/Actor Plan
        ↓
Technology Bindings
        ↓
Files + Tests + Policies + Evidence
```

## Required generated traceability

For every implemented RFC requirement, the Agent SHOULD generate a mapping containing:

- requirement ID;
- implementing Agent/Action/capability;
- source/config artifacts;
- verification test;
- expected Runtime evidence.

## Existing-code rule

The Agent MUST prefer adapting to the existing project when adaptation preserves semantic requirements. It MUST NOT rewrite technology merely to match this reference profile unless the project goal explicitly requires migration.

## Implementation quality gates

Before declaring completion, the Agent SHOULD verify:

- semantic requirements are covered;
- implementation bindings are explicit;
- protected effects have authority checks;
- failures are semantic rather than opaque;
- observability exists;
- conformance evidence can be produced.
