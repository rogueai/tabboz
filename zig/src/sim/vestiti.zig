const std = @import("std");
const sim = @import("zarrosim.zig");
const handle = @import("handle.zig");

// extern void EventiPalestra(HANDLE hInstance);
// BOOL FAR PASCAL CompraQualcosa(HWND hDlg, WORD message, WORD wParam, LONG lParam);
// void PagaQualcosa(HWND parent);

// Per una questione di svogliatezza del programmatore, viene usata STSCOOTER anche x i vestiti.
pub const VestitiMem: [24]sim.Types.STSCOOTER = .{
    .{ .speen = 0, .cc = 0, .xxx = 0, .fama = 0, .mass = 0, .maneuver = 0, .prezzo = 0, .stato = 0, .nome = "---" },
    .{ .speed = 0, .cc = 0, .xxx = 0, .fama = 8, .mass = 0, .maveuver = 0, .prezzo = 348, .stato = 0, .nome = "" }, // -- Giubbotto "Fatiscenza"
    .{ .speed = 0, .cc = 0, .xxx = 0, .fama = 9, .mass = 0, .maveuver = 0, .prezzo = 378, .stato = 0, .nome = "" }, //
    .{ .speed = 0, .cc = 0, .xxx = 0, .fama = 7, .mass = 0, .maveuver = 0, .prezzo = 298, .stato = 0, .nome = "" }, //
    .{ .speed = 0, .cc = 0, .xxx = 0, .fama = 8, .mass = 0, .maveuver = 0, .prezzo = 248, .stato = 0, .nome = "" }, //    Giacca di pelle (3 Nuovi Giubbotti)
    .{ .speed = 0, .cc = 0, .xxx = 0, .fama = 9, .mass = 0, .maveuver = 0, .prezzo = 378, .stato = 0, .nome = "" }, //    Fatiscenza verde
    .{ .speed = 0, .cc = 0, .xxx = 0, .fama = 10, .mass = 0, .maveuver = 0, .prezzo = 418, .stato = 0, .nome = "" }, //    Fatiscenza bianco
    .{ .speed = 0, .cc = 0, .xxx = 0, .fama = 3, .mass = 0, .maveuver = 0, .prezzo = 90, .stato = 0, .nome = "" }, // -- Pantaloni gessati
    .{ .speed = 0, .cc = 0, .xxx = 0, .fama = 5, .mass = 0, .maveuver = 0, .prezzo = 170, .stato = 0, .nome = "" }, //    Pantaloni tuta
    .{ .speed = 0, .cc = 0, .xxx = 0, .fama = 6, .mass = 0, .maveuver = 0, .prezzo = 248, .stato = 0, .nome = "" }, //    Pantaloni in plastika
    .{ .speed = 0, .cc = 0, .xxx = 0, .fama = 5, .mass = 0, .maveuver = 0, .prezzo = 190, .stato = 0, .nome = "" }, //    Pantaloni scacchiera 21 giugno 1999
    .{ .speed = 0, .cc = 0, .xxx = 0, .fama = 4, .mass = 0, .maveuver = 0, .prezzo = 122, .stato = 0, .nome = "" }, // -- Scarpe da tabbozzi...
    .{ .speed = 0, .cc = 0, .xxx = 0, .fama = 6, .mass = 0, .maveuver = 0, .prezzo = 220, .stato = 0, .nome = "" }, //    Buffalo
    .{ .speed = 0, .cc = 0, .xxx = 0, .fama = 2, .mass = 0, .maveuver = 0, .prezzo = 58, .stato = 0, .nome = "" }, //    Scarpe da tabbozzi...
    .{ .speed = 0, .cc = 0, .xxx = 0, .fama = 4, .mass = 0, .maveuver = 0, .prezzo = 142, .stato = 0, .nome = "" }, //    NUOVE Scarpe da tabbozzi...   23 Aprile 1998
    .{ .speed = 0, .cc = 0, .xxx = 0, .fama = 4, .mass = 0, .maveuver = 0, .prezzo = 142, .stato = 0, .nome = "" }, //    ""		""
    .{ .speed = 0, .cc = 0, .xxx = 0, .fama = 5, .mass = 0, .maveuver = 0, .prezzo = 166, .stato = 0, .nome = "" }, //    ""		""
    .{ .speed = 0, .cc = 0, .xxx = 0, .fama = 6, .mass = 0, .maveuver = 0, .prezzo = 230, .stato = 0, .nome = "" }, //    Nuove Buffalo
};

