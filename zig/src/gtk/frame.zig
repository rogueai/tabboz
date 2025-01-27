const c = @import("cimport.zig");

const Bin = @import("bin.zig").Bin;
const Buildable = @import("buildable.zig").Buildable;
const Container = @import("container.zig").Container;
const ShadowType = @import("enums.zig").ShadowType;
const Widget = @import("widget.zig").Widget;

const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

/// # Description
/// The frame widget is a bin that surrounds its child with a decorative frame
/// and an optional label. If present, the label is drawn in a gap in the top
/// side of the frame. The position of the label can be controlled with
/// Frame.set_label_align().
/// ### Frame as Buildable
/// The GtkFrame implementation of the GtkBuildable interface supports placing a
/// child in the label position by specifying “label” as the “type” attribute of
/// a <child> element. A normal content child can be specified without
/// specifying a <child> type attribute.
/// ```XML
/// <object class="GtkFrame">
///   <child type="label">
///     <object class="GtkLabel" id="frame-label"/>
///   </child>
///   <child>
///     <object class="GtkEntry" id="frame-content"/>
///   </child>
/// </object>
/// ```
/// ### CSS
/// GtkFrame has a main CSS node named “frame” and a subnode named “border”. The
/// “border” node is used to draw the visible border. You can set the appearance
/// of the border using CSS properties like “border-style” on the “border” node.
///
/// The border node can be given the style class “.flat”, which is used by
/// themes to disable drawing of the border. To do this from code, call
/// Frame.set_shadow_type() with ShadowType.none to add the “.flat” class or any
/// other shadow type to remove it.
pub const Frame = struct {
    ptr: *c.GtkFrame,

    const Self = @This();

    const Align = struct {
        x: f32,
        y: f32,
    };

    /// Creates a new GtkFrame, with optional label label . If label is `null`,
    /// the label is omitted.
    pub fn new(label: ?[:0]const u8) Self {
        return Self{
            .ptr = @as(*c.GtkFrame, @ptrCast(c.gtk_frame_new(if (label) |l| l.ptr else null))),
        };
    }

    /// Removes the current “label-widget”. If label is not `null`, creates a
    /// new GtkLabel with that text and adds it as the “label-widget”.
    pub fn set_label(self: Self, label: ?[:0]const u8) void {
        c.gtk_frame_set_label(self.ptr, if (label) |l| l.ptr else null);
    }

    /// Sets the “label-widget” for the frame. This is the widget that will
    /// appear embedded in the top edge of the frame as a title.
    pub fn set_label_widget(self: Self, widget: Widget) void {
        c.gtk_frame_set_label_widget(self.ptr, widget.ptr);
    }

    /// Sets the alignment of the frame widget’s label. The default values for a
    /// newly created frame are 0.0 and 0.5.
    pub fn set_label_align(self: Self, x: f32, y: f32) void {
        c.gtk_frame_set_label_align(self.ptr, x, y);
    }

    /// Sets the “shadow-type” for frame , i.e. whether it is drawn without
    /// (ShadowType.none) or with (other values) a visible border. Values other
    /// than ShadowType.none are treated identically by GtkFrame. The chosen
    /// type is applied by removing or adding the .flat class to the CSS node
    /// named border.
    pub fn set_shadow_type(self: Self, shadow: ShadowType) void {
        c.gtk_frame_set_shadow_type(self.ptr, @intFromEnum(shadow));
    }

    /// If the frame’s label widget is a GtkLabel, returns the text in the label
    /// widget. (The frame will have a GtkLabel for the label widget if a
    /// non-NULL argument was passed to gtk_frame_new().)
    pub fn get_label(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_frame_get_label(self.ptr);
        if (val) |v| {
            const len = mem.len(val);
            return fmt.allocPrintZ(allocator, "{s}", .{v[0..len]}) catch {
                return null;
            };
        } else return null;
    }

    /// Retrieves the X and Y alignment of the frame’s label. See
    /// Frame.set_label_align().
    pub fn get_label_align(self: Self) Align {
        const x: f32 = undefined;
        const y: f32 = undefined;
        c.gtk_frame_get_label_align(self.ptr, x, y);
        return Align{ .x = x, .y = y };
    }

    /// Retrieves the label widget for the frame. See Frame.set_label_widget().
    pub fn get_label_widget(self: Self) ?Widget {
        return if (c.gtk_frame_get_label_widget(self.ptr)) |w| Widget{ .ptr = w } else null;
    }

    /// Retrieves the shadow type of the frame. See Frame.set_shadow_type().
    pub fn get_shadow_type(self: Self) ShadowType {
        return @as(ShadowType, @enumFromInt(c.gtk_frame_get_shadow_type(self.ptr)));
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_frame_get_type());
    }

    pub fn as_bin(self: Self) Bin {
        return Bin{ .ptr = @as(*c.GtkBin, @ptrCast(self.ptr)) };
    }

    pub fn as_buildable(self: Self) Buildable {
        return Buildable{ .ptr = @as(*c.GtkBuildable, @ptrCast(self.ptr)) };
    }

    pub fn as_container(self: Self) Container {
        return Container{ .ptr = @as(*c.GtkContainer, @ptrCast(self.ptr)) };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{ .ptr = @as(*c.GtkWidget, @ptrCast(self.ptr)) };
    }
};

