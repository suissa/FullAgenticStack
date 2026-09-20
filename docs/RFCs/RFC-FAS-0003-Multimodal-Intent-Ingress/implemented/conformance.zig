const std = @import("std");

pub const Modality = enum { text, audio, image };
pub const SemanticInput = struct {
    modality: Modality,
    normalized_text: []const u8,
    confidence: f32,
};

pub const IngressError = error{
    UnreadableInput,
    UnintelligibleAudio,
    InsufficientVisualEvidence,
    ExtractionUncertain,
};

pub fn normalizeText(text: []const u8) IngressError!SemanticInput {
    if (text.len == 0) return error.UnreadableInput;
    return .{ .modality = .text, .normalized_text = text, .confidence = 1.0 };
}

pub fn normalizeAudio(transcript: []const u8, confidence: f32) IngressError!SemanticInput {
    if (transcript.len == 0) return error.UnintelligibleAudio;
    if (confidence < 0.5) return error.ExtractionUncertain;
    return .{ .modality = .audio, .normalized_text = transcript, .confidence = confidence };
}

pub fn normalizeImage(extracted: []const u8, confidence: f32) IngressError!SemanticInput {
    if (extracted.len == 0) return error.InsufficientVisualEvidence;
    if (confidence < 0.5) return error.ExtractionUncertain;
    return .{ .modality = .image, .normalized_text = extracted, .confidence = confidence };
}

pub fn mayAuthorize(_: SemanticInput) bool {
    return false;
}

test "modality extraction never grants business authority" {
    const input = try normalizeText("pay this tomorrow");
    try std.testing.expect(!mayAuthorize(input));
}
