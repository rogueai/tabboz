const c = @import("cimport.zig");
const ColorChooserDialog = @import("colorchooser.zig").ColorChooserDialog;
const Container = @import("container.zig").Container;
const FileChooserDialog = @import("filechooser.zig").FileChooserDialog;
const FontChooserDialog = @import("fontchooser.zig").FontChooserDialog;
const License = @import("enums.zig").License;
const Widget = @import("widget.zig").Widget;
const Window = @import("window.zig").Window;

const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

pub const Dialog = struct {
    ptr: *c.GtkDialog,

    /// Flags used to influence dialog construction.
    pub const Flags = enum(c_uint) {
        /// Make the constructed dialog modal, see gtk_window_set_modal()
        modal = c.GTK_DIALOG_FLAGS_MODAL,
        /// Destroy the dialog when its parent is destroyed, see
        /// gtk_window_set_destroy_with_parent()
        destroy_with_parent = c.GTK_DIALOG_FLAGS_DESTROY_WITH_PARENT,
        /// Create dialog with actions in header bar instead of action area.
        /// Since 3.12.
        use_header_bar = c.GTK_DIALOG_FLAGS_USE_HEADER_BAR,
    };

    /// Predefined values for use as response ids in gtk_dialog_add_button().
    /// All predefined values are negative; GTK+ leaves values of 0 or greater
    /// for application-defined response ids.
    pub const ResponseType = enum(c_uint) {
        /// Returned if an action widget has no response id, or if the dialog
        /// gets programmatically hidden or destroyed
        none = c.GTK_RESPONSE_NONE,
        /// Generic response id, not used by GTK+ dialogs
        reject = c.GTK_RESPONSE_REJECT,
        /// Generic response id, not used by GTK+ dialogs
        accept = c.GTK_RESPONSE_ACCEPT,
        /// Returned if the dialog is deleted
        delete_event = c.GTK_RESPONSE_DELETE_EVENT,
        /// Returned by OK buttons in GTK+ dialogs
        ok = c.GTK_RESPONSE_OK,
        /// Returned by Cancel buttons in GTK+ dialogs
        cancel = c.GTK_RESPONSE_CANCEL,
        /// Returned by Close buttons in GTK+ dialogs
        close = c.GTK_RESPONSE_CLOSE,
        /// Returned by Yes buttons in GTK+ dialogs
        yes = c.GTK_RESPONSE_YES,
        /// Returned by No buttons in GTK+ dialogs
        no = c.GTK_RESPONSE_NO,
        /// Returned by Apply buttons in GTK+ dialogs
        apply = c.GTK_RESPONSE_APPLY,
        /// Returned by Help buttons in GTK+ dialogs
        help = c.GTK_RESPONSE_HELP,
    };

    pub const DefaultSize = struct {
        width: u16,
        height: u16,
    };

    const Self = @This();

    pub fn new(parent: ?Window, size: ?DefaultSize, title: ?[:0]const u8, bOk: ?[:0]const u8, bCancel: ?[:0]const u8) Self {
        const dialog = c.gtk_dialog_new();
        c.gtk_window_set_destroy_with_parent(@ptrCast(dialog), c.gtk_false());
        if (size) |s| {
            c.gtk_window_set_default_size(@ptrCast(dialog), s.width, s.height);
        }
        if (parent) |p| {
            // c.gtk_widget_set_parent_window(@ptrCast(dialog), @ptrCast(p.ptr));
            c.gtk_window_set_transient_for(@ptrCast(dialog), @ptrCast(p.ptr));
        } else {
            c.gtk_window_set_transient_for(@ptrCast(dialog), null);
        }
        if (title) |t| {
            c.gtk_window_set_title(@ptrCast(dialog), t);
        }
        if (bOk) |ok| {
            _ = c.gtk_dialog_add_button(@ptrCast(dialog), ok, c.GTK_RESPONSE_OK);
        }
        if (bCancel) |cancel| {
            _ = c.gtk_dialog_add_button(@ptrCast(dialog), cancel, c.GTK_RESPONSE_CANCEL);
        }
        return Self{
            .ptr = @as(*c.GtkDialog, @ptrCast(dialog)),
        };
    }

    pub fn run(self: Self) c_int {
        return c.gtk_dialog_run(self.ptr);
    }

    pub fn get_content_area(self: Self) Container {
        return Container{ .ptr = @as(*c.GtkContainer, @ptrCast(c.gtk_dialog_get_content_area(@ptrCast(self.ptr)))) };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{ .ptr = @as(*c.GtkWidget, @ptrCast(self.ptr)) };
    }

    pub fn as_window(self: Self) Window {
        return Window{ .ptr = @as(*c.GtkWindow, @ptrCast(self.ptr)) };
    }

    pub fn as_container(self: Self) Container {
        return Container{ .ptr = @as(*c.GtkContainer, @ptrCast(self.ptr)) };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_dialog_get_type() or AboutDialog.is_instance(gtype) or ColorChooserDialog.is_instance(gtype) or FontChooserDialog.is_instance(gtype) or MessageDialog.is_instance(gtype));
    }

    fn get_g_type(self: Self) u64 {
        return self.ptr.*.parent_instance.g_type_instance.g_class.*.g_type;
    }

    pub fn isa(self: Self, comptime T: type) bool {
        return T.is_instance(self.get_g_type());
    }

    pub fn to_about_dialog(self: Self) ?AboutDialog {
        return if (self.isa(AboutDialog)) AboutDialog{
            .ptr = @as(*c.GtkAboutDialog, @ptrCast(self.ptr)),
        } else null;
    }

    pub fn to_colorchooser_dialog(self: Self) ?ColorChooserDialog {
        return if (self.isa(ColorChooserDialog)) ColorChooserDialog{
            .ptr = @as(*c.GtkColorChooserDialog, @ptrCast(self.ptr)),
        } else null;
    }

    pub fn to_filechooser_dialog(self: Self) ?FileChooserDialog {
        return if (self.isa(FileChooserDialog)) FileChooserDialog{
            .ptr = @as(*c.GtkFileChooserDialog, @ptrCast(self.ptr)),
        } else null;
    }

    pub fn to_fontchooser_dialog(self: Self) ?FontChooserDialog {
        return if (self.isa(FontChooserDialog)) FontChooserDialog{
            .ptr = @as(*c.GtkFontChooserDialog, @ptrCast(self.ptr)),
        } else null;
    }

    pub fn to_message_dialog(self: Self) ?MessageDialog {
        return if (self.isa(MessageDialog)) MessageDialog{
            .ptr = @as(*c.GtkMessageDialog, @ptrCast(self.ptr)),
        } else null;
    }
};

