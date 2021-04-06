****************************************************************
*
* Software:	?
* Modified:	Shawn Liptak 8/6/91 - Hiscore display and entry
*
* COPYRIGHT (C) 1991 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 9/25/91 14:22
****************************************************************

	.FILE	'ATTRACT.ASM'
	.TITLE	"ATTRACT MODE"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

	.INCLUDE	"MPROC.EQU"		;MPROC EQUATES
	.INCLUDE	"DISP.EQU"		;DISPLAY PROC. EQUATES
	.INCLUDE	"\VIDEO\SYS\SYS.INC"	;Z UNIT SYSTEM EQUATES
	.INCLUDE	"\VIDEO\SYS\GSP.INC"
	.INCLUDE	"MAC2.ASM"		;MACRO 2 DEFINITIONS
	.INCLUDE	"IMGTBL.GLO"
	.INCLUDE	"BGNDTBL.GLO"		;BACKGROUND EQUATES
	.INCLUDE	"GAME.EQU"
	.INCLUDE	"AUDIT.EQU"
	.include	"shawn.hdr"		;Macros


;SOUNDS

	.REF	TOTCARN,BEEP1,BEEP2,CNTDOWN
	.REF	PLYRONE,PLYRTWO,MUSICOFF

; SYMBOLS DEFINED IN THIS FILE

	.DEF	SYSINITL,WIPEOUT,STATUS,ATSTRT,P1START,P2START,ENTERON
	.DEF	NO_START,THIS_PLYR,RUNIN
	.def	hisclong

; SYMBOLS DEFINED EXTERNALLY

	.REF	timerp1,timerp1sd,timerp2,timerp2sd,TNT_TYPE,DELAYALL
	.REF	TAUNTOUT,TWAS1,KP_TAUNT,PLYRPRCS
	.REF	GAMERASE,GAMSTATE,P1DATA,P2DATA,COLRPRC,HALT,CLRBPAL,KILBGND
	.REF	BAKMODS,BGND_UD1,BLAKOUT,KILL_CRD,CLR_SCRN,MAPOUT,MAPDN
	.REF	CR_CONTP,P_CONT,CR_STRTP,P_START,SOUNDSUP,WSPEED,WFLG,BOX_OUT
	.REF	WNDWON,CRD_SCRN,IRQSKYE,CLRPAL,PLYROBJS,AUTOEON,KPARWP,WORDS
	.REF	GETFPAL,AUTOEOFF,DMAQWAIT,CLRSWPRC,MYOINIT,AUD1,INFO_BOX
	.REF	CLRWORLD,SYNCFULL,SYSCOPY,GET_ADJ,CYCLE_TABLE,INIT_GAME
	.REF	P1CTRL,P2CTRL,GET_OUT,SCORETYP,BCDADD,SCORETYP,TBOMB
	.REF	DRAW_PLYR_TORSO,CNTDIG1,CNTDIG2,KILLP1,KILLP2,SCRIPTPLAY
	.REF	WARPOUT
	.ref	HISCBMOD,COLTAB,GETHIGH,PALSET,FPALRAM
	.ref	SYNCHALF
	.REF	FADE_DOWN,FADE_UP,FADEIN,FADEOUT


;RAM AREA FOR THIS FILE

	.BSS	RUNIN,16
	.BSS	STATUS,16		;PLAYERS 0,1,2,3
	.BSS	ENTERON,16		;INITIALS BEING ENTERD FLAG
	.BSS	NO_START,16		;FLAG 0=OKAY, 1=NOT RIGHT NOW.
	.BSS	THIS_PLYR,16		;FLAG = 1/2 FOR PLYR WHO BOUGHT IN

	.bss	palram	,11*15*16	;Palette mem
	.bss	hisclong,16		;!0=Show hiscore table longer

OWSPD	.SET	21    ;31	;OPEN WINDOW SPEED  (HIGHER THE SLOWER)


	.TEXT

**************************************************************************
*									 *
* WIPEOUT - WIPES THE SYSTEM CLEAR OF ALL OTHER PROCESSES, OBJECTS	 *
*	  AND COORDINATES. IT RETURNS WITH AUTO-ERASE SHUT OFF,		 *
*	  DISPLAY PROCESSOR DISABLED
*	  COLOR RAM CLEARED, AND THE BIT MAP WIPED CLEAN.		 *
*	  THIS IS NICE TO USE WHEN SWITCHING BETWEEN STUFF.		 *
**************************************************************************
WIPEOUT
	MMTM	SP,A0,A1
	CLR	A0
;	MOVE	A0,@SCORE_FLAG,W	;INSURE SCORE DMA IS NOT PERFORMED
	MOVE	A0,@WFLG
	MOVE	A0,@P1CTRL,W
	MOVE	A0,@P2CTRL,W		;CLEAR PLAYER CPU CONTROLS
	MOVE	A0,@P1DATA+POBJ,L
	MOVE	A0,@P2DATA+POBJ,L
;	MOVE	A0,@PLAYPAGE,W		;CLEAR THE ATTRACT MODE PLAY PAGE
	MOVI	PLIST_ID,A1
	CLR	A0
	CALLA	KILALL			;KILL ALL PROCS, EXCEPT FOR COINS
	CALLA	KILBGND			;WIPEOUT BACKGROUND BLOCKS
	CLR	A0
	MOVE	A0,@SOUNDSUP,W		;MAKE SURE SOUNDS ARE ALLOWED
	MOVE	A0,@GAMERASE,W
	MOVE	A0,@IRQSKYE,W
	CALLA	AUTOEOFF
;	CLR	A0
;	MOVE	A0,@DISPLAYON,W		;TURN THE DISPLAY PROCESSOR OFF
	CALLA	DMAQWAIT
	PUSHST
	DINT
	CALLA	CLRSWPRC
	CALLA	MYOINIT			;RE-INIT THE OBJECT LIST
	CALLA	CLRWORLD		;RESET THE WORLD
	CALLR	SYSINITL
	CALLA	CLR_SCRN
	POPST
	CALLA	SYNCFULL		;NOW WAIT FOR VBLANK TO ZAP COLOR MAP
	MOVI	0FFFCH,A0
	MOVE	A0,@DPYSTRT		;RESET DISPLAY START POINT
	MMFM	SP,A0,A1
	MOVI	OWSPD,A0
	MOVE	A0,@WSPEED
	RETS

**************************************************************************
*									 *
* SYSINITL - INITIALIZE LOW BYTE OF SYSTEM CONTROL REGISTER		 *
*									 *
**************************************************************************
SYSINITL
	MMTM	SP,A0,A1
	MOVE	@SYSCOPY,A0,W
	MOVI	SYSCINIT,A1
	SLL	24,A1
	SRL	24,A1
	OR	A1,A0
	MOVE	A0,@SYSCOPY,W		;RE-INITIALIZE SYSTEM CONTROL REG
	MOVE	A0,@SYSCTRL,W
	MMFM	SP,A0,A1
	RETS


