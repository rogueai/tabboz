const std = @import("std");
const GTK = @import("gtk");
const gui = @import("gui");

const c = GTK.c;
const gtk = GTK.gtk;

var mainApp: *c.GtkApplication = undefined;

const Context = struct {
    allocator: std.mem.Allocator,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();

    mainApp = c.gtk_application_new("org.gtk.example", c.G_APPLICATION_FLAGS_NONE) orelse @panic("null app :(");
    defer c.g_object_unref(mainApp);

    var context = .{
        .allocator = allocator,
    };

    _ = c.g_signal_connect_data(mainApp, "activate", @as(c.GCallback, @ptrCast(&activate)), &context, null, c.G_CONNECT_AFTER);
    _ = c.g_application_run(@as(*c.GApplication, @ptrCast(mainApp)), 0, null);
    c.gtk_main();
}

pub fn activate(app: *c.GtkApplication, context: *Context) void {
    create(app, context) catch |e| {
        std.debug.print("{?}\n", .{e});
    };
}

fn create(app: *c.GtkApplication, _: *Context) !void {
    const builder = gtk.Builder.new();
    try builder.add_from_string(gui.window_tabboz);
    builder.set_application(app);
    var w = try builder.get_widget("window");
    attachTheme(@ptrCast(w.ptr));
    w.show_all();
    w.connect("delete-event", @as(c.GCallback, @ptrCast(&c.gtk_main_quit)), null);
}

fn attachTheme(window: *c.GtkWindow) void {
    const refProvider = c.gtk_css_provider_new();
    const refScreen = c.gtk_window_get_screen(window);
    const slice: [:0]const u8 = "./res/theme/gtk.css";
    var err: [*c]c.GError = null;
    _ = c.gtk_css_provider_load_from_path(refProvider, slice, &err);
    c.gtk_style_context_add_provider_for_screen(refScreen, @ptrCast(refProvider), c.GTK_STYLE_PROVIDER_PRIORITY_APPLICATION);
    c.g_clear_error(&err);
}