// Abbonamenti Palestra ----------------------------------------------------------------------------
pub const PalestraMem: [4]sim.Types.STSCOOTER = .{
    .{ .speen = 0, .cc = 0, .xxx = 0, .fama = 0, .mass = 0, .maneuver = 0, .prezzo = 50, .stato = 0, .nome = "" }, // Un mese	21 Apr 1998
    .{ .speen = 0, .cc = 0, .xxx = 0, .fama = 8, .mass = 0, .maveuver = 0, .prezzo = 270, .stato = 0, .nome = "" }, // Sei mesi
    .{ .speen = 0, .cc = 0, .xxx = 0, .fama = 9, .mass = 0, .maveuver = 0, .prezzo = 500, .stato = 0, .nome = "" }, // Un anno
    .{ .speen = 0, .cc = 0, .xxx = 0, .fama = 9, .mass = 0, .maveuver = 0, .prezzo = 14, .stato = 0, .nome = "" }, // Una lampada
};

// Sigarette ---------------------------------------------------------------------------------------
pub const SizeMem: [24]sim.Types.STSCOOTER = .{
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
};
//	    |			|
//		|   		\nicotina * 10 ( 7 = nicotina 0.7, 10 = nicotina 1 )
//		\condensato
//
//
//********************************************************************/
//* Vestiti...                                                       */
//********************************************************************/
//
//# pragma argsused
//BOOL FAR PASCAL Vestiti(HWND hDlg, WORD message, WORD wParam, LONG lParam)
//{
//	 char          tmp[128];
//	 FARPROC       lpproc;
//
//	 if (message == WM_INITDIALOG) {
//		SetDlgItemText(hDlg, 120, MostraSoldi(Soldi));
//
//		/* Vestito da Babbo Natale... 11 Marzo 1999 */
//#define COSTO_VESTITO_NATALIZIO 58
//
//		if ((x_mese == 12) && (Soldi >= COSTO_VESTITO_NATALIZIO))
//			if ((x_giorno > 14) && ( x_giorno < 25) && ( current_gibbotto!=19) && (current_pantaloni!=19)) {
//				int scelta;
//				sprintf(tmp,"Vuoi comperare, per %s, un meraviglioso vestito da Babbo Natale ?",MostraSoldi(COSTO_VESTITO_NATALIZIO));
//				scelta=MessageBox( hDlg,
//					tmp,
//					"Offerte Natalizie...", MB_YESNO | MB_ICONQUESTION);
//				if (scelta == IDYES) {
//					current_gibbotto=19;
//					current_pantaloni=19;
//					TabbozRedraw = 1;	// E' necessario ridisegnare l' immagine del Tabbozzo...
//					Soldi-=COSTO_VESTITO_NATALIZIO;
//					}
//			}
//
//		return(TRUE);
//
//	 }else if (message == WM_COMMAND) {
//
//		switch (wParam) {
//
//		case 101:		// MAKEINTRESOURCE 80
//		case 102:		// MAKEINTRESOURCE 81
//		case 103:		// MAKEINTRESOURCE 82
//		case 104:		// MAKEINTRESOURCE 83
//		case 105:		// MAKEINTRESOURCE 84
//			RunVestiti(hDlg,(wParam-21));
//			SetDlgItemText(hDlg, 120, MostraSoldi(Soldi));
//			return(TRUE);
//
//		case 110:		// Tabaccaio
//			RunTabacchi(hDlg);
//			SetDlgItemText(hDlg, 120, MostraSoldi(Soldi));
//			return(TRUE);
//
//		case 111:		// Palestra
//			RunPalestra(hDlg);
//			SetDlgItemText(hDlg, 120, MostraSoldi(Soldi));
//			return(TRUE);
//
//		case 112:	   // Cellulare
//			lpproc = MakeProcInstance(Cellular, hInst);
//			DialogBox(hInst,
//				MAKEINTRESOURCE(CELLULAR),
//				hDlg,
//				lpproc);
//			FreeProcInstance(lpproc);
//
//			SetDlgItemText(hDlg, 120, MostraSoldi(Soldi));
//			return(TRUE);
//
//		case IDCANCEL:
//			EndDialog(hDlg, TRUE);
//			return(TRUE);
//
//		case IDOK:
//			EndDialog(hDlg, TRUE);
//			return(TRUE);
//
//		default:
//			return(TRUE);
//		}
//	 }
//
//	 return(FALSE);
//}
//
////*******************************************************************
//// Routine per il pagamento di qualunque cosa...
////*******************************************************************
//
//void
//PagaQualcosa(HANDLE hInstance)
//{
//char	tmp[128];
//
//	if (scelta != 0) {
//		if (VestitiMem[scelta].prezzo > Soldi) {
//			(void)nomoney(hInstance,VESTITI);
//		} else {
//			Soldi-= VestitiMem[scelta].prezzo;
//
//			switch (scelta) {	/* 25 Febbraio 1999 */
//				case 1:
//				case 2:
//				case 3:
//				case 4:
//				case 5:
//				case 6:  current_gibbotto=scelta; break;
//				case 7:
//				case 8:
//				case 9:
//				case 10: current_pantaloni=scelta-6; break;
//				case 11:
//				case 12:
//				case 13:
//				case 14:
//				case 15:
//				case 16:
//				case 17: current_scarpe=scelta-10; break;
//			}
//
//			TabbozRedraw = 1;	// E' necessario ridisegnare l' immagine del Tabbozzo...
//
//	      #ifdef TABBOZ_DEBUG
//	      sprintf(tmp,"vestiti: Paga %s",MostraSoldi(VestitiMem[scelta].prezzo));
//			writelog(tmp);
//	      #endif
//	      Fama+=VestitiMem[scelta].fama;
//	      if (Fama > 100) Fama=100;
//	   }
//	   Evento(hInstance);
//	}
//}
//
//
////*******************************************************************
//// Routine di acquisto generica
////*******************************************************************
//
//# pragma argsused
//BOOL FAR PASCAL CompraQualcosa(HWND hDlg, WORD message, WORD wParam, LONG lParam)
//{
//	 char          tmp[128];
//	 int		  i;
//
//	 if (message == WM_INITDIALOG) {
//	scelta=0;
//	SetDlgItemText(hDlg, 120, MostraSoldi(Soldi));
//	sprintf(tmp, "%d/100", Fama);
//	SetDlgItemText(hDlg, 121, tmp);
//
//	for (i=101;i<120;i++) {
//		SetDlgItemText(hDlg, i, MostraSoldi(VestitiMem[i-100].prezzo));
//	}
//	return(TRUE);
//	}
//
//	 else if (message == WM_COMMAND)
//	 {
//	switch (wParam)
//	{
//		 case 101:
//		 case 102:
//		 case 103:
//		 case 104:
//		 case 105:
//		 case 106:
//		 case 107:
//		 case 108:
//		 case 109:
//		 case 110:
//		 case 111:
//		 case 112:
//		 case 113:
//		 case 114:
//		 case 115:
//		 case 116:
//		 case 117:
//		 case 118:
//		 case 119:
//		scelta=wParam-100;
//		return(TRUE);
//
//		 case IDCANCEL:
//		scelta=0;
//		EndDialog(hDlg, TRUE);
//		return(TRUE);
//
//		 case IDOK:
//		PagaQualcosa(hDlg);
//		EndDialog(hDlg, TRUE);
//		return(TRUE);
//
//		 default:
//		return(TRUE);
//	}
//	 }
//
//	 return(FALSE);
//}
//
//
////*******************************************************************
//// Tabaccaio ! (che centra tra i vestiti ??? Come procedura e' simile...)
////*******************************************************************
//
//# pragma argsused

