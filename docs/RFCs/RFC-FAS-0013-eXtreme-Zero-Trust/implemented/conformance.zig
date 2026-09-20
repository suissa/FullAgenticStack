const std = @import("std");
const fas = @import("fullagenticstack");

test "internal location never substitutes for zero-trust checks" {
    const ctx = fas.zero_trust.TrustContext{
        .authenticated = true,
        .authorized = false,
        .proof_of_possession = true,
        .scope_valid = true,
        .context_valid = true,
        .replay_detected = false,
    };
    try std.testing.expect(!fas.zero_trust.allowProtectedEffect(ctx));
}

test "replay detection vetoes otherwise valid protected effect" {
    const ctx = fas.zero_trust.TrustContext{
        .authenticated = true,
        .authorized = true,
        .proof_of_possession = true,
        .scope_valid = true,
        .context_valid = true,
        .replay_detected = true,
    };
    try std.testing.expect(!fas.zero_trust.allowProtectedEffect(ctx));
}
