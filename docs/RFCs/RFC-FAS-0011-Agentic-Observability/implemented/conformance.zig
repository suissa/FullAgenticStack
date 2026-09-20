const std = @import("std");
const fas = @import("fullagenticstack");

test "protected execution evidence is reconstructable" {
    const e = fas.observability.Evidence{
        .correlation_id = "corr-7",
        .intent = "Financial.Pay",
        .agent = "FinancialAgent",
        .action = "Payment.Execute",
        .authority_decision = "accepted",
        .outcome = "ok",
        .kind = .trace,
    };
    try e.validate();
    try std.testing.expectEqual(
        fas.observability.Sink.tempo,
        fas.observability.preferredSink(e.kind),
    );
}

test "evidence without correlation fails explicitly" {
    const e = fas.observability.Evidence{
        .correlation_id = "",
        .intent = "Financial.Pay",
        .agent = "FinancialAgent",
        .action = "Payment.Execute",
        .authority_decision = "accepted",
        .outcome = "ok",
        .kind = .trace,
    };
    try std.testing.expectError(error.CorrelationLost, e.validate());
}
