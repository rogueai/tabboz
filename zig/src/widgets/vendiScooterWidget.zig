const std = @import("std");
const GTK = @import("gtk");
const gui = @import("gui");

const RissaWidget = @import("rissaWidget.zig").RissaWidget;

const c = GTK.c;
const gtk = GTK.gtk;

var mainApp: *c.GtkApplication = undefined;

const Context = struct {
    allocator: std.mem.Allocator,
    text: ?[:0]const u8,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();

    var context = .{
        .allocator = allocator,
        .text = undefined,
    };

    mainApp = c.gtk_application_new("org.gtk.example", c.G_APPLICATION_FLAGS_NONE) orelse @panic("null app :(");
    defer c.g_object_unref(mainApp);

    var vendiScooterWidget = VendiScooterWidget.init(&context);

    _ = c.g_signal_connect_data(mainApp, "activate", @as(c.GCallback, @ptrCast(&VendiScooterWidget.activate)), &vendiScooterWidget, null, c.G_CONNECT_AFTER);
    _ = c.g_application_run(@as(*c.GApplication, @ptrCast(mainApp)), 0, null);
    c.gtk_main();
}

pub const VendiScooterWidget = struct {
    context: *Context,
    widgets: std.StringHashMap(gtk.Widget),

    const Self = @This();

    pub fn init(context: *Context) Self {
        return .{
            .context = context,
            .widgets = std.StringHashMap(gtk.Widget).init(context.allocator),
        };
    }

    pub fn activate(app: *c.GtkApplication, instance: *Self) void {
        instance.create(app) catch |e| {
            std.debug.print("{}\n", .{e});
        };
    }

    fn create(self: *Self, app: *c.GtkApplication) !void {
        const builder = gtk.Builder.new();
        builder.add_from_string(gui.window_71) catch |e| {
            std.debug.print("{}\n", .{e});
            return;
        };
        builder.set_application(app);
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

        try self.widgets.put("001", try builder.get_widget("001"));
        try self.widgets.put("002", try builder.get_widget("002"));
        try self.widgets.put("003", try builder.get_widget("003"));
        try self.widgets.put("004", try builder.get_widget("004"));
        try self.widgets.put("005", try builder.get_widget("005"));
        try self.widgets.put("006", try builder.get_widget("006"));

        var buf: [std.fs.MAX_PATH_BYTES]u8 = undefined;
        const cwd = try std.os.getcwd(&buf);
        std.debug.print("cwd: {s}\n\n\n", .{cwd});

        const refProvider = c.gtk_css_provider_new();
        const refScreen = c.gtk_window_get_screen(@ptrCast(w.ptr));

        const slice: [:0]const u8 = "./res/theme/gtk.css";
        var err: [*c]c.GError = null;
        _ = c.gtk_css_provider_load_from_path(refProvider, slice, &err);
        c.gtk_style_context_add_provider_for_screen(refScreen, @ptrCast(refProvider), c.GTK_STYLE_PROVIDER_PRIORITY_APPLICATION);

        w.show_all();
        w.connect("delete-event", @as(c.GCallback, @ptrCast(&c.gtk_main_quit)), null);

        var okButton: gtk.Widget = try builder.get_widget("ok");
        // const parent = okButton.get_root_window();
        // std.log.debug("Result {?}\n", .{parent});
        // okButton.connectWidget("clicked", openDialog);
        okButton.connect("clicked", @as(c.GCallback, @ptrCast(&openDialog)), self);
    }

    fn openDialog(widget: *c.GtkButton, instance: *Self) void {
        _ = widget;
        // const root_window = c.gtk_widget_get_root_window(@ptrCast(widget));

        var dialog = gtk.Dialog.new(null, "title", "ok", "cancel");
        dialog.as_window().set_default_size(300, 300);
        dialog.as_widget().show_all();

        var rissa = RissaWidget().init(instance.context.allocator) catch unreachable;
        var content_area = dialog.get_content_area();
        content_area.to_container().?.add(rissa.ptr);

        var result = dialog.run();
        std.log.debug("Result {?}\n", .{result});

        switch (result) {
            c.GTK_RESPONSE_CANCEL => {
                instance.context.text = "false";
                std.log.debug("Response\n", .{});
            },
            c.GTK_RESPONSE_OK => {
                instance.context.text = "true";
                std.log.debug("Response\n", .{});
            },
            else => {},
        }
        instance.update();
        dialog.as_widget().destroy();
    }

    fn update(self: Self) void {
        if (self.widgets.get("001")) |*w| {
            w.to_label().?.set_text(self.context.text.?);
        }
    }
};
