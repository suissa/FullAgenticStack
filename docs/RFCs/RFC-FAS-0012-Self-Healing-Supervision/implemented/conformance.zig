const std = @import("std");

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

    pub fn classify(_: *Supervisor, failure: Failure) FailureClass {
        if (!failure.authority_ok or !failure.invariant_ok) return .escalate;
        if (std.mem.indexOf(u8, failure.reason, "transient") != null) return .retryable;
        if (std.mem.indexOf(u8, failure.reason, "config") != null) return .healable;
        if (std.mem.indexOf(u8, failure.reason, "dependency") != null) return .substitutable;
        return .non_recoverable;
    }

    pub fn heal(self: *Supervisor, failure: Failure) !HealingResult {
        const class = self.classify(failure);
        return switch (class) {
            .retryable => blk: {
                if (self.attempts >= self.max_attempts) break :blk .escalated;
                self.attempts += 1;
                break :blk .retry;
            },
            .healable => if (failure.authority_ok and failure.invariant_ok) .recovered else .escalated,
            .substitutable => .recovered,
            .non_recoverable, .escalate => .escalated,
        };
    }
};

test "healing never bypasses authority" {
    var s = Supervisor{};
    const f = Failure{
        .action = "Payment.Execute",
        .reason = "config mismatch",
        .authority_ok = false,
        .invariant_ok = true,
    };
    try std.testing.expectEqual(HealingResult.escalated, try s.heal(f));
}
