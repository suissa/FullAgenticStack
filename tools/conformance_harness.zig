const std = @import("std");

pub const Harness = struct {
    const max_events = 128;

    events: [max_events][]const u8 = undefined,
    len: usize = 0,

    pub fn emit(self: *Harness, event: []const u8) void {
        if (self.len >= max_events) @panic("conformance event buffer exhausted");
        self.events[self.len] = event;
        self.len += 1;
    }

    pub fn emitted(self: *const Harness, expected: []const u8) bool {
        for (self.events[0..self.len]) |event| {
            if (std.mem.eql(u8, event, expected)) return true;
        }
        return false;
    }

    pub fn expectEmitted(self: *const Harness, expected: []const u8) !void {
        try std.testing.expect(self.emitted(expected));
    }

    pub fn expectNotEmitted(self: *const Harness, expected: []const u8) !void {
        try std.testing.expect(!self.emitted(expected));
    }
};
