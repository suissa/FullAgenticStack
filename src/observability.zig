pub const EvidenceKind = enum { log, metric, trace, event, proof };

pub const Evidence = struct {
    correlation_id: []const u8,
    intent: []const u8,
    agent: []const u8,
    action: []const u8,
    authority_decision: []const u8,
    outcome: []const u8,
    kind: EvidenceKind,

    pub fn validate(self: Evidence) !void {
        if (self.correlation_id.len == 0) return error.CorrelationLost;
        if (self.intent.len == 0 or self.action.len == 0) return error.EvidenceIncomplete;
        if (self.outcome.len == 0) return error.OutcomeUnknown;
    }
};

pub const Sink = enum { opentelemetry, clickhouse, tempo, sse_ndjson, grafana };

pub fn preferredSink(kind: EvidenceKind) Sink {
    return switch (kind) {
        .trace => .tempo,
        .metric => .opentelemetry,
        .log, .event, .proof => .clickhouse,
    };
}
