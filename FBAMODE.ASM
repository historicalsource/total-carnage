**************************************************************************
*                                                                        *
*  VIDEO GAME PROJECT:     HIGH IMPACT FOOTBALL                          *
*                                                                        *
*  PROGRAMMER:             EDWARD J. BOON                                *
*  ARTIST:                 JOHN R. NEWCOMER                              *
*  SOUNDS:                                                               *
*                                                                        *
*  MODULE: FBAMODE.ASM --  ATTRACT MODE                                  *
*                                                                        *
*  COPYRIGHT (C) 1989 WILLIAMS ELECTRONICS GAMES, INC.                   *
*                                                                        *
**************************************************************************

	.FILE	'FBAMODE.ASM'
	.TITLE	" <<< FOOTBALL ATTRACT MODE CODE >>> "

	.WIDTH	132
	.OPTION	B,D,L
	.MNOLIST
*
* GET THE SYSTEM STUFF
*
	.INCLUDE	"MPROCEQU.ASM"	;MPROC equates
	.INCLUDE	"DISPEQU.ASM"	;Display processor equates
         .INCLUDE        "SYSEQU.ASM"      ;SYS.INC and GSP.INC
	.INCLUDE	"MACROS.HDR"	     ;Macros
	.INCLUDE	"MAINEQU.ASM"
	.INCLUDE	"IMGTBL.GLO"
         .INCLUDE        FIELDEQU.ASM
         .INCLUDE        "STRING.H"
         .INCLUDE        DIAGAUDN.ASM

         .REF    PRINT_DMA,PRINT_DMA_XY,BACKGROUND
         .REF    PRINT_OBJ,SHADOW_PRINT,AUTOSCR
         .REF    WIPEOUT,COIN_PAGE,CRED_P,PLAYTABS
         .REF    LM_SETUP,PRINTF,CHANGE_OID,GET_CSTR
         .REF    SETUP_OFFENSE,SETUP_DEFENSE,SETWORLD,BALL_IN_PLAY
         .REF    START_PLAYERS,COLSCAN,PLAY_INIT
         .REF    GET_LOGO,MIDDLE_OPEN,NOSOUNDS,POST_PLAY 		;CAT_DUMP
         .REF    XFER_ALL_TO_A7

***************************** (SELF PLAY CODE)
         .REF    AMODE_START
***************************** (SELF PLAY CODE)

         .DEF    AMODE

	.EVEN
	.TEXT

**************************************************************************
*                                                                        *
*                     ATTRACT MODE ENTRY POINT                           *
*                                                                        *
**************************************************************************
AMODE
         CLR     A0
         MOVE    A0,@P1STAT,W
         MOVE    A0,@P2STAT,W
         MOVE    A0,@P3STAT,W
         MOVE    A0,@P4STAT,W

         MOVI    GS_AMODE,A0
         MOVE    A0,@GSTATE,W         ; GAME STATE = ATTRACT MODE

	CALLA	WIPEOUT
         MOVI    RGB_BLACK,A0
	MOVE	A0,@IRQSKYE,W   	; SET BACKGROUND COLOR

**************************** (SELF PLAY CODE)
         JRUC    AM0
         SLEEP   >80
         MOVK    1,A0
         MOVE    A0,@AUTOPLAY,W
         JAUC    AMODE_START
***************************** (SELF PLAY CODE)

AM0      MOVK    5,A0
         MOVE    A0,*A13(P_GCOUNT),W       ; # OF LOOPS TILL NO SOUNDS
AM1      CALLA 	CLR_SCRN
         JSRP    FIELD_TOUR
         CALLA   GANGEL
         CALLA   WIPEOUT

         JSRP    RUN_A_PLAY
         CALLA   GANGEL
	CALLA	WIPEOUT

	JSRP	COIN_PAGE
         CALLA   GANGEL
	CALLA	WIPEOUT

         MOVE    *A13(P_GCOUNT),A0,W
         JREQ    AM1
         DEC     A0
         MOVE    A0,*A13(P_GCOUNT),W
         JRNE    AM1
         MOVK    1,A0
         MOVE    A0,@NOSOUND,W        ; NO MORE SOUNDS PLEASE.
         JRUC    AM1

**************************************************************************
*                                                                        *
*  RUN A PLAY                                                            *
*                                                                        *
*  Runs a random play during the attract mode.                           *
*                                                                        *
**************************************************************************
RUN_A_PLAY
         MOVE    @NOSOUND,A1,W             ; ARE WE ALLOWED ??
         JRNE    RUNP0
         MOVI    >C7,A3
         CALLA   SEND_CODE_A3              ; PLAY TUNE IF LEGAL

