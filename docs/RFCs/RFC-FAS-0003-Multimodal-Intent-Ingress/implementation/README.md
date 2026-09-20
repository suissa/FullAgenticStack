# RFC-FAS-0003 — Multimodal Ingress Implementation Profile

**Pairs with:** RFC-FAS-0003-Multimodal-Intent-Ingress.semantic.md

## Required modalities

The reference implementation MUST support:
- text;
- audio;
- image.

Additional modalities MAY be added without changing the Intent contract.

## Gateway model

A **GatewayAgent** receives public requests and passes modality payloads to bounded modality-specific Actions.

Preferred semantic decomposition:

```text
GatewayAgent
  ├─ Text.Normalize
  ├─ Audio.TranscribeAndNormalize
  └─ Image.ExtractAndNormalize
          ↓
      IntentResolver
```

The modality Actions extract semantic content; they do not grant business authority.

## WhatsApp-First profile

WhatsApp is a first-class ingress surface in the reference architecture.

Supported message forms SHOULD include:
- text messages;
- voice/audio messages;
- images/photos;
- documents when available.

WhatsApp-specific transport details MUST terminate before canonical Intent resolution.

## Web/A2UI profile

Web clients MAY submit text, microphone audio, camera/uploaded images and A2UI interaction context through the same Intent gateway.

## Media processing

Python MAY be used for model-heavy audio/image processing. TypeScript MAY be used in gateway/web layers. Zig remains responsible for Runtime semantic execution after normalized input reaches the Runtime boundary.

## Data minimization

Raw media SHOULD be retained only as long as needed by project requirements, compliance and evidence policy.

Derived semantic content SHOULD preserve source correlation without forcing full raw-media replication into every subsystem.

## Tests

Implementation Agents SHOULD produce:
- same-goal text/audio/image equivalence cases;
- unreadable/unintelligible media cases;
- conflicting multimodal input cases;
- uncertainty propagation tests;
- tests proving media extraction cannot directly trigger protected effects.
