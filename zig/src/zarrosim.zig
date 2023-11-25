const std = @import("std");

const GTK = @import("gtk");
pub const c = GTK.c;
pub const gtk = GTK.gtk;

// commons
pub usingnamespace @import("gui/gui.zig");

// widgets
pub const widget = struct {
    pub usingnamespace @import("tabaccaioWidget.zig");
};

pub const I18n = @import("util/string.zig").I18n;
pub const Context = struct {
    i18n: I18n,
};

// todo: da spostare
pub fn EventWrapper(comptime I: type, comptime D: type) type {
    return struct {
        instance: *I,
        data: D,
        const Self = @This();
        pub fn new(allocator: std.mem.Allocator, instance: *I, data: D) !*Self {
            const object = try allocator.create(Self);
            object.* = .{
                .instance = instance,
                .data = data,
            };
            return object;
        }
    };
}

pub const STSCOOTER = struct {
    speed: i32, // velocita' massima
    cc: i32, // cilindrata
    xxx: i32, // [future espansioni]
    fama: i32, // figosita' scooter
    mass: i32, // massa sooter
    maneuver: i32, // manovrabilita'
    prezzo: i32, // costo dello scooter (modifiche incluse)
    stato: i32, // quanto e' intero (in percuntuale); -1 nessuno scooter
    nome: [:0]const u8, // nome dello scooter
};

pub const NEWSTSCOOTER = struct {
    speed: i32, // 01  Velocita'
    marmitta: i32, // 02  Marmitta 		( +0, +7, +12, +15)
    carburatore: i32, // 03  Carburatore  	( 0 - 4 )
    cc: i32, // 04  Cilindrata		( 0 - 4 )
    filtro: i32, // 05  Filtro dell' aria	( +0, +5, +10, +15)
    prezzo: i32, // 06  Costo dello scooter  (modifiche incluse)
    attivita: i32, // 07  Attivita' scooter
    stato: i32, // 08  Quanto e' intero (in percuntuale); -1 nessuno scooter
    nome: []const u8, // 09  Nome dello scooter
    fama: i32, // 10  Figosita' scooter
};

pub const ScooterMem: [8]NEWSTSCOOTER = .{
    .{ .speed = 0, .marmitta = 0, .carburatore = 0, .cc = 0, .filtro = 0, .prezzo = 0, .attivita = 0, .stato = -1, .nome = "Nessuno scooter", .fama = 0 }, //
    .{ .speed = 65, .marmitta = 0, .carburatore = 0, .cc = 0, .filtro = 0, .prezzo = 2498, .attivita = 1, .stato = 100, .nome = "Magutty Firecow", .fama = 5 },
    .{ .speed = 75, .marmitta = 0, .carburatore = 1, .cc = 1, .filtro = 1, .prezzo = 4348, .attivita = 1, .stato = 100, .nome = "Honda F98", .fama = 10 },
    .{ .speed = 105, .marmitta = 1, .carburatore = 1, .cc = 2, .filtro = 1, .prezzo = 6498, .attivita = 1, .stato = 100, .nome = "Mizzubisci R200 Millenium", .fama = 15 },
    .{ .speed = 75, .marmitta = 0, .carburatore = 0, .cc = 1, .filtro = 1, .prezzo = 4298, .attivita = 1, .stato = 100, .nome = "Magutty Firecow+", .fama = 7 },
    .{ .speed = 100, .marmitta = 0, .carburatore = 1, .cc = 2, .filtro = 1, .prezzo = 5998, .attivita = 1, .stato = 100, .nome = "Magutty Firecow II", .fama = 10 },
    .{ .speed = 100, .marmitta = 0, .carburatore = 1, .cc = 2, .filtro = 1, .prezzo = 6348, .attivita = 1, .stato = 100, .nome = "Honda F98s", .fama = 13 },
    .{ .speed = 250, .marmitta = 0, .carburatore = 5, .cc = 5, .filtro = 0, .prezzo = 1450, .attivita = 1, .stato = 100, .nome = "Lexux LS400 ", .fama = 60 },
};

const Time = struct {
    x_giorno: u32,
    x_mese: u32,
    x_giornoset: u32,
    x_vacanza: u32,
    x_anno_bisesto: u32,
    scad_pal_giorno: u32, // Giorno e mese in cui scadra' l' abbonamento alla palestra.
    scad_pal_mese: u32,
    comp_giorno: u32, // giorno & mese del compleanno
    comp_mese: u32,
};

const GameState = struct {
    time: Time,
    ScooterData: NEWSTSCOOTER,
    soldi: u32,
    oa: []const u8, // penso sia il pronome
};

pub var gameState: GameState = .{
    .time = undefined,
    .ScooterData = ScooterMem[0],
    .soldi = 0,
    .oa = undefined,
};

const euro = false;

pub fn mostraSoldi(allocator: std.mem.Allocator, i: i32) ![]const u8 {
    if (euro) {
        const f: f32 = @floatFromInt(i);
        return try std.fmt.allocPrint(allocator, "{d:0.2} ue", .{f / 2.0});
    } else if (i == 0) {
        return try std.fmt.allocPrint(allocator, "0 L.", .{});
    } else {
        return try std.fmt.allocPrint(allocator, "{d}000 L.", .{i});
    }
}

test "mostraSoldi" {
    const alloc = std.testing.allocator;
    const string = try mostraSoldi(alloc, 211);
    defer alloc.free(string);
    std.debug.print("{s}\n", .{string});
}

test "access by reference" {
    var scooterData = &gameState.ScooterData;
    gameState.ScooterData.speed = 0;
    scooterData.speed = 10;
    try std.testing.expectEqual(scooterData.speed, gameState.ScooterData.speed);
}
