const std = @import("std");
const GTK = @import("gtk");
const c = GTK.c;
const gtk = GTK.gtk;
const gui = @import("gui/gui.zig");

const Context = @import("context.zig").Context;
const I18n = @import("context.zig").I18n;

const TabaccaioWidget = @import("tabaccaioWidget.zig").TabaccaioWidget;

var mainApp: *c.GtkApplication = undefined;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();

    mainApp = c.gtk_application_new("org.gtk.example", c.G_APPLICATION_FLAGS_NONE) orelse @panic("null app :(");
    defer c.g_object_unref(mainApp);

    var i18n = I18n.init(allocator);
    // defer i18n.deinit();

    var context = Context{
        .allocator = allocator,
        .i18n = i18n,
    };

    _ = i18n.get(0);

    _ = c.g_signal_connect_data(mainApp, "activate", @as(c.GCallback, @ptrCast(&activate)), &context, null, c.G_CONNECT_AFTER);
    _ = c.g_application_run(@as(*c.GApplication, @ptrCast(mainApp)), 0, null);
    c.gtk_main();
}

pub fn activate(app: *c.GtkApplication, context: *Context) void {
    create(app, context) catch |e| {
        std.debug.print("{?}\n", .{e});
    };
}

fn create(app: *c.GtkApplication, context: *Context) !void {
    const builder = gtk.Builder.new();
    try builder.add_from_string(gui.window_tabboz);
    builder.set_application(app);
    var window: gtk.Window = try builder.get(gtk.Window, "window");
    attachTheme(@ptrCast(window.ptr));

    _ = context.i18n.get(0);
    try attachEvents(builder, context);

    window.as_widget().show_all();
    window.as_widget().connect("delete-event", @as(c.GCallback, @ptrCast(&c.gtk_main_quit)), null);
}

fn attachEvents(builder: gtk.Builder, context: *Context) !void {
    const tabaccaioMenu: gtk.MenuItem = try builder.get(gtk.MenuItem, "tabaccaioMenu");

    tabaccaioMenu.set_label("Tabaccaio");
    // tabaccaioMenuItem.set_submenu(attivitaMenu.as_widget());
    tabaccaioMenu.connect_activate(@as(c.GCallback, @ptrCast(&onTabaccaio)), context);

    // var top = attivitaMenu.as_widget().get_toplevel().to_window();
    // _ = top;

    // _ = dialog;
}

fn onTabaccaio(widget: *c.GtkWidget, context: *Context) void {
    _ = context.i18n.get(0);
    const menu = gtk.Widget.as(widget);
    var top = menu.get_toplevel().to_window();

    var dialog = gtk.Dialog.new(top, .{ .width = 200, .height = 200 }, "title", "ok", "cancel");

    var tabaccaioWidget = TabaccaioWidget.init(context);
    defer TabaccaioWidget.deinit();
    var content = tabaccaioWidget.create() catch unreachable;
    var content_area = dialog.get_content_area();
    content_area.add(content.*);

    var result = dialog.run();
    switch (result) {
        c.GTK_RESPONSE_CANCEL => {
            // instance.context.text = "false";
            std.log.debug("Cancel", .{});
        },
        c.GTK_RESPONSE_OK => {
            // instance.context.text = "true";
            std.log.debug("Ok", .{});
        },
        else => {},
    }
    // instance.update();
    dialog.as_widget().destroy();
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
