const std = @import("std");
const zarrosim = @import("sim/zarrosim.zig");
const handle = @import("sim/handle.zig");
const vestiti = @import("sim/vestiti.zig");

const c = zarrosim.c;
const gtk = zarrosim.gtk;

const Handle = handle.Handle;

var arena: std.heap.ArenaAllocator = undefined;

pub const TabaccaioWidget = struct {
    const Self = @This();

    const OnSelectData = handle.EventWrapper(Self, usize);

    handle: Handle,

    pub fn init(allocator: std.mem.Allocator, context: *zarrosim.Context) Self {
        arena = std.heap.ArenaAllocator.init(allocator);
        return Self{
            .handle = Handle.init(arena.allocator(), context),
        };
    }

    pub fn deinit(self: *Self) void {
        _ = self;
        defer arena.deinit();
    }

    pub fn create(self: *Self) !*gtk.Widget {
        const builder = gtk.Builder.new();
        builder.add_from_string(zarrosim.ui.window_88) catch |e| {
            std.debug.print("{?}\n", .{e});
        };
        // Builder.get_widget() returns an optional, so unwrap if there is a value
        var w = try builder.get_widget("window");

        try self.handle.add("message", try builder.get_widget("message"));

        var grid: gtk.Grid = try builder.get(gtk.Grid, "grid");

        var buffer: [24]u8 = undefined;
        for (400..424) |i| {
            var button = gtk.Button.new();
            const fileName = try std.fmt.bufPrintZ(&buffer, "./res/{d}.BMP", .{i + 1000});
            var image = gtk.Image.new_from_file(fileName);
            button.set_image(image.as_widget());

            const event: *OnSelectData = OnSelectData.new(self.handle.allocator, self, i) catch unreachable;
            button.as_widget().connectWidget(OnSelectData, "clicked", onSelect, event);

            const left = i % 8;
            const top = @divTrunc(i, 8);
            grid.attach(button.as_widget(), left, top, 1, 1);
        }
        //_ = try zarrosim.mostraSoldi(self.handle.allocator, 10);
        _ = vestiti.Tabaccaio(self.handle, handle.HandleMessage.WM_INITDIALOG, null) catch unreachable;

        w.show_all();
        w.connect("delete-event", @as(c.GCallback, @ptrCast(&c.gtk_main_quit)), null);

        // var okButton: gtk.Widget = try builder.get_widget("ok");
        // const parent = okButton.get_root_window();
        // std.log.debug("Result {?}\n", .{parent});
        // okButton.connectWidget("clicked", openDialog);
        // okButton.connect("clicked", @as(c.GCallback, @ptrCast(&openDialog)), self);

        return &w;
    }

    fn onSelect(_: *c.GtkWidget, event: *OnSelectData) void {
        _ = vestiti.Tabaccaio(event.instance.handle, handle.HandleMessage.WM_COMMAND, event.data) catch unreachable;
    }
};
