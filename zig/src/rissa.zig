const std = @import("std");
const GTK = @import("gtk");
const c = GTK.c;
const gtk = GTK.gtk;

const builderDecl = @embedFile("./gui/100.glade");

pub fn main() !u8 {
    c.gtk_init(0, null);

    const builder = gtk.Builder.new();
    try builder.add_from_string(builderDecl);

    // Connect signal handlers to the constructed widgets.
    const window = try builder.get_widget("window_100");
    _ = window.connect("destroy", @as(c.GCallback, @ptrCast(&c.gtk_main_quit)), null);

    const image = try builder.get_widget("image");
    const slice: [:0]const u8 = "./res/1283.BMP";
    c.gtk_image_set_from_file(@ptrCast(image.ptr), slice);

    const label = try builder.get_widget("text");
    c.gtk_label_set_text(@ptrCast(label.ptr), "Insulti un gruppo di metallari che passano per xxx e uno di questi ti spacca le ossa");

    const button = try builder.get_widget("button");
    button.connectWidget("clicked", printHello, null);

    c.gtk_main();

    return 0;
}

pub fn printHello(_: *gtk.Widget) void {
    std.log.debug("Hello World\n", .{});
}