TITLE	.long	TITLEBMOD		;THIS IS FROM BLIMP (MODULE NAME)
	.WORD	9H,03EAH		;x,y start pos.
	.LONG	>FFFFFFFF


;ATTRACT MODE START UP ROUTINE

ATSTRT
	MOVK	1,A0
	MOVE	A0,@GAMERASE
	MOVE	@GAMSTATE,A0
	CMPI	INDIAG,A0
	JREQ	ATSTRTX
	MOVI	INAMODE,A0
	MOVE	A0,@GAMSTATE,W
	CALLA	COLRPRC
	CREATE	AMDEPID,AMODE		;CREATE THE ATTRACT MODE
	CLR	A0
	MOVE	A0,@HALT
	MOVE	A0,@ENTERON
ATSTRTX
	RETS

; CYCLE BETWEEN MODES

AMODE
	JSRP	HSTDTABQ	;Show high scores with quick blindin

amode2	JSRP	TITLPAGE	;DISPLAY TITLE (SPLASH SCREEN) PAGE
	CALLA	CLRBPAL
;	JSRP	ATTPLAY 	;DO SOME ATTRACT MODE PLAY STUFF
;	SLEEPK	1
;	CALLA	CLRBPAL
;	JSRP	LOGOSC
	JSRP	DO_CRD_SCRN	;DISPLAY INSERT COIN SCREEN
	CALLA	CLRBPAL
;	JSRP	TITLPAGE	;DISPLAY TITLE (SPLASH SCREEN) PAGE
;	JSRP	HSTDTAB		;Show high scores
;	JSRP	ATTPLAY		;DO SOME ATTRACT MODE PLAY STUFF
;	JSRP	DO_CRD_SCRN	;CREDIT INFO SCREEN
;	CALLA	CLRBPAL
;	JSRP	HSTDTAB		;Show high scores
;	JSRP	TITLPAGE	;DISPLAY TITLE (SPLASH SCREEN) PAGE
;	CALLA	CLRBPAL
;	JSRP	ATTPLAY		;DO ATTRACT MODE DEMO PLAY
	MOVI	AMDEPID,A0
	MOVE	A0,*A13(PROCID),W
	JSRP	HSTDTAB		;Show high scores
	jruc	amode2

;KILCYC
;	MOVI	COLRPID,A0
;	CLR	A1
;	NOT	A1
;	CALLA	KILALL		;KILL COLOR SPECTRUM COLOR CYCLE
;	MOVI	CYCPID,A0	;KILL INDIVIDUAL COLOR CYCLERS
;	CALLA	KILALL
;	RETS

TITLPAGE:
;	JSRP	WNDWON
;	CALLA	KILBGND			;KILL OLD BACKGROUND IF ANY EXISTED
;	MOVI	CLSNEUT|TYPTEXT|SUBWNDW,A0
;	CLR	A1
;	NOT	A1
;	CALLA	KILOBJ
;	CLR	A0
;	MOVE	A0,@WFLG

;	CALLR	KILCYC

;	MOVI	[2,1],A8		;START AT COLOR 2, CYCLE 1 COLOR
;	MOVI	TPGPAL,A9		;PAL NAME
;	MOVI	TPG_TBL,A10		;TABLE TO CYCLE WITH
;	MOVK	2,A11			;RATE OF CYCLE IN TICKS
;	CREATE	CYCPID,CYCLE_TABLE	;START PROCESS TO DO CYCLE

	MOVI	TITLE,A0
	MOVE	A0,@BAKMODS,L
	CALLA	BGND_UD1

;SOUNDS OFF IN DEMO
	ADJUST	ADJMUSIC	;GET MUSIC ON OFF FOR DEMO
	MOVE	A0,A0
	JRNZ	NONO
;SOUND ALLOWED IN ATTRACT MODE
	MOVI	yousuck,A0
	CALLA	ONESND
NONO
	
	SLEEP	60*6
	RETP
yousuck	.word	>f9a0,10,>80c5,0		;You suck at this game!

;TPG_TBL
;;GOTTEN FROM WIMP DUMP TO PALSRC.ASM (PALCRNCH IT!)
;	.word	>144F,>1450,>1451,>1452,>1453,>1454,>1455
;	.word	>1456,>1457,>1458,>1459,>145A,>145B,>145C,>145D
;	.word	>145E,>145F,>145E,>145D,>145C,>145B,>145A,>1459
;	.word	>1458,>1457,>1456,>1455,>1454,>1453,>1452,>1451
;	.WORD	-1     	;BECAUSE IT IS ONLY 1 COLOR
;COPY IT AGAIN!
;	.word	>144F,>1450,>1451,>1452,>1453,>1454,>1455
;	.word	>1456,>1457,>1458,>1459,>145A,>145B,>145C,>145D
;	.word	>145E,>145F,>145E,>145D,>145C,>145B,>145A,>1459
;	.word	>1458,>1457,>1456,>1455,>1454,>1453,>1452,>1451
;
DO_CRD_SCRN
	JSRP	CRD_SCRN		;SHOW CREDITS SCREEN SUPERIMPOSED
	SLEEP	5*60
	CALLA	KILL_CRD
	CALLA	CLR_SCRN
	RETP

**************************************************************************
*									 *
* PxSTART - PLAYER START SWITCH PROCESSES				 *
*									 *
**************************************************************************
*PLAYER 1 START
P1START:
	MOVE	@TAUNTOUT,A1
	JRZ	P1TAG0
IN2
;CHECK TO SEE IF TAUNT IN RACKUP
	MOVE	@TNT_TYPE,A0
	CMPI	1,A0			;1=RACKUP
	JAZ	SUCIDE
	MOVE	@KP_TAUNT,A0,L
	CMPI	1,A1
	JRNZ	TNT1
	MOVI	TWAS1,A7
	CALLA	XFERPROC
	DIE

TNT1	MOVK	3,A0			;GET OUT OF TAUNT!
	MOVE	A0,@TAUNTOUT
	DIE
P1TAG0	MOVE	@INFO_BOX,A0,L
	JRZ	P1TAG
P2IN2
;INFO BOX IS OUT, TAKE IT OFF, IGNORE THIS START!
	MOVI	BOX_OUT,A7
	CALLA	XFERPROC
	JAUC	SUCIDE

P1TAG
	MOVE	@WFLG,A0	     ;WINDOW GROW FLAG
	JANZ	SUCIDE
	MOVE	@ENTERON,A0		;NEVER START WHEN INITIALS BEING
	JANZ	SUCIDE			;ENTERED
	MOVE	@MAPOUT,A0,L
	JRZ	P1OK
