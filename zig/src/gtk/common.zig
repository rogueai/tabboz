const c = @import("cimport.zig");
const enums = @import("enums.zig");
const Widget = @import("widget.zig").Widget;

const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

pub fn signal_connect(instance: c.gpointer, detailed_signal: [*c]const c.gchar, c_handler: c.GCallback, data: c.gpointer) c.gulong {
    var zero: u32 = 0;
    const flags: *c.GConnectFlags = @as(*c.GConnectFlags, @ptrCast(&zero));
    return c.g_signal_connect_data(instance, detailed_signal, c_handler, data, null, flags.*);
}

pub fn signal_connect_swapped(instance: c.gpointer, detailed_signal: [*c]const c.gchar, c_handler: c.GCallback, data: c.gpointer) c.gulong {
    return c.g_signal_connect_data(instance, detailed_signal, c_handler, data, null, c.G_CONNECT_SWAPPED);
}

/// Convenience function which returns a proper GtkWidget pointer or null
pub fn builder_get_widget(builder: *c.GtkBuilder, name: [*]const u8) ?*c.GtkWidget {
    const obj = c.gtk_builder_get_object(builder, name);
    if (obj == null) {
        return null;
    } else {
        const gobject = @as([*c]c.GTypeInstance, @ptrCast(obj));
        const gwidget = @as(*c.GtkWidget, @ptrCast(c.g_type_check_instance_cast(gobject, c.gtk_widget_get_type())));
        return gwidget;
    }
}

/// Convenience function which returns a proper GtkAdjustment pointer or null
pub fn builder_get_adjustment(builder: *c.GtkBuilder, name: [*]const u8) ?*c.GtkAdjustment {
    const obj = c.gtk_builder_get_object(builder, name);
    if (obj == null) {
        return null;
    } else {
        const gobject = @as([*c]c.GTypeInstance, @ptrCast(obj));
        const adjustment = @as(*c.GtkAdjustment, @ptrCast(gobject));
        return adjustment;
    }
}

/// Convenience function which returns a proper bool instead of 0 or 1
pub fn toggle_button_get_active(but: *c.GtkToggleButton) bool {
    return (c.gtk_toggle_button_get_active(but) == 1);
}

/// Convenience function which takes a proper bool instead of 0 or 1
pub fn widget_set_sensitive(widget: *c.GtkWidget, state: bool) void {
    c.gtk_widget_set_sensitive(widget, bool_to_c_int(state));
}

/// Convenience function which takes a prope bool instead of 0 or 1
pub fn widget_set_visible(widget: *c.GtkWidget, state: bool) void {
    c.gtk_widget_set_visible(widget, bool_to_c_int(state));
}

/// Convenience function which takes a bool and returns a c_int
pub fn bool_to_c_int(boolean: bool) c_int {
    return if (boolean) 1 else 0;
}

/// Convenience function which converts a GSlist singly-linked list to
/// a Zig ArrayList
pub fn gslistToArrayList(in: c.GSlist, allocator: mem.Allocator) ?std.ArrayList(Widget) {
    var list = std.ArrayList(Widget).init(allocator);
    while (in) |ptr| {
        list.append(Widget{ .ptr = @as(*c.GtkWidget, @ptrCast(@alignCast(ptr.*.data))) }) catch {
            list.deinit();
            return null;
        };
        in = ptr.*.next;
    }
    return list;
}
