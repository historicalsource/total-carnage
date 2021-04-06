**************************************************************************
*                                                                        *
*  VIDEO GAME PROJECT:     FOOTBALL                                      *
*                                                                        *
*  PROGRAMMER:             EDWARD J. BOON                                *
*  ARTIST:                 JOHN R. NEWCOMER                              *
*                                                                        *
*  MODULE: FBFX.ASM  ---   SPECIAL EFFECTS                               *
*                                                                        *
*  COPYRIGHT (C) 1990 WILLIAMS ELECTRONICS GAMES, INC.                   *
*                                                                        *
**************************************************************************
         .FILE	'FBFX.ASM'
         .WIDTH	132
         .OPTION	B,D,L,T
         .MNOLIST
*
* GET THE SYSTEM STUFF
*
         .INCLUDE   MPROCEQU.ASM  ; MPROC EQUATES
         .INCLUDE   DISPEQU.ASM   ; DISPLAY PROCESSOR EQUATES
         .INCLUDE   SYSEQU.ASM
         .INCLUDE   MACROS.HDR	; MACROS
         .INCLUDE   MAINEQU.ASM
         .INCLUDE   IMGTBL.GLO
         .INCLUDE   BGNDTBL.GLO
         .INCLUDE   FIELDEQU.ASM

         .DATA
FXLEGAL1
         .INCLUDE   FBFX.TBL
         .DATA
FXLEGAL2
         .TEXT

         .GLOBAL FXLEGAL1,FXLEGAL2

         .DEF    WINTEST,TDFX1,FX_GOVER,TDFX2
         .DEF    FX_PLAYRES,EOQ_MSG,EXTRAP,KICKPREP
         .DEF    FX_BLEW4TH,FX_POSTINT,FX_WHADDA
         .DEF    FX_INTER,FX_OOB,FX_NOGOOD,FX_SAFETY,FX_TOUCHB,FX_BIGHIT
         .DEF    FX_INCOM,FX_FGY,FX_FUMBLE,TANIA_PROC,TD_TANIA,FX_FGN
         .DEF    SHOW_TURNOVER,FX_SUDDEN,FX_PAIN,FX_EPY
         .DEF    FX_SHADOW_PRINT,PRNT_1DIG
         .DEF    FX_GAME_INTRO,HALFTIME,MIDDLE_OPEN
         .DEF    KOM_PROMPT

         .REF    FIELD,BACKGROUND,BOONSND,PRINT_OBJ_XY_ID,PRINT_OBJ
         .REF    SHADOW_PRINT,DUMB_IMG,CHAN1PRI,NOSOUNDS,ROAR_WITH_CROWD
         .REF    GET_LOGO,SPLIT_A1,FONT15_NUMS,AUTOSCR,PTIMERS
         .REF    BIG_DIGITS,TEAM_LOGOS,GETCBOX,GET_CREDITS
         .REF    BOUNDS_A0,LOGO_INIT,VERSUS_INIT
         .REF    CROWD_FRAMES,STRIP_FRAMES
         .REF    CRED_P
         .REF    DO_CLOCK,BALL_ON_THE,MINIPRNT,SHOW_QUARTER

**************************************************************************
*                                                                        *
*  KOM_PROMPT                                                            *
*                                                                        *
*  Process to prompt the player to tap his ACTION button for kicking pow *
*                                                                        *
**************************************************************************
KOM_PROMPT
         SLEEP   >30
         MOVI    PBOX0_INIT,A0
         MOVI    TAPACT0_INIT,A2
         MOVI    ARR0_INIT,A3
         MOVE    @OFFENSE,A1,W
         MOVE    @OFFPLAY,A4,W
         CMPI    OF_KICKOFF,A4
         JRNE    KOMP1
         XORI    1,A1                 ; KICKOFF ---> PROMPT FOR DEFENSE
KOMP1    MOVE    A1,A1
         JREQ    KOMP2

         MOVI    PBOX1_INIT,A0
         MOVI    TAPACT1_INIT,A2
         MOVI    ARR1_INIT,A3

KOMP2    MOVE    A0,A14
         CALLR   KOMP7
         MOVE    A2,A14
         CALLR   KOMP7
         MOVE    A3,A14
         CALLR   KOMP7

         MOVK    1,A11
         CREATE  PID_PROMPT,RGBSTUFF  ; FLASH THE LETTERS

KOMP3    SLEEP   6
         MOVE    @BSTATE,A0,W         ; STATE O BALL ?
         CMPI    BS_FGKICK,A0
         JREQ    KOMP4                ; YES ----> NO NEED FOR PROMPT ANYMOE
         MOVE    @KOM_RAM,A0,W
         CMPI    METER_MIN+40,A0
         JRLO    KOMP3                ; KEEP SHOWIN
KOMP4    MOVI    OID_PROMPT,A0
         CALLA   DALLOBJ
         MOVI    PID_PROMPT,A0
         CALLA   DALLPRC
         DIE

KOMP7    CALLA   INITOBJ
         MOVE    A8,A0
         JAUC    INSOBJ2

PBOX0_INIT
         .LONG   JUSTABOX,HELPBX_P
         .WORD   0,DMAWNZ|M_NOSCROLL,OID_PROMPT
         .WORD   >35,>B0,0

TAPACT0_INIT
         .LONG   TAFP,boonpal
         .WORD   0,DMAWNZ|M_NOSCROLL,OID_PROMPT
         .WORD   >3E,>B7,1

ARR0_INIT
         .LONG   HBOX_ARROW,HELPBX_P
         .WORD   0,DMAWNZ|M_NOSCROLL,OID_PROMPT
         .WORD   >25,>BA,1

PBOX1_INIT
         .LONG   JUSTABOX,HELPBX_P
         .WORD   0,DMAWNZ|M_NOSCROLL,OID_PROMPT
         .WORD   >E5,>B0,0

TAPACT1_INIT
         .LONG   TAFP,boonpal
         .WORD   0,DMAWNZ|M_NOSCROLL,OID_PROMPT
         .WORD   >ED,>B7,1

ARR1_INIT
         .LONG   HBOX_ARROW,HELPBX_P
         .WORD   0,DMAWNZ|M_NOSCROLL|M_FLIPH,OID_PROMPT
         .WORD   >158,>BA,1

**************************************************************************
*                                                                        *
*  HALFTIME                                                              *
*                                                                        *
*  Finally, the long awaited, much anticipated HALFTIME show !!          *
*                                                                        *
**************************************************************************
HALFTIME
         MOVI    >05,A0
         CALLA   FX_SHADOW_PRINT      ; "HALFTIME"
         MOVK    4,A11
         CREATE  PID_FX,RGBSTUFF      ; FLASH THE LETTERS

         MOVI    4A0H,A9
         MOVE    A9,@WORLDTLX+16,W    ; STARTING X
         MOVI    2D0H,A10
         MOVE    A10,@WORLDTLY+16,W   ; STARTING Y
         CREATE  PID_FX,BACKGROUND    ; START A BACKGROUND UPDATER
         CREATE  PID_FX,HT_CROWD      ; BACKGROUND CROWD

         ADDI    >150,A9
         ADDI    >50,A10

         PUSH    A9
         MOVK    7,A11
HTIME3   CREATE  PID_FX,ONE_CHEER
         SUBI    >30,A9
         DSJS    A11,HTIME3
         PULL    A9
         ADDI    >90,A10              ; 2ND ROW

         MOVK    7,A11
HTIME4   CREATE  PID_FX,ONE_CHEER
         SUBI    >30,A9
         DSJS    A11,HTIME4

         CREATE  PID_FX,WINMAKER
         SLEEP   >40
         MOVK    8,A3
         CALLA   SEND_CODE_A3         ; GET DOWN SENOR FORDEN !!
         SLEEP   >280

         MOVI    MA_HT_CHEER3,A11
         MOVI    INSOBJ3,A10
         CREATE  PID_FX,MULTIANI
         SLEEP   >08

         MOVI    MA_HT_CHEER4,A11
         MOVI    INSOBJ3,A10
         CREATE  PID_FX,MULTIANI
         SLEEP   >08

         MOVI    MA_HT_LOF2,A11
         MOVI    INSOBJ3,A10
         CREATE  PID_FX,MULTIANI
         BSOUND  >23
         SLEEP   >90
         JRUC    FX_EXIT


WINMAKER
         CREATE  PID_FX,AWESOME_PROC
         MOVI    HT_WINDOWS,A8
WINM1    MOVE    *A8,A11,L
         MOVI    INSOBJ3,A10
         CREATE  PID_FX,MULTIANI
         MOVE    A0,A11
         CREATE  PID_FX,HTWINDOW_KILLER
         SLEEP   1                    ; TIME FOR LIST TO BE RUN

         MOVE    @OBJLST3,A3,L
         CLR     A0
         MOVE    A0,@OBJLST3,L
         MOVI    ->28000,A2
         MOVE    A3,A4

WINM2    MOVE    A2,*A4(OXVEL),L
         MOVE    A4,A5
         MOVE    *A4(OLINK),A4,L      ; GIVE ALL OBJECTS THE SAME VELOCITY
         JRNE    WINM2
*
* TACK ONTO LIST #2
*
         MOVE    @OBJLST2,A0,L
         MOVE    A0,*A5(OLINK),L      ; ADD TO TOP OF LIST #1
         MOVE    A3,@OBJLST2,L
         SLEEP   >45
         ADDI    32,A8
         CMPI    HT_END,A8
         JRNE    WINM1

         MOVI    HTFAN_INIT,A14
         MOVI    A_FAN1,A9
         CALLA   INITOBJ
         MOVK    5,A10
         CREATE  PID_FX,WINDOW_ANI    ; LET SOMEONE ELSE DO THE ANIMATING
         MOVE    A0,A11
         MOVI    ->28000,A2
         MOVE    A2,*A8(OXVEL),L
         MOVE    A8,A0
         CALLA   INSOBJ2
         DIE

AWESOME_PROC
         SLEEP   >13D
         BSOUND  >42                  ; SPEECH: AWESOME !!!
         DIE

HT_CROWD
         BSOUND  >23                  ; START WITH ROAR
         SLEEP   >50
         JAUC    CROWDM

HT_WINDOWS
         .LONG   MA_HT_CHEER2
         .LONG   MA_HTYEA
         .LONG   MA_LOFNUM1
         .LONG   MA_HT_CHEER1
         .LONG   MA_HTAWESOME
HT_END


HTFAN_INIT
         .LONG   FANWIN1A,FAN1PAL
         .WORD   0,DMAWNZ|M_NOSCROLL,OID_FX
         .WORD   >1E0,>51,0


HTWINDOW_KILLER
         SLEEP   10
         MOVE    *A11(P_PREY),A8,L    ; RIGHT SIDE IMAGE
         MOVE    *A8(OXPOS),A2,W
         CMPI    ->60,A2              ; ON SCREEN ?
         JRGT    HTWINDOW_KILLER      ; NO ---> WAIT

         MOVE    *A11(P_PREY),A0,L    ; RIGHT SIDE
         MOVE    *A0(OSLINK),A1,L     ; LEFT SIDE
         
         CALLA   DELOBJP2              ; DELETE RIGHT SIDE
         MOVE    A1,A0
         CALLA   DELOBJP2              ; DELETE LEFT SIDE

         MOVE    *A11(P_SWITCH),A0,L
HTKILL3  CALLA   DELOBJP2
         MOVE    *A0(OSLINK),A0,L
         JRNE    HTKILL3              ; KILL LINKED PARTS
         MOVE    A11,A0
         CALLA   KILL                 ; KILL "MULTIANI" PROC
         DIE



;         CLR     A0
;         MOVE    A0,@SCRNTL3,L
;         MOVE    A0,@SCRNLR3,L

;         SLEEP   >2A
;         MOVI    MA_HT_CHEER2,A11
;         MOVI    INSOBJ3,A10
;         CREATE  PID_FX,MULTIANI
;         MOVE    A0,A9
;         SLEEP   1
;         MOVE    *A9(P_PREY),A8,L     ; A8 = BACKDROP OBJ
;         MOVI    >00030003,A11
;         MOVI    >00250025,A10        ; A10 = INITIAL CLIPPING
;         JSRP    GROW_WINDOW
;         DIE


ONE_CHEER
         MOVI    TANIAFX_INIT,A14         
         CALLA   INITOBJ

         MOVE    @T0SCORE,A0,W
         MOVE    @T1SCORE,A1,W

         MOVI    HFTMER_P,A5
         MOVI    afrorpal,A6          ; USE THE LEADING TEAMS CHEERLEADERS
         CMP     A1,A0
         JRGE    ONEC2
         MOVI    HFTIME_P,A5
         MOVI    afrobpal,A6
ONEC2    MOVI    410,A0
         CALLA   RANDPER              ; 40% BLACK CHEERLEADERS
         JRNC    ONEC3
         MOVE    A6,A5
ONEC3    MOVE    A5,A0
         CALLA   GETFPAL              ; GET A PALETTE FOR CHEERLEADER
         MOVE    A0,*A8(OPAL),L

         SLEEP   2
         CALLA   GROUND_PLAYER        ; PLANT YER FEET, TANIA
         MOVE    A9,*A8(OXPOS),W
         MOVE    A10,*A8(OZPOS),W
         MOVE    A8,A0
         CALLA   INSOBJ
         SLEEP   >3A

         MOVI    A_SIDE,A9
         MOVI    >00060002,A0
         JSRP    A0FRAMES             ; BEAT #1
         SLEEP   >04
         MOVI    >00050002,A0
         JSRP    A0FRAMES             ; BEAT #2
         SLEEP   >12

         MOVI    >00050002,A0
         JSRP    A0FRAMES             ; BEAT #3
         SLEEP   >04
         MOVI    >00050002,A0
         JSRP    A0FRAMES             ; BEAT #4
         SLEEP   >12

         MOVI    A_KICK,A9
         MOVK    4,A0
         JSRP    FRAMEW
         MOVI    A_KICK,A9
         MOVK    4,A0
         JSRP    FRAMEW
         MOVI    A_KICK,A9
         MOVK    4,A0
         JSRP    FRAMEW

         MOVE    A11,A0
         SLL     4,A0
         ADDI    TS_TABLE1,A0
         MOVE    *A0,A0,W
         CALLA   PRCSLP

         MOVI    A_JUMP,A9
         MOVK    6,A0
         JSRP    FRAMEW               ; JUMP ANIMATION
         MOVI    A_JUMP,A9
         MOVK    6,A0
         JSRP    FRAMEW               ; JUMP ANIMATION
         MOVI    A_JUMP,A9
         MOVK    6,A0
         JSRP    FRAMEW               ; JUMP ANIMATION
         MOVI    A_JUMP,A9
         MOVI    >00020006,A0
         JSRP    A0FRAMES

         MOVI    A_SIDE,A9
         MOVK    5,A0
         JSRP    FRAMEW
         MOVI    A_SIDE,A9
         MOVK    5,A0
         JSRP    FRAMEW

         MOVI    A_KICK,A9
         MOVK    4,A0
         JSRP    FRAMEW
         SLEEP   >20

         MOVI    A_JUMP,A9
         MOVK    6,A0
         JSRP    FRAMEW               ; JUMP ANIMATION
         MOVI    >00020006,A0
         JSRP    A0FRAMES

         DIE

TS_TABLE1
         .WORD   6
         .WORD   6*2
         .WORD   6*3
         .WORD   6*4
         .WORD   6*5
         .WORD   6*6
         .WORD   6*7
         .WORD   6*8
         .WORD   6*9

         .WORD   6*9
         .WORD   6*9
         .WORD   6*9

TANIAFX_INIT
         .LONG   CHEERSIDE1,0
         .WORD   0,DMAWNZ,OID_FX
         .WORD   0,0,0

**************************************************************************
*                                                                        *
*  THE PAIN EFFECT                                                       *
*                                                                        *
*  Used when some dork is screaming on the ground in pain !              *
*                                                                        *
**************************************************************************
FX_PAIN
         MOVE    @PAINCNT,A0,W
         JREQ    PAIN1                ; ZERO ---> RUN THE EFFECT
         DEC     A0
         MOVE    A0,@PAINCNT,W        ; DON'T DO THIS TOO OFTEN
         DIE

PAIN1    MOVK    2,A0
         MOVE    A0,@PAINCNT,W
         SLEEP   >38                  ; LET THE "IMPACT" SOUND PLAY
         BSOUND  >45                  ; PAIN SCREAMING
         SLEEP   >60

         MOVI    FAN1_INIT,A14
         MOVI    A_FAN1,A9
         CALLA   INITOBJ
         MOVK    5,A10
         CREATE  PID_FX,WINDOW_ANI    ; LET SOMEONE ELSE DO THE ANIMATING

         MOVI    >E0,A2
         MOVI    >10,A3
         MOVE    @BALLCAR,A0,L
         MOVE    *A0(OZPOS),A0,W
         CMPI    FIELD_MIDZ,A0
         JRLO    PAIN2
         MOVI    >99,A3
PAIN2    MOVE    A2,*A8(OXPOS),W
         MOVE    A3,*A8(OYPOS),W      ; FIND A GOOD SPOT FOR WINDOW
         MOVE    A8,A0
         CALLA   INSOBJ2
         BSOUND  >53                  ; CROWD ROAR
         SLEEP   >40

         CREATE  PID_FX,AWESOME
         SLEEP   >80
         JRUC    FX_EXIT

**************************************************************************
*                                                                        *
*  AWESOME                                                               *
*                                                                        *
*  Announcer saying: "Awesome !!"                                        *
*                                                                        *
**************************************************************************
AWESOME
         MOVI    MA_AWESOMEH,A11
         MOVE    @BALLCAR,A0,L
         MOVE    *A0(OZPOS),A0,W
         CMPI    FIELD_MIDZ,A0
         JRHI    AWE2
         MOVI    MA_AWESOMEL,A11      ; LOWER PORTION OF SCREEN

AWE2     MOVI    INSOBJ3,A10
         CREATE  PID_FX,MULTIANI
         MOVE    A0,A9                ; A9 = ANI PROC
         CALLR   HIDELIST3
         SLEEP   1                    ; TIME FOR IT TO INITIALIZE
         MOVE    *A9(P_PREY),A8,L     ; A8 = BACKDROP OBJ
         MOVI    >00020002,A11
         MOVI    >00250025,A10        ; A10 = INITIAL CLIPPING
         JSRP    GROW_WINDOW
         SLEEP   >0B
         BSOUND  >42                  ; SPEECH: AWESOME !!!
         SLEEP   >80
         MOVI    >00020002,A11
         JSRP    SHRINK_WIN
         DIE

**************************************************************************
*                                                                        *
*  SUDDEN DEATH OVERTIME EFFECT                                          *
*                                                                        *
*  Tells the players what the lowdown is.                                *
*                                                                        *
**************************************************************************
FX_SUDDEN
         MOVI    RGB_BLACK,A0
	MOVE	A0,@IRQSKYE,W        ; BACKGROUND COLOR

         CALLA   GAME_OVER_SCREEN

         MOVI    >0B,A0
         CALLA   FX_SHADOW_PRINT      ; "THE SCORE IS TIED"

         MOVI    SUDDEN_IMAGES,A7
         CLR     A9
         MOVK    6,A3
         MOVI    SUDLET_INIT,A14
         CALLR   TDOWN1               ; "SUDDEN"
         MOVI    DEATH_IMAGES,A7
         CLR     A9
         MOVK    5,A3
         MOVI    DELET_INIT,A14
         CALLR   TDOWN1               ; "DEATH"

         MOVI    >0A,A0
         CALLA   FX_SHADOW_PRINT      ; "OVERTIME"

         MOVK    3,A11
         CREATE  PID_FX,RGBSTUFF      ; FLASH: "THE SCORE IS TIED"

         MOVI    >0A,A3
         CALLA   FVTUNE               ; TUNE
         SLEEP   >130
         JRUC    FX_EXIT

