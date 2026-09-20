const std = @import("std");
const fas = @import("fullagenticstack");

test "duplicate event is idempotent" {
    var c = fas.events.Consumer{};
    const e = fas.events.Event{
        .name = "Financial.Pay.Ok",
        .intent = "Financial.Pay",
        .correlation_id = "corr-1",
        .outcome = .ok,
    };
    try std.testing.expect(try c.apply(e));
    try std.testing.expect(!(try c.apply(e)));
}

test "event without correlation does not masquerade as causal evidence" {
    const e = fas.events.Event{
        .name = "Financial.Pay.Ok",
        .intent = "Financial.Pay",
        .correlation_id = "",
        .outcome = .ok,
    };
    try std.testing.expectError(error.CausalityUnknown, fas.events.validateEvent(e));
}
