const std = @import("std");

pub const Language = enum { zig, rust, go, typescript, python, prolog, haskell, wasm };

pub const ActionBinding = struct {
    action: []const u8,
    language: Language,
    preserves_authority: bool,
    preserves_failures: bool,
    preserves_evidence: bool,

    pub fn validate(self: ActionBinding) !void {
        if (self.action.len == 0) return error.ContractMismatch;
        if (!self.preserves_authority) return error.AuthorityContextLost;
        if (!self.preserves_failures) return error.SemanticSerializationLoss;
        if (!self.preserves_evidence) return error.EvidenceContextLost;
    }
};

pub fn preferredLanguage(action: []const u8) Language {
    if (std.mem.find(u8, action, "Policy") != null) return .prolog;
    if (std.mem.find(u8, action, "ML") != null) return .python;
    if (std.mem.find(u8, action, "UI") != null) return .typescript;
    if (std.mem.find(u8, action, "Crypto") != null) return .rust;
    return .zig;
}

test "cross-language binding must preserve semantic context" {
    const b = ActionBinding{
        .action = "Payment.CryptoSign",
        .language = .rust,
        .preserves_authority = true,
        .preserves_failures = true,
        .preserves_evidence = true,
    };
    try b.validate();
}