SUDLET_INIT
         .LONG   HUGE_T,letblu
         .WORD   0,DMAWNZ|M_NOSCROLL,OID_FX
         .WORD   >7C,>62,0

DELET_INIT
         .LONG   HUGE_T,letblu
         .WORD   0,DMAWNZ|M_NOSCROLL,OID_FX
         .WORD   >88,>85,0

SUDDEN_IMAGES
         .LONG   HUGE_N
         .LONG   HUGE_E
         .LONG   HUGE_D
         .LONG   HUGE_D
         .LONG   HUGE_U
         .LONG   HUGE_S

DEATH_IMAGES
         .LONG   HUGE_H
         .LONG   HUGE_T
         .LONG   HUGE_A
         .LONG   HUGE_E
         .LONG   HUGE_D

**************************************************************************
*                                                                        *
*  "WHAT A PLAY" EFFECT                                                  *
*                                                                        *
**************************************************************************
FX_WHADDA
         MOVI    MA_WHADDAH,A11
         MOVE    @BALLCAR,A0,L
         MOVE    *A0(OZPOS),A0,W
         CMPI    FIELD_MIDZ,A0        ; ABOVE OR BELOW ??
         JRGT    WHAD2
         MOVI    MA_WHADDAL,A11
WHAD2    MOVI    INSOBJ3,A10
         CREATE  PID_FX,MULTIANI      ; COACH "YEA" WINDOW
         MOVE    A0,A9                ; A9 = ANI PROC
         CALLR   HIDELIST3
         SLEEP   1                    ; TIME FOR IT TO INITIALIZE
         MOVE    *A9(P_PREY),A8,L     ; A8 = BACKDROP OBJ
         MOVI    >00020002,A11
         MOVI    >00250025,A10        ; A10 = INITIAL CLIPPING
         JSRP    GROW_WINDOW
         SLEEP   8         
         BSOUND  >48                  ; SPEECH: "WHAT A PLAY !!!"
         SLEEP   >80
         JRUC    SHRINK_THEN_DIE

**************************************************************************
*                                                                        *
*  POST INTERCEPTION EFFECT                                              *
*                                                                        *
**************************************************************************
FX_POSTINT
         MOVI    OID_FX,A0
         CALLA   DALLOBJ              ; DONT INTERFERE WITH OLD TEXT !
         CREATE  PID_FX,SHOW_TURNOVER

         MOVE    @RAND,A0,L
         JRN     POSTINT1             ; 2 DIFFERENT "YEA !!" DEALS

         MOVI    MA_FUCKINA1,A11
         MOVE    @OFFENSE,A0,W
         JREQ    POSTINT2
         MOVI    MA_FUCKINA2,A11
         JRUC    POSTINT2

POSTINT1 MOVI    MA_COACH_YEA1,A11
         MOVE    @OFFENSE,A0,W
         JREQ    POSTINT2
         MOVI    MA_COACH_YEA2,A11
POSTINT2 MOVI    INSOBJ3,A10
         CREATE  PID_FX,MULTIANI      ; COACH "YEA" WINDOW

POSTINT3 MOVE    A0,A9                ; A9 = ANI PROC
         CALLR   HIDELIST3
         SLEEP   1                    ; TIME FOR IT TO INITIALIZE
         MOVE    *A9(P_PREY),A8,L     ; A8 = BACKDROP OBJ
         MOVI    >00020002,A11
         MOVI    >00250025,A10        ; A10 = INITIAL CLIPPING
         JSRP    GROW_WINDOW
         BSOUND  >23                  ; CROWD ROAR !!!!
         SLEEP   >B0
         JRUC    SHRINK_THEN_DIE

**************************************************************************
*                                                                        *
*  SHOW_TURNOVER                                                         *
*                                                                        *
*  Effect which shows the TURNOVER of the ball.                          *
*                                                                        *
**************************************************************************
SHOW_TURNOVER
         MOVE    @T0TEAM,A0,W
         MOVI    >36,A5
         MOVI    >55,A6
         MOVI    INSOBJ2,A10          ; ROUTINE TO CALL
         CALLR   DO_A_LOGO
         MOVE    @T1TEAM,A0,W
         MOVI    >DA,A5
         MOVI    >55,A6
         MOVI    INSOBJ2,A10          ; ROUTINE TO CALL
         CALLR   DO_A_LOGO

         MOVI    >2F,A0
         MOVE    @INTERF,A1,W         ; INTERCEPTION OF SORTS ??
         CMPI    1,A1
         JRNE    SHOT2                ; NOPE....
         MOVI    >11,A0               ; YES ---> "INTERCEPTION TURNOVER"
SHOT2    CALLA   FX_SHADOW_PRINT      ; "TURNOVER"

         MOVI    >2D,A0
         MOVE    @OFFENSE,A1,W
         JREQ    SHOT3
         MOVI    >2E,A0
SHOT3    CALLA   FX_SHADOW_PRINT
         MOVK    4,A11
         CREATE  PID_FX,RGBSTUFF      ; FLASH THE LETTERS
         BSOUND  >0F
         SLEEP   >70
         DIE

**************************************************************************
*                                                                        *
*  BLEW 4TH DOWN EFFECT                                                  *
*                                                                        *
**************************************************************************
FX_BLEW4TH
         SLEEP   >30
         MOVI    MAD_CHOICES0,A1
         MOVE    @OFFENSE,A2,W
         JRNE    BLEW40
         MOVI    MAD_CHOICES1,A1
BLEW40   MOVK    5,A0                 ; # OF CHOICES WE HAVE
         CALLA   RANDU
         DEC     A0
         SLL     5,A0
         ADD     A1,A0
         MOVE    *A0,A11,L

BLEW41   MOVI    INSOBJ3,A10
         CREATE  PID_FX,MULTIANI      ; COACH WINDOW

         MOVE    A0,A9                ; A9 = ANI PROC
         CALLR   HIDELIST3
         SLEEP   1                    ; TIME FOR IT TO INITIALIZE
         MOVE    *A9(P_PREY),A8,L     ; A8 = BACKDROP OBJ
         MOVI    >00020002,A11
         MOVI    >00250025,A10        ; A10 = INITIAL CLIPPING
         JSRP    GROW_WINDOW
         BSOUND  >24                  ; BOO !!!
;        SLEEP   >30
         CREATE  PID_FX,SHOW_TURNOVER
         SLEEP   >A0

SHRINK_THEN_DIE
         MOVI    >00020002,A11
         JSRP    SHRINK_WIN
         JRUC    FX_EXIT

MAD_CHOICES0
         .LONG   MA_BAGMAN0
         .LONG   MA_MAD0
         .LONG   MA_SHAKE0
         .LONG   MA_PU0
         .LONG   MA_MOON0

MAD_CHOICES1
         .LONG   MA_BAGMAN1
         .LONG   MA_MAD1
         .LONG   MA_SHAKE1
         .LONG   MA_PU1
         .LONG   MA_MOON1

**************************************************************************
*                                                                        *
*  FIELD GOAL = YES EFFECT                                               *
*                                                                        *
**************************************************************************
FX_FGY
         MOVI    RGOAL_IN_X,A1
         MOVE    @OFFENSE,A2,W
         JRNE    FXFGY2
         MOVI    LGOAL_IN_X,A1
FXFGY2   MOVE    @LINEOFSC,A0,W
         SUB     A0,A1
         ABS     A1
         MOVK    PIX_PER_YARD,A2
         DIVS    A2,A1                ; TRANSLATE TO YARDS
         ADDK    10,A1                ; PLUS ENDZONE SIZE

         PUSH    A1
         MOVI    FXLET_INIT,A14
         PUSH    A14
         MOVK    1,A0                 ; MSG: "YARD FIELDGOAL"
         CALLA   PRINT_OBJ            ; TEXT = A4 --> A7
         PULL    A14
         MOVE    A4,A5                ; A5 = BEGINNING OF LIST
         PULL    A1

         MOVI    FXLET_INIT,A14
         CALLA   SPLIT_A1             ; A1 / A3
         SWAP    A1,A3
         CALLR   PRNT_1DIG
         MOVE    *A8(OXPOS),A0,W
         SUBK    6,A0
         MOVE    A0,*A8(OXPOS),W      ; WORD SPACING
         MOVE    A3,A1                ; TENS
         JREQ    FXFGY3               ; ZERO ---> SKIP
         MOVI    FXLET_INIT,A14
         CALLR   PRNT_1DIG

FXFGY3   MOVI    00020002H,A6
         CALLA   SHADOW_PRINT
         MOVE    @OBJLST2,A0,L
         MOVE    A0,*A7(OLINK),L      ; LAST CHAR ----> OBJLST2
         MOVE    A5,@OBJLST2,L        ; OBJLST2 ---> 1ST CHAR

         MOVK    4,A11                ; USE THIS RGBSTUFF
         CREATE  PID_FX,RGBSTUFF      ; FLASH THE LETTERS (A11 IS DEFINED)

**************************************************************************
*                                                                        *
*  EXTRA POINT = YES EFFECT                                              *
*                                                                        *
**************************************************************************
FX_EPY
         CALLA   UNCLIP
         CLR     A3
         CALLA   SEND_CODE_A3
         BSOUND  >3C                  ; ITS GOOD / TUNE / CROWD
         CREATE  PID_FX,ITGOOD
         CREATE  PID_FX,GP_FLASH      ; PROC: FLASH THE GOAL POSTS

         MOVI    >14000,A1
         MOVE    @OFFENSE,A0,W
         JRNE    EPY2
         NEG     A1
EPY2     MOVE    A1,@SCROLLX,L        ; REVEAL A BIT MORE OF THE GOAL POSTS
         MOVI    ->10000,A1
         MOVE    A1,@SCROLLY,L        ; A TAD UPWARDS
         SLEEP   >30
         CLR     A0
         MOVE    A0,@SCROLLX,L
         MOVE    A0,@SCROLLY,L
         SLEEP   >60

         MOVI    LGOAL_IN_X+>A0,A1         ; LEFT SIDE
         MOVE    @OFFENSE,A0,W
         JREQ    EPY3
         MOVI    RGOAL_IN_X-SCRRGT->80,A1  ; RIGHT SIDE
EPY3     MOVI    >1B0,A3
         MOVK    3,A4
         JSRP    AUTOSCR              ; SHOW SOME CROWD
         SLEEP   >100
         JRUC    FX_EXIT              ; SHOULDN'T GET HERE

**************************************************************************
*                                                                        *
*    FLASH THE GOAL POSTS FOR A SEC...                                   *
*                                                                        *
**************************************************************************
GP_FLASH
         MOVE    @T0GP,A8,L           ; ASSUME OFFENSE = 0
         MOVE    @OFFENSE,A0,W
         JREQ    FGY2
         MOVE    @T1GP,A8,L           ; MAIN PROC HAS ALREADY SWITCHED OFFENSE
FGY2     MOVE    *A8(OSLINK),A8,L
         MOVE    *A8(OSLINK),A9,L
         MOVE    *A9(OSLINK),A10,L

         MOVI    BPAL_WHT,A0
         MOVE    A0,*A8(OCONST),W
         MOVE    A0,*A9(OCONST),W
         MOVE    A0,*A10(OCONST),W    ; CONSTANT COLOR TO FLASH

         MOVI    20,A11
GPFLASH  MOVE    *A8(OFLAGS),A4,W
         PUSHP   A4
         ORI     DMACNZ,A4
         MOVI    boonpal,A0           ; USE BOONPAL "WHITE"
         CALLA   SWPAL
         PUSH    A8
         MOVE    A9,A8
         CALLA   SWPAL
         MOVE    A10,A8
         CALLA   SWPAL                ; CHANGE EVERYONE TO "BOONPAL"
         PULL    A8
         MOVE    A4,*A8(OFLAGS),W
         MOVE    A4,*A9(OFLAGS),W
         MOVE    A4,*A10(OFLAGS),W
         SLEEP   3
*
* CHANGE EVERYONE BACK TO NORMAL
*
         PULLP   A4
         MOVE    A4,*A8(OFLAGS),W
         MOVE    A4,*A9(OFLAGS),W
         MOVE    A4,*A10(OFLAGS),W
         MOVI    FLDPAL1,A0
         CALLA   SWPAL
         PUSH    A8
         MOVE    A9,A8
         CALLA   SWPAL
         MOVE    A10,A8
         CALLA   SWPAL                ; CHANGE EVERYONE BACK TO "FLDPAL"
         PULL    A8
         SLEEP   3
         DSJ     A11,GPFLASH
         DIE

**************************************************************************
*                                                                        *
*   HUGE "ITS GOOD" LETTERS                                              *
*                                                                        *
**************************************************************************
ITGOOD
         CLR     A9
         MOVE    A9,@SCRNTL3,0
         MOVE    A9,@SCRNLR3,0        ; TOTALLY CLIP LIST #3

         MOVK    9,A3
IG1      MOVI    IGLET_INIT,A14
         CALLA   INITOBJ
         MOVE    A3,A1
         DEC     A1
         SLL     5,A1
         ADDI    IG_IMAGES,A1
         MOVE    *A1,A1,L
         CALLA   ANI                  ; SHAPE THE LETTER
         MOVE    A9,A9
         JREQ    IG2

         MOVE    *A9(OXPOS),A0,W
         MOVE    *A9(OSIZEX),A1,W
         ADD     A1,A0
         DEC     A0
         MOVE    A0,*A8(OXPOS),W
IG2      MOVE    A8,A9
         MOVE    A8,A0
         CALLA   INSOBJ3
         DSJ     A3,IG1
*
* SCORE BOXES
*
         MOVE    @OBJLST3,A5,L
         MOVE    A5,A1
FG4      MOVE    A1,A6
         MOVE    *A6(OLINK),A1,L
         JRNE    FG4                   ; SET UP LIST #3 = A5 --> A6

         MOVI    L_SCOREBOX,A14
         CALLA   INITOBJ
         MOVI    >22,A0
         MOVE    A0,*A8(OXPOS),W
         MOVE    A8,A0
         CALLA   INSOBJ3              ; ON LIST #3
         MOVE    A8,A9
         MOVI    R_SCOREBOX,A14
         CALLA   INITOBJ
         MOVI    >134,A0
         MOVE    A0,*A8(OXPOS),W
         MOVE    A8,A0
         CALLA   INSOBJ3              ; ON LIST #3

         MOVE    @T0SCORE,A1,W        
         MOVI    >29,A11              ; X COORDINATE FOR DIGIT
         MOVI    >6C,A3
         CALLR   TWO_BIG_DIG          ; TEAM 0 SCORE
         CALLR   A9A10_OBJLST3
         MOVE    @T1SCORE,A1,W        
         MOVI    >13B,A11             ; FALL THROUGH TO "MAKE_2_DIGITS"
         MOVI    >6C,A3
         CALLR   TWO_BIG_DIG          ; TEAM 0 SCORE
         CALLR   A9A10_OBJLST3

         MOVI    letblu,A10
         MOVI    >04060200,A11
         CREATE  PID_FX,CYCLERF
         MOVI    letblu,A10
         MOVI    >0A060200,A11
         CREATE  PID_FX,CYCLERF
*
* CLIP UNMASKING EFFECT
*
         MOVI    SCRRGT/2,A10
         MOVE    A10,A11
FG6      SUBK    12,A10
         ADDK    12,A11
         MOVE    A10,@SCRNTL3,W
         MOVE    A11,@SCRNLR3,W
         SLEEP   1
         CMPI    SCRRGT-12,A11
         JRLT    FG6
         CALLA   UNCLIP
         CALLA   OL3TOOL2             ; TACK LIST 3 ---> LIST 2
*
* WINDOW
*
         CALLR   HIDELIST3

         MOVI    MA_COACH_YEA2,A11
         MOVE    @OFFENSE,A0,W
         JREQ    FG8
         MOVI    MA_COACH_YEA1,A11
FG8      MOVI    INSOBJ3,A10
         CREATE  PID_FX,MULTIANI      ; COACH WINDOW
         MOVE    A0,A9                ; A9 = ANI PROC
         SLEEP   1                    ; TIME FOR IT TO INITIALIZE
         MOVE    *A9(P_PREY),A8,L     ; A8 = BACKDROP OBJ
         MOVI    >00020002,A11
         MOVI    >00250025,A10        ; A10 = INITIAL CLIPPING
         JSRP    GROW_WINDOW
         SLEEP   >C0                  ; TIME TO SEE FULL ANIMATION
         MOVI    >00020002,A11
         JSRP    SHRINK_WIN
         MOVE    A9,A0
         CALLA   KILL                 ; KILL "MULTIANI" PROC
         DIE

IGLET_INIT
         .LONG   HUGE_I,letblu
         .WORD   0,DMAWNZ|M_NOSCROLL,OID_FX
         .WORD   >62,>72,0

IG_IMAGES
         .LONG   HUGE_D
         .LONG   HUGE_O
         .LONG   HUGE_O
         .LONG   HUGE_G
         .LONG   HUGE_SP
         .LONG   HUGE_S
         .LONG   HUGE_APOS
         .LONG   HUGE_T
         .LONG   HUGE_I

**************************************************************************
*                                                                        *
*  BIG HIT EFFECT                                                        *
*                                                                        *
*  Effect to stroke the dude after he makes a BIG hit !!!                *
*                                                                        *
**************************************************************************
FX_BIGHIT
         MOVE    @BALLCAR,A0,L
         MOVE    *A0(OZPOS),A0,W      ; A0 = BALL CARRIER Z
         SUBI    TOP_SIDELINE,A0
         ABS     A0                   ; A0 = DISTANCE FROM SIDELINE
         CMPI    >70,A0
         JRLE    PAN_TO_CROWD         ; CLOSE TO TOP ---> PAN UP !!

         SLEEP   >30
         BSOUND  >53                  ; FAST ROAR

         MOVI    FAN1_INIT,A14
         MOVI    A_FAN1,A9
         CALLA   INITOBJ
         MOVK    5,A10
         CREATE  PID_FX,WINDOW_ANI    ; LET SOMEONE ELSE DO THE ANIMATING

         MOVI    >EC,A1
         MOVI    >12,A2
         MOVE    @BALLCAR,A0,L
         MOVE    *A0(ODMAY),A0,W
         CMPI    >300,A0
         JRGT    FXBIG2
         MOVI    >94,A2
FXBIG2   MOVE    A1,*A8(OXPOS),W
         MOVE    A2,*A8(OYPOS),W      ; POSITION WINDOW
         MOVE    A8,A0
         CALLA   INSOBJ2
         SLEEP   >40                  ; TIME FOR CROWD SOUND

         MOVI    MA_AWESOME_UL,A11    ; UPPER LEFT CORNER "AWESOME"
         MOVI    INSOBJ3,A10
         CREATE  PID_FX,MULTIANI      ; DO THE WINDOW !!
         MOVE    A0,A11

         SLEEP   >20
         BSOUND  >42                  ; SPEECH: AWESOME !!!
         SLEEP   >60

         MOVE    *A11(P_PREY),A8,L
         MOVI    >00020002,A11
         JRUC    SHRINK_THEN_DIE

