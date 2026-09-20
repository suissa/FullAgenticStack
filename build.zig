const std = @import("std");

const conformance_files = [_][]const u8{
    "docs/RFCs/RFC-FAS-0000-Semantic-First-Agent-Readable-Specification/implemented/conformance.zig",
    "docs/RFCs/RFC-FAS-0001-Core-Architecture/implemented/conformance.zig",
    "docs/RFCs/RFC-FAS-0002-Intent-as-Universal-Interface/implemented/conformance.zig",
    "docs/RFCs/RFC-FAS-0003-Multimodal-Intent-Ingress/implemented/conformance.zig",
    "docs/RFCs/RFC-FAS-0004-Agentic-Runtime/implemented/conformance.zig",
    "docs/RFCs/RFC-FAS-0005-Agent-Actor-Action/implemented/conformance.zig",
    "docs/RFCs/RFC-FAS-0006-Agentic-Data-Architecture/implemented/conformance.zig",
    "docs/RFCs/RFC-FAS-0007-Agent-per-Projection/implemented/conformance.zig",
    "docs/RFCs/RFC-FAS-0008-Agentic-Event-Architecture/implemented/conformance.zig",
    "docs/RFCs/RFC-FAS-0009-Agentic-Frontend-A2UI/implemented/conformance.zig",
    "docs/RFCs/RFC-FAS-0010-Polyglot-Agent-Actions/implemented/conformance.zig",
    "docs/RFCs/RFC-FAS-0011-Agentic-Observability/implemented/conformance.zig",
    "docs/RFCs/RFC-FAS-0012-Self-Healing-Supervision/implemented/conformance.zig",
    "docs/RFCs/RFC-FAS-0013-eXtreme-Zero-Trust/implemented/conformance.zig",
    "docs/RFCs/RFC-FAS-0014-Passwordless-Agentic-Identity/implemented/conformance.zig",
    "docs/RFCs/RFC-FAS-0015-Human-Agent-Authority/implemented/conformance.zig",
    "docs/RFCs/RFC-FAS-0016-Conformance/implemented/conformance.zig",
    "docs/RFCs/RFC-FAS-0017-Maturity-Levels/implemented/conformance.zig",
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const conformance = b.step("conformance", "Compile and run every RFC conformance suite");

    const harness_module = b.createModule(.{
        .root_source_file = b.path("tools/conformance_harness.zig"),
        .target = target,
        .optimize = optimize,
    });

    for (conformance_files, 0..) |path, index| {
        const module = b.createModule(.{
            .root_source_file = b.path(path),
            .target = target,
            .optimize = optimize,
        });
        module.addImport("conformance_harness", harness_module);
        const tests = b.addTest(.{
            .name = b.fmt("rfc-conformance-{d}", .{index}),
            .root_module = module,
        });
        conformance.dependOn(&b.addRunArtifact(tests).step);
    }
}
