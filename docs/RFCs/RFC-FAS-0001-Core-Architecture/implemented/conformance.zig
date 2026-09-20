const std = @import("std");
const rt = @import("fullagenticstack");

// @test FAS-CORE-001
test "FAS-CORE-001 real human-facing capability inventory has universal Intent coverage" {
    const capabilities = rt.capabilityInventory();
    try std.testing.expect(capabilities.len > 0);

    const coverage = try rt.evaluateIntentCoverage(capabilities);
    try std.testing.expect(coverage.human_facing_total > 0);
    try std.testing.expectEqual(
        coverage.human_facing_total,
        coverage.reachable_by_intent,
    );
    try std.testing.expectEqual(
        @as(?f64, 1.0),
        coverage.ratio,
    );

    try std.testing.expectEqual(
        rt.RequirementApplicability.applicable,
        try rt.validateUniversalIntentCoverage(capabilities),
    );

    var runtime = rt.Runtime{};
    for (capabilities) |capability| {
        if (!capability.human_facing) continue;

        const outcome = runtime.submit(
            .{
                .natural_language = "please perform the requested outcome",
                .modality = .text,
            },
            capability.name,
        );

        switch (outcome) {
            .accepted => |accepted| try std.testing.expectEqualStrings(
                capability.name,
                accepted,
            ),
            .semantic_failure, .escalated => {
                return error.TestUnexpectedResult;
            },
        }
    }
}

// @test FAS-CORE-001
// @adversarial FAS-CORE-001 capability_masking
test "FAS-CORE-001 rejects a human capability that cannot be reached by Intent" {
    const adversarial_inventory = [_]rt.Capability{
        .{
            .name = "Customer.Create",
            .human_facing = true,
            .natural_language_path = true,
            .owner = "CoreAgent",
        },
        .{
            .name = "Invoice.Create",
            .human_facing = true,
            .natural_language_path = false,
            .owner = "CoreAgent",
        },
    };

    const coverage = try rt.evaluateIntentCoverage(&adversarial_inventory);
    try std.testing.expectEqual(@as(usize, 2), coverage.human_facing_total);
    try std.testing.expectEqual(@as(usize, 1), coverage.reachable_by_intent);
    try std.testing.expectEqual(@as(?f64, 0.5), coverage.ratio);

    try std.testing.expectError(
        error.UnreachableHumanCapability,
        rt.validateUniversalIntentCoverage(&adversarial_inventory),
    );
}

// @test FAS-CORE-001
// @adversarial FAS-CORE-001 empty_inventory
test "FAS-CORE-001 empty registry is not perfect coverage" {
    const empty = [_]rt.Capability{};

    try std.testing.expectError(
        error.EmptyCapabilityInventory,
        rt.evaluateIntentCoverage(&empty),
    );
    try std.testing.expectError(
        error.EmptyCapabilityInventory,
        rt.validateUniversalIntentCoverage(&empty),
    );
}

// @test FAS-CORE-001
test "FAS-CORE-001 explicitly reports not-applicable when registry has no human-facing capability" {
    const internal_only = [_]rt.Capability{
        .{
            .name = "Runtime.Internal.Health",
            .human_facing = false,
            .natural_language_path = false,
            .owner = "Runtime",
        },
    };

    const coverage = try rt.evaluateIntentCoverage(&internal_only);
    try std.testing.expectEqual(@as(usize, 0), coverage.human_facing_total);
    try std.testing.expectEqual(@as(?f64, null), coverage.ratio);
    try std.testing.expectEqual(
        rt.RequirementApplicability.not_applicable,
        try rt.validateUniversalIntentCoverage(&internal_only),
    );
}