FAN1_INIT
         .LONG   FANWIN1A,FAN1PAL
         .WORD   0,DMAWNZ|M_NOSCROLL,OID_FX
         .WORD   0,0,0

*
* PAN UP TO SHOW THE CROWD CHEERING
*
PAN_TO_CROWD
         CREATE  PID_FX,SHOWC_SCROLL
         SLEEP   >30
         BSOUND  >53             ; FAST CROWD

         MOVI    CHAN1PRI,A11
         JSRP    WAITPRI         ; WAIT FOR CROWD TO FINISH
         CLR     A10
         MOVK    9,A3            ; A3 = # OF CHOICES
         MOVI    SSRCOMT,A2      ; TABLE O COMMENTS
         CALLA   COMMENT_CALL    ; MAKE THE CALL

         MOVI    CHAN1PRI,A11
         JSRP    WAITPRI         ; WAIT FOR SOUND TO FINISH
         JRUC    FX_EXIT

*
* SHOW CROWD SCROLLER
*
SHOWC_SCROLL
         MOVE    @BALLCAR,A8,L        ; A8 = BALL CARRIER
         MOVI    ->18000,A0
         MOVE    A0,@SCROLLY,L
         CLR     A0
         MOVE    A0,@SCROLLX,L        ; PAN UP
CRCH2    SLEEP   1                  
         MOVE    @WORLDTLY+16,A0,W

         MOVE    A0,A2
         ADDI    SCRBOT,A2            ; A2 = BOTTOM SCREEN Y
         MOVE    *A8(OZPOS),A1,W      ; A2 = DUDE Z
         SUB     A1,A2
         ABS     A2              ; A2 = DISTANCE FROM BOTTOM OF SCREEN
         CMPI    >18,A2
         JRLT    CRCH3           ; TOO CLOSE TO EDGE ---> STOP SCROLL
         CMPI    >1D0,A0
         JRGT    CRCH2
CRCH3    CLR     A0
         MOVE    A0,@SCROLLX,L
         MOVE    A0,@SCROLLY,L
         DIE

**************************************************************************
*                                                                        *
*  FUMBLE MESSAGE                                                        *
*                                                                        *
**************************************************************************
FX_FUMBLE
         CALLA   KILLFX
         BSOUND  >37                  ; SPEECH: "FUMBLE !!"
         MOVI    >28,A0
         CALLA   FX_SHADOW_PRINT
         MOVK    4,A11
         CREATE  PID_FX,RGBSTUFF      ; FLASH THE LETTERS
         SLEEP   >D0
         JRUC    FX_EXIT

**************************************************************************
*                                                                        *
*  TOUCHBACK MESSAGE                                                     *
*                                                                        *
**************************************************************************
FX_TOUCHB
         CALLA   KILLFX
         MOVI    >25,A0
         CALLA   FX_SHADOW_PRINT
         MOVK    4,A11
         CREATE  PID_FX,RGBSTUFF      ; FLASH THE LETTERS
         SLEEP   >30
         MOVI    >00310039,A0
         CALLA   SNDCROWD             ; SPEECH: TOUCHBACK
         SLEEP   >70
         JRUC    FX_EXIT

**************************************************************************
*                                                                        *
*  OUT OF BOUNDS EFFECT                                                  *
*                                                                        *
**************************************************************************
FX_OOB
         BSOUND  >55
         CALLA   KILLFX
         CLR     A0
         MOVE    A0,@SCROLLX,L
         MOVE    A0,@SCROLLY,L        ; IN CASE AN EFFECT WAS SCROLLING

         CMPI    4,A10
         JREQ    OOB_TURNOVER         ; 4TH DOWN ---> SHOW "TURNOVER"

         MOVI    >26,A0
         CALLA   FX_SHADOW_PRINT
         MOVK    4,A11
         CREATE  PID_FX,RGBSTUFF      ; FLASH THE LETTERS
         SLEEP   >90
;        BSOUND  >39                  ; BULL SHIT, BULL SHIT
         JRUC    FX_EXIT

OOB_TURNOVER
         MOVI    9,A0
         CALLA   FX_SHADOW_PRINT      ; OUT OF BOUNDS (HI ON SCREEN)
         MOVK    3,A11
         CREATE  PID_FX,RGBSTUFF      ; FLASH THE LETTERS
         SLEEP   >20
         CREATE  PID_FX,FX_BLEW4TH    ; NOW SHOW THE "TURNOVER"
         DIE

**************************************************************************
*                                                                        *
*  SAFETY EFFECT                                                         *
*                                                                        *
**************************************************************************
FX_SAFETY
         BSOUND  >36                  ; SOUND FX
         CALLA   KILLFX

         CLR     A9
         MOVK    6,A3
         MOVI    SAFETY_IMAGES,A7
         MOVI    SAFLET_INIT,A14
         CALLR   TDOWN1               ; SAFETY LETTERS

         MOVI    L_SCOREBOX,A14
         CALLA   INITOBJ
         MOVI    >3C,A0
         MOVE    A0,*A8(OXPOS),W
         MOVE    A8,A0
         CALLA   INSOBJ3              ; ON LIST #3
         MOVE    A8,A9
         MOVI    R_SCOREBOX,A14
         CALLA   INITOBJ
         MOVI    >11E,A0
         MOVE    A0,*A8(OXPOS),W
         MOVE    A8,A0
         CALLA   INSOBJ3              ; ON LIST #3

         MOVE    @T0SCORE,A1,W        
         MOVI    >41,A11              ; X COORDINATE FOR DIGIT
         MOVI    >6C,A3
         CALLR   TWO_BIG_DIG          ; TEAM 0 SCORE
         MOVI    OID_FX2,A4
         MOVE    A4,*A9(OID),W
         MOVE    A4,*A10(OID),W       ; DONT CONFUSE WITH OID_FX
         CALLR   A9A10_OBJLST3
         MOVE    @T1SCORE,A1,W        
         MOVI    >124,A11             ; FALL THROUGH TO "MAKE_2_DIGITS"
         MOVI    >6C,A3
         CALLR   TWO_BIG_DIG          ; TEAM 0 SCORE
         MOVI    OID_FX2,A4
         MOVE    A4,*A9(OID),W
         MOVE    A4,*A10(OID),W       ; DONT CONFUSE WITH OID_FX
         CALLR   A9A10_OBJLST3

         SLEEP   >80
         MOVI    >0D,A3
         CALLA   FVTUNE
         SLEEP   >F0
         JRUC    FX_EXIT

SAFETY_IMAGES
         .LONG   HUGE_Y
         .LONG   HUGE_T
         .LONG   HUGE_E
         .LONG   HUGE_F
         .LONG   HUGE_A
         .LONG   HUGE_S

SAFLET_INIT
         .LONG   HUGE_T,letblu
         .WORD   0,DMAWNZ|M_NOSCROLL,OID_FX2
         .WORD   >7C,>72,0

**************************************************************************
*                                                                        *
*  COMMENT PROCS                                                         *
*                                                                        *
*  This is the process which handles POST PLAY comments                  *
*                                                                        *
*  Input: A10 = sound call to make (zero = random from table of calls)   *
*                                                                        *
**************************************************************************
*
* PLAYER COMMENT
*
PPCOM    JSRP    COMSETUP
         MOVI    PLCOMT,A2
         MOVK    9,A3            ; A3 = # OF CHOICES
COM1     CALLR   COMMENT_CALL
         MOVI    CHAN1PRI,A11
         JSRP    WAITPRI         ; WAIT FOR SOUND TO FINISH
         DIE                     ; BEFORE SPLITTIN'

COMSETUP
         MOVI    PID_CROWDM,A0
         CALLA   DALLPRC
         MOVI    CHAN1PRI,A11
         JAUC    WAITPRI         ; WAIT FOR AN OPENNING TO SPEAK

*
* COMMENT CALL
* A10 = SOUND CALL (or zero for Random call)
*  A9 = # OF CHOICES
*  A2 = TABLE OF A9 SOUND CALLS
*
COMMENT_CALL
         MOVE    A10,A0          ; RANDOM CALL ??
         JRNE    COM2            ; NO, A10 = SOUND CALL TO MAKE
         MOVE    A3,A0
         CALLA   RANDU           ; YES, GET THE RANGE
         DEC     A0
         SLL     4,A0
         ADD     A2,A0
         MOVE    *A0,A0,W        ; A0 = RANDOM SOUND CALL
COM2     JAUC    BOONSND         ; MAKE THE CALL / RETURN
         

*
* ANNOUNCER TABLE O COMMENTS
*
SSRCOMT
         .WORD   >50     ; 1 - HE NAILED HIM
         .WORD   >50     ; 2 - HE NAILED HIM
         .WORD   >43     ; 3 - WHAT A HIT
         .WORD   >3E     ; 4 - OUCH, THAT HURT
         .WORD   >40     ; 5 - THAT WAS INTENSE
         .WORD   >41     ; 6 - DEVASTATING
         .WORD   >43     ; 7 - WHAT A HIT
         .WORD   >52     ; 8 - I LOVE IT
         .WORD   >3E     ; 9 - OUCH, THAT HURT

*
* PLAYER TABLE O COMMENTS
*
PLCOMT   .WORD   >2F     ; 1 - I'M GONNA KICK YER ASS
         .WORD   >31     ; 2 - YOU SON OF A BITCH
         .WORD   >32     ; 3 - YER DEAD BUDDY
         .WORD   >33     ; 4 - YOU SUCK
         .WORD   >46     ; 5 - YOU MOTHER ******
         .WORD   >47     ; 6 - HOW'D THAT FEEL PUNK ?
         .WORD   >4A     ; 7 - YOU MINE SUCKA
         .WORD   >46     ; 8 - YOU MOTHER ******
         .WORD   >46     ; 9 - YOU MOTHER ******

**************************************************************************
*                                                                        *
*  PREPARE FOR KICKOFF MESSAGE                                           *
*                                                                        *
**************************************************************************
KICKPREP
         MOVE    @T0TEAM,A0,W
         MOVI    >30,A5
         MOVI    >50,A6
         MOVI    INSOBJ3,A10            ; ROUTINE TO CALL
         CALLR   DO_A_LOGO
         MOVE    @T1TEAM,A0,W
         MOVI    >E0,A5
         MOVI    >50,A6
         MOVI    INSOBJ3,A10            ; ROUTINE TO CALL
         CALLR   DO_A_LOGO

         MOVI    >1F,A0
         MOVE    @OFFENSE,A1,W
         JREQ    KIKP2
         MOVI    >1E,A0
KIKP2    CALLA   FX_SHADOW_PRINT
         MOVK    4,A11
         CREATE  PID_FX,RGBSTUFF                ; FLASH THE LETTERS

         MOVE    @SUDDEATH,A0,W
         JREQ    KIKP3                ; SUDDEN DEATH ---> TENSE TOON !
         MOVI    >D2,A3
         CALLA   SEND_CODE_A3

KIKP3    SLEEP   >80
         JRUC    FX_EXIT

DO_A_LOGO
         MOVI    LOGO_INIT,A14         
         CALLA   INITOBJ
         MOVE    A5,*A8(OXPOS),W           ; SET X
         MOVE    A6,*A8(OYPOS),W           ; SET Y
         SLL     5,A0
         ADDI    TEAM_LOGOS,A0
         MOVE    *A0,A1,L
         MOVE    *A1(32*3),A0,L
         CALLA   GETFPAL
         MOVE    A0,*A8(OPAL),W            ; DO THE PALETTE
         CALLA   ANI                       ; SHAPE TEAM 0 LOGO
         MOVE    A8,A0
         JUMP    A10

**************************************************************************
*                                                                        *
*           GAME OVER EFFECT                                             *
*                                                                        *
**************************************************************************
FX_GOVER
         MOVI    RGB_GO_GREY,A0
	MOVE	A0,@IRQSKYE,W        ; BACKGROUND COLOR

         MOVE    @GSTATE,A1,W
         PUSH    A1
         MOVI    GS_EOQMSG,A0
         MOVE    A0,@GSTATE,W         ; TRICK "GAME_OVER_SCREEN" FOR A SEC
         CALLR   GAME_OVER_SCREEN
         PULL    A1
         MOVE    A1,@GSTATE,W         ; NO MORE NEED FOR THIS TRECHERY !!

         CREATE  PID_FX,GOVER_CRED    ; SOMEONE TO SHOW CREDITS
         MOVI    >C,A0
         CALLA   FX_SHADOW_PRINT
         MOVK    4,A11
         CREATE  PID_FX,RGBSTUFF      ; FLASH THE LETTERS
*
* SHOW WINNER (IF ANY)
*
         MOVE    @T0TEAM,A2,W         ; A2 = WINNING TEAM !
         MOVE    @T0SCORE,A0,W
         MOVE    @T1SCORE,A1,W
         CMP     A1,A0
         JREQ    GOVER5               ; TIE SCORE ---> NO WINNER
         JRHI    GOVER2
         MOVE    @T1TEAM,A2,W         ; WINNING TEAM

GOVER2   MOVI    T0LOGO_INIT,A14
         CALLA   INITOBJ
         MOVE    A2,A1
         CALLA   GET_LOGO
         MOVE    *A1(16*6),A0,L
         CALLA   GETFPAL
         MOVE    A0,*A8(OPAL),W       ; TEAMS PALETTE
         CALLA   ANI

         MOVI    >88,A0
         MOVE    A0,*A8(OXPOS),W
         MOVI    >60,A0
         MOVE    A0,*A8(OYPOS),W      ; POSITION LOGO AT "CENTER SCREEN"
         MOVE    A8,A0
         CALLA   INSOBJ2

         MOVI    WINS_IMAGES,A7
         CLR     A9
         MOVK    4,A3
         MOVI    WINSLET_INIT,A14
         CALLR   TDOWN1               ; "WINS"

*
* GET DOWN DAN !!
*
GOVER5   CLR     A3
         CALLA   SEND_CODE_A3
         MOVI    >C2,A3
         CALLA   SEND_CODE_A3         ; GAME OVER INTRO
         SLEEP   >40*14
         MOVI    >C6,A3
         CALLA   SEND_CODE_A3         ; GAME OVER TUNE
         SLEEP   >40*30
         BSOUND  >15                  ; START FADING MUSIC AWAY
         SLEEP   >40*15

         MOVI    OBJLST,A2
         CALLA   DELOLIST             ; EMPTY THE LIST
         MOVI    OBJLST2,A2
         CALLA   DELOLIST             ; EMPTY THE LIST
         JRUC    FX_EXIT


WINS_IMAGES
         .LONG   HUGE_S
         .LONG   HUGE_N
         .LONG   HUGE_I
         .LONG   HUGE_W

WINSLET_INIT
         .LONG   HUGE_T,letblu
         .WORD   0,DMAWNZ|M_NOSCROLL,OID_FX
         .WORD   >90,>82,0

***************************************


GOVER_CRED
         CALLA   CRED_P               ; ANY CREDITS ?
         JRNE    GOCRED3              ; YES, DISPLAY 'EM
         SLOOP   8,GOVER_CRED         ; NO, WAIT

GOCRED3  MOVI    OBJLST3,A2
         CALLA   DELOLIST             ; EMPTY THE LIST

GOCRED5  CALLA   GET_CREDITS
         MOVE    A0,A10
         CALLA   GETCBOX              ; GET "CREDIT:" OBJECTS

         MOVE    A5,A4
GOCRED7  MOVE    *A4(OYPOS),A0,W
         ADDI    >58,A0
         MOVE    A0,*A4(OYPOS),W      ; SPECIAL CASE: LOWER THAN NORMAL
         MOVE    *A4(OLINK),A4,L
         JRNE    GOCRED7

         MOVI    OBJLST3,A2
         CALLA   DELOLIST             ; EMPTY THE OLD LIST
         CALLA   A5A6OL3              ; PUT ON LIST

GOCRED8  SLEEP   3
         CALLA   GET_CREDITS
         CMP     A0,A10
         JRNE    GOCRED5
         JRUC    GOCRED8


T0LOGO_INIT
         .LONG   LA,0
         .WORD   0,DMAWNZ|M_NOSCROLL,OID_FX
         .WORD   >40,1,0

T1LOGO_INIT
         .LONG   LA,0
         .WORD   0,DMAWNZ|M_NOSCROLL,OID_FX
         .WORD   >D3,1,0

GAME_OVER_SCREEN
         MOVK    3,A0
         CALLA   GETBLIMP             ; GAME OVER SCREEN

         MOVE    @T0SCORE,A1,W        
         MOVK    9,A11                ; X COORDINATE FOR DIGIT
         MOVK    6,A3
         CALLR   TWO_BIG_DIG          ; TEAM 0 SCORE
         CALLR   A9A10_OBJLST2
         MOVE    @T1SCORE,A1,W        
         MOVI    >151,A11
         MOVK    6,A3
         CALLR   TWO_BIG_DIG          ; TEAM 0 SCORE
         CALLR   A9A10_OBJLST2
         CALLA   A5A6OL1              ; ADD TO "OBJLST1"

         MOVI    T0LOGO_INIT,A14
         CALLA   INITOBJ
         MOVE    @T0TEAM,A1,W
         CALLA   GET_LOGO
         MOVE    *A1(16*6),A0,L
         CALLA   GETFPAL
         MOVE    A0,*A8(OPAL),W       ; TEAMS PALETTE
         CALLA   ANI
         MOVE    A8,A0
         CALLA   INSOBJ

         MOVI    T1LOGO_INIT,A14
         CALLA   INITOBJ
         MOVE    @T1TEAM,A1,W
         CALLA   GET_LOGO
         MOVE    *A1(16*6),A0,L
         CALLA   GETFPAL
         MOVE    A0,*A8(OPAL),W       ; TEAMS PALETTE
         CALLA   ANI
         MOVE    A8,A0
         CALLA   INSOBJ

         MOVE    @OBJLST2,A5,L
         MOVE    A5,A2
GOV2     MOVE    A2,A6
         MOVE    *A6(OLINK),A2,L
         JRNE    GOV2                 ; A5 ---> A6 = LIST #2
         MOVI    INSOBJ2A8,A11        ; A11 = INSERT ROUTINE
         CALLA   PTIMERS

         MOVE    @OBJLST2,A5,L
         MOVE    A5,A2
GOV3     MOVE    A2,A6
         MOVE    *A6(OLINK),A2,L
         JRNE    GOV3                 ; A5 ---> A6 = LIST #2

         CALLA   DO_CLOCK             ; CLOCK !!
         CALLA   SHOW_QUARTER
         CALLA   BALL_ON_THE
         CALLA   MINIPRNT
         RETS

**************************************************************************
*                                                                        *
*  END OF QUARTER                                                        *
*                                                                        *
*  End of quarter message / effect.                                      *
*                                                                        *
**************************************************************************
EOQ_MSG
;        MOVI    RGB_GO_GREY,A0
         CLR     A0
	MOVE	A0,@IRQSKYE,W        ; BACKGROUND COLOR

         CALLA   NOSOUNDS

	CLR	A0
	MOVE	A0,@BAKLST,L
         CALLA   BAKCLR
	MOVI	MASSIVE_CROWD,A0
	MOVE	A0,@BAKMODS,L
         CLR     A0
         MOVE    A0,@WORLDTLX,L
         MOVE    A0,@WORLDTLY,L
         MOVI    >10000,A0
         MOVE    A0,@SCROLLX,L             ; LIL SCROLL ACTION
         CREATE  PID_FX,CBACK

         MOVI    >1C,A0                    ; END OF 1ST
         MOVE    @QUARTER,A1,W         
         CMPI    4,A1
         JRNE    EOQQ2
         MOVI    >0D,A0                    ; END OF 3RD
