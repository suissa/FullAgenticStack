# RFC-FAS-0010 — Polyglot Agent Actions

Status: Draft Standard  
Category: Standards Track  
Version: 0.1.0

## Principle

Implementation language is a binding decision, not part of Action semantics.

### FAS-POLY-001
An Agent or Action MUST NOT be semantically defined by its programming language.

### FAS-POLY-002
Different Actions belonging to the same Agent MAY use different implementation technologies.

### FAS-POLY-003
The Runtime MUST reason over semantic contracts rather than language identity.

### FAS-POLY-004
An implementation Agent MAY choose technologies according to developer constraints and Action requirements.

### FAS-POLY-005
Technology changes MUST NOT alter Intent identity, Action semantics, authority boundaries or evidence obligations.

### FAS-POLY-006
The developer MAY explicitly constrain language, runtime, deployment or interoperability requirements outside the semantic RFC.
