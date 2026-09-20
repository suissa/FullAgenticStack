const std = @import("std");

pub const RequirementClass = enum { required, conditional, optional };
pub const EvidenceClass = enum { static, test_evidence, runtime, formal, human_attestation };

pub const RequirementMetadata = struct {
    requirement_id: []const u8,
    class: RequirementClass,
    activation_condition: []const u8,
    verification_property: []const u8,
    required_evidence: EvidenceClass,
    adversarial_property: []const u8,
};

pub const TechnologyProfile = struct {
    primary_language: []const u8,
    runtime: []const u8,
    write_store: ?[]const u8 = null,
    read_store: ?[]const u8 = null,
    cache_store: ?[]const u8 = null,
    vector_store: ?[]const u8 = null,
    graph_store: ?[]const u8 = null,
    event_store: ?[]const u8 = null,
};

pub fn semanticWins(semantic_ok: bool, implementation_ok: bool) bool {
    return semantic_ok and implementation_ok;
}

pub fn validateRequirement(meta: RequirementMetadata) !void {
    if (meta.requirement_id.len == 0) return error.MissingRequirementId;
    if (meta.activation_condition.len == 0) return error.MissingActivationCondition;
    if (meta.verification_property.len == 0) return error.MissingVerificationProperty;
    if (meta.class == .conditional and std.mem.eql(u8, meta.activation_condition, "always"))
        return error.ConditionalWithoutCondition;
}
