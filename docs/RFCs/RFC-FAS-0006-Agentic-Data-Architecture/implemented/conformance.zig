const std = @import("std");

pub const Responsibility = enum { write, read, cache, vector, graph, events, observability };

pub const StoreBinding = struct {
    responsibility: Responsibility,
    technology: []const u8,
    authoritative: bool,
};

pub const DataPlane = struct {
    bindings: []const StoreBinding,

    pub fn has(self: DataPlane, r: Responsibility) bool {
        for (self.bindings) |b| if (b.responsibility == r) return true;
        return false;
    }

    pub fn validate(self: DataPlane) !void {
        inline for ([_]Responsibility{ .write, .read, .cache, .vector, .graph, .events, .observability }) |r| {
            if (!self.has(r)) return error.MissingResponsibility;
        }
        for (self.bindings) |b| {
            if (b.responsibility != .write and b.authoritative) return error.DerivedStoreCannotBeCanonical;
        }
    }
};

pub const reference_polyglot = [_]StoreBinding{
    .{ .responsibility = .write, .technology = "PostgreSQL", .authoritative = true },
    .{ .responsibility = .read, .technology = "MongoDB", .authoritative = false },
    .{ .responsibility = .cache, .technology = "Redis", .authoritative = false },
    .{ .responsibility = .vector, .technology = "Qdrant", .authoritative = false },
    .{ .responsibility = .graph, .technology = "Neo4j/Cozo", .authoritative = false },
    .{ .responsibility = .events, .technology = "EventStoreDB/BadgerDB", .authoritative = false },
    .{ .responsibility = .observability, .technology = "ClickHouse/Tempo", .authoritative = false },
};

test "reference polyglot plane preserves write authority" {
    const plane = DataPlane{ .bindings = &reference_polyglot };
    try plane.validate();
}
