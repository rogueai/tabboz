const VERSION = "Version 0.92q";

const copyright = "@(#) Copyright (c) 1997-2001 Andrea Bonomi, Emanuele Caccialanza, Daniele Gazzarri.\n\nAll rights reserved.\n";

const IDOK = 1;
const IDCANCEL = 2;
const IDABORT = 3;
const IDYES = 6;
const IDNO = 7;

const QX_NOME = 102;
const QX_SOLDI = 105;
const QX_LOAD = 106;
const QX_SAVE = 107;
const QX_CLOSE = 108;
const QX_ADDW = 119;
const QX_NOREDRAW = 120;
const QX_REDRAW = 121;
const QX_ABOUT = 120;
const QX_LOGO = 121;
const QX_SCOOTER = 130;
const QX_VESTITI = 131;
const QX_DISCO = 132;
const QX_TIPA = 133;
const QX_COMPAGNIA = 134;
const QX_FAMIGLIA = 135;
const QX_SCUOLA = 136;
const QX_LAVORO = 137;
const QX_INFO = 139;
const QX_CONFIG = 140;
const QX_TABACCHI = 141;
const QX_PALESTRA = 142;
const QX_VESTITI1 = 143;
const QX_VESTITI2 = 144;
const QX_VESTITI3 = 145;
const QX_VESTITI4 = 146;
const QX_VESTITI5 = 147;
const QX_PROMPT = 150;
const QX_NETWORK = 151;
const QX_CELLULAR = 155;

// DIALOG (finestre)

const MAIN = 1;
const ABOUT = 2;
const WARNING = 3;
const DISCO = 4;
const FAMIGLIA = 5;
const COMPAGNIA = 6;
const SCOOTER = 7;
const VESTITI = 8;
const TIPA = 9;
const SCUOLA = 10;
const PERSONALINFO = 11;
const LOGO = 12;
const LAVORO = 13;
const CONFIGURATION = 14;
const SPEGNIMI = 16;
const NETWORK = 17;
const PROMPT = 20;

const ACQUISTASCOOTER = 70;
const VENDISCOOTER = 71;
const RIPARASCOOTER = 72;
const TAROCCASCOOTER = 73;
const BAUHOUSE = 80;
const ZOCCOLARO = 81;
const FOOTSMOCKER = 82;
const ALTRIVESTITI4 = 83;
const ALTRIVESTITI5 = 84;
const ALTRIVESTITI6 = 85;
const TABACCAIO = 88;
const PALESTRA = 89;
const CERCATIPA = 91;
const LASCIATIPA = 92;
const ESCICONLATIPA = 93;
const DUEDIPICCHE = 95;
const CELLULAR = 120;
const COMPRACELLULAR = 121;
const VENDICELLULAR = 122;
const CELLULRABBONAM = 123;
const ATTESAMAX = 5;

const u_long: type = u32; // 28 Novembre 1998

// INFORMAZIONI SUGLI SCOOTER  (ora usato solo per cose generiche...)
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

// NUOVE INFORMAZIONI SUGLI SCOOTER - 28 Aprile 1998
pub const NEWSTSCOOTER = struct {
    speed: i32, // 01  Velocita'
    marmitta: i32, // 02  Marmitta 		( +0, +7, +12, +15)
    carburatore: i32, // 03  Carburatore  	( 0 - 4 )
    cc: i32, // 04  Cilindrata		( 0 - 4 )
    filtro: i32, // 05  Filtro dell' aria	( +0, +5, +10, +15)
    prezzo: i32, // 06  Costo dello scooter  (modifiche incluse)
    attivita: i32, // 07  Attivita' scooter
    stato: i32, // 08  Quanto e' intero (in percuntuale); -1 nessuno scooter
    nome: [:0]const u8, // 09  Nome dello scooter
    fama: i32, // 10  Figosita' scooter
};

// INFORMAZIONI SUI TELEFONINI  31 Marzo 1999
pub const STCEL = struct {
    dual: bool, // Dual Band ?
    fama: i32, // figosita'
    stato: i32, // quanto e' intero (in percuntuale)
    prezzo: i32,
    nome: [:0]const u8, // nome del telefono
};

// INFORMAZIONI SULLE COMPAGNIE DEI TELEFONINI

