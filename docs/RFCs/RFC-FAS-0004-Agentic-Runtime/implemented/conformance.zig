const std = @import("std");
const Harness = @import("../../../../tools/conformance_harness.zig").Harness;

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
    harness: *Harness,
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
        ctx.harness.emit("Runtime.Intake.Accepted");
        ctx.evidence_count += 1;
    }

    fn resolve(ctx: *ExecutionContext) RuntimeError!void {
        ctx.harness.emit("Intent.Resolve.Ok");
        ctx.evidence_count += 1;
    }

    fn bind(ctx: *ExecutionContext) RuntimeError!void {
        ctx.harness.emit("Runtime.Binding.Ok");
        ctx.evidence_count += 1;
    }

    fn govern(ctx: *ExecutionContext) RuntimeError!void {
        if (!ctx.authority.granted) {
            ctx.harness.emit("Governance.Rejected");
            return error.GovernanceRejected;
        }
        ctx.harness.emit("Governance.Accepted");
        ctx.evidence_count += 1;
    }

    fn orchestrate(ctx: *ExecutionContext) RuntimeError!void {
        ctx.harness.emit("Runtime.Orchestration.Ok");
        ctx.evidence_count += 1;
    }

    fn prove(ctx: *ExecutionContext) RuntimeError!void {
        ctx.harness.emit("Runtime.Proof.Ok");
        ctx.evidence_count += 1;
    }

    fn accept(ctx: *ExecutionContext) RuntimeError!void {
        if (ctx.evidence_count < 6) return error.EvidenceIncomplete;
        ctx.harness.emit("Runtime.Acceptance.Ok");
        ctx.evidence_count += 1;
    }

    fn persist(ctx: *ExecutionContext) RuntimeError!void {
        ctx.harness.emit("Runtime.Persistence.Ok");
        ctx.evidence_count += 1;
    }
};

// @test FAS-RUNTIME-003
// @evidence FAS-RUNTIME-003 Governance.Rejected
test "FAS-RUNTIME-003 governance rejects and emits evidence without authority" {
    var harness = Harness{};
    var runtime = Runtime{};
    var ctx = ExecutionContext{
        .canonical_intent = "Financial.Pay",
        .authority = .{ .granted = false },
        .harness = &harness,
    };

    try std.testing.expectError(error.GovernanceRejected, runtime.execute(&ctx));
    try harness.expectEmitted("Governance.Rejected");
    try harness.expectNotEmitted("Runtime.Orchestration.Ok");
}

// @test FAS-RUNTIME-006
// @evidence FAS-RUNTIME-006 Runtime.Acceptance.Ok
test "FAS-RUNTIME-006 successful execution leaves correlated stage evidence" {
    var harness = Harness{};
    var runtime = Runtime{};
    var ctx = ExecutionContext{
        .canonical_intent = "Customer.Read",
        .authority = .{ .granted = true },
        .harness = &harness,
    };

    try runtime.execute(&ctx);
    try harness.expectEmitted("Intent.Resolve.Ok");
    try harness.expectEmitted("Governance.Accepted");
    try harness.expectEmitted("Runtime.Proof.Ok");
    try harness.expectEmitted("Runtime.Acceptance.Ok");
    try harness.expectEmitted("Runtime.Persistence.Ok");
}
