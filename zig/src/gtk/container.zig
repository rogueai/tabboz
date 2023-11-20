const c = @import("cimport.zig");
const Box = @import("box.zig").Box;
const Bin = @import("bin.zig").Bin;
const Button = @import("button.zig").Button;
const Expander = @import("expander.zig").Expander;
const FlowBox = @import("flowbox.zig").FlowBox;
const Frame = @import("frame.zig").Frame;
const Grid = @import("grid.zig").Grid;
const HeaderBar = @import("headerbar.zig").HeaderBar;
const Notebook = @import("notebook.zig").Notebook;
const Paned = @import("paned.zig").Paned;
const stack = @import("stack.zig");
const Stack = stack.Stack;
const StackSwitcher = stack.StackSwitcher;
const StackSidebar = stack.StackSidebar;
const Widget = @import("widget.zig").Widget;

const std = @import("std");
const fmt = mem.fmt;
const mem = std.mem;

pub const Container = struct {
    ptr: *c.GtkContainer,

    const Self = @This();

    pub fn add(self: Self, widget: Widget) void {
        c.gtk_container_add(self.ptr, widget.ptr);
    }

    pub fn remove(self: Self, widget: Widget) void {
        c.gtk_container_remove(self.ptr, widget.ptr);
    }

    pub fn check_resize(self: Self) void {
        c.gtk_container_check_resize(self.ptr);
    }

    pub fn foreach(self: Self, callback: *c.GtkCallback, data: c.gpointer) void {
        c.gtk_container_foreach(self.ptr, callback, data);
    }

    pub fn get_children(self: Self, allocator: mem.Allocator) ?std.ArrayList(Widget) {
        var kids = c.gtk_container_get_children(self.ptr);
        defer c.g_list_free(kids);
        var list = std.ArrayList(Widget).init(allocator);
        while (kids) |ptr| {
            list.append(Widget{ .ptr = @as(*c.GtkWidget, @ptrCast(@alignCast(ptr.*.data))) }) catch {
                list.deinit();
                return null;
            };
            kids = ptr.*.next;
        }
        return list;
    }

    pub fn get_focus_child(self: Self) Widget {
        return Widget{ .ptr = c.gtk_container_get_focus_child(self.ptr) };
    }

    pub fn set_focus_child(self: Self, child: Widget) void {
        c.gtk_widget_set_focus_child(self.ptr, child.ptr);
    }

    pub fn get_border_width(self: Self) c_uint {
        c.gtk_container_get_border_width(self.ptr);
    }

    pub fn set_border_width(self: Self, border: c_uint) void {
        c.gtk_container_set_border_width(self.ptr, border);
    }

    pub fn connect_add(self: Self, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("add", callback, if (data) |d| d else null);
    }

    pub fn connect_check_resize(self: Self, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("check-resize", callback, if (data) |d| d else null);
    }

    pub fn connect_remove(self: Self, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("remove", callback, if (data) |d| d else null);
    }

    pub fn connect_set_focus_child(self: Self, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("set-focus-child", callback, if (data) |d| d else null);
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @as(*c.GtkWidget, @ptrCast(self.ptr)),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_container_get_type() or Box.is_instance(gtype) or Grid.is_instance(gtype) or Notebook.is_instance(gtype) or Stack.is_instance(gtype));
    }

    fn get_g_type(self: Self) u64 {
        return self.ptr.*.parent_instance.g_type_instance.g_class.*.g_type;
    }

    pub fn isa(self: Self, comptime T: type) bool {
        return T.is_instance(self.get_g_type());
    }

    pub fn to_bin(self: Self) ?Bin {
        return if (self.isa(Bin)) Bin{
            .ptr = @as(*c.GtkBin, @ptrCast(self.ptr)),
        } else null;
    }

    pub fn to_box(self: Self) ?Box {
        return if (self.isa(Box)) Box{
            .ptr = @as(*c.GtkBox, @ptrCast(self.ptr)),
        } else null;
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

    pub fn to_flow_box(self: Self) ?FlowBox {
        return if (self.isa(FlowBox)) FlowBox{
            .ptr = @as(*c.GtkFlowBox, @ptrCast(self.ptr)),
        } else null;
    }

    pub fn to_frame(self: Self) ?Frame {
        return if (self.isa(Frame)) Frame{
            .ptr = @as(*c.GtkFrame, @ptrCast(self.ptr)),
        } else null;
    }

    pub fn to_grid(self: Self) ?Grid {
        return if (self.isa(Grid)) Grid{
            .ptr = @as(*c.GtkGrid, @ptrCast(self.ptr)),
        } else null;
    }

    pub fn to_header_bar(self: Self) ?HeaderBar {
        return if (self.isa(HeaderBar)) HeaderBar{
            .ptr = @as(*c.GtkHeaderBar, @ptrCast(self.ptr)),
        } else null;
    }

    pub fn to_notebook(self: Self) ?Notebook {
        return if (self.isa(Notebook)) Notebook{
            .ptr = @as(*c.GtkNotebook, @ptrCast(self.ptr)),
        } else null;
    }

    pub fn to_paned(self: Self) ?Paned {
        return if (self.isa(Paned)) Paned{
            .ptr = @as(*c.GtkPaned, @ptrCast(self.ptr)),
        } else null;
    }

    pub fn to_stack(self: Self) ?Stack {
        return if (self.isa(Stack)) Stack{ .ptr = @as(*c.GtkStack, @ptrCast(self.ptr)) } else null;
    }

    pub fn to_stack_switcher(self: Self) ?StackSwitcher {
        return if (self.isa(StackSwitcher)) StackSwitcher{ .ptr = @as(*c.GtkStackSwitcher, @ptrCast(self.ptr)) } else null;
    }

    pub fn to_stack_sidebar(self: Self) ?StackSidebar {
        return if (self.isa(StackSidebar)) StackSidebar{ .ptr = @as(*c.GtkStackSidebar, @ptrCast(self.ptr)) } else null;
    }
};
