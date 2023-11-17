const c = @import("cimport.zig");
const util = @import("util.zig");

const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

pub const Widget = struct {
    ptr: *c.GtkWidget,

    const Self = @This();

    /// Destroys a widget.
    ///
    /// When a widget is destroyed all references it holds on other objects will
    /// be released:
    /// * if the widget is inside a container, it will be removed from its parent
    /// * if the widget is a container, all its children will be destroyed,
    /// recursively
    /// * if the widget is a top level, it will be removed from the list of top
    /// level widgets that GTK+ maintains internally
    ///
    /// It's expected that all references held on the widget will also be
    /// released; you should connect to the “destroy” signal if you hold a
    /// reference to widget and you wish to remove it when this function is
    /// called. It is not necessary to do so if you are implementing a Container,
    /// as you'll be able to use the GtkContainerClass.remove() virtual function
    /// for that.
    ///
    /// It's important to notice that gtk_widget_destroy() will only cause the
    /// widget to be finalized if no additional references, acquired using
    /// g_object_ref(), are held on it. In case additional references are in
    /// place, the widget will be in an "inert" state after calling this function;
    /// widget will still point to valid memory, allowing you to release the
    /// references you hold, but you may not query the widget's own state.
    ///
    /// You should typically call this function on top level widgets, and rarely
    /// on child widgets.
    pub fn destroy(self: Widget) void {
        c.gtk_widget_destroy(self.ptr);
    }

    /// Flags a widget to be displayed. Any widget that isn’t shown will not
    /// appear on the screen. If you want to show all the widgets in a container,
    /// it’s easier to call gtk_widget_show_all() on the container, instead of
    /// individually showing the widgets.
    ///
    /// Remember that you have to show the containers containing a widget, in
    /// addition to the widget itself, before it will appear onscreen.
    ///
    /// When a toplevel container is shown, it is immediately realized and
    /// mapped; other shown widgets are realized and mapped when their toplevel
    /// container is realized and mapped.
    pub fn show(self: Self) void {
        c.gtk_widget_show(self.ptr);
    }

    /// Shows a widget. If the widget is an unmapped toplevel widget (i.e. a
    /// GtkWindow that has not yet been shown), enter the main loop and wait for
    /// the window to actually be mapped. Be careful; because the main loop is
    /// running, anything can happen during this function.
    pub fn show_now(self: Self) void {
        c.gtk_widget_show_now(self.ptr);
    }

    /// Reverses the effects of gtk_widget_show(), causing the widget to be
    /// hidden (invisible to the user).
    pub fn hide(self: Self) void {
        c.gtk_widget_hide(self.ptr);
    }

    /// Recursively shows a widget, and any child widgets (if the widget is a
    /// container).
    pub fn show_all(self: Self) void {
        c.gtk_widget_show_all(self.ptr);
    }

    /// Obtains the frame clock for a widget. The frame clock is a global “ticker”
    /// that can be used to drive animations and repaints. The most common reason
    /// to get the frame clock is to call gdk_frame_clock_get_frame_time(), in
    /// order to get a time to use for animating. For example you might record
    /// the start of the animation with an initial value from
    /// gdk_frame_clock_get_frame_time(), and then update the animation by calling
    /// gdk_frame_clock_get_frame_time() again during each repaint.
    ///
    /// gdk_frame_clock_request_phase() will result in a new frame on the clock,
    /// but won’t necessarily repaint any widgets. To repaint a widget, you have
    /// to use gtk_widget_queue_draw() which invalidates the widget (thus
    /// scheduling it to receive a draw on the next frame). gtk_widget_queue_draw()
    /// will also end up requesting a frame on the appropriate frame clock.
    ///
    /// A widget’s frame clock will not change while the widget is mapped.
    /// Reparenting a widget (which implies a temporary unmap) can change the
    /// widget’s frame clock.
    ///
    /// Unrealized widgets do not have a frame clock.
    pub fn get_frame_clock(self: Self) *c.GdkFrameClock {
        return c.gtk_widget_get_frame_clock(self.ptr);
    }

    /// Retrieves the internal scale factor that maps from window coordinates to
    /// the actual device pixels. On traditional systems this is 1, on high
    /// density outputs, it can be a higher value (typically 2).
    pub fn get_scale_factor(self: Self) c_int {
        return c.gtk_widget_get_scale_factor(self.ptr);
    }

    pub fn is_focus(self: Self) bool {
        return (c.gtk_widget_is_focus(self.ptr) == 1);
    }

    pub fn has_focus(self: Self) bool {
        return (c.gtk_widget_has_focus(self.ptr) == 1);
    }

    pub fn grab_focus(self: Self) void {
        c.gtk_widget_grab_focus(self.ptr);
    }

    pub fn grab_default(self: Self) void {
        c.gtk_widget_grab_default(self.ptr);
    }

    pub fn set_name(self: Self, name: [:0]const u8) void {
        c.gtk_widget_set_name(self.ptr, name.ptr);
    }

    pub fn get_name(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        if (c.gtk_widget_get_name(self.ptr)) |n| {
            const len = mem.len(n);
            return fmt.allocPrintZ(allocator, "{s}", .{n[0..len]}) catch {
                return null;
            };
        } else return null;
    }

    pub fn set_sensitive(self: Self, visible: bool) void {
        c.gtk_widget_set_sensitive(self.ptr, util.bool_to_c_int(visible));
    }

    pub fn get_toplevel(self: Self) Self {
        return Self{
            .ptr = c.gtk_widget_get_toplevel(self.ptr),
        };
    }

    pub fn get_parent(self: Self) ?Self {
        return if (c.gtk_widget_get_parent(self.ptr)) |w| Self{ .ptr = w } else null;
    }

    pub fn get_has_tooltip(self: Self) bool {
        return (c.gtk_widget_get_has_tooltip(self.ptr) == 1);
    }

    pub fn set_has_tooltip(self: Self, tooltip: bool) void {
        c.gtk_widget_set_has_tooltip(self.ptr, util.bool_to_c_int(tooltip));
    }

    pub fn get_tooltip_text(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        return if (c.gtk_widget_get_tooltip_text(self.ptr)) |t|
            fmt.allocPrintZ(allocator, "{s}", .{t}) catch return null
        else
            null;
    }

    pub fn set_tooltip_text(self: Self, text: [:0]const u8) void {
        c.gtk_widget_set_tooltip_text(self.ptr, text.ptr);
    }

    pub fn get_screen(self: Self) ?*c.GdkScreen {
        return c.gtk_widget_get_screen(self.ptr);
    }

    pub fn set_visual(self: Self, visual: *c.GdkVisual) void {
        c.gtk_widget_set_visual(self.ptr, visual);
    }

    pub fn set_opacity(self: Self, opacity: f64) void {
        c.gtk_widget_set_opacity(self.ptr, opacity);
    }

    pub fn set_visible(self: Self, vis: bool) void {
        c.gtk_widget_set_visible(self.ptr, util.bool_to_c_int(vis));
    }

    // pub fn get_halign(self: Self) Align {
    //     return @intToEnum(Align, c.gtk_widget_get_halign(self.ptr));
    // }

    // pub fn set_halign(self: Self, halign: Align) void {
    //     c.gtk_widget_set_halign(self.ptr, @enumToInt(halign));
    // }

    // pub fn get_valign(self: Self) Align {
    //     return @intToEnum(Align, c.gtk_widget_get_valign(self.ptr));
    // }

    // pub fn set_valign(self: Self, valign: Align) void {
    //     c.gtk_widget_set_valign(self.ptr, @enumToInt(valign));
    // }

    pub fn get_hexpand(self: Self) bool {
        return (c.gtk_widget_get_hexpand(self.ptr) == 1);
    }

    pub fn set_hexpand(self: Self, expand: bool) void {
        c.gtk_widget_set_hexpand(self.ptr, if (expand) 1 else 0);
    }

    pub fn get_vexpand(self: Self) bool {
        return (c.gtk_widget_get_vexpand(self.ptr) == 1);
    }

    pub fn set_vexpand(self: Self, expand: bool) void {
        c.gtk_widget_set_vexpand(self.ptr, if (expand) 1 else 0);
    }

    pub fn connect(self: Self, sig: [:0]const u8, callback: c.GCallback, data: ?c.gpointer) void {
        _ = util.signal_connect(self.ptr, sig.ptr, callback, if (data) |d| d else null);
    }

    pub fn connectWidget(self: Self, sig: []const u8, comptime callback: fn (widget: *Widget) void, data: ?c.gpointer) void {
        const fnPtr = @as(c.GCallback, @ptrCast(&callback));
        _ = util.signal_connect(self.ptr, sig.ptr, fnPtr, if (data) |d| d else null);
    }

    fn get_g_type(self: Self) u64 {
        return self.ptr.*.parent_instance.g_type_instance.g_class.*.g_type;
    }

    pub fn isa(self: Self, comptime T: type) bool {
        return T.is_instance(self.get_g_type());
    }
};
