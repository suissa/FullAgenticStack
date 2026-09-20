# RFC-FAS-0016 — FullAgenticStack Conformance

**Status:** Draft Standard  
**Category:** Standards Track  
**Version:** 0.4.0  
**Last Updated:** 2026-09-20  
**Dependencies:** RFC-FAS-0000

Normative keywords **MUST**, **MUST NOT**, **SHOULD**, **SHOULD NOT**, and **MAY** define requirement strength.

## 1. Purpose

FullAgenticStack claims MUST be testable.

Conformance is determined by semantic behavior, invariant preservation, coverage and evidence. It MUST NOT be inferred from branding, framework choice, number of Agents, number of LLMs, number of services, number of databases, or implementation language.

This RFC defines a protocol that can be executed by a human evaluator or an AI Conformance Agent.

## 2. Conformance target

Every evaluation MUST identify the exact target being evaluated.

A ConformanceTarget contains:

~~~text
ConformanceTarget {
  system_identity
  system_version
  deployment_identity
  artifact_fingerprint
  configuration_fingerprint
  profile_claimed
  evaluation_scope
  exclusions
  rfc_set
}
~~~

### FAS-CONF-001 — Explicit target
A conformance result MUST identify the system, version, deployment or artifact scope to which it applies.

### FAS-CONF-002 — Explicit exclusions
Any excluded subsystem, capability or environment MUST be declared.

An evaluator MUST NOT silently exclude a failing area from scope.

## 3. Requirement classes

Requirement applicability follows RFC-FAS-0000.

~~~text
REQUIRED
CONDITIONAL
OPTIONAL
~~~

### REQUIRED
Must be evaluated whenever included by the claimed profile.

### CONDITIONAL
Must be evaluated when its ActivationCondition is true.

### OPTIONAL
Does not block conformance unless the profile explicitly elevates it to REQUIRED.

A profile manifest MAY override the baseline class of a requirement.

## 4. Requirement states

Every evaluated requirement MUST have one of:

- **PASS**
- **FAIL**
- **NOT_APPLICABLE**
- **NOT_VERIFIED**
- **STALE**

### PASS
The requirement is applicable and supported by sufficient evidence.

### FAIL
The requirement is applicable and evidence shows that its semantic property does not hold.

### NOT_APPLICABLE
The requirement is conditional and its ActivationCondition is demonstrably false.

### NOT_VERIFIED
Applicability is known or possible, but available evidence is insufficient.

### STALE
The requirement was previously evaluated, but material artifact, configuration, deployment, RFC version or environment drift makes the prior result unreliable.

NOT_VERIFIED and STALE MUST NOT be treated as PASS.

## 5. Non-applicability rules

### FAS-CONF-003 — Justified non-applicability
NOT_APPLICABLE MUST include evidence showing why the ActivationCondition is false.

### FAS-CONF-004 — No missing-feature laundering
A requirement MUST NOT become NOT_APPLICABLE merely because the implementation omitted the capability that the claimed profile requires.

For example, FAS-MULTI-001 cannot be marked NOT_APPLICABLE in FAS-Core because audio ingress was not implemented. It is FAIL.

## 6. Evidence model

A ConformanceEvidence object SHOULD identify:

~~~text
ConformanceEvidence {
  evidence_id
  requirement_id
  evidence_class
  source
  subject
  claim
  observed_at
  reproducible
  integrity_reference
}
~~~

Accepted evidence classes include:

- **StaticEvidence**
- **TestEvidence**
- **RuntimeEvidence**
- **FormalEvidence**
- **HumanAttestation**

### FAS-CONF-005 — Evidence-based PASS
PASS MUST be supported by evidence appropriate to the requirement.

### FAS-CONF-006 — Evidence integrity
Evidence used for authority-, security-, identity- or conformance-critical requirements SHOULD provide an integrity mechanism appropriate to risk.

### FAS-CONF-007 — Human attestation limits
HumanAttestation alone SHOULD NOT satisfy a directly machine-verifiable security- or authority-critical requirement.

## 7. Assurance level

Requirement status and assurance are separate dimensions.

An evaluation SHOULD declare one of:

- **CLAIMED**
- **SELF_VERIFIED**
- **INDEPENDENTLY_VERIFIED**

Example:

~~~text
status: PASS
assurance: SELF_VERIFIED
~~~

does not mean the same thing as:

