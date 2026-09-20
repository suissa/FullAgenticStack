# RFC-FAS-0005 — Agent-Actor-Action Implementation Profile

**Pairs with:** RFC-FAS-0005-Agent-Actor-Action.semantic.md

## A³ reference model

The reference model is **A³ — Agent-Actor-Action**.

```text
Agent
  ↓ coordinates Behaviors by Intent
Actor
  ↓ owns bounded local execution state
Action
  ↓ performs one atomic/bounded capability
Supervisor
  ↓ supervises Actor/Action execution
```

An Action is treated operationally as an Actor-owned executable capability under supervision.

## Atomic Action requirement

Each Action SHOULD have a corresponding atomic skill describing:
- purpose;
- how to use it;
- inputs/outputs;
- invariants;
- authority;
- failure semantics;
- healing expectations;
- evidence.

This skill is intended to let coding Agents regenerate the implementation in the project's selected language without changing Action semantics.

## Action files

In the Zig Runtime reference implementation, generated Action structure SHOULD isolate the editable implementation body.

Only the implementation boundary intended for healing should be mutable by CodeHealerAgent.

## Supervisor model

Each Actor has a Supervisor responsible for:
- semantic failures;
- bounded retry;
- diagnosis;
- recovery;
- escalation.

## Event naming

Preferred event identity:

```text
{Agent}.{Intent}.Ok
{Agent}.{Intent}.Error
```

The canonical Intent remains immutable.

## Code generation

An implementation Agent SHOULD:
1. read Action semantic skill;
2. read language binding;
3. generate implementation;
4. generate tests from invariants;
5. generate failure/evidence mapping;
6. register the Action with Runtime Binding;
7. verify conformance.

## Language bindings

Actions MAY use Zig, Rust, Go, TypeScript, Python, Prolog, Haskell or WASM-compatible external languages.

Language choice SHOULD be optimized per Action rather than forcing one language per Agent.
