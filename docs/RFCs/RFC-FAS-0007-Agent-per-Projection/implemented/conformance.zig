const std = @import("std");
const fas = @import("fullagenticstack");

test "projection cannot serve before validation" {
    var p = fas.projection.Projection{
        .name = "CustomerRead",
        .source = "Write.Customer",
        .owner_agent = "CustomerReadProjectionAgent",
    };
    try p.materialize();
    try std.testing.expectError(error.ProjectionInvalid, p.serve());
}