~~~text
status: PASS
assurance: INDEPENDENTLY_VERIFIED
~~~

### FAS-CONF-008 — Assurance disclosure
A conformance report SHOULD state who or what performed the verification and the resulting assurance level.

## 8. Traceability

### FAS-CONF-009 — Requirement traceability
Each PASS SHOULD be traceable through:

~~~text
requirement
  ↓
semantic capability
  ↓
implementation artifact
  ↓
verification test/property
  ↓
runtime/formal evidence
~~~

### FAS-CONF-010 — Honest uncertainty
Missing evidence MUST result in NOT_VERIFIED rather than inferred success.

## 9. Reproducibility

### FAS-CONF-011 — Reproducible evaluation
Where practical, another Agent or human evaluator SHOULD be able to reproduce the verification from the report references.

A report SHOULD identify test inputs, target version or fingerprint, relevant configuration, environment assumptions, evidence locations and RFC versions.

## 10. Anti-masking

### FAS-CONF-012 — Capability masking prohibited
A requirement MUST NOT PASS if the implementation removes, disables, hides, short-circuits or makes unreachable the behavior being evaluated solely to avoid exercising the invariant.

Examples of masking:
- disabling a required capability to avoid its authorization tests;
- bypassing a projection to avoid proving projection consistency while still exposing the projection;
- returning a canned success response instead of executing the required capability;
- excluding an unsafe Agent from discovery only during conformance tests.

An evaluator SHOULD include masking-detection tests where relevant.

## 11. Positive and adversarial verification

### FAS-CONF-013 — Positive verification
Applicable requirements SHOULD define at least one property showing expected compliant behavior.

### FAS-CONF-014 — Adversarial verification
Security-, identity-, authority-, healing-, integrity- and evidence-critical requirements SHOULD define at least one adversarial property intended to falsify the invariant.

Example:

~~~text
Given:
  effective_authority = A
  Action requires B
  B is not a subset of A

Then:
  protected effect MUST NOT occur
~~~

## 12. Coverage

A universal requirement MUST define coverage over the full relevant capability set, not over a hand-picked example.

For universal Intent access:

~~~text
IntentCoverage =
  covered_human_facing_capabilities
  /
  total_human_facing_capabilities
~~~

For FAS-Core:

~~~text
IntentCoverage = 1.0
~~~

### FAS-CONF-015 — Complete capability inventory
Universal capability requirements MUST be evaluated against a declared capability inventory.

### FAS-CONF-016 — No sample-based universal PASS
A universal requirement MUST NOT PASS merely because selected examples succeed.

## 13. Drift and staleness

A conformance result applies to a specific semantic target.

Material change to any of the following MAY invalidate prior results:
- executable artifact;
- relevant configuration;
- authority policy;
- deployment topology where semantics depend on it;
- capability inventory;
- profile manifest;
- evaluated RFC version.

### FAS-CONF-017 — Fingerprint binding
A conformance report SHOULD bind results to artifact and configuration fingerprints when practical.

### FAS-CONF-018 — Stale transition
If material drift invalidates supporting evidence, affected PASS results MUST become STALE or be re-evaluated.

## 14. Profile manifests

A profile manifest defines exact requirement membership.

### 14.1 FAS-Core manifest

The following are REQUIRED unless a more specific activation rule is stated:

~~~text
FAS-CORE-001
FAS-CORE-002
FAS-CORE-003
FAS-CORE-004
FAS-CORE-005
FAS-CORE-006
FAS-CORE-007
FAS-CORE-008

FAS-INTENT-001
FAS-INTENT-002
FAS-INTENT-003
FAS-INTENT-004
FAS-INTENT-005
FAS-INTENT-006
FAS-INTENT-007
FAS-INTENT-009

FAS-MULTI-001
FAS-MULTI-002
FAS-MULTI-003
FAS-MULTI-004
FAS-MULTI-005

FAS-RUNTIME-001
FAS-RUNTIME-002
FAS-RUNTIME-003
FAS-RUNTIME-004
FAS-RUNTIME-005
FAS-RUNTIME-006
FAS-RUNTIME-007
FAS-RUNTIME-008

FAS-OBS-001
FAS-OBS-002
FAS-OBS-003
FAS-OBS-004
FAS-OBS-005
FAS-OBS-006
~~~

FAS-CORE-009 and FAS-INTENT-008 remain CONDITIONAL or OPTIONAL according to their annotations.