RUNP0    CLR     A0
         MOVE    A0,@SCRNTL,L
         MOVE    A0,@SCRNLR,L

         MOVK    15,A0
         CALLA   RANDU
         DEC     A0
         MOVE    A0,@T0TEAM,W
         MOVE    A0,A1

RUNP1    MOVK    15,A0
         CALLA   RANDU
         DEC     A0
         CMP     A0,A1
         JREQ    RUNP1                ; DONT PICK SAME TEAM
         MOVE    A0,@T1TEAM,W

         MOVI    FIFTY_YARD,A0
         MOVE    A0,@LINEOFSC,W       ; SET LINE OF SCRIMMAGE
         MOVE    A0,@STLOS,W

         MOVE    @OFFENSE,A0,W
         XORI    1,A0
         MOVE    A0,@OFFENSE,W        ; FLIP OFFENSE !!

         MOVK    4,A0
         CALLA   RANDU
         MOVE    A0,@DOWNNUM,W        ; RANDOM DOWN #

         MOVK    4,A0
         CALLA   RANDU
         DEC     A0
         MOVE    A0,@MENUPIK0,W
         MOVE    A0,@MENUPIK1,W       ; RANDOM PLAY CHOICE

         CALLA   PLAY_INIT
         CALLA   PLAYTABS             ; SETUP OFFPTBL/DEFPTBL
         CALLA   SETWORLD
         CREATE  PID_AMODE,MIDDLE_OPEN
         SLEEP   1

         CREATE  PID_AMODE,T0_SLIDE
         CREATE  PID_AMODE,T1_SLIDE

         MOVI    AMODE_VERSUS_INIT,A14
         CALLA   INITOBJ
         MOVE    A8,A0
         CALLA   INSOBJ2
         SLEEP   2
         MOVK    10,A11
         CREATE  PID_AMODE,RGBSTUFF   ; FLASH "VERSUS"

         SLEEP   >C0                  ; WAIT FOR LINEUP
         MOVI    OID_AMODE,A0
         CALLA   DALLOBJ              ; GET RID OF LOGOS/VERSUS

         CALLA   START_PLAYERS        ; XFER DUDES PROCESSES
         MOVI    OID_QB,A0
         CALLA   FINDOMAN             ; FIND THE QB
         CALLA   BALL_IN_PLAY         ; PUT THE BALL IN PLAY
         CREATE  PID_COLSCAN,COLSCAN  ; COLLISION SCANNER
         CREATE  PID_BCTRACK,BC_TRACK ; BALL CARRIER
         CLR     A0
         MOVE    A0,@PLAYRES,W        ; NO PLAY RESULT SO FAR
         MOVI    OID_MSGLET,A0
         CALLA   DALLOBJ              ; ERASE LETTERS
         MOVI    PID_QB_YELL,A0
         CALLA   DALLPRC              ; QB = SHUT UP
*
* WAIT FOR ATTRACT MODE PLAY TO END
*
         MOVI    13*20,A10            ; WATCH "CAT" TIME LIMIT
RUNP5    SLEEP   5
         MOVE    @PLAYRES,A0,W
         JRNE    RUNP7
         DSJS    A10,RUNP5            ; I'LL WAIT, BUT NOT FOREVER
         CLR     A0
         MOVE    A0,@ERRNUM,W         ; DONT CONFUSE WITH BOONTRAP
         MOVI    AUDWCATS,A0
         CALLA   AUD1                 ; AUDIT THIS !!
        .IF B_DEBUG
         JAUC    $                    ; IN DEBUGGER ---> CALL ATTENTION TO !
        .ENDIF
        .IF     PRINTER
;         CALLA  CAT_DUMP
        .ENDIF

RUNP7    
         MOVI    PID_COLSCAN,A0
         CALLA   DALLPRC
         MOVI    PID_SCR,A0
         CALLA   DALLPRC              ; KILL SCROLLER
         CLR     A1
         MOVE    A1,@SCROLLX,L
         MOVE    A1,@SCROLLY,L
         MOVI    POST_PLAY,A7         ; A7 = EVERYONE XFERED HERE
         CALLA   XFER_ALL_TO_A7

         SLEEP   >20
         MOVI    >8000,A0
         MOVE    A0,A1
         CALLA   KILALL               ; KILL ALL PROCS (EXCEPT INDESTUCTABLES)

         MOVI    FADEALL,A0
         CALLA   FADEOUT              ; FADE EVERYTHING TO BLACK
         SLEEP   >30
         CALLA   NOSOUNDS             ; SHUT UP
         RETP


