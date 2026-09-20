const std = @import("std");

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
        if (req.value) |v| {
            if (v > limit) return false;
        }
    }
    return true;
}

pub fn naturalLanguageMayExpandAuthority(_: []const u8) bool {
    return false;
}

test "delegated authority is scoped" {
    const auth = Authority{
        .subject = "agent:financial",
        .capability = "Financial.Pay",
        .max_value = 500,
    };
    try std.testing.expect(permits(auth, .{ .capability = "Financial.Pay", .value = 100 }, 0));
    try std.testing.expect(!permits(auth, .{ .capability = "Financial.Pay", .value = 1000 }, 0));
}
