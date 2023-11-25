const std = @import("std");
const zarrosim = @import("zarrosim.zig");
const c = zarrosim.c;
const gtk = zarrosim.gtk;

// /* Sigarette --------------------------------------------------------------------------------------- */
const ScooterMem: [24]zarrosim.STSCOOTER = .{
    .{ .speed = 5, .cc = 5, .xxx = 0, .fama = 2, .mass = 0, .maneuver = 0, .prezzo = 6, .stato = 0, .nome = "Barclay" },
    .{ .speed = 8, .cc = 7, .xxx = 0, .fama = 1, .mass = 0, .maneuver = 0, .prezzo = 6, .stato = 0, .nome = "Camel" },
    .{ .speed = 7, .cc = 6, .xxx = 0, .fama = 2, .mass = 0, .maneuver = 0, .prezzo = 6, .stato = 0, .nome = "Davidoff Superior Lights" },
    .{ .speed = 7, .cc = 6, .xxx = 0, .fama = 2, .mass = 0, .maneuver = 0, .prezzo = 6, .stato = 0, .nome = "Davidoff Mildnes" },
    .{ .speed = 13, .cc = 9, .xxx = 0, .fama = 2, .mass = 0, .maneuver = 0, .prezzo = 6, .stato = 0, .nome = "Davidoff Classic" },
    .{ .speed = 9, .cc = 7, .xxx = 0, .fama = 1, .mass = 0, .maneuver = 0, .prezzo = 5, .stato = 0, .nome = "Diana Blu" },
    .{ .speed = 12, .cc = 9, .xxx = 0, .fama = 1, .mass = 0, .maneuver = 0, .prezzo = 5, .stato = 0, .nome = "Diana Rosse" },
    .{ .speed = 8, .cc = 7, .xxx = 0, .fama = 0, .mass = 0, .maneuver = 0, .prezzo = 6, .stato = 0, .nome = "Dunhill Lights" },
    .{ .speed = 7, .cc = 5, .xxx = 0, .fama = 0, .mass = 0, .maneuver = 0, .prezzo = 6, .stato = 0, .nome = "Merit" },
    .{ .speed = 14, .cc = 10, .xxx = 0, .fama = 0, .mass = 0, .maneuver = 0, .prezzo = 6, .stato = 0, .nome = "Gauloises Blu" },
    .{ .speed = 7, .cc = 6, .xxx = 0, .fama = 0, .mass = 0, .maneuver = 0, .prezzo = 6, .stato = 0, .nome = "Gauloises Rosse" },
    .{ .speed = 13, .cc = 10, .xxx = 0, .fama = 1, .mass = 0, .maneuver = 0, .prezzo = 6, .stato = 0, .nome = "Unlucky Strike" },
    .{ .speed = 9, .cc = 7, .xxx = 0, .fama = 1, .mass = 0, .maneuver = 0, .prezzo = 6, .stato = 0, .nome = "Unlucky Strike Lights" },
    .{ .speed = 8, .cc = 6, .xxx = 0, .fama = 2, .mass = 0, .maneuver = 0, .prezzo = 6, .stato = 0, .nome = "Malborro Medium" }, // dovrebbero essere come le lights 4 Marzo 1999
    .{ .speed = 12, .cc = 9, .xxx = 0, .fama = 2, .mass = 0, .maneuver = 0, .prezzo = 6, .stato = 0, .nome = "Malborro Rosse" },
    .{ .speed = 8, .cc = 6, .xxx = 0, .fama = 2, .mass = 0, .maneuver = 0, .prezzo = 6, .stato = 0, .nome = "Malborro Lights" },
    .{ .speed = 11, .cc = 10, .xxx = 0, .fama = 0, .mass = 0, .maneuver = 0, .prezzo = 5, .stato = 0, .nome = "NS Rosse" },
    .{ .speed = 9, .cc = 8, .xxx = 0, .fama = 0, .mass = 0, .maneuver = 0, .prezzo = 5, .stato = 0, .nome = "NS Mild" },
    .{ .speed = 9, .cc = 7, .xxx = 0, .fama = 1, .mass = 0, .maneuver = 0, .prezzo = 5, .stato = 0, .nome = "Poll Mon Blu" },
    .{ .speed = 12, .cc = 9, .xxx = 0, .fama = 1, .mass = 0, .maneuver = 0, .prezzo = 5, .stato = 0, .nome = "Poll Mon Rosse" },
    .{ .speed = 12, .cc = 10, .xxx = 0, .fama = 2, .mass = 0, .maneuver = 0, .prezzo = 6, .stato = 0, .nome = "Philip Morris" },
    .{ .speed = 4, .cc = 4, .xxx = 0, .fama = 2, .mass = 0, .maneuver = 0, .prezzo = 6, .stato = 0, .nome = "Philip Morris Super Light" },
    .{ .speed = 10, .cc = 9, .xxx = 0, .fama = 1, .mass = 0, .maneuver = 0, .prezzo = 5, .stato = 0, .nome = "Armadis" },
    .{ .speed = 11, .cc = 9, .xxx = 0, .fama = 0, .mass = 0, .maneuver = 0, .prezzo = 5, .stato = 0, .nome = "Winston" },
    // 	        |       \nicotina * 10 ( 7 = nicotina 0.7, 10 = nicotina 1 )
    //          \condensato
};

