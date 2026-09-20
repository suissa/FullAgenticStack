# FullAgenticStack RFC Series

Each RFC is a self-contained directory with three layers:

```text
RFC-FAS-NNNN-Name/
├── semantic.md
├── implementation/
│   ├── README.md
│   ├── architecture.mmd
│   ├── technology.yml
│   └── bindings.yml
└── implemented/
    ├── conformance.zig
    ├── manifest.yml
    ├── tests.yml
    └── evidence.yml
```

## Authority and precedence

```text
semantic.md
    ↓ normative authority
implementation/
    ↓ chosen reference realization
implemented/
    ↓ proof/bindings/evidence of actual realization
real source code
```

If layers disagree, `semantic.md` wins.

The implementation profile MAY be adapted to a project's goal and Technology Profile, but MUST preserve the semantic requirements.

## Why implemented/ does not duplicate product code

`implemented/` is a semantic lockfile/proof layer. It does not contain a second copy of the product implementation.

- `manifest.yml` binds the RFC to real source/test artifacts.
- `conformance.zig` is the executable conformance reference.
- `tests.yml` binds/derives positive and adversarial tests.
- `evidence.yml` records verification evidence.

A target project MUST populate `real_source_bindings` and evidence after implementation.

## Drift rule

CI SHOULD compute fingerprints for `semantic.md` and `implementation/`.

If either materially changes after verification:

```text
PASS → STALE
```

until conformance is re-run and `implemented/manifest.yml` is refreshed.

## Agent read order

An implementation Agent SHOULD read:

1. project goal;
2. all applicable RFC `semantic.md` files;
3. paired `implementation/README.md`;
4. `implementation/architecture.mmd`;
5. `implementation/technology.yml`;
6. `implementation/bindings.yml`;
7. existing project source/config/tests;
8. `implemented/manifest.yml`, `tests.yml`, and `evidence.yml` if present.

Then it should:

```text
discover capabilities
→ map semantic requirements
→ adapt technology bindings
→ implement real source
→ generate positive tests
→ generate adversarial tests
→ instrument evidence
→ bind real source in manifest
→ run conformance
→ update evidence/fingerprints
```

## Scope rule

This structure is intended for architectural/cross-system RFCs, not every small feature.

```text
RFC         = architectural/cross-system contract
Issue       = bounded feature/change
Atomic Skill= reusable Action knowledge
Test        = executable invariant
PR          = concrete code change
```

## RFC directories

- [RFC-FAS-0000 — Semantic First Agent Readable Specification](./RFC-FAS-0000-Semantic-First-Agent-Readable-Specification/)
- [RFC-FAS-0001 — Core Architecture](./RFC-FAS-0001-Core-Architecture/)
- [RFC-FAS-0002 — Intent as Universal Interface](./RFC-FAS-0002-Intent-as-Universal-Interface/)
- [RFC-FAS-0003 — Multimodal Intent Ingress](./RFC-FAS-0003-Multimodal-Intent-Ingress/)
- [RFC-FAS-0004 — Agentic Runtime](./RFC-FAS-0004-Agentic-Runtime/)
- [RFC-FAS-0005 — Agent Actor Action](./RFC-FAS-0005-Agent-Actor-Action/)
- [RFC-FAS-0006 — Agentic Data Architecture](./RFC-FAS-0006-Agentic-Data-Architecture/)
- [RFC-FAS-0007 — Agent per Projection](./RFC-FAS-0007-Agent-per-Projection/)
- [RFC-FAS-0008 — Agentic Event Architecture](./RFC-FAS-0008-Agentic-Event-Architecture/)
- [RFC-FAS-0009 — Agentic Frontend A2UI](./RFC-FAS-0009-Agentic-Frontend-A2UI/)
- [RFC-FAS-0010 — Polyglot Agent Actions](./RFC-FAS-0010-Polyglot-Agent-Actions/)
- [RFC-FAS-0011 — Agentic Observability](./RFC-FAS-0011-Agentic-Observability/)
- [RFC-FAS-0012 — Self Healing Supervision](./RFC-FAS-0012-Self-Healing-Supervision/)
- [RFC-FAS-0013 — eXtreme Zero Trust](./RFC-FAS-0013-eXtreme-Zero-Trust/)
- [RFC-FAS-0014 — Passwordless Agentic Identity](./RFC-FAS-0014-Passwordless-Agentic-Identity/)
- [RFC-FAS-0015 — Human Agent Authority](./RFC-FAS-0015-Human-Agent-Authority/)
- [RFC-FAS-0016 — Conformance](./RFC-FAS-0016-Conformance/)
- [RFC-FAS-0017 — Maturity Levels](./RFC-FAS-0017-Maturity-Levels/)
