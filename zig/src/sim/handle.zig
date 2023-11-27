const std = @import("std");
const zarrosim = @import("zarrosim.zig");

const gtk = zarrosim.gtk;
const Context = zarrosim.Context;

const Map = std.StringHashMap(gtk.Widget);

pub const HandleMessage = enum {
    WM_INITDIALOG,
    WM_COMMAND,
};

pub const Handle = struct {
    allocator: std.mem.Allocator,
    widgets: Map,
    context: *Context,

    pub fn init(allocator: std.mem.Allocator, context: *Context) Handle {
        return .{
            .allocator = allocator,
            .widgets = Map.init(allocator),
            .context = context,
        };
    }

    pub fn deinit(self: *Handle) void {
        self.arena.deinit();
    }

    pub fn add(self: *Handle, id: []const u8, widget: gtk.Widget) !void {
        try self.widgets.put(id, widget);
    }
};

pub fn SetDlgItemText(hDlg: Handle, widgetId: usize, text: [:0]const u8) void {
    var buffer: [255]u8 = undefined;
    const widgetStr: ?[]u8 = std.fmt.bufPrint(&buffer, "{d}", .{widgetId}) catch null;
    if (widgetStr) |key| {
        if (hDlg.widgets.get(key)) |*w| {
            w.to_label().?.set_text(text);
        } else {
            std.log.warn("Widget {s} non found", .{key});
        }
    }
}

pub fn sprintf(buffer: *[:0]u8, fmt: [:0]const u8, args: anytype) void {
    buffer.* = std.fmt.bufPrintZ(&buffer, fmt, args) catch "";
}

pub fn EventWrapper(comptime I: type, comptime D: type) type {
    return struct {
        instance: *I,
        data: D,
        const Self = @This();
        pub fn new(allocator: std.mem.Allocator, instance: *I, data: D) !*Self {
            const object = try allocator.create(Self);
            object.* = .{
                .instance = instance,
                .data = data,
            };
            return object;
        }
    };
}
