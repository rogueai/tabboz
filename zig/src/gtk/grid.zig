const c = @import("cimport.zig");
const enums = @import("enums.zig");
const BaselinePosition = enums.BaselinePosition;
const Buildable = @import("buildable.zig").Buildable;
const Container = @import("container.zig").Container;
const Orientable = @import("orientable.zig").Orientable;
const PositionType = enums.PositionType;
const Widget = @import("widget.zig").Widget;

const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

pub const Grid = struct {
    ptr: *c.GtkGrid,

    const Self = @This();

    pub fn new() Self {
        return Self{
            .ptr = c.gtk_grid_new(),
        };
    }

    pub fn attach(self: Self, child: Widget, left: usize, top: usize, width: usize, height: c_int) void {
        c.gtk_grid_attach(self.ptr, child.ptr, @intCast(left), @intCast(top), @intCast(width), @intCast(height));
    }

    pub fn attach_next_to(self: Self, child: Widget, sibling: Widget, side: PositionType, width: c_int, height: c_int) void {
        c.gtk_grid_attach_next_to(self.ptr, child.ptr, sibling.ptr, @intFromEnum(side), width, height);
    }

    pub fn get_child_at(self: Self, left: c_int, top: c_int) ?Widget {
        const val = c.gtk_grid_get_child_at(self.ptr, left, top);
        return if (val) |v| Widget{
            .ptr = v,
        } else null;
    }

    pub fn insert_row(self: Self, position: c_int) void {
        c.gtk_grid_insert_row(self.ptr, position);
    }

    pub fn insert_column(self: Self, position: c_int) void {
        c.gtk_grid_insert_column(self.ptr, position);
    }

    pub fn remove_row(self: Self, position: c_int) void {
        c.gtk_grid_remove_row(self.ptr, position);
    }

    pub fn remove_column(self: Self, position: c_int) void {
        c.gtk_grid_remove_column(self.ptr, position);
    }

    pub fn insert_next_to(self: Self, sibling: Widget, side: PositionType) void {
        c.gtk_grid_insert_next_to(self.ptr, sibling.ptr, @intFromEnum(side));
    }

    pub fn set_row_homogeneous(self: Self, hom: bool) void {
        c.gtk_grid_set_row_homogeneous(self.ptr, if (hom) 1 else 0);
    }

    pub fn get_row_homogeneous(self: Self) bool {
        return (c.gtk_grid_get_row_homogeneous(self.ptr) == 1);
    }

    pub fn set_row_spacing(self: Self, spacing: c_uint) void {
        c.gtk_grid_set_row_spacing(self.ptr, spacing);
    }

    pub fn get_row_spacing(self: Self) c_uint {
        return c.gtk_grid_get_row_spacing(self.ptr);
    }

    pub fn set_column_homogeneous(self: Self, hom: bool) void {
        c.gtk_grid_set_column_homogeneous(self.ptr, if (hom) 1 else 0);
    }

    pub fn get_column_homogeneous(self: Self) bool {
        return (c.gtk_grid_get_column_homogeneous(self.ptr) == 1);
    }

    pub fn set_column_spacing(self: Self, spacing: c_uint) void {
        c.gtk_grid_set_column_spacing(self.ptr, spacing);
    }

    pub fn get_column_spacing(self: Self) c_uint {
        return c.gtk_grid_get_column_spacing(self.ptr);
    }

    pub fn get_baseline_row(self: Self) c_int {
        return c.gtk_grid_get_baseline_row(self.ptr);
    }

    pub fn set_baseline_row(self: Self, row: c_int) void {
        c.gtk_grid_set_baseline_row(self.ptr, row);
    }

    pub fn get_row_baseline_position(self: Self, row: c_int) BaselinePosition {
        return @as(BaselinePosition, @enumFromInt(c.gtk_grid_get_baseline_position(self.ptr, row)));
    }

    pub fn set_row_baseline_position(self: Self, row: c_int, pos: BaselinePosition) void {
        c.gtk_grid_set_row_baseline_position(self.ptr, row, @intFromEnum(pos));
    }

    pub fn as_buildable(self: Self) Buildable {
        return Buildable{
            .ptr = @as(*c.GtkBuildable, @ptrCast(self.ptr)),
        };
    }

    pub fn as_container(self: Self) Container {
        return Container{
            .ptr = @as(*c.GtkContainer, @ptrCast(self.ptr)),
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
        return (gtype == c.gtk_grid_get_type());
    }

    pub fn to_grid(self: Self) ?Grid {
        return if (self.isa(Grid)) Grid{
            .ptr = @as(*c.GtkGrid, @ptrCast(self.ptr)),
        } else null;
    }
};
