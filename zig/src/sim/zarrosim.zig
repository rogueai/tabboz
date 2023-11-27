const std = @import("std");

const GTK = @import("gtk");
pub const c = GTK.c;
pub const gtk = GTK.gtk;

// commons
pub usingnamespace @import("../gui/gui.zig");

pub const I18n = @import("../util//string.zig").I18n;
pub const Context = struct {
    i18n: I18n,
};

pub const Types = struct {
    pub usingnamespace @import("zarrosimh.zig");
};

const GameState = struct {
    time: Types.Time,
    ScooterData: Types.NEWSTSCOOTER,
    soldi: u32,
    oa: []const u8, // penso sia il pronome
};

pub var gameState: GameState = .{
    .time = undefined,
    .ScooterData = undefined,
    .soldi = 0,
    .oa = undefined,
};

// var data = Types.Data{};

//*******************************************************************
// PROCEDURA PRINCIPALE per la versione Windows.
pub fn WinMain() void {

    // Inizializza il programma
    // InitTabboz();

    // /* Finestra principale */
    // DialogBox(hInst,MAKEINTRESOURCE(1),NULL,TabbozWndProc);

    // /* Chiusura */

    // Nuova chiusura - 19 Giugno 1999, speriamo che ora non crashi piu'...
    //  if (boolean_shutdown == 2) {
    // 		FineProgramma("shutdown"); // Salvataggio partita...
    // 		#ifdef TABBOZ_DEBUG
    // 		if (debug_active) {
    // 				writelog("tabboz: end (exit + shutdown)");
    // 				closelog();
    // 		}
    // 		#endif
    // 		ExitWindows(0, 0);

    //  } else {
    // 		FineProgramma("main"); // Salvataggio partita...
    // 		#ifdef TABBOZ_DEBUG
    // 		if (debug_active) {
    // 				writelog("tabboz: end (standard exit)");
    // 				closelog();
    // 		}
    // 		#endif
    //  }

    return 0;
}

/// InitTabboz
// pub fn InitTabboz() void {
// 	 char       tmp[128];
//      nome_del_file_su_cui_salvare[0]=0;

// 	 // Inizializzazione dei numeri casuali...
// 	 randomize();

// 	 // Inizializza un po' di variabile...
// 	 boolean_shutdown=0;		  /* 0=resta dentro, 1=uscita, 2=shutdown 19 Giugno 1999 / 14 Ottoble 1999 */

// 	 Fortuna=0;					     /* Uguale a me...               */
// 	 ScooterData=ScooterMem[0];  /* nessuno scooter              */
// 	 Attesa=ATTESAMAX;           /* attesa per avere soldi...    */
// 	 ImgSelector=0;              /* W l' arte di arrangiarsi...  */
// 	 timer_active=1;             			 /* 10 Giugno  1998 */
// 	 fase_di_avvio=1;				 		    /* 11 Giugno  1998 */
// 	 Tempo_trascorso_dal_pestaggio=0;    /* 12 Giugno  1998 */
// 	 current_tipa=0;							 /* 6  Maggio  1999 */

// 	 debug_active=atoi (RRKey("Debug"));

// 	 if (debug_active < 0) debug_active=0;

// 	 if (debug_active == 1) {
// 		 openlog();
// 		 sprintf(tmp,"tabboz: Starting Tabboz Simulator %s %s",VERSION,__DATE__);
// 		 writelog(tmp);
// 		 }

// 	 // Ottieni i nomi dei creatori di sto coso...
// 	 LoadString(hInst, 10, Andrea,   sizeof(Andrea));
// 	 LoadString(hInst, 11, Caccia,   sizeof(Caccia));
// 	 LoadString(hInst, 12, Daniele,  sizeof(Daniele));
// 	 LoadString(hInst,  2, Obscured, sizeof(Obscured));

// 	 // /* Registra la Classe BMPView - E' giusto metterlo qui ??? - 25 Feb 1999 */
// 	 RegisterBMPViewClass(hInst);

// 	 // /* Registra la Classe BMPTipa - 6 Maggio 1999 */
// 	 RegisterBMPTipaClass(hInst);

// 	 firsttime=0;
// 	 CaricaTutto();

//     // 15 Gen 1999 - Parametro 'config' sulla linea di comando
//     // 12 Mar 1999 - A causa di un riordino generale, e' stata spostata qui...

// 	 if (_argc > 1)
// 		 if (! strcmp(_argv[1],"config") ) {
// 			 hWndMain = 0; // Segnala che non esiste proc. principale.
// 			 DialogBox(hInst,MAKEINTRESOURCE(CONFIGURATION),NULL,Configuration);
// 			 FineProgramma("config");
// 			 exit(0);
// 	}

// // 15 Mar 1998 - Ora mostra anche il logo iniziale
// // 12 Mar 1999 - A causa di un riordino generale, e' stata spostata qui...

// 	 if (STARTcmdShow)
// 		DialogBox(hInst,MAKEINTRESOURCE(LOGO),NULL,Logo);

// // 14 Gen 1999 - Formattazione iniziale Tabbozzo
// 	 if (firsttime == 1) {
// 		 lpproc = MakeProcInstance(FormatTabboz, hInst);
// 		 DialogBox(hInst,
// 				MAKEINTRESOURCE(15),
// 				hInst,
// 				lpproc);
// 		 FreeProcInstance(lpproc);
//        }

// }

const euro = false;

pub fn mostraSoldi(allocator: std.mem.Allocator, i: i32) ![:0]u8 {
    if (euro) {
        const f: f32 = @floatFromInt(i);
        return try std.fmt.allocPrintZ(allocator, "{d:0.2} ue", .{f / 2.0});
    } else if (i == 0) {
        return try std.fmt.allocPrintZ(allocator, "0 L.", .{});
    } else {
        return try std.fmt.allocPrintZ(allocator, "{d}000 L.", .{i});
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
