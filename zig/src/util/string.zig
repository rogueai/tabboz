const std = @import("std");
const jsonStrings = @embedFile("strings.json");
const Map = std.StringArrayHashMapUnmanaged([]const u8);

pub const I18n = struct {
    allocator: std.mem.Allocator,
    strings: Map,

    pub fn init(allocator: std.mem.Allocator) I18n {
        var map = parse(allocator) catch |err| default: {
            std.log.err("Error while parsing strings.json: {?}", .{err});
            break :default Map{}; // return an empty map
        };
        return .{
            .allocator = allocator,
            .strings = map,
        };
    }

    pub fn get(self: *I18n, key: usize) ?[:0]const u8 {
        var buf: [16]u8 = undefined;
        const sKey = std.fmt.bufPrint(&buf, "{d}", .{key}) catch "0";
        if (self.strings.get(sKey)) |value| {
            const sValue = std.fmt.allocPrintZ(self.allocator, "{s}", .{value}) catch "";
            std.log.debug("Key: {s} Value: {s}", .{ sKey, sValue });
            return sValue;
        }
        return null;
    }

    pub fn deinit(self: *I18n) void {
        self.strings.deinit(self.allocator);
    }

    fn parse(allocator: std.mem.Allocator) !Map {
        const JsonMap = std.json.ArrayHashMap([]const u8);
        var result = try std.json.parseFromSlice(JsonMap, allocator, jsonStrings, .{});
        defer result.deinit();
        return try result.value.map.clone(allocator);
    }
};

test "Encode a struct into a JSON string2" {
    var i18n = I18n.init(std.testing.allocator);
    defer i18n.deinit();
    try std.testing.expect(std.mem.eql(u8, "TabbozSimulator", i18n.get("1").?));
}
