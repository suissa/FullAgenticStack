const std = @import("std");

pub const ComponentKind = enum { text, input, confirm, result };

pub const A2UIComponent = struct {
    id: []const u8,
    kind: ComponentKind,
    capability: []const u8,
    label: []const u8,
    protected_effect: bool = false,
};

pub const UIAction = struct {
    component_id: []const u8,
    intent: []const u8,
    confirmed: bool = false,
};

pub fn validateComponent(c: A2UIComponent) !void {
    if (c.id.len == 0 or c.capability.len == 0) return error.InterfaceCapabilityMismatch;
    if (c.kind == .confirm and c.label.len == 0) return error.MisleadingConfirmation;
}

pub fn invoke(c: A2UIComponent, a: UIAction) ![]const u8 {
    try validateComponent(c);
    if (!std.mem.eql(u8, c.id, a.component_id)) return error.InterfaceCapabilityMismatch;
    if (c.protected_effect and !a.confirmed) return error.UnsafeImplicitAction;
    if (!std.mem.eql(u8, c.capability, a.intent)) return error.SemanticDrift;
    return c.capability;
}
