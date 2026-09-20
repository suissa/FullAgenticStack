const std = @import("std");
const fas = @import("fullagenticstack");

// @test FAS-RUNTIME-003
// @evidence FAS-RUNTIME-003 Governance.Rejected
test "FAS-RUNTIME-003 governance rejects and emits evidence without authority" {
    var evidence = fas.agentic_runtime.EvidenceJournal{};
    var runtime = fas.agentic_runtime.Runtime{};
    var ctx = fas.agentic_runtime.ExecutionContext{
        .canonical_intent = "Financial.Pay",
        .authority = .{ .granted = false },
        .evidence = &evidence,
    };

    try std.testing.expectError(error.GovernanceRejected, runtime.execute(&ctx));
    try evidence.expectEmitted("Governance.Rejected");
    try evidence.expectNotEmitted("Runtime.Orchestration.Ok");
}

// @test FAS-RUNTIME-006
// @evidence FAS-RUNTIME-006 Runtime.Acceptance.Ok
test "FAS-RUNTIME-006 successful execution leaves correlated stage evidence" {
    var evidence = fas.agentic_runtime.EvidenceJournal{};
    var runtime = fas.agentic_runtime.Runtime{};
    var ctx = fas.agentic_runtime.ExecutionContext{
        .canonical_intent = "Customer.Read",
        .authority = .{ .granted = true },
        .evidence = &evidence,
    };

    try runtime.execute(&ctx);
    try std.testing.expect(evidence.emitted("Intent.Resolve.Ok"));
    try std.testing.expect(evidence.emitted("Governance.Accepted"));
    try std.testing.expect(evidence.emitted("Runtime.Proof.Ok"));
    try evidence.expectEmitted("Runtime.Acceptance.Ok");
    try std.testing.expect(evidence.emitted("Runtime.Persistence.Ok"));
}
