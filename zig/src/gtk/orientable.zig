const c = @import("cimport.zig");
const enums = @import("enums.zig");
const Orientation = enums.Orientation;
const Widget = @import("widget.zig").Widget;

pub const Orientable = struct {
    ptr: *c.GtkOrientable,

    pub fn as_widget(self: Orientable) Widget {
        return Widget{
            .ptr = @as(*c.GtkWidget, @ptrCast(self.ptr)),
        };
    }

    pub fn get_orientation(self: Orientable) Orientation {
        return @as(Orientation, @enumFromInt(c.gtk_orientable_get_orientation(self.ptr)));
    }

    pub fn set_orientation(self: Orientable, orientation: Orientation) void {
        c.gtk_orientable_set_orientation(self.ptr, @intFromEnum(orientation));
    }
};