### 14.2 FAS-Native manifest

FAS-Native requires FAS-Core plus the following applicable requirements:

~~~text
FAS-A3-001
FAS-A3-002
FAS-A3-003
FAS-A3-004
FAS-A3-005
FAS-A3-006
FAS-A3-008

FAS-DATA-001
FAS-DATA-002
FAS-DATA-003
FAS-DATA-004
FAS-DATA-005
FAS-DATA-006
FAS-DATA-007
FAS-DATA-008
FAS-DATA-009
FAS-DATA-010

FAS-PROJ-001
FAS-PROJ-002
FAS-PROJ-003
FAS-PROJ-004
FAS-PROJ-006
FAS-PROJ-007
FAS-PROJ-008

FAS-EVENT-001
FAS-EVENT-002
FAS-EVENT-003
FAS-EVENT-004
FAS-EVENT-006
FAS-EVENT-007
FAS-EVENT-008
FAS-EVENT-009

FAS-HEAL-001
FAS-HEAL-002
FAS-HEAL-003
FAS-HEAL-004
FAS-HEAL-005
FAS-HEAL-006
FAS-HEAL-007
FAS-HEAL-008

FAS-OBS-007
FAS-OBS-008
~~~

Projection requirements remain CONDITIONAL on independent projections existing.

### 14.3 FAS-Extreme manifest

FAS-Extreme requires FAS-Native plus:

~~~text
FAS-UI-001
FAS-UI-002
FAS-UI-003
FAS-UI-004
FAS-UI-005
FAS-UI-006
FAS-UI-007

FAS-POLY-001
FAS-POLY-003
FAS-POLY-004
FAS-POLY-007

FAS-XZT-001
FAS-XZT-002
FAS-XZT-003
FAS-XZT-004
FAS-XZT-005
FAS-XZT-006
FAS-XZT-007
FAS-XZT-008
FAS-XZT-009

FAS-ID-001
FAS-ID-002
FAS-ID-003
FAS-ID-004
FAS-ID-005
FAS-ID-006
FAS-ID-007
FAS-ID-008

FAS-AUTH-001
FAS-AUTH-002
FAS-AUTH-003
FAS-AUTH-004
FAS-AUTH-007
FAS-AUTH-008
~~~

FAS-UI-002 and FAS-UI-006 are elevated to REQUIRED in FAS-Extreme.

Delegation-specific requirements become applicable when delegated autonomy exists.

## 15. Profile evaluation

Let R(P) be the set of applicable REQUIRED requirements for profile P after activation rules and profile overrides.

A profile passes only when every requirement in R(P) has status PASS.

For a conditional requirement, ActivationCondition=false permits NOT_APPLICABLE only with evidence.

If any applicable REQUIRED requirement has FAIL, NOT_VERIFIED or STALE, the profile MUST NOT PASS.

## 16. Targeting vs claiming

### FAS-CONF-019 — Target profile is not a claim
A system MAY state “Targeting FAS-Extreme” without yet conforming.

It MUST NOT state “FullAgenticStack Extreme conformant” unless FAS-Extreme evaluates to PASS.

### FAS-CONF-020 — Claim integrity
A public conformance claim SHOULD identify report identity, target fingerprint, evaluated profile, RFC set, assurance level and evaluation time.

## 17. Conformance report schema

A report SHOULD contain:

~~~text
ConformanceReport {
  report_id
  target
  profile_claimed
  profile_result
  assurance_level
  evaluator_identity
  rfc_set
  capability_inventory
  requirement_results[]
  coverage_metrics
  fingerprints
  evaluation_time
}
~~~

Each requirement result SHOULD contain:

~~~text
RequirementResult {
  requirement_id
  requirement_class
  activation_condition
  activation_result
  status
  evidence_refs[]
  verification_refs[]
  adversarial_test_refs[]
  notes
}
~~~

## 18. Conformance Agent procedure

A Conformance Agent SHOULD:

1. identify the target;
2. load the RFC set;
3. load the claimed profile manifest;
4. discover the capability inventory;
5. compute applicable requirements;
6. evaluate activation conditions;
7. collect existing evidence;
8. derive positive verification properties;
9. derive adversarial properties;
10. execute or inspect verification;
11. compute universal coverage;
12. detect masking;
13. detect drift and staleness;
14. assign requirement states;
15. compute profile result;
16. produce an evidence-backed report.

