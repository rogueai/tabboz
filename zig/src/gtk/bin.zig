const c = @import("cimport.zig");
const Button = @import("button.zig").Button;
const Expander = @import("expander.zig").Expander;
const Frame = @import("frame.zig").Frame;
const Widget = @import("widget.zig").Widget;

const std = @import("std");

/// The GtkBin widget is a container with just one child. It is not very useful
/// itself, but it is useful for deriving subclasses, since it provides common
/// code needed for handling a single child widget.
pub const Bin = struct {
    ptr: *c.GtkBin,

    const Self = @This();

    /// Gets the child of the GtkBin, or `null` if the bin contains no child
    /// widget. The returned widget does not have a reference added, so you do
    /// not need to unref it.
    pub fn get_child(self: Self) ?Widget {
        return if (c.gtk_bin_get_child(self.ptr)) |ch| Widget{
            .ptr = ch,
        } else null;
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @as(*c.GtkWidget, @ptrCast(self.ptr)),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_bin_get_type());
    }

    fn get_g_type(self: Self) u64 {
        return self.ptr.*.parent_instance.g_type_instance.g_class.*.g_type;
    }

    pub fn isa(self: Self, comptime T: type) bool {
        return T.is_instance(self.get_g_type());
    }

    pub fn to_button(self: Self) ?Button {
        return if (self.isa(Button)) Button{
            .ptr = @as(*c.GtkButton, @ptrCast(self.ptr)),
        } else null;
    }

    pub fn to_expander(self: Self) ?Expander {
        return if (self.isa(Expander)) Expander{
            .ptr = @as(*c.GtkExpander, @ptrCast(self.ptr)),
        } else null;
    }

    pub fn to_frame(self: Self) ?Frame {
        return if (self.isa(Frame)) Frame{
            .ptr = @as(*c.GtkFrame, @ptrCast(self.ptr)),
        } else null;
    }
};
