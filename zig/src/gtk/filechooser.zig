const c = @import("cimport.zig");
const com = @import("common.zig");
const Buildable = @import("buildable.zig").Buildable;
const Button = @import("button.zig").Button;
const Dialog = @import("dialog.zig").Dialog;
const FileFilter = @import("filefilter.zig").FileFilter;
const Orientable = @import("orientable.zig").Orientable;
const Widget = @import("widget.zig").Widget;
const Window = @import("window.zig").Window;

const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

pub const FileChooser = struct {
    ptr: *c.GtkFileChooser,

    const Self = @This();

    pub const Action = enum(c_uint) {
        open = c.GTK_FILE_CHOOSER_ACTION_OPEN,
        save = c.GTK_FILE_CHOOSER_ACTION_SAVE,
        select_folder = c.GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER,
        create_folder = c.GTK_FILE_CHOOSER_ACTION_CREATE_FOLDER,
    };

    pub const Confirmation = enum(c_uint) {
        confirm = c.GTK_FILE_CHOOSER_CONFIRMATION_CONFIRM,
        accept_filename = c.GTK_FILE_CHOOSER_CONFIRMATION_ACCEPT_FILENAME,
        select_again = c.GTK_FILE_CHOOSER_CONFIRMATION_SELECT_AGAIN,
    };

    pub const Error = enum(c_uint) {
        nonexistent = c.GTK_FILE_CHOOSER_ERROR_NONEXISTENT,
        bad_filename = c.GTK_FILE_CHOOSER_ERROR_BAD_FILENAME,
        already_exists = c.GTK_FILE_CHOOSER_ERROR_ALREADY_EXISTS,
        incomplete_hostname = c.GTK_FILE_CHOOSER_ERROR_INCOMPLETE_HOSTNAME,
    };

    pub fn set_action(self: Self, action: Action) void {
        c.gtk_file_chooser_set_action(self.ptr, @intFromEnum(action));
    }

    pub fn get_action(self: Self) Action {
        return c.gtk_file_chooser_get_action(self.ptr);
    }

    pub fn set_local_only(self: Self, local: bool) void {
        c.gtk_file_chooser_set_local_only(self.ptr, if (local) 1 else 0);
    }

    pub fn get_local_only(self: Self) bool {
        return (c.gtk_file_chooser_get_local_only(self.ptr) == 1);
    }

    pub fn set_select_multiple(self: Self, multiple: bool) void {
        c.gtk_file_chooser_set_select_multiple(self.ptr, if (multiple) 1 else 0);
    }

    pub fn get_select_multiple(self: Self) bool {
        return (c.gtk_file_chooser_get_select_multiple(self.ptr) == 1);
    }

    pub fn set_show_hidden(self: Self, hidden: bool) void {
        c.gtk_file_chooser_set_show_hidden(self.ptr, if (hidden) 1 else 0);
    }

    pub fn get_show_hidden(self: Self) bool {
        return (c.gtk_file_chooser_get_show_hidden(self.ptr) == 1);
    }

    pub fn set_do_overwrite_confirmation(self: Self, confirm: bool) void {
        c.gtk_file_chooser_set_do_overwrite_confirmation(self.ptr, if (confirm) 1 else 0);
    }

    pub fn get_do_overwrite_confirmation(self: Self) bool {
        return (c.gtk_file_chooser_get_do_overwrite_confirmation(self.ptr) == 1);
    }

    pub fn set_create_folders(self: Self, create: bool) void {
        c.gtk_file_chooser_set_create_folders(self.ptr, if (create) 1 else 0);
    }

    pub fn get_create_folders(self: Self) bool {
        return (c.gtk_file_chooser_get_create_folders(self.ptr) == 1);
    }

    pub fn set_current_name(self: Self, name: [:0]const u8) void {
        c.gtk_file_chooser_set_current_name(self.ptr, name.ptr);
    }

    pub fn get_current_name(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_file_chooser_get_current_name(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn get_filename(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_file_chooser_get_filename(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_filename(self: Self, name: [:0]const u8) void {
        c.gtk_file_chooser_set_filename(self.ptr, name.ptr);
    }

    pub fn select_filename(self: Self, filename: [:0]const u8) void {
        c.gtk_file_chooser_select_filename(self.ptr, filename.ptr);
    }

    pub fn unselect_filename(self: Self, filename: [:0]const u8) void {
        c.gtk_file_chooser_unselect_filename(self.ptr, filename.ptr);
    }

    pub fn select_all(self: Self) void {
        c.gtk_file_chooser_select_all(self.ptr);
    }

    pub fn unselect_all(self: Self) void {
        c.gtk_file_chooser_unselect_all(self.ptr);
    }

    pub fn get_filenames(self: Self, allocator: mem.Allocator) ?std.ArrayList(Widget) {
        const kids = c.gtk_file_chooser_get_filenames(self.ptr);
        defer c.g_list_free(kids);
        return if (com.gslistToArrayList(kids, allocator)) |list| list else null;
    }

    pub fn set_current_folder(self: Self, folder: [:0]const u8) void {
        c.gtk_file_chooser_set_current_folder(self.ptr, folder.ptr);
    }

    pub fn get_current_folder(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_file_chooser_get_current_folder(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn get_uri(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_file_chooser_get_uri(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_uri(self: Self, uri: [:0]const u8) void {
        c.gtk_file_chooser_set_uri(self.ptr, uri.ptr);
    }

    pub fn select_uri(self: Self, uri: [:0]const u8) void {
        c.gtk_file_chooser_select_uri(self.ptr, uri.ptr);
    }

    pub fn unselect_uri(self: Self, uri: [:0]const u8) void {
        c.gtk_file_chooser_unselect_uri(self.ptr, uri.ptr);
    }

    pub fn get_uris(self: Self, allocator: mem.Allocator) ?std.ArrayList(Widget) {
        const kids = c.gtk_file_chooser_get_uris(self.ptr);
        defer c.g_list_free(kids);
        return if (com.gslistToArrayList(kids, allocator)) |list| list else null;
    }

    pub fn set_current_folder_uri(self: Self, uri: [:0]const u8) void {
        c.gtk_file_chooser_set_current_folder_uri(self.ptr, uri.ptr);
    }

    pub fn get_current_folder_uri(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_file_chooser_get_current_folder_uri(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_preview_widget(self: Self, widget: Widget) void {
        c.gtk_file_chooser_set_preview_widget(self.ptr, widget.ptr);
    }

    pub fn get_preview_widget(self: Self) ?Widget {
        if (c.get_file_chooser_get_preview_widget(self.ptr)) |ptr| {
            return Widget{ .ptr = ptr };
        } else return null;
    }

    pub fn set_preview_widget_active(self: Self, active: bool) void {
        c.gtk_file_chooser_set_preview_widget_active(self.ptr, if (active) 1 else 0);
    }

    pub fn get_preview_widget_active(self: Self) bool {
        return (c.gtk_file_chooser_get_preview_widget_active(self.ptr) == 1);
    }

    pub fn set_use_preview_label(self: Self, use: bool) void {
        c.gtk_file_chooser_set_use_preview_label(self.ptr, if (use) 1 else 0);
    }

    pub fn get_use_preview_label(self: Self) bool {
        return (c.gtk_file_chooser_get_use_preview_label(self.ptr) == 1);
    }

    pub fn get_preview_filename(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_file_chooser_get_preview_filename(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn get_preview_uri(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_file_chooser_get_preview_uri(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_extra_widget(self: Self, widget: Widget) void {
        c.gtk_file_chooser_set_extra_widget(self.ptr, widget.ptr);
    }

    pub fn get_extra_widget(self: Self) ?Widget {
        if (c.gtk_file_chooser_get_extra_widget(self.ptr)) |ptr| {
            return Widget{ .ptr = ptr };
        } else return null;
    }

    pub fn add_choice(self: Self, id: [:0]const u8, label: [:0]const u8, options: [*c][*c]const u8, option_labels: [*c][*c]const u8) void {
        c.gtk_file_chooser_add_choice(self.ptr, id.ptr, label.ptr, options, option_labels);
    }

    pub fn remove_choice(self: Self, id: [:0]const u8) void {
        c.gtk_file_chooser_remove_choice(self.ptr, id.ptr);
    }

    pub fn set_choice(self: Self, id: [:0]const u8, option: [:0]const u8) void {
        c.gtk_file_chooser_set_choice(self.ptr, id.ptr, option.ptr);
    }

    pub fn get_choice(self: Self, id: [:0]const u8, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_file_chooser_get_choice(self.ptr, id.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn add_filter(self: Self, filter: FileFilter) void {
        c.gtk_file_chooser_add_filter(self.ptr, filter.ptr);
    }

    pub fn remove_filter(self: Self, filter: FileFilter) void {
        c.gtk_file_chooser_remove_filter(self.ptr, filter.ptr);
    }

    pub fn list_filters(self: Self, allocator: mem.Allocator) ?std.ArrayList(Widget) {
        const kids = c.gtk_file_chooser_list_filters(self.ptr);
        defer c.g_list_free(kids);
        return if (com.gslistToArrayList(kids, allocator)) |list| list else null;
    }

    pub fn set_filter(self: Self, filter: FileFilter) void {
        c.gtk_file_chooser_set_filter(self.ptr, filter.ptr);
    }

    pub fn get_filter(self: Self) ?FileFilter {
        if (c.gtk_file_filter_get_filter(self.ptr)) |f| {
            return FileFilter{ .ptr = f };
        } else return null;
    }

    pub fn add_shortcut_folder(self: Self, folder: [:0]const u8) Error!void {
        if (c.gtk_file_chooser_add_shortcut_folder(self.ptr, folder.ptr, null) == 0) {
            return Error.nonexistent;
        }
    }

    pub fn remove_shortcut_folder(self: Self, folder: [:0]const u8) Error!void {
        if (c.gtk_file_chooser_remove_shortcut_folder(self.ptr, folder.ptr, null) == 0) {
            return Error.nonexistent;
        }
    }

    pub fn list_shortcut_folders(self: Self) ?c.GSlist {
        return if (c.gtk_file_chooser_list_folders(self.ptr)) |ls| ls else null;
    }

    pub fn add_shortcut_folder_uri(self: Self, uri: [:0]const u8) Error!void {
        if (c.gtk_file_chooser_add_shortcut_folder_uri(self.ptr, uri.ptr, null) == 0) {
            return Error.nonexistent;
        }
    }

    pub fn remove_shorcut_holder_uri(self: Self, uri: [:0]const u8) Error!void {
        if (c.gtk_file_chooser_remove_shortcut_folder_uri(self.ptr, uri.ptr, null) == 0) {
            return Error.nonexistent;
        }
    }

    pub fn list_shortcut_folder_uris(self: Self) ?c.GSlist {
        return if (c.gtk_file_chooser_list_folder_uris(self.ptr)) |ls| ls else null;
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{ .ptr = @as(*c.GtkWidget, @ptrCast(self.ptr)) };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_file_chooser_get_type() or FileChooserButton.is_instance(gtype) or FileChooserWidget.is_instance(gtype) or FileChooserDialog.is_instance(gtype));
    }

    fn get_g_type(self: Self) u64 {
        return self.ptr.*.parent_instance.g_type_instance.g_class.*.g_type;
    }

    pub fn isa(self: Self, comptime T: type) bool {
        return T.is_instance(self.get_g_type());
    }

    pub fn to_filechooser_button(self: Self) ?FileChooserButton {
        return if (self.isa(FileChooserButton)) FileChooserButton{
            .ptr = @as(*c.GtkFileChooserButton, @ptrCast(self.ptr)),
        } else null;
    }

    pub fn to_filechooser_dialog(self: Self) ?FileChooserDialog {
        return if (self.isa(FileChooserDialog)) FileChooserDialog{
            .ptr = @as(*c.GtkFileChooserDialog, @ptrCast(self.ptr)),
        } else null;
    }

    pub fn to_filechooser_widget(self: Self) ?FileChooserWidget {
        return if (self.isa(FileChooserWidget)) FileChooserWidget{
            .ptr = @as(*c.GtkFileChooserWidget, @ptrCast(self.ptr)),
        } else null;
    }
};

pub const FileChooserButton = struct {
    ptr: *c.GtkFileChooserButton,

    const Self = @This();

    pub fn new(title: [:0]const u8, action: FileChooser.Action) Self {
        return Self{ .ptr = @as(
            *c.GtkFileChooserButton,
            @ptrCast(c.gtk_file_chooser_button_new(title.ptr, @intFromEnum(action))),
        ) };
    }

    pub fn new_with_dialog(dlg: FileChooserDialog) Self {
        return Self{ .ptr = @as(*c.GtkFileChooserButton, @ptrCast(c.gtk_file_chooser_button_new_with_dialog(@as(*c.GtkWidget, @ptrCast(dlg.ptr))))) };
    }

    pub fn get_title(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_file_chooser_button_get_title(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_title(self: Self, title: [:0]const u8) void {
        c.gtk_file_chooser_button_set_title(self.ptr, title.ptr);
    }

    pub fn get_width_chars(self: Self) c_int {
        return c.gtk_file_chooser_button_get_width_chars(self.ptr);
    }

    pub fn set_width_chars(self: Self, width: c_int) void {
        c.gtk_file_chooser_button_set_width_chars(self.ptr, width);
    }

    pub fn as_buildable(self: Self) Buildable {
        return Buildable{ .ptr = @as(*c.GtkBuildable, @ptrCast(self.ptr)) };
    }

    pub fn as_button(self: Self) Button {
        return Button{ .ptr = @as(*c.GtkButton, @ptrCast(self.ptr)) };
    }

    pub fn as_filechooser(self: Self) FileChooser {
        return FileChooser{ .ptr = @as(*c.GtkWidget, @ptrCast(self.ptr)) };
    }

    pub fn as_orientable(self: Self) Orientable {
        return Orientable{ .ptr = @as(*c.GtkOrientable, @ptrCast(self.ptr)) };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{ .ptr = @as(*c.GtkWidget, @ptrCast(self.ptr)) };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_file_chooser_button_get_type());
    }
};

pub const FileChooserWidget = struct {
    ptr: *c.GtkFileChooserWidget,

    const Self = @This();

    pub fn new() Self {
        return Self{ .ptr = @as(*c.GtkFileChooserWidget, @ptrCast(c.gtk_file_chooser_widget_new())) };
    }

    pub fn as_buildable(self: Self) Buildable {
        return Buildable{ .ptr = @as(*c.GtkBuildable, @ptrCast(self.ptr)) };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{ .ptr = @as(*c.GtkWidget, @ptrCast(self.ptr)) };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_file_chooser_widget_get_type());
    }
};

pub const FileChooserDialog = struct {
    ptr: *c.GtkFileChooserDialog,

    const Self = @This();

    pub fn new(
        title: [:0]const u8,
        parent: Window,
        action: FileChooser.Action,
        first_button_text: [:0]const u8,
    ) Self {
        return c.gtk_file_chooser_dialog_new(title.ptr, parent.ptr, @intFromEnum(action), first_button_text.ptr);
    }

    pub fn as_buildable(self: Self) Buildable {
        return Buildable{ .ptr = @as(*c.GtkBuildable, @ptrCast(self.ptr)) };
    }

    pub fn as_dialog(self: Self) Dialog {
        return Dialog{ .ptr = @as(*c.GtkWidget, @ptrCast(self.ptr)) };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{ .ptr = @as(*c.GtkWidget, @ptrCast(self.ptr)) };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_file_chooser_dialog_get_type());
    }
};
