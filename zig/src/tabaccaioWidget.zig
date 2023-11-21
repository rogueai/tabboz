const std = @import("std");
const GTK = @import("gtk");
const c = GTK.c;
const gtk = GTK.gtk;
const gui = @import("gui/gui.zig");
const Context = @import("context.zig").Context;

const SelectEvent = struct {
    self: *TabaccaioWidget,
    n: usize,
};

pub const TabaccaioWidget = struct {
    const Self = @This();
    const Map = std.StringHashMap(gtk.Widget);

    var widgets: Map = undefined;
    var context: *Context = undefined;

    pub fn init(_context: *Context) Self {
        widgets = Map.init(_context.allocator);
        context = _context;
        return .{};
    }

    pub fn deinit() void {
        widgets.deinit();
    }

    pub fn create(self: *Self) !*gtk.Widget {
        const builder = gtk.Builder.new();
        builder.add_from_string(gui.window_88) catch |e| {
            std.debug.print("{?}\n", .{e});
        };
        // Builder.get_widget() returns an optional, so unwrap if there is a value
        var w = try builder.get_widget("window");

        try widgets.put("message", try builder.get_widget("message"));

        var grid: gtk.Grid = try builder.get(gtk.Grid, "grid");

        var buffer: [24]u8 = undefined;
        for (0..24) |i| {
            var button = gtk.Button.new();
            const fileName = try std.fmt.bufPrintZ(&buffer, "./res/{d}.BMP", .{i + 1400});
            var image = gtk.Image.new_from_file(fileName);
            button.set_image(image.as_widget());

            var event = try context.allocator.create(SelectEvent);
            event.* = .{
                .self = self,
                .n = i,
            };
            button.as_widget().connect("clicked", @as(c.GCallback, @ptrCast(&onSelect)), event);

            const left = i % 8;
            const top = @divTrunc(i, 8);
            grid.attach(button.as_widget(), @as(c_int, @intCast(left)), @as(c_int, @intCast(top)), 1, 1);
        }

        w.show_all();
        w.connect("delete-event", @as(c.GCallback, @ptrCast(&c.gtk_main_quit)), null);

        // var okButton: gtk.Widget = try builder.get_widget("ok");
        // const parent = okButton.get_root_window();
        // std.log.debug("Result {?}\n", .{parent});
        // okButton.connectWidget("clicked", openDialog);
        // okButton.connect("clicked", @as(c.GCallback, @ptrCast(&openDialog)), self);

        return &w;
    }

    fn onSelect(_: *c.GtkButton, event: *SelectEvent) void {
        const label = widgets.get("message");
        if (label) |l| {
            if (context.i18n.get(1400 + event.n)) |text| {
                std.log.debug("{s}", .{text});
                l.to_label().?.set_text(text);
            }
        }
    }
};