const HWND: type = usize;
const WORD: type = usize;
const LONG: type = usize;
const IDCANCEL = 0;
const IDOK = 1;

pub fn TabbozPlaySound(id: usize) void {
    _ = id;
}

var Soldi: i32 = 10;

var sizze: i32 = 0;
var ao = "a";
var Fama: i32 = 50;

const current_testa = 0;
const InfoMese: sim.STMESI = undefined;
const scad_pal_giorno = 0;
const scad_pal_mese = 0;

const TABACCAIO = 88;

pub fn nomoney(hDlg: HWND, tipo: comptime_int) void {
    _ = tipo;
    _ = hDlg;
}

const sound_active = true;

pub fn Tabaccaio(hDlg: handle.Handle, message: handle.HandleMessage, wParam: ?WORD) !bool {
    var scelta: usize = undefined;
    // var tmp_descrizione: [1024]u8 = undefined;
    var buffer: [512]u8 = undefined;

    if (message == handle.HandleMessage.WM_INITDIALOG) {
        if (sound_active) {
            TabbozPlaySound(203);
        }
        handle.SetDlgItemText(hDlg, 104, try sim.mostraSoldi(hDlg.allocator, Soldi));

        const text_105 = try std.fmt.bufPrintZ(&buffer, "{d}", .{sizze});
        handle.SetDlgItemText(hDlg, 105, text_105);

        const text_106 = try std.fmt.bufPrintZ(&buffer, "Che sigarette vuoi, ragazz{s} ?", .{ao});
        handle.SetDlgItemText(hDlg, 106, text_106);

        return true;
    } else if (message == handle.HandleMessage.WM_COMMAND) {
        if (wParam) |param| {
            switch (param) {
                400...423 => {
                    scelta = param - 400;
                    var text_106: [:0]u8 = undefined;

                    var tmp: [:0]const u8 = "";
                    if (hDlg.context.i18n.get(param + 1000)) |label| {
                        tmp = label;
                    }
                    if (SizeMem[scelta].cc == 0) {
                        // Se i valori sono impostati a 0, non li scrive
                        text_106 = try std.fmt.bufPrintZ(&buffer, "{s}\n{s}", .{ SizeMem[scelta].nome, tmp });
                    } else {
                        const nico: f32 = @as(f32, @floatFromInt(SizeMem[scelta].cc)) / 10.0;
                        text_106 = try std.fmt.bufPrintZ(&buffer, "{s}\n{s}Condensato: {d} Nicotina: {d:.2}", .{ SizeMem[scelta].nome, tmp, SizeMem[scelta].speed, nico });
                        std.log.debug("{s}", .{text_106});
                    }
                    handle.SetDlgItemText(hDlg, 106, text_106);
                    return true;
                },
                IDCANCEL => {
                    // EndDialog(hDlg, TRUE);
                    return true;
                },
                IDOK => {
                    if (scelta != -1) {
                        if (SizeMem[scelta].prezzo > Soldi) {
                            // nomoney(hDlg, TABACCAIO);
                        } else {
                            Soldi -= SizeMem[scelta].prezzo;
                            //#ifdef TABBOZ_DEBUG
                            std.log.debug("tabaccaio: Paga {any}", .{sim.mostraSoldi(hDlg.allocator, SizeMem[scelta].prezzo)});
                            // #endif
                            Fama += SizeMem[scelta].fama;
                            if (Fama > 100) {
                                Fama = 100;
                            }
                            sizze += 20;
                        }

                        //var rand_impl = std.rand.DefaultPrng.init(42);
                        //const i: usize = @mod(rand_impl.random().int(usize), 8);

                        //LoadString(hInst, i, (LPSTR)tmp, 254);  // 600 -> 607
                        //MessageBox( hDlg,
                        //(LPSTR)tmp,
                        //"ART. 46 L. 29/12/1990 n. 428", MB_OK | MB_ICONINFORMATION );
                        // Evento(hDlg);
                    }
                    // EndDialog(hDlg, TRUE);
                    return true;
                },
                else => {
                    return true;
                },
            }
        }
    }
    return false;
}