pub const TabaccaioWidget = struct {
    const Self = @This();

    const Map = std.StringHashMap(gtk.Widget);
    const OnSelectData = zarrosim.EventWrapper(Self, usize);

    arena: std.heap.ArenaAllocator,
    widgets: Map,
    context: *zarrosim.Context,

    pub fn init(allocator: std.mem.Allocator, context: *zarrosim.Context) Self {
        var arena = std.heap.ArenaAllocator.init(allocator);
        return Self{
            .arena = arena,
            .widgets = Map.init(arena.allocator()),
            .context = context,
        };
    }

    pub fn deinit(self: *Self) void {
        defer self.arena.deinit();
    }

    pub fn create(self: *Self) !*gtk.Widget {
        const builder = gtk.Builder.new();
        builder.add_from_string(zarrosim.ui.window_88) catch |e| {
            std.debug.print("{?}\n", .{e});
        };
        // Builder.get_widget() returns an optional, so unwrap if there is a value
        var w = try builder.get_widget("window");

        try self.widgets.put("message", try builder.get_widget("message"));

        var grid: gtk.Grid = try builder.get(gtk.Grid, "grid");

        var buffer: [24]u8 = undefined;
        for (0..24) |i| {
            var button = gtk.Button.new();
            const fileName = try std.fmt.bufPrintZ(&buffer, "./res/{d}.BMP", .{i + 1400});
            var image = gtk.Image.new_from_file(fileName);
            button.set_image(image.as_widget());

            const event: *OnSelectData = OnSelectData.new(self.arena.allocator(), self, i) catch unreachable;
            button.as_widget().connectWidget(OnSelectData, "clicked", onSelect, event);

            const left = i % 8;
            const top = @divTrunc(i, 8);
            grid.attach(button.as_widget(), left, top, 1, 1);
        }

        w.show_all();
        w.connect("delete-event", @as(c.GCallback, @ptrCast(&c.gtk_main_quit)), null);

        // var okButton: gtk.Widget = try builder.get_widget("ok");
        // const parent = okButton.get_root_window();
        // std.log.debug("Result {?}\n", .{parent});
        // okButton.connectWidget("clicked", openDialog);
        // okButton.connect("clicked", @as(c.GCallback, @ptrCast(&openDialog)), self);

        return &w;
    }

    fn onSelect(_: *c.GtkWidget, event: *OnSelectData) void {
        const label = event.instance.widgets.get("message");
        if (label) |l| {
            l.to_label().?.set_text(ScooterMem[event.data].nome);
        }
    }
};
