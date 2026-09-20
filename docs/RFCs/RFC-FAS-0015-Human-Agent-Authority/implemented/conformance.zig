const std = @import("std");
const fas = @import("fullagenticstack");

// @test FAS-AUTH-002
// @test FAS-AUTH-008
// @evidence FAS-AUTH-007 Authority.Rejected
test "delegated authority is scoped and rejection is evidenced" {
    var evidence = fas.agentic_runtime.EvidenceJournal{};
    const auth = fas.authority.Authority{
        .subject = "agent:financial",
        .capability = "Financial.Pay",
        .max_value = 500,
    };

    try std.testing.expect(fas.authority.authorize(
        auth,
        .{ .capability = "Financial.Pay", .value = 100 },
        0,
        &evidence,
    ));
    try std.testing.expect(!fas.authority.authorize(
        auth,
        .{ .capability = "Financial.Pay", .value = 1000 },
        0,
        &evidence,
    ));
    try evidence.expectEmitted("Authority.Accepted");
    try evidence.expectEmitted("Authority.Rejected");
}

// @test FAS-AUTH-003
test "natural language never broadens authority" {
    try std.testing.expect(
        !fas.authority.naturalLanguageMayExpandAuthority("do whatever is necessary"),
    );
}