P2IN
;MAP IS OUT, TAKE IT OFF, IGNORE THIS START!
	MOVI	MAPDN,A7
	CALLA	GETA8
	CALLA	GETA9
	CALLA	GETA10
	CALLA	XFERPROC
	CLR	A0
	MOVE	A0,@MAPOUT,L
	JAUC	SUCIDE
P1OK	MOVE	@STATUS,A0		;1/2 OR 3 FOR WHO IS PLAYING NOW
	BTST	0,A0			;TEST IF 0 BIT IS SET (1)
	JRZ	P1A
	MOVE	@GAMSTATE,A0
	CMPI	ININTRO,A0
	JRZ	INTRO_EXIT
	MOVE	@WARPOUT,A0
	JRZ	ABM
	CMPI	1,A0
	JRNZ	SUCIDE
WRPIN	MOVE	@KPARWP,A0,L
	MOVE	*A0(PDATA),A10		;INDEX 0-5
;CHECK FOR RIGHT SIDE OF SCREEN
;SCRN EDGE OK
	CMPI	4,A10
	JRZ	DONE
	INC	A10
	MOVE	A10,*A0(PDATA)
	MOVI	BEEP1,A0
	CALLA	ONESND
	JAUC	SUCIDE
ABM
;PLACE TIME BOMB HERE
	MOVE	@PLYRPRCS,A0,L
	MOVE	*A0(DEAD),A0
	JRNZ	YESSND
	MOVK	1,A9
	MOVE	@P1DATA+BMB_CNT,A0
	JRZ	YESSND
;PLACE BOMB ON GROUND
	MOVE	@P1DATA+BMBSUSED,A0
	INC	A0
	MOVE	A0,@P1DATA+BMBSUSED
	CREATE	BMBPID,TBOMB
	DIE
DONE	MOVK	1,A0
	MOVE	A0,@WORDS+4*16
	DIE
P1A
;NOT ALREADY IN GAME, SEE IF WE CAN START P1 UP!
	MOVI	P1DATA,A2
	JRUC	PXSTART

*PLAYER 2 START
P2START:
	MOVE	@TAUNTOUT,A1
	JRNZ	IN2
	MOVE	@INFO_BOX,A0,L
	JRNZ	P2IN2
	MOVE	@WFLG,A0	     ;WINDOW GROW FLAG
	JANZ	SUCIDE
	MOVE	@ENTERON,A0		;INITIALS BEING ENTERED
	JANZ	SUCIDE
	MOVE	@MAPOUT,A0,L
	JRNZ	P2IN
	MOVE	@STATUS,A0		;1/2 OR 3 FOR WHO IS PLAYING NOW
	BTST	1,A0			;TEST IF 1 BIT IS SET (2)
	JRZ	P2A
	MOVE	@GAMSTATE,A0
	CMPI	ININTRO,A0
	JRZ	INTRO_EXIT
	MOVE	@WARPOUT,A0
	JRZ	NOW
	CMPI	2,A0
	JRZ	WRPIN
	DIE
NOW
;PLACE TIME BOMB HERE
	MOVE	@PLYRPRCS+32,A0,L
	MOVE	*A0(DEAD),A0
	JRNZ	YESSND
	MOVK	2,A9
	MOVE	@P2DATA+BMB_CNT,A0
	JRZ	YESSND
;PLACE BOMB ON GROUND
	MOVE	@P2DATA+BMBSUSED,A0
	INC	A0
	MOVE	A0,@P2DATA+BMBSUSED
	CREATE	BMBPID,TBOMB
	DIE
YESSND	
	MOVI	BEEP2,A0		;NO BOMBS LEFT SND
	CALLA	ONESND
	DIE
P2A
;NOT ALREADY IN GAME, SEE IF WE CAN START P2 UP!
	MOVI	P2DATA,A2

PXSTART:
	MOVE	@GAMSTATE,A0,W
	CMPI	INGAMEOV,A0
	JRZ	SUCIDE
	CMPI	INDIAG,A0
	JRNE	PSTARTG
;GAME IN DIAGNOSTICS MODE!  DO NOT START A GAME.
	DIE

INTRO_EXIT
;IF IN INTRO, TELL CODE TO EXIT EARLY.
;TELL INTRO TO STOP NOW!
	CLR	A1
	NOT	A1
	MOVI	INTROPID,A0
	CALLA	EXISTP
	JAZ	SUCIDE
;YES, FOUND INTRO PROC
	MOVI	GET_OUT,A7		;WAKE UP AT GET_OUT
	CALLA	XFERPROC
	DIE
DEC_DIGIT
;MAYBE DEC BUYIN TIMER FASTER!
	MOVE	@CNTDIG1,A0
	CMPI	2,A0
	JRC	DEC1
	DEC	A0
	MOVE	A0,@CNTDIG1
	MOVI	CNTDOWN,A0
	CALLA	ONESND
DEC1	
	MOVE	@CNTDIG2,A0
	CMPI	2,A0
	JRC	DEC2
	DEC	A0
	MOVE	A0,@CNTDIG2
	MOVI	CNTDOWN,A0
	CALLA	ONESND
DEC2	DIE

PSTARTG:
	CMPI	INAMODE,A0
	JREQ	PXSTRTNEW		;BR=FRESH START FROM ATTRACT MODE
;NOT IN ATTRACT MODE, TRY A CONTINUE!
	CALLA	CR_CONTP		;CONTINUATION, SEE IF ENOUGH CRD. FOR
	JALO	DEC_DIGIT		;A CONTINUE
	CALLA	P_CONT			;AUDIT CREDITS (TAKE THEM AWAY!)

	CMPI	P1DATA,A2
	JRNE	P2STARTA

;THIS IS PLAYER 1 BUYING IN TO A GAME IN PROGRESS (OR A CONTINUE)
;IF GAME IS NOT SHOWING PLAYFIELD AREA, VOCALLY INDICATE PLAYER HAS BOUGHT
;IN BUT DELAY HIS CREATION UNTIL PLAYFIELD SCREEN IS SHOWN.  IF HE NEEDS TO
;APPREAR IN A VIEWSCRN OR SOMETHING, THEN THAT IS A SPECIAL CASE TURN ON
;OF THE PLAYER.

	MOVI	PLYRONE,A0		;WELCOME PLAYER 1 AUDIO
	CALLA	ONESND
	CALLR	SET_P1BUYIN
	MOVI	P1DATA,A11
	CALLR	GET_LIVES
	MOVE	@CNTDIG1,A0
	JRNZ	NO_ZER
	CALLR	ZERO_STATS
NO_ZER
	MOVI	DG1PID,A0
	CLR	A1
	MOVE	A1,@CNTDIG1
	MOVE	A1,*A11(CNTD)		;CNTDWN FLAG
	NOT	A1
	CALLA	KILALL
;ZERO COUNTDOWN DIGIT FOR PLYR 1
	DIE