pub const STABB = struct {
    abbonamento: i32, // 0 = Ricarica, 1 = Abbonamento
    dualonly: i32, // Dual Band Only ?
    creditorest: i32, // Credito Restante...
    fama: i32, // figosita'
    prezzo: i32,
    nome: [:0]const u8, // nome del telefono
};

// extern   NEWSTSCOOTER ScooterData;
// extern	NEWSTSCOOTER ScooterMem[];

// extern	STSCOOTER    MaterieMem[];

// extern	STCEL			 CellularData;
// extern	STCEL 		 CellularMem[];

// extern	STABB 		 AbbonamentData;
// extern	STABB 		 AbbonamentMem[];

pub const STMESI = struct {
    nome: [:0]const u8, // nome del mese
    num_giorni: u8, // giorni del mese
};

// extern	STMESI InfoMese[];
// extern	STMESI InfoSettimana[];

pub const Time = struct {
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

// PRIMA LE VARIABILI GENERIKE...

pub const Data = struct {
    cheat: i32,
    scelta: i32,
    Andrea: [:0]const u8,
    Caccia: [:0]const u8,
    Daniele: [:0]const u8,
    Obscured: [:0]const u8,
    firsttime: i32, //29 Novembre 1998 - 0.8.1pr
    ImgSelector: i32,
    TabbozRedraw: i32, // E' necessario ridisegnare il Tabbozzo ???
    ScuolaRedraw: i32, // E' necessario ridisegnare la scuola ???
    showscooter: [:0]const u8,
    // DOPO LE CARATTERISTIKE...
    Attesa: i32, // Tempo prima che ti diano altri soldi...
    Fama: i32,
    Reputazione: i32,
    Studio: i32, // Quanto vai bene a scuola (1 - 100)
    Soldi: u_long, // Long...per forza! lo zarro ha tanti soldi...
    Paghetta: u_long, // Paghetta Settimanale...
    Nome: [:0]const u8,
    Cognome: [:0]const u8,
    Nometipa: [:0]const u8,
    FigTipa: i32,
    Rapporti: i32,
    Stato: i32,
    DDP: u_long,
    AttPaghetta: i32,
    Fortuna: i32,
    numeroditta: i32,
    impegno: i32,
    giorni_di_lavoro: i32, // Serve x calcolare lo stipendio SOLO per il primo mese...
    stipendio: i32,
    benzina: i32,
    antifurto: i32,
    sizze: i32,
    Tempo_trascorso_dal_pestaggio: i32,
    current_testa: i32, // Grado di abbronzatura del tabbozzo
    current_gibbotto: i32, // Vestiti attuali del tabbozzo...
    current_pantaloni: i32,
    current_scarpe: i32,
    current_tipa: i32,
    sound_active: bool,
    euro: bool,
    sesso: [:0]const u8, // M/F 29 Maggio 1999 --- Inizio...
    ao: [:0]const u8,
    un_una: [:0]const u8,
    n_attivita: [:0]const u8, //  7 Maggio 1998
};

// #ifdef TABBOZ_DEBUG                	// Sistema di Debug... [12 Giugno 1998]
// extern  FILE	 *debugfile;
// extern  void   writelog(char *s);	// 22 Giugno 1998
// #endif

// #ifndef NONETWORK
//extern   int	 net_enable;		   // Rete Attiva/Disattiva [24 Giugno 1998]
// extern	char	 lastneterror[255];
// extern   char   lastconnect[255];
// extern   int  	 addrLen;
// extern	HWND 	 NEThDlg;				// Punta alla procedura pricipale...
// extern   void   TabbozStartNet(HANDLE hDlg);		// 24 Giugno 1998
// #endif

// POI LE STRONZATE PER LE FINESTRELLE...

//#ifdef TABBOZ_WIN
//extern  HANDLE    hInst;
//extern  HWND      hWndMain;
//extern  HANDLE    hdlgr;
//#endif
//
//// ED I PROTOTIPI FUNZIONI...
//
//#ifdef TABBOZ_WIN
//extern  int	PASCAL 		WinMain(HANDLE hInstance, HANDLE hPrevInstance,
//					LPSTR lpszCmdLine, int cmdShow);
//extern  BOOL FAR PASCAL MainDlgBoxProc(HWND hDlg, WORD message,
//					WORD wParam, LONG lParam);
//#endif
//
//extern  void Evento(HWND hWnd);
//extern  void RunPalestra(HWND hDlg);	/* 23 Aprile 1998 */
//extern  void RunTabacchi(HWND hDlg);	/* 23 Aprile 1998 */
//extern  void RunVestiti(HWND hDlg,int numero);  /* 23 Aprile 1998 */
//
//extern  BOOL FAR PASCAL        About(HWND hDlg, WORD message, WORD wParam, LONG lParam);
//extern  BOOL FAR PASCAL        Warning(HWND hDlg, WORD message, WORD wParam, LONG lParam);
//extern  BOOL FAR PASCAL        Disco(HWND hDlg, WORD message, WORD wParam, LONG lParam);
//extern  BOOL FAR PASCAL        Famiglia(HWND hDlg, WORD message, WORD wParam, LONG lParam);
//extern  BOOL FAR PASCAL        Compagnia(HWND hDlg, WORD message, WORD wParam, LONG lParam);
//extern  BOOL FAR PASCAL        Tipa(HWND hDlg, WORD message, WORD wParam, LONG lParam);
//extern  BOOL FAR PASCAL        Lavoro(HWND hDlg, WORD message, WORD wParam, LONG lParam);
//extern  BOOL FAR PASCAL        Scuola(HWND hDlg, WORD message, WORD wParam, LONG lParam);
//extern  BOOL FAR PASCAL        Scooter(HWND hDlg, WORD message, WORD wParam, LONG lParam);
//extern  BOOL FAR PASCAL        Vestiti(HWND hDlg, WORD message, WORD wParam, LONG lParam);
//extern  BOOL FAR PASCAL        Configuration(HWND hDlg, WORD message, WORD wParam, LONG lParam);
//extern  BOOL FAR PASCAL	       PersonalInfo(HWND hDlg, WORD message, WORD wParam, LONG lParam);
//extern  BOOL FAR PASCAL        Logo(HWND hDlg, WORD message, WORD wParam, LONG lParam); 	/* 13 Marzo 1998 */
//extern  BOOL FAR PASCAL        Tabaccaio(HWND hDlg, WORD message, WORD wParam, LONG lParam); 	/* 19 Marzo 1998 */
//extern  BOOL FAR PASCAL        Palestra(HWND hDlg, WORD message, WORD wParam, LONG lParam); 	/* iniziata il 20 Marzo 1998  */
//extern  BOOL FAR PASCAL        Setup(HWND hDlg, WORD message, WORD wParam, LONG lParam); 	/* 9 Giugno 1998 */
//extern  BOOL FAR PASCAL        Spegnimi(HWND hDlg, WORD message, WORD wParam, LONG lParam); 	/* 11 Giugno 1998 */
//extern  BOOL FAR PASCAL        Network(HWND hDlg, WORD message, WORD wParam, LONG lParam); 	/* 25 Giugno 1998 */
//extern  BOOL FAR PASCAL	       MostraSalutieBaci(HWND hDlg, WORD message, WORD wParam, LONG lParam); /* 4 Gennaio 1999 */
//extern  BOOL FAR PASCAL        Cellular(HWND hDlg, WORD message, WORD wParam, LONG lParam); 	/* 31 Marzo 1999 */
//
//extern  void  TabbozAddKey(char *key,char *v);
//extern  char  *TabbozReadKey(char *key,char *buf);
//extern  void  TabbozPlaySound(int number);
//
//#ifdef PROMPT_ACTIVE
//extern  BOOL FAR PASCAL        Prompt(HWND hDlg, WORD message, WORD wParam, LONG lParam); 	/* iniziato il 15 Maggio 1998 */
//#endif
//
//
//extern  void FineProgramma(char *caller);
//extern  void CalcolaStudio(void);
//extern  char *MostraSoldi(u_long i);
//
//extern  char   *RRKey(char *xKey);		// 29 Novembre 1998
//extern  int    new_check_i(int i);		// 14 Marzo 1999
//extern  u_long new_check_l(u_long i);  // 14 Marzo 1999
//extern  void 	new_reset_check(void); 	// 14 Marzo 1999
//
//extern  void   openlog(void);
//extern  void	closelog(void);
//extern  void   nomoney(HWND parent,int tipo);
//extern  void   AggiornaPrincipale();
//extern  void	Giorno(HANDLE hInstance);
//extern  void   CalcolaStudio(void);
//extern  void   CalcolaVelocita(HANDLE hDlg);