## 19. Required negative-test families

A conformance suite SHOULD attempt to:
- expose a user-facing capability unavailable through Intent;
- omit a required modality;
- cause a protected effect from interpretation alone;
- exceed delegated authority;
- reuse expired or out-of-scope authority;
- treat cache or projection as silent authority;
- publish command intent as if it were an occurred Event;
- omit or tamper with execution evidence;
- bypass required human approval;
- heal by weakening invariants;
- mask failing capability during testing;
- report unresolved execution as success;
- reuse stale conformance evidence after material drift.

## 20. Example result

~~~text
Target:
  system: ExampleSystem
  version: 3.4.1
  profile: FAS-Native
  artifact_fingerprint: abc...
  configuration_fingerprint: def...

FAS-INTENT-001
  class: REQUIRED
  status: PASS
  assurance: SELF_VERIFIED
  evidence: capability-inventory + intent-coverage
  coverage: 1.0

FAS-MULTI-001
  class: REQUIRED
  status: FAIL
  evidence: text=true, image=true, audio=false

FAS-PROJ-001
  class: CONDITIONAL
  activation: independent_projection_exists=false
  status: NOT_APPLICABLE
  evidence: architecture-inventory-17

FAS-RUNTIME-003
  class: REQUIRED
  status: PASS
  adversarial_test: protected-effect-without-authority rejected

FAS-DATA-010
  class: REQUIRED
  status: NOT_VERIFIED
  note: lineage evidence unavailable
~~~

## 21. Machine-actionable annotations

| Requirement | Class | Activation condition | Required evidence | Adversarial property |
|---|---|---|---|---|
| FAS-CONF-001 | REQUIRED | always | target identity/scope | result applies to ambiguous target |
| FAS-CONF-002 | REQUIRED | exclusions_exist | exclusion manifest | failing area is silently excluded |
| FAS-CONF-003 | REQUIRED | NOT_APPLICABLE_used | activation evidence | N/A used without false activation condition |
| FAS-CONF-004 | REQUIRED | profile_requires_capability | profile manifest + capability inventory | missing required capability is marked N/A |
| FAS-CONF-005 | REQUIRED | PASS_assigned | sufficient evidence | PASS exists without evidence |
| FAS-CONF-006 | CONDITIONAL | critical_evidence_used | integrity evidence | altered evidence remains accepted |
| FAS-CONF-007 | CONDITIONAL | human_attestation_used_for_machine_verifiable_critical_requirement | alternate machine evidence or justification | attestation alone grants PASS |
| FAS-CONF-008 | REQUIRED | conformance_report_created | evaluator/assurance identity | verification origin is undisclosed |
| FAS-CONF-009 | REQUIRED | PASS_assigned | traceability chain | PASS cannot map to implementation/test/evidence |
| FAS-CONF-010 | REQUIRED | evidence_missing | NOT_VERIFIED status | evaluator infers success |
| FAS-CONF-011 | REQUIRED | reproducibility_practical | test/evidence references | another evaluator cannot reproduce |
| FAS-CONF-012 | REQUIRED | capability_under_test | masking detection | capability disabled to avoid failure |
| FAS-CONF-013 | REQUIRED | applicable_requirement | positive verification | no compliant behavior property exists |
| FAS-CONF-014 | CONDITIONAL | critical_requirement | adversarial verification | invariant never tested against violation |
| FAS-CONF-015 | REQUIRED | universal_requirement | complete capability inventory | inventory omits exposed capability |
| FAS-CONF-016 | REQUIRED | universal_requirement | coverage metric | sample success is generalized to universal PASS |
| FAS-CONF-017 | REQUIRED | fingerprinting_practical | artifact/config fingerprints | result cannot be tied to evaluated artifact |
| FAS-CONF-018 | REQUIRED | material_drift_detected | drift evidence | stale PASS remains valid |
| FAS-CONF-019 | REQUIRED | target_profile_not_yet_passed | claim text + report | target profile is presented as conformance |
| FAS-CONF-020 | REQUIRED | public_claim_made | public report metadata | claim omits profile/version/evidence identity |

## Agent implementation guidance

A Conformance Agent MUST treat semantic requirements and profile manifests as authoritative.

It MUST NOT “fix” conformance by changing requirement meaning, removing required capability, weakening invariants, redefining authority, or hiding evidence.

