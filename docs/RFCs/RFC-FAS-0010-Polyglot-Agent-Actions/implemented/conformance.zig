const std = @import("std");
const fas = @import("fullagenticstack");

test "cross-language binding must preserve semantic context" {
    const b = fas.polyglot.ActionBinding{
        .action = "Payment.CryptoSign",
        .language = .rust,
        .preserves_authority = true,
        .preserves_failures = true,
        .preserves_evidence = true,
    };
    try b.validate();
}

test "polyglot binding rejects lost authority context" {
    const b = fas.polyglot.ActionBinding{
        .action = "Payment.CryptoSign",
        .language = .rust,
        .preserves_authority = false,
        .preserves_failures = true,
        .preserves_evidence = true,
    };
    try std.testing.expectError(error.AuthorityContextLost, b.validate());
}
