# RFC-FAS-0002 — Intent Interface Implementation Profile

**Pairs with:** RFC-FAS-0002-Intent-as-Universal-Interface.semantic.md

## Canonical Intent model

The reference ecosystem uses immutable canonical semantic labels.

Preferred form:

```text
canonical_label = {Agent}.{Intent}
```

Examples:

```text
Financial.CreateInvoice
Customer.Create
Inventory.CheckAvailability
```

Natural-language aliases and multilingual expressions resolve to the canonical identity.

## Intent immutability

Once accepted, the Intent identity is immutable. Additional processing MAY enrich:
- entities;
- parameters;
- context;
- evidence;
- authority metadata.

A semantic change creates a new candidate Intent or requires explicit confirmation.

## Resolution implementation

The resolver MAY combine:
- LLM classification;
- semantic/vector retrieval;
- rules;
- deterministic parsing;
- graph context;
- Prolog reasoning;
- confidence/ambiguity logic.

No single technique is mandatory.

## Intent registry

The implementation SHOULD maintain an Agent-readable Intent catalog containing at least:
- canonical label;
- aliases;
- required entities;
- required context;
- candidate Behaviors;
- authority requirements;
- semantic failure classes.

## Vector usage

The reference data plane stores canonical labels, aliases and entity identifiers in the vector responsibility to support semantic retrieval.

Vector similarity is candidate discovery, not final execution authority.

## 2flow binding

Resolved Intents MAY bind to declarative **2flow** flows.

The 2flow DSL currently uses operators such as:

```text
->
<-
->>
<<-
[]
,
try/catch
error#last-error
```

The DSL describes orchestration; the semantic Intent remains stable.

## Required tests

The Agent SHOULD generate:
- alias equivalence tests;
- multilingual equivalence tests where supported;
- ambiguous Intent tests;
- topology independence tests;
- `resolve != authorize` tests;
- complete user-capability-to-Intent coverage tests.
