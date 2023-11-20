const c = @import("cimport.zig");
const Buildable = @import("buildable.zig").Buildable;
const Orientable = @import("orientable.zig").Orientable;
const Orientation = @import("enums.zig").Orientation;
const Widget = @import("widget.zig").Widget;

/// GtkSeparator is a horizontal or vertical separator widget, depending on
/// the value of the “orientation” property, used to group the widgets
/// within a window. It displays a line with a shadow to make it appear
/// sunken into the interface.
/// ### CSS
/// GtkSeparator has a single CSS node with name separator. The node gets
/// one of the .horizontal or .vertical style classes.
pub const Separator = struct {
    ptr: *c.GtkSeparator,

    const Self = @This();

    /// Creates a new GtkSeparator with the given orientation.
    pub fn new(orientation: Orientation) Self {
        return Self{
            .ptr = @as(*c.GtkSeparator, @ptrCast(c.gtk_separator_new(@intFromEnum(orientation)))),
        };
    }

    pub fn as_buildable(self: Self) Buildable {
        return Buildable{
            .ptr = @as(*c.GtkBuildable, @ptrCast(self.ptr)),
        };
    }

    pub fn as_orientable(self: Self) Orientable {
        return Orientable{
            .ptr = @as(*c.GtkOrientable, @ptrCast(self.ptr)),
        };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @as(*c.GtkWidget, @ptrCast(self.ptr)),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_separator_get_type());
    }
};
