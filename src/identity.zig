pub const CredentialKind = enum { passkey, device_key, agent_ed25519, mtls, dpop };

pub const Identity = struct {
    subject: []const u8,
    credential: CredentialKind,
    email_required: bool = false,
    password_required: bool = false,
    proof_valid: bool = false,

    pub fn validateExtreme(self: Identity) !void {
        if (self.password_required) return error.PasswordForbidden;
        if (self.email_required) return error.EmailIdentityForbidden;
        if (!self.proof_valid) return error.IdentityProofInvalid;
    }
};

pub const HumanLogin = struct {
    whatsapp_context: ?[]const u8 = null,
    passkey_verified: bool,

    pub fn authenticated(self: HumanLogin) bool {
        return self.passkey_verified;
    }
};

pub fn authenticationImpliesAuthorization(_: Identity) bool {
    return false;
}
