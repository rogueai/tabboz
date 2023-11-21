const std = @import("std");
const GTK = @import("gtk");
const c = GTK.c;
const gtk = GTK.gtk;

pub const I18n = @import("util/string.zig").I18n;

pub const Context = struct {
    allocator: std.mem.Allocator,
    i18n: I18n,
};