FADEALL  .LONG   0

T0_SLIDE
         MOVI    AMODEL0_INIT,A14
         CALLA   INITOBJ
         MOVE    @T0TEAM,A1,W
         CALLA   GET_LOGO
         MOVE    *A1(16*6),A0,L
         CALLA   GETFPAL
         MOVE    A0,*A8(OPAL),W       ; TEAMS PALETTE
         CALLA   ANI
         MOVE    A8,A0
         CALLA   INSOBJ2
         MOVI    >30000,A0
         MOVE    A0,*A8(OXVEL),L
         SLEEP   >3C
         CLR     A0
         MOVE    A0,*A8(OXVEL),L
         DIE

T1_SLIDE
         MOVI    AMODEL1_INIT,A14
         CALLA   INITOBJ
         MOVE    @T1TEAM,A1,W
         CALLA   GET_LOGO
         MOVE    *A1(16*6),A0,L
         CALLA   GETFPAL
         MOVE    A0,*A8(OPAL),W       ; TEAMS PALETTE
         CALLA   ANI
         MOVE    A8,A0
         CALLA   INSOBJ2

         MOVI    ->30000,A0
         MOVE    A0,*A8(OXVEL),L
         SLEEP   >3D
         CLR     A0
         MOVE    A0,*A8(OXVEL),L
         DIE


AMODEL0_INIT
         .LONG   LA,0
         .WORD   0,DMAWNZ|M_NOSCROLL,OID_AMODE
         .WORD   -120,26,0

AMODEL1_INIT
         .LONG   LA,0
         .WORD   0,DMAWNZ|M_NOSCROLL,OID_AMODE
         .WORD   SCRRGT,26,0

AMODE_VERSUS_INIT
         .LONG   VERSUS,ICN3_PAL
         .WORD   0,DMAWNZ|M_NOSCROLL,OID_AMODE
         .WORD   >BB
         .WORD   32
         .WORD   0

**************************************************************************
*                                                                        *
*  SHOW TEAMS                                                            *
*                                                                        *
*  Will put all of the teams on the screen along with the field in the   *
*  background.                                                           *
*                                                                        *
**************************************************************************
;SHOW_TEAMS
;         MOVI    AMODE_TEXT_INIT,A14
;         MOVI    >29,A0
;         CALLA   PRINT_OBJ                 ; TEXT = A4 --> A7
;
;         MOVE    A4,A5
;         MOVI    AMODE_TEXT_INIT,A14
;         MOVI    00020002H,A6
;         CALLA   SHADOW_PRINT
;         MOVE    @OBJLST3,A0,L
;         MOVE    A0,*A7(OLINK),L      ; LAST CHAR ----> OBJLST3
;         MOVE    A5,@OBJLST3,L        ; OBJLST3 ---> 1ST CHAR
;         MOVK    3,A11
;         CREATE  PID_AMODE,RGBSTUFF
;*
;* BACKGROUND THING A MA BOB
;*
;         MOVK    4,A0
;         CALLA   GETBLIMP             ; TEAM SELECT MODULE
;         CALLA   A5A6OL1              ; ADD TO "OBJLST1"
;
;         MOVI    9,A9
;         MOVI    60,A10
;         MOVI    ATEAM_LOGOS,A11
;SHOWT0   MOVK    5,A7                 ; 5 ROWS
;SHOWT1   MOVI    LOGO_INIT,A14
;         CALLA   INITOBJ              ; GET AN OBJECT
;         MOVE    *A11+,A1,L           ; A1 = OIMG
;         CALLA   ANI
;         MOVE    *A11+,A0,L
;         CALLA   SWPAL
;         MOVE    A8,A0
;         
;         MOVE    A9,*A8(OXPOS),W
;         MOVE    A10,*A8(OYPOS),W
;         CALLA   INSOBJ
;         ADDI    35,A10
;         DSJS    A7,SHOWT1
;         SLEEP   2
;         MOVI    60,A10
;         ADDI    >80,A9
;         CMPI    (>60*3)+5,A9
;         JRLT    SHOWT0
;
;         SLEEP   >40*8
;         JRUC    AMODE_EXIT
;
;
;
AMODE_TEXT_INIT
         .LONG   FON15A,boonpal
         .WORD   0,DMACNZ|M_NOSCROLL,OID_AMODE
         .WORD   0,0,0
