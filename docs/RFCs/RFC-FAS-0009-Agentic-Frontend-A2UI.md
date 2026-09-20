# RFC-FAS-0009 — Agentic Frontend and A2UI

Status: Draft Standard  
Category: Standards Track  
Version: 0.1.0

## Principle

The frontend is a semantic projection of user intent and system state, not necessarily a fixed catalog of screens.

### FAS-UI-001
Every user-facing frontend capability MUST have an equivalent natural-language Intent path.

### FAS-UI-002
A FullAgenticStack frontend MAY be generated or adapted dynamically by Agents.

### FAS-UI-003
A UI Agent MUST NOT gain additional business authority merely because it renders or collects user interaction.

### FAS-UI-004
Dynamic UI descriptions SHOULD preserve semantic links to the Intents and capabilities they expose.

### FAS-UI-005
A2UI or any equivalent Agent-to-User-Interface mechanism MAY be used. No specific UI protocol is required by this RFC.

### FAS-UI-006
The system SHOULD be able to represent the same capability through conversational, visual or mixed interaction without changing the underlying Intent contract.
