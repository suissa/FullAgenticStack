const std = @import("std");
const fas = @import("fullagenticstack");

// @test FAS-HEAL-004
// @test FAS-HEAL-006
// @test FAS-HEAL-007
// @evidence FAS-HEAL-006 Healing.Escalated
test "healing never bypasses authority and emits escalation evidence" {
    var evidence = fas.agentic_runtime.EvidenceJournal{};
    var s = fas.healing.Supervisor{ .evidence = &evidence };
    const f = fas.healing.Failure{
        .action = "Payment.Execute",
        .reason = "config mismatch",
        .authority_ok = false,
        .invariant_ok = true,
    };
    try std.testing.expectEqual(fas.healing.HealingResult.escalated, s.heal(f));
    try std.testing.expect(evidence.emitted("Healing.Escalated"));
    try std.testing.expect(!evidence.emitted("Healing.Recovered"));
}

// @test FAS-HEAL-008
// @evidence FAS-HEAL-008 Healing.Escalated
test "retry is bounded and eventually escalates" {
    var evidence = fas.agentic_runtime.EvidenceJournal{};
    var s = fas.healing.Supervisor{ .evidence = &evidence, .max_attempts = 1 };
    const f = fas.healing.Failure{
        .action = "Remote.Read",
        .reason = "transient dependency error",
        .authority_ok = true,
        .invariant_ok = true,
    };
    try std.testing.expectEqual(fas.healing.HealingResult.retry, s.heal(f));
    try std.testing.expectEqual(fas.healing.HealingResult.escalated, s.heal(f));
    try std.testing.expect(evidence.emitted("Healing.Retry"));
    try std.testing.expect(evidence.emitted("Healing.Escalated"));
}