pub const AboutDialog = struct {
    ptr: *c.GtkAboutDialog,

    const Self = @This();

    pub fn new() Self {
        return Self{
            .ptr = @as(*c.GtkAboutDialog, @ptrCast(c.gtk_about_dialog_new())),
        };
    }

    pub fn get_program_name(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_about_dialog_get_program_name(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_program_name(self: AboutDialog, name: [:0]const u8) void {
        c.gtk_about_dialog_set_program_name(self.ptr, name.ptr);
    }

    pub fn get_version(self: AboutDialog, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_about_dialog_get_version(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_version(self: AboutDialog, version: [:0]const u8) void {
        c.gtk_about_dialog_set_version(self.ptr, version.ptr);
    }

    pub fn get_copyright(self: AboutDialog, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_about_dialog_get_copyright(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_copyright(self: AboutDialog, copyright: [:0]const u8) void {
        c.gtk_about_dialog_set_copyright(self.ptr, copyright.ptr);
    }

    pub fn get_comments(self: AboutDialog, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_about_dialog_get_comments(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_comments(self: AboutDialog, comments: [:0]const u8) void {
        c.gtk_about_dialog_set_copyright(self.ptr, comments.ptr);
    }

    pub fn get_license(self: AboutDialog, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_about_dialog_get_license(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_license(self: AboutDialog, license: [:0]const u8) void {
        c.gtk_about_dialog_set_license(self.ptr, license.ptr);
    }

    pub fn get_wrap_license(self: Self) bool {
        return (c.gtk_about_dialog_get_wrap_license(self.ptr) == 1);
    }

    pub fn set_wrap_license(self: Self, wrap: bool) void {
        c.gtk_about_dialog_set_wrap_license(self.ptr, if (wrap) 1 else 0);
    }

    pub fn get_license_type(self: Self) License {
        return c.gtk_about_dialog_get_license_type(self.ptr);
    }

    pub fn set_license_type(self: Self, license: License) void {
        c.gtk_about_dialog_set_license_type(self.ptr, @intFromEnum(license));
    }

    pub fn get_website(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_about_dialog_get_website(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_website(self: Self, site: [:0]const u8) void {
        c.gtk_about_dialog_set_website(self.ptr, site.ptr);
    }

    pub fn get_website_label(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_about_dialog_get_website_label(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_website_label(self: Self, label: [:0]const u8) void {
        c.gtk_about_dialog_set_website_label(self.ptr, label.ptr);
    }

    pub fn get_authors(self: Self) [][:0]const u8 {
        return c.gtk_about_dialog_get_authors(self.ptr);
    }

    /// Gtk+ expects a pointer to a null terminated array of pointers to null
    /// terminated arrays of u8. In order to coerce properly follow this form:
    /// var authors = [_:0][*c]const u8{ "Your Name" };
    /// dlg.set_authors(&authors);
    pub fn set_authors(self: Self, authors: [*c][*c]const u8) void {
        c.gtk_about_dialog_set_authors(self.ptr, authors);
    }

    pub fn get_artists(self: Self) [*c][*c]const u8 {
        return c.gtk_about_dialog_get_artists(self.ptr);
    }

    /// Gtk+ expects a pointer to a null terminated array of pointers to null
    /// terminated arrays of u8. In order to coerce properly follow this form:
    /// var artists = [_:0][*c]const u8{ "Some Artist" };
    /// dlg.set_authors(&artists);
    pub fn set_artists(self: Self, artists: [*c][*c]const u8) void {
        c.gtk_about_dialog_set_artists(self.ptr, artists);
    }

    pub fn get_documentors(self: Self) [*c][*c]const u8 {
        return c.gtk_about_dialog_get_documentors(self.ptr);
    }

    /// Gtk+ expects a pointer to a null terminated array of pointers to null
    /// terminated arrays of u8. In order to coerce properly follow this form:
    /// var documentors = [_:0][*c]const u8{ "Some Person" };
    /// dlg.set_authors(&documentors);
    pub fn set_documentors(self: Self, artists: [*c][*c]const u8) void {
        c.gtk_about_dialog_set_documentors(self.ptr, artists);
    }

    pub fn get_translator_credits(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_about_dialog_get_translator_credits(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_translator_credits(self: Self, site: [:0]const u8) void {
        c.gtk_about_dialog_set_translator_credits(self.ptr, site.ptr);
    }

    pub fn get_logo(self: Self) *c.GdkPixbuf {
        return c.gtk_about_dialog_get_logo(self.ptr);
    }

    pub fn set_logo(self: Self, logo: *c.GdkPixbuf) void {
        c.gtk_about_dialog_set_logo(self.ptr, logo);
    }

    pub fn get_logo_icon_name(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_about_dialog_get_logo_icon_name(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_logo_icon_name(self: Self, name: [:0]const u8) void {
        c.gtk_about_dialog_set_logo_icon_name(self.ptr, name.ptr);
    }

    /// Gtk+ expects a pointer to a null terminated array of pointers to null
    /// terminated arrays of u8. In order to coerce properly follow this form:
    /// var documentorss = [_:0][*c]const u8{ "Some Person" };
    /// dlg.set_authors(&documentors);
    pub fn add_credit_section(self: Self, section_name: [:0]const u8, people: [*c][*c]const u8) void {
        c.gtk_about_dialog_add_credit_section(self.ptr, section_name.ptr, people);
    }

    pub fn as_dialog(self: Self) Dialog {
        return Dialog{
            .ptr = @as(*c.GtkDialog, @ptrCast(self.ptr)),
        };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{ .ptr = @as(*c.GtkWidget, @ptrCast(self.ptr)) };
    }

    pub fn as_window(self: Self) Window {
        return Window{ .ptr = @as(*c.GtkWindow, @ptrCast(self.ptr)) };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_about_dialog_get_type());
    }
};

pub const MessageDialog = struct {
    ptr: *c.GtkMessageDialog,

    const Self = @This();

    pub fn new(parent: *c.GtkWindow, flags: Dialog.Flags, kind: Type, buttons: ButtonsType, msg: [:0]const u8) Self {
        return Self{
            .ptr = c.gtk_message_dialog_new(parent, @intFromEnum(flags), kind, buttons, msg.ptr),
        };
    }

    pub fn new_with_markup(parent: *c.GtkWindow, flags: Dialog.Flags, kind: Type, buttons: ButtonsType, msg: [:0]const u8) Self {
        return Self{
            .ptr = c.gtk_message_dialog_new_with_markup(parent, @intFromEnum(flags), kind, buttons, msg.ptr),
        };
    }

    pub fn set_markup(self: Self, markup: [:0]const u8) void {
        c.gtk_message_dialog_set_markup(self.ptr, markup.ptr);
    }

    pub fn format_secondary_text(self: Self, text: [:0]const u8) void {
        c.gtk_message_dialog_format_secondary_text(self.ptr, text.ptr);
    }

    pub fn format_secondary_markup(self: Self, text: [:0]const u8) void {
        c.gtk_message_dialog_format_secondary_markup(self.ptr, text.ptr);
    }

    pub fn get_message_area(self: Self) Widget {
        return Widget{
            .ptr = c.gtk_message_dialog_get_message_area(self.ptr),
        };
    }

    pub fn as_dialog(self: Self) Dialog {
        return Dialog{
            .ptr = @as(*c.GtkDialog, @ptrCast(self.ptr)),
        };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{ .ptr = @as(*c.GtkWidget, @ptrCast(self.ptr)) };
    }

    pub fn as_window(self: Self) Window {
        return Window{ .ptr = @as(*c.GtkWindow, @ptrCast(self.ptr)) };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_message_dialog_get_type());
    }
};

pub const Type = enum(c_uint) {
    info = c.GTK_MESSAGE_INFO,
    warning = c.GTK_MESSAGE_WARNING,
    question = c.GTK_MESSAGE_QUESTION,
    err = c.GTK_MESSAGE_ERROR,
    other = c.GTK_MESSAGE_OTHER,
};

pub const ButtonsType = enum(c_uint) {
    none = c.GTK_BUTTONS_NONE,
    ok = c.GTK_BUTTONS_OK,
    close = c.GTK_BUTTONS_CLOSE,
    cancel = c.GTK_BUTTONS_CANCEL,
    yes_no = c.GTK_BUTTONS_YES_NO,
    ok_cancel = c.GTK_BUTTONS_OK_CANCEL,
};
