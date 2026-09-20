# RFC-FAS-0000 — Semantic-First and Agent-Readable Specification Model

**Status:** Draft Standard  
**Category:** Standards Track  
**Version:** 0.4.0  
**Last Updated:** 2026-09-20  
**Dependencies:** None

Normative keywords **MUST**, **MUST NOT**, **SHOULD**, **SHOULD NOT**, and **MAY** define requirement strength.


## 1. Scope

This RFC governs how the FullAgenticStack RFC series is written and interpreted. The specifications are intended for both human readers and AI Agents that plan, implement, review and verify software.

## 2. Governing principle

**Specify semantics first. Bind technology later.**

A semantic RFC defines what a capability means, what it owns, what it may change, what it must preserve, what evidence it must produce, and how conformity can be evaluated.

A semantic RFC does not prescribe programming language, database, framework, cloud, broker, vendor or library unless that technology is itself being standardized.

## 3. Human-readable and Agent-readable language

Normative text MUST remain understandable by a human reviewer and sufficiently explicit for an AI Agent to derive an implementation plan without hidden architectural assumptions.

Statements such as “handle intelligently” or “use the best approach” SHOULD NOT be normative because they omit the obligation, boundary and success condition.

A normative statement SHOULD make clear:
- the semantic subject;
- required or prohibited behavior;
- relevant authority boundary;
- preserved invariant;
- observable result or evidence where applicable.

## 4. Semantic entities

Terms such as Intent, Agent, Actor, Behavior, Action, Capability, Event, Projection, Policy, Constraint, Proof, Evidence, Supervisor, Runtime, Context and Authority describe semantic roles.

They MUST NOT implicitly require a particular implementation construct.

Examples:
- Agent is not necessarily a class or process.
- Event is not necessarily a broker message.
- Projection is not necessarily a SQL view.
- Runtime is not necessarily one executable process.

## 5. Normative requirements

### FAS-SPEC-001 — Semantic completeness
Every normative capability MUST define enough information for an implementation Agent to identify responsibility, inputs, outputs, invariants, authority and evidence obligations.

### FAS-SPEC-002 — Technology independence
A normative requirement MUST NOT require a specific implementation product or language unless that technology is explicitly in scope.

### FAS-SPEC-003 — Stable meaning
A semantic requirement SHOULD retain its meaning when the implementation technology changes.

### FAS-SPEC-004 — Explicit authority
If a capability can cause protected effects, its authority boundary MUST be explicit.

### FAS-SPEC-005 — Explicit failure semantics
A normative capability SHOULD define semantic failure conditions rather than relying only on implementation exceptions.

### FAS-SPEC-006 — Stable identifiers
Normative requirements SHOULD have persistent identifiers that Agents can reference directly.

### FAS-SPEC-007 — Traceability
A conforming implementation SHOULD support requirement → capability → implementation → test → runtime evidence traceability.

### FAS-SPEC-008 — Behavioral conformance
Conformance MUST be based primarily on observable semantic behavior and invariant preservation, not product choice.

### FAS-SPEC-009 — Developer bindings
A developer MAY provide a Technology Profile defining implementation constraints.

### FAS-SPEC-010 — Agent freedom
An implementation Agent MAY choose mechanisms not named by the RFC if all required semantics remain preserved.

## 6. Technology Profile boundary

The RFC answers:
- What capability must exist?
- What does it mean?
- What may it do?
- What must it never do?
- What must it preserve?
- How do we verify it?

A Technology Profile answers:
- Which language?
- Which runtime?
- Which data engine?
- Which transport?
- Which deployment constraints?

## 7. Failure semantics

Specification-level failures include:
- **UnderspecifiedRequirement** — implementation requires inventing material semantics.
- **TechnologyLeakage** — normative semantics are unnecessarily tied to a product.
- **AuthorityAmbiguity** — a protected effect has no defined authority boundary.
- **UntestableInvariant** — a claimed invariant has no observable verification path.

## 8. Normative example

Conforming semantic requirement:

“A Vector capability MUST support retrieval according to semantic proximity within a representation space.”

Non-conforming semantic requirement:

“The system MUST use a named vector database product.”

The latter belongs in a Technology Profile.

## 9. Machine interpretation

An Agent SHOULD be able to normalize a requirement into:
- subject;
- obligation;
- constraints;
- dependencies;
- failure conditions;
- evidence;
- verification.

No private knowledge from the specification author’s implementation should be required.

## 10. Machine-actionable requirement model

Every normative requirement SHOULD expose explicit metadata sufficient for deterministic evaluation by an Agent.

### FAS-SPEC-011 — Requirement class
Each normative requirement SHOULD declare one of:

