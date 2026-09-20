# RFC-FAS-0003 — Multimodal Intent Ingress

**Status:** Draft Standard  
**Category:** Standards Track  
**Version:** 0.2.0  
**Last Updated:** 2026-09-20  
**Dependencies:** RFC-FAS-0000, RFC-FAS-0001, RFC-FAS-0002

Normative keywords **MUST**, **MUST NOT**, **SHOULD**, **SHOULD NOT**, and **MAY** define requirement strength.


## 1. Purpose

Human intent is not limited to typed text. FullAgenticStack treats modality as an input representation, not as a separate business authority.

## 2. Minimum modality set

### FAS-MULTI-001 — Required modalities
A conforming FullAgenticStack Core implementation MUST accept text, audio and image as human request inputs.

### FAS-MULTI-002 — Semantic convergence
All required modalities MUST converge toward the same semantic Intent model.

### FAS-MULTI-003 — Goal preservation
A modality processor MUST preserve the user's expressed semantic objective.

### FAS-MULTI-004 — No modality authority
Extracting or interpreting modality content MUST NOT itself grant authority to cause business effects.

### FAS-MULTI-005 — Equivalent meaning
Equivalent meaning expressed through different modalities SHOULD resolve to equivalent canonical Intent.

### FAS-MULTI-006 — Extended modalities
A system MAY support video, documents, sensors, device streams, location signals and other modalities.

## 3. Semantic stages

Raw modality → modality interpretation → semantic representation → Intent resolution → authority evaluation → execution.

Implementations MAY merge physical stages, but the semantic boundaries MUST remain distinguishable.

## 4. Inputs and outputs

Input consists of a modality payload and available context.

Output consists of semantic content suitable for Intent resolution or an explicit modality failure.

## 5. Invariants

- modality MUST NOT change the authority model;
- processors MUST NOT invent material missing user intent;
- uncertainty that can alter execution SHOULD remain observable;
- multimodal context MAY enrich Intent but MUST NOT silently replace the goal.

## 6. Failure semantics

- **UnreadableInput**
- **UnintelligibleAudio**
- **InsufficientVisualEvidence**
- **ConflictingModalities**
- **UnsupportedModality**
- **ExtractionUncertain**

## 7. Evidence

The architecture SHOULD preserve modality type, source correlation, derived semantic representation, material uncertainty and transformations affecting interpretation.

## 8. Normative example

A photo of an invoice plus the text “pay this tomorrow” combines entity extraction from the image with a payment Intent and temporal constraint from text.

## 9. Non-conforming example

A processor detects a payment document in an image and executes payment without a payment Intent or delegated authority.

## Agent implementation guidance

An implementation Agent MUST treat semantic requirements as authoritative and technology choices as bindings. It MAY choose languages, libraries, data engines, protocols, process boundaries and deployment topology when those choices preserve every normative invariant.

The Agent SHOULD maintain traceability from RFC requirement to semantic capability, implementation artifact, verification test and runtime evidence.

## Compatibility and evolution

Minor revisions MAY clarify wording without silently changing the meaning of stable requirement identifiers. Breaking semantic changes SHOULD receive new identifiers or a new major version.