ZERO_STATS
	MOVK	3,A0
	MOVE	A0,*A11(BMB_CNT)
	CLR	A0
	MOVE	A0,*A11(CASHCNT),W
	MOVE	A0,*A11(TFLAGS),W	;US FLAGS PICKED UP
	MOVE	A0,*A11(PSCORE),L
	MOVE	A0,*A11(THSTGS)		;TOTAL HOSTAGES
	MOVE	A0,*A11(THITS)		;TOTAL SUCCESSFUL SHOTS FIRED
	MOVE	A0,*A11(TWPNS)		;TOTAL WEAPONS PICKED UP
	MOVE	A0,*A11(TEARNED)       	;TOTAL EXTRA MEN EARNED
	MOVE	A0,*A11(BMBSUSED)      	;TOTAL BOMBS/CRUISE MISSILES USED
	MOVE	A0,*A11(TBIGSTF)      	;TOTAL BIG STUFF DESTROYED
	MOVE	A0,*A11(TMISLS)      	;TOTAL MISSILE STRIKES CALLED IN
	MOVE	A0,*A11(TMINEDTH)      	;TOTAL LAND MINE DEATHS
	MOVE	A0,*A11(TSHOTS)		;TOTAL SHOTS FIRED
	MOVE	A0,*A11(TKEYS)		;TOTAL KEYS COLLECTED
	CMPI	P1DATA,A11
	JRZ	P1TIMR
	MOVE	A0,@timerp2
	MOVE	A0,@timerp2sd		;Player 1 seconds since death
	RETS
P1TIMR	MOVE	A0,@timerp1
	MOVE	A0,@timerp1sd		;Player 1 seconds since death
	RETS
P2STARTA
	MOVI	PLYRTWO,A0		;WELCOME PLAYER 2 AUDIO
	CALLA	ONESND
	CALLR	SET_P2BUYIN
	MOVI	P2DATA,A11
	CALLR	GET_LIVES
	MOVE	@CNTDIG2,A0
	JRNZ	NO_ZER2
	CALLR	ZERO_STATS
NO_ZER2
	MOVI	DG2PID,A0
	CLR	A1
	MOVE	A1,@CNTDIG2
	MOVE	A1,*A11(CNTD)		;CNTDWN FLAG
	NOT	A1
	CALLA	KILALL
	DIE

SET_P1BUYIN:
	AUDIT	AUD1CONT		;AUDIT PLYR 1 CONTINUE
	MOVK	1,A2
	MOVK	1,A8
	MOVI	P1PID,A0
	JRUC	SET_OUT

SET_P2BUYIN:
	AUDIT	AUD2CONT		;AUDIT PLYR 2 CONTINUE
	MOVK	2,A2
	MOVK	2,A8
	MOVI	P2PID,A0
SET_OUT
	MOVE	A8,@THIS_PLYR		;FLAG FOR BUY IN BOX CLOSE DOWN
	CLR	A1
	NOT	A1
	CALLA	KILALL			;KILL SCOREBOARD MESSAGE PROCESS
	MOVE	@STATUS,A1
	OR	A2,A1			;TELL STATUS WORD THAT PLYR X IS ON!
	MOVE	A1,@STATUS
	MOVE	@SCORETYP,A1
	OR	A2,A1
	MOVE	A1,@SCORETYP		;FOR DISPLAYING OF SCORES OR TEXT
	CREATE	0,ALL_PLYR_STUFF
	RETS

ALL_PLYR_STUFF:
;A8=1 OR 2 FOR PLYR
;IF FLAG SET, DELAY TURN ON OF NEW PLAYER UNTIL FLAG CLEARED
	MOVE	@GAMSTATE,A0
	CMPI	ININTRO,A0		;IF IN INTRO, THE REGULAR START UP
	JRZ	ALL_OUT 		;CODE WILL START THIS PLAYER!
;IN GAME!  TRY TO START.	
	MOVE	@NO_START,A0
	JREQ	OKAY			;DELAY START FOR SOME REASON.
;PLAYER TRYED TO START WHEN WE DON'T WANT HIM TO.
;DELAY STARTING PLAYER UNTIL WE RESET NO_START FLAG TO 0.
	CREATE	0,DELAY_START
	DIE

DELAY_START:
	SLEEPK	1
	MOVE	@NO_START,A0
	JRNE	DELAY_START		;LOOP UNTIL FLAG RESET
;FALL IN HERE WHEN IT IS OKAY TO START A PLAYER
OKAY:
;OKAY TO TRY AND START THIS PLAYER RIGHT NOW.
;A8=1 OR 2 FOR START STUFF
;START PLAYER AT BOTTOM OF SCREEN - IN SAFE SPOT.
	CMPI	1,A8
	JRNZ	NEXT1
	CALLA	KILLP1			;KILL OLD PLYR1 IF ANY
	CREATE	PLY1PID,DRAW_PLYR_TORSO
	MOVE	@WORLDTLY,A3,L
	CMPI	[127EH,0],A3
	JRZ	ALL_OUT			;BR=STARTING AT PARACHUTES!
	MOVE	@RUNIN,A10,W		;INDICATES FROM BOTTOM OR LEFT
;A10=0 FOR COME IN FROM BOTTOM
	CREATE	SCRPID,SCRIPTPLAY
	DIE
NEXT1	CALLA	KILLP2			;KILL OLD PLYR2 IF ANY
	CREATE	PLY2PID,DRAW_PLYR_TORSO
	MOVE	@WORLDTLY,A3,L
	CMPI	[127EH,0],A3
	JRZ	ALL_OUT			;BR=STARTING AT PARACHUTES!
	MOVE	@RUNIN,A10,W		;INDICATES FROM BOTTOM OR LEFT
;A10=0 FOR COME IN FROM BOTTOM
	CREATE	SCRPID,SCRIPTPLAY
ALL_OUT:
	DIE



*****************************************************************************


PXSTRTNEW
	CALLA	CR_STRTP		;CHECK FOR ENOUGH CREDITS TO START
	JALO	SUCIDE			;BR=NOPE!
	CALLA	P_START			;AUDIT CREDITS (TAKE THEM AWAY!)
;NEW START FROM ATTRACT MODE, ZERO BOTH SCORES!
	MOVE	A2,A11
	CALLR	GET_LIVES		;GET LIVES PER CREDIT
;	CLR	A0



;	MOVI	P2DATA,A11
;	CALLR	SET_1ST
;	MOVI	P1DATA,A11
;	CALLR	SET_1ST

	CMPI	P1DATA,A2		;IS THIS A PLYR 1 OR 2 START BUTTON?
	JRZ	P1GAME

;PLYR2 FALLS IN HERE

**************************************************************************
* PLAYER 2 GAME START - COLD FROM ATTRACT MODE OR GAME OVER MODE	 *
**************************************************************************
	MOVK	2,A1			;A1 IS P2 FLAG FOR STATUS
	AUDIT	AUD2STRT		;AUDIT A PLAYER 2 START
	JRUC	GAMESTR

