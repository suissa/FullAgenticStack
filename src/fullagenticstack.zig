pub const specification = @import("specification.zig");
pub const intent = @import("intent.zig");
pub const multimodal = @import("multimodal.zig");
pub const agentic_runtime = @import("runtime.zig");
pub const a3 = @import("a3.zig");
pub const data = @import("data.zig");
pub const projection = @import("projection.zig");
pub const events = @import("events.zig");
pub const a2ui = @import("a2ui.zig");
pub const polyglot = @import("polyglot.zig");
pub const observability = @import("observability.zig");
pub const healing = @import("healing.zig");
pub const zero_trust = @import("zero_trust.zig");
pub const identity = @import("identity.zig");
pub const authority = @import("authority.zig");
pub const conformance = @import("conformance.zig");
pub const maturity = @import("maturity.zig");

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
    human_facing: bool,
    natural_language_path: bool,
    owner: []const u8,
};

pub const RequirementApplicability = enum {
    applicable,
    not_applicable,
};

pub const IntentCoverage = struct {
    human_facing_total: usize,
    reachable_by_intent: usize,
    ratio: ?f64,
};

pub const ConformanceError = error{
    EmptyCapabilityInventory,
    UnreachableHumanCapability,
};

const reference_capabilities = [_]Capability{
    .{
        .name = "Customer.Create",
        .human_facing = true,
        .natural_language_path = true,
        .owner = "CoreAgent",
    },
    .{
        .name = "Invoice.Create",
        .human_facing = true,
        .natural_language_path = true,
        .owner = "CoreAgent",
    },
};

// @satisfies FAS-CORE-001
// @not-applicable FAS-CORE-009 condition=independent_responsibility_domain_exists:false reason=reference_registry_uses_single_core_owner
pub fn capabilityInventory() []const Capability {
    return reference_capabilities[0..];
}

pub fn evaluateIntentCoverage(capabilities: []const Capability) ConformanceError!IntentCoverage {
    if (capabilities.len == 0) return error.EmptyCapabilityInventory;

    var human_facing_total: usize = 0;
    var reachable_by_intent: usize = 0;

    for (capabilities) |capability| {
        if (!capability.human_facing) continue;
        human_facing_total += 1;
        if (capability.natural_language_path) reachable_by_intent += 1;
    }

    return .{
        .human_facing_total = human_facing_total,
        .reachable_by_intent = reachable_by_intent,
        .ratio = if (human_facing_total == 0)
            null
        else
            @as(f64, @floatFromInt(reachable_by_intent)) /
                @as(f64, @floatFromInt(human_facing_total)),
    };
}

pub fn validateUniversalIntentCoverage(
    capabilities: []const Capability,
) ConformanceError!RequirementApplicability {
    const coverage = try evaluateIntentCoverage(capabilities);
    if (coverage.human_facing_total == 0) return .not_applicable;
    if (coverage.reachable_by_intent != coverage.human_facing_total) {
        return error.UnreachableHumanCapability;
    }
    return .applicable;
}

fn findCapability(name: []const u8) ?Capability {
    for (reference_capabilities) |capability| {
        if (std.mem.eql(u8, capability.name, name)) return capability;
    }
    return null;
}

pub const Runtime = struct {
    pub fn submit(_: *Runtime, req: Request, capability_name: []const u8) Outcome {
        if (req.natural_language.len == 0) {
            return .{ .semantic_failure = "MissingIntent" };
        }

        const capability = findCapability(capability_name) orelse
            return .{ .semantic_failure = "CapabilityUnavailable" };

        if (capability.human_facing and !capability.natural_language_path) {
            return .{ .semantic_failure = "UnsupportedIntent" };
        }

        return .{ .accepted = capability.name };
    }
};
