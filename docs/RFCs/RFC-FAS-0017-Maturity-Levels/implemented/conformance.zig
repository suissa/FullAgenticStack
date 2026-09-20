const std = @import("std");
const fas = @import("fullagenticstack");

test "framework count does not determine maturity" {
    const c = fas.maturity.Capabilities{ .natural_language_execution = true };
    try std.testing.expectEqual(
        fas.maturity.Level.agentic_interface,
        fas.maturity.infer(c),
    );
}

test "extreme level requires the declared extreme capabilities" {
    const c = fas.maturity.Capabilities{
        .natural_language_execution = true,
        .runtime_orchestration = true,
        .agentic_data = true,
        .a3_native = true,
        .a2ui = true,
        .extreme_zero_trust = true,
        .passwordless_identity = true,
        .explicit_human_agent_authority = true,
    };
    try std.testing.expectEqual(
        fas.maturity.Level.full_agentic_stack_extreme,
        fas.maturity.infer(c),
    );
}