EOQQ2    MOVI    FXLET_INIT,A14
         CALLA   PRINT_OBJ                 ; TEXT = A4 --> A7
         MOVE    @OBJLST2,A0,L
         MOVE    A0,*A7(OLINK),L           ; LAST CHAR ----> OBJLST2
         MOVE    A4,@OBJLST2,L             ; OBJLST2 ---> 1ST CHAR
         MOVK    4,A11
         CREATE  PID_FX,RGBSTUFF           ; FLASH THE LETTERS

         MOVK    1,A0
         CALLA   GETBLIMP                  ; A5 = MENU MODULE OBJECT LIST
         CALLA   A5A6OL1                   ; ADD TO "OBJLST1"

         MOVI    BIG_BLACK_INIT,A14
         CALLA   INITOBJ
         MOVI    >F0,A0
         MOVE    A0,*A8(OSIZEX),W
         MOVI    >38,A0
         MOVE    A0,*A8(OSIZEY),W
         MOVI    BPAL_BLK,A0
         MOVE    A0,*A8(OCONST),W          ; BLACK
         MOVE    A8,A0
         CALLA   INSOBJ
*
* TEAM LOGOS
*
         MOVE    @T0TEAM,A0,W
         MOVI    >48,A5
         MOVK    3,A6
         MOVI    INSOBJ,A10          ; ROUTINE TO CALL
         CALLR   DO_A_LOGO
         MOVE    @T1TEAM,A0,W
         MOVI    >CE,A5
         MOVK    3,A6
         MOVI    INSOBJ,A10          ; ROUTINE TO CALL
         CALLR   DO_A_LOGO
         MOVI    VERSUS_INIT,A14
         CALLA   INITINS              ; VERSUS
*
* TEAM SCORES
*
         MOVE    @T0SCORE,A1,W
         MOVI    >0F,A11              ; X COORDINATE FOR DIGIT
         MOVK    6,A3
         CALLR   TWO_BIG_DIG          ; TEAM 0 SCORE
         CALLR   A9A10_OBJLST2
         MOVE    @T1SCORE,A1,W        
         MOVI    >14C,A11             ; FALL THROUGH TO "MAKE_2_DIGITS"
         MOVK    6,A3
         CALLR   TWO_BIG_DIG          ; TEAM 0 SCORE
         CALLR   A9A10_OBJLST2
*
* SHOW EACH PLAYERS TIMERS
*
         MOVK    5,A0
         CALLA   GETBLIMP             ; BUYIN BOXES
         CALLA   A5A6OL2              ; ADD TO "OBJLST2"
         MOVE    @OBJLST2,A5,L
         MOVE    A5,A2
EOQQ3    MOVE    A2,A6
         MOVE    *A6(OLINK),A2,L
         JRNE    EOQQ3                ; A5 ---> A6 = LIST #2
         MOVI    INSOBJ2A8,A11        ; A11 = INSERT ROUTINE
         CALLA   PTIMERS

         MOVI    >0C,A3
         CALLA   SEND_CODE_A3
         CREATE  PID_FX,EOQ_LOF
         SLEEP   8
         BSOUND  >23                  ; BIG CROWD ROAR
         SLEEP   >E0-8

         MOVI    RGB_BLACK,A0
	MOVE	A0,@IRQSKYE,W        ; BACKGROUND COLOR
         JRUC    FX_EXIT

EOQ_LOF
         MOVI    LOF_1,A11
         MOVI    INSOBJ2,A10
         MOVK    8,A0
         MOVE    A0,*A13(P_ANIRATE),W

         MOVI    >C0,A0
         MOVE    A0,*A13(PLGOX),W
         MOVI    >91,A0
         MOVE    A0,*A13(PLGOZ),W
         CLR     A0
         MOVE    A0,*A13(P_FACE),W    ; ASSURE NO FLIPPED IMAGE
         JAUC    MANISET

LOF_1
         .LONG   markfan1,markfan2,0,ANI_LOOP
         .LONG   mltarm1,mltarm2,0,ANI_LOOP
         .LONG   mrtarm1,mrtarm2,0,ANI_LOOP
         .LONG   mwere1,0,ANI_END
         .LONG   >FFFFFFFF


QNUM_INIT
         .LONG   num0,frame
         .WORD   0,DMAWNZ|M_NOSCROLL,OID_FX
         .WORD   >BC,>60,1

BIG_BLACK_INIT
         .LONG   num0,boonpal
         .WORD   0,DMACAL|M_NOSCROLL,OID_FX
         .WORD   78,37,0

*
* CROWD BACKGROUND PROCESS
*
CBACK    CALLA	BGND_UD1

         MOVE    @BAKLST,A8,L         ; A8 = BACKGROUND LIST
         JREQ    BACK8                ; EMPTY = SPLIT
BACK3    MOVE    *A8(OZVAL),A1,L
         CMPI    CROWD_Z,A1           ; CROWD BLOCK ?
         JRGT    BACK8                ; NOPE

         MOVI    CROWD_FRAMES,A2      ; ASSUME "BIG" CROWD BLOCK
         SUBI    STRIP_Z,A1
         JRNE    BACK5                ; BIG BLOCK = YES
         MOVI    STRIP_FRAMES,A2      ; NO, USE "STRIP" FRAMES
BACK5    MOVE    *A8(OCOLLIDE),A0,W   ; HAVE WE ANIMATED THIS ONE ??
         INC     A0                   ; NEXT FRAME
         CMPI    4,A0                 ; END OF LIST ?
         JRLT    BACK4                ; NOPE....
         CLR     A0                   ; YES ---> BACK TO BEGINNING
BACK4    MOVE    A0,*A8(OCOLLIDE),W
         SLL     5,A0
         ADD     A2,A0

         MOVE    *A0,A1,L             ; A1 = NEW IMAGE
         MOVE    A1,*A8(OIMG),L
         MOVE    *A8(OFLAGS),A4,W
         MOVE    *A8(OXVAL),A0,L
         MOVE    *A8(OYVAL),A2,L      ; SAVE THIS
         CALLA   ANI0
         MOVE    A0,*A8(OXVAL),L
         MOVE    A2,*A8(OYVAL),L      ; RESTORE THIS
         MOVE    *A8(OLINK),A8,L
         JRNE    BACK3

BACK8    SLEEP   5                    ; USED TO BE 10
         JRUC    CBACK

MASSIVE_CROWD
         .LONG   EOQCRBMOD
         .WORD   0,>30
	.LONG	>FFFFFFFF

**************************************************************************
*                                                                        *
*  FX_INTER                                                              *
*                                                                        *
*  Interception effect                                                   *
*                                                                        *
**************************************************************************
FX_INTER
         CALLA   KILLFX
         MOVI    >23,A0
         CALLR   FX_SHADOW_PRINT

;        MOVI    INTLET_INIT,A14
;        CALLR   SHADOW_2             ; PRINT: "INTERCEPTION"
         MOVK    4,A11
         CREATE  PID_FX,RGBSTUFF      ; FLASH THE LETTERS
         MOVE    A0,A11
         BSOUND  >35                  ; SPEECH: INTERCEPTION
         SLEEP   >C0

         MOVE    @ACTIVE,A0,L
FXINT1   CMP     A0,A11               ; MAKE SURE RGBSTUFF IS STILL ALIVE
         JREQ    FXINT2
         MOVE    *A0(PLINK),A0,L
         JRNE    FXINT1
         JRUC    FXINT3
FXINT2   CALLA   KILL                 ; KILL RGBSTUFF IF STILL ALIVE
FXINT3   DIE

;INTLET_INIT
;         .LONG   DUMB_IMG,boonpal
;         .WORD   0,DMACNZ|M_NOSCROLL,OID_FX2
;         .WORD   0,0,0

**************************************************************************
*                                                                        *
*  PLAY RESULT EFFECT                                                    *
*                                                                        *
**************************************************************************
FX_PLAYRES
         CLR     A6                   ; ASSUME "NO EXTRA EFFECT"
         MOVE    @PPEFFECT,A7,L       ; POST PLAY EFFECT REQUEST ??
         JREQ    PLRES2               ; NOPE...
         INC     A6                   ; SIGNAL ---> "ANOTHER EFFECT RUNNING"
         MOVI    OID_FX2,A1
         CALLA   GETPRC               ; YES, CREATE A PROCESS
PLRES2   MOVE    A6,*A13(P_GCOUNT),W
         CALLA   UNCLIP
         MOVE    A10,A10              ; 1ST DOWN ?
         JREQ    NO1ST                ; NO...
*
* FIRST DOWN !!
*
         CLR     A0
         MOVE    A0,*A13(P_GCOUNT),W  ; CANCELL OTHER FX
         CALLA   KILLFX
         PUSH    A11
         MOVI    >1B,A0
         CALLA   FX_SHADOW_PRINT
         MOVK    4,A11
         CREATE  PID_FX,RGBSTUFF      ; FLASH THE LETTERS
         PULL    A11
         CMPI    PIX_PER_YARD*25,A11  ; MAJOR YARDAGE ???
         JRGT    FX_WHADDA_1ST        ; YES

         MOVE    @OFFENSE,A1,W
         JREQ    PLRES3
         MOVI    MA_FIRST1_DOWN,A11
         MOVI    INSOBJ3,A10
         CREATE  PID_FX,MULTIANIF     ; DO THE WINDOW !!
         JRUC    PLRES4

PLRES3   MOVI    MA_FIRST0_DOWN,A11
         MOVI    INSOBJ3,A10
         CREATE  PID_FX,MULTIANI      ; DO THE WINDOW !!

PLRES4   MOVE    A0,A11               ; SAVE PROC
         SLEEP   >28
         BSOUND  >3A                  ; SPEECH: "FIRST DOWN"

         SLEEP   >90->28
         MOVE    *A11(P_PREY),A8,L
         MOVI    >00020002,A11
         JSRP    SHRINK_WIN
         JRUC    FX_EXIT

*
* NO FIRST DOWN
*
NO1ST    MOVE    *A13(P_ANIRATE),A0,W ; A0 = DOWN # (IT WAS)
         CMPI    4,A0
         JREQ    FX_DIE               ; 4TH DOWN ---> DONT SHOW YARDS LOST

         MOVE    @LASTLOS,A0,W        ; LAST PLAY'S LINE OF SCRIMMAGE
         MOVE    @LINEOFSC,A1,W       ; CURRENT LINE OF SCRIMMAGE
         MOVE    A1,A3
         MOVE    *A13(P_TURBO),A4,W   ; TEAM ON OFFENSE ?
         JREQ    NO1ST1               ; ZERO

         SUB     A1,A0                ; TEAM1
         MOVE    A0,A1                ; A1 = DISTANCE
         JRUC    NO1ST3               ; LOOK AT THE DISTANCE
NO1ST1   SUB     A0,A1                ; A1 = DISTANCE
NO1ST3   MOVE    A1,A1
         JRN     YARDS_LOST           ; NEGATIVE = YARDS LOST
         MOVI    >2B,A0
         MOVK    9,A11                ; USE THIS RGBSTUFF
         JRUC    YARDALL              ; YARD GAIN

YARDS_LOST
         MOVI    >2A,A0               ; YARD LOSS
         ABS     A1
         MOVK    8,A11                ; USE THIS RGBSTUFF
YARDALL  MOVK    PIX_PER_YARD,A2
         DIVS    A2,A1                ; TRANSLATE TO YARDS
         JREQ    NOYARDS              ; NO YARDAGE MESSAGE

         PUSH    A1
         MOVI    FXLET_INIT,A14
         PUSH    A14
         CALLA   PRINT_OBJ            ; TEXT = A4 --> A7
         PULL    A14
         MOVE    A4,A5                ; A5 = BEGINNING OF LIST
         PULL    A1

         MOVI    FXLET_INIT,A14
         CALLA   SPLIT_A1             ; A1 / A3
         SWAP    A1,A3
         CALLR   PRNT_1DIG
         MOVE    *A8(OXPOS),A0,W
         SUBK    6,A0
         MOVE    A0,*A8(OXPOS),W      ; WORD SPACING
         MOVE    A3,A1                ; TENS
         JREQ    YLOST3               ; ZERO ---> SKIP
         MOVI    FXLET_INIT,A14
         CALLR   PRNT_1DIG

YLOST3   MOVI    00020002H,A6
         CALLA   SHADOW_PRINT
         MOVE    @OBJLST2,A0,L
         MOVE    A0,*A7(OLINK),L      ; LAST CHAR ----> OBJLST2
         MOVE    A5,@OBJLST2,L        ; OBJLST2 ---> 1ST CHAR

         CREATE  PID_FX,RGBSTUFF      ; FLASH THE LETTERS (A11 IS DEFINED)
         MOVE    A0,A10               ; REMEMBER THIS PROC
         SLEEP   >24
         MOVE    A10,A0
         CALLA   KILL                 ; STOP "RGBSTUFF" PROC
         SLEEP   >A0
         JRUC    PLAYRES_EXIT

NOYARDS
         MOVE    @PLAYRES,A0,W
         CMPI    PR_INCOMPLETE,A0
         JREQ    INCOM_PLAYRES        ; INCOMPLETE PASS

         MOVI    >2C,A0               ; YARD LOSS
         MOVI    FXLET_INIT,A14
         CALLA   PRINT_OBJ            ; TEXT = A4 --> A7
         MOVE    A4,A5
         MOVI    00020002H,A6
         CALLA   SHADOW_PRINT
         MOVE    @OBJLST2,A0,L
         MOVE    A0,*A7(OLINK),L      ; LAST CHAR ----> OBJLST2
         MOVE    A5,@OBJLST2,L        ; OBJLST2 ---> 1ST CHAR
         SLEEP   >60
         JRUC    PLAYRES_EXIT
*
* INCOMPLETE PASS
*
INCOM_PLAYRES
         MOVE    @BALLCAR,A0,L        ; BALL CARRIER ?
         JREQ    INCOM2               ; NOPE...
         CALLA   BOUNDS_A0            ; CHECK BOUND CONDITIONS
         CMPI    1,A1
         JRNE    INCOM2
         CREATE  PID_FX,FX_CAUGHTOOB  ; BALL CAUGHT OUT OF BOUNDS
         JRUC    INCOM3
INCOM2   CREATE  PID_FX,FX_INCOM
INCOM3   SLEEP   >80
*
* PLAY RESULT EFFECT EXIT
*
PLAYRES_EXIT
         CLR     A1
         NOT     A1
         MOVI    PID_FX,A0
         CALLA   EXISTP
         JRNE    PRESEX2
         CLR     A1
         NOT     A1
         MOVI    PID_FX2,A0
         CALLA   EXISTP
         JREQ    FX_EXIT              ; NO OTHER FX ---> EXIT
PRESEX2  

;        MOVE    *A13(P_GCOUNT),A6,W  ; ANOTHER DUDE RUNNING ??
;        JREQ    FX_EXIT              ; NOPE...
;        JSRP    WAITFX               ; YES --> LET HIM GO

         SLEEP   >F0                  ; YES ---> LET HIM END THE EFFECT
         JRUC    FX_EXIT              ; UNLESS HE'S A PIG

PRNT_1DIG
         PUSH    A14
         SLL     5,A1
         ADDI    FONT15_NUMS,A1
         MOVE    *A1,A1,L             ; A1 = IMG
         PUSH    A1
         CALLA   INITOBJ              ; GET AN OBJECT FOR THIS CHARACTER
         PULL    A1

         CALLA   ANI                            ; GIVE DIGIT A SHAPE !!
         MOVE    *A7(OCONST),*A8(OCONST),W      ; SAME COLOR
         MOVE    *A7(OZPOS),*A8(OZPOS),W
         MOVE    *A7(OYPOS),*A8(OYPOS),W

         MOVE    *A7(OXPOS),A0,W
         MOVE    *A8(OSIZEX),A1,W
         SUB     A1,A0                     ; SIZE OF #
         SUBK    3,A0                      ; PLUS LETTER SPACING
         MOVE    A0,*A8(OXPOS),W

         CLR     A0
         MOVE    A0,*A8(OLINK),L           ; A8 = NEW END OF LIST
         MOVE    A8,*A7(OLINK),L
         MOVE    A8,A7
         PULL    A14
         RETS

**************************************************************************
*                                                                        *
*  WHAT A PLAY / FIRST DOWN EFFECT                                       *
*                                                                        *
**************************************************************************
FX_WHADDA_1ST
         MOVE    @OFFENSE,A1,W
         JREQ    WHADDA3

         MOVI    MA_FIRST1_DOWN,A11
         MOVI    INSOBJ3,A10
         CREATE  PID_FX,MULTIANIF     ; DO THE WINDOW !!
         JRUC    WHADDA4

WHADDA3  MOVI    MA_FIRST0_DOWN,A11
         MOVI    INSOBJ3,A10
         CREATE  PID_FX,MULTIANI      ; REF: 1ST DOWN WINDOW

WHADDA4  MOVI    MA_WHADDAL,A11
         MOVI    INSOBJ3,A10
         CREATE  PID_FX,MULTIANI      ; ANNOUNCER: WHAT A PLAY !!

         MOVE    A0,A9                ; A9 = ANI PROC
         CALLR   HIDELIST3
         SLEEP   1                    ; TIME FOR IT TO INITIALIZE
         MOVE    *A9(P_PREY),A8,L     ; A8 = BACKDROP OBJ
         MOVI    >00020002,A11
         MOVI    >00250025,A10        ; A10 = INITIAL CLIPPING
         JSRP    GROW_WINDOW
         BSOUND  >48                  ; SPEECH: "WHAT A PLAY !!!"
         SLEEP   >80
         JRUC    SHRINK_THEN_DIE

******************************************************************

FX_SHADOW_PRINT
         MOVI    FXLET_INIT,A14
SHADOW_2
         PUSH    A14
         CALLA   PRINT_OBJ                 ; TEXT = A4 --> A7
         PULL    A14
         MOVE    A4,A5
         MOVI    00020002H,A6
         CALLA   SHADOW_PRINT
         MOVE    @OBJLST2,A0,L
         MOVE    A0,*A7(OLINK),L           ; LAST CHAR ----> OBJLST2
         MOVE    A5,@OBJLST2,L             ; OBJLST2 ---> 1ST CHAR
         RETS

FXLET_INIT
         .LONG   DUMB_IMG,boonpal
         .WORD   0,DMACNZ|M_NOSCROLL,OID_FX
         .WORD   0,0,0


FX_GAME_INTRO
         MOVK    5,A0
         CALLA   GETBLIMP             ; BUYIN BOXES
         CALLA   A5A6OL1              ; ADD TO "OBJLST1"
*
* DO EACH PLAYERS "GAME TIMER"
*
         MOVE    @OBJLST,A5,L
         MOVE    A5,A2
