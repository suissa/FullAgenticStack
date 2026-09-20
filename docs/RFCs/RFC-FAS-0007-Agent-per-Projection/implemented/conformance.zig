const std = @import("std");

pub const ProjectionState = enum { declared, materialized, validated, serving, stale, invalid };

pub const Projection = struct {
    name: []const u8,
    source: []const u8,
    owner_agent: []const u8,
    state: ProjectionState = .declared,
    version: u64 = 0,

    pub fn materialize(self: *Projection) !void {
        if (self.source.len == 0 or self.owner_agent.len == 0) return error.LineageIncomplete;
        self.state = .materialized;
        self.version += 1;
    }

    pub fn validate(self: *Projection, valid: bool) void {
        self.state = if (valid) .validated else .invalid;
    }

    pub fn serve(self: *Projection) !void {
        if (self.state != .validated) return error.ProjectionInvalid;
        self.state = .serving;
    }

    pub fn markStale(self: *Projection) void {
        self.state = .stale;
    }

    pub fn rebuild(self: *Projection) !void {
        if (self.source.len == 0) return error.SourceUnavailable;
        self.state = .materialized;
        self.version += 1;
    }
};

test "projection cannot serve before validation" {
    var p = Projection{ .name = "CustomerRead", .source = "Write.Customer", .owner_agent = "CustomerReadProjectionAgent" };
    try p.materialize();
    try std.testing.expectError(error.ProjectionInvalid, p.serve());
}