**************************************************************************
* PLAYER 1 GAME START - COLD FROM ATTRACT MODE OR GAME OVER MODE	 *
**************************************************************************
P1GAME:
	MOVK	1,A1			;A1 IS P1 FLAG FOR STATUS
	AUDIT	AUD1STRT		;AUDIT A PLAYER 1 START

GAMESTR:
;GAME START PROCESS
;A1 = PLAYERS TO START,1 = PLAYER 1,2 = PLAYER 2
	MOVE	A1,@STATUS,W
	MOVE	A1,@SCORETYP,W
	MOVI	ININTRO,A0		;NOT IN ATTRACT MODE ANYMORE!
	MOVE	A0,@GAMSTATE,W		;FLAG ININTRO

;POSSIBLY DO SOME OTHER KIND OF WIPE (NOT WNDON) IF FROM CREDITS SCREEN!

	MOVI	CP_PID2,A0		;ARE WE SHOWING THE CREDIT PAGE?
	CLR	A1
	NOT	A1
	CALLA	KILALL
	MOVI	CP_PID1,A0		;ARE WE SHOWING THE CREDIT PAGE?
	CALLA	KILALL
	MOVI	AMDEPID,A0		;ARE WE SHOWING THE CREDIT PAGE?
	CALLA	KILALL

	MOVI	TOTCARN,A0		;WELCOME PLAYER AUDIO
	CALLA	ONESND

	JSRP	WNDWON			;GROW WINDOW

	CLR	A0
	MOVE	A0,@IRQSKYE		;BACKGROUND COLOR

	CALLA	CLRPAL
	SLEEPK	1
	CALLR	WIPEOUT			;CLEAN SYSTEM OUT

	MOVK	1,A0
	MOVE	A0,@GAMERASE		;AUTOERASE FLAG

	CALLA	AUTOEON
	CALLA	COLRPRC			;INIT FIXED PAL 0 AND MAYBE 2ND PAL

	SLEEPK	2			;8/1/91
	CREATE	INTROPID,INIT_GAME	;INITIALIZE GAMEPLAY
	DIE

GET_LIVES:
;A11=P1/P2DATA
	ADJUST	ADJLIVES		;GET LIVES PER GAME
	DEC	A0
	MOVE	A0,*A11(PLIVES),W
	MOVE	*A11(BMB_CNT),A0
	cmpi	18,A0			;CAN CARRY MAXIMUM OF 20 BMBS
	JRNC	NOADD
	ADDK	3,A0
	MOVE	A0,*A11(BMB_CNT)	;BOMBS PER CREDIT
NOADD
;SET RAM PTS AREA TO START
	CLR	A0
	MOVE	A0,*A11(PTSRAM),W
	RETS


;SET_1ST
;;FIRST FREE MAN AT X POINTS
;;A11=P1 OR P2DATA AREA
;	MMTM	SP,A0,A1
;	CALLR	ZERO_STATS
;	MOVI	>100000,A1		;FIRST FREE MAN AT 100000
;	CALLR	BCDADD
;	MOVE	A0,*A11(PNEXTREP),L
;	MMFM	SP,A0,A1
;	RETS


********************************
* Show high score tables


 SUBRP	HSTDTABQ

	clr	a0
	jruc	hst5

 SUBRP	HSTDTAB

	movk	1,a0
hst5	move	a0,-*a12

	clr	a0
	move	a0,@GAMERASE
	movi	->ff4,a0		;Start display at bottom of screen
	move	a0,@DPYSTRT
	JSRP	WNDWON
	calla	KILBGND			;Kill old background
	SLEEPK	1
	clr	a1
	calla	KILOBJ			;Kill all objs (Screen mem is clr)
	calla	COLRPRC

	movi	FPALRAM+PALRSIZ,a2	;>Steal pals 1-3
	movi	junkp,a1
	movk	3,a3
hst30	move	a1,*a2+,L
	dsj	a3,hst30

	movi	SCRNEND,a0		;[256,405]
	move	a0,@SCRNLR,L
	movk	10,a0
	move	a0,@WORLDTLX+16
	movi	1000,a0
	move	a0,@WORLDTLY+16

	SLEEPK	2
	movi	hiscbg_t,a0		;Show high score screen
	move	a0,@BAKMODS,L
	calla	BGND_UD1

	callr	palcyc_init

	JSRP	GETHIGH			;Prints high scores

	clr	a0
	move	a0,@DISPLAYON
	movi	-4,a0			;Show screen
	move	a0,@DPYSTRT

	move	*a12+,a0
	jrnz	hst90			;Do flyin?
	callr	vidhwfx_blindin
	jruc	hst120

hst90	move	@SWITCH,a0
	movk	>11,a1
	and	a1,a0
	jrz	hst100
	callr	vidhwfx_flyin
	jruc	hst120
hst100	callr	vidhwfx_zoomin
hst120
	movk	1,a0
	move	a0,@DISPLAYON
	clr	a0
	move	a0,@WFLG		;Plyr can start

	CREATE	CYCPID,palcyc

	SLEEP	10*60
	move	@hisclong,a0
	jrz	hst200
	SLEEP	10*60
	clr	a0
	move	a0,@hisclong
;	movb	a0,@CANT
	SLEEP	40
	SOUND1	MUSICOFF
hst200
	callr	vidhwfx_flyout

	movi	CYCPID,a0
	calla	KIL1C

	RETP


hiscbg_t
	.long	HISCBMOD
	.word	10,1002
	.long	-1


hscolorsc_t
	COLORW	02,29,02, 03,29,03, 04,29,04
	COLORW	05,30,05, 04,29,04, 03,29,03, 02,29,02
	COLORW	01,29,01, 00,29,00, 00,28,00, 00,27,00
	COLORW	00,26,00, 00,25,00, 00,24,00, 00,23,00

	COLORW	30,09,30, 30,10,30, 30,11,30
	COLORW	31,13,31, 30,11,30, 30,10,30, 30,09,30
	COLORW	30,08,30, 30,07,30, 30,06,30, 30,05,30
	COLORW	30,04,30, 30,03,30, 30,02,30, 30,01,30

	COLORW	31,11,00, 31,12,00, 31,13,00
	COLORW	31,15,00, 31,13,00, 31,12,00, 31,11,00
	COLORW	31,10,00, 31,09,00, 31,08,00, 31,07,00
	COLORW	31,06,00, 31,05,00, 31,04,00, 31,03,00
	.word	-1

hscolori_t	;Blue
	COLORW	00,09,31, 00,10,31, 00,11,31
	COLORW	00,12,31, 00,11,31, 00,10,31, 00,09,31
	COLORW	00,08,31, 00,07,31, 00,06,31, 00,05,31
	COLORW	00,04,31, 00,03,31, 00,02,31, 00,01,31


