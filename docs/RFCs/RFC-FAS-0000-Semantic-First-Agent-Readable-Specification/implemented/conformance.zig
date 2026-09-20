const std = @import("std");
const fas = @import("fullagenticstack");

test "semantic contract rejects underspecified requirement" {
    const bad = fas.specification.RequirementMetadata{
        .requirement_id = "",
        .class = .required,
        .activation_condition = "always",
        .verification_property = "must hold",
        .required_evidence = .test_evidence,
        .adversarial_property = "must fail when violated",
    };
    try std.testing.expectError(
        error.MissingRequirementId,
        fas.specification.validateRequirement(bad),
    );
}
