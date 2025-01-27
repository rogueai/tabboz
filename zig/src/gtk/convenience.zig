usingnamespace @import("cimport.zig");
usingnamespace @import("enums.zig");

const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

/// The Gtk function g_signal_connect is defined in a macro which is unfortunately
/// broken for translate-c, so we redefine the function doing what the orignal
/// does internally as  workaround.
pub fn signal_connect(instance: gpointer, detailed_signal: [*c]const gchar, c_handler: GCallback, data: gpointer) gulong {
    var zero: u32 = 0;
    const flags: *GConnectFlags = @as(*GConnectFlags, @ptrCast(&zero));
    return g_signal_connect_data(instance, detailed_signal, c_handler, data, null, flags.*);
}

/// Convenience function which returns a proper GtkWidget pointer or null
pub fn builder_get_widget(builder: *GtkBuilder, name: [*]const u8) ?*GtkWidget {
    const obj = gtk_builder_get_object(builder, name);
    if (obj == null) {
        return null;
    } else {
        var gobject = @as([*c]GTypeInstance, @ptrCast(obj));
        var gwidget = @as(*GtkWidget, @ptrCast(g_type_check_instance_cast(gobject, gtk_widget_get_type())));
        return gwidget;
    }
}

/// Convenience function which returns a proper GtkAdjustment pointer or null
pub fn builder_get_adjustment(builder: *GtkBuilder, name: [*]const u8) ?*GtkAdjustment {
    const obj = gtk_builder_get_object(builder, name);
    if (obj == null) {
        return null;
    } else {
        var gobject = @as([*c]GTypeInstance, @ptrCast(obj));
        var adjustment = @as(*GtkAdjustment, @ptrCast(gobject));
        return adjustment;
    }
}

/// Convenience function which returns a proper bool instead of 0 or 1
pub fn toggle_button_get_active(but: *GtkToggleButton) bool {
    if (gtk_toggle_button_get_active(but) == 0) {
        return false;
    } else {
        return true;
    }
}

/// Convenience function which takes a proper bool instead of 0 or 1
pub fn widget_set_sensitive(widget: *GtkWidget, state: bool) void {
    if (state) {
        gtk_widget_set_sensitive(widget, 1);
    } else {
        gtk_widget_set_sensitive(widget, 0);
    }
}

/// Convenience function which takes a prope bool instead of 0 or 1
pub fn widget_set_visible(widget: *GtkWidget, state: bool) void {
    if (state) {
        gtk_widget_set_visible(widget, 1);
    } else {
        gtk_widget_set_visible(widget, 0);
    }
}

/// Convenience function which takes a bool and returns a c_int
pub fn bool_to_c_int(boolean: bool) c_int {
    const val: c_int = if (boolean) 1 else 0;
    return val;
}