;
;
;ATEAM_LOGOS
;         .LONG   LA,LA_PAL
;         .LONG   DENVER,DNVR_PAL
;         .LONG   SANFRN,SANF_PAL
;         .LONG   MIAMI,MIAM_PAL
;         .LONG   WASH,WASH_PAL
;         .LONG   CHICAGO,CHGO_PAL
;         .LONG   TEXAS,TEX_PAL
;         .LONG   PITTSBURGH,PITT_PAL
;         .LONG   DETROIT,DETR_PAL
;         .LONG   NEWYRK,NYC_PAL
;         .LONG   AFRICA,AFRC_PAL
;         .LONG   CANADA,CANA_PAL
;         .LONG   EUROPA,EURO_PAL
;         .LONG   KANSAS,KANS_PAL
;         .LONG   ATLANTA,ATLN_PAL
;
;
;LOGO_INIT
;         .LONG   LA,boonpal
;         .WORD   0,DMAWNZ|M_NOSCROLL,OID_AMODE
;         .WORD   0,0,0
;
;LA_INIT
;         .LONG   LA,LA_PAL
;         .WORD   0,DMAWNZ|M_NOSCROLL,OID_AMODE
;         .WORD   >40,>30,0
;
;DENVER_INIT
;         .LONG   DENVER,DNVR_PAL
;         .WORD   0,DMAWNZ|M_NOSCROLL,OID_AMODE
;         .WORD   >40,>58,0
;
;SF_INIT
;         .LONG   SANFRN,SANF_PAL
;         .WORD   0,DMAWNZ|M_NOSCROLL,OID_AMODE
;         .WORD   >40,>80,0
;
;MIAMI_INIT
;         .LONG   MIAMI,MIAM_PAL
;         .WORD   0,DMAWNZ|M_NOSCROLL,OID_AMODE
;         .WORD   >40,>A8,0
;
;WASH_INIT
;         .LONG   WASH,WASH_PAL
;         .WORD   0,DMAWNZ|M_NOSCROLL,OID_AMODE
;         .WORD   >40,>D0,0
;
;*
;* COLUMN #2
;*
;CHICAGO_INIT
;         .LONG   CHICAGO,CHGO_PAL
;         .WORD   0,DMAWNZ|M_NOSCROLL,OID_AMODE
;         .WORD   >C0,>30,0
;
;DALLAS_INIT
;         .LONG   TEXAS,TEX_PAL
;         .WORD   0,DMAWNZ|M_NOSCROLL,OID_AMODE
;         .WORD   >C0,>58,0
;
;PITT_INIT
;         .LONG   PITTSBURGH,PITT_PAL
;         .WORD   0,DMAWNZ|M_NOSCROLL,OID_AMODE
;         .WORD   >C0,>80,0
;
;DETROIT_INIT
;         .LONG   DETROIT,DETR_PAL
;         .WORD   0,DMAWNZ|M_NOSCROLL,OID_AMODE
;         .WORD   >C0,>A8,0
;
;NY_INIT
;         .LONG   NEWYRK,NYC_PAL
;         .WORD   0,DMAWNZ|M_NOSCROLL,OID_AMODE
;         .WORD   >C0,>D0,0
;
**************************************************************************
*                                                                        *
*  FIELD TOUR                                                            *
*                                                                        *
*  This part of the attract mode scans the entire field with the game    *
*  logo overlaying the screen.                                           *
*                                                                        *
**************************************************************************
FIELD_TOUR
         CREATE  PID_AMODE,BACKGROUND      ; MAKE A BACKGROUND UPDATE DUDE
         JSRP    SHOW_CREDITS

         CLR     A0
         MOVI    AMODE_TEXT_INIT,A14
         CALLA   PRINT_OBJ                 ; COPYRIGHT MESSAGE
         MOVE    A4,A5
         MOVE    A7,A6
         CALLA   A5A6OL1

         MOVK    2,A0
         CALLA   GETBLIMP                  ; A5 = LOGO MODULE OBJECT LIST
         CALLA   A5A6OL2                   ; PUT ON OBJECT LIST #1
         MOVK    4,A11
         CREATE  PID_AMODE,RGBSTUFF        ; FLASH "CREDITS"

         MOVK    2,A9
FTOUR1   MOVI    LGOAL_OUT_X-80,A0
         MOVE    A0,@WORLDTLX+16,W         ; STARTING X
         MOVI    TOP_SIDELINE-215,A0
         MOVE    A0,@WORLDTLY+16,W         ; STARTING Y
*
* PAN THROUGH THE CROWD
*
         MOVI    RGOAL_OUT_X+80-SCRRGT,A1
         MOVE    @WORLDTLY+16,A3
         MOVK    2,A4
         JSRP    AUTOSCR                   ; SCROLLER DUDE
