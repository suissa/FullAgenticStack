pub const CryptoProfile = struct {
    aead: []const u8 = "XChaCha20-Poly1305",
    signing: []const u8 = "Ed25519",
    key_agreement: []const u8 = "X25519",
    kdf: []const u8 = "HKDF-SHA-256",
    hash: []const u8 = "BLAKE3/SHA-256",
    mac: []const u8 = "HMAC-SHA-256",
    pqc: []const u8 = "ML-KEM",
};

pub const TrustContext = struct {
    authenticated: bool,
    authorized: bool,
    proof_of_possession: bool,
    scope_valid: bool,
    context_valid: bool,
    replay_detected: bool,
};

pub fn allowProtectedEffect(ctx: TrustContext) bool {
    return ctx.authenticated and
        ctx.authorized and
        ctx.proof_of_possession and
        ctx.scope_valid and
        ctx.context_valid and
        !ctx.replay_detected;
}

pub const NetworkProfile = struct {
    quic: bool = true,
    tls13: bool = true,
    mtls: bool = true,
    dpop: bool = true,
    edge_wall: []const u8 = "UbiQEdgeWall",
    semantic_wall: []const u8 = "UbiQSemanticWall",
};
