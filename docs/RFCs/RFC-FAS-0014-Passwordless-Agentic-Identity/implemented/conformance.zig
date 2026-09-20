const std = @import("std");
const fas = @import("fullagenticstack");

test "extreme identity is passwordless and email independent" {
    const id = fas.identity.Identity{
        .subject = "human:1",
        .credential = .passkey,
        .proof_valid = true,
    };
    try id.validateExtreme();
    try std.testing.expect(!fas.identity.authenticationImpliesAuthorization(id));
}

test "password requirement is non-conforming in extreme identity" {
    const id = fas.identity.Identity{
        .subject = "human:1",
        .credential = .passkey,
        .password_required = true,
        .proof_valid = true,
    };
    try std.testing.expectError(error.PasswordForbidden, id.validateExtreme());
}