*
* TO MIDDLE OF FIELD
*
         MOVE    @WORLDTLX+16,A1
         SUBI    >100,A1
         MOVE    @WORLDTLY+16,A3
         ADDI    >100,A3
         MOVK    2,A4
         JSRP    AUTOSCR                   ; SCROLLER DUDE
*
* TO LEFT ENDZONE
*
         MOVI    LGOAL_OUT_X->50,A1
         MOVE    @WORLDTLY+16,A3
         MOVK    2,A4
         JSRP    AUTOSCR                   ; SCROLLER DUDE
         SLEEP   >80

AMODE_EXIT
         MOVI    OID_AMODE,A0
         MOVE    A0,A1
         CALLA   KILL_OCP
         CALLA   DELALLB
         MOVI    PID_AMODE,A0
         MOVE    A0,A1
         CALLA   KILALL                    ; KILL ANYONE I SPAWNED OFF
         RETP

*
* DELETE ALL BACKGROUND OBJECTS (AND THEIR PALETTES)
*
DELALLB
         MOVE    @BAKLST,A0,L              ; ARE THERE ANY BACKGROUND OBJ ?
         JREQ    PS2                       ; NO ---> SKIP

         MOVE    A0,A1                     ; A1 = OBJECT #1
         CLR	A0
	MOVE	A0,@BAKLST,L

PS1      MOVE    *A1,A3,L                  ; A3 = NEXT IN LINE
         MOVE    *A1(OPAL),A0,W
         CALLA   FREEPAL                   ; DECREMENT PALETTE COUNTER
         MOVE    @OFREE,A2,L
         MOVE    A1,@OFREE,L               ; PUT OBJECT ON FREE LIST
         MOVE    A2,*A1,L
         MOVE    A3,A1
         JRNE    PS1
PS2      RETS

*
* STARS ALONG THE EDGES
*
         CLR     A5                   ; INITIALIZE COLOR POINTER
         DEC     A5

         MOVI    >10,A2               ; STARTING X POSITION
         MOVI    >15,A3               ; STARTING Y POSITION

         MOVI    13,A6                ; STAR COUNT
AM2      CALLR   DO_A_STAR
         ADDI    >25,A2
         DEC     A6
         JRNE    AM2
         SUBI    >25,A2

         MOVI    10,A6                ; STAR COUNT
AM3      ADDI    >22,A3
         CALLR   DO_A_STAR
         DEC     A6
         JRNE    AM3

         MOVI    12,A6                ; STAR COUNT
AM4      SUBI    >25,A2
         CALLR   DO_A_STAR
         DEC     A6
         JRNE    AM4
         
         MOVI    9,A6                ; STAR COUNT
AM5      SUBI    >22,A3
         CALLR   DO_A_STAR
         DEC     A6
         JRNE    AM5

         MOVI    boonpal,a10          ; PALETTE TO CYCLE
         MOVI    >01040900,A11        ; PARAMETERS FOR CYCLE DUDE
         CREATE  PID_AMODE,CYCLERF
         CREATE  PID_AMODE,TWINKLE
         SLEEP   >40*15

         CLR     A1
         NOT     A1
         MOVI    PID_AMODE,A0
         CALLA   KILALL               ; KILL AMODE PROCS

	CALLA	MYOINIT		     ; BLOW OUT OBJECT SYSTEM
	CALLA	SCRCLR

;         JSRP    HSTD
;         MOVK	1,A0
;  	 MOVE	A0,@GAMERASE,W            ; GAME ERASE = ON
;         SLEEP   >20

         CALLR   GAME_ERASE_OFF
         JSRP    LITTLE_FADE
         CALLR   GAME_ERASE_ON
         SLEEP   2
         CALLR   GAME_ERASE_OFF
         JSRP    NO_DRUGS                  ; SAY NO TO DRUGS MESSAGE
         JRUC    AMODE


GAME_ERASE_OFF
         CLR     A0
         JRUC    GERASE
GAME_ERASE_ON
	MOVK	1,A0
GERASE   MOVE	A0,@GAMERASE,W
         RETS



;WIL_FADE
;         MOVI    WILLINIT,A14         
;         CALLA   INITINS         
;         SLEEP   >60
;         MOVE    A8,A9
;         MOVI    >00010002,A11
;         MOVI    willypal,a8
;         CREATE  PID_AMODE,PALFADE
;         SLEEP   >60
;         MOVE    A9,A0
;         CALLA   DELOBJP
;         MOVI    willypal,a0
;         CALLA   BLOWPAL              ; BLOW OUT PALETTE COMPLETELY
;         SLEEP   1
;         RETP
;WILLINIT 
;         .LONG   willy1,willypal
;         .WORD   0,DMAWNZ,>555,>55,>60,0