junkp	.word	1,0


********************************
* Palette cycle code

 SUBRP	palcyc_init

	movi	hscolorsc_t+30*16,b0

	movi	palram,a1		;>Set palram
	movk	10,a3
psi40	move	b0,a0
	movk	15,a2
psi50	move	*a0+,*a1+
	dsj	a2,psi50
	dsj	a3,psi40

	movi	hscolori_t,a0
	movk	15,a2
psi100	move	*a0+,*a1+
	dsj	a2,psi100

	CREATE	CYCPID,hiscore_cyc
	CREATE	CYCPID,paldump
	rets


 SUBRP	palcyc

	movi	hscolorsc_t,a10

ps20	movi	palram+15*16,a9
	movk	9,a8
ps40	movk	15,a11
ps50	CREATE	CYCPID,palnewcol
	SLEEPK	1
	addk	16,a9			;Next slot
	addk	16,a10			;Next color in set
	dsj	a11,ps50
	subi	15*16,a10		;Back to 1st in set
	dsj	a8,ps40

	SLEEP	60
	addi	15*16,a10		;Next set
	move	*a10,a0			;End of color tables = Neg
	jrnn	ps20

	jruc	palcyc


 SUBRP	palnewcol	;A9=*palram, A10=*New color

	movi	120,a8			;>Fade old down
	move	*a9,a11			;Get old
pp50	move	a11,*a9
	move	a9,a0
	move	a9,a1
	callr	palnewc_set
	SLEEPK	1
	subk	8,a8
	cmpi	16,a8
	jrgt	pp50

pp100	move	a10,a1			;>Fade new up
	move	a9,a0
	callr	palnewc_set
	SLEEPK	1
	addk	4,a8
	cmpi	128,a8
	jrls	pp100
	DIE



 SUBRP	palnewc_set

	move	a8,a2
	movk	1,a14
	jruc	color_fade


********************************
* Cycle the #1 score colors

 SUBRP	hiscore_cyc

hsc10	movi	COLTAB,a8

hsc30	move	*a8+,a7
	jrn	hsc10

	movi	palram,a4
	move	a4,a0
	addk	16,a0
	movk	14,a2
hsc40	move	*a0+,*a4+		;Shift colors down
	dsj	a2,hsc40

	move	a7,*a4+

	SLEEPK	2
	jruc	hsc30


********************************
* Dump palram each frame (process)

 SUBRP	paldump

	movi	palram,a0		;*Color
	movi	>101,a1			;Palette 1, Color 1
	movi	60,a2			;# Colors
	calla	PALSET
	movi	palram+60*16,a0
	movi	>201,a1			;Palette 2, Color 1
	movi	60,a2
	calla	PALSET
	movi	palram+120*16,a0
	movi	>301,a1			;Palette 3, Color 1
	movi	45,a2
	calla	PALSET
	SLEEPK	1
	jruc	paldump


********************************
* Fade a palette
* Each color in palette will be multiplied by a2 then divided by 128
* A0=*Ram for pal, A1=*Palette, A2=Brightness (0-128)

 SUBRP	color_fade

	PUSH	a3,a4,a5,a6,a7,a8,a9,a10,a11


	movi	>7c00,a4	;A4=Mask for 5 bits of red
	movi	>03e0,a6	;A6=Mask for 5 bits of green
	movk	>1f,a8		;A8=Mask for 5 bits of blue
	move	a4,a9
	move	a6,a10
	move	a8,a11
	sll	7,a9		;A9=post mult max for 5 bits of red
	sll	7,a10		;A10=post mult max for 5 bits of green
	sll	7,a11		;A11=post mult max for 5 bits of blue

fp100	move	*a1+,a3
	move	a3,a5		;A3=Red
	move	a3,a7		;A5=Green
	and	a4,a3		;A7=Blue
	and	a6,a5
	and	a8,a7
	mpyu	a2,a3
	mpyu	a2,a5
	mpyu	a2,a7

	cmp	a9,a3
	jrle	redok
	move	a9,a3

redok	cmp	a10,a5
	jrle	greenok
	move	a10,a5

greenok	cmp	a11,a7
	jrle	blueok
	move	a11,a7

blueok	and	a9,a3
	and	a10,a5
	or	a5,a3
	or	a7,a3
	srl	7,a3
	move	a3,*a0+		;Save color
	dsj	a14,fp100

	PULL	a3,a4,a5,a6,a7,a8,a9,a10,a11
	rets

********************************
* Video hardware effects

FXNUML	.equ	254

	.bss	vhfxmem	,FXNUML*16	;Video line effect list
	.bss	vhfxlnv	,FXNUML*16	;Velocity

 SUBRP	vidhwfx_flyin

	move	@HEBLNK,a10

	movi	FXNUML/2,a0		;>Clr effect list and init lines
	movi	vhfxmem,a3
	movi	vhfxlnv,a4
	move	@HSBLNK,a1
	sub	a10,a1
	subk	1,a1
	sll	4,a1			;*16
	clr	a2
vffi100	move	a1,*a3+			;Set X
	move	a2,*a4+			;Set vel
	addk	1,a1
	move	a1,*a3+			;Set X
	move	a2,*a4+			;Set vel
	subk	1,a1
	dsj	a0,vffi100

	movk	2,b2			;B2=#Lines active
;	movk	1,b4			;B4=Spawn delay
;	move	b4,b3			;B3=Spawn cntdn

	movi	>10f,a11

vffi200	move	@COINS,a0
	ori	>34,a0
	not	a0
	jrnz	vffix

	movi	VCOUNT,a7		;A7=*VCNT
	movi	HEBLNK,a6		;A6=*Dest reg

	movi	vhfxmem,a3
	movk	21,a1			;1st line
	movi	FXNUML,a5

	DINT

vffi230	addk	1,a1
	move	*a3+,a2			;Get X start of line
	srl	4,a2			;/16
	add	a10,a2

vffi260	move	*a7,a0			;Wait on vcnt
	cmp	a1,a0
	jrnz	vffi260
	move	a2,*a6			;Stuff value
	dsj	a5,vffi230

	EINT

	movi	vhfxlnv,a3		;>Move lines
	movi	vhfxmem,a8
	move	b2,b0

vffi400	move	*a8,a0			;Get X
	move	*a3,a1
	add	a1,a0			;New pos
	jrge	vffi500
	clr	a0
;	cmpi	>1f,a11			;No bounce at end
;	jrls	vffi500
	sra	1,a1
	neg	a1
vffi500	subk	2,a1			;New vel
;	movk	3,a2
;	and	a11,a2
;	jrnz	vffi530
;	move	a1,a2
;	sra	3,a2			;1/8 drag
;	sub	a2,a1
vffi530	move	a1,*a3+
	move	a0,*a8+			;New X
	dsj	b0,vffi400

	cmpi	FXNUML,b2
	jrhs	vffi700
