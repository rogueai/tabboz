const std = @import("std");

const jsonStrings = @embedFile("strings.json");

const Map = std.StringArrayHashMapUnmanaged([]const u8);

pub const I18n = struct {
    allocator: std.mem.Allocator,
    strings: Map,

    pub fn init(allocator: std.mem.Allocator) I18n {
        var map = parse(allocator) catch unreachable;
        return .{
            .allocator = allocator,
            .strings = map,
        };
    }

    pub fn get(self: *I18n, key: []const u8) ?[]const u8 {
        return self.strings.get(key);
    }

    pub fn deinit(self: *I18n) void {
        self.strings.deinit(self.allocator);
    }

    fn parse(allocator: std.mem.Allocator) !Map {
        const JsonMap = std.json.ArrayHashMap([]const u8);
        var result = try std.json.parseFromSliceLeaky(JsonMap, allocator, jsonStrings, .{});
        defer result.deinit(allocator);
        return try result.map.clone(std.testing.allocator);
    }
};

test "Encode a struct into a JSON string2" {
    var i18n = I18n.init(std.testing.allocator);
    defer i18n.deinit();
    try std.testing.expect(std.mem.eql(u8, "TabbozSimulator", i18n.get("1").?));
}