BALL_BANG
         MOVI    1,A0
         MOVE    A0,@NO_VEL,W              ; NO VELOCITIES !!

         MOVI    40,B0
BANG_LOOP
         PUSH    B0
         MOVI    BALL_INIT,A14
         CALLA   INITOBJ
         MOVE    A8,B1
         MOVI    BALL_INIT,A14
         CALLA   INITOBJ
         MOVE    A8,B2
         MOVI    BALL_INIT,A14
         CALLA   INITOBJ
         MOVE    A8,B3
         MOVI    BALL_INIT,A14
         CALLA   INITOBJ
         MOVE    A8,B4

         CALLA   RANDOM                    ; GET A RANDOM # IN A0
         ANDI    >00070000,A0              ; KEEP IT WITHIN REASON
         ADDI    >00010000,A0
         MOVE    A0,B0         
         MOVE    B0,*B1(OYVEL),L           ; RANDOM Y VELOCITY
         CALLA   RANDOM                    ; GET A RANDOM # IN A0
         ANDI    >00070000,A0              ; KEEP IT WITHIN REASON
         ADDI    >00010000,A0
         MOVE    A0,B0         
         MOVE    B0,*B2(OYVEL),L           ; RANDOM Y VELOCITY

         CALLA   RANDOM                    ; GET A RANDOM # IN A0
         ANDI    >00070000,A0              ; KEEP IT WITHIN REASON
         ADDI    >00010000,A0
         MOVE    A0,B0         
         NEG     B0
         MOVE    B0,*B3(OYVEL),L           ; RANDOM Y VELOCITY
         CALLA   RANDOM                    ; GET A RANDOM # IN A0
         ADDI    >00010000,A0
         ANDI    >00070000,A0              ; KEEP IT WITHIN REASON
         MOVE    A0,B0         
         NEG     B0
         MOVE    B0,*B4(OYVEL),L           ; RANDOM Y VELOCITY
         
         CALLA   RANDOM                    ; GET A RANDOM # IN A0
         ANDI    >00070000,A0              ; KEEP IT WITHIN REASON
         ADDI    >00010000,A0
         MOVE    A0,B0
         MOVE    B0,*B1(OXVEL),L
         CALLA   RANDOM                    ; GET A RANDOM # IN A0
         ANDI    >00070000,A0              ; KEEP IT WITHIN REASON
         ADDI    >00010000,A0
         MOVE    A0,B0
         MOVE    B0,*B3(OXVEL),L

         CALLA   RANDOM                    ; GET A RANDOM # IN A0
         ANDI    >00070000,A0              ; KEEP IT WITHIN REASON
         ADDI    >00010000,A0
         MOVE    A0,B0
         NEG     B0
         MOVE    B0,*B2(OXVEL),L
         CALLA   RANDOM                    ; GET A RANDOM # IN A0
         ANDI    >00070000,A0              ; KEEP IT WITHIN REASON
         ADDI    >00010000,A0
         MOVE    A0,B0
         NEG     B0
         MOVE    B0,*B4(OXVEL),L

*
* PUT EM ON THE LIST
*
         MOVE    B1,A0
         CALLA   INSOBJ
         MOVE    B2,A0
         CALLA   INSOBJ
         MOVE    B3,A0
         CALLA   INSOBJ
         MOVE    B4,A0
         CALLA   INSOBJ

         PULL    B0
         DEC     B0
         JRNE    BANG_LOOP

         CLR     A0
         MOVE    A0,@NO_VEL,W              ; VELOCITIES !!
         SLEEP   >50

         CLR     A1
         NOT     A1
         MOVI    OID_BALL,A0
         CALLA   KILL_OCP

         RETP


*
* HIGH SCORE TO DATE TABLE
*
HSTD     MOVI    HSTD_TEXT,A14
;         CALLA   P RINT7_INFO
;         CALLA   P RINT7_INFO
;         CALLA   P RINT7_INFO
;         CALLA   P RINT7_INFO
;         CALLA   P RINT7_INFO
;         SLEEP   >40*4
         RETP


HSTD_TEXT
         .LONG   >00600070
         .WORD   >FFFF
         .STRING "1) BUN        $ 4,000,000",0

         .LONG   >00800070
         .WORD   >FFFF
         .STRING "2) JRN        $ 3,500,000",0

         .LONG   >00A00070
         .WORD   >FFFF
         .STRING "3) BUN        $ 3,000,000",0

         .LONG   >00C00070
         .WORD   >FFFF
         .STRING "4) JRN        $ 2,500,000",0

         .LONG   >00E00070
         .WORD   >FFFF
         .STRING "5) KIM        $ 2,000,000",0

         .EVEN


