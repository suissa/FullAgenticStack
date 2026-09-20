# RFC-FAS-0012 — Self-Healing and Supervision Implementation Profile

**Pairs with:** RFC-FAS-0012-Self-Healing-Supervision.semantic.md

## Reference healing architecture

The AllasCode Runtime treats healing as a Runtime-owned responsibility.

Reference actors:

- **Supervisor** — observes bounded Actor/Action execution;
- **CodeHealerAgent** — repairs Action implementation within the permitted code boundary;
- **SystemHealerAgent** — repairs permitted Runtime/system configuration;
- **CodeManager** — forms a hypothesis about whether the problem is code, configuration, both, or neither before mutation;
- **Human-in-the-Healing-Loop** — final escalation when autonomous correction is unsafe, unauthorized or inconclusive.

## Mutable boundaries

Reference safety rule:

- CodeHealerAgent MAY modify only the Action's `implementation.zig` boundary;
- SystemHealerAgent MAY modify only approved system configuration such as `configs/core.yml`;
- semantic contracts, generated invariants and other protected files are read-only;
- protected files MAY be automatically restored when unauthorized mutation is detected.

The exact filenames MAY differ in another project, but an equivalent bounded-mutation model SHOULD exist.

## Healing lifecycle

```text
Action failure
  ↓
Supervisor captures semantic failure
  ↓
CodeManager diagnosis / hypothesis
  ↓
classify:
  code | config | both | dependency | external | unknown
  ↓
select authorized healer
  ↓
bounded modification
  ↓
re-run invariant/tests
  ↓
accept | retry bounded | rollback | human escalation
```

## Retry

Retries MUST be bounded and context-aware.

A retry SHOULD NOT repeat an identical failing execution indefinitely.

## Evidence

Every healing attempt SHOULD retain:
- failure identity;
- hypothesis;
- selected healer;
- changed artifact/configuration;
- before/after fingerprint;
- tests/invariants executed;
- result;
- rollback or escalation evidence.

## Recovery priority

Preferred order:
1. retry only if failure is plausibly transient;
2. rebind to equivalent capability if authorized;
3. repair bounded configuration;
4. repair bounded implementation;
5. rollback unsafe change;
6. escalate to human.

## Tests

Agents SHOULD generate adversarial cases proving that healing:
- cannot remove authorization;
- cannot change canonical Intent;
- cannot mutate protected files;
- cannot convert failure into fabricated success;
- cannot retry without bound.