GINT1    MOVE    A2,A6
         MOVE    *A6(OLINK),A2,L
         JRNE    GINT1                ; A5 ---> A6 = LIST #2
         MOVI    INSOBJA8,A11         ; A11 = INSERT ROUTINE
         CALLA   PTIMERS

         CREATE  PID_FX,BACKGROUND    ; START BACKGROUND UPDATE DUDE
         CREATE  PID_FX,MIDDLE_OPEN
         CLR     A0
         MOVE    A0,@SCRNTL,L
         MOVE    A0,@SCRNLR,L         ; START WITH NOTHING SHOWING

         MOVI    TOP_SIDELINE->D0,A0
         MOVE    A0,@WORLDTLY+16,W    ; CENTER SCREEN
         MOVI    LGOAL_OUT_X->A0,A0
         MOVE    A0,@WORLDTLX+16,W
         SLEEP   1                    ; GIVE BACKGROUND A CHANCE

         MOVK    1,A3
         CALLA   SEND_CODE_A3         ; START THE MAIN TUNE
         MOVI    >30000,A0
         MOVE    A0,@SCROLLX,L        ; PAN ACROSS THE FIELD
         SLEEP   >24
         CREATE  PID_FX,WINDOW_SHOWOFF
         MOVI    >59,A3
         CALLA   SEND_CODE_A3         ; "WANNA KICK SOME BUTT ?"
         SLEEP   >40
         BSOUND  >23                  ; ROAR !!!

         SLEEP   >70
         BSOUND  >1F                  ; I CANT HEAR U
         SLEEP   >80

         MOVK    2,A0
         CALLA   GETBLIMP             ; GET LOGOPAGE
         MOVI    >28000,A4
         MOVE    A5,A7
GINT2    MOVE    *A7(OXPOS),A3,W
         SUBI    >170,A3
         MOVE    A3,*A7(OXPOS),W      ; START OFFSCREEN
         MOVE    A4,*A7(OXVEL),L
         MOVE    *A7(OLINK),A7,L
         JRNE    GINT2
         CALLA   A5A6OL1

         SLEEP   >40
         MOVI    >5A,A3
         CALLA   SEND_CODE_A3         ; "ITS HIGH IMPACT"

         SLEEP   >53
         MOVK    1,A0
         MOVE    A0,@NO_VEL,W
         CLR     A1
         MOVE    @OBJLST,A0,L
GINT8    MOVE    A1,*A0(OXVEL),L
         MOVE    *A0(OLINK),A0,L      ; STOP LOGO OBJECTS
         JRNE    GINT8
         MOVE    A1,@NO_VEL,W         ; ALLOW VELOCITIES AGAIN

         MOVI    FADE_NOLOGO,A0
         CALLA   FADEOUT
         SLEEP   >8
         CLR     A0         
         MOVE    A0,@SCROLLX,L
         SLEEP   >10
         CREATE  PID_FX,STARS1
         MOVE    A0,A11
         SLEEP   >20
         MOVE    A11,A0
         CALLA   KILL                 ; KILL LINE SPAWNER
         MOVI    PID_FX2,A0
         CALLA   DALLPRC              ; AND ANY REMAINING LINES
         SLEEP   >30
         MOVI    PID_FX,A0
         CALLA   DALLPRC
         MOVI    PID_FX2,A0
         CALLA   DALLPRC              ; DELETE FX PROCESSES
         MOVI    BAKLST,A2
         CALLA   DELOLIST             ; NO MORE NEED FOR BACKGROUND
         MOVI    FADE_NOBUY,A0
         CALLA   FADEOUT
         SLEEP   >10
         MOVI    OID_FX,A0
         CALLA   DALLOBJ
*
* BRING ON THE TEAMS !!
*
         MOVI    LOGORAND,A9,L
GINT19   MOVE    *A9+,A11,W
         JRN     GINT20               ; END OF LIST ----> DONE
         CREATE  PID_FX,LOGO_FLY
         SLEEP   6
         JRUC    GINT19

GINT20   MOVK    4,A0
         CALLA   GETBLIMP             ; "SELECT TEAM" MESSAGE
         CALLA   A5A6OL1

         MOVI    PID_FX,A0
         CALLA   DALLPRC
         MOVI    PID_FX2,A0
         CALLA   DALLPRC              ; KILL ALL FX PROCS
         DIE

LOGORAND .WORD   0,1,2,3,4,5,6,7,8,9,10,11,12,13,14
         .WORD   >FFFF

LOGO_FLY
         MOVE    A11,A0
         MOVE    A0,A1
         SLL     5,A1
         ADDI    LOGO_COOR,A1
         MOVE    *A1+,A5,W
         MOVE    *A1+,A6,W
         MOVI    INSOBJ,A10
         CALLA   DO_A_LOGO
         DIE

LOGO_COOR
         .WORD   LOGO1_X,LOGO1_Y
         .WORD   LOGO1_X,LOGO1_Y+35
         .WORD   LOGO1_X,LOGO1_Y+35*2
         .WORD   LOGO1_X,LOGO1_Y+35*3
         .WORD   LOGO1_X,LOGO1_Y+35*4

         .WORD   LOGO1_X+>80,LOGO1_Y
         .WORD   LOGO1_X+>80,LOGO1_Y+35
         .WORD   LOGO1_X+>80,LOGO1_Y+35*2
         .WORD   LOGO1_X+>80,LOGO1_Y+35*3
         .WORD   LOGO1_X+>80,LOGO1_Y+35*4

         .WORD   LOGO1_X+>100,LOGO1_Y
         .WORD   LOGO1_X+>100,LOGO1_Y+35
         .WORD   LOGO1_X+>100,LOGO1_Y+35*2
         .WORD   LOGO1_X+>100,LOGO1_Y+35*3
         .WORD   LOGO1_X+>100,LOGO1_Y+35*4

FADE_NOLOGO
         .LONG   WILLYPAL,logopal,MENUPAL1,boonpal,0
FADE_NOBUY
         .LONG   MENUPAL1,boonpal,0

*
* STARS
*
STARS1   MOVI    STAR_COORDS,A4
GINT4    MOVE    *A4+,A9,W
         JREQ    GINT5
         MOVE    *A4+,A10,W
         SUBI    STAR_Z,A10                ; COMPENSATE FOR Z !!
         MOVE    *A4+,A11,L
         CREATE  PID_FX2,LINE_O_STARS
         JRUC    GINT4

GINT5
         JAUC    WAIT_FOREVER

**************************************************************************
*                                                                        *
*  WINDOW_SHOWOFF                                                        *
*                                                                        *
*  This is the process which spawns the moving windows during the        *
*  game intro sequence.                                                  *
*                                                                        *
**************************************************************************
WINDOW_SHOWOFF
         MOVI    INTRO_WINDOWS,A8

WINS1    MOVE    *A8,A11,L
         MOVI    INSOBJ2,A10
         CREATE  PID_FX,MULTIANI
         MOVE    A0,A11
         CREATE  PID_FX,WINDOW_KILLER
         SLEEP   1                    ; TIME FOR LIST TO BE RUN

         MOVE    @OBJLST2,A3,L
         CLR     A0
         MOVE    A0,@OBJLST2,L
         MOVI    >28000,A2
         MOVE    A3,A4
WINS2    
;        MOVE    *A4(OID),A0,W
;        CMPI    OID_FX,A0
;        JRNE    WINS3                ; DONT TOUCH "NON F/X" OBJECTS

         MOVE    A2,*A4(OXVEL),L
WINS3    MOVE    A4,A5
         MOVE    *A4(OLINK),A4,L      ; GIVE ALL OBJECTS THE SAME VELOCITY
         JRNE    WINS2
*
* TACK ONTO LIST #1
*
         MOVE    @OBJLST,A0,L
         MOVE    A0,*A5(OLINK),L      ; ADD TO TOP OF LIST #1
         MOVE    A3,@OBJLST,L
         SLEEP   >40

         ADDI    32,A8
         CMPI    INTRO_END,A8
         JRNE    WINS1
         DIE

INTRO_WINDOWS
         .LONG   MA_INTCHEER
         .LONG   MA_INTREFTD
         .LONG   MA_CANT_HEAR
         .LONG   MA_INTYEA
         .LONG   MA_INTFD
INTRO_END


WINDOW_KILLER
         SLEEP   10
         MOVE    *A11(P_PREY),A8,L    ; RIGHT SIDE IMAGE
;        MOVE    *A0(OSLINK),A8,L     ; LEFT SIDE IMAGE
         MOVE    *A8(OXPOS),A2,W
         CMPI    SCRRGT,A2            ; ON SCREEN ?
         JRLT    WINDOW_KILLER        ; NO ---> WAIT

         MOVE    *A11(P_PREY),A0,L    ; RIGHT SIDE
         MOVE    *A0(OSLINK),A1,L     ; LEFT SIDE
         
         CALLA   DELOBJP              ; DELETE RIGHT SIDE
         MOVE    A1,A0
         CALLA   DELOBJP              ; DELETE LEFT SIDE

         MOVE    *A11(P_SWITCH),A0,L
WKILL3   CALLA   DELOBJP
         MOVE    *A0(OSLINK),A0,L
         JRNE    WKILL3               ; KILL LINKED PARTS
         
         MOVE    A11,A0
         CALLA   KILL                 ; KILL "MULTIANI" PROC
         DIE

**************************************************************************
*                                                                        *
*  MIDDLE_OPEN                                                           *
*                                                                        *
*  Television "reveal" effect from the middle of the screen outwards.    *
*                                                                        *
**************************************************************************
MIDDLE_OPEN
;         MOVI    WBAR_INIT,A14         
;         CALLA   INITOBJ
;         MOVI    BPAL_YEL,A0
;         MOVE    A0,*A8(OCONST),W
;         MOVE    A8,A0
;         CALLA   INSOBJ2

         MOVI    SCRNMID,A0
         MOVE    A0,@SCRNTL,L
         MOVE    A0,@SCRNLR,L         ; START FROM THE MIDDLE
MOPEN1   SLEEP   1
         CLR     A3
         MOVE    @SCRNTL,A0,L
         SUBI    >00020003,A0
         MOVE    @SCRNLR,A1,L
         ADDI    >00020003,A1

         CMPXY   A3,A0
         JRYGE   MOPEN3
         SLL     16,A0
         SRL     16,A0                ; KEEP Y POSITIVE
MOPEN3   CMPXY   A3,A0
         JRXGE   MOPEN4
         SRL     16,A0
         SLL     16,A0                ; KEEP X POSITIVE
MOPEN4   MOVI    SCRNEND,A3
         CMPXY   A3,A1
         JRYLE   MOPEN5
         MOVY    A3,A1
MOPEN5   CMPXY   A3,A1
         JRXLE   MOPEN6
         MOVX    A3,A1
MOPEN6   MOVE    A0,@SCRNTL,L
         MOVE    A1,@SCRNLR,L

         MOVE    A0,A0
         JRNE    MOPEN1

         MOVI    SCRNST,A0
         MOVE    A0,@SCRNTL,L
         MOVI    SCRNEND,A0
         MOVE    A0,@SCRNLR,L         ; UNCLIP
         DIE

;WBAR_INIT
;         .LONG   DUMB_IMG,boonpal
;         .WORD   0,DMACAL|M_NOSCROLL,OID_FX
;         .WORD   0,0,0

STAR_COORDS
         .WORD   >70,78H
         .LONG   STW_PAL
         .WORD   >A0,78H
         .LONG   STR_PAL
         .WORD   >B3,78H
         .LONG   STW_PAL
         .WORD   >BC,78H
         .LONG   STB_PAL

;        .WORD   >C3,78H
         .WORD   0



LINE_O_STARS
         CREATE  PID_FX,STAR_PROC         ; QUADRANT #1

         PUSH    A9
         MOVI    SCRRGT/2,A0         
         SUB     A9,A0  
         ADDI    SCRRGT/2,A0
         MOVE    A0,A9
         CREATE  PID_FX,STAR_PROC         ; QUADRANT #2
         PULL    A9

         PUSH    A10
         MOVI    SCRBOT/2,A0
         SUB     A10,A0
         ADDI    SCRBOT/2,A0
         MOVE    A0,A10
         CREATE  PID_FX,STAR_PROC         ; QUADRANT #4
         PULL    A10

         MMTM    SP,A9,A10
         MOVI    SCRRGT/2,A0         
         SUB     A9,A0  
         ADDI    SCRRGT/2,A0
         MOVE    A0,A9
         MOVI    SCRBOT/2,A0
         SUB     A10,A0
         ADDI    SCRBOT/2,A0
         MOVE    A0,A10
         CREATE  PID_FX,STAR_PROC         ; QUADRANT #3
	MMFM    SP,A9,A10

         SLEEP   10
         JRUC    LINE_O_STARS

STAR_PROC
         MOVI    STAR_INIT,A14
         CALLA   INITOBJ

         MOVE    A11,A0
         CALLA   SWPAL

         MOVE    A9,*A8(OXPOS),W
         MOVE    A10,*A8(OYPOS),W

         MOVI    (SCRRGT/2)*10000H,A0 ; SCREEN X MIDPOINT
         MOVI    (SCRBOT/2)*10000H,A2 ; SCREEN Y MIDPOINT
         MOVE    *A8(OXVAL),A1,L
         MOVE    *A8(OYVAL),A3,L
         SUB     A0,A1
         SUB     A2,A3                ; GET X/Y RATIOS
         MOVE    A1,A0
         MOVE    A3,A2
         ABS     A0
         ABS     A2
         ADD     A2,A0                ; A0 = ABS(X) + ABS(Z)
         SRL     16,A0                ; IN LOWER WORD

         DIVS    A0,A1                ; A1 = X / X+Z
         DIVS    A0,A3                ; A3 = Z / X+Z
         MOVK    5,A0
         MPYS    A0,A1
         MPYS    A0,A3
         MOVE    A1,*A8(OXVEL),L
         MOVE    A3,*A8(OYVEL),L

         MOVE    A8,A0
         CALLA   INSOBJ

         MOVI    A_STARSP,A9
         MOVK    3,A0
         JSRP    FRAMEW
         SLEEP   20H
         MOVE    A8,A0
         CALLA   DELOBJP              ; DELETE OBJECT AND PALETTE
FX_DIE   DIE

;DELAYED_TUNE
;         SLEEP   29H
;         BSOUND  1
;         DIE


STAR_Z   .SET    10

STAR_INIT
         .LONG   STR1,STW_PAL
         .WORD   0,DMAWNZ|M_NOSCROLL,OID_FX
         .WORD   0,0,0   ;STAR_Z

**************************************************************************
*                                                                        *
*  INCOMPLETE PASS EFFECT                                                *
*                                                                        *
**************************************************************************
FX_INCOM
         CALLA   UNCLIP
         MOVI    MA_INCOMPLETE,A11
         MOVI    INSOBJ3,A10
         CREATE  PID_FX,MULTIANI
         MOVE    A0,A11               ; SAVE PROC
         BSOUND  >54                  ; INCOMPLETE

         MOVI    >27,A0
         CALLA   FX_SHADOW_PRINT      ; PRINT: "INCOMPLETE PASS"
         SLEEP   >60
         MOVE    *A11(P_PREY),A8,L
         MOVI    >00020002,A11
         JSRP    SHRINK_WIN
         JRUC    FX_EXIT

**************************************************************************
*                                                                        *
*  BALL CAUGHT OUT OF BOUNDS EFFECT                                      *
*                                                                        *
**************************************************************************
FX_CAUGHTOOB
         MOVI    >31,A0
         CALLA   FX_SHADOW_PRINT
         MOVI    >26,A0
         CALLA   FX_SHADOW_PRINT
         MOVK    4,A11
         CREATE  PID_FX,RGBSTUFF      ; FLASH THE LETTERS

         BSOUND  >55                  ; SPEECH: OUT OF BOUNDS
         SLEEP   >70
         JRUC    FX_EXIT

**************************************************************************
*                                                                        *
*  NO GOOD REFEREE EFFECT                                                *
*                                                                        *
**************************************************************************
FX_NOGOOD
         CALLA   UNCLIP
         MOVI    MA_NOGOOD,A11
         MOVI    INSOBJ3,A10
         CREATE  PID_FX,MULTIANI
         MOVE    A0,A11               ; SAVE PROC
         BSOUND  >44                  ; NO GOOD !!
         SLEEP   >D0
         MOVE    *A11(P_PREY),A8,L
         MOVI    >00020002,A11
         JSRP    SHRINK_WIN
         JRUC    FX_EXIT


**************************************************************************
*                                                                        *
*  FIELD GOAL NO GOOD EFFECT                                             *
*                                                                        *
**************************************************************************
FX_FGN
         MOVI    P1STAT,A1
         MOVI    P3STAT,A2
         MOVE    A10,A10
         JREQ    FGN2                 ; TEAM 0 MISSED
         MOVI    P3STAT,A1
         MOVI    P1STAT,A2
FGN2     MOVE    *A1,A0,L
         JREQ    FGN_CHEER            ; DRONE TEAM MISSED ---> CHEER
         MOVE    *A2,A0,L         
         JREQ    FGN_BOO              ; HUMAN MISSED (VS DRONE) ---> BOO

FGN_CHEER
         PUSH    A10
         MOVI    MA_FGN0,A11
         MOVE    A10,A10
         JREQ    FGN3
         MOVI    MA_FGN1,A11          ; TEAM 1 FUCKED UP
FGN3     MOVI    INSOBJ3,A10
         CREATE  PID_FX,MULTIANI
         PULL    A10                  ; REF "NO GOOD" ON DORK SIDE

         BSOUND  >44                  ; NO GOOD !!
         SLEEP   >30

         MOVI    MA_NGCHEER1,A11
         MOVE    A10,A10
         JREQ    FGN4
         MOVI    MA_NGCHEER0,A11
FGN4     MOVI    INSOBJ3,A10
         CREATE  PID_FX,MULTIANI      ; CHEER ON "COOL" SIDE

         SLEEP   >06
         BSOUND  >23                  ; ROAR !!

FGNTO    CREATE  PID_FX,SHOW_TURNOVER
         SLEEP   >B0

         MOVI    SCRNST+>32,A0
         MOVE    A0,@SCRNTL3,L
         MOVE    A0,@SCRNTL2,L
         MOVI    SCRNEND->32,A0
         MOVE    A0,@SCRNLR3,L
         MOVE    A0,@SCRNLR2,L
         MOVK    1,A10
         MOVK    6,A11
         JSRP    WIPEOUT32_1

         MOVI    OBJLST2,A2
         CALLA   DELOLIST
         MOVI    OBJLST3,A2
         CALLA   DELOLIST
         CALLA   UNCLIP
         CALLA   KILLFX          ; STOP PROCS
         SLEEP   >20             ; PAUSE FOR SMOOTHNESS

         JRUC    FX_EXIT

FGN_BOO
         PUSH    A10
         MOVI    MA_FGN1,A11
         MOVE    A10,A10
         JREQ    FGN6
         MOVI    MA_FGN0,A11          ; TEAM 1 FUCKED UP
FGN6     MOVI    INSOBJ3,A10
         CREATE  PID_FX,MULTIANI
         PULL    A10                  ; REF "NO GOOD" ON DORK SIDE
         BSOUND  >44                  ; NO GOOD !!
         SLEEP   >30
         BSOUND  >24                  ; SPEECH: BOO !!

         MOVI    MA_FGPU0,A11
         MOVE    A10,A10
         JREQ    FGN7
         MOVI    MA_FGPU1,A11
FGN7     MOVI    INSOBJ3,A10
         CREATE  PID_FX,MULTIANI      ; BOO
         JRUC    FGNTO


**************************************************************************
*                                                                        *
*  TOUCHDOWN EFFECT #2                                                   *
*                                                                        *
**************************************************************************
TDFX2
         BSOUND  >27                  ; SOUND: WHISTLE / TOUCHDOWN !!
         MOVI    MA_REFTD,A11
         MOVI    INSOBJ2,A10
         CREATE  PID_FX,MULTIANI

         CLR     A9
         MOVK    9,A11
