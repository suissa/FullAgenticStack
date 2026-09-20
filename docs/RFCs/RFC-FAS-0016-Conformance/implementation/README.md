# RFC-FAS-0016 — Conformance Implementation Profile

**Pairs with:** RFC-FAS-0016-Conformance.semantic.md

## Goal

The conformance implementation allows an AI Agent or CI pipeline to evaluate FAS-Core, FAS-Native and FAS-Extreme against a concrete project.

## Conformance artifacts

A project SHOULD generate:

```text
.conformance/
  target.yml
  capability-inventory.yml
  requirement-map.yml
  evidence/
  reports/
```

File names are recommendations; semantic content is authoritative.

## Fingerprints

Preferred fingerprint: **BLAKE3** for fast artifact/configuration fingerprinting.

SHA-256 MAY also be emitted where ecosystem interoperability requires it.

Fingerprints SHOULD cover:
- executable/source artifact version;
- relevant configuration;
- capability inventory;
- policy set;
- RFC/profile versions.

## Test layers

### Static checks
Validate declarations, capability inventory, Agent/Action contracts, projection ownership and Technology Profile.

### Unit/property tests
Verify individual semantic invariants.

### Integration tests
Verify Runtime stages, authority, events, data propagation and evidence.

### Adversarial tests
Attempt authority bypass, masking, replay, stale projection use, unsafe healing and evidence omission.

### Formal checks
Where high value, use **TLA+** and/or **Alloy** models for concurrency, state, authority and invariant analysis.

## CI

CI SHOULD:
1. discover applicable requirements;
2. run positive tests;
3. run adversarial tests;
4. calculate IntentCoverage;
5. verify evidence;
6. compare fingerprints;
7. mark stale results;
8. emit machine-readable report.

## Machine-readable report

Preferred format: YAML or JSON.

The report SHOULD include:
- target;
- profile;
- RFC versions;
- requirement status;
- assurance;
- evidence refs;
- coverage;
- fingerprints;
- evaluator identity.

## Assurance

Self-verification MAY run in ordinary CI.

Independent verification SHOULD be possible by a separate Agent/environment using the same report inputs.

## Anti-masking

The CI evaluator MUST compare capability inventory and exposed runtime behavior so an implementation cannot hide a failing capability only during tests.

## Runtime evidence

OpenTelemetry/semantic event evidence MAY be used as RuntimeEvidence.

ClickHouse/Tempo evidence backends MAY retain historical verification traces.

## Agent workflow

A Conformance Agent reads:
- all semantic RFCs;
- implementation RFCs;
- project goal;
- Technology Profile;
- code/config;
- existing tests/evidence.

It MUST NOT modify requirements merely to obtain PASS.