;	dsj	b3,vffi700
	addk	2,b2			;2 New
;	movk	1,b3
;	subk	6,b4
;	jrle	vffi700
;	move	b4,b3
;	subk	1,b2			;Only 1

vffi700	dsj	a11,vffi200

vffix	move	a10,@HEBLNK
	rets



 SUBRP	vidhwfx_flyout

	clr	a0
	move	a0,@GAMERASE		;Off
	move	a0,@DISPLAYON		;^
	calla	SYNCHALF
	calla	SYNCFULL		;At top and DMA should be done!
	move	@HSBLNK,a9
	subk	2,a9			;A9=Highest HEBLNK allowed
	move	@HEBLNK,a10

	movi	FXNUML,a0		;>Clr effect list and init lines
	movi	vhfxmem,a3
	movi	vhfxlnv,a4
	clr	a1
	clr	a2
vffo100	move	a1,*a3+			;Set X
	move	a2,*a4+			;Set vel
	addk	1,a2
	dsj	a0,vffo100

	movk	2,b2			;B2=#Lines active
;	movk	1,b4			;B4=Spawn delay
;	move	b4,b3			;B3=Spawn cntdn

	movi	>4f,a11

vffo200	move	@COINS,a0
	ori	>34,a0
	not	a0
	jrnz	vffox

	movi	VCOUNT,a7		;A7=*VCNT
	movi	HEBLNK,a6		;A6=*Dest reg

	movi	vhfxmem,a3
	movk	21,a1			;1st line
	movi	FXNUML,a5

	DINT

vffo230	addk	1,a1
	move	*a3+,a2			;Get X start of line
	srl	4,a2			;/16
	add	a10,a2
	cmp	a9,a2
	jrls	vffo260
	move	a9,a2

vffo260	move	*a7,a0			;Wait on vcnt
	cmp	a1,a0
	jrnz	vffo260
	move	a2,*a6			;Stuff value
	dsj	a5,vffo230

	EINT

	movi	vhfxlnv,a3		;>Move lines
	movi	vhfxmem,a8
	move	b2,b0

vffo400	move	*a8,a0			;Get X
	move	*a3,a1
	add	a1,a0			;New pos
	jrge	vffo500
	clr	a0
;	cmpi	>1f,a11			;No bounce at end
;	jrls	vffo500
	sra	1,a1
	neg	a1
vffo500	addk	1,a1			;New vel
;	movk	3,a2
;	and	a11,a2
;	jrnz	vffo530
;	move	a1,a2
;	sra	3,a2			;1/8 drag
;	sub	a2,a1
vffo530	move	a1,*a3+
	move	a0,*a8+			;New X
	dsj	b0,vffo400

	cmpi	FXNUML,b2
	jrhs	vffo700
;	dsj	b3,vffo700
	addk	4,b2			;2 New
;	movk	1,b3
;	subk	6,b4
;	jrle	vffo700
;	move	b4,b3
;	subk	1,b2			;Only 1

vffo700	dsj	a11,vffo200

vffox
	movk	1,a0
	move	a0,@GAMERASE		;On
	calla	SYNCFULL		;At top
	calla	KILBGND
	clr	a1
	calla	KILOBJ			;Kill all objs
	calla	SYNCFULL		;At top
	move	a10,@HEBLNK		;Set normal
	movk	1,a0
	move	a0,@DISPLAYON		;ON

	rets


********************************
* Zoom into screen

 SUBRP	vidhwfx_zoomin


	movi	FXNUML,a0		;>Clr effect list and init lines
	movi	vhfxmem,a3
	movi	vhfxlnv,a4
	move	@DPYSTRT,a1
vfzi100	move	a1,*a3+			;Set Addr
	move	a1,*a4+			;^
	subk	>10,a1
	dsj	a0,vfzi100

	movi	>10000,b2		;B2=#Lines per addr
;	movk	1,b4			;B4=Spawn delay
;	move	b4,b3			;B3=Spawn cntdn

	movi	>10f,a11

vfzi200	move	@COINS,a0
	ori	>34,a0
	not	a0
	jrnz	vfzix

	movi	VCOUNT,a7		;A7=*VCNT
	movi	DPYADR,a6		;A6=*Dest reg

	movi	vhfxmem,a3
	movk	21,a1			;1st line
	movi	FXNUML,a5

	DINT

vfzi230	addk	1,a1
	move	*a3+,a2			;Get X start of line

vfzi260	move	*a7,a0			;Wait on vcnt
	cmp	a1,a0
	jrnz	vfzi260
	move	a2,*a6			;Stuff value
	dsj	a5,vfzi230

	EINT

;	movi	vhfxlnv,a3		;>Move lines
	movi	vhfxmem,a8
	movi	FXNUML,a2
	clr	b0

vfzi400	move	b0,a3
	srl	16,a3
	cmpi	FXNUML,a3
	jrlo	vfzi430
	movi	FXNUML-1,a3
vfzi430	sll	4,a3			;*16
	addi	vhfxlnv,a3
	move	*a3,a0			;Get addr
	move	a0,*a8+			;Set addr
	add	b2,b0
	dsj	a2,vfzi400

	addi	>200,b2			;Inc line skip
;	jrgt	vfzi550
;	movi	>100,b2
;	subi	>200,b2			;Decrease line skip
;	jrgt	vfzi550
;	movi	>100,b2
vfzi550
;	cmpi	FXNUML,b2
;	jrhs	vfzi700
;	dsj	b3,vfzi700
	addk	1,b2
;	movk	1,b3
;	subk	6,b4
;	jrle	vfzi700
;	move	b4,b3
;	subk	1,b2			;Only 1

vfzi700	dsj	a11,vfzi200

vfzix	move	a10,@HEBLNK
	rets




********************************
* Show screen by droping lines (BOGUS)

	NOTINUSE
	.bss	vhfxln	,FXNUML*32	;Line current pos, velocity

 SUBRP	vidhwfx_linein

	move	@DPYCTL,a10

	movi	FXNUML,a0		;>Clr effect list and init lines
	movi	vhfxmem,a3
	movi	vhfxln,a4
	clr	a1
	movi	-8,a2
vhf100	move	a1,*a3+
	move	a2,*a4+			;Set pos (3 bits fraction)
	move	a1,*a4+			;Set vel
	dsj	a0,vhf100

	movk	1,b2			;B2=#Lines active
	movi	45,b4			;B4=Spawn delay
	move	b4,b3			;B3=Spawn cntdn

	movi	>12f,a11

vhf200	move	@COINS,a0
	ori	>34,a0
	not	a0
	jrnz	vhfx

	movi	VCOUNT,a7		;A7=*VCNT
	movi	DPYCTL,a6		;A6=*Dest reg

	movi	vhfxmem,a3
	movk	21,a1			;1st line
	movi	FXNUML,a5

	DINT

