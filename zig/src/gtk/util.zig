const c = @import("cimport.zig");

pub fn signal_connect(instance: c.gpointer, detailed_signal: [*c]const c.gchar, c_handler: c.GCallback, data: c.gpointer) c.gulong {
    var zero: u32 = 0;
    const flags: *c.GConnectFlags = @as(*c.GConnectFlags, @ptrCast(&zero));
    return c.g_signal_connect_data(instance, detailed_signal, c_handler, data, null, flags.*);
}

pub fn signal_connect_swapped(instance: c.gpointer, detailed_signal: [*c]const c.gchar, c_handler: c.GCallback, data: c.gpointer) c.gulong {
    return c.g_signal_connect_data(instance, detailed_signal, c_handler, data, null, c.G_CONNECT_SWAPPED);
}
