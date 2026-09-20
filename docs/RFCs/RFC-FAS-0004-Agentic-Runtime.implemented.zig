const std = @import("std");

pub const Stage = enum {
    intake,
    resolver,
    binding,
    healing,
    proof,
    governor,
    orchestration,
    acceptance,
    persistence,
};

pub const Authority = struct {
    granted: bool,
};

pub const ExecutionContext = struct {
    canonical_intent: []const u8,
    authority: Authority,
    evidence_count: usize = 0,
};

pub const RuntimeError = error{
    ResolutionFailure,
    BindingFailure,
    GovernanceRejected,
    ExecutionFailure,
    EvidenceIncomplete,
    AcceptanceFailure,
};

pub const Runtime = struct {
    pub fn execute(_: *Runtime, ctx: *ExecutionContext) RuntimeError!void {
        try intake(ctx);
        try resolve(ctx);
        try bind(ctx);
        try govern(ctx);
        try orchestrate(ctx);
        try prove(ctx);
        try accept(ctx);
        try persist(ctx);
    }

    fn intake(ctx: *ExecutionContext) RuntimeError!void {
        if (ctx.canonical_intent.len == 0) return error.ResolutionFailure;
        ctx.evidence_count += 1;
    }
    fn resolve(ctx: *ExecutionContext) RuntimeError!void { ctx.evidence_count += 1; }
    fn bind(ctx: *ExecutionContext) RuntimeError!void { ctx.evidence_count += 1; }
    fn govern(ctx: *ExecutionContext) RuntimeError!void {
        if (!ctx.authority.granted) return error.GovernanceRejected;
        ctx.evidence_count += 1;
    }
    fn orchestrate(ctx: *ExecutionContext) RuntimeError!void { ctx.evidence_count += 1; }
    fn prove(ctx: *ExecutionContext) RuntimeError!void { ctx.evidence_count += 1; }
    fn accept(ctx: *ExecutionContext) RuntimeError!void {
        if (ctx.evidence_count < 6) return error.EvidenceIncomplete;
        ctx.evidence_count += 1;
    }
    fn persist(ctx: *ExecutionContext) RuntimeError!void { ctx.evidence_count += 1; }
};

test "governance blocks protected effect without authority" {
    var runtime = Runtime{};
    var ctx = ExecutionContext{ .canonical_intent = "Financial.Pay", .authority = .{ .granted = false } };
    try std.testing.expectError(error.GovernanceRejected, runtime.execute(&ctx));
}
