const std = @import("std");
const fas = @import("fullagenticstack");

test "Action cannot expand authority" {
    var actor = fas.a3.Actor{ .id = "payment-actor" };
    var agent = fas.a3.Agent{ .name = "PaymentAgent", .actor = &actor };
    const action = fas.a3.ActionContract{
        .name = "Payment.Execute",
        .purpose = "execute payment",
        .requires_authority = true,
    };
    try std.testing.expectError(
        error.AuthorityInsufficient,
        agent.run(action, false),
    );
}
