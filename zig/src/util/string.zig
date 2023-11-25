/// imports
const std = @import("std");
const raw_text = @embedFile("strings.txt");

/// types
const CString = [:0]u8;
const Map = std.AutoHashMap(usize, CString);

/// I18n
pub const I18n = struct {
    map: Map,

    const Self = @This();

    pub fn init(allocator: std.mem.Allocator) Self {
        const map: Map = parseStrings(allocator) catch Map.init(allocator);
        return .{
            .map = map,
        };
    }

    pub fn deinit(self: *Self) void {
        var iter = self.map.valueIterator();
        while (iter.next()) |el| {
            self.map.allocator.free(el.*);
        }
        self.map.deinit();
    }

    fn parseStrings(allocator: std.mem.Allocator) !Map {
        std.log.info("Parsing strings...", .{});
        var map = Map.init(allocator);
        var fbs = std.io.fixedBufferStream(raw_text);
        var in_stream = fbs.reader();
        var buf: [1024]u8 = undefined;
        var line_number: usize = 0;
        while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
            line_number += 1;
            const idx_semicolon = std.mem.indexOf(u8, line, ":");
            if (idx_semicolon) |idx| {
                const key = std.mem.trim(u8, line[0..idx], " ");
                const key_usize = std.fmt.parseInt(usize, key, 10) catch |err| {
                    std.log.err("Skipped row number: {d}. Token '{s}' is not a number: {any}", .{ line_number, key, err });
                    continue;
                };
                const value = std.mem.trim(u8, line[idx + 1 ..], " ");
                const value_z = try std.fmt.allocPrintZ(allocator, "{s}", .{value});
                try map.put(key_usize, value_z);
            } else {
                std.log.warn("Skipped row number: {d}.", .{line_number});
            }
        }
        std.log.info("String parsed {d}", .{line_number});
        return map;
    }

    pub fn get(self: *Self, key: usize) ?CString {
        return self.map.get(key);
    }
};

test "Encode a struct into a JSON string2" {
    var i18n = I18n.init(std.testing.allocator);
    defer i18n.deinit();
    //    const value = i18n.get(101).?;
    // std.debug.print("\n{s}\n", .{value});

    //try std.testing.expect(std.mem.eql(
    //    [:0]const u8,
    //    &"TabbozSimulator",
    //));
}