vhf230	addk	1,a1
	move	a10,a2
	move	*a3+,a0			;Get effect for line
	jrnz	vhf260
	sll	17,a2			;Clr ENV bit
	srl	17,a2

vhf260	move	*a7,a0			;Wait on vcnt
	cmp	a1,a0
	jrnz	vhf260
	move	a2,*a6			;Stuff value
	dsj	a5,vhf230

	movi	FXNUML,a0		;>Clr effect list
	movi	vhfxmem,a3
	clr	a1
vhf300	move	a1,*a3+
	dsj	a0,vhf300

	EINT

	movi	vhfxln,a3		;>Move lines
	movi	vhfxmem,a8
	movi	FXNUML*8,a5		;A5=Line #*8
	move	b2,b0
	move	a5,a2
	jruc	vhf410

vhf400	move	*a3(-32),a2
vhf410	move	*a3+,a0
	move	*a3,a1
	add	a1,a0			;New pos
	cmp	a2,a0
	jrlt	vhf450
	move	a2,a0
	subk	8,a0
	jruc	vhf470
vhf450	cmp	a5,a0
	jrlt	vhf500
	move	a5,a0
vhf470	cmpi	>2f,a11			;No bounce at end
	jrls	vhf500
	neg	a1
vhf500	addk	4,a1			;Add vel
	movk	3,a2
	and	a11,a2
	jrnz	vhf530
	move	a1,a2
	sra	3,a2			;1/8 drag
	sub	a2,a1
vhf530	move	a1,*a3+
	move	a0,*a3(-32)		;New pos
	sra	3,a0			;Get int part
	jrle	vhf550
	sll	4,a0			;*16
	addi	vhfxmem-16,a0
	movk	1,a2
	move	a2,*a0			;Effect on
vhf550	subk	8,a5
	dsj	b0,vhf400

	cmpi	FXNUML,b2
	jrhs	vhf700
	dsj	b3,vhf700
	addk	4,b2			;4 New
	movk	1,b3
	subk	6,b4
	jrle	vhf700
	move	b4,b3
	subk	3,b2			;Only 1

vhf700	dsj	a11,vhf200

vhfx	move	a10,@DPYCTL
	rets

	.endif


********************************
* Show screen with blind effect

 SUBRP	vidhwfx_blindin

	move	@DPYCTL,a10

	movi	FXNUML,a0		;>Clr effect list
	movi	vhfxmem,a3
	move	a3,a9			;A9=*Next line to show
	clr	a1
vhfb100	move	a1,*a3+
	dsj	a0,vhfb100

	movk	18,a11

vhfb200	move	@COINS,a0
	ori	>34,a0
	not	a0
	jrnz	vhfbx

	movi	VCOUNT,a7		;A7=*VCNT
	movi	DPYCTL,a6		;A6=*Dest reg

	movi	vhfxmem,a3
	movk	21,a1			;1st line
	movi	FXNUML,a5

	DINT

vhfb230	addk	1,a1
	move	a10,a2
	move	*a3+,a0			;Get effect for line
	jrnz	vhfb260
	sll	17,a2			;Clr ENV bit
	srl	17,a2

vhfb260	move	*a7,a0			;Wait on vcnt
	cmp	a1,a0
	jrnz	vhfb260
	move	a2,*a6			;Stuff value
	dsj	a5,vhfb230

	EINT

	movk	14,a5
	move	a9,a3
	movk	1,a0
vhfb400	move	a0,*a3			;Line on
	addi	18*16,a3
	dsj	a5,vhfb400
	addk	16,a9

	dsj	a11,vhfb200

vhfbx	move	a10,@DPYCTL
	rets


********************************
* Get initials from players

	.ref	STRT_S,WNDWOFF,GETINIT,ISHSTD,INITTIM
	.ref	GETINIT1,GETINIT2
	.ref	WRLD,BAKBITS

 SUBR	INITIALS

	JSRP	WNDWON

	movi	junkp,a1		;>Steal PAL 1
	move	a1,@FPALRAM+PALRSIZ,L

	movi	hscolorsc_t+30*16,a0	;*Red
	movi	>101,a1			;Palette 1, Color 1
	movk	15,a2			;# Colors
	calla	PALSET

	clr	a0
	move	a0,@TNT_TYPE
	move	a0,@WORLDTLX+16
	movi	1000,a0
	move	a0,@WORLDTLY+16

	SLEEPK	2
	movi	hiscoreinit_t,a0	;Show home base view screen
	move	a0,@BAKMODS,L
	calla	BGND_UD1
	calla	STRT_S			;Static color cycle
;TURMELL
	.REF	STRT_CRM
	calla	STRT_CRM		;Start headquarters cycle

	movk	4,a0
	move	a0,@IRQSKYE		;Dark blue

	clr	a0
	move	a0,@WRLD		;Do world adj

	movk	1,a0
	move	a0,@ENTERON

	movk	8,a0
	move	a0,@WSPEED

	JSRP	WNDWOFF
	SLEEP	70

	callr	intgrid_prt		;Print grid

	calla	ISHSTD
	jrz	in70
 	move	a0,b0			;P1=1, P2=2, Both=3
	calla	INITTIM

	srl	1,b0
	jrnc	in30
	CREATE	HISCPID,GETINIT1	;GET PLAYER 1 INITS
in30	srl	1,b0
	jrnc	in70
	CREATE	HISCPID,GETINIT2	;GET PLAYER 2 INITS

in70	JSRP	GETINIT			;Wait on initials
	JSRP	WNDWON

	calla	KILBGND
	movi	INTROPID,a0
	calla	KIL1C
	movi	HISCPID,a0
	calla	KIL1C
	movi	CYCPID,a0
	calla	KIL1C
	clr	a1
	calla	KILOBJ			;Kill all objs
	SLEEPK	1
	calla	MYOINIT
	RETP


hiscoreinit_t
	.long	HISCOREBMOD		;Module name
	.word	6,1000			;X,Y start pos
	.long	-1



********************************
* print initials letter grid

	.bss	intgridbuf	,16	;Print buffer
	.ref	INITMAT,RD15FONT,STRCNRMO

 SUBRP	intgrid_prt

	movi	INITMAT,a4
	movi	>2525,a6
	movi	[44,149],a9		;Scrn y/x
	movk	[0,1],a10		;Spacing
	movi	RD15FONT,a11

	movk	5,a2
igp30	movk	6,a3
igp50	clr	a0			;No sleep
	movi	intgridbuf,a8
	movb	*a4,*a8
	PUSH	a9
	JSRP	STRCNRMO		;Print, objs
	PULL	a9
	addk	8,a4
	addk	21,a9			;Next X
	dsj	a3,igp50

	subi	6*21,a9			;1st X
	addi	[22,0],a9		;Next Y
	dsj	a2,igp30

	rets



	.end