*
* SAY NO TO DRUGS MESSAGE
*
NO_DRUGS
         MOVI    >0D,A0
         CALLA   PRINT_DMA
         MOVI    >0E,A0
         CALLA   PRINT_DMA
         
;         MOVI    BOONDCD,A0
;         CALLA   GETFPAL                   ; GET BOONDCD PALLETTE
;         JRNE    NODR1
;         ERMAC   24

;NODR1    MOVE    A0,A1                     ; A1 = DTIME INPUT = PALLETTE         
;         MOVI    [>70,>D0],A3
;         MOVI    DMAWNZ,A5
;         MOVI    BOONDCD_vda,A14
;         CALLA   DTIME                     ; DMA BOON PICTURE

         SLEEP   >40*3
         RETP

LITTLE_FADE
         MOVI    >0F,A0
         MOVI    >00700070,A3              ; A3 = [Y,X]
         CALLA   PRINT_DMA_XY

         MOVI    >0F,A0
         MOVI    >00900070,A3              ; A3 = [Y,X]
         CALLA   PRINT_DMA_XY

         MOVI    >0F,A0
         MOVI    >00B00070,A3              ; A3 = [Y,X]
         CALLA   PRINT_DMA_XY

         MOVI    >0F,A0
         MOVI    >00D00070,A3              ; A3 = [Y,X]
         CALLA   PRINT_DMA_XY

         MOVI    >0F,A0
         MOVI    >00F00070,A3              ; A3 = [Y,X]
         CALLA   PRINT_DMA_XY
         SLEEP   >60
         RETP


SET_EM_UP
         CALLA   INITOBJ              ; A8 = NFL LOGO OBJECT
         MOVE    A8,A0         
         JAUC    INSOBJ

DO_A_STAR
         RETS                         

         INC     A5
         CMPI    4,A5
         JRLO    DOST1
         CLR     A5                   ; FROM (0-3)
DOST1    MOVE    A5,A0
         SLL     4,A0                 ; 16 BIT OFFSET         
         ADDI    STAR_COLORS,A0
         MOVE    *A0,A0,W             ; GET THE COLOR FOR THIS STAR
         MOVE    A0,*A8(OCONST),W     ; THIS IS THE STARS CONSTANT COLOR
         MOVE    A8,A0         
         JAUC    INSOBJ               ; PUT IN LIST
         

STAR_COLORS
         .WORD   >0101
         .WORD   >0202
         .WORD   >0303
         .WORD   >0404

*
* MAKE THE TROPHIES TWINKLE
*
TWINKLE
         CLR     A11
         JSRP    TWLOOP
         MOVI    3,A11
         JSRP    TWLOOP
         MOVI    6,A11
         JSRP    TWLOOP
         JRUC    TWINKLE

TWLOOP   CREATE  PID_AMODE,DO_TWINK
         INC     A11
         CREATE  PID_AMODE,DO_TWINK
         INC     A11
         CREATE  PID_AMODE,DO_TWINK
         SLEEP   >30
         RETP


DO_TWINK
         DIE


;TWINKINIT
;         .LONG   twink1,twinkpal
;         .WORD   0,DMAWNZ,>555,>80,>80,3


TWINK_SPOTS
         .LONG   >007D007D                 ; LEFT TROPHY'S SHOULDER
         .LONG   >009000D0                 ; LEFT TROPHY LEG
         .LONG   >0184007C                 ; RIGHT TROPHY SHOULDER
         .LONG   >01A0010D                 ; RIGHT TROPHY BASE
         .LONG   >0060010D                 ; LEFT TROPHY BASE
         .LONG   >01C000A0                 ; RIGHT TROPHY HAND

         .LONG   >009000D0                 ; LEFT TROPHY LEG
         .LONG   >01A0010D                 ; RIGHT TROPHY BASE
         .LONG   >01C000A0                 ; RIGHT TROPHY HAND
         .LONG   >007D007D                 ; LEFT TROPHY'S SHOULDER

**************************************************************************
*                                                                        *
*  SHOW CREDITS                                                          *
*                                                                        *
*  Displays # of credits in the game                                     *
*                                                                        *
**************************************************************************
SHOW_CREDITS
	MOVI	COIN_MESS3,A8
	CALLA	LM_SETUP
	CALLA	GET_CSTR		; GET THE CURRENT CREDITS
	JSRP	PRINTF               ; PRINT TO OBJECT LIST
	MOVI	OID_TEXT,A0
	MOVI	OID_AMODE,A1
	CALLA	CHANGE_OID           ; ALL TEXT = OID_AMODE
