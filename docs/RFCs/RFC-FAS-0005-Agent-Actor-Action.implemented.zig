const std = @import("std");

pub const ActionFailure = error{
    PreconditionNotMet,
    AuthorityInsufficient,
    ExecutionFailed,
    PostconditionNotMet,
};

pub const ActionContract = struct {
    name: []const u8,
    purpose: []const u8,
    requires_authority: bool,
};

pub const Actor = struct {
    id: []const u8,
    local_event_count: usize = 0,

    pub fn execute(self: *Actor, contract: ActionContract, authority: bool) ActionFailure!void {
        if (contract.name.len == 0 or contract.purpose.len == 0) return error.PreconditionNotMet;
        if (contract.requires_authority and !authority) return error.AuthorityInsufficient;
        self.local_event_count += 1;
    }
};

pub const Agent = struct {
    name: []const u8,
    actor: *Actor,

    pub fn run(self: *Agent, action: ActionContract, authority: bool) ActionFailure!void {
        try self.actor.execute(action, authority);
    }
};

test "Action cannot expand authority" {
    var actor = Actor{ .id = "payment-actor" };
    var agent = Agent{ .name = "PaymentAgent", .actor = &actor };
    const action = ActionContract{ .name = "Payment.Execute", .purpose = "execute payment", .requires_authority = true };
    try std.testing.expectError(error.AuthorityInsufficient, agent.run(action, false));
}
