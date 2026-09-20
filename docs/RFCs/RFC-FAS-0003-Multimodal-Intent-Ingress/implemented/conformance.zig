const std = @import("std");
const fas = @import("fullagenticstack");

test "modality extraction never grants business authority" {
    const input = try fas.multimodal.normalizeText("pay this tomorrow");
    try std.testing.expect(!fas.multimodal.mayAuthorize(input));
}

test "uncertain multimodal extraction fails explicitly" {
    try std.testing.expectError(
        error.ExtractionUncertain,
        fas.multimodal.normalizeAudio("pay tomorrow", 0.2),
    );
    try std.testing.expectError(
        error.ExtractionUncertain,
        fas.multimodal.normalizeImage("invoice", 0.2),
    );
}