T2DOWN1  MOVI    TDLET_INIT,A14
         CALLA   INITOBJ
         MOVE    A11,A1
         DEC     A1
         SLL     5,A1
         ADDI    TD_IMAGES,A1
         MOVE    *A1,A1,L
         CALLA   ANI                  ; SHAPE THE LETTER
         MOVE    A9,A9
         JREQ    T2DOWN2

         MOVE    *A9(OCOLLIDE),A0,W
         MOVE    *A9(OSIZEX),A1,W
         ADD     A1,A0
         DEC     A0
         MOVE    A0,*A8(OXPOS),W
         
T2DOWN2  MOVE    A8,A9
         MOVE    *A8(OXPOS),*A8(OCOLLIDE),W
         CREATE  PID_FX,TD_SLIDE      ; MAKE SOMEONE TO SLIDE IT IN
         SLEEP   >6
         DSJ     A11,T2DOWN1

         SLEEP   >20
         CALLR   TD_SCORE_BOXES
         CALLR   TD_SCORES
         MOVI    letblu,A10
         MOVI    >04060200,A11
         CREATE  PID_FX,CYCLERF
         MOVI    letblu,A10
         MOVI    >0A060200,A11
         CREATE  PID_FX,CYCLERF
         CALLR   PLAY_TD_TUNE

         SLEEP   >70
         JRUC    FX_EXIT

TD_SLIDE
         MOVE    *A8(OXPOS),A11,W
         MOVE    A11,A0
         ADDI    SCRRGT,A0
         MOVE    A0,*A8(OXPOS),W
         MOVE    A8,A0
         CALLA   INSOBJ3

         MOVI    ->A0000,A0
         MOVE    A0,*A8(OXVEL),L
TDSL2    SLEEP   1
         MOVE    *A8(OXPOS),A0,W
         CMP     A0,A11
         JRLO    TDSL2
         CLR     A0
         MOVE    A0,*A8(OXVEL),L
         MOVE    A11,*A8(OXPOS),W
         DIE

**************************************************************************
*                                                                        *
*  TOUCHDOWN EFFECT #1                                                   *
*                                                                        *
**************************************************************************
TDFX1
         CREATE  PID_FX,TD_SCROLLER
         CALLA   UNCLIP
         BSOUND  >27                  ; SOUND: WHISTLE / TOUCHDOWN !!
         MOVI    MA_REFTD,A11
         MOVI    INSOBJ2,A10
         CREATE  PID_FX,MULTIANI

         MOVE    @RAND,A0,L
         JRN     FX_TD2               ; BE A BIT RANDOM !!!

         SLEEP   >30
         CALLR   TD_LETTERS
*
* CLIP UNMASKING EFFECT
*
         MOVI    SCRRGT/2,A10
         MOVE    A10,A11
TDOWN3   SUBK    12,A10
         ADDK    12,A11
         MOVE    A10,@SCRNTL3,W
         MOVE    A11,@SCRNLR3,W
         SLEEP   1
         CMPI    SCRRGT-8,A11
         JRLT    TDOWN3
         CALLA   UNCLIP

         SLEEP   >20
         CALLR   PLAY_TD_TUNE

         MOVI    MA_TDCHEER,A11
         MOVI    INSOBJ3,A10
         CREATE  PID_FX,MULTIANI      ; CHEERLEADER WINDOW
         SLEEP   >F0

         MOVI    OID_FX,A0
         CALLA   DALLOBJ              ; KILL ONLY WINDOW OBJECTS
         MOVI    PID_FX,A0
         CALLA   DALLPRC              ; AND THE FUCKING PROC YOU DORK !!!
         SLEEP   >C0
         JRUC    FX_EXIT

**************************************************************************
*                                                                        *
*  TOUCHDOWN EFFECT #2  (WITH ANNOUNCER)                                 *                *
*                                                                        *
**************************************************************************
FX_TD2
         MOVI    MA_TDANN,A11
         MOVI    INSOBJ2,A10
         CREATE  PID_FX,MULTIANI
         CALLR   TD_LETTERS

         MOVI    SCRRGT/2,A10
         MOVE    A10,A11
TDFX22   SUBK    12,A10
         ADDK    12,A11
         MOVE    A10,@SCRNTL3,W
         MOVE    A11,@SCRNLR3,W
         SLEEP   1
         CMPI    SCRRGT-8,A11
         JRLT    TDFX22
         CALLA   UNCLIP

         SLEEP   >20
         CALLR   PLAY_TD_TUNE
         SLEEP   >C0

         MOVI    OID_FX,A0
         CALLA   DALLOBJ              ; KILL ONLY WINDOW OBJECTS
         SLEEP   >E0
         JRUC    FX_EXIT

*
* "TOUCHDOWN" SCROLL TO CROWD
*
TD_SCROLLER
         SLEEP   >40*2
         MOVI    FIFTY_YARD-(SCRRGT/2),A1
         MOVI    >1B8,A3                   ; WE WANNA END UP HERE
         MOVK    4,A4                      ; AND TRAVEL THIS FAST
         JSRP    AUTOSCR                   ; LET THE AUTO SCROLLER HANDLE IT
         DIE


*
* SCORE BOXES AND "TOUCHDOWN" LETTERS
*
TD_LETTERS
         CALLR   TD_SCORE_BOXES
         CALLR   TD_SCORES

         MOVI    TD_IMAGES,A7
         CLR     A9
         MOVK    9,A3
         MOVI    TDLET_INIT,A14
TDOWN1   PUSH    A14
         CALLA   INITOBJ
         PULL    A14
         MOVE    A3,A1
         DEC     A1
         SLL     5,A1
         ADD     A7,A1
         MOVE    *A1,A1,L
         CALLA   ANI                  ; SHAPE THE LETTER
         MOVE    A9,A9
         JREQ    TDOWN2

         MOVE    *A9(OXPOS),A0,W
         MOVE    *A9(OSIZEX),A1,W
         ADD     A1,A0
         DEC     A0
         MOVE    A0,*A8(OXPOS),W
TDOWN2   MOVE    A8,A9
         MOVE    A8,A0
         CALLA   INSOBJ3
         DSJ     A3,TDOWN1

         MOVI    letblu,A10
         MOVI    >04060200,A11
         CREATE  PID_FX,CYCLERF
         MOVI    letblu,A10
         MOVI    >0A060200,A11
         CREATE  PID_FX,CYCLERF
         RETS

*
* SCORES
*
TD_SCORES
         MOVE    @T0SCORE,A1,W        
         MOVI    >13,A11              ; X COORDINATE FOR DIGIT
         MOVI    >6C,A3
         CALLR   TWO_BIG_DIG          ; TEAM 0 SCORE
         MOVI    OID_FX2,A4
         MOVE    A4,*A9(OID),W
         MOVE    A4,*A10(OID),W       ; DONT CONFUSE WITH OID_FX
         CALLR   A9A10_OBJLST3
         MOVE    @T1SCORE,A1,W        
         MOVI    >147,A11             ; FALL THROUGH TO "MAKE_2_DIGITS"
         MOVI    >6C,A3
         CALLR   TWO_BIG_DIG          ; TEAM 0 SCORE
         MOVI    OID_FX2,A4
         MOVE    A4,*A9(OID),W
         MOVE    A4,*A10(OID),W       ; DONT CONFUSE WITH OID_FX
         CALLR   A9A10_OBJLST3
         RETS


TD_SCORE_BOXES
         MOVI    L_SCOREBOX,A14
         CALLA   INITOBJ
         MOVE    A8,A0
         CALLA   INSOBJ3              ; ON LIST #3
         MOVE    A8,A9
         MOVI    R_SCOREBOX,A14
         CALLA   INITOBJ
         MOVE    A8,A0
         CALLA   INSOBJ3              ; ON LIST #3
         RETS

TD_IMAGES
         .LONG   HUGE_N
         .LONG   HUGE_W
         .LONG   HUGE_O
         .LONG   HUGE_D
         .LONG   HUGE_H
         .LONG   HUGE_C
         .LONG   HUGE_U
         .LONG   HUGE_O
         .LONG   HUGE_T

TDLET_INIT
         .LONG   HUGE_T,letblu
         .WORD   0,DMAWNZ|M_NOSCROLL,OID_FX2
         .WORD   >4C,>72,0

L_SCOREBOX
         .LONG   MENUSCORE,MENUPAL1
         .WORD   0,DMAWNZ|M_NOSCROLL,OID_FX2
         .WORD   >0C,>68,0

R_SCOREBOX
         .LONG   MENUSCORE,MENUPAL1
         .WORD   0,DMAWNZ|M_NOSCROLL,OID_FX2
         .WORD   >140,>68,0


PLAY_TD_TUNE
         MOVI    >60,A3
         CALLA   SEND_CODE_A3
         MOVI    >20,A3
         CALLA   SEND_CODE_A3         ; FULL VOLUME
         MOVI    9,A3
         JAUC    SEND_CODE_A3


*
* FORM LINKED LIST: A11 ---> A9
*
FORM_WINDOW
         CALLR   SETUP_WINDOW
         MOVE    A11,A9                    ; A9 = BACKDROP DUDE
PJSH00   PULLP   A2                        ; TAKE FROM LIST
         MOVE    A2,A2                     ; END OF LIST ?
         JREQ    PJSH0                     ; YES, EXIT
         MOVE    A2,*A9(OLINK),L           ; ADD TO A9 LIST
         MOVE    A2,A9
         JRUC    PJSH00
*
* ADD OBJECTS TO "OBJLST3"
*
PJSH0    MOVE    A11,A8
         MOVI    >0025002C,A1              ; A1 = INITIAL CLIPPING
         CALLR   WINDOW_CLIP               ; CLIP BEFORE PUTTING ON LIST

         MOVE    @OBJLST3,A0,L
         MOVE    A0,*A9(OLINK),L           ; END OF LIST ---> OBJLST3
         MOVE    A11,@OBJLST3,L            ; OBJLST3 ---> TOP OF LIST

         MOVI    >0025002C,A10             ; A10 = INITIAL CLIPPING
         MOVE    A14,A14
         JREQ    PJSH2                     ; NO MOVEMENT --> RETP

         MOVE    A14,A0
         SRA     16,A0
         MOVE    A0,*A13(P_GCOUNT),W       ; SAVE VELOCITY HERE
         SLL     16,A14
         SRL     16,A14                    ; A14 = # OF ITERATIONS
*
* CLIPPING / MOVEMENT
*
         MOVE    A11,A8                    ; CLIP ACCORDING TO BACKDROP
PJSH6    PUSHP   A14
         MOVE    A11,A3
PJSH7    MOVE    *A3(OXPOS),A2,W
         MOVE    *A13(P_GCOUNT),A5,W       ; VELOCITY
         ADD     A5,A2
         MOVE    A2,*A3(OXPOS),W           ; DO VELOCITY BY HAND
         MOVE    *A3(OLINK),A3,L
         JRNE    PJSH7
PJSH1    MOVE    A10,A1
         CALLR   WINDOW_CLIP
         SLEEP   1
         PULLP   A14
         DSJS    A14,PJSH6
PJSH2    RETP

*
* GROW THE WINDOW
* INPUT:  A8 = BACKDROP OBJECT
*        A11 = AMOUNT TO CLIP EACH TICK
*        A10 = INITIAL CLIPPING
*
GROW_WINDOW
         MOVE    A10,A1
         CALLR   WINDOW_CLIP
         SLEEP   1
         MOVE    A11,A0               ; A0 = AMOUNT TO CLIP EACH TICK
         SUBXY   A0,A10
         MOVE    A10,A1
         MOVE    A10,A2
         SLL     16,A1
         SRA     16,A1                ; A1 = X
         JRP     GROW_WINDOW          ; ANY CLIPPING AT ALL = LOOP
         SRA     16,A2                ; A2 = Y
         JRP     GROW_WINDOW          ; ANY CLIPPING AT ALL = LOOP
*
* SHOW FULL SCREEN
*
	MOVI	SCRNST,A0,L	     ; INIT SCREEN TOP LEFT [Y,X]
	MOVE	A0,@SCRNTL3,L
	MOVI	SCRNEND,A0,L	     ; INIT SCREEN LOWER RIGHT [Y,X]
	MOVE	A0,@SCRNLR3,L
         RETP

********************************************************************


FX_EXIT  CALLA   KILLFX
         DIE

**************************************************************************
*                                                                        *
*  SHRINK WINDOW                                                         *
*                                                                        *
*  Does the clipping trick to shrink a window to nothing.                *
*                                                                        *
*  Input: A8 = backdrop object                                           *
*        A11 = amount to clip away each tick.                            *
*                                                                        *
**************************************************************************
SHRINK_WIN
         CLR     A10                  ; INIT = NO CLIP
SHWIN2   ADDXY   A11,A10
         MOVE    A10,A1
         CALLR   WINDOW_CLIP
         SLEEP   1
         MOVE    *A8(OSIZEX),A0,W
         MOVE    *A8(OSIZEY),A1,W
         MOVE    A10,A2
         MOVE    A10,A3
         SLL     16,A2
         SRL     16,A2                ; A2 = X CLIP
         CMP     A0,A2                ; ANY MORE TO CLIP
         JRLT    SHWIN2               ; YES, DO MORE
         SRL     16,A3                ; A3 = Y CLIP
         CMP     A1,A3                ; ANY MORE TO CLIP
         JRLT    SHWIN2               ; YES, DO IT
         RETP

**************************************************************************
*                                                                        *
*  WINDOW CLIP                                                           *
*                                                                        *
*  INPUT: A1 = AMOUNT TO CLIP TL,LR CORNERS                              *
*         A8 = BACKDROP BLOCK TO USE                                     *
*                                                                        *
***************************************************************************
WINDOW_CLIP
         MOVE    *A8(OXPOS),A2,W
         MOVE    *A8(OYPOS),A3,W
         SLL     16,A2
         SRL     16,A2
         SLL     16,A3
         OR      A2,A3                     ; A3 = BOX [Y,X]
         ADDXY   A1,A3
         MOVE    A3,@SCRNTL3,L

         MOVE    *A8(OXPOS),A2,W
         MOVE    *A8(OYPOS),A3,W
         MOVE    *A8(OSIZEX),A4,W
         SLL     1,A4

         MOVE    *A8(OSIZEY),A5,W
         ADD     A4,A2                     ; A2 = BOTTOM RIGHT CORNER X
         ADD     A5,A3                     ; A3 = BOTTOM RIGHT CORNER Y
         SLL     16,A3
         OR      A2,A3                     ; A3 = BOTTOM CORNER BOX [Y,X]
         SUBXY   A1,A3
         MOVE    A3,@SCRNLR3,L
         RETS

**************************************************************************
*                                                                        *
*  SETUP WINDOW                                                          *
*                                                                        *
*  Creates a BACKDROP object and walks through a list of foreground      *
*  objects to animate.                                                   *
*                                                                        *
*  Input: A14 = init table for BACKDROP object                           *
*          A3 = table of foreground animations to run.                   *
*          A5 = x position (16 bits)                                     *
*          A6 = y position (16 bits)                                     *
*                                                                        *
*  Returns: all the objects created on the process stack.                *
*           A11 = backdrop object                                        *
*           A14 = velocity to give each window object                    *
*                                                                        *
**************************************************************************
SETUP_WINDOW
         CLR     A0
         PUSHP   A0                        ; ZERO SIGNALS ---> END O LIST
         CALLA   INITOBJ
         CALLR   POSITION_ME
         MOVE    *A8(OYPOS),A0,W
         INC     A0                        ; COMPENSATE FOR SMALLER "Z"
         MOVE    A0,*A8(OYPOS),W
         MOVE    A8,A11                    ; RETURN A11 = BACKDROP OBJECT

SETWIN3  MOVE    *A3+,A14,L                ; A14 ---> INIT TABLE
         JREQ    SETWIN9                   ; END OF ANIMATIONS TO MAKE
         CALLA   INITOBJ
         CALLR   POSITION_ME
         PUSHP   A8                        ; STACK IT !!
         MOVE    *A3+,A9,L                 ; A9 = ANIMATION TO USE
         JREQ    SETWIN4                   ; NO ANI ---> NO PROC
         MOVE    *A3,A10,W                 ; PASS A10 = SLEEP TIME
         CREATE  PID_FX,WINDOW_ANI
SETWIN4  ADDI    16,A3                     ; A3 ---> NEXT ENTRY
         JRUC    SETWIN3
SETWIN9  MOVE    *A3,A14,L                 ; A14 = VELOCITY / ITTERATIONS
         RETS

POSITION_ME
         MOVE    *A8(OXPOS),A0,W
         ADD     A5,A0
         MOVE    A0,*A8(OXPOS),W
         MOVE    *A8(OYPOS),A0,W
         ADD     A6,A0
         MOVE    A0,*A8(OYPOS),W           ; PUT WINDOW WHERE IT SHOULD BE
         RETS

**************************************************************************
*                                                                        *
*  WINDOW ANIMATOR                                                       *
*                                                                        *
*  INPUTS: A8 = OBJECT TO ANIMATE                                        *
*          A9 = ANIMATION FRAMES                                         *
*         A10 = SLEEP TIME BETWEEN TICKS                                 *
*                                                                        *
**************************************************************************
WINDOW_ANI
         MOVE    *A9,A1,L
         MOVE    *A8(OFLAGS),A4,W
         MOVE    *A9+,A1,L
         JREQ    WANI3
         CALLA   ANI
         MOVE    A10,A0
         CALLA   PRCSLP
         JRUC    WINDOW_ANI
WANI3    MOVE    *A9,A9,L
         JRUC    WINDOW_ANI


WINDOW_PLANE     .SET    300H
WINDOW_COLOR     .SET    0101H
BOARDER_COLOR    .SET    0202H

WINTEST
         RETS


PULL_OUT_A8
         MOVE    *A8(OSIZEX),A10,W
         SRA     1,A10                     ; 1ST X CLIP = ALL

PULL2    MOVE    A10,A1
         CALLR   WINDOW_CLIP
         SLEEP   1
         MOVI    >00000004,A0
         SUBXY   A0,A10
         MOVE    A10,A1
         MOVE    A10,A2
         SLL     16,A1
         SRA     16,A1                     ; A1 = X
         JRP     PULL2                     ; ANY CLIPPING AT ALL = LOOP
         RETP

SQUEEZE_IN_A8
         CLR     A10                       ; 1ST CLIP = NONE
SQU2     MOVE    A10,A1
         CALLR   WINDOW_CLIP
         SLEEP   1
         MOVI    >00000004,A0
         ADDXY   A0,A10
         MOVE    A10,A1
         MOVE    A10,A2
         SLL     16,A1
         SRA     16,A1                     ; A1 = X
         MOVE    *A8(OSIZEX),A0,W
         CMP     A0,A1
         JRLE    SQU2
         RETP

*
* BOARDER OFFSET
* A1 = [Y,X] OFFSETS
* A9 = BOARDER OBJECT
*
BOARDER_OFFSET
         MOVE    A1,A0
         SLL     16,A0
         SRL     16,A0                     ; A0 = X OFFSET
         SRL     16,A1                     ; A1 = Y OFFSET
         MOVE    *A9(OXPOS),A2,W
         ADD     A0,A2
         MOVE    A2,*A8(OXPOS),W
         MOVE    *A9(OYPOS),A2,W
         ADD     A1,A2
         MOVE    A2,*A8(OYPOS),W
         MOVK    2,A0
         MOVE    A0,*A8(OZVAL),L           ; NUDGE Z IN FRONT OF REST
         MOVE    A8,A0
         JAUC    INSOBJ3