*
* ALLOCATE PALETTES FOR EACH TEXT OBJECT CREATED
*
         MOVI    boonpal,A0
         CALLA   GETFPAL              ; GET BOONPAL !!
         MOVI    BPAL_BLK,A3          ; A3 = BOONPAL "BLACK"
         CLR     A2

         MOVI    >0505,A3             ; A3 = CONSTANT COLOR TO USE
         MOVE    @OBJLST,A0,L         ; TOP O LIST
         JREQ    SHOWC2               ; NONE, EXIT
SHOWC1   INC     A2                   ; COUNT IT
         MOVE    A3,*A0(OCONST),W     ; SET COLOR O TEXT
         MOVE    *A0(OLINK),A0,L
         JRNE    SHOWC1

         MOVI    PALRAM,A1            ; TEXT USES 1ST PALETTE !!
         MOVE    *A1(32),A3,W         ; A3 = 1ST PALETTE COUNT
         DEC     A3                   ; DONT COUNT THE 1SR "GETFPAL" CALL
         ADD     A2,A3                ; ADD IN TEXT OBJECTS
         MOVE    A3,*A1(32),W
SHOWC2   RETP


COIN_MESS3
         MESS_MAC  RD15FONT,SPACING20,200,>C0,0D0D0000H,STRCNRMO,0

*********************************************************************
;CREDLET_INIT
;         .LONG   osrn1,boonpal
;         .WORD   0,DMACNZ|M_NOSCROLL,OID_AMODE
;         .WORD   0,>D0,0
;
;MED_DIGITS
;         .LONG   FON150
;         .LONG   FON151
;         .LONG   FON152
;         .LONG   FON153
;         .LONG   FON154
;         .LONG   FON155
;         .LONG   FON156
;         .LONG   FON157
;         .LONG   FON158
;         .LONG   FON159
;
;
;         CALLA   CRED_P               ; A0 = # OF CREDITS
;         CLR     A10                  ; ASSUME NO "TENS" DIGIT
;         MOVE    A0,A3
;         MOVE    A3,A6
;         CMPI    10,A3
;         JRLT    SHOWC2
;*
;* CREDITS > 10
;*
;         MOVK    10,A0
;         DIVS    A0,A3                ; A3 = 10'S DIGIT
;         MOVE    A3,A5
;         MOVI    CREDLET_INIT,A14
;         CALLA   INITOBJ              ; GET DIGIT #2 = TENS DIGIT
;         MOVE    A8,A10               ; TENS DIGIT
;         MOVI    >0101,A0
;         MOVE    A0,*A8(OCONST),W
;         SLL     5,A3
;         ADDI    MED_DIGITS,A3
;         MOVE    *A3,A1,L
;         CALLA   ANI                  ; SHAPE THE #
;         MOVI    >E6,A0
;         MOVE    A0,*A8(OXPOS),W      ; X POS = AFTER THE ":"
;         MOVE    A8,A0
;         CALLA   INSOBJ
;         CALLA   CRED_P               ; A0 = # OF CREDITS
;         MOVE    A0,A6
;         MOVK    10,A0
;         MPYS    A0,A5
;         SUB     A5,A6                ; A6 = ONES
;
;SHOWC2   MOVI    CREDLET_INIT,A14
;         CALLA   INITOBJ              ; GET DIGIT #1
;         MOVI    >0101,A0
;         MOVE    A0,*A8(OCONST),W
;
;         SLL     5,A6
;         ADDI    MED_DIGITS,A6
;         MOVE    *A6,A1,L
;         CALLA   ANI                  ; SHAPE THE NUMBER
;         MOVI    >E6,A0
;         MOVE    A10,A10              ; TENS DIGIT ?
;         JREQ    SHOWC3
;         MOVE    *A10(OSIZEX),A2,W
;         ADD     A2,A0
;         INC     A0
;SHOWC3   MOVE    A0,*A8(OXPOS),W      ; PLACE ONES AFTER "TENS"
;         MOVE    A8,A0
;         CALLA   INSOBJ
;
;         MOVI    >0F,A0
;         MOVI    CREDLET_INIT,A14
;         CALLA   PRINT_OBJ                 ; CREDITS MESSAGE !!
;         MOVE    @OBJLST,A0,L
;         MOVE    A0,*A7(OLINK),L           ; LAST CHAR ----> OBJLST
;         MOVE    A4,@OBJLST,L              ; OBJLST ---> 1ST CHAR

******************* END OF LINE (QUOTE FROM TRON) ***************

         .END