- **REQUIRED** — must be evaluated whenever the containing conformance profile includes it.
- **CONDITIONAL** — must be evaluated when its ActivationCondition is true.
- **OPTIONAL** — does not block profile conformance unless a profile explicitly elevates it.

RequirementClass is distinct from MUST/SHOULD/MAY wording. The normative verb defines obligation strength inside the requirement; RequirementClass defines profile applicability.

### FAS-SPEC-012 — Activation condition
CONDITIONAL requirements MUST define a machine-evaluable or semantically explicit ActivationCondition.

Example:

```text
Requirement: FAS-PROJ-001
Class: CONDITIONAL
ActivationCondition:
  independent_projection_exists == true
```

### FAS-SPEC-013 — Required evidence
A requirement SHOULD define the minimum evidence class needed to support PASS.

### FAS-SPEC-014 — Verification property
A requirement SHOULD define at least one observable property whose satisfaction supports PASS.

### FAS-SPEC-015 — Adversarial property
Security-, authority-, integrity-, healing- and conformance-critical requirements SHOULD define at least one negative or adversarial property that attempts to falsify the invariant.

### FAS-SPEC-016 — Non-applicability
A CONDITIONAL requirement MAY become NOT_APPLICABLE only when its ActivationCondition is demonstrably false.

NOT_APPLICABLE MUST NOT be used merely because implementation or evidence is missing.

### FAS-SPEC-017 — No capability masking
A requirement MUST NOT be satisfied by removing, disabling, hiding, short-circuiting or making unreachable the behavior being evaluated when that behavior is required by the claimed profile.

### FAS-SPEC-018 — Profile elevation
A conformance profile MAY elevate OPTIONAL or CONDITIONAL requirements to REQUIRED for that profile. Such elevation MUST be explicit in the profile manifest.

## 11. Canonical requirement metadata

The canonical semantic fields are:

```text
RequirementMetadata {
  requirement_id
  requirement_class
  activation_condition
  verification_property
  required_evidence
  adversarial_property
  profile_overrides
}
```

A human-readable table is acceptable when the same fields are unambiguous.

## 12. Evidence classes

RFCs and conformance profiles MAY require one or more of:

- **StaticEvidence** — declarations, schemas, contracts, source structure or configuration.
- **TestEvidence** — reproducible positive, negative, property or conformance tests.
- **RuntimeEvidence** — observed execution traces, events, proofs or state transitions.
- **FormalEvidence** — proof artifacts, model checking, theorem or invariant verification.
- **HumanAttestation** — explicit human assertion when machine verification is unavailable or inappropriate.

HumanAttestation alone SHOULD NOT satisfy a requirement whose semantics are directly machine-verifiable and security- or authority-critical.

## 13. Verification-oriented wording

A normative requirement SHOULD be expressible as:

```text
Given <precondition/context>
When <semantic action or observation>
Then <required property>
And NOT <forbidden/adversarial property>
Evidence <required evidence class>
```

This form is recommended because an implementation Agent can derive tests and evidence collectors from it without requiring a particular programming language.

## 14. Semantic executability

The long-term objective of the RFC series is semantic executability:

```text
RFCs
  + Technology Profile
  + Project Context
      ↓
Implementation Agent
      ↓
Implementation
      ↓
Conformance Agent
      ↓
Requirement evaluation
      ↓
Evidence-backed report
```

“Executable” in this context does not mean that RFC prose is source code. It means the semantics are explicit enough for an Agent to deterministically derive implementation obligations and verification properties.

## Agent implementation guidance

An implementation Agent MUST treat semantic requirements as authoritative and technology choices as bindings. It MAY choose languages, libraries, data engines, protocols, process boundaries and deployment topology when those choices preserve every normative invariant.

The Agent SHOULD maintain traceability from RFC requirement to semantic capability, implementation artifact, verification test and runtime evidence.

## Compatibility and evolution

Minor revisions MAY clarify wording without silently changing the meaning of stable requirement identifiers. Breaking semantic changes SHOULD receive new identifiers or a new major version.


## 15. Machine-actionable requirement annotations