GROW_WINDOW2 
         SLEEP   1
         MOVE    A11,A11
         JREQ    NOX
         DEC     A11
         MOVE    *A8(OSIZEX),A0,W
         ADDK    8,A0
         MOVE    A0,*A8(OSIZEX),W          ; BIGGER X
         MOVE    *A8(OXPOS),A0,W
         SUBK    4,A0
         MOVE    A0,*A8(OXPOS),W

NOX      MOVE    A10,A10
         JREQ    NOY
         DEC     A10
         MOVE    *A8(OSIZEY),A0,W
         ADDK    8,A0
         MOVE    A0,*A8(OSIZEY),W          ; BIGGER Y
         MOVE    *A8(OYPOS),A0,W
         SUBK    4,A0
         MOVE    A0,*A8(OYPOS),W

NOY      MOVE    A11,A0
         ADD     A10,A0
         JRNE    GROW_WINDOW
         RETP

TEAM_INIT
         .LONG   LA,LA_PAL
         .WORD   0,DMAWNZ|M_NOSCROLL,OID_FX
         .WORD   0,0,0
         
**************************************************************************
*                                                                        *
*  EXTRA POINT EFFECT                                                    *
*                                                                        *
**************************************************************************
EXTRAP
         MOVI    >1D,A0
         CALLA   FX_SHADOW_PRINT
         MOVK    5,A11
         CREATE  PID_FX,RGBSTUFF           ; FLASH THE LETTERS
         JAUC    WAIT_FOREVER

*
* SWITCH OBJECT LIST #3 TO OBJECT LIST #2
*
OBJ3TO2
         MOVE    @OBJLST3,A0,L
O321     MOVE    A0,A1
         MOVE    *A0(OLINK),A0,L           ; NEXT ??
         JRNE    O321                      ; NON-ZERO CONTINUE
         MOVE    @OBJLST2,A0,L
         MOVE    A0,*A1(OLINK),L           ; ADD TO TOP OF LIST #2
         MOVE    @OBJLST3,A0,L
         MOVE    A0,@OBJLST2,L             ; REPOINT TOP OF LIST #2
         CLR     A0
         MOVE    A0,@OBJLST3,L             ; EMPTY OLD LIST OUT
         RETS

**************************************************************************
*                                                                        *
*  MULTIANI                                                              *
*                                                                        *
*  Process to animate through multiple sequences at once. This is        *
*  a window utility.                                                     *
*                                                                        *
*  Input: A11 ---> master animation table                                *
*         A10 = which "INSERT OBJECT" routine to call                    *
*                                                                        *
**************************************************************************
MASTER_END       .SET    >FFFFFFFF
ANI_LOOP         .SET    1
ANI_END          .SET    2
ANI_JUMP         .SET    3


MULTIANIF
         MOVK    1,A0
         JRUC    MANI0

MULTIANI CLR     A0
MANI0    MOVE    A0,*A13(P_FACE),W    ; FLIP FLAG
         MOVE    *A11+,A0,W
         MOVE    A0,*A13(P_ANIRATE),W ; SAVE SLEEP TIME
         MOVE    *A11+,A0,W
         MOVE    A0,*A13(PLGOX),W     ; X OFFSET
         MOVE    *A11+,A0,W
         MOVE    A0,*A13(PLGOZ),W     ; Y OFFSET
*
* DO THE BACKGROUND "WINDOW" OBJECT
*
         MOVI    MANI_IMG,A14
         CALLA   INITOBJ
         MOVE    A8,*A13(P_PREY),L    ; STORE 1ST WINDOW IMAGE HERE

         MOVE    *A13(PLGOX),*A8(OXPOS),W
         MOVE    *A13(PLGOZ),A0
;        INC     A0
         MOVE    A0,*A8(OYPOS),W  
         CLR     A0
         MOVE    A0,*A8(OZPOS),W

         MOVE    *A11+,A1,L           ; WINDOW IMAGE
         CMPI    ANI_JUMP,A1          ; JUMP TO NEW ADDRESS ???
         JRNE    MANI1                ; NO
         MOVE    *A11+,A1,L           ; A1 = BACKGROUNDS IMAGE
         MOVE    *A11,A11,L           ; YES ---> REDIRECT A11
MANI1    MOVE    *A1(32*3),A0,L       ; A0 = PALETTE TO USE
         PUSH    A0
         CALLA   GETFPAL              ; GET ONE
         MOVE    A0,*A8(OPAL),W
         CALLR   WANI
         MOVE    A8,A0
         CALL    A10                  ; CALL THE "INSERT OBJECT" ROUTINE
*
* HACK TOGETHER THE "SPLIT WINDOW" BRAIN DAMMAGE
*
         MOVE    A8,A9                ; A9 = RIGHT SIDE WINDOW
         MOVI    MANI_IMG,A14
         CALLA   INITOBJ
         PULL    A0                   ; WINDOW PALETTE
         CALLA   GETFPAL
         MOVE    A0,*A8(OPAL),W
         MOVE    *A9(OIMG),*A8(OIMG),L
         MOVE    A8,*A9(OSLINK),L     ; LINK WINDOW HALFS TOGETHER
         MOVE    A9,*A8(OSLINK),L     ; LINK WINDOW HALFS TOGETHER
         CALLA   YFLP                 ; LEFT WINDOW = FLIPPED RIGHT WINDOW
         MOVE    *A9(OYPOS),*A8(OYPOS),W
         MOVE    *A9(OZPOS),*A8(OZPOS),W
         MOVE    *A9(OXPOS),A0,W
         MOVE    *A8(OSIZEX),A1,W
         SUB     A1,A0
         MOVE    A0,*A8(OXPOS),W      ; POSITION LEFT WINDOW NEXT TO RIGHT
         MOVE    A8,*A13(P_PREY),L    ; CLIP BASED ON "LEFT" SIDE
         MOVE    A8,A0
         CALL    A10                  ; CALL THE "INSERT OBJECT" ROUTINE

*
* SETUP ANIMATIONS
*
MANISET
         CLR     A9
MANI3    MOVE    *A11,A8,L            ; ANIMATION ??
         CMPI    MASTER_END,A8
         JREQ    MANI7                ; DONE...
         MOVI    MANI_IMG,A14
         CALLA   INITOBJ
         MOVE    *A13(P_FACE),A0,W
         JREQ    MANIX2               ; NO FLIP
         ORI     M_FLIPH,A4
         MOVE    A4,*A8(OFLAGS),W     ; FLIP IMAGE         

MANIX2   MOVE    A9,A9                ; 1ST IMAGE ?
         JRNE    MANI5                ; NO
         MOVE    A8,*A13(P_SWITCH),L  ; YES, REMEMBER IT
         JRUC    MANI2
MANI5    MOVE    A8,*A9(OSLINK),L     ; NO, LINK TO THE LAST ONE
MANI2    CLR     A0
         MOVE    A0,*A8(OSLINK),L     ; ASSUME END OF LIST
         MOVE    A8,A9                ; SAVE

         MOVE    *A13(PLGOX),*A8(OXPOS),W
         MOVE    *A13(PLGOZ),A0,W
         DEC     A0
         MOVE    A0,*A8(OYPOS),W      ; Y OFFSET - 1

         MOVE    *A11,A1,L            ; GET 1ST IMAGE
         MOVE    *A8(OPAL),A0,W       ; PALETTE DEFINED YET ???
         JRNE    MANI21               ; YES, SKIP
         MOVE    *A1(32*3),A0,L       ; A0 = PALETTE TO USE
         CALLA   GETFPAL              ; NO ---> GET ONE
         MOVE    A0,*A8(OPAL),W
MANI21   CALLA   ANI
         MOVE    A11,*A8(OCOLLIDE),L  ; SAVE TABLE POINTER HERE
         MOVE    A11,*A8(OXACC),L     ; SAVE 1ST FRAME POINTER HERE
         MOVE    A8,A0
         CALL    A10

MANI4    MOVE    *A11+,A0,L
         JRNE    MANI4                ; SEARCH FOR ZERO
         ADDI    32,A11               ; NEXT COMMAND
         MOVE    *A11,A0,L
         CMPI    MASTER_END,A0        ; END OF ALL ????
         JRNE    MANI3                ; NOPE...
*
* DO THE ANIMATIONS
*
MANI_ANI
         MOVE    *A13(P_SWITCH),A8,L  ; GET OBJECT #1
MANI9    MOVE    *A8(OCOLLIDE),A2,L
         JREQ    MANI8                ; ZERO ---> LEAVE IMAGE ALONE

         MOVE    *A2+,A1,L            ; A1 = NEW IMAGE
         JREQ    MANI6                ; ZERO ---> SPECIAL CODE
         MOVE    *A8(OFLAGS),A4,W
         CALLA   ANI
         MOVE    A2,*A8(OCOLLIDE),L   ; SAVE NEXT IMAGE POINTER
         JRUC    MANI8

MANI6    MOVE    *A2,A1,L             ; A1 = COMMAND
         CMPI    ANI_LOOP,A1
         JREQ    MANI7                ; ANI LOOP
         CLR     A0
         MOVE    A0,*A8(OCOLLIDE),L   ; NO MORE ANI'S
         JRUC    MANI8

MANI7    MOVE    *A8(OXACC),A0,L
         MOVE    A0,*A8(OCOLLIDE),L   ; RESET ANI POINTER
         JRUC    MANI9                ; DO NEXT FRAME RIGHT AWAY
         
MANI8    MOVE    *A8(OSLINK),A8,L
         JRNE    MANI9
         MOVE    *A13(P_ANIRATE),A0,W ; RESTORE SLEEP TIME
         CALLA   PRCSLP
         JRUC    MANI_ANI

*
* ANI WHICH CHECKS BOUNDARIES OF IMAGE POINTER
*
WANI
         CMPI    FXLEGAL1,A1
         JRLO    WANI_ERROR
         CMPI    FXLEGAL2,A1
         JRHS    WANI_ERROR           ; MAKE SURE THIS IMAGE IS LEGIT
         JAUC    ANI                  ; COOL ---> ANI YER ASS OFF

WANI_ERROR
         ERMAC   61


MANI_IMG
         .LONG   MULTI_DUMB,0
         .WORD   0,DMAWNZ|M_NOSCROLL,OID_FX
         .WORD   0,0,1

MULTI_DUMB
	.word	0,0,0,0                   ; SIZE, ANI POINTS
	.long	DUMB_IMG                  ; IMG DATA POINTER
	.long	DUMB_IMG                  ; PALETTE

**************************************************************************
*                                                                        *
*  MULTIWINDOW MASTER ANIMATION TABLES                                   *
*                                                                        *
**************************************************************************
MA_AWESOME_UL
         .WORD   >0A,>60,>10
         .LONG   ANI_JUMP,winsize1,AWESOME_FRAMES

MA_AWESOMEL
         .WORD   >0A,>60,>99
         .LONG   ANI_JUMP,winsize1,AWESOME_FRAMES

MA_AWESOMEH
         .WORD   >0A,>120,>10
         .LONG   winsize1
AWESOME_FRAMES
         .LONG   bighead1
         .LONG   bighead1
         .LONG   bighead1,bighead2,bighead2,bighead2,bigbod1,bigbod1,bigbod1
         .LONG   bigbod1,bigbod1
         .LONG   0,ANI_END
         .LONG   TDANN_DUMB
         .LONG   TDANN_DUMB
         .LONG   TDANN_DUMB,TDANN_DUMB,TDANN_DUMB,TDANN_DUMB,bighead3
         .LONG   bighead3,bighead3,bighead3,bighead4
         .LONG   0,ANI_END
         .LONG   >FFFFFFFF

MA_TDANN
         .WORD   >08,>50,>A0
         .LONG   winsize1
         .LONG   bigbod1
         .LONG   bigbod1
         .LONG   bigbod1
         .LONG   bigbod1
         .LONG   bigbod1,TDANN_DUMB,TDANN_DUMB,bigbod1,0,ANI_END
         .LONG   bighead3
         .LONG   bighead3
         .LONG   bighead3
         .LONG   bighead3
         .LONG   bighead3,bighead1,bighead1,bighead5,bighead5,bighead6
         .LONG   bighead6,bighead6,bighead6,bighead6,bighead6,bighead4
         .LONG   0,ANI_END
         .LONG   >FFFFFFFF

TDANN_DUMB
	.word	0,0,0,0         ; SIZE, ANI POINTS
	.long	DUMB_IMG        ; IMG DATA POINTER
	.long	bghedpal        ; PALETTE


MA_WHADDAH
         .WORD   >07,>110,>08
         .LONG   ANI_JUMP,winsize1,WHADDA_FRAMES
MA_WHADDAL
         .WORD   >07,>58,>90
         .LONG   winsize1
WHADDA_FRAMES
         .LONG   whatbod1
         .LONG   whatbod1
         .LONG   whatbod1,whatbod2,whatbod3,0,ANI_END
         .LONG   WHA_DUMB
         .LONG   WHA_DUMB
         .LONG   WHA_DUMB,wltarm1,wltarm2,0,ANI_END
         .LONG   WHA_DUMB
         .LONG   WHA_DUMB
         .LONG   WHA_DUMB,wrtarm1,wrtarm2,0,ANI_END
         .LONG   WHA_DUMB
         .LONG   WHA_DUMB
         .LONG   WHA_DUMB,WHA_DUMB,wlthand,0,ANI_END
         .LONG   WHA_DUMB
         .LONG   WHA_DUMB
         .LONG   WHA_DUMB,WHA_DUMB,wrthand2,0,ANI_END
         .LONG   WHA_DUMB
         .LONG   WHA_DUMB
         .LONG   WHA_DUMB,WHA_DUMB,whathed3,whathed2,whathed1
         .LONG   whathed2,whathed3,0,ANI_END
         .long   >FFFFFFFF         

WHA_DUMB
	.word	0,0,0,0         ; SIZE, ANI POINTS
	.long	DUMB_IMG        ; IMG DATA POINTER
	.long	whattpal        ; PALETTE

****************************************

MA_FGPU0
         .WORD   >0A,>70,>99
         .LONG   ANI_JUMP,HALFBLUR,PU_FRAMES

MA_FGPU1
MA_PU1
         .WORD   >0A,>120,>99
         .LONG   ANI_JUMP,HALFBLUR,PU_FRAMES
MA_PU0
         .WORD   >0A,>70,>99
         .LONG   HALFBLUR
PU_FRAMES
         .LONG   stkhand1,stkhand2,stkhand3,0,ANI_LOOP
         .LONG   stnkarm1,stnkarm2,stnkarm3,0,ANI_LOOP
         .LONG   stnkhed1,stnkhed2,stnkhed3,0,ANI_LOOP
         .LONG   stnksut1,stnksut2,stnksut3,0,ANI_LOOP
         .LONG   >FFFFFFFF

MA_MAD1
         .WORD   >8,>110,>99
         .LONG   ANI_JUMP,HALFBLUR,MAD_FRAMES

MA_MAD0
         .WORD   >8,>70,>99
         .LONG   HALFBLUR
MAD_FRAMES
         .LONG   COCHMAD1,COCHMAD2,COCHMAD3,0,ANI_LOOP
         .LONG   >FFFFFFFF


MA_FIRST1_DOWN
         .WORD   8,>120,>10
         .LONG   ANI_JUMP,HALFBLUR,FD_FRAMES

MA_FIRST0_DOWN
         .WORD   8,>50,>10
         .LONG   HALFBLUR
FD_FRAMES
         .LONG   REF_1DOWN1A
         .LONG   REF_1DOWN1A
         .LONG   REF_1DOWN1A
         .LONG   REF_1DOWN1A
         .LONG   REF_1DOWN1A
         .LONG   REF_1DOWN1A
         .LONG   REF_1DOWN1A,REF_1DOWN2A,REF_1DOWN3A,0,ANI_END
         .LONG   REF_1DOWN1B
         .LONG   REF_1DOWN1B
         .LONG   REF_1DOWN1B
         .LONG   REF_1DOWN1B
         .LONG   REF_1DOWN1B
         .LONG   REF_1DOWN1B
         .LONG   REF_1DOWN1B,REF_1DOWN2B,REF_1DOWN3B,0,ANI_END
         .LONG   >FFFFFFFF

MA_FGN0
         .WORD   >07,>70,>99
         .LONG   ANI_JUMP,HALFBLUR,NOGOOD_FRAMES

MA_FGN1
         .WORD   >07,>120,>99
         .LONG   ANI_JUMP,HALFBLUR,NOGOOD_FRAMES

MA_INCOMPLETE
         .WORD   >07,>70,>99
         .LONG   ANI_JUMP,HALFBLUR,NOGOOD_FRAMES

MA_NOGOOD
         .WORD   8,>80,>10
         .LONG   HALFBLUR
NOGOOD_FRAMES
         .LONG   REF_NGOOD1,REF_NGOOD2A,REF_NGOOD3A,0,ANI_LOOP
         .LONG   NG_DUMB,REF_NGOOD2B,REF_NGOOD3B,0,ANI_LOOP
         .LONG   NG_DUMB,REF_NGOOD2C,REF_NGOOD3C,0,ANI_LOOP
         .LONG   >FFFFFFFF

NG_DUMB
	.word	0,0,0,0         ; SIZE, ANI POINTS
	.long	DUMB_IMG        ; IMG DATA POINTER
	.long	REFNG_PA        ; PALETTE

MA_REFTD
         .WORD   8,>120,>0D
         .LONG   HALFBLUR
TD_FRAMES
         .LONG   REF_TD1A
         .LONG   REF_TD1A
         .LONG   REF_TD1A
         .LONG   REF_TD1A,REF_TD2A,REF_TD3A,0,ANI_END
         .LONG   REF_TD1B
         .LONG   REF_TD1B
         .LONG   REF_TD1B
         .LONG   REF_TD1B,REF_TD2B,REF_TD3B,0,ANI_END
         .LONG   REF_TD1C
         .LONG   REF_TD1C
         .LONG   REF_TD1C
         .LONG   REF_TD1C,REF_TD2C,REF_TD3C,0,ANI_END
         .LONG   >FFFFFFFF


MA_NGCHEER0
         .WORD   >07,>70,>99
         .LONG   ANI_JUMP,HALFBLUR,CHEER_FRAMES

MA_NGCHEER1
         .WORD   >07,>120,>99
         .LONG   ANI_JUMP,HALFBLUR,CHEER_FRAMES


MA_TDCHEER
         .WORD   8,>50,>A0
         .LONG   HALFBLUR
CHEER_FRAMES
         .LONG   CHEER1A,CHEER2A,CHEER3A,0,ANI_LOOP
         .LONG   CHEER1B,CHEER2B,CHEER3B,0,ANI_LOOP
         .LONG   CHEER1C,CHEER2C,CHEER3C,0,ANI_LOOP
         .LONG   >FFFFFFFF

*****************************************

MA_FUCKINA2
         .WORD   8,>120,>9D
         .LONG   ANI_JUMP,HALFBLUR,FUCKINA_FRAMES
MA_FUCKINA1
         .WORD   8,>60,>9D
         .LONG   HALFBLUR
FUCKINA_FRAMES
         .LONG   high51A,high52A,high53,0,ANI_LOOP
         .LONG   high51B,high52B,FUK_DUMB,0,ANI_LOOP
         .LONG   high51C,high52C,FUK_DUMB,0,ANI_LOOP
         .LONG   >FFFFFFFF