Technology choice remains non-normative except where a Technology Profile explicitly constrains the target.

## Compatibility and evolution

Changes to profile manifests, requirement states, evidence semantics or PASS computation are conformance-significant and SHOULD increment this RFC's minor or major version according to compatibility impact.

Stable requirement identifiers MUST NOT silently change semantic meaning.


## 22. Generated semantic lockfile protocol

The `implemented/manifest.yml` file is a generated semantic lockfile.

### FAS-CONF-021 — Manifest generation
The manifest MUST be reproducibly generated from:
- normalized semantic requirements;
- implementation annotations or discovered source bindings;
- executable test bindings;
- asserted evidence bindings;
- evaluated non-applicability declarations.

A handwritten `status: implemented` field MUST NOT be accepted as sufficient implementation evidence.

### FAS-CONF-022 — Requirement-level statement hash
Each normative requirement MUST have an independent statement fingerprint.

The current reference implementation uses BLAKE3 over the normalized requirement identifier, title and normative statement body.

Semantic staleness is requirement-local:

~~~text
verified_against == statement_hash
    => semantic statement unchanged since verification

verified_against != statement_hash
    => STALE
~~~

A change to one requirement MUST NOT automatically make unrelated requirements STALE.

### FAS-CONF-023 — Implementation status vocabulary
The generated implementation lockfile uses:

- **implemented**
- **partial**
- **not_implemented**
- **not_applicable**
- **stale**

`not_applicable` is valid only for a CONDITIONAL requirement whose ActivationCondition has been evaluated false and whose justification is recorded.

`partial` means some implementation/test/evidence binding exists but the requirement cannot yet be claimed complete.

### FAS-CONF-024 — Reference existence verification
Every generated source and test reference MUST resolve to an existing artifact during lock verification.

Missing, renamed or deleted referenced artifacts MUST invalidate or downgrade the affected requirement.

### FAS-CONF-025 — Evidence assertion requirement
For machine-verifiable evidence obligations, conformance MUST assert evidence production.

For example, testing only that execution returns `GovernanceRejected` is insufficient when the requirement also requires governance evidence.

A conforming executable proof SHOULD assert both semantic outcome and evidence:

~~~zig
try expectError(error.GovernanceRejected, runtime.execute(&ctx));
try harness.expectEmitted("Governance.Rejected");
~~~

### FAS-CONF-026 — Build visibility
Every committed executable conformance source MUST be reachable from an explicit build or CI target.

For the Zig reference profile:

~~~text
zig build conformance
~~~

MUST compile and execute all RFC conformance suites.

### FAS-CONF-027 — Descriptive binding non-authority
`implementation/bindings.yml` is descriptive planning metadata.

It MAY map semantic requirements to conceptual components, but it MUST NOT independently establish conformance.

The generated manifest is the authoritative implementation binding artifact.

CI SHOULD verify that any requirement identifiers appearing in descriptive bindings exist in the generated lockfile.

## 23. Lockfile generation workflow

Reference workflow:

~~~text
semantic.md
   ↓ parse normative requirements
normalize each requirement
   ↓
BLAKE3 per requirement
   ↓
scan source/test annotations
   ↓
verify referenced artifacts exist
   ↓
derive implementation status
   ↓
assert evidence bindings
   ↓
generate implemented/manifest.yml
   ↓
run conformance tests
   ↓
record verified_against after successful verification
~~~

The lockfile generator SHOULD support:

~~~text
--write
--check
~~~

`--write` regenerates lockfiles.

`--check` MUST fail when committed lockfiles cannot be reproduced from current semantic/source/test state.

## 24. Requirement-local drift example

Before semantic change:

~~~yaml
FAS-RUNTIME-003:
  statement_hash: blake3:aaa
  verified_against: blake3:aaa
  status: implemented
~~~

After FAS-RUNTIME-003 changes normatively:

~~~yaml
FAS-RUNTIME-003:
  statement_hash: blake3:bbb
  verified_against: blake3:aaa
  status: stale
~~~

Unchanged neighboring requirements retain their verified state.

## 25. Conditional implementation example

~~~yaml
FAS-PROJ-001:
  statement_hash: blake3:...
  verified_against: null
  status: not_applicable
  not_applicable:
    activation_condition: "independent_projection_exists:false"
    justification: "no_independent_projections"
~~~

A missing capability required by the selected conformance profile MUST NOT use this mechanism to escape verification.
