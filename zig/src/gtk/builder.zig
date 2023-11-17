const c = @import("cimport.zig");
const Widget = @import("widget.zig").Widget;

const std = @import("std");
const mem = std.mem;

const BuilderError = error{
    ParseStringError,
    ParseFileError,
    WidgetNotFoundError,
};

pub const Builder = struct {
    ptr: *c.GtkBuilder,

    pub fn new() Builder {
        return Builder{
            .ptr = c.gtk_builder_new(),
        };
    }

    pub fn add_from_string(self: Builder, string: []const u8) BuilderError!void {
        var err: [*c]c.GError = null;
        if (c.gtk_builder_add_from_string(self.ptr, string.ptr, string.len, &err) == 0) {
            c.g_printerr("Error loading embedded builder: %s\n", err.*.message);
            c.g_clear_error(&err);
            return BuilderError.ParseStringError;
        }
    }

    pub fn get_widget(self: Builder, string: [:0]const u8) !Widget {
        if (builder_get_widget(self.ptr, string.ptr)) |w| {
            return Widget{ .ptr = w };
        } else return BuilderError.WidgetNotFoundError;
    }

    pub fn set_application(self: Builder, app: *c.GtkApplication) void {
        c.gtk_builder_set_application(self.ptr, app);
    }

    /// Convenience function which returns a proper GtkWidget pointer or null
    fn builder_get_widget(builder: *c.GtkBuilder, name: [*]const u8) ?*c.GtkWidget {
        const obj = c.gtk_builder_get_object(builder, name);
        if (obj == null) {
            return null;
        } else {
            var gwidget: *c.GtkWidget = @ptrCast(c.g_type_check_instance_cast(@ptrCast(obj), c.gtk_widget_get_type()));
            return gwidget;
        }
    }
};
