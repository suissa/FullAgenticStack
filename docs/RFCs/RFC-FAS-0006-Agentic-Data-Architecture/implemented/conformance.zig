const std = @import("std");
const fas = @import("fullagenticstack");

test "reference polyglot plane preserves write authority" {
    const plane = fas.data.DataPlane{ .bindings = &fas.data.reference_polyglot };
    try plane.validate();
}

test "derived store cannot silently become canonical" {
    const bad = [_]fas.data.StoreBinding{
        .{ .responsibility = .write, .technology = "PostgreSQL", .authoritative = true },
        .{ .responsibility = .read, .technology = "MongoDB", .authoritative = true },
        .{ .responsibility = .cache, .technology = "Redis", .authoritative = false },
        .{ .responsibility = .vector, .technology = "Qdrant", .authoritative = false },
        .{ .responsibility = .graph, .technology = "Cozo", .authoritative = false },
        .{ .responsibility = .events, .technology = "EventStoreDB", .authoritative = false },
        .{ .responsibility = .observability, .technology = "Tempo", .authoritative = false },
    };
    try std.testing.expectError(
        error.DerivedStoreCannotBeCanonical,
        (fas.data.DataPlane{ .bindings = &bad }).validate(),
    );
}
