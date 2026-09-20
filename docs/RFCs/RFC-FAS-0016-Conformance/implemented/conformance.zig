const std = @import("std");
const fas = @import("fullagenticstack");

test "required failure blocks profile" {
    const rs = [_]fas.conformance.RequirementResult{
        .{
            .id = "FAS-INTENT-001",
            .class = .required,
            .activation = true,
            .status = .pass,
            .evidence_count = 1,
        },
        .{
            .id = "FAS-MULTI-001",
            .class = .required,
            .activation = true,
            .status = .fail,
            .evidence_count = 1,
        },
    };
    try std.testing.expect(!fas.conformance.profilePasses(&rs));
}

test "universal intent coverage requires full coverage" {
    const coverage = try fas.conformance.intentCoverage(4, 4);
    try std.testing.expectEqual(@as(?f64, 1.0), coverage.ratio);
}

test "empty capability inventory is not perfect conformance coverage" {
    try std.testing.expectError(
        error.EmptyCapabilityInventory,
        fas.conformance.intentCoverage(0, 0),
    );
}
