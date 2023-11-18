const std = @import("std");
const GTK = @import("gtk");
const gui = @import("gui");

const c = GTK.c;
const gtk = GTK.gtk;

pub fn VendiScooterWidget() type {
    const WidgetMap = std.StringHashMap(gtk.Widget);
    return struct {
        ptr: gtk.Widget,
        widgets: WidgetMap,

        const Self = @This();

        pub fn init(allocator: std.mem.Allocator) !Self {
            const builder = gtk.Builder.new();
            try builder.add_from_string(gui.window_71);
            // Connect signal handlers to the constructed widgets.
            const window = try builder.get_widget("window_71");
            _ = window.connect("destroy", @as(c.GCallback, @ptrCast(&c.gtk_main_quit)), null);

            {
                const image = try builder.get_widget("image1");
                const slice: [:0]const u8 = "./res/1252.BMP";
                c.gtk_image_set_from_file(@ptrCast(image.ptr), slice);
            }
            {
                const image = try builder.get_widget("image2");
                const slice: [:0]const u8 = "./res/0001.png";
                c.gtk_image_set_from_file(@ptrCast(image.ptr), slice);
            }

            var widgets = WidgetMap.init(allocator);

            // save widgets for later
            try widgets.put("001", try builder.get_widget("001"));
            try widgets.put("002", try builder.get_widget("002"));
            try widgets.put("003", try builder.get_widget("003"));
            try widgets.put("004", try builder.get_widget("004"));
            try widgets.put("005", try builder.get_widget("005"));
            try widgets.put("006", try builder.get_widget("006"));

            // const label = try self.builder.get_widget("text");
            // c.gtk_label_set_text(@ptrCast(label.ptr), "Insulti un gruppo di metallari che passano per xxx e uno di questi ti spacca le ossa");

            // const button = try self.builder.get_widget("button");
            // button.connectWidget("clicked", printHello, null);
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

        pub fn setTextLabel(self: *Self, id: []const u8, text: [:0]const u8) !void {
            const ptr = self.widgets.get(id).?.ptr;
            c.gtk_label_set_text(@ptrCast(ptr), text);
        }

        pub fn printHello(_: *gtk.Widget) void {
            std.log.debug("Hello World\n", .{});
        }
    };
}

pub fn main() !u8 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer std.debug.assert(gpa.deinit() == .ok);

    c.gtk_init(0, null);

    var widget = try VendiScooterWidget().init(allocator);
    defer widget.deinit();
    widget.show();

    try widget.setTextLabel("001", "aseo");

    c.gtk_main();

    return 0;
}
