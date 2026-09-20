const std = @import("std");
const fas = @import("fullagenticstack");

test "protected UI effect requires matching intent and confirmation" {
    const c = fas.a2ui.A2UIComponent{
        .id = "pay",
        .kind = .confirm,
        .capability = "Financial.Pay",
        .label = "Confirm payment",
        .protected_effect = true,
    };
    try std.testing.expectError(
        error.UnsafeImplicitAction,
        fas.a2ui.invoke(c, .{
            .component_id = "pay",
            .intent = "Financial.Pay",
        }),
    );
}

test "UI cannot silently drift from declared capability" {
    const c = fas.a2ui.A2UIComponent{
        .id = "pay",
        .kind = .confirm,
        .capability = "Financial.Pay",
        .label = "Confirm payment",
        .protected_effect = false,
    };
    try std.testing.expectError(
        error.SemanticDrift,
        fas.a2ui.invoke(c, .{
            .component_id = "pay",
            .intent = "Customer.Delete",
            .confirmed = true,
        }),
    );
}