/// The AspectFrame is useful when you want pack a widget so that it can resize
/// but always retains the same aspect ratio. For instance, one might be drawing
/// a small preview of a larger image. AspectFrame derives from Frame, so it can
/// draw a label and a frame around the child. The frame will be “shrink-wrapped”
/// to the size of the child.
/// ### CSS
/// GtkAspectFrame uses a CSS node with name frame.
pub const AspectFrame = struct {
    ptr: *c.GtkAspectFrame,

    const Self = @This();

    /// Create a new GtkAspectFrame.
    pub fn new(
        /// Label text.
        label: [:0]const u8,
        /// Horizontal alignment of the child within the allocation of the
        /// AspectFrame. This ranges from 0.0 (left aligned) to 1.0 (right aligned)
        xalign: f32,
        /// Vertical alignment of the child within the allocation of the
        /// AspectFrame. This ranges from 0.0 (top aligned) to 1.0 (bottom aligned)
        yalign: f32,
        /// The desired aspect ratio.
        ratio: f32,
        /// If true, ratio is ignored, and the aspect ratio is taken from the
        /// requistion of the child.
        obey_child: bool,
    ) Self {
        return Self{ .ptr = @as(
            *c.GtkAspectFrame,
            @ptrCast(c.gtk_aspect_frame_new(label.ptr, xalign, yalign, ratio, if (obey_child) 1 else 0)),
        ) };
    }

    /// Set parameters for an existing GtkAspectFrame.
    pub fn set(
        self: Self,
        /// Horizontal alignment of the child within the allocation of the
        /// AspectFrame. This ranges from 0.0 (left aligned) to 1.0 (right aligned)
        xalign: f32,
        /// Vertical alignment of the child within the allocation of the
        /// AspectFrame. This ranges from 0.0 (top aligned) to 1.0 (bottom aligned)
        yalign: f32,
        /// The desired aspect ratio.
        ratio: f32,
        /// If true, ratio is ignored, and the aspect ratio is taken from the
        /// requistion of the child.
        obey_child: bool,
    ) void {
        c.gtk_aspect_frame_set(self.ptr, xalign, yalign, ratio, if (obey_child) 1 else 0);
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_aspect_frame_get_type());
    }

    pub fn as_bin(self: Self) Bin {
        return Bin{ .ptr = @as(*c.GtkBin, @ptrCast(self.ptr)) };
    }

    pub fn as_buildable(self: Self) Buildable {
        return Buildable{ .ptr = @as(*c.GtkBuildable, @ptrCast(self.ptr)) };
    }

    pub fn as_container(self: Self) Container {
        return Container{ .ptr = @as(*c.GtkContainer, @ptrCast(self.ptr)) };
    }

    pub fn as_frame(self: Self) Frame {
        return Frame{ .ptr = @as(*c.GtkFrame, @ptrCast(self.ptr)) };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{ .ptr = @as(*c.GtkWidget, @ptrCast(self.ptr)) };
    }
};