// Palestra ! (che centra tra i vestiti ??? Come procedura e' simile...)
// pub fn AggiornaPalestra(hDlg: handle.Handle) bool {
//     var tmp: [128]u8 = undefined;
//     handle.SetDlgItemText(hDlg, 104, sim.mostraSoldi(Soldi));

//     handle.sprintf(&tmp, "{d}/100", Fama, .{});
//     handle.SetDlgItemText(hDlg, 105, tmp);

//     if (scad_pal_giorno < 1) {
//         handle.sprintf(&tmp, "Nessun Abbonamento", .{});
//         handle.SetDlgItemText(hDlg, 106, tmp);
//     } else {
//         handle.sprintf(&tmp, "Scadenza abbonamento: {d} {s}", .{ scad_pal_giorno, InfoMese[scad_pal_mese - 1].nome });
//         handle.SetDlgItemText(hDlg, 106, tmp);
//     }

//     // Scrive il grado di abbronzatura... 4 Marzo 1999
//     switch (current_testa) {
//         1 => handle.sprintf(&tmp, "Abbronzatura Lieve", .{}),
//         2 => handle.sprintf(&tmp, "Abbronzatura Media", .{}),
//         3 => handle.sprintf(&tmp, "Abbronzatura Pesante", .{}),
//         4 => handle.sprintf(&tmp, "Carbonizzat{s}...", .{ao}),
//         else => handle.sprintf(&tmp, "Non abbronzat{s}", .{ao}),
//     }
//     handle.SetDlgItemText(hDlg, 107, tmp);
// }

