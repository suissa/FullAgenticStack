const std = @import("std");

pub const RequirementStatus = enum { pass, fail, not_applicable, not_verified, stale };
pub const Assurance = enum { claimed, self_verified, independently_verified };
pub const RequirementClass = enum { required, conditional, optional };

pub const RequirementResult = struct {
    id: []const u8,
    class: RequirementClass,
    activation: bool,
    status: RequirementStatus,
    evidence_count: usize,
};

pub const ConformanceTarget = struct {
    system_identity: []const u8,
    system_version: []const u8,
    artifact_fingerprint: []const u8,
    configuration_fingerprint: []const u8,
    profile: []const u8,
};

pub fn validateResult(r: RequirementResult) !void {
    if (r.id.len == 0) return error.MissingRequirementId;
    if (r.status == .pass and r.evidence_count == 0) return error.PassWithoutEvidence;
    if (r.status == .not_applicable and r.class != .conditional) return error.InvalidNotApplicable;
    if (r.class == .required and r.activation and r.status != .pass) return error.ProfileBlocked;
}

pub fn profilePasses(results: []const RequirementResult) bool {
    for (results) |r| {
        if (r.class == .required and r.activation and r.status != .pass) return false;
        if (r.class == .conditional and r.activation and r.status != .pass) return false;
    }
    return true;
}

pub const Coverage = struct {
    covered: usize,
    total: usize,
    ratio: ?f64,
};

pub fn intentCoverage(covered: usize, total: usize) !Coverage {
    if (total == 0) return error.EmptyCapabilityInventory;
    if (covered > total) return error.InvalidCoverage;
    return .{
        .covered = covered,
        .total = total,
        .ratio = @as(f64, @floatFromInt(covered)) / @as(f64, @floatFromInt(total)),
    };
}

pub fn isStale(old_artifact: []const u8, new_artifact: []const u8, old_config: []const u8, new_config: []const u8) bool {
    return !std.mem.eql(u8, old_artifact, new_artifact) or !std.mem.eql(u8, old_config, new_config);
}
