const c = @import("cimport.zig");
const Widget = @import("widget.zig").Widget;
const ActionBar = @import("actionbar.zig").ActionBar;
const Bin = @import("bin.zig").Bin;
const Box = @import("box.zig").Box;
const button = @import("button.zig");
const Button = button.Button;
const ToggleButton = button.ToggleButton;
const CheckButton = button.CheckButton;
const ButtonBox = @import("button.zig").ButtonBox;
const color = @import("colorchooser.zig");
const ColorChooser = color.ColorChooser;
const ColorButton = color.ColorButton;
const ColorChooserWidget = color.ColorChooserWidget;
const ColorChooserDialog = color.ColorChooserDialog;
const combobox = @import("combobox.zig");
const ComboBox = combobox.ComboBox;
const ComboBoxText = combobox.ComboBoxText;
const common = @import("common.zig");
const Container = @import("container.zig").Container;
const dialog = @import("dialog.zig");
const Dialog = dialog.Dialog;
const AboutDialog = dialog.AboutDialog;
const MessageDialog = dialog.MessageDialog;
const entry = @import("entry.zig");
const Entry = entry.Entry;
const EntryBuffer = entry.EntryBuffer;
const EntryCompletion = entry.EntryCompletion;
const Expander = @import("expander.zig").Expander;
const filechooser = @import("filechooser.zig");
const FileChooser = filechooser.FileChooser;
const FileChooserButton = filechooser.FileChooserButton;
const FileChooserDialog = filechooser.FileChooserDialog;
const FileChooserWidget = filechooser.FileChooserWidget;
const Fixed = @import("fixed.zig").Fixed;
const flowbox = @import("flowbox.zig");
const FlowBox = flowbox.FlowBox;
const FlowBoxChild = flowbox.FlowBoxChild;
const fontchooser = @import("fontchooser.zig");
const FontChooser = fontchooser.FontChooser;
const FontButton = fontchooser.FontButton;
const FontChooserWidget = fontchooser.FontChooserWidget;
const FontChooserDialog = fontchooser.FontChooserDialog;
const frame = @import("frame.zig");
const AspectFrame = frame.AspectFrame;
const Frame = frame.Frame;
const grid = @import("grid.zig");
const Grid = grid.Grid;
const HeaderBar = @import("headerbar.zig").HeaderBar;
const Image = @import("image.zig").Image;
const Invisible = @import("invisible.zig").Invisible;
const Label = @import("label.zig").Label;
const Layout = @import("layout.zig").Layout;
const menu = @import("menu.zig");
const Menu = menu.Menu;
const MenuItem = menu.MenuItem;
const Notebook = @import("notebook.zig").Notebook;
const Paned = @import("paned.zig").Paned;
const Popover = @import("popover.zig").Popover;
const range = @import("range.zig");
const Range = range.Range;
const Scale = range.Scale;
const SpinButton = range.SpinButton;
const Revealer = @import("revealer.zig").Revealer;
const Separator = @import("separator.zig").Separator;
const stack = @import("stack.zig");
const Stack = stack.Stack;
const StackSwitcher = stack.StackSwitcher;
const StackSidebar = stack.StackSidebar;
const Switch = @import("switch.zig").Switch;
const window = @import("window.zig");
const ApplicationWindow = window.ApplicationWindow;
const Window = window.Window;
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

    // TODO: Verificare che i tipo di input e di destinazione siano compatibili
    pub fn get(self: Builder, comptime T: type, string: [:0]const u8) !T {
        // comptime {
        //     switch (@typeInfo(T)) {
        //         .Struct => |structInfo| {
        //             const destType = @typeName(T);
        //             const srcType = @typeName(structInfo.fields[0].type);
        //             if (!std.mem.eql(u8, getType(srcType), destType)) {
        //                 @compileError("Returned type does not match expected type");
        //             }
        //         },
        //         else => {
        //             @compileError("Error while returning the struct from the builder, Type must be one of the widgets");
        //         },
        //     }
        // }
        if (builder_get_widget(self.ptr, string.ptr)) |w| {
            return T{ .ptr = @ptrCast(w) };
        } else {
            return BuilderError.WidgetNotFoundError;
        }
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

    fn getType(srcType: []const u8) []const u8 {
        if (std.mem.eql(u8, srcType, "*cimport.struct__GtkImage")) {
            return "image.Image";
        } else {
            return "";
        }
    }
};