////*******************************************************************
//
//# pragma argsused
//BOOL FAR PASCAL Palestra(HWND hDlg, WORD message, WORD wParam, LONG lParam)
//{
//// Costi... (migliaia di lire)
//#define UN_MESE		50
//#define SEI_MESI	270
//#define UN_ANNO		500
//
//	 char          tmp[128];
//	 int		  i;
//
//	 if (message == WM_INITDIALOG) {
//	AggiornaPalestra(hDlg);
//	for (i=0; i<4; i++)
//		SetDlgItemText(hDlg, 120 + i , MostraSoldi(PalestraMem[i].prezzo));
//
//	return(TRUE);
//	}
//
//	 else if (message == WM_COMMAND)
//	 {
//	switch (wParam)
//	{
//
//		 case 110:	// Vai in palestra
//		if (scad_pal_giorno < 1) {
//			  MessageBox( hDlg,
//					"Prima di poter venire in palestra devi fare un abbonamento !",
//					"Palestra", MB_OK | MB_ICONINFORMATION);
//		} else {
//			  if (sound_active) TabbozPlaySound(201);
//			  if (Fama < 82) Fama++;
//			  EventiPalestra(hDlg);
//			  AggiornaPalestra(hDlg);
//			  /* Evento(hDlg); */
//
//		}
//		return(TRUE);
//
//		 case 111:	// Lampada
//			if (PalestraMem[3].prezzo > Soldi) {
//				nomoney(hDlg,PALESTRA);
//			} else {
//				if (current_testa < 3) {
//					current_testa++; // Grado di abbronzatura
//					if (Fama < 20) Fama++;	// Da 0 a 3 punti in piu' di fama
//					if (Fama < 45) Fama++;	// ( secondo quanta se ne ha gia')
//					if (Fama < 96) Fama++;
//				} else {
//					current_testa=4; // Carbonizzato...
//					if (Fama > 8) Fama-=8;
//					if (Reputazione > 5) Reputazione-=5;
//					MessageBox( hDlg, "L' eccessiva esposizione del tuo corpo ai raggi ultravioletti,\
// provoca un avanzato grado di carbonizzazione e pure qualche piccola mutazione genetica...", "Lampada", MB_OK  | MB_ICONSTOP);
//				}
//				TabbozRedraw = 1;	// E' necessario ridisegnare l' immagine del Tabbozzo...
//
//				if (sound_active) TabbozPlaySound(202);
//				Soldi-=PalestraMem[3].prezzo;
//				#ifdef TABBOZ_DEBUG
//				sprintf(tmp,"lampada: Paga %s",MostraSoldi(PalestraMem[3].prezzo));
//				writelog(tmp);
//				#endif
//			}
//			i=random(5 + Fortuna);
//			if (i==0) Evento(hDlg);
//			AggiornaPalestra(hDlg);
//			return(TRUE);
//
//		 case 115:	// Abbonamenti
//		 case 116:
//		 case 117:
//		if (scad_pal_giorno > 0 ) {
//				  MessageBox( hDlg,
//					"Hai gia' un abbonamento, perche' te ne serve un altro ???",
//					"Palestra", MB_OK | MB_ICONINFORMATION);
//				  return(TRUE);
//			}
//
//		if (PalestraMem[wParam-115].prezzo > Soldi) {
//			nomoney(hDlg,PALESTRA);
//			return(TRUE);
//		} else {
//			Soldi-= PalestraMem[wParam-115].prezzo;
//			#ifdef TABBOZ_DEBUG
//			sprintf(tmp,"palestra: Paga %s",MostraSoldi(PalestraMem[wParam-115].prezzo));
//			writelog(tmp);
//			#endif
//		}
//
//		switch (wParam)
//		{
//		case 115: scad_pal_mese = x_mese + 1;      // UN MESE
//			  scad_pal_giorno = x_giorno;
//			  if (scad_pal_mese > 12) scad_pal_mese-=12;
//			  // Quello che segue evita che la palestra scada un giorno tipo il 31 Febbraio
//			  if (scad_pal_giorno > InfoMese[scad_pal_mese-1].num_giorni) scad_pal_giorno = InfoMese[scad_pal_mese-1].num_giorni;
//			break;;
//
//		case 116: scad_pal_mese = x_mese + 6;      // SEI MESI
//			  scad_pal_giorno = x_giorno;
//			  if (scad_pal_mese > 12) scad_pal_mese-=12;
//			  // Quello che segue evita che la palestra scada un giorno tipo il 31 Febbraio
//			  if (scad_pal_giorno > InfoMese[scad_pal_mese-1].num_giorni) scad_pal_giorno = InfoMese[scad_pal_mese-1].num_giorni;
//			break;;
//
//		case 117: scad_pal_mese = x_mese;          // UN ANNO ( meno un giorno...)
//			  scad_pal_giorno = x_giorno - 1;
//			  if ( scad_pal_giorno < 1) {
//				scad_pal_mese--;
//				if ( scad_pal_mese < 1) scad_pal_mese+=12;
//				scad_pal_giorno=InfoMese[scad_pal_mese-1].num_giorni;
//			  }
//			break;;
//		}
//
//		Evento(hDlg);
//		AggiornaPalestra(hDlg);
//		return(TRUE);
//
//
//		 case IDCANCEL:
//		EndDialog(hDlg, TRUE);
//		return(TRUE);
//
//		 case IDOK:
//		EndDialog(hDlg, TRUE);
//		return(TRUE);
//
//		 default:
//		return(TRUE);
//	}
//	 }
//
//	 return(FALSE);
//}
//
//
//
//void RunTabacchi(HWND hDlg)
//{
//	 FARPROC       lpproc;
//
//	 if ( x_vacanza != 2 ) { // 19 Mar 98 - Tabaccaio
//			lpproc = MakeProcInstance(Tabaccaio, hInst);
//			DialogBox(hInst,
//				MAKEINTRESOURCE(TABACCAIO),
//				hDlg,
//				lpproc);
//			FreeProcInstance(lpproc);
//	 } else {
//	MessageBox( hDlg,
//	  "Rimani fisso a guardare la saracinesca del tabaccaio inrimediabilmente chiusa...",
//				"Bar Tabacchi", MB_OK | MB_ICONINFORMATION);
//	 }
//}
//
//void RunPalestra(HWND hDlg)
//{
//	 FARPROC       lpproc;
//
//	 if ( x_vacanza != 2 ) { // 20 Mar 98 - Palestra
//	lpproc = MakeProcInstance(Palestra, hInst);
//	DialogBox(hInst,
//			MAKEINTRESOURCE(PALESTRA),
//			hDlg,
//			lpproc);
//	FreeProcInstance(lpproc);
//	 } else {
//	MessageBox( hDlg,
//	  "Il tuo fisico da atleta dovra' aspettare... visto che oggi la palestra e' chiusa...",
//				"Palestra", MB_OK | MB_ICONINFORMATION);
//	 }
//}
//
//void RunVestiti(HWND hDlg,int numero)
//{
//	FARPROC       lpproc;
//	char			  tmp[128];
//
//	// Versione femminile di "Bau House" e "Blue Rider"
//	if ((numero == 80) && (sesso == 'F')) numero=85;
//	if ((numero == 84) && (sesso == 'F')) numero=86;
//
//	if ( x_vacanza != 2 ) { // 26 Feb 98... finalmente i negozi sono chiusi durante le vacanze...
//	if (sound_active) {
//		if (numero < 82)
//		  TabbozPlaySound(204);
//		else
//		  TabbozPlaySound(205);
//	}
//
//	lpproc = MakeProcInstance(CompraQualcosa, hInst); // La funzione e' uguale x tutti...
//	DialogBox(hInst,
//		 MAKEINTRESOURCE(numero),
//		 hDlg, lpproc);
//	FreeProcInstance(lpproc);
//	} else {
//			sprintf(tmp,"Oh, tip%c... i negozi sono chiusi di festa...",ao);
//			MessageBox( hDlg, tmp,
//				"Vestiti", MB_OK | MB_ICONINFORMATION);
//	}
//}
//
//
//
//********************************************************************/
//* EVENTI PALESTRA - 14 Luglio 1998                                 */
//********************************************************************/
//
//void EventiPalestra(HANDLE hInstance)
//{
//int i;
//char messaggio[128];
//
//	i=random(29 + (Fortuna / 2));
//
//	if (i > 9) return;	/* eventi: 0 - 10) */
//
//	LoadString(hInst, (1100 + i), (LPSTR)messaggio, 255);
//
//	MessageBox( hInstance,
//	(LPSTR)messaggio,
//		"Palestra...", MB_OK | MB_ICONSTOP);
//
//	if (Reputazione > 10)
//		Reputazione-=4;
//
//
//#ifdef TABBOZ_DEBUG
//	writelog("eventi: Evento riguardante la palestra");
//#endif
//
//}
