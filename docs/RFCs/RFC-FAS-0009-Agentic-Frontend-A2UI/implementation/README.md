# RFC-FAS-0009 — Agentic Frontend and A2UI Implementation Profile

**Pairs with:** RFC-FAS-0009-Agentic-Frontend-A2UI.semantic.md

## Highest-level frontend profile

The preferred highest-maturity interface is **A2UI**: Agents describe the user interface required for the current Intent/context and the frontend renders it.

The frontend is therefore a projection of semantic state, not the owner of business behavior.

## UIAgent

A **UIAgent** owns:
- semantic UI state;
- available user capabilities;
- A2UI structures;
- presentation adaptation;
- local/offline state;
- correlation between UI actions and Intents.

It MUST NOT own protected domain authority merely because it renders controls.

## GatewayAgent

A **GatewayAgent** terminates external human channels, including web and WhatsApp-first surfaces, and forwards normalized requests into the Runtime Intent path.

## Web implementation

Preferred web stack: **TypeScript**.

The exact UI framework is project-specific.

The client SHOULD:
- render Agent-described interface structures;
- support text/audio/image input;
- work offline-first where practical;
- retain bounded local state;
- synchronize semantic events with the backend.

## Realtime synchronization

Preferred mechanisms:
- WebSocket for bidirectional live synchronization;
- SSE/NDJSON for streaming events/evidence where one-way streaming is sufficient.

UI state SHOULD be updated from semantic events rather than arbitrary database polling.

## Offline-first

The UI MAY maintain local projections. These are derived state and MUST NOT silently become authoritative.

On reconnection, the UIAgent reconciles local and authoritative semantic state.

## Command-oriented UX

A FullAgenticStack UI SHOULD permit all exposed operations through natural language, even if A2UI also presents visual controls.

The reference UX may minimize fixed buttons and use commands/intents plus context-specific generated controls.

## WhatsApp-first

WhatsApp MAY be the primary human interface. Web/A2UI then acts as a richer report/visualization/interaction surface over the same canonical Intents.

## Tests

Implementation Agents SHOULD verify:
- every visual capability has Intent equivalence;
- A2UI descriptions map to real capabilities;
- confirmation text matches protected effects;
- stale UI cannot silently authorize actions;
- offline state cannot override canonical authority.
