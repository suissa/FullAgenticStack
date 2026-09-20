const std = @import("std");

pub const Modality = enum { text, audio, image };
pub const Outcome = union(enum) {
    accepted: []const u8,
    semantic_failure: []const u8,
    escalated: []const u8,
};

pub const Request = struct {
    natural_language: []const u8,
    modality: Modality,
};

pub const Capability = struct {
    name: []const u8,
    natural_language_path: bool,
};

pub const Runtime = struct {
    pub fn submit(_: *Runtime, req: Request, capability: Capability) Outcome {
        if (req.natural_language.len == 0) return .{ .semantic_failure = "MissingIntent" };
        if (!capability.natural_language_path) return .{ .semantic_failure = "UnsupportedIntent" };
        return .{ .accepted = capability.name };
    }
};

pub fn intentCoverage(capabilities: []const Capability) f64 {
    if (capabilities.len == 0) return 1.0;
    var covered: usize = 0;
    for (capabilities) |c| if (c.natural_language_path) { covered += 1; };
    return @as(f64, @floatFromInt(covered)) / @as(f64, @floatFromInt(capabilities.len));
}

test "all human capabilities must have natural language path" {
    const caps = [_]Capability{
        .{ .name = "Customer.Create", .natural_language_path = true },
        .{ .name = "Invoice.Create", .natural_language_path = true },
    };
    try std.testing.expectEqual(@as(f64, 1.0), intentCoverage(&caps));
}
