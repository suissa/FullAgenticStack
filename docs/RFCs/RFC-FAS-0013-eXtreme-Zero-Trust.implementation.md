# RFC-FAS-0013 — eXtreme Zero Trust Implementation Profile

**Pairs with:** RFC-FAS-0013-eXtreme-Zero-Trust.semantic.md

## Reference security posture

The FullAgenticStack Extreme profile assumes no implicit trust between humans, Agents, Runtime stages, data responsibilities, services, devices or infrastructure.

## Transport

Preferred internal/external security mechanisms include:
- **QUIC** where appropriate;
- **TLS 1.3**;
- **mutual TLS (mTLS)** for service/Agent mutual authentication;
- **DPoP** or equivalent proof-of-possession for bearer-token hardening;
- short-lived scoped credentials.

## Cryptographic profile

Current preferred primitives:
- **XChaCha20-Poly1305** — authenticated encryption where suitable;
- **Ed25519** — signatures/identity;
- **X25519** — key agreement;
- **HKDF-SHA-256** — key derivation;
- **BLAKE3** and/or **SHA-256** — fingerprints/hashing according to compatibility requirements;
- **HMAC-SHA-256** — keyed integrity where needed;
- **ML-KEM** — post-quantum key-establishment capability where the deployment profile enables PQC.

Specific cryptography remains subordinate to the semantic RFC and security review.

## Network/security Agents

Reference infrastructure includes:
- **UbiQEdgeWall** for L4/edge enforcement, implemented with Zig/eBPF/XDP where supported;
- **UbiQSemanticWall** for L7 semantic/policy enforcement.

## Runtime controls

Every protected Action SHOULD receive:
- authenticated subject;
- Agent identity;
- authority scope;
- proof-of-possession where required;
- correlation/evidence identity;
- policy context.

## Resilience security

Runtime and network boundaries SHOULD apply:
- rate limits;
- bulkheads;
- circuit breakers;
- bounded retries;
- replay protection.

These mechanisms MUST NOT silently become authorization substitutes.

## Secrets

**Infisical** is the preferred secrets-management binding in the polyglot data/infrastructure profile.

Secrets MUST NOT be embedded in Agent prompts, telemetry or generated source.

## Tests

Implementation Agents SHOULD generate:
- untrusted internal Agent tests;
- expired authority tests;
- replay tests;
- scope escalation tests;
- stolen token without proof-of-possession tests;
- mTLS/identity mismatch tests;
- semantic firewall policy tests.
