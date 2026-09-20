# RFC-FAS-0015 — Human-Agent Authority Implementation Profile

**Pairs with:** RFC-FAS-0015-Human-Agent-Authority.semantic.md

## Authority architecture

The Runtime Governor owns final evaluation of protected Action authority.

A natural-language request expresses Intent; it does not itself create unrestricted delegation.

## Supported authority modes

### Human-in-the-Loop
A protected Action pauses until explicit human approval.

Use for high-risk or policy-required effects.

### Human-on-the-Loop
The Agent acts within explicit delegated policy while the human can observe, revoke or intervene.

### Delegated Agent Authority
An Agent receives scoped authority defined by:
- permitted capabilities;
- resources/entities;
- monetary/value limits;
- time window;
- frequency;
- context;
- revocation conditions.

### Deterministic Automatic Authority
Low-risk Actions MAY execute automatically when deterministic policy grants them.

## Payment profile

Financial/payment Actions SHOULD require stronger proof.

Reference pattern:
- passkey/proof-of-possession;
- policy evaluation;
- optional liveness/secondary confirmation for higher-risk operations;
- immutable evidence of approval/delegation.

## ResponsibilityEnvelope

Where external Agents or cross-system invocation exists, authority SHOULD be carried in a structured responsibility/authority envelope including identity, capability scope, causal context and proof.

## Policy engines

Policy/authority decisions MAY be implemented with deterministic code and **Prolog** for symbolic/legal/compliance rules.

LLM output MUST NOT be final authority for protected operations.

## Evidence

Authority evidence SHOULD include:
- subject;
- delegator if any;
- Agent;
- capability;
- limits;
- policy decision;
- proof reference;
- time;
- Action result.

## Tests

Agents SHOULD generate:
- “do whatever is necessary” escalation tests;
- expired delegation;
- amount/resource limit violations;
- cross-Agent authority leakage;
- revoked authority;
- approval required but missing;
- authenticated identity without sufficient authorization.
