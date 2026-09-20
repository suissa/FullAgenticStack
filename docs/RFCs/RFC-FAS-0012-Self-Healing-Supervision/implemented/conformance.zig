const std = @import("std");
const Harness = @import("../../../../tools/conformance_harness.zig").Harness;

pub const FailureClass = enum { retryable, substitutable, healable, non_recoverable, escalate };
pub const HealingResult = enum { recovered, retry, rollback, escalated };

pub const Failure = struct {
    action: []const u8,
    reason: []const u8,
    authority_ok: bool,
    invariant_ok: bool,
};

pub const Supervisor = struct {
    attempts: u8 = 0,
    max_attempts: u8 = 3,
    harness: *Harness,

    pub fn classify(_: *Supervisor, failure: Failure) FailureClass {
        if (!failure.authority_ok or !failure.invariant_ok) return .escalate;
        if (std.mem.indexOf(u8, failure.reason, "transient") != null) return .retryable;
        if (std.mem.indexOf(u8, failure.reason, "config") != null) return .healable;
        if (std.mem.indexOf(u8, failure.reason, "dependency") != null) return .substitutable;
        return .non_recoverable;
    }

    pub fn heal(self: *Supervisor, failure: Failure) HealingResult {
        const class = self.classify(failure);
        const result: HealingResult = switch (class) {
            .retryable => blk: {
                if (self.attempts >= self.max_attempts) break :blk .escalated;
                self.attempts += 1;
                break :blk .retry;
            },
            .healable => if (failure.authority_ok and failure.invariant_ok) .recovered else .escalated,
            .substitutable => .recovered,
            .non_recoverable, .escalate => .escalated,
        };

        switch (result) {
            .recovered => self.harness.emit("Healing.Recovered"),
            .retry => self.harness.emit("Healing.Retry"),
            .rollback => self.harness.emit("Healing.Rollback"),
            .escalated => self.harness.emit("Healing.Escalated"),
        }
        return result;
    }
};

// @test FAS-HEAL-004
// @test FAS-HEAL-006
// @test FAS-HEAL-007
// @evidence FAS-HEAL-006 Healing.Escalated
test "healing never bypasses authority and emits escalation evidence" {
    var harness = Harness{};
    var s = Supervisor{ .harness = &harness };
    const f = Failure{
        .action = "Payment.Execute",
        .reason = "config mismatch",
        .authority_ok = false,
        .invariant_ok = true,
    };
    try std.testing.expectEqual(HealingResult.escalated, s.heal(f));
    try harness.expectEmitted("Healing.Escalated");
    try harness.expectNotEmitted("Healing.Recovered");
}

// @test FAS-HEAL-008
// @evidence FAS-HEAL-008 Healing.Escalated
test "retry is bounded and eventually escalates" {
    var harness = Harness{};
    var s = Supervisor{ .harness = &harness, .max_attempts = 1 };
    const f = Failure{
        .action = "Remote.Read",
        .reason = "transient dependency error",
        .authority_ok = true,
        .invariant_ok = true,
    };
    try std.testing.expectEqual(HealingResult.retry, s.heal(f));
    try std.testing.expectEqual(HealingResult.escalated, s.heal(f));
    try harness.expectEmitted("Healing.Retry");
    try harness.expectEmitted("Healing.Escalated");
}
