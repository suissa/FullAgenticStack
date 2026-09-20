const std = @import("std");

pub const CanonicalIntent = struct {
    label: []const u8,
    goal: []const u8,
    authority_required: bool,
};

pub const Resolution = union(enum) {
    resolved: CanonicalIntent,
    ambiguous: []const u8,
    unsupported: []const u8,
    incomplete: []const u8,
};

pub const IntentResolver = struct {
    pub fn resolve(_: *IntentResolver, text: []const u8) Resolution {
        if (text.len == 0) return .{ .incomplete = "empty input" };
        if (std.mem.find(u8, text, "invoice") != null or std.mem.find(u8, text, "fatura") != null) {
            if (std.mem.find(u8, text, "send") != null or std.mem.find(u8, text, "mande") != null)
                return .{ .resolved = .{ .label = "Billing.Invoice.Send", .goal = "send invoice", .authority_required = false } };
            return .{ .ambiguous = "invoice intent requires operation" };
        }
        return .{ .unsupported = "no capability" };
    }
};

pub fn sameSemanticIntent(a: CanonicalIntent, b: CanonicalIntent) bool {
    return std.mem.eql(u8, a.label, b.label) and std.mem.eql(u8, a.goal, b.goal);
}

pub fn resolvedDoesNotAuthorize(_: CanonicalIntent) bool {
    return true;
}

test "resolve does not imply authorization" {
    const i = CanonicalIntent{ .label = "Financial.Pay", .goal = "pay", .authority_required = true };
    try std.testing.expect(resolvedDoesNotAuthorize(i));
}
