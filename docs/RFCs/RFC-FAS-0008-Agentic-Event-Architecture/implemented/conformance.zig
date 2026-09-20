const std = @import("std");

pub const EventOutcome = enum { ok, error_outcome };

pub const Event = struct {
    name: []const u8,
    intent: []const u8,
    correlation_id: []const u8,
    causation_id: ?[]const u8 = null,
    outcome: EventOutcome,
    replay_safe: bool = false,
};

pub fn validateEvent(event: Event) !void {
    if (event.name.len == 0) return error.EventMalformed;
    if (event.intent.len == 0) return error.CausalityUnknown;
    if (event.correlation_id.len == 0) return error.CausalityUnknown;
}

pub fn semanticName(agent: []const u8, intent: []const u8, outcome: EventOutcome, buf: []u8) ![]const u8 {
    return std.fmt.bufPrint(buf, "{s}.{s}.{s}", .{
        agent,
        intent,
        if (outcome == .ok) "Ok" else "Error",
    });
}

pub const Consumer = struct {
    last_event: ?[]const u8 = null,

    pub fn apply(self: *Consumer, event: Event) !bool {
        try validateEvent(event);
        if (self.last_event) |last| {
            if (std.mem.eql(u8, last, event.correlation_id)) return false;
        }
        self.last_event = event.correlation_id;
        return true;
    }
};

test "duplicate event is idempotent" {
    var c = Consumer{};
    const e = Event{ .name = "Financial.Pay.Ok", .intent = "Financial.Pay", .correlation_id = "corr-1", .outcome = .ok };
    try std.testing.expect(try c.apply(e));
    try std.testing.expect(!(try c.apply(e)));
}