| Requirement | Class | Activation condition | Required evidence | Adversarial property |
|---|---|---|---|---|
| FAS-SPEC-001 | REQUIRED | normative_capability_exists | requirement semantic fields | implementation requires inventing material semantics |
| FAS-SPEC-002 | REQUIRED | always | technology-neutral wording | normative requirement unnecessarily binds a product/language |
| FAS-SPEC-003 | REQUIRED | implementation_binding_changes | cross-binding semantic comparison | semantic meaning changes with technology |
| FAS-SPEC-004 | REQUIRED | protected_effect_possible | authority declaration | protected effect has undefined authority boundary |
| FAS-SPEC-005 | REQUIRED | capability_can_fail | semantic failure definitions | only opaque implementation exception exists |
| FAS-SPEC-006 | REQUIRED | normative_requirement_exists | stable ID registry | requirement cannot be stably referenced |
| FAS-SPEC-007 | REQUIRED | conformance_or_implementation_claim_exists | traceability chain | requirement cannot map to test/evidence |
| FAS-SPEC-008 | REQUIRED | conformance_evaluated | behavior/invariant evidence | product choice substitutes for semantic verification |
| FAS-SPEC-009 | OPTIONAL | developer_constraints_exist | Technology Profile | implementation Agent ignores explicit constraints |
| FAS-SPEC-010 | OPTIONAL | technology_not_fully_bound | implementation rationale | Agent changes semantics to fit preferred technology |
| FAS-SPEC-011 | REQUIRED | normative_requirement_exists | requirement metadata | applicability cannot be determined |
| FAS-SPEC-012 | CONDITIONAL | requirement_class=CONDITIONAL | activation condition | N/A can be assigned without a false condition |
| FAS-SPEC-013 | REQUIRED | normative_requirement_exists | evidence declaration | PASS has no evidence basis |
| FAS-SPEC-014 | REQUIRED | normative_requirement_exists | verification property | requirement cannot be tested positively |
| FAS-SPEC-015 | CONDITIONAL | requirement_is_critical | adversarial property | invariant is never challenged negatively |
| FAS-SPEC-016 | REQUIRED | NOT_APPLICABLE_possible | non-applicability evidence | missing feature is laundered as N/A |
| FAS-SPEC-017 | REQUIRED | conformance_evaluated | masking detection | capability is disabled to avoid failure |
| FAS-SPEC-018 | CONDITIONAL | profile_override_exists | profile manifest | profile silently changes requirement class |


## 16. Generated semantic lockfiles

### FAS-SPEC-019 — Generated semantic lockfiles
The implemented manifest MUST be generated from semantic requirements and implementation evidence. It MUST NOT be treated as a manually authoritative declaration.

A generated lockfile MAY be committed to version control, but CI MUST be able to regenerate it deterministically and detect divergence.

### FAS-SPEC-020 — Requirement-level fingerprints
Semantic drift MUST be tracked at requirement granularity rather than only at file granularity.

Each normative requirement SHOULD have a fingerprint computed from its normalized normative statement.

Editorial changes that do not change the normalized statement SHOULD NOT invalidate unrelated requirements.

### FAS-SPEC-021 — Source-derived implementation binding
Implementation status SHOULD be derived from verifiable implementation annotations, source references, tests and evidence rather than handwritten status fields.

A missing source or test reference MUST invalidate the generated implementation claim.

### FAS-SPEC-022 — Asserted evidence
Evidence obligations MUST be verified by executable assertions where machine verification is practical.

Listing an event name or proof identifier without asserting that it was produced MUST NOT satisfy an evidence-critical requirement.

### FAS-SPEC-023 — Build-visible conformance
Executable conformance proofs MUST participate in the project build or CI graph.

A conformance source file that is never compiled or executed MUST NOT count as verification.

### FAS-SPEC-024 — Single authoritative implementation chain
Implementation planning metadata MAY describe conceptual components, but conformance authority MUST come from one generated chain connecting requirement → real source → test → evidence.

If descriptive bindings and generated implementation bindings diverge, CI MUST fail or report the divergence explicitly.

## 17. Recommended implementation annotations

Projects MAY expose source-level annotations such as:

~~~text
// @satisfies FAS-RUNTIME-003
// @test FAS-RUNTIME-003
// @evidence FAS-RUNTIME-003 Governance.Rejected
~~~

Conditional non-applicability MAY be expressed as:

~~~text
// @not-applicable FAS-PROJ-001 condition=independent_projection_exists:false reason=no_independent_projections
~~~

A NOT_APPLICABLE annotation MUST include both the evaluated activation condition and a justification.

## 18. Normalized statement hashing

The fingerprint input SHOULD include the requirement identifier, title and normative body after normalization.

Normalization SHOULD:
- trim leading/trailing whitespace;
- collapse semantically irrelevant whitespace;
- preserve normative words and semantic content;
- exclude unrelated neighboring requirements.

The recommended fingerprint algorithm for the current reference implementation is BLAKE3.

A conformance system SHOULD preserve:

~~~text
requirement_id
statement_hash
verified_against
status
~~~

If `verified_against != statement_hash`, a previously verified requirement becomes STALE until revalidated.
