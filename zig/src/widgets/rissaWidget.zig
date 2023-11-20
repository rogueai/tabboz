const std = @import("std");
const GTK = @import("gtk");
const gui = @import("gui");

const c = GTK.c;
const gtk = GTK.gtk;

pub fn RissaWidget() type {
    const WidgetMap = std.StringHashMap(gtk.Widget);
    return struct {
        ptr: gtk.Widget,
        widgets: WidgetMap,

        const Self = @This();

        pub fn init(allocator: std.mem.Allocator) !Self {
            const builder = gtk.Builder.new();
            try builder.add_from_string(gui.window_100);
            // Connect signal handlers to the constructed widgets.
            const window = try builder.get_widget("window_100");
            // _ = window.connect("destroy", @as(c.GCallback, @ptrCast(&c.gtk_main_quit)), null);

            const image = try builder.get_widget("image");
            const slice: [:0]const u8 = "./res/1283.BMP";
            c.gtk_image_set_from_file(@ptrCast(image.ptr), slice);

            const label = try builder.get_widget("text");
            c.gtk_label_set_text(@ptrCast(label.ptr), "Insulti un gruppo di metallari che passano per xxx e uno di questi ti spacca le ossa");

            const button = try builder.get_widget("button");
            button.connectWidget("clicked", printHello);

            var widgets = WidgetMap.init(allocator);

            return Self{
                .ptr = window,
                .widgets = widgets,
            };
        }

        pub fn deinit(self: *Self) void {
            self.ptr.destroy();
            self.widgets.deinit();
        }

        pub fn show(self: *Self) void {
            self.ptr.show_now();
        }

        fn printHello(_: *gtk.Widget) void {
            std.log.debug("Hello World", .{});
        }
    };
}

pub fn main() !u8 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer std.debug.assert(gpa.deinit() == .ok);

    c.gtk_init(0, null);

    var widget = try RissaWidget().init(allocator);
    defer widget.deinit();
    widget.show();

    c.gtk_main();

    return 0;
}
