const std = @import("std");

pub const Level = enum {
    ai_enhanced,
    agentic_interface,
    agentic_orchestration,
    full_agentic_stack,
    full_agentic_stack_native,
    full_agentic_stack_extreme,
};

pub const Capabilities = struct {
    natural_language_execution: bool = false,
    runtime_orchestration: bool = false,
    agentic_data: bool = false,
    a3_native: bool = false,
    multimodal: bool = false,
    a2ui: bool = false,
    extreme_zero_trust: bool = false,
    passwordless_identity: bool = false,
    explicit_human_agent_authority: bool = false,
};

pub fn infer(c: Capabilities) Level {
    if (c.a2ui and c.extreme_zero_trust and c.passwordless_identity and c.explicit_human_agent_authority)
        return .full_agentic_stack_extreme;
    if (c.a3_native and c.agentic_data and c.runtime_orchestration)
        return .full_agentic_stack_native;
    if (c.agentic_data and c.runtime_orchestration and c.natural_language_execution)
        return .full_agentic_stack;
    if (c.runtime_orchestration and c.natural_language_execution)
        return .agentic_orchestration;
    if (c.natural_language_execution)
        return .agentic_interface;
    return .ai_enhanced;
}

test "framework count does not determine maturity" {
    const c = Capabilities{ .natural_language_execution = true };
    try std.testing.expectEqual(Level.agentic_interface, infer(c));
}
