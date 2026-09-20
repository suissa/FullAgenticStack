const std = @import("std");
const fas = @import("fullagenticstack");

test "resolve does not imply authorization" {
    const i = fas.intent.CanonicalIntent{
        .label = "Financial.Pay",
        .goal = "pay",
        .authority_required = true,
    };
    try std.testing.expect(fas.intent.resolvedDoesNotAuthorize(i));
}

test "real intent resolver returns explicit unsupported instead of implicit execution" {
    var resolver = fas.intent.IntentResolver{};
    const result = resolver.resolve("do something unknown");
    switch (result) {
        .unsupported => {},
        else => return error.TestUnexpectedResult,
    }
}
