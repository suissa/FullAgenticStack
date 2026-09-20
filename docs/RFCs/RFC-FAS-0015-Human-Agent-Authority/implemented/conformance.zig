const std = @import("std");
const Harness = @import("../../../../tools/conformance_harness.zig").Harness;

pub const AuthorityMode = enum { human_in_loop, human_on_loop, delegated, deterministic_auto };

pub const Authority = struct {
    subject: []const u8,
    capability: []const u8,
    resource: ?[]const u8 = null,
    max_value: ?u64 = null,
    expires_at: ?i64 = null,
    revoked: bool = false,
};

pub const ActionRequest = struct {
    capability: []const u8,
    resource: ?[]const u8 = null,
    value: ?u64 = null,
};

pub fn permits(authority: Authority, req: ActionRequest, now: i64) bool {
    if (authority.revoked) return false;
    if (authority.expires_at) |expiry| if (now > expiry) return false;
    if (!std.mem.eql(u8, authority.capability, req.capability)) return false;
    if (authority.resource) |r| {
        if (req.resource == null or !std.mem.eql(u8, r, req.resource.?)) return false;
    }
    if (authority.max_value) |limit| {
        if (req.value) |v| if (v > limit) return false;
    }
    return true;
}

pub fn authorize(authority: Authority, req: ActionRequest, now: i64, harness: *Harness) bool {
    const accepted = permits(authority, req, now);
    harness.emit(if (accepted) "Authority.Accepted" else "Authority.Rejected");
    return accepted;
}

pub fn naturalLanguageMayExpandAuthority(_: []const u8) bool {
    return false;
}

// @test FAS-AUTH-002
// @test FAS-AUTH-008
// @evidence FAS-AUTH-007 Authority.Rejected
test "delegated authority is scoped and rejection is evidenced" {
    var harness = Harness{};
    const auth = Authority{
        .subject = "agent:financial",
        .capability = "Financial.Pay",
        .max_value = 500,
    };

    try std.testing.expect(authorize(auth, .{ .capability = "Financial.Pay", .value = 100 }, 0, &harness));
    try std.testing.expect(!authorize(auth, .{ .capability = "Financial.Pay", .value = 1000 }, 0, &harness));
    try harness.expectEmitted("Authority.Accepted");
    try harness.expectEmitted("Authority.Rejected");
}

// @test FAS-AUTH-003
test "natural language never broadens authority" {
    try std.testing.expect(!naturalLanguageMayExpandAuthority("do whatever is necessary"));
}
