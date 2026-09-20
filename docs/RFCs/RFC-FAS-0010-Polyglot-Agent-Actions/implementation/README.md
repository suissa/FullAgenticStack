# RFC-FAS-0010 — Polyglot Agent Actions Implementation Profile

**Pairs with:** RFC-FAS-0010-Polyglot-Agent-Actions.semantic.md

## Current language portfolio

Supported/preferred languages:
- Zig 0.16
- Rust
- Go
- TypeScript
- Python
- Prolog
- Haskell

External languages SHOULD eventually integrate through a **WASM** capability boundary when practical.

## Selection strategy

Choose language **per Action**, not per Agent or product.

Reference tendencies:

### Zig
Runtime internals, edge components, memory-sensitive and deterministic systems work.

### Rust
High-assurance services, cryptographic/security-heavy Actions, performance-critical logic.

### Go
Operational/network services, simple concurrency-heavy infrastructure.

### TypeScript
Web/A2UI, gateway integration, developer tooling, application adapters.

### Python
ML/model workloads, data science, experimentation, inference integration.

### Prolog
Policies, legal/compliance rules, symbolic reasoning and constraint evaluation.

### Haskell
Compiler/formal transformations and strongly typed semantic transformations where beneficial.

## Contract boundary

Every polyglot Action MUST expose the same semantic contract regardless of binding:
- Action identity;
- typed/validated inputs;
- outputs;
- authority context;
- semantic failures;
- evidence/correlation;
- postconditions.

## WASM

WASM is the planned neutral portability layer for languages outside the native set.

A WASM adapter MUST preserve semantic failure and authority metadata; it is not merely a byte-level FFI.

## Serialization

The concrete serialization format is project-specific. Agents SHOULD prefer schema-driven contracts and MUST preserve semantic identity across language boundaries.

## Generation

Atomic Action skills are the primary source for language-specific code generation.

An implementation Agent should be able to regenerate the same Action in another language and pass the same conformance suite.

## Cross-language tests

For any alternative binding, run:
- same input → semantically equivalent result;
- same invalid input → equivalent semantic failure;
- same authority constraints;
- same evidence obligations;
- no hidden privilege gained through adapter boundary.