FUK_DUMB
	.word	0,0,0,0         ; SIZE, ANI POINTS
	.long	DUMB_IMG        ; IMG DATA POINTER
	.long	coachpal        ; PALETTE

*****************************************

MA_MOON1
         .WORD   8,>110,>99
         .LONG   ANI_JUMP,HALFBLUR,MOON_FRAMES

MA_MOON0
         .WORD   >0A,>70,>99
         .LONG   HALFBLUR
MOON_FRAMES
         .LONG   moon1
         .LONG   moon1
         .LONG   moon1
         .LONG   moon1,moon2,moon3
         .LONG   moon2,moon3
         .LONG   moon2,moon3
         .LONG   moon2,moon3
         .LONG   0,ANI_END
         .LONG   >FFFFFFFF

MA_COACH_YEA2
         .WORD   8,>120,>9D
         .LONG   ANI_JUMP,HALFBLUR,COACHY_FRAMES

MA_COACH_YEA1
         .WORD   8,>60,>9D
         .LONG   HALFBLUR
COACHY_FRAMES
         .LONG   yeasuit1,yeasuit2,yeasuit3,0,ANI_LOOP
         .LONG   yeahead1,yeahead2,yeahead3,0,ANI_LOOP
         .LONG   yelthnd1,yelthnd2,yelthnd3,0,ANI_LOOP
         .LONG   yerthnd1,yerthnd2,yerthnd3,0,ANI_LOOP
         .LONG   >FFFFFFFF

MA_SHAKE1
         .WORD   >06,>110,>99
         .LONG   ANI_JUMP,HALFBLUR,SHAKE_FRAMES

MA_SHAKE0
         .WORD   >06,>70,>99
         .LONG   HALFBLUR
SHAKE_FRAMES
         .LONG   EJBSHAKE1,EJBSHAKE2,EJBSHAKE3,0,ANI_LOOP
         .LONG   PJSHAKE1,PJSHAKE2,PJSHAKE3,0,ANI_LOOP
         .LONG   >FFFFFFFF

MA_BAGMAN1
         .WORD   >09,>110,>99
         .LONG   ANI_JUMP,HALFBLUR,BAG_FRAMES

MA_BAGMAN0
         .WORD   >09,>70,>99
         .LONG   HALFBLUR
BAG_FRAMES
         .LONG   COCHBAG1
         .LONG   COCHBAG1
         .LONG   COCHBAG1
         .LONG   COCHBAG1,COCHBAG2A,COCHBAG3A,0,ANI_END
         .LONG   BAG_DUMB
         .LONG   BAG_DUMB
         .LONG   BAG_DUMB
         .LONG   BAG_DUMB,COCHBAG2B,COCHBAG3B,0,ANI_END
         .LONG   >FFFFFFFF

BAG_DUMB
	.word	0,0,0,0         ; SIZE, ANI POINTS
	.long	DUMB_IMG        ; IMG DATA POINTER
	.long	CBAG_PAL        ; PALETTE


**************************************************************************
*                                                                        *
*  WIPEOUT3_1                                                            *
*                                                                        *
*  Wipes from the left/right edges "inwards" using 2 vertical lines.     *
*                                                                        *
*  Input: A10 = sleep time to use                                        *
*         A11 = # of pixels each tick [0,x]                              *
*                                                                        *
**************************************************************************
WIPEOUT3_1
	MOVE	@SCRNTL3,A8,L	; INIT SCREEN TOP LEFT [Y,X]
	MOVE	@SCRNLR3,A9,L	; INIT SCREEN LOWER RIGHT [Y,X]
WIPEO31  ADD     A11,A8
         SUB     A11,A9          ; CLIPPY
         MOVE    A9,A0
         SLL     16,A0
         SRL     16,A0
         CMP     A8,A0
         JRLS    WIPEO32         ; WEEZ DONE
	MOVE	A8,@SCRNTL3,L
	MOVE	A9,@SCRNLR3,L
         MOVE    A10,A0
         CALLA   PRCSLP
         JRUC    WIPEO31
WIPEO32  RETP

**************************************************************************
*                                                                        *
*  WIPEOUT32_1                                                           *
*                                                                        *
*  Wipes from the left/right edges "inwards" using 2 vertical lines.     *
*                                                                        *
*  Input: A10 = sleep time to use                                        *
*         A11 = # of pixels each tick [0,x]                              *
*                                                                        *
**************************************************************************
WIPEOUT32_1
	MOVE	@SCRNTL3,A8,L	; INIT SCREEN TOP LEFT [Y,X]
	MOVE	@SCRNLR3,A9,L	; INIT SCREEN LOWER RIGHT [Y,X]
WIPEO321 ADD     A11,A8
         SUB     A11,A9          ; CLIPPY
         MOVE    A9,A0
         SLL     16,A0
         SRL     16,A0
         CMP     A8,A0
         JRLS    WIPEO322        ; WEEZ DONE
	MOVE	A8,@SCRNTL3,L
	MOVE	A8,@SCRNTL2,L
	MOVE	A9,@SCRNLR3,L
	MOVE	A9,@SCRNLR2,L
         MOVE    A10,A0
         CALLA   PRCSLP
         JRUC    WIPEO321
WIPEO322 RETP

**************************************************************************
*                                                                        *
*  ANIMATION TABLES                                                      *
*                                                                        *
**************************************************************************
*
* FAN WINDOW #1
*
A_FAN1
         .long   FANWIN1A
         .long   FANWIN1B
         .long   FANWIN1C
         .long   0
         .long   A_FAN1


**************************************************************************
*                                                                        *
*  TANIA PROC                                                            *
*                                                                        *
*  This process handles making all the cheerleaders on the field         *
*  animate.                                                              *
*                                                                        *
**************************************************************************
TANIA_PROC
         MOVK    1,A0
         MOVE    A0,@TANIAF,W         ; SIGNAL ---> TANIA PROCESS IS ALIVE

         MOVI    TANIA_PALETTES,A11

         CLR     A9
         MOVK    5,A10                ; # OF CHEERLEADERS ON FIELD
         MOVI    LGOAL_IN_X+(PIX_PER_YARD*28),A6
TANIAP2  MOVI    TANIA_INIT,A14
         CALLA   INITOBJ
         MOVE    *A11+,A0,L           ; GET A PALLETE
         CALLA   GETFPAL
         MOVE    A0,*A8(OPAL),L       ; USE IT

         CALLA   GROUND_PLAYER        ; SET Y
         MOVE    A6,*A8(OXPOS),W
         MOVE    A9,*A8(OSLINK),L     ; LINK 'EM TOGETHER
         MOVE    A8,A0
         CALLA   INSOBJ
         MOVE    A8,A9
         ADDI    PIX_PER_YARD*3,A6    ; NEXT X POSITION
         DSJ     A10,TANIAP2

         MOVK    5,A10                ; # OF CHEERLEADERS ON FIELD
         MOVI    RGOAL_IN_X-(PIX_PER_YARD*28),A6
TANIAP3  MOVI    TANIA_INIT,A14
         CALLA   INITOBJ
         MOVE    *A11+,A0,L           ; GET A PALLETE
         CALLA   GETFPAL
         MOVE    A0,*A8(OPAL),L       ; USE IT

         CALLA   GROUND_PLAYER        ; SET Y
         MOVE    A6,*A8(OXPOS),W
         MOVE    A9,*A8(OSLINK),L     ; LINK 'EM TOGETHER
         MOVE    A8,A0
         CALLA   INSOBJ
         MOVE    A8,A9
         SUBI    PIX_PER_YARD*3,A6    ; NEXT X POSITION
         DSJ     A10,TANIAP3
         MOVE    A8,A11               ; A11 = CHEERLEADER #1
         
         MOVE    @TANIAR,A0,L         ; SPECIAL ROUTINE ?
         JREQ    TANIAP4              ; NOPE...
         JUMP    A0                   ; YES ---> RUN IT
*
* ANIMATE 'EM
*
TANIAP4  MOVI    A_SIDE,A9
         MOVI    >00140008,A10
         JSRP    CHEERANI
         MOVI    A_KICK,A9
         MOVI    >001A0005,A10
         JSRP    CHEERANI
         MOVI    A_JUMP,A9
         MOVI    >000A0006,A10
         JSRP    CHEERANI
         JRUC    TANIAP4
         
TANIA_INIT
         .LONG   CHEERSIDE1,0
         .WORD   0,DMAWNZ,OID_TANIA
         .WORD   0,0,TOP_SIDELINE-30

TANIA_PALETTES
         .LONG   HFTMER_P
         .LONG   afrorpal
         .LONG   HFTMER_P
         .LONG   HFTMER_P
         .LONG   afrorpal             ; RED TEAM

         .LONG   HFTIME_P
         .LONG   afrobpal
         .LONG   HFTIME_P
         .LONG   afrobpal
         .LONG   afrobpal             ; BLUE TEAM

;TANIA2_INIT
;         .LONG   CHEERSIDE1,HFTMER_P
;         .WORD   0,DMAWNZ,OID_TANIA
;         .WORD   0,0,TOP_SIDELINE-30

TD_TANIA
         MOVI    A_JUMP,A9
         MOVI    >02000006,A10
         JSRP    CHEERANI
         JRUC    TD_TANIA

*
* ANIMATE A LIST OF CHEERLEADERS
*
CHEERANI
         MOVE    A10,A0
         SRL     16,A0
         MOVE    A0,*A13(P_GCOUNT),W       ; FRAME COUNT
CHANI1   MOVE    A11,A8
         MOVE    *A9,A1,L
CHANI2   MOVE    *A8(OFLAGS),A4,W
         CALLA   ANI
         MOVE    *A8(OSLINK),A8,L          ; EACH ONE !!
         JRNE    CHANI2
         MOVE    A10,A0         
         SLL     16,A0
         SRL     16,A0
         CALLA   PRCSLP
         ADDI    32,A9
         MOVE    *A9,A1,L
         JRNE    CHANI4
         MOVE    *A9(32),A9,L              ; ZERO ---> GET POINTER TO BEGIN
CHANI4   MOVE    *A13(P_GCOUNT),A0,W
         DEC     A0
         MOVE    A0,*A13(P_GCOUNT),W
         JRNE    CHANI1
         RETP

*
* MAKE 2 BIG DIGITS
* RETURNS: A9 = #1
*         A10 = #2
*
TWO_BIG_DIG
         PUSH    A1
         MOVI    DIGIT_INIT,A14
         CALLA   INITOBJ
         MOVE    A8,A9                ; A9 = DIGIT #1
         MOVI    DIGIT_INIT,A14
         CALLA   INITOBJ
         MOVE    A8,A10               ; A10 = DIGIT #2
         PULL    A1

         CMPI    99,A1
         JRLE    TWO2
         MOVI    99,A1
TWO2
         MOVE    A1,A2                ; SAVE ORIGINAL
         MOVI    10,A0
         DIVS    A0,A1                ; A1 = TENS !!
         MOVE    A1,A7
         SLL     5,A7
         ADDI    BIG_DIGITS,A7        ; A7 = TENS ENTRY TABLE
         MPYS    A0,A1                ; A1 = ONLY TENS
         SUB     A1,A2                ; A2 = ONES
         SLL     5,A2
         ADDI    BIG_DIGITS,A2        ; A2 = ONES TABLE ENTRY

         MOVE    A3,*A9(OYPOS),W
         MOVE    A11,*A9(OXPOS),W
         MOVE    *A7,A1,L             ; A1 = NEW OIMG
         MOVE    A9,A8                ; A8 --> OBJECT BLOCK
         MOVE    *A9(OFLAGS),A4,W     ; A4 = FLAGS
         CALLA   ANI

         MOVE    A3,*A10(OYPOS),W
         ADDI    25,A11               ; DIGIT #2 DISTANCE = WIDTH
         MOVE    A11,*A10(OXPOS),W
         MOVE    *A2,A1,L             ; A1 = OIMG
         MOVE    A10,A8               ; A8 --> OBJECT BLOCK
         MOVE    *A10(OFLAGS),A4,W    ; A4 = FLAGS
         CALLA   ANI
         RETS

DIGIT_INIT
         .LONG   num0,frame
         .WORD   0,DMAWNZ|M_NOSCROLL,OID_FX
         .WORD   0,0,0

A9A10_OBJLST3
         MOVE    A9,A0
         CALLA   INSOBJ3
         MOVE    A10,A0
         JAUC    INSOBJ3

A9A10_OBJLST2
         MOVE    A9,A0
         CALLA   INSOBJ2
         MOVE    A10,A0
         JAUC    INSOBJ2

A9A10_OBJLST
         MOVE    A9,A0
         CALLA   INSOBJ
         MOVE    A10,A0
         JAUC    INSOBJ

HIDELIST3
         CLR     A0
         MOVE    A0,@SCRNTL3,L
         MOVE    A0,@SCRNLR3,L         ; DONT SHOW ANY OBJLST3
         RETS


**************************************************************************
*                                                                        *
*  GAME INTRO WINDOW ANIMATIONS                                          *
*                                                                        *
**************************************************************************
MA_INTCHEER
         .WORD   >07,->40,>89
         .LONG   ANI_JUMP,HALFBLUR,CHEER_FRAMES

MA_INTREFTD
         .WORD   >07,->40,>89
         .LONG   ANI_JUMP,HALFBLUR,TD_FRAMES

MA_INTYEA
         .WORD   >07,->40,>89
         .LONG   ANI_JUMP,HALFBLUR,COACHY_FRAMES

MA_INTFD
         .WORD   >07,->40,>89
         .LONG   ANI_JUMP,HALFBLUR,FD_FRAMES

MA_CANT_HEAR
         .WORD   >0D,->40,>89
         .LONG   winsize1
         .LONG   bigbod1
         .LONG   bigbod1
         .LONG   bigbod1
         .LONG   bighead1,bigbod1,bigbod1,bigbod1,bigbod1,bighead2,0,ANI_END
         .LONG   bighead3
         .LONG   bighead3
         .LONG   bighead3
         .LONG   TDANN_DUMB,bighead3,bighead3,bighead6,bighead6,TDANN_DUMB
         .LONG   0,ANI_END
         .LONG   >FFFFFFFF


MA_LOFEOQ
         .WORD   >07,>50,>80
         .LONG   ANI_JUMP,HALFBLUR,LOF_FRAMES

MA_LOFNUM1
         .WORD   >08,>1E0,>51
         .LONG   HALFBLUR
LOF_FRAMES
         .LONG   markfan1,markfan2,0,ANI_LOOP
         .LONG   mltarm1,mltarm2,0,ANI_LOOP
         .LONG   mrtarm1,mrtarm2,0,ANI_LOOP
         .LONG   mwere1,0,ANI_END
         .LONG   >FFFFFFFF

MA_HT_CHEER1
         .WORD   >08,>1E0,>51
         .LONG   ANI_JUMP,HALFBLUR,CHEER_FRAMES

MA_HTYEA
         .WORD   >07,>1E0,>51
         .LONG   ANI_JUMP,HALFBLUR,COACHY_FRAMES

MA_HTAWESOME
         .WORD   >0A,>1E0,>51
         .LONG   winsize1
         .LONG   bighead1
         .LONG   bighead1
         .LONG   bighead1
         .LONG   bighead1
         .LONG   bighead1,bighead2,bighead2,bighead2,bigbod1,bigbod1,bigbod1
         .LONG   bigbod1,bigbod1
         .LONG   0,ANI_END
         .LONG   TDANN_DUMB
         .LONG   TDANN_DUMB
         .LONG   TDANN_DUMB
         .LONG   TDANN_DUMB
         .LONG   TDANN_DUMB,TDANN_DUMB,TDANN_DUMB,TDANN_DUMB,bighead3
         .LONG   bighead3,bighead3,bighead3,bighead4
         .LONG   0,ANI_END
         .LONG   >FFFFFFFF


MA_HT_CHEER2
         .WORD   >05,>1E0,>51
         .LONG   HALFBLUR
         .LONG   NCHEER1A
         .LONG   NCHEER1A
         .LONG   NCHEER1A
         .LONG   NCHEER1A
         .LONG   NCHEER1A
         .LONG   NCHEER1A
         .LONG   NCHEER1A
         .LONG   NCHEER1A
         .LONG   NCHEER1A
         .LONG   NCHEER1A,NCHEER2A,NCHEER3A
         .LONG   NCHEER3A
         .LONG   NCHEER3A
         .LONG   NCHEER3A
         .LONG   NCHEER2A,NCHEER1A
         .LONG   NCHEER1A
         .LONG   NCHEER1A
         .LONG   NCHEER1A
         .LONG   NCHEER2A,NCHEER3A
         .LONG   NCHEER3A
         .LONG   NCHEER3A
         .LONG   NCHEER2A,NCHEER1A
         .LONG   0,ANI_END

         .LONG   NCHEER1B
         .LONG   NCHEER1B
         .LONG   NCHEER1B
         .LONG   NCHEER1B
         .LONG   NCHEER1B
         .LONG   NCHEER1B
         .LONG   NCHEER1B
         .LONG   NCHEER1B
         .LONG   NCHEER1B
         .LONG   NCHEER1B,NCHEER2B,NCHEER3B
         .LONG   NCHEER3B
         .LONG   NCHEER3B
         .LONG   NCHEER3B
         .LONG   NCHEER2B,NCHEER1B
         .LONG   NCHEER1B
         .LONG   NCHEER1B
         .LONG   NCHEER1B
         .LONG   NCHEER2B,NCHEER3B
         .LONG   NCHEER3B
         .LONG   NCHEER3B
         .LONG   NCHEER2B,NCHEER1B
         .LONG   0,ANI_END

         .LONG   NCHEER1C
         .LONG   NCHEER1C
         .LONG   NCHEER1C
         .LONG   NCHEER1C
         .LONG   NCHEER1C
         .LONG   NCHEER1C
         .LONG   NCHEER1C
         .LONG   NCHEER1C
         .LONG   NCHEER1C
         .LONG   NCHEER1C,NCHEER2C,NCHEER3C
         .LONG   NCHEER3C
         .LONG   NCHEER3C
         .LONG   NCHEER3C
         .LONG   NCHEER2C,NCHEER1C
         .LONG   NCHEER1C
         .LONG   NCHEER1C
         .LONG   NCHEER1C
         .LONG   NCHEER2C,NCHEER3C
         .LONG   NCHEER3C
         .LONG   NCHEER3C
         .LONG   NCHEER2C,NCHEER1C
         .LONG   0,ANI_END
         .LONG   >FFFFFFFF

MA_HT_CHEER3
         .WORD   >0A,>40,>51
         .LONG   HALFBLUR
         .LONG   NCHEER1A,NCHEER2A,NCHEER3A,0,ANI_LOOP
         .LONG   NCHEER1B,NCHEER2B,NCHEER3B,0,ANI_LOOP
         .LONG   NCHEER1C,NCHEER2C,NCHEER3C,0,ANI_LOOP
         .LONG   >FFFFFFFF
         
MA_HT_CHEER4
         .WORD   >0A,>145,>51
         .LONG   HALFBLUR
         .LONG   CHEER1A,CHEER2A,CHEER3A,0,ANI_LOOP
         .LONG   CHEER1B,CHEER2B,CHEER3B,0,ANI_LOOP
         .LONG   CHEER1C,CHEER2C,CHEER3C,0,ANI_LOOP
         .LONG   >FFFFFFFF

MA_HT_LOF2
         .WORD   >08,>C0,>51
         .LONG   ANI_JUMP,HALFBLUR,LOF_FRAMES
