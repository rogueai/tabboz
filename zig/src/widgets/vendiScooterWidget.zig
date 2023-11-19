const std = @import("std");
const GTK = @import("gtk");
const gui = @import("gui");

const RissaWidget = @import("rissaWidget.zig").RissaWidget;

const c = GTK.c;
const gtk = GTK.gtk;

// const WidgetMap = std.StringHashMap(gtk.Widget);

// pub const VendiScooterWidget = struct {
//     ptr: gtk.Widget = undefined,
//     widgets: WidgetMap = undefined,
//     allocator: std.mem.Allocator = undefined,
//     const Self = @This();

//     pub fn init(allocator: std.mem.Allocator) !VendiScooterWidget {
//         const builder = gtk.Builder.new();
//         try builder.add_from_string(gui.window_71);
//         // Connect signal handlers to the constructed widgets.
//         //

//         const window = try builder.get_widget("window_71");
//         _ = window.connect("destroy", @as(c.GCallback, @ptrCast(&c.gtk_main_quit)), null);

//         {
//             const image = try builder.get_widget("image1");
//             const slice: [:0]const u8 = "./res/1252.BMP";
//             c.gtk_image_set_from_file(@ptrCast(image.ptr), slice);
//         }
//         {
//             const image = try builder.get_widget("image2");
//             const slice: [:0]const u8 = "../../res/0001.png";

//             const stat = try std.fs.cwd().statFile("VendiScooterWidget.zig");
//             std.debug.print("{s}\n", .{@tagName(stat.kind)});

//             c.gtk_image_set_from_file(@ptrCast(image.ptr), slice);
//         }

// var buf: [std.fs.MAX_PATH_BYTES]u8 = undefined;
// const cwd = try std.os.getcwd(&buf);
// std.debug.print("cwd: {}\n\n\n", .{cwd});

//         var widgets = WidgetMap.init(allocator);

//         // save widgets for later
//         try widgets.put("window", window);
//         try widgets.put("001", try builder.get_widget("001"));
//         try widgets.put("002", try builder.get_widget("002"));
//         try widgets.put("003", try builder.get_widget("003"));
//         try widgets.put("004", try builder.get_widget("004"));
//         try widgets.put("005", try builder.get_widget("005"));
//         try widgets.put("006", try builder.get_widget("006"));
//         try widgets.put("ok", try builder.get_widget("ok"));

//         return VendiScooterWidget{
//             .ptr = window,
//             .widgets = widgets,
//             .allocator = allocator,
//         };
//     }

//     pub fn deinit(self: *Self) void {
//         self.ptr.destroy();
//         self.widgets.deinit();
//     }

//     pub fn show(self: *Self) void {
//         self.ptr.show_now();
//     }

//     pub fn setTextLabel(self: *Self, id: []const u8, text: [:0]const u8) !void {
//         const ptr = self.widgets.get(id).?.ptr;
//         c.gtk_label_set_text(@ptrCast(ptr), text);
//     }
// };

pub fn main() !void {
    const app = c.gtk_application_new("org.gtk.example", c.G_APPLICATION_FLAGS_NONE) orelse @panic("null app :(");
    defer c.g_object_unref(app);

    _ = c.g_signal_connect_data(app, "activate", @as(c.GCallback, @ptrCast(&activate)), null, null, c.G_CONNECT_AFTER);
    _ = c.g_application_run(@as(*c.GApplication, @ptrCast(app)), 0, null);
}

fn activate(app: *c.GtkApplication) !void {
    _ = app;
    const builder = gtk.Builder.new();
    builder.add_from_string(gui.window_71) catch |e| {
        std.debug.print("{}\n", .{e});
        return;
    };
    // builder.set_application(app);
    // Builder.get_widget() returns an optional, so unwrap if there is a value
    var w = try builder.get_widget("window_71");

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

    var buf: [std.fs.MAX_PATH_BYTES]u8 = undefined;
    const cwd = try std.os.getcwd(&buf);
    std.debug.print("cwd: {s}\n\n\n", .{cwd});

    const refProvider = c.gtk_css_provider_new();
    const refScreen = c.gtk_window_get_screen(@ptrCast(w.ptr));

    const slice: [:0]const u8 = "./res/theme/gtk.css";
    var err: [*c]c.GError = null;
    _ = c.gtk_css_provider_load_from_path(@ptrCast(refProvider), slice, &err);
    c.gtk_style_context_add_provider_for_screen(@ptrCast(refScreen), @ptrCast(refProvider), c.GTK_STYLE_PROVIDER_PRIORITY_APPLICATION);

    w.show_all();
    w.connect("delete-event", @as(c.GCallback, @ptrCast(&c.gtk_main_quit)), null);

    var okButton: gtk.Widget = try builder.get_widget("ok");
    okButton.connectWidget("clicked", openDialog);

    c.gtk_main();
}

// pub fn main() !u8 {
//     var gpa = std.heap.GeneralPurposeAllocator(.{}){};
//     var allocator = gpa.allocator();
//     // defer std.debug.assert(gpa.deinit() == .ok);

//     c.gtk_init(0, null);

//     var widget: VendiScooterWidget = try VendiScooterWidget.init(allocator);
//     defer widget.deinit();

//     try widget.setTextLabel("001", "aseo");
//     var okButton: gtk.Widget = widget.widgets.get("ok").?;
//     var window: gtk.Widget = widget.widgets.get("window").?;

//     okButton.connectWidgetWithData(gtk.Widget, "clicked", openDialog, &window);
//     widget.show();

//     c.gtk_main();

//     return 0;
// }
fn openDialog(button: *gtk.Widget) void {
    _ = button;
    const ok: [:0]const u8 = "Ok";
    const cancel: [:0]const u8 = "Cancel";

    var dialog = c.gtk_dialog_new();

    // var parent = button.get_root_window();
    // _ = parent;
    // c.gtk_widget_set_parent_window(@ptrCast(dialog), @ptrCast(parent));
    c.gtk_window_set_destroy_with_parent(@ptrCast(dialog), c.gtk_false());
    c.gtk_window_set_title(@ptrCast(dialog), "title");
    // c.gtk_window_set_transient_for(@ptrCast(dialog), @ptrCast(parent));
    // _ = window.connect("destroy", @as(c.GCallback, @ptrCast(&c.gtk_main_quit)), null);
    _ = c.gtk_dialog_add_button(@ptrCast(dialog), ok, c.GTK_RESPONSE_OK);
    _ = c.gtk_dialog_add_button(@ptrCast(dialog), cancel, c.GTK_RESPONSE_CANCEL);
    //

    // c.gtk.
    var content_area = c.gtk_dialog_get_content_area(@ptrCast(dialog));

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();

    var widget = RissaWidget().init(allocator) catch unreachable;
    c.gtk_container_add(@ptrCast(content_area), @ptrCast(widget.ptr.ptr));
    c.gtk_window_set_default_size(@ptrCast(dialog), 300, 300);
    c.gtk_widget_show_all(@ptrCast(dialog));

    var result = c.gtk_dialog_run(@ptrCast(dialog));
    std.log.debug("Result {?}\n", .{result});

    switch (result) {
        c.GTK_RESPONSE_ACCEPT => {
            std.log.debug("Response\n", .{});
        },
        c.GTK_RESPONSE_OK => {
            std.log.debug("Response\n", .{});
        },
        else => {},
    }
    c.gtk_widget_hide(@ptrCast(dialog));
    std.log.debug("Exit\n", .{});
    // return;
}
