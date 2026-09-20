# RFC-FAS-0014 — Passwordless Agentic Identity Implementation Profile

**Pairs with:** RFC-FAS-0014-Passwordless-Agentic-Identity.semantic.md

## Human identity

The reference FullAgenticStack Extreme implementation is **passwordless by construction**.

Preferred human authentication:
- **Passkeys / WebAuthn** as the primary cryptographic authentication mechanism;
- device-bound credentials;
- proof-of-possession;
- WhatsApp as a communication/confirmation surface where appropriate.

Reusable passwords are not part of the architecture.

Email is not a required identity anchor.

## WhatsApp-first identity

Reference passwordless flow may use:

```text
phone / WhatsApp identity context
  ↓
WhatsApp magic interaction
  ↓
Passkey/WebAuthn
  ↓
WhatsApp confirmation when policy requires
```

SMS MAY exist only as a constrained fallback where project policy permits it.

## Agent identity

Agents SHOULD have cryptographically attributable identities.

Preferred primitives:
- Ed25519 signing identities;
- mTLS service identity;
- DPoP/proof-of-possession;
- short-lived scoped credentials;
- device/hardware-backed keys when available.

## Identity vs authority

Identity proves who/what is acting.

Authorization remains a separate Runtime/Governor decision.

No Agent receives unrestricted human authority simply by representing that human.

## Recovery

Recovery MUST preserve passwordless guarantees.

Preferred recovery combines:
- existing trusted device/passkey;
- verified communication channel;
- human confirmation;
- revocation and re-issuance of credentials.

## No-email rule

Email MAY exist as an optional notification channel if a project wants it.

It MUST NOT be required for:
- account identity;
- login;
- password reset;
- privileged recovery.

## Tests

Implementation Agents SHOULD prove:
- no password route exists;
- email is not mandatory;
- possession of phone/WhatsApp alone is insufficient for high-risk protected effects;
- authentication does not imply authorization;
- Agent credentials are scoped and attributable;
- revoked credentials stop working.
