**************************************************************
;turmell
;how come the ? mark is not printed out?  (how can i beat him?)
;how come then number 1 is not printed out?  (player 1 is a dork)
*
* Software:		Shawn Liptak
* Initiated:		June 6,1991
*
* Modified:		!
*
* COPYRIGHT (C) 1991 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 9/27/91 13:47
**************************************************************
      	.FILE	'RACKUP.ASM'
	.TITLE	'TOTAL CARNAGE GAME PROGRAM'
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

	.include	"mproc.equ"
	.include	"disp.equ"
	.include	"\video\sys\sys.inc"
	.include	"game.equ"
	.include	"imgtbl.glo"
	.include	"shawn.hdr"		;My macros
	.include	"rackup.tbl"



;sound headers used

	.ref	GLSEXP,NOWAY,SETDWN,TUNE3

CVSDOFF .word	>F0F0,10,>807D,0		;SPEECH OFF
racksup	.word	>f280,1,>80b3,0			;Rackup bonus sweep up
rackoff	.word	>fa81,1,>80a7,0			;Rackup bonus off
kilfgnd	.word	>f000,1,>807f,0			;Kill foregnd snds
rackp1p	.word	>fa80,1,>80b4,0			;Rackup P1 gets 500 pts
rackp2p	.word	>fa80,1,>80b5,0			;^ P2
stats1	.word	>f280,1,>8100,0			;Rackup stat line snd
stats2	.word	>f280,1,>8101,0			;^
stats3	.word	>f280,1,>8102,0			;^
stats4	.word	>f280,1,>8103,0			;^
stats5	.word	>f280,1,>8104,0			;^
stats6	.word	>f280,1,>8105,0			;^
stats7	.word	>f280,1,>8106,0			;^
stats8	.word	>f280,1,>8107,0			;^
stats9	.word	>f280,1,>8108,0			;^
stats10	.word	>f280,1,>8109,0			;^
stats11	.word	>f280,1,>810a,0			;^
stats12	.word	>f280,1,>810b,0			;^
txtssnd	.word	>f3f7,8,>80b1,0			;Text shrink
shout	.word	>f1a0,60,>80fe,0		;Rackup victory shout
rackgun	.word	>fca0,4,>8030,0			;Player shoots gun
gigle1	.word	>f9a0,60,>80f3,0		;Rackup winner laughs
ahkb1	.word	>f9a0,10,>80eb,0		;Akhboob speech
ahkb2	.word	>f9a0,10,>80ec,0		;^
ahkb3	.word	>f9a0,10,>80ed,0		;^
ahkbsta	.word	>f9a0,10,>80ee,0		;^ start angry
ahkbang	.word	>f9a0,10,>80ef,0		;^ angry
yousuck	.word	>f9a0,10,>80c5,0		;You suck at this game!
fisthit	.word	>fca0,10,>803c,0		;Ahkboob hits desk
ermtune	.word	>f3f0,10,>8004,0		;Electrocution tune
fshock	.word	>f540,20,>80bb,0		;Electric chair shocks
fburn	.word	>f048,30,>80d7,0		;^ burn
fpain1	.word	>f965,20,>80f6,0		;Player in pain
fpain2	.word	>f160,20,>80f7,0		;^
fpain3	.word	>f160,20,>80fd,0		;^
fskullb	.word	>f460,20,>8040,0		;Skull bounce
fryexp	.word	>fc50,6,>803e,0			;Fry explosion
fryexp2	.word	>fd50,8,>80d9,0			;^
totcarn	.word	>f980,30,>80cf,0		;Total carnage!


;symbols externally defined

	.ref	COLTAB,CYCLE_TABLE,STATIC_COVER,PLYRPRCS,INTRO
	.ref	RACKBMOD,RANDOM,GPALOBJ,PALSET,FINDPAL,GETFPAL,PCNT
	.ref	IRQSKYE,ERASE_TXT,HEXTOASC,FRANIM,HSTGLST,HALT,PLYROBJS
	.ref	CRMP,BCDBIN,BINBCD
	.ref	WSPEED,STRT_S,STATUS,STOPPLYR
	.ref	COLCYC,BGND_UD1,BAKMODS,WNDWON,WNDWOFF,NO_START,WRLD
	.ref	STRCNRMO,STRCNRMO_1,STRCNRM,LOWZ
	.ref	RD15FONT,RD7FONT,RD8FONT
	.ref	P1DATA,P2DATA,HSTGS_LOST,KEYS_LOST
	.ref	SLDEBUG,timerp1,timerp2
	.ref	FADEOUT2,PCOUNT,TAUNTOUT
	.ref	RNDRNG,RNDRNG0
	.ref	ELECRM1BMOD,CHAIR2BMOD
	.ref	BLUEEXP,FIREEXP,XBOOM2,BOOM3
	.ref	FRANIMQ
	.ref	TNT_TYPE,SHAKER

;symbols defined in this file


;uninitialized ram definitions

	.bss	cycmem		,5*16*2	;Allocate 2 x color area in ram
	.bss	statspal	,31*16 	;Statistics palette
	.bss	boanimdeath1	,16    	;CntDn for bonus anim procs to die
	.bss	boanimdeath2	,16    	;^
	.bss	scoredie	,16	;>0=Score processes die
	.bss	hitpercent1	,16	;Player1 %
	.bss	hitpercent2	,16	;Player2 %
	.bss	hitsmin1	,16	;Player1 hits per minute
	.bss	hitsmin2	,16	;Player2 ^
	.bss	score1old	,32	;P1 score before bonuses
	.bss	score2old	,32	;P2 ^

	.bss	bonusstat	,16	;Status of bonus

	.bss	frydone		,16	;!0=Electrocution over
	.bss	fryp1palmem	,65*16	;P1 mem for pallette pulse
	.bss	fryp2palmem	,65*16	;P2 ^

	.text


********************************
* Do dictator taunt 1

 SUBR	DO_MAN

	SLEEPK	10
	clr	a11			;1st taunt
	jruc	dictt


 SUBR	INCOM_TRAN

	clr	a0
	move	a0,@WRLD		;Do world adj
	movi	incom_st,a0 		;*Text
	jruc	prt0_xy

TUNE4	.WORD	>F3FE,10,>8007,0		;RACKUP TUNE

********************************
* Rack it up!

 SUBR	DO_RACKUP

	calla	STOPOBJS		;Keep all objs still

;	move	@SLDEBUG,a0
;	btst	0,a0
;	jrnz	skiprc
;	CREATE0	rackcaller		;DEBUG
;skiprc

	movk	1,a0			;Delay start of a 2nd plyr flag
	move	a0,@NO_START
	move	a0,@INTRO

	clr	a0
	move	a0,@IRQSKYE

	movi	TUNE4,a0
	calla	ONESND

;	movi	rackupbg_t,a0		;Show home base view screen
;	move	a0,@BAKMODS,L
;	calla	BGND_UD1
;	calla	STRT_S			;Static color cycle
;	movi	CRMP,A8 		;Pal name
;	movi	cycmem,A9		;Ram area
;	movi	[58,64],A10		;Begin/end color #
;	movk	4,a11			;Rate in ticks
;	CREATE	CYCPID,COLCYC		;Color cycler on

;	JSRP	WNDWOFF

;	SLEEP	80
;	calla	ERASE_TXT

	SLEEP	96

 	move	@PLYROBJS,a9,L
	jrz	rp10
	calla	STOPPLYR
rp10	move	@PLYROBJS+32,a9,L
	jrz	rp12
	calla	STOPPLYR
rp12
	clr	a0
	move	a0,@HALT
					;>Make tiles
	movk	8*4,a1			;# Panels
	movi	-4*>25800+>12c00,a2	;Velocity
	movk	10,a3
	movi	200,a5
rp20	movi	panel_t,a14
	calla	GPALOBJ			;Get palette & obj
	calla	STFOBJ			;Stuff object data
	move	a2,*a0(OXVEL),L		;Set XVEL
	move	a3,*a0(OYPOS)		;New Y
	addi	46,a3
	move	a5,*a0(OZPOS)
	movk	3,a4
	and	a1,a4
	subk	1,a4
	jrne	rp30
	addi	>25800,a2
	movk	10,a3
	movk	1,a4
	xor	a4,a5			;Toggle 0 Bit
rp30	calla	ADJSTWTL		;Adjust into world
	calla	INSOBJ			;Insert obj
	dsj	a1,rp20

	SLEEPK	20

	calla	STOPOBJS		;Stop tiles

	callr	scores_bcdbin

	move	@P1DATA+THITS,a1	;>Calc P1 % & hitsmin
	move	a1,a3
	movi	100,a0
	mpyu	a0,a1
	move	@P1DATA+TSHOTS,a2
	divu	a2,a1
	move	a1,@hitpercent1

	movi	60,a0
	mpyu	a0,a3
	move	@timerp1,a2
	divu	a2,a3
	move	a3,@hitsmin1

	move	@P2DATA+THITS,a1	;>Calc P2 % & hitsmin
	move	a1,a3
	movi	100,a0
	mpyu	a0,a1
	move	@P2DATA+TSHOTS,a2
	divu	a2,a1
	move	a1,@hitpercent2

	movi	60,a0
	mpyu	a0,a3
	move	@timerp2,a2
	divu	a2,a3
	move	a3,@hitsmin2

	movi	[2,30],a8		;Color 2, 30 colors
	movi	SCOREPAL,a9
	movi	COLTAB,a10		;Color table
	movk	7,a11			;Rate of cycle
	CREATE	CYCPID,CYCLE_TABLE
	movi	[1,1],a8
	movi	SCOREPAL,a9
	movi	statscolor_t,a10
	movk	3,a11
	CREATE	CYCPID,CYCLE_TABLE
	movi	[32,2],a8
	movi	SCOREPAL,a9
	movi	statscolor_t,a10
	movk	5,a11
	CREATE	CYCPID,CYCLE_TABLE

	CREATE0	score_prt
	SLEEPK	1
	CREATE0	scorebonus_prt

	JSRP	bonus_main

	JSRP	player_showstats

	movk	1,a0
	move	a0,@scoredie		;Kill score processes
	SLEEPK	8

	movk	5,a11
	JSRP	text_shrink

	JSRP	player_bonuswin		;Show bonus winner!


	movi	60*8,a0
	callr	sleep_var


	callr	scores_binbcd

	movi	CYCPID,a0
       	calla	KIL1C

debug	movk	1,a11
	CREATE0	STATIC_COVER

	movi	TUNE3,a0		;Turn on dictator taunt music
	calla	ONESND
	
	SLEEPK	25

	movi	SCOREPAL,a0		;*Color
	clr	a1			;Palette 0, Color 0
	move	*a0+,a2			;# Colors
	calla	PALSET
	movi	DESRTPL,a0		;*Color
	move	*a0,a2			;# Colors
	calla	GETFPAL
	srl	8,a0
	sll	8,a0
	move	a0,a1
	movi	DESRTPL+16,a0		;*Color
	calla	PALSET

	movi	2*32*32+2*32+2,a0
	move	a0,@IRQSKYE		;Dark grey background behind dictator

	callr	anim_killall

	movk	1,a11			;2nd taunt
dictt	movi	engtran_s,a8
	movi	40,a9
	CREATE	MADPID,prt_inrackwin

	move	a11,a0
	JSRP	dictator_taunt

	movk	3,a0
	move	a0,@TAUNTOUT		;Taunt over
	DIE


rackupbg_t
	.long	RACKBMOD
	.word	-6,>35b			;x,y start pos.
	.long	-1

incom_st
	XYTXT	PRTF15,652,55,1,"INCOMING TRANSMISSION"
	.word	-1


panel_t	.long	[177,0],[0,0],RACKBLK		;x,y,img name
	.word	200,DMAWNZ+M_NOCOLL,CLSDEAD	;zpos,oflags,oid
	.long	0,0				;xvel,yvel

statscolor_t
	COLORW	16,0,0
	COLORW	20,00,08, 24,00,12, 28,00,16, 31,00,20
	COLORW	28,00,24, 24,00,28, 20,00,31, 16,00,28
	COLORW	08,20,00, 16,24,00, 24,28,00, 31,31,00
	COLORW	20,28,00, 12,24,00, 08,20,00, 02,16,00
	COLORW	00,08,20, 00,16,24, 00,24,28, 00,31,31
	COLORW	00,20,28, 00,10,24, 00,00,20, 00,00,16
	COLORW	16,0,0
	.word	-1

engtran_s
	.byte	"ENGLISH TRANSLATION",0
	.even
	

********************************
* Print XY sting set if player in game
* Trashes A2-A6

 SUBRP	printifp_xy	;A0=*Plyr1 string, A1=*Plyr2 string

	PUSH	a8
	move	a1,a8

	move	@STATUS,a1
	btst	0,a1
	jrz	pipx10
	callr	prt0_xy		;P1

pipx10	move	@STATUS,a1
	btst	1,a1
	jrz	pipx20
	move	a8,a0
	callr	prt0_xy		;P2

pipx20	PULL	a8
	rets

********************************
* Print an XY string set
* A0=*XY text
* A1=Y:X offset
* Trashes A1-A6
* Rets: A0=*Next XY or End

PRTF15	.equ	1		;Font15
PRTF8	.equ	2		;Font8 MultiColor
PRTDEC	.equ	4		;Decimal
PRTBCD	.equ	8		;BCD (Long)
PRTL	.equ	16		;Long data
PRTOBJ	.equ	32		;Object format
PRTE	.equ	>8000		;Stop on this header

PRTF15B	.equ	0
PRTF8B	.equ	1
PRTDECB	.equ	2
PRTBCDB	.equ	3
PRTLB	.equ	4
PRTOBJB	.equ	5

 SUBRP	prt0_xy

	clr	a1		;No offset

 SUBRP	prt_xy

	PUSH	a6,a7,a8,a9,a10,a11

	move	a0,a8			;A8=*Txt data
	move	a1,a3			;A3=Y:X offset
prtxy5	move	*a8+,a1			;Mode word
	move	*a8+,a9,L		;Scrn Y:X
	addxy	a3,a9			;+Offset
	btst	PRTOBJB,a1
	jrnz	pxy300

	movk	[0,1],a10		;Char Y:X spacing
	movi	RD7FONT,a11		;*Font
	btst	PRTF15B,a1
	jrz	prtxy10
	movi	RD15FONT,a11		;*Font
prtxy10	move	*a8+,a6			;Color
	move	a6,a0
	sll	8,a6
	or	a0,a6

	btst	PRTDECB,a1
	jrz	prtxy30
	move	*a8+,a2,L		;Binary mode
	PUSH	a8
	move	*a2,a8			;Get word
	btst	PRTLB,a1
	jrz	prtxy20
	move	*a2,a8,L		;Get long
prtxy20	calla	HEXTOASC
	jruc	prtxy40

prtxy30	btst	PRTBCDB,a1
	jruc	prtxy70
;	jrz	prtxy70
;	move	*a8+,a0,L		;BCD mode
;	move	*a0,a0,L
;	callr	bcdtoasc
;	PUSH	a8
;	move	a0,a8
prtxy40	clr	a0
	JSRP	STRCNRMO
	PULL	a8
	jruc	pxy80

prtxy70					;>String mode
	btst	PRTF8B,a1
	jrz	prtxy74
	movi	BLLNP5,a0
	calla	FINDPAL
	move	a0,a6
	movi	RD8FONT,a11
	clr	a0
	JSRP	STRCNRMO_1		;Full color font
	jruc	prtxy77

prtxy74	clr	a0			;Sleep time
	JSRP	STRCNRMO		;Print string, objects
prtxy77	addk	8,a8			;Round up
	srl	4,a8
	sll	4,a8
pxy80	move	*a8,a0			;-=End
	jrge	prtxy5

	move	a8,a0
	PULL	a6,a7,a8,a9,a10,a11
	rets

pxy300	move	a3,a10			;>Print obj
	move	*a8+,a3			;Z
	move	*a8+,a2,L		;*Img
	move	*a2,a1			;Get ISIZEX
	srl	1,a1			;/2
	move	a9,a0
	sub	a1,a0			;Center
	sll	16,a0			;X
	clr	a1
	movy	a9,a1			;Y
	movi	DMAWNZ+M_NOCOLL,a4
	movi	CLSNEUT|TYPTEXT|SUBTXT,a5
	clr	a6
	clr	a7
	move	a8,a9
	calla	BEGINOBJ
	move	a9,a8
	move	a10,a3
	jruc	pxy80


********************************
* Print an XY string set number with no objects
* Trashes A2-A7

	NOTINUSE
 SUBRP	prtnobj_xy		;A0=*XY Text

	PUSH	a8,a9,a10,a11

	move	a0,a8
pdnox5	movk	[0,1],a10		;Char y,x spacing
	movi	RD7FONT,a11		;*Font
	move	*a8+,a1			;Mode word
	btst	PRTF15B,a1
	jrz	pdnox10
	movi	RD15FONT,a11		;*Font
pdnox10	move	*a8+,a9,L		;Scrn y/x
	move	*a8+,a6			;Color
	move	a6,a2
	sll	8,a6
	or	a2,a6

	btst	PRTDECB,a1
	jrz	pdnoxx
	move	*a8+,a2,L		;Binary mode
	move	*a2,a0			;Get word
	btst	PRTLB,a1
	jrz	pdnox20
	move	*a2,a0,L		;Get long
pdnox20	PUSH	a8
	move	a0,a8
	calla	HEXTOASC
	clr	a0
	JSRP	STRCNRM
	PULL	a8

	move	*a8,a0			;-=End
	jrge	pdnox5

pdnoxx	PULL	a8,a9,a10,a11
	rets
	.endif

********************************
* Vertically shrink text
* Trashes A0-A10

 SUBRP	text_shrink		;A11=Sleep time

	movi	txtssnd,a0
	calla	ONESND

	movk	8,a10			;Size for x2 shrinkage
txs20	move	a11,a0
	calla	PRCSLP
	clr	a8
	move	@OBJLST,a9,L		;>Find and shrink
txs40	move	*a9(OID),a0
	cmpi	CLSNEUT|TYPTEXT|SUBTXT,a0
	jrne	txs70
	move	*a9(OSIZEY),a0
	subk	1,a0			;Shrink
	jrz	txs70			;Min of 1
	cmp	a10,a0
	jrlt	txs50
	subk	1,a0			;Shrink again
	cmpi	15,a0
	jrlt	txs50
	subk	5,a0			;Shrink x7
txs50	move	a0,*a9(OSIZEY)
	movk	1,a8
txs70	move	*a9,a9,L
	jrnz	txs40

	subk	1,a10			;Lower x2 min
	move	a8,a8
	jrnz	txs20

	calla	ERASE_TXT

	RETP


********************************
* Delete text at a ZPOS
* Trashes A0-A3

 SUBRP	text_delz		;A0=ZPOS

	move	a0,a2

	move	@OBJLST,a0,L
tdz40	move	*a0(OID),a1
	cmpi	CLSNEUT|TYPTEXT|SUBTXT,a1
	jrne	tdz70
	move	*a0(OZPOS),a1
	cmp	a2,a1
	jrne	tdz70
	move	*a0,a3,L	;Get * next
	calla	DELOBJ
	move	a3,a0
	jruc	tdz80
tdz70	move	*a0,a0,L
tdz80	jrnz	tdz40		;Continue?
	rets


********************************
* Delete text in a Y range
* Trashes A0-A3

 SUBRP	text_delyrng		;A0=Lower Y, A1=Upper Y

	move	@WORLDTLY+16,a2
	add	a2,a1		;A1=World adjusted upper Y
	add	a0,a2		;A2=^ lower Y

	move	@OBJLST,a0,L
tdy40	move	*a0(OID),a3
	cmpi	CLSNEUT|TYPTEXT|SUBTXT,a3
	jrne	tdy70
	move	*a0(OYPOS),a3
	cmp	a2,a3
	jrlt	tdy70
	cmp	a1,a3
	jrgt	tdy70
	move	*a0,a3,L	;Get * next
	calla	DELOBJ
	move	a3,a0
	jruc	tdy80
tdy70	move	*a0,a0,L
tdy80	jrnz	tdy40		;Continue?
	rets


********************************
* Print text in rackup window

 SUBR	prt_inrackwin	;A8=*Text, A9=#Loops
;turmell made global

	move	a9,*a13(PDATA)
	SLEEPK	30
	movk	1,a10			;Y:X spacing
	movi	RD7FONT,a11		;font table

pirw10	SLEEPK	10
	movi	-210,a0			;-2
;TURMELL
	move	a0,@LOWZ
	movi	[187,198],a9		;Y:X
	movi	>2525,a6
	clr	a0
	PUSH	a8
	JSRP	STRCNRMO
	PULL	a8
	SLEEPK	10
	movi	20000-210,a0
	callr	text_delz
	move	*a13(PDATA),a0
	subk	1,a0
	move	a0,*a13(PDATA)
	jrgt	pirw10
	DIE

********************************
* Convert scores to binary

 SUBRP	scores_bcdbin

	move	@P1DATA+PSCORE,a0,L
	calla	BCDBIN
	move	a0,@P1DATA+PSCORE,L
	move	a0,@score1old,L
	move	@P2DATA+PSCORE,a0,L
	calla	BCDBIN
	move	a0,@P2DATA+PSCORE,L
	move	a0,@score2old,L
	rets

********************************
* Convert scores to BCD

 SUBRP	scores_binbcd

	move	@P1DATA+PSCORE,a0,L
	calla	BINBCD
	move	a0,@P1DATA+PSCORE,L
	move	@P2DATA+PSCORE,a0,L
	calla	BINBCD
	move	a0,@P2DATA+PSCORE,L
	rets


********************************
* Print players score (Process)

	LONGPD	scorecopy1	,0	;Last P1 score
	LONGPD	scorecopy2	,2	;^ P2

 SUBRP	score_prt
	clr	a0
	move	a0,@scoredie
	subk	1,a0
	move	a0,*a13(scorecopy1),L
	move	a0,*a13(scorecopy2),L

scp20	move	@STATUS,a8

	btst	0,a8
	jrz	scp50
	move	*a13(scorecopy1),a0,L
	move	@P1DATA+PSCORE,a1,L
	cmp	a0,a1
	jreq	scp50
	move	a1,*a13(scorecopy1),L
	movi	305,a0
	callr	text_delz
	movi	305-20000,a0
	move	a0,@LOWZ
	movi	score1_st,a0
	callr	prt0_xy		;P1

scp50	SLEEPK	3
	btst	1,a8
	jrz	scp80
	move	*a13(scorecopy2),a0,L
	move	@P2DATA+PSCORE,a1,L
	cmp	a0,a1
	jreq	scp80
	move	a1,*a13(scorecopy2),L
	movi	306,a0
	callr	text_delz
	movi	306-20000,a0
	move	a0,@LOWZ
	movi	score2_st,a0
	callr	prt0_xy		;P2

scp80	SLEEPK	3
	move	@scoredie,a0
	jrle	scp20
	DIE

score1_st
	XYNUM	PRTDEC+PRTL+PRTF15,85,16,32,P1DATA+PSCORE
	.word	-1
score2_st
	XYNUM	PRTDEC+PRTL+PRTF15,315,16,33,P2DATA+PSCORE
	.word	-1


********************************
* Print players bonus score (Process)

 SUBRP	scorebonus_prt

	movi	-1,a0
	move	a0,*a13(scorecopy1),L
	move	a0,*a13(scorecopy2),L

	movk	[0,1],a10		;Spacing
	movi	RD7FONT,a11

scbp20	move	@STATUS,a2
	btst	0,a2
	jrz	scbp50
	move	@P1DATA+PSCORE,a8,L	;>Calc bonus score
	move	*a13(scorecopy1),a0,L
	cmp	a0,a8
	jreq	scbp50
	move	a8,*a13(scorecopy1),L
	movi	300,a0
	callr	text_delz
	move	@score1old,a0,L
	movi	300-20000,a1
	movi	>2020,a6
	movi	[35,85],a9		;Scrn y/x
	callr	scoreb_prt2

scbp50	SLEEPK	3
	move	@STATUS,a2
	btst	1,a2
	jrz	scbp80
	move	@P2DATA+PSCORE,a8,L	;>Calc bonus score
	move	*a13(scorecopy2),a0,L
	cmp	a0,a8
	jreq	scbp80
	move	a8,*a13(scorecopy2),L
	movi	301,a0
	callr	text_delz
	move	@score2old,a0,L
	movi	301-20000,a1
	movi	>2121,a6
	movi	[35,315],a9		;Scrn y/x
	callr	scoreb_prt2

scbp80	SLEEPK	3
	move	@scoredie,a0
	jrle	scbp20
	DIE


scoreb_prt2
	move	a1,@LOWZ
	sub	a0,a8
	calla	HEXTOASC
	clr	a0			;No sleep
	JSRP	STRCNRMO		;Print
	rets


********************************
* Variable sleep

 SUBRP	sleep_var	;A0=Sleep time

	move	@SWITCH+16,a1	;Chk for impatience
	not	a1
	andi	>24,a1
	jrz	sv20
	srl	2,a0		;1/4 sleep time
sv20	jauc	PRCSLP



********************************
* Give collection bonus

	.bss	bonuscnt	,32	;P1/P2 item cnt (word*2)

 SUBRP	bonus_main

;	movk	3,a0
;	move	a0,@STATUS	;DEBUG
;
;	movi	200,a0		;>DEBUG
;	calla	RNDRNG0
;	move	a0,@P1DATA+TFLAGS
;	movi	200,a0
;	calla	RNDRNG0
;	move	a0,@P2DATA+TFLAGS
;
;	movi	200,a0
;	calla	RNDRNG0
;	move	a0,@P1DATA+CASHCNT
;	movi	200,a0
;	calla	RNDRNG0
;	move	a0,@P2DATA+CASHCNT
;
;	movi	200,a0
;	calla	RNDRNG0
;	move	a0,@P1DATA+THSTGS
;	movi	200,a0
;	calla	RNDRNG0
;	move	a0,@P2DATA+THSTGS

	movi	collectb_s,a8
	movi	100,a9
	CREATE0	prt_inrackwin
	move	a0,-*a12,L

	movi	-1,a0
	move	a0,@bonusstat

	movi	bonus_st,a0
	callr	prt0_xy

	move	@STATUS,a2
	btst	0,a2
	jrz	bm20
	movi	bonusp1_as,a8
	CREATE	ANIMPID,anim_script	;P1

bm20	btst	1,a2
	jrz	bm40
	movi	bonusp2_as,a8
	CREATE	ANIMPID2,anim_script	;P2
bm40
	movi	bonus1p1_st,a0
	movi	bonus1p2_st,a1
	movi	210,a2
	movi	[70,116],a9		;YX
	movi	60,a10
	movi	TFLAGS,a11
	JSRP	bonus_cntup		;Flags

	clr	a0
	move	a0,@bonusstat

	movi	bonus2p1_st,a0
	movi	bonus2p2_st,a1
	movi	211,a2
	movi	[108,116],a9		;YX
	movi	40,a10
	movi	CASHCNT,a11
	JSRP	bonus_cntup		;Crystals

	movk	1,a0
	move	a0,@bonusstat

	movi	bonus3p1_st,a0
	movi	bonus3p2_st,a1
	movi	212,a2
	movi	[146,116],a9		;YX
	movi	100,a10
	movi	THSTGS,a11
	JSRP	bonus_cntup		;Hostages

	movi	60*4,a0
	callr	sleep_var

	move	*a12+,a0,L
	clr	a1
	move	a1,*a0(PDATA)		;Stop window text

	movk	2,a0
	move	a0,@bonusstat
	movi	55,a0
	movi	200,a1
	callr	text_delyrng
	SLEEPK	30

	RETP

collectb_s
	.byte	"COLLECTION BONUS",0


 SUBRP	bonus_cntup	;A0=*P1_st, A1=*P2_st, A2=Z
			;A9=Base YX, A10=Pts each, A11=Plyr data offset
	move	@STATUS,a3
	subk	3,a3
	jrnz	bcu10
	sll	1,a10			;*2 pts for two players

bcu10	PUSH	a2
	callr	printifp_xy

	movi	bonuscnt,a8
	CREATE0	bonus_prtitem		;Display
	move	a0,-*a12,L
	PULL	a2
	move	a2,*a0(bonusz)

	clr	a0
	move	a0,*a8,L		;Cnt=0

	movi	racksup,a0
	calla	ONESND

bcu20	SLEEPK	1
	move	@STATUS,a2

	clr	a3

	btst	0,a2
	jrz	bcu30
	move	*a8,a0
	movi	P1DATA,a1
	add	a11,a1
	move	*a1,a1
	cmp	a1,a0
	jrge	bcu30			;Count maxed?
	addk	1,a0
	move	a0,*a8
	movk	1,a3
	move	@P1DATA+PSCORE,a0,L
	add	a10,a0
	move	a0,@P1DATA+PSCORE,L

bcu30	btst	1,a2
	jrz	bcu60
	move	*a8(16),a0
	movi	P2DATA,a1
	add	a11,a1
	move	*a1,a1
	cmp	a1,a0
	jrge	bcu60			;Count maxed?
	addk	1,a0
	move	a0,*a8(16)
	movk	1,a3
	move	@P2DATA+PSCORE,a0,L
	add	a10,a0
	move	a0,@P2DATA+PSCORE,L

bcu60	move	a3,a3
	jrnz	bcu20			;More to do?

	movi	rackoff,a0		;End
	calla	ONESND
	SLEEPK	5

	move	*a8+,a1			;P1
	move	*a8,a2			;P2
	move	@WORLDTLX+16,a10
	cmp	a2,a1
	jrhi	bcu200			;P1 won?
	jrlo	bcu180			;P2 won?
	move	@P1DATA+PSCORE,a0,L	;Tie!
	move	@P2DATA+PSCORE,a1,L
	cmp	a1,a0
	jrhs	bcu200			;P1 won?
bcu180	addi	190,a10			;Min X of tiles
bcu200	movi	190,a11			;X range of tiles
	movk	3,a8
bcu220	movi	DMACNZ+M_NOCOLL,a3
	callr	bonus_flashblk
	SLEEPK	2
	movi	DMAWNZ+M_NOCOLL,a3
	callr	bonus_flashblk
	SLEEPK	8
	dsj	a8,bcu220

	move	*a12+,a0,L
	calla	KILL
	SLEEP	120

	RETP


********************************
* Print bonus item count & score (Process)

	WORDPD	bonusz	,0	;ZPOS for text, set by creator


 SUBRP	bonus_prtitem	;A8=*P1/2 item cnt, A9=Y:X, A10=Pts each

	movi	RD7FONT,a11

bpilp	move	*a13(bonusz),a0
	callr	text_delz

	move	@STATUS,a2
	move	a10,a4			;A4=Pts
	movk	[0,1],a10		;Spacing

	btst	0,a2
	jrz	bpi50

	PUSH	a8,a9
	move	*a8,a8			;Get P1 cnt
	move	a8,a3
	movi	>2525,a6
	callr	strcnrmo_nosleep	;Print cnt
	callr	strcnrmo_nosleep2	;Print score
	PULL	a8,a9

bpi50	btst	1,a2
	jrz	bpi80

	PUSH	a8,a9
	addi	160,a9			;+X
	move	*a8(16),a8		;Get P2 cnt
	move	a8,a3
	movi	>2525,a6
	callr	strcnrmo_nosleep	;Print cnt
	callr	strcnrmo_nosleep2	;Print score
	PULL	a8,a9

bpi80	move	a4,a10
	SLEEPK	2
	jruc	bpilp


 SUBRP	strcnrmo_nosleep2
	mpyu	a4,a3
	move	a3,a8
	addi	45,a9			;+X

 SUBRP	strcnrmo_nosleep

	PUSH	a9
	calla	HEXTOASC
	move	*a13(bonusz),a0
	subi	20000,a0
	move	a0,@LOWZ
	clr	a0			;No sleep
	JSRP	STRCNRMO
	PULL	a9
	rets


bonusp2_as				;Scripts
	ASBXY	160,0
bonusp1_as
	ASADDW	1,animscnt
	ASNEW	bonusflag_t
	ASFRA	flag_l,>20,100

bas10	ASSLP	2
	ASJMPEQ	-1,bonusstat,bas10

	ASNEW	bonusgem_t
	ASFRA	gems_l,>21,100

bas20	ASSLP	2
	ASJMPEQ	0,bonusstat,bas20

	ASNEW	bonushstg_t

bas30	ASSLP	2
	ASJMPEQ	1,bonusstat,bas30

	ASKIL	0,>ff
	ASDELM	0,>ff

	ASADDW	-1,animscnt
	ASEND

bonus_st
	XYOBJ	PRTOBJ,200,16,500,TSCORE
	.word	-1

bonus1p1_st
	XYTXT	0,116,70,35,"X     ="
	.word	-1
bonus1p2_st
	XYTXT	0,276,70,35,"X     ="
	.word	-1

bonus2p1_st
	XYTXT	0,116,108,35,"X     ="
	.word	-1
bonus2p2_st
	XYTXT	0,276,108,35,"X     ="
	.word	-1

bonus3p1_st
	XYTXT	0,116,146,35,"X     ="
	.word	-1
bonus3p2_st
	XYTXT	0,276,146,35,"X     ="
	.word	-1

bonusflag_t
	ASITEMN	50,55,FLG1,220,DMAWNZ,>20
	.word	-1000
bonusgem_t
	ASITEMN	50,90,GEMS1,220,DMAWNZ,>21
	.word	-1000
bonushstg_t
	ASITEMN	50,130,HSTGHD,220,DMAWNZ,>21
	.word	-1000


flag_l	LW	FLG1,5
	LW	FLG2,5
	LW	FLG3,5
	LW	FLG4,5
	LWL0	FLG5,5

gems_l	LW	GEMS1,4
	LW	GEMS2,4
	LW	GEMS3,4
	LW	GEMS4,4
	LW	GEMS3,4
	LW	GEMS2,4
	LWL0	GEMS1,4


 SUBRP	bonus_flashblk		;A3=OFLAGS, A10=XMin, A11=XWidth

	move	@OBJLST,a1,L
bfb20	move	*a1(OZPOS),a0
	subi	200,a0
	subk	1,a0
	jrhi	bfb30			;Not 200-201?
	move	*a1(OXPOS),a0
	sub	a10,a0
	cmp	a11,a0
	jrhi	bfb30
	move	a3,*a1(OFLAGS)
	movi	>909,a0
	move	a0,*a1(OCONST)
bfb30	move	*a1,a1,L
	jrnz	bfb20
	rets


********************************
* Show player stats and give bonuses

 SUBRP	player_showstats

	movi	gamestat_s,a8
	movi	100,a9
	CREATE0	prt_inrackwin
	move	a0,-*a12,L

	clr	a7			;A7=Bonus pts Y:X offset

;	move	@STATUS,a0
;	cmpi	3,a0
;	jrne	pst20
;	movi	statsbo_st,a0
;	callr	prt0_xy

pst20	movi	statssnd_t,a8
	movi	stats_st,a9
	movi	statsp1_st,a10
	movi	statsp2_st,a11

pst50	move	*a8+,a0,L
	calla	ONESND
	move	@STATUS,a6
	move	a9,a0
	callr	prt0_xy
	move	a0,a9
	btst	0,a6			;P1
	jrz	pst300
	move	a10,a0
	callr	prt0_xy
	move	a0,a10
pst300	btst	1,a6			;P2
	jrz	pst400			;pst310
	move	a11,a0
	callr	prt0_xy
	move	a0,a11
pst400	move	a7,-*a12,L
	SLEEPK	10
	move	*a12+,a7,L
	move	*a9,a0
	addk	1,a0
	jrnz	pst50			;End?




;turmell
********************************************************************
;now do bonus word rackup

	move	@STATUS,a0
	cmpi	3,a0
	jrne	pst500

	clr	a7			;A7=Bonus pts Y:X offset

	movi	statsbo_st,a0
	callr	prt0_xy

bpst20	movi	statssnd_t,a8
	movk	11,a9			;i	stats_st,a9
	movi	statsp1_st,a10
	movi	statsp2_st,a11

bpst50	move	*a8+,a0,L
	calla	ONESND
bpst310
	move	*a10(-32),a2,L
	move	*a11(-32),a3,L
	cmpi	P1DATA+TMINEDTH,a2
	jrne	bpst330			;Normal compare?
	SWAP	a2,a3
bpst330	move	*a2,a2
	move	*a3,a3
	movi	P1DATA+PSCORE,a4
	movi	rackp1p,a0
	clr	a1
	cmp	a3,a2
	jrz	bpst380			;Same stats?
	jrhi	bpst350			;P1 higher?
	movi	P2DATA+PSCORE,a4
	movi	rackp2p,a0
	addi	300,a7			;P2 offset
bpst350	move	*a4,a2,L		;Give points
	addi	500,a2
	move	a2,*a4,L
	movi	statspts_st,a0
	move	a7,a1
	callr	prt_xy
bpst380	srl	16,a7			;X=0
	addk	10,a7			;Y=Y+10
	sll	16,a7

bpst400	move	a7,-*a12,L
	SLEEPK	5
	move	*a12+,a7,L
	dsj	a9,bpst50
**************************************************************************

pst500
	movi	60*14,a0
	callr	sleep_var

	move	*a12+,a0,L
	clr	a1
	move	a1,*a0(PDATA)		;Stop window text

	RETP


gamestat_s
	.byte	"GAME STATISTICS",0
	.even
statssnd_t	
	.long	stats1,stats2,stats3,stats4,stats5,stats6,stats7,stats8
	.long	stats9,stats10,stats11,stats12

SY	.equ	55

statsbo_st
	XYOBJ	PRTOBJ,50,45,280,BWORD
	XYOBJ	PRTOBJ,350,45,280,BWORD
	.word	-1
statspts_st
	XYOBJ	PRTOBJ,50,SY,280,FIVE
	.word	-1
stats_st
	XYTXT	0,200,SY,2,"SHOTS FIRED"
	XYTXT	PRTE,200,SY+10,3,"ENEMY HITS"
	XYTXT	PRTE,200,SY+20,4,"HIT PERCENTAGE"
	XYTXT	PRTE,200,SY+30,5,"HITS PER MINUTE"
	XYTXT	PRTE,200,SY+40,6,"WEAPONS PICKED UP"
	XYTXT	PRTE,200,SY+50,7,"BOMBS USED"
	XYTXT	PRTE,200,SY+60,8,"MISSILE STRIKES"
	XYTXT	PRTE,200,SY+70,9,"BIG STUFF DESTROYED"
	XYTXT	PRTE,200,SY+80,10,"EXTRA MEN EARNED"
	XYTXT	PRTE,200,SY+90,11,"MINES STEPPED ON"
	XYTXT	PRTE,200,SY+100,12,"KEYS COLLECTED"
	XYTXT	PRTE,200,SY+110,13,"HOSTAGES NOT RESCUED"
	.word	-1	;End

statsp1_st
	XYNUM	PRTDEC,95,SY,2,P1DATA+TSHOTS
	XYNUM	PRTDEC+PRTE,95,SY+10,3,P1DATA+THITS
	XYNUM	PRTDEC+PRTE,95,SY+20,4,hitpercent1
	XYNUM	PRTDEC+PRTE,95,SY+30,5,hitsmin1
	XYNUM	PRTDEC+PRTE,95,SY+40,6,P1DATA+TWPNS
	XYNUM	PRTDEC+PRTE,95,SY+50,7,P1DATA+BMBSUSED
	XYNUM	PRTDEC+PRTE,95,SY+60,8,P1DATA+TMISLS
	XYNUM	PRTDEC+PRTE,95,SY+70,9,P1DATA+TBIGSTF
	XYNUM	PRTDEC+PRTE,95,SY+80,10,P1DATA+TEARNED
	XYNUM	PRTDEC+PRTE,95,SY+90,11,P1DATA+TMINEDTH
	XYNUM	PRTDEC+PRTE,95,SY+100,12,P1DATA+TKEYS
	XYNUM	PRTDEC+PRTE,95,SY+110,13,HSTGS_LOST
	.word	-1

statsp2_st
	XYNUM	PRTDEC,305,SY,2,P2DATA+TSHOTS
	XYNUM	PRTDEC+PRTE,305,SY+10,3,P2DATA+THITS
	XYNUM	PRTDEC+PRTE,305,SY+20,4,hitpercent2
	XYNUM	PRTDEC+PRTE,305,SY+30,5,hitsmin2
	XYNUM	PRTDEC+PRTE,305,SY+40,6,P2DATA+TWPNS
	XYNUM	PRTDEC+PRTE,305,SY+50,7,P2DATA+BMBSUSED
	XYNUM	PRTDEC+PRTE,305,SY+60,8,P2DATA+TMISLS
	XYNUM	PRTDEC+PRTE,305,SY+70,9,P2DATA+TBIGSTF
	XYNUM	PRTDEC+PRTE,305,SY+80,10,P2DATA+TEARNED
	XYNUM	PRTDEC+PRTE,305,SY+90,11,P2DATA+TMINEDTH
	XYNUM	PRTDEC+PRTE,305,SY+100,12,P2DATA+TKEYS
	XYNUM	PRTDEC+PRTE,305,SY+110,13,HSTGS_LOST
	.word	-1


********************************
* Player bonus winner animations


 SUBRP	player_bonuswin

	CLR	A9			;A9=LITTLE MESSAGE ON CONTROL PANEL
;TURMELL
	movi	plbwp1o_as,a8		;P1 only initial script
	move	@STATUS,a0
	btst	1,a0
	jrz	pbw90
	MOVK	1,A9
;TURMELL
	movi	plbwp2o_as,a8		;P2 only initial script
	btst	0,a0
	jrz	pbw90

	movi	plbwp1w_as,a8		;P1 win initial script
	MOVK	2,A9
;TURMELL

	move	@P1DATA+PSCORE,a0,L
	move	@P2DATA+PSCORE,a1,L
	cmp	a1,a0			;P1 score > P2 score?
	jrhi	pbw90
	jrlo	pbw80			;P1sc < P2sc
	move	@score1old,a3,L
	move	@score2old,a4,L
	cmp	a4,a3			;Score same!
	jrlo	pbw90			;P1 old < P2 old?

pbw80	movi	plbwp2w_as,a8		;P2 win initial script
	MOVK	3,A9
;TURMELL
pbw90	CREATE	ANIMPID,PRT_WIN		;PRINT WINNER MESSAGE
;TURMELL
	CREATE	ANIMPID,anim_script

	movi	1*32*32+15*32+27,a0	;Bkgnd color
	move	a0,@IRQSKYE

	move	@OBJLST,a1,L		;>Tiles fly away
pbw200	move	*a1(OZPOS),a0
	subi	200,a0
	subk	1,a0
	jrhi	pbw230
	movk	8,a2			;Vel
	btst	0,a0
	jrnz	pbw220
	neg	a2			;-Vel
pbw220	move	a2,*a1(OYVEL+16)

pbw230	move	*a1,a1,L
	jrnz	pbw200

	SLEEP	60

	move	@OBJLST,a0,L		;>Delete tiles
pbw300	move	*a0(OZPOS),a2
	subi	200,a2
	subk	1,a2
	jrhi	pbw330
	move	*a0,a1,L		;Get * to next obj
	calla	DELOBJ			;Kill
	move	a1,a0
	jruc	pbw340
pbw330	move	*a0,a0,L
pbw340	jrnz	pbw300

	movi	200,a0
	callr	sleep_var

;	movi	plbwpal_t,a0		;*Palette list
;	movk	5,a1
;	movi	>40,a2
;	move	a2,@PCOUNT
;	calla	FADEOUT2
;
;	SLEEPK	30

	RETP

PRT_WIN
;TURMELL
;A9=0-3 FOR MESSAGE TO PRINT
;0=PLYR 1 ONLY
;1=PLYR 2 ONLY
;2=PLYR 1 WINS OVER PLYR 2
;3=PLYR 2 WINS OVER PLYR 1
	SLL	5,A9
	ADDI	WINMSGS,A9
	MOVE	*A9,A8,L		;MESSAGE PNTR
	movi	22H,a9
	CREATE	ANIMPID,prt_inrackwin
	DIE

WINMSGS	.LONG	WIN0,WIN1,WIN2,WIN3

;COME UP WITH MORE CLEVER TEXT HERE!
WIN0	.BYTE	"PLAYER ONE IS GREAT!",0
WIN1	.BYTE	"PLAYER TWO IS GREAT!",0
WIN2	.BYTE	"PLAYER ONE KICKED BUTT!",0
WIN3	.BYTE	"PLAYER TWO KICKED BUTT!",0
	.EVEN


;plbwpal_t
;	.long	0,BIGPL1,GUNSP1,CLDS9,DESRTPL,BIGPL2,GUNSP2,0


plbwp1o_as
	ASNEW	plyr1wnew_t
	ASXY	>40,>1f,70,0
	ASJMP	plbw_as

plbwp2o_as
	ASNEW	plyr2wnew_t
	ASXY	>40,>1f,-50,0
	ASSVL	BIGPL2
	ASPAL	>41
	ASPAL	>54
	ASPAL	>55
	ASSVL	GUNSP2
	ASPAL	>42
	ASPAL	>48
	ASJMP	plbw_as

plbwp1w_as
	ASNEW	plyr1wnew_t
	ASNEW	plyr2lnew_t
	ASSVL	BIGPL2
	ASPAL	>81
	ASSVL	GUNSP2
	ASPAL	>82
	ASPAL	>88
	ASRUN	plbw2txt_as
	ASJMP	plbw_as

plbwp2w_as
	ASNEW	plyr1lnew_t
	ASNEW	plyr2wnew_t
	ASSVL	BIGPL2
	ASPAL	>41
	ASPAL	>54
	ASPAL	>55
	ASSVL	GUNSP2
	ASPAL	>42
	ASPAL	>48
	ASRUN	plbw1txt_as

plbw_as
	ASADDW	1,animscnt
	ASNEW	plyrbgnew_t
	ASFRA	ribbonb_l,>48,-1
	ASFRA	ribbonl_l,>88,-1

	ASRUN	pbwcloud1_as
	ASRUN	pbwcloud2_as
	ASRUN	pbwcloud3_as
	ASRUN	pbwsnd_as
	ASSLP	90
	ASFRA	plhdcc_l,>4c,1
	ASFRA	plhdmm_l,>4d,1
	ASLAB	5
	ASXY	0,>ff,0,1	;Pan up
	ASSLP	1
	ASDSJ
	ASLAB	20
	ASXY	0,>ff,0,2
	ASSLP	1
	ASDSJ
	ASLAB	5
	ASXY	0,>ff,0,1
	ASSLP	1
	ASDSJ

	ASANI	LBOW2,>54
	ASANI	WRISTBND2,>50
	ASANI	HAND2,>55
	ASANI	GUN2,>51
	ASXY	>44,1,-1000,0	;Put middle strap on screen
	ASSLP	4
	ASANI	LBOW1,>54
	ASANI	WRISTBND1,>50
	ASANI	HAND1,>55
	ASANI	GUN1,>51
	ASXY	>44,1,-1000,0	;Straps off screen

	ASLAB	40
	ASSND	rackgun
	ASLAB	2
	ASXY	>50,>7,0,1	;Shake gun
	ASXY	>56,0,-1000,0	;Show flame
	ASSLP	1
	ASDSJ
	ASLAB	2
	ASXY	>50,>7,0,-1
	ASXY	>56,0,1000,0	;Hide flame
	ASSLP	1
	ASDSJ
	ASDSJ

	ASSLP	30
	ASLAB	5
	ASXY	0,>ff,0,-1	;Pan down
	ASSLP	1
	ASDSJ
	ASLAB	20
	ASXY	0,>ff,0,-2
	ASSLP	1
	ASDSJ
	ASLAB	5
	ASXY	0,>ff,0,-1
	ASSLP	1
	ASDSJ

	ASSLP	20
	ASANI	LBOW2,>54
	ASANI	WRISTBND2,>50
	ASANI	HAND2,>55
	ASANI	GUN2,>51
	ASXY	>44,1,1000,0	;Middle strap on screen
	ASSLP	4
	ASANI	LBOW3,>54
	ASANI	WRISTBND3,>50
	ASANI	HAND3,>55
	ASANI	GUN3,>51
	ASXY	>44,1,1000,0	;1st strap on screen
	ASADDW	-1,animscnt
	ASEND


pbwcloud1_as
	ASLAB	4
	ASLAB	188
	ASXY	>10,0,1,0
	ASSLP	4
	ASDSJ
	ASXY	>10,0,-188,0
	ASDSJ
	ASEND
pbwcloud2_as
	ASLAB	4
	ASLAB	188
	ASXY	>11,0,1,0
	ASSLP	5
	ASDSJ
	ASXY	>11,0,-188,0
	ASDSJ
	ASEND
pbwcloud3_as
	ASLAB	4
	ASLAB	188
	ASXY	>12,0,1,0
	ASSLP	6
	ASDSJ
	ASXY	>12,0,-188,0
	ASDSJ
	ASEND


pbwsnd_as			;Sounds
	ASSLP	130
	ASSND	shout
	ASSLP	170
	ASSND	gigle1
	ASEND


CLY	.equ	142

plyrbgnew_t	;X,Y,img name,Z,oflags,oid

	ASITEMN	12,-40,CLOUD,25,DMAWNZ+M_FLIPH,>10
	ASITEMN	200,-40,CLOUD,25,DMAWNZ+M_FLIPH,>10
	ASITEMN	388,-40,CLOUD,25,DMAWNZ+M_FLIPH,>10
	ASITEMN	12,-10,CLOUD,24,DMAWNZ+M_FLIPH,>11
	ASITEMN	200,-10,CLOUD,24,DMAWNZ+M_FLIPH,>11
	ASITEMN	388,-10,CLOUD,24,DMAWNZ+M_FLIPH,>11
	ASITEMN	-178,20,CLOUD,23,DMAWNZ,>12
	ASITEMN	10,20,CLOUD,23,DMAWNZ,>12
	ASITEMN	198,20,CLOUD,23,DMAWNZ,>12
	ASITEMN	10,CLY,CLIFF3A,30,DMAWNZ,8
	ASITEMN	128,CLY,CLIFF3A,30,DMAWNZ+M_FLIPH,8
	ASITEMN	129,CLY+6,CLIFF2A,30,DMAWNZ,8
	ASITEMN	186,CLY-1,CLIFF3A,30,DMAWNZ,8
	ASITEMN	304,CLY-1,CLIFF3A,30,DMAWNZ+M_FLIPH,8
	ASITEMN	355,CLY+7,CLIFF2A,30,DMAWNZ+M_FLIPH,8
	ASITEMN	356,CLY+1,CLIFF3A,30,DMAWNZ,8
	.word	-1000

P1X	.equ	120
P1Y	.equ	23
P1LX	.equ	70
P1LY	.equ	30
P2X	.equ	260
P2Y	.equ	23
P2LX	.equ	305
P2LY	.equ	30

plyr1wnew_t
	ASITEMN	P1X,P1Y,CCHED1,51,DMAWNZ,>4c
	ASITEMN	P1X,P1Y,RIB1,45,DMAWNZ,>48
	ASITEMN	P1X,P1Y,BDBOD1,50,DMAWNZ,>40
	ASITEMN	P1X,P1Y,BDBOD2,50,DMAWNZ,>40
	ASITEMN	P1X,P1Y,RTARMBND,51,DMAWNZ,>40
	ASITEMN	P1X,P1Y,RTLBOW1,52,DMAWNZ,>40
	ASITEMN	P1X,P1Y,RTWRISTBND,53,DMAWNZ,>40
	ASITEMN	P1X,P1Y,RTHAND1,53,DMAWNZ,>40
	ASITEMN	P1X,P1Y,LFTARMBND,52,DMAWNZ,>40
	ASITEMN	P1X,P1Y,LBOW3,51,DMAWNZ,>54
	ASITEMN	P1X,P1Y,WRISTBND3,52,DMAWNZ,>50
	ASITEMN	P1X,P1Y,HAND3,54,DMAWNZ,>55
	ASITEMN	P1X,P1Y,GUN3,53,DMAWNZ,>51
	ASITEMN	P1X,P1Y,STRAP,51,DMAWNZ,>44
	ASITEMN	P1X+1000,P1Y,STRAPA,51,DMAWNZ,>45
	ASITEMN	P1X+1054,P1Y-33,T72BLAST1,55,DMAWNZ+M_FLIPV,>56
	ASITEMN	P1X+2054,P1Y-33,T72BLAST2,55,DMAWNZ+M_FLIPV,>56
	.word	-1000

plyr2wnew_t
	ASITEMN	P2X,P2Y,MMHED1,51,DMAWNZ+M_FLIPH,>4d
	ASITEMN	P2X,P2Y-5,RIB1,45,DMAWNZ,>48
	ASITEMN	P2X,P2Y,BDBOD1,50,DMAWNZ+M_FLIPH,>41
	ASITEMN	P2X,P2Y,BDBOD2,50,DMAWNZ+M_FLIPH,>42
	ASITEMN	P2X,P2Y,RTARMBND,51,DMAWNZ+M_FLIPH,>40
	ASITEMN	P2X,P2Y,RTLBOW1,52,DMAWNZ+M_FLIPH,>41
	ASITEMN	P2X,P2Y,RTWRISTBND,53,DMAWNZ+M_FLIPH,>40
	ASITEMN	P2X,P2Y,RTHAND1,53,DMAWNZ+M_FLIPH,>41
	ASITEMN	P2X,P2Y,LFTARMBND,52,DMAWNZ+M_FLIPH,>40
	ASITEMN	P2X,P2Y,LBOW3,51,DMAWNZ+M_FLIPH,>54
	ASITEMN	P2X,P2Y,WRISTBND3,52,DMAWNZ+M_FLIPH,>50
	ASITEMN	P2X,P2Y,HAND3,54,DMAWNZ+M_FLIPH,>55
	ASITEMN	P2X,P2Y,GUN3,53,DMAWNZ+M_FLIPH,>51
	ASITEMN	P2X,P2Y,STRAP,51,DMAWNZ+M_FLIPH,>44
	ASITEMN	P2X+1000,P2Y,STRAPA,51,DMAWNZ+M_FLIPH,>45
	ASITEMN	P2X+945,P2Y-33,T72BLAST1,55,DMAWNZ+M_FLIPV,>56
	ASITEMN	P2X+1945,P2Y-33,T72BLAST2,55,DMAWNZ+M_FLIPV,>56
	.word	-1000

plyr1lnew_t
	ASITEMN	P1LX,P1LY,SMHEAD1,40,DMAWNZ+M_FLIPH,>80
	ASITEMN	P1LX-10,P1LY,LILRIB1,35,DMAWNZ,>88
	ASITEMN	P1LX,P1LY,SMBOD1,40,DMAWNZ+M_FLIPH,>81
	ASITEMN	P1LX,P1LY,SMBOD2,40,DMAWNZ+M_FLIPH,>82
	ASITEMN	P1LX,P1LY,SMARMBND,41,DMAWNZ+M_FLIPH,>80
	ASITEMN	P1LX,P1LY,SMWRISTS,41,DMAWNZ+M_FLIPH,>80
	.word	-1000

plyr2lnew_t
	ASITEMN	P2LX,P2LY,SMHEAD2,40,DMAWNZ,>80
	ASITEMN	P2LX-1,P2LY-3,LILRIB1,35,DMAWNZ,>88
	ASITEMN	P2LX,P2LY,SMBOD1,40,DMAWNZ,>81
	ASITEMN	P2LX,P2LY,SMBOD2,40,DMAWNZ,>82
	ASITEMN	P2LX,P2LY,SMARMBND,41,DMAWNZ,>80
	ASITEMN	P2LX,P2LY,SMWRISTS,41,DMAWNZ,>80
	.word	-1000


ribbonb_l
	LW	RIB1,4
	LW	RIB2,4
	LW	RIB3,4
	LW	RIB4,4
	LWL0	RIB5,4

ribbonl_l
	LW	LILRIB1,3
	LW	LILRIB2,4
	LW	LILRIB3,3
	LW	LILRIB4,4
	LWL0	LILRIB5,4

plhdcc_l
	LW	CCHED1,30
	LW	CCHED2,8
	LW	CCHED3,8
	LW	CCHED4,60
	LW	CCHED3,5
	LW	CCHED2,5
	LW	CCHED1,70
	LW	CCHED5,5
	LWL0	CCHED6,15

plhdmm_l
	LW	MMHED1,30
	LW	MMHED2,8
	LW	MMHED3,8
	LW	MMHED4,60
	LW	MMHED3,5
	LW	MMHED2,5
	LW	MMHED1,70
	LW	MMHED5,5
	LWL0	MMHED6,15

plbw1txt_as
	ASSLP	140
	ASNEW	plbw1balloon_t
	ASASM
	movk	2,a0
	calla	RNDRNG0
	subk	1,a0
	jrn	plbw110
	jrz	plbw120
	ASENDASM
	ASTXT	plbw1lose1_st
	ASJMP	plbw280

plbw110	ASENDASM
	ASTXT	plbw1lose2_st
	ASJMP	plbw280

plbw120	ASENDASM
	ASTXT	plbw1lose3_st
	ASJMP	plbw280

plbw2txt_as
	ASSLP	140
	ASNEW	plbw2balloon_t
	ASASM
	movk	2,a0
	calla	RNDRNG0
	subk	1,a0
	jrn	plbw210
	jrz	plbw220
	ASENDASM
	ASTXT	plbw2lose1_st
	ASJMP	plbw280

plbw210	ASENDASM
	ASTXT	plbw2lose2_st
	ASJMP	plbw280

plbw220	ASENDASM
	ASTXT	plbw2lose3_st
plbw280	ASSLP	140
	ASDEL	2
	ASTXTK
	ASEND

plbw1balloon_t
	ASITEMN	P1LX+0,P1LY+8-20,BLLN1,46,DMAWNZ,2
	ASITEMN	P1LX+20,P1LY+8-20,BLLN2,46,DMAWNZ,2
	ASITEMN	P1LX+40,P1LY+8-20,BLLN2,46,DMAWNZ,2
	ASITEMN	P1LX+80,P1LY+8-20,BLLN1,46,DMAWNZ+M_FLIPH,2
	ASITEMN	P1LX+40,P1LY+40-20,BOON2B,47,DMAWNZ+M_FLIPH,2
	.word	-1000

plbw2balloon_t
	ASITEMN	P2LX-80,P2LY+8-20,BLLN1,46,DMAWNZ,2
	ASITEMN	P2LX-60,P2LY+8-20,BLLN2,46,DMAWNZ,2
	ASITEMN	P2LX-40,P2LY+8-20,BLLN2,46,DMAWNZ,2
	ASITEMN	P2LX+0,P2LY+8-20,BLLN1,46,DMAWNZ+M_FLIPH,2
	ASITEMN	P2LX-40,P2LY+40-20,BOON2B,47,DMAWNZ,2
	.word	-1000

plbw1lose1_st
	XYTXT	PRTF8,P1LX+40,P1LY+12-20,2,"I SUCK AT"
	XYTXT	PRTF8,P1LX+40,P1LY+22-20,2,"THIS GAME."
	.word	-1
plbw1lose2_st
	XYTXT	PRTF8,P1LX+40,P1LY+12-20,2,"I NEED"
	XYTXT	PRTF8,P1LX+40,P1LY+22-20,2,"A DRINK..."
	.word	-1
plbw1lose3_st
	XYTXT	PRTF8,P1LX+40,P1LY+12-20,2,"I NEED"
	XYTXT	PRTF8,P1LX+40,P1LY+22-20,2,"MORE CASH."
	.word	-1
plbw2lose1_st
	XYTXT	PRTF8,P2LX-40,P2LY+12-20,2,"PLAYER 1"
	XYTXT	PRTF8,P2LX-40,P2LY+22-20,2,"IS A DORK."
	.word	-1
plbw2lose2_st
	XYTXT	PRTF8,P2LX-40,P2LY+12-20,2,"THAT BOY"
	XYTXT	PRTF8,P2LX-40,P2LY+22-20,2,"IS GOOD..."
	.word	-1
plbw2lose3_st
	XYTXT	PRTF8,P2LX-40,P2LY+12-20,2,"HOW CAN I"
	XYTXT	PRTF8,P2LX-40,P2LY+22-20,2,"BEAT HIM?"
	.word	-1

********************************
* Dictator taunts players


 SUBRP	dictator_taunt		;A0=Taunt # (0-?)

	movi	dictator0_as,a8
	subk	1,a0
	jrnz	dt20
	movi	dictator1_1p_as,a8	;1 Player
	move	@STATUS,a0
	cmpi	3,a0
	jrnz	dt20
	movi	dictator1_2p_as,a8	;2 Players
dt20	CREATE	ANIMPID,anim_script
	jruc	anim_wait

dictator0_as
	ASRUN	dicttxt0_as
	ASJMP	dictmain_as

dictator1_1p_as				;1 player game
	ASRUN	dicttxt1a_as
	ASJMP	dictmain_as

dictator1_2p_as				;2 player game
	ASRUN	dicttxt1b_as

dictmain_as
	ASADDW	1,animscnt
	ASNEW	dictnew_t
	ASNEW	dictnew2_t

	ASSND	txtssnd
	ASLAB	50			;Scroll up
	ASXY	0,>1f,0,-4
	ASSLP	1
	ASDSJ

	ASSLP	30
	ASNEW	dictboon_t
	ASRUN	dictarm_as
	ASRUN	dictsnd_as
	ASRUN	dicteyes_as

	ASFRA	dictmtk_l,>18,3
	ASFRA	dictmtk_l,>19,3

	ASWAIT

	ASFRA	dictmtk2_l,>18,1
	ASFRA	dictmtk2_l,>19,1

	ASWAIT

	ASFRA	dictmtk_l,>18,1
	ASFRA	dictmtk_l,>19,1

	ASWAIT

	ASFRA	dictmtk2_l,>18,1
	ASFRA	dictmtk2_l,>19,1

	ASWAIT

	ASFRA	dicteymd_l,>10,1
	ASFRA	dicteymd_l,>11,1
	ASFRA	dictmyell_l,>18,1
	ASFRA	dictmyell_l,>19,1

	ASWAIT
	ASRUN	dicteyes_as
	ASSLP	40
	ASFRA	dictmusuck_l,>18,1
	ASFRA	dictmusuck_l,>19,1

	ASWAIT

	ASFRA	dictsmile_l,>18,1
	ASFRA	dictsmile_l,>19,1

	ASSLP	60*4
	ASADDW	-1,animscnt
	ASEND


dicttxt0_as
	ASSLP	80
	ASTXT	dicttxta1_st		;Say1
	ASSLP	180
	ASTXTK
	ASTXT	dicttxta2_st		;Say2
	ASSLP	204
	ASTXTK
	ASTXT	dicttxta3_st		;Say3
	ASEND

dicttxt1a_as
	ASSLP	80
	ASTXT	dicttxtb1a_st		;Say1
	ASJMP	dicttxt1_as

dicttxt1b_as
	ASSLP	80
	ASTXT	dicttxtb1b_st		;Say1

dicttxt1_as
	ASSLP	180
	ASTXTK
	ASTXT	dicttxtb2_st		;Say2
	ASSLP	204
	ASTXTK
	ASTXT	dicttxtb3_st		;Say3
	ASEND


dictarm_as				;Move arm
	ASSLP	90

	ASLAB	28
	ASXY	>20,1,-1,-8
	ASSLP	1
	ASDSJ

	ASSLP	20

	ASLAB	3
	ASLAB	10

	ASLAB	3
	ASXY	>20,1,0,1
	ASSLP	1
	ASDSJ
	ASLAB	3
	ASXY	>20,1,0,-1
	ASSLP	1
	ASDSJ

	ASDSJ
	ASSLP	30
	ASDSJ

	ASLAB	4		;>Bang arm up and down

	ASLAB	6
	ASXY	>20,1,1,14
	ASSLP	1
	ASDSJ
	ASXY	0,>3f,0,-2	;body up
	ASSND	fisthit
	ASSLP	1
	ASXY	0,>3f,0,2	;body dn

	ASLAB	6
	ASXY	>20,1,-1,-14
	ASSLP	1
	ASDSJ

	ASDSJ

	ASLAB	8		;>move arm off screen
	ASXY	>20,1,1,14
	ASSLP	1
	ASDSJ
	ASXY	0,>3f,0,-2	;body up
	ASSND	GLSEXP
	ASSLP	1
	ASXY	0,>3f,0,2	;body dn

	ASEND

dicteyes_as
	ASFRA	dicteybl_l,>10,2
	ASFRA	dicteybl_l,>11,2
	ASEND


dictsnd_as
	ASSLP	15
	ASSND	ahkb1
	ASSLP	60
	ASSND	ahkb2
	ASSLP	60
	ASSND	ahkb3
	ASSLP	60
	ASSND	ahkbsta
	ASSLP	72
	ASSND	ahkb1
	ASSLP	60
	ASSND	ahkbsta
	ASSLP	72
	ASSND	ahkbang
	ASSLP	115
	ASASM
	move	@TNT_TYPE,a0		;0=TAUNT ONE,1=RACK UP ONE
	jrnz	dsnd5
	ASENDASM
	ASSND	ahkbang
	ASSLP	65
	ASSND	CVSDOFF
	ASEND

dsnd5	ASENDASM
	ASSND	yousuck
	ASEND

dictnew_t
	ASITEMN	67,66,WRINK2,30,DMAWNZ+M_FLIPH+M_FLIPV,>40
	ASITEMN	328,66,WRINK2,30,DMAWNZ+M_FLIPV,>40
	ASITEMN	15,132,WRINK1,30,DMAWNZ,>40
	ASITEMN	370,132,WRINK1,30,DMAWNZ+M_FLIPH,>40
	ASITEMN	122,25,BIOSIGN,30,DMAWNZ,>40
	ASITEMN	273,25,BIOSIGN,30,DMAWNZ+M_FLIPH,>40
	.word	-1000				;End

X	.set	145
dictnew2_t
	ASITEMN	X+1,210,MADBOD,250,DMAWNZ,1
	ASITEMN	X,210,MADBOD,250,DMAWNZ+M_FLIPH,1
	ASITEMN	X+1,210,MADNECK,250,DMAWNZ,1
	ASITEMN	X,210,MADNECK,250,DMAWNZ+M_FLIPH,1
	ASITEMN	X+1,210,MADHAT,250,DMAWNZ,1
	ASITEMN	X,210,MADHAT,250,DMAWNZ+M_FLIPH,1
	ASITEMN	X+1,210,MADEYE1,252,DMAWNZ,>10
	ASITEMN	X,210,MADEYE1,252,DMAWNZ+M_FLIPH,>11
	ASITEMN	X+1,210,MTHGRIM,252,DMAWNZ,>18
	ASITEMN	X,210,MTHGRIM,252,DMAWNZ+M_FLIPH,>19
	ASITEMN	X+74,300,MADARM,255,DMAWNZ+M_FLIPH,>20
	ASITEMN	X+74,300,MADFIST,256,DMAWNZ+M_FLIPH,>21
	.word	-1000

dictboon_t
	ASITEMN	220,17,BOON1,240,DMAWNZ,>60
	ASITEMN	350,17,BOON1,240,DMAWNZ+M_FLIPH,>60
	ASITEMN	270,75,BOON2,240,DMAWNZ+M_FLIPH,>60
	.word	-1000


dicteybl_l
	LW	MADEYE1,20
	LW	MADEYE2,20
	LW	MADEYE3,50
	LW	MADEYE2,6
	LW	MADEYE1,5
	LW	MADEYE2,6
	LW	MADEYE3,40
	LW	MADEYE2,5
	LW	MADEYE1,4
	LW	MADEYE2,4
	LW	MADEYE1,5
	LW	MADEYE2,4
	LW	MADEYE3,50
	LW	MADEYE2,6
	LWL0	MADEYE1,5

dicteymd_l
	LW	MADEYE1,5
	LW	MADEYE2,15
	LW	MADEYE3,30
	LWL0	MADEYE1,1

dictmtk_l
	LW	MTHSMILE1,10		;Mouth for ahkb1,2,3 (60 ticks)
	LW	MTHOPEN1,4
	LW	MTHOPEN2,4
	LW	MTHOPEN1,3

	LW	MTHSMILE1,3
	LW	MTHOPEN1,4
	LW	MTHOPEN2,3
	LW	MTHOPEN3,4
	LW	MTHOPEN2,3
	LW	MTHOPEN1,3

	LW	MTHSMILE1,3
	LW	MTHOPEN1,3
	LW	MTHOPEN2,3
	LW	MTHOPEN3,3
	LW	MTHOPEN2,3
	LW	MTHOPEN1,3

	LWL0	MTHSMILE1,1

dictmtk2_l
	LW	MTHSMILE1,3		;ahkbsta (72 ticks)
	LW	MTHOPEN1,3
	LW	MTHOPEN2,3
	LW	MTHOPEN3,3
	LW	MTHOPEN2,3
	LW	MTHOPEN1,3

	LW	MTHSMILE1,2
	LW	MTHOPEN1,2
	LW	MTHOPEN2,2
	LW	MTHOPEN1,3

	LW	MTHSMILE1,2
	LW	MTHOPEN1,2
	LW	MTHOPEN2,3
	LW	MTHOPEN3,2
	LW	MTHOPEN2,3

	LW	MTHOPEN1,3
	LW	MTHOPEN2,2
	LW	MTHOPEN1,2

	LW	MTHOPEN1,3
	LW	MTHOPEN2,3
	LW	MTHOPEN3,2
	LW	MTHOPEN2,3
	LW	MTHOPEN1,3

	LW	MTHSMILE1,2
	LW	MTHOPEN1,3
	LW	MTHOPEN2,3
	LW	MTHOPEN1,3
	LWL0	MTHSMILE1,1


dictmyell_l
	LW	MTHOPEN1,2		;ahkbang (75 ticks)
	LW	MTHOPEN2,2
	LW	MTHOPEN3,3
	LW	MTHOPEN2,1

	LW	MTHOPEN1,3
	LW	MTHOPEN2,3
	LW	MTHOPEN3,2
	LW	MTHOPEN2,3

	LW	MTHSMILE1,1
	LW	MTHOPEN1,2
	LW	MTHOPEN2,3
	LW	MTHOPEN3,3
	LW	MTHOPEN2,2

	LW	MTHOPEN1,3
	LW	MTHOPEN2,2
	LW	MTHOPEN1,2

	LW	MTHSMILE1,2
	LW	MTHOPEN1,2
	LW	MTHOPEN2,2
	LW	MTHOPEN3,2
	LW	MTHOPEN2,2

	LW	MTHOPEN1,2
	LW	MTHOPEN2,3
	LW	MTHOPEN1,3

	LW	MTHSMILE1,3
	LW	MTHOPEN1,3
	LW	MTHOPEN2,3
	LW	MTHOPEN3,3
	LW	MTHOPEN2,3
	LW	MTHOPEN1,3
	LWL0	MTHSMILE1,2

dictmusuck_l
	LW	MTHSMILE1,5		;You suck at this game!
	LW	MTHOPEN1,3
	LW	MTHOPEN2,3
	LW	MTHOPEN3,2
	LW	MTHOPEN2,3
	LW	MTHOPEN1,3

	LW	MTHSMILE1,2
	LW	MTHOPEN1,3
	LW	MTHOPEN2,2
	LW	MTHOPEN3,2
	LW	MTHOPEN2,2

	LW	MTHOPEN1,2
	LW	MTHOPEN2,2
	LW	MTHOPEN3,3
	LW	MTHOPEN2,2

	LW	MTHSMILE1,2
	LW	MTHOPEN1,2
	LW	MTHOPEN2,2
	LW	MTHOPEN3,2
	LW	MTHOPEN2,2
	LW	MTHOPEN1,2

	LW	MTHSMILE1,2
	LW	MTHOPEN1,2
	LW	MTHOPEN2,2
	LW	MTHOPEN3,2
	LW	MTHOPEN2,2
	LWL0	MTHOPEN1,2

dictsmile_l
	LW	MTHSMILE1,30
	LW	MTHGRIM,50
	LW	MTHSMILE1,8
	LWL0	MTHSMILE2,60


dicttxta1_st
	XYTXT	PRTF8,286,25,1,"AMERICAN PIGS!!"
	XYTXT	PRTF8,286,36,1,"GET OUT OF MY"
	XYTXT	PRTF8,286,47,1,"PEACE LOVING"
	XYTXT	PRTF8,286,58,1,"COUNTRY."
	.word	-1
dicttxta2_st
	XYTXT	PRTF8,286,30,1,"THESE ACTS OF"
	XYTXT	PRTF8,286,41,1,"AGGRESSION WILL"
	XYTXT	PRTF8,286,52,1,"NOT BE TOLERATED!"
	.word	-1
dicttxta3_st
	XYTXT	PRTF8,286,25,1,"PURSUE ME AND"
	XYTXT	PRTF8,286,36,1,"YOU SHALL SWIM"
	XYTXT	PRTF8,286,47,1,"IN POOLS OF YOUR"
	XYTXT	PRTF8,286,58,1,"OWN BLOOD!!"
	.word	-1

dicttxtb1b_st 	;FOR 2 PLYRS
	XYTXT	PRTF8,286,25,1,"YOU BOTH SUCK AT"
	XYTXT	PRTF8,286,36,1,"THIS GAME!  YOU"
	XYTXT	PRTF8,286,47,1,"WILL NOT CAPTURE"
	XYTXT	PRTF8,286,58,1,"ME. I AM TOO GOOD."
	.word	-1
dicttxtb1a_st	;FOR 1 PLYR
	XYTXT	PRTF8,286,25,1,"YOU SUCK AT THIS"
	XYTXT	PRTF8,286,36,1,"GAME!  YOU SHALL"
	XYTXT	PRTF8,286,47,1,"NEVER CAPTURE ME!"
	XYTXT	PRTF8,286,58,1,"I AM TOO GOOD."
	.word	-1
dicttxtb2_st
	XYTXT	PRTF8,286,25,1,"WITH MY ADVANCED"
	XYTXT	PRTF8,286,36,1,"BIO-NUCLEAR"
	XYTXT	PRTF8,286,47,1,"FACTORY I WILL"
	XYTXT	PRTF8,286,58,1,"RULE THE WORLD!!"
	.word	-1
dicttxtb3_st
	XYTXT	PRTF8,286,25,1,"SO GIVE UP NOW"
	XYTXT	PRTF8,286,36,1,"OR MY MEN WILL"
	XYTXT	PRTF8,286,47,1,"PULL YOUR HEAD"
	XYTXT	PRTF8,286,58,1,"OFF!"
	.word	-1

	NOTINUSE
;dicttxtb1b_st
;	XYTXT	PRTF8,286,25,1,"YOU BOTH SUCK AT" 	;For 2 plyrs
;	XYTXT	PRTF8,286,36,1,"THIS GAME!  YOU"
;	XYTXT	PRTF8,286,47,1,"WON'T CAPTURE ME"
;	XYTXT	PRTF8,286,58,1,"CUZ I CAN DANCE."
;	.word	-1
;dicttxtb1a_st
;	XYTXT	PRTF8,286,25,1,"YOU SUCK AT THIS" 	;For 1 plyr
;	XYTXT	PRTF8,286,36,1,"GAME!  YOU SHALL"
;	XYTXT	PRTF8,286,47,1,"NEVER CAPTURE ME"
;	XYTXT	PRTF8,286,58,1,"CUZ I CAN DANCE."
;	.word	-1
dicttxt4_st
	XYTXT	PRTF8,320,25,1,"YOU WILL DIE!"
	XYTXT	PRTF8,320,35,1,"YOU WILL DIE!!"
	XYTXT	PRTF8,320,45,1,"YOU WILL DIE!!!"
	.word	-1
dicttxt8_st
	XYTXT	PRTF8,320,25,1,("IF YOU CONTINUE,")
	XYTXT	PRTF8,320,35,1,"THE HOSTAGES"
	XYTXT	PRTF8,320,45,1,"WILL DIE!"
	.word	-1
	.endif



********************************
* Electrocution code


 SUBR	fry_plyrs	;A8=Fry # (0=Plyrs, 1=Dict)

;	clr	a8			;DEBUG
;	movk	1,a8			;DEBUG

;	movi	>1000,a0
;	calla	KIL1C			;DEBUG

	movi	ermtune,a0
	calla	ONESND

	calla	STOPOBJS		;Keep all objs still

	movk	1,a0			;Delay start of a 2nd plyr
	move	a0,@NO_START
	move	a0,@INTRO

	clr	a0
	move	a0,@IRQSKYE

	movk	10,a0
	move	a0,@WORLDTLX+16
	movi	960,a0
	move	a0,@WORLDTLY+16

	SLEEPK	2
	move	a8,a8
	jrnz	fry_dict

	movi	frypbg_t,a0		;Show electric chairs
	move	a0,@BAKMODS,L
	calla	BGND_UD1

	movi	CHAIRP,a8 		;Pal name
	movi	cycmem,a9		;Ram area
	movi	[59,64],a10		;Begin/end color #
	movk	4,a11			;Rate in ticks
	CREATE	CYCPID,COLCYC		;Color cycler on

;	JSRP	WNDWOFF

;	SLEEP	80
;	calla	ERASE_TXT

;	SLEEP	96

 	move	@PLYROBJS,a9,L
	jrz	f50
	calla	STOPPLYR
f50	move	@PLYROBJS+32,a9,L
	jrz	f55
	calla	STOPPLYR
f55
;	clr	a0
;	move	a0,@HALT

;	movk	1,a11
;	CREATE0	STATIC_COVER
;	SLEEPK	25

debugf
	movi	frypdict_as,a8		;Dictator taunt
	CREATE	ANIMPID,anim_script

	move	@STATUS,a6
	btst	0,a6			;Player1
	jrz	f200
	movi	fryp1_as,a8
	CREATE	ANIMPID2,anim_script

f200	btst	1,a6			;Player1
	jrz	f300
	movi	fryp2_as,a8
	CREATE	ANIMPID3,anim_script

f300	SLEEP	509
	CREATE	FRYPID,frypmeters

	JSRP	anim_wait
	callr	anim_killall

	movi	FRYPID,a0
	calla	KIL1C
;	jruc	debugf

fry_done
	movi	CYCPID,a0
	calla	KIL1C

	clr	a0			;Enable player starts
	move	a0,@NO_START
	move	a0,@INTRO

	movk	3,a0
	move	a0,@frydone		;Finished
	DIE


frypbg_t
	.long	ELECRM1BMOD
	.word	12,1000
	.long	-1



 SUBR	fry_dict

	movi	frydbg_t,a0		;Show electric chairs
	move	a0,@BAKMODS,L
	calla	BGND_UD1

	movi	CHAIRP,a8 		;Pal name
	movi	cycmem,a9		;Ram area
	movi	[59,64],a10		;Begin/end color #
	movk	4,a11			;Rate in ticks
	CREATE	CYCPID,COLCYC		;Color cycler on

 	move	@PLYROBJS,a9,L
	jrz	fd50
	calla	STOPPLYR
fd50	move	@PLYROBJS+32,a9,L
	jrz	fd55
	calla	STOPPLYR
fd55

;debugfd
	callr	scores_bcdbin
	CREATE	FRYPID,score_prt

	movi	frydict_as,a8		;Dictator
	CREATE	ANIMPID,anim_script

	SLEEP	185+75
	CREATE	FRYPID,frydmeters

	JSRP	anim_wait
	callr	anim_killall

	movi	FRYPID,a0
	calla	KIL1C

	callr	scores_binbcd

;	jruc	debugfd

	jruc	fry_done


frydbg_t
	.long	CHAIR2BMOD
	.word	102,1000
	.long	>ffffffff


********************************
* Fry meters (Process)

	WORDPD	fmp1str	,0	;Plyr 1 strength (0-?, 4LBits fractional)
	WORDPD	fmp2str	,1	;Plyr 2 ^
	WORDPD	fmgwts	,2	;Electrocution gigawatts (0-?) Fry players

	WORDPD	fmgwts1	,2	;^ Fry dictator by P1
	WORDPD	fmgwts2	,3	;^ P2

	.bss	fryp1stat,16	;0=Plyr1 OK, -=Fried, 1=Hyper, >1=Bust free
	.bss	fryp2stat,16	;Plyr2 ^

FMTR_X	.equ	14		;Plyr mtr
FMTR_Y	.equ	39
FMTR_H	.equ	192
FGMTR_X	.equ	188		;GWatt mtr
FGMTR_Y	.equ	14
FGMTR_H	.equ	120

 SUBRP	frypmeters

	movi	185*16,a2		;Initial strengths

	movk	2,a8
	move	a13,a9
	addi	fmp1str,a9		;A9=*1st variable
	CREATE	FRYPID,fm_swsc		;Start P1 switch scan
	move	a2,*a9+

	movk	5,a8
	CREATE	FRYPID,fm_swsc		;P2 ^
	move	a2,*a9+

	movi	[FMTR_X+19,0],a0
	movi	[FMTR_Y,0],a1
	movi	CLAMP1,a2
	movi	198,a3			;Z
	movi	DMACAL+M_NOCOLL,a4
	movi	CLSANIM+>180,a5		;Same as ANIM meter ID
	clr	a6
	clr	a7
	movk	2,b3			;Cause skip of plyr meter
	movk	2,b4
	move	@STATUS,b2
	btst	0,b2			;Player1
	jrz	fm20
	calla	BEGINOBJ
	move	a8,a10			;A10=*P1 meter
	movi	>1414,a0
	move	a0,*a10(OCONST)
	movk	12,a0
	move	a0,*a10(OSIZEX)
	clr	b3			;Ok

fm20	movi	[372+19,0],a0
	movi	[FMTR_Y,0],a1
	movi	CLSANIM+>280,a5		;Same as ANIM meter ID
	btst	1,b2			;Player2
	jrz	fm30
	calla	BEGINOBJ
	move	a8,a11			;A11=*P2 meter
	movi	>1414,a0
	move	a0,*a11(OCONST)
	movk	12,a0
	move	a0,*a11(OSIZEX)
	clr	b4			;Ok

fm30	move	b3,@fryp1stat
	move	b4,@fryp2stat

	movi	[FGMTR_X+19,0],a0
	movk	1,a1
	movi	90,a3			;Z
	movi	CLSANIM+>80,a5
	calla	BEGINOBJ
	move	a10,a2
	clr	a10
	CREATE	FRYPID,fm_gmtr		;Gigawatt meter
	move	a2,a10

	movi	fryp1stat,a8		;Cache A8/A9
	movi	fryp2stat,a9

fm50	SLEEPK	1
	move	@WORLDTLY+16,a7
	addi	FMTR_H+FMTR_Y,a7
	movi	FMTR_H*16-16,a3
	movk	15,a4			;A4=Strength drain
	move	*a13(fmgwts),a0
	cmpi	90,a0
	jrlo	fm60
	movk	1,a2
	move	*a8,a1
	jrnz	fm54
	move	a2,*a8			;P1 Hyper
fm54	move	*a9,a1
	jrnz	fm55
	move	a2,*a9			;P2 Hyper
fm55	cmpi	118,a0
	jrlo	fm60
	sll	1,a4			;*2
	neg	a4			;They made it, so run up meters

fm60	move	*a8,a0
	subk	1,a0
	jrhi	fm120
	move	*a13(fmp1str),a0
	sub	a4,a0			;Decrease strength
	jrge	fm70
	movi	-1,a1
	move	a1,*a8			;Die
	clr	a0			;Set min
fm70	move	a0,*a13(fmp1str)
	cmp	a3,a0
	jrls	fm80			;In range?
	move	a3,a0			;Set max
	movk	2,a1
	move	a1,*a8			;Break free
fm80	srl	4,a0			;/16
	addk	1,a0
	move	a0,*a10(OSIZEY)
	move	a7,a1
	sub	a0,a1
	move	a1,*a10(OYPOS)		;New Y

fm120	move	*a9,a0
	subk	1,a0
	jrhi	fm300
	move	*a13(fmp2str),a0
	sub	a4,a0
	jrgt	fm150
	movi	-1,a1
	move	a1,*a9			;Die
	clr	a0			;Set min
fm150	move	a0,*a13(fmp2str)
	cmp	a3,a0
	jrls	fm180
	move	a3,a0
	movk	2,a1
	move	a1,*a9			;Break free
fm180	srl	4,a0
	addk	1,a0
	move	a0,*a11(OSIZEY)
	sub	a0,a7
	move	a7,*a11(OYPOS)

fm300	jruc	fm50



 SUBRP	frydmeters

	clr	a2			;Initial strengths
	move	a2,@fryp1stat

	movk	2,a8
	move	a13,a9
	addi	fmp1str,a9		;A9=*1st variable
	CREATE	FRYPID,fm_swsc		;Start P1 switch scan
	move	a2,*a9+

	movk	5,a8
	CREATE	FRYPID,fm_swsc		;P2 ^
	move	a2,*a9+

	movi	[57+19,0],a0
	movk	1,a1
	movi	CLAMP1,a2
	movi	90,a3			;Z
	movi	DMACAL+M_NOCOLL,a4
	movi	CLSANIM+>80,a5		;Same as ANIM meter ID
	clr	a6
	clr	a7
	movi	50,a10			;Meter Y offset
	move	@STATUS,b2
	btst	0,b2			;Player1
	jrz	fdm20
	calla	BEGINOBJ
	CREATE	FRYPID,fm_gmtr		;Gigawatt meter P1

fdm20	btst	1,b2			;Player2
	jrz	fdm80
	movi	[324+19,0],a0
	movk	1,a1
	movi	CLSANIM+>81,a5		;Same as ANIM meter ID
	clr	a7
	calla	BEGINOBJ
	addk	16,a9
	CREATE	FRYPID,fm_gmtr		;Gigawatt meter P2

fdm80	movi	fryp1stat,a11		;A11=Status (dictator)

fdm100	SLEEPK	1
	move	@STATUS,b2

	btst	0,b2			;Player1
	jrz	fdm200			;Not in game?

	move	*a13(fmgwts1),a3	;A3=Meter1 watts
	cmpi	80,a3
	jrlo	fdm150
	movk	1,a2			;Hyper
	cmpi	FGMTR_H,a3
	jrlo	fdm130
	move	@P1DATA+PSCORE,a0,L	;1st to fry dict gets 10000 pts
	addi	10000,a0
	move	a0,@P1DATA+PSCORE,L
	subk	2,a2			;-1 Kill dict
fdm130	move	a2,*a11

fdm150	move	*a13(fmp1str),a0
	jrz	fdm200
	clr	a0
	move	a0,*a13(fmp1str)
	movk	7,a0			;Skip watt add 87%
	calla	RNDRNG0
	move	a0,a0
	jrnz	fdm170
	addk	1,a3
	move	a3,*a13(fmgwts1)	;Add in watts
fdm170	move	@P1DATA+PSCORE,a0,L	;Bonus points
	addi	100,a0
	move	a0,@P1DATA+PSCORE,L

fdm200	btst	1,b2			;Player2
	jrz	fdm300			;Not in game?

	move	*a13(fmgwts2),a3	;A3=Meter2 watts
	cmpi	80,a3
	jrlo	fdm250
	move	*a11,a0
	jrn	fdm250			;P1 killed dict?
	movk	1,a2			;Hyper
	cmpi	FGMTR_H,a3
	jrlo	fdm230
	move	@P2DATA+PSCORE,a0,L	;1st to fry dict gets 10000 pts
	addi	10000,a0
	move	a0,@P2DATA+PSCORE,L
	subk	2,a2			;-1 Kill dict
fdm230	move	a2,*a11

fdm250	move	*a13(fmp2str),a0
	jrz	fdm300
	clr	a0
	move	a0,*a13(fmp2str)

	movk	7,a0			;Skip watt add 87%
	calla	RNDRNG0
	move	a0,a0
	jrnz	fdm270
	addk	1,a3
	move	a3,*a13(fmgwts2)	;Add in watts
fdm270	move	@P2DATA+PSCORE,a0,L	;Bonus points
	addi	100,a0
	move	a0,@P2DATA+PSCORE,L

fdm300	move	*a11,a0
	jrnn	fdm100			;Dict alive?
	SLEEP	>7fff


********************************
* Fry switch scanner (Process)

 SUBRP	fm_swsc		;A8=Bit to test, A9=*Strength var

fmss50	SLEEPK	1
	move	@COINS,a0
	btst	a8,a0
	jrnz	fmss50			;Off?

	move	*a9,a0
	addi	36,a0
;	addi	500,a0			;DEBUG
	move	a0,*a9
	
fmss70	SLEEPK	1
	move	@COINS,a0
	btst	a8,a0
	jrz	fmss70			;Off?
 
	move	*a9,a0
	addi	36,a0
	move	a0,*a9

	jruc	fmss50


********************************
* Fry gigawatt meter (Process)

 SUBRP	fm_gmtr		;A8=*Meter obj, A9=*fmgwts var, A10=Y offset

	movi	>1414,a0
	move	a0,*a8(OCONST)
	movk	19,a0
	move	a0,*a8(OSIZEX)
	clr	a0
	move	a0,*a9

fmgm50	move	*a9,a0
	addk	1,a0
	cmpi	FGMTR_H,a0
	jrls	fmgm80			;In range?
	movi	FGMTR_H,a0		;Set max
fmgm80	move	a0,*a9

	addk	1,a0
	move	a0,*a8(OSIZEY)
	move	@WORLDTLY+16,a1
	addi	FGMTR_H+FGMTR_Y,a1
	add	a10,a1			;+Offset
	sub	a0,a1
	move	a1,*a8(OYPOS)		;New Y

	SLEEPK	8

	jruc	fmgm50




********************************
* Pulse fleshtones in pal

	APTRPD	fppal_p	,0	;Plyr 1 strength (0-?, 4LBits fractional)

 SUBRP	fry_pulsep1

	movi	BIGPL1,a0
	movi	fryp1palmem,a10
	jruc	fpp5

 SUBRP	fry_pulsep2

	movi	BIGPL2,a0
	movi	fryp2palmem,a10

fpp5	move	a0,*a13(fppal_p),L

	calla	FINDPAL
	jrz	fppx
	sll	8,a0
	move	a0,a11			;needed later for palset

	movk	9,a9
	clr	a8
fpp20	move	a10,a0
	addk	2,a8
	move	a8,a2
	move	*a13(fppal_p),a1,L
	callr	pal_addb
	SLEEPK	1
	dsj	a9,fpp20

	movk	9,a9
fpp50	move	a10,a0
	subk	2,a8
	move	a8,a2
	move	*a13(fppal_p),a1,L
	callr	pal_addb
	SLEEPK	1
	dsj	a9,fpp50
fppx	DIE


********************************
* Change brightness of a palette
* Each color in palette will have A2 added to its RGB
* A0=*Ram for pal, A1=*Palette, A2=Brightness (-31 to 31)

 SUBRP	pal_addb

	PUSH	a3,a5,a7,a8

	move	*a1+,a14	;# Colors
	move	a14,*a0+

	sll	23,a14		;Remove any flags
	srl	23,a14		;9 bits needed for # colors

pb1c	movk	>1f,a8		;A8=Mask for 5 bits of color

pb100	move	*a1+,a3
	movk	>1f,a7
	and	a3,a7		;A7=Blue
	srl	5,a3
	movk	>1f,a5
	and	a3,a5		;A5=Green
	srl	5,a3		;A3=Red

	add	a2,a3
;	add	a2,a5
;	add	a2,a7

	cmp	a8,a3
	jrls	pbrok
	move	a8,a3

pbrok
;	cmp	a8,a5
;	jrls	pbgok
;	move	a8,a5
;
;pbgok	cmp	a8,a7
;	jrls	pbbok
;	move	a8,a7
;
pbbok	sll	10,a3
	sll	5,a5
	or	a5,a3
	or	a7,a3
	move	a3,*a0+		;Save color
	dsj	a14,pb100

	PULL	a3,a5,a7,a8

	move	a10,a0		;*Color data
	move	a11,a1		;Pal#
	move	*a0+,a2		;#Colors
	jauc	PALSET


********************************
* Electrocution scripts

frypdict_as
	ASADDW	1,animscnt
	ASBXY	0,58			;Set base

	ASNEW	dictnew2_t
	ASSND	fisthit
	ASSND	txtssnd

	ASLAB	50			;Scroll up
	ASXY	0,>1f,0,-4
	ASSLP	1
	ASDSJ

	ASSLP	30
	ASNEW	dictboon_t
	ASTXT	frypdicttxt_st
	ASRUN	frypdictarm_as
	ASRUN	frypdictsnd_as
	ASRUN	dicteyes_as

	ASFRA	dictmtk_l,>18,1
	ASFRA	dictmtk_l,>19,1

	ASWAIT

	ASSLP	15

	ASFRA	dicteymd_l,>10,1
	ASFRA	dicteymd_l,>11,1
	ASFRA	dictmyell_l,>18,1
	ASFRA	dictmyell_l,>19,1

	ASWAIT

	ASFRA	dictsmile_l,>18,1
	ASFRA	dictsmile_l,>19,1

	ASSLP	60

	ASLAB	25			;Scroll dn
	ASXY	0,>1f,0,8
	ASSLP	1
	ASDSJ

	ASTXTK
	ASKIL	0,>ff
	ASDELM	0,>ff
	ASRUN	frypgigmeteron_as
	ASADDW	-1,animscnt
	ASEND


frypdicttxt_st
	XYTXT	PRTF8,286,30+58,1,"YOU WILL PAY FOR"
	XYTXT	PRTF8,286,41+58,1,"YOUR CRIMES."
	XYTXT	PRTF8,286,52+58,1,"PREPARE TO FRY!!!"
;	XYTXT	PRTF8,286,58+58,1,"TO FRY!!!"
	.word	-1

frypdictarm_as				;Move arm
	ASLAB	28
	ASXY	>20,1,-1,-8
	ASSLP	1
	ASDSJ

	ASLAB	10		;Vibrate fist
	ASLAB	3
	ASXY	>20,1,0,1
	ASSLP	1
	ASDSJ
	ASLAB	3
	ASXY	>20,1,0,-1
	ASSLP	1
	ASDSJ
	ASDSJ

	ASLAB	4		;>Bang arm up and down

	ASLAB	6
	ASXY	>20,1,1,14
	ASSLP	1
	ASDSJ
	ASXY	0,>3f,0,-2	;body up
	ASSND	fisthit
	ASSLP	1
	ASXY	0,>3f,0,2	;body dn

	ASLAB	6
	ASXY	>20,1,-1,-14
	ASSLP	1
	ASDSJ

	ASDSJ

	ASLAB	8		;>move arm off screen
	ASXY	>20,1,1,14
	ASSLP	1
	ASDSJ
	ASXY	0,>3f,0,-2	;body up
	ASSND	GLSEXP
	ASSLP	1
	ASXY	0,>3f,0,2	;body dn

	ASEND


frypdictsnd_as
	ASSLP	15
	ASSND	ahkb3
	ASSLP	60
	ASSND	ahkbang
	ASEND


frypgigmeteron_as			;Scroll in the meter
	ASSLP	70
	ASNEW	frypgigmeter_t
	ASLAB	100
	ASXY	>82,0,0,2
	ASSLP	1
	ASDSJ
	ASEND

frypgigmeter_t
	ASITEMN	172,2-258,GGSWRD,90,DMAWNZ,>82
	ASITEMN	184,10-258,GGWTTS,91,DMAWNZ,>82
	.word	-1000
	


********************************
* Player 1 scripts

fryp1_as
	ASADDW	1,animscnt
	ASNEW	fryplyr_t
	ASSLP	270
	ASRUN	frypdropin_as
	ASSLP	54
	ASFRA	fryp1look_l,>40,1
	ASSLP	60
	ASFRA	clampclose_l,>20,1
	ASSLP	5
	ASSND	SETDWN
	ASSLP	15
	ASFRA	clampclose_l,>21,1
	ASSLP	5
	ASSND	SETDWN
	ASRUN	fryp1meteron_as

	ASSLP	100
	ASNEW	fryshocks_t
	ASRUNI	fryshocks_as,>70
	ASRUNI	fryshakex_as,>10
	ASRUNI	fryshakey_as,>10
	ASSLP	30

fryp1_lp
	ASRUNI	fryshakehdx_as,>30
	ASRUNI	fryshakehdy_as,>30

	ASRUN	fryp1stretch_as
	ASSLPR	5,14

	ASJMPR	750,fryp1_40		;75% skip shock
	ASRUN	fryshakescr_as
	ASSND	fpain1
	ASLABR	1,4
	ASNEW	fryshockbig_t
	ASSLPR	1,4
	ASDEL	>60
	ASNEW	fryshockbigb_t
	ASSLPR	1,4
	ASDEL	>60
	ASDSJ

	ASNEW	fryshockbig_t
	ASSLP	2
	ASDEL	>60
fryp1_40
	ASRUN	fryp1unstretch_as
	ASSLP	16

	ASRUNI	fryp1face_as,>20

	ASJMPR	800,fryp1_50		;80% skip slouch
	ASSND	fpain2
	ASXY	>40,0,0,9
	ASANI	ECTOR4,>41		;Slouch
	ASANI	ECTOR4,>46
	ASSLPR	8,70
	ASXY	>40,0,0,-9
	ASANI	ECTOR1,>41
	ASANI	ECTOR1,>46
fryp1_50
	ASCRE	fry_pulsep1,0
	ASJMPEQ	1,fryp1stat,fryp1h_lp

fryp1_80
	ASLABR	15,70
	ASASM
	move	@fryp1stat,a0
	jrn	fryp1_die
	subk	1,a0
	jrgt	fryp1_brkfree
	ASENDASM
	ASSLP	1
	ASDSJ

	ASSND	fpain3
	ASKIL	>20,7

	ASJMP	fryp1_lp


fryp1h_lp				;Hyper loop
	ASSND	fpain3
	ASKIL	>20,7

	ASRUNI	fryshakehdx_as,>30
	ASRUNI	fryshakehdy_as,>30

	ASRUN	fryp1stretch_as
	ASSLP	4

	ASSND	fpain1
	ASRUN	fryshakescr_as
	ASLABR	1,4
	ASNEW	fryshockbig_t
	ASSLPR	1,3
	ASDEL	>60
	ASNEW	fryshockbigb_t
	ASSLPR	1,3
	ASDEL	>60
	ASDSJ

	ASRUNI	frysprks2_as,>70	;More sparks
	ASNEW	fryshockbig_t
	ASSLP	2
	ASDEL	>60

	ASRUN	fryp1unstretch_as
	ASSLP	16

	ASRUNI	fryp1face_as,>20

	ASCRE	fry_pulsep1,0
	ASJMPNE	1,fryp1stat,fryp1_80

	ASSLPR	1,30
	ASJMP	fryp1h_lp


fryp1_die				;Plyr fries
	ASENDASM
	ASRUN	fryp1stretch_as
fryp1_die2				;P2 entry
	ASSLP	12

	ASRUNI	frysprks3_as,>70

	ASLAB	15
	ASRUN	fryshakescr_as
	ASNEW	fryshockbig_t
	ASSLP	2
	ASDEL	>60
	ASNEW	fryshockbigb_t
	ASSLP	2
	ASDEL	>60
	ASDSJ

	ASDELM	>70,>f			;Kill electricity
	ASKIL	>70,7
	ASKIL	>10,7
	ASKIL	>20,7

	ASRUN	frysmoke_as
	ASRUN	frywisp_as

	ASSND	fburn
	ASXY	>40,>f,0,-12
	ASRUN	fryskull_as
	ASZ	>41,0,117
	ASZ	>46,0,117
	ASFRA	bonetor_l,>41,1
	ASFRA	bonetor_l,>46,1

	ASANI	BONEARM,>42		;Make bones
	ASANI	BONEARM,>47
	ASANI	BONELEG1,>44
	ASANI	BONELEG1,>49
	ASANI	BONELEG2,>45
	ASANI	BONELEG2,>4a
	ASDEL	>43
	ASDEL	>48
	ASSVL	MTRP			;Bone pal
	ASPAL	>42
	ASPAL	>47
	ASPAL	>44
	ASPAL	>49
	ASPAL	>45
	ASPAL	>4a

fry_end_as
	ASSLP	60*5
	ASADDW	-1,animscnt
	ASEND


fryp1_brkfree				;Plyr breaks free
	ASENDASM
	ASDELM	>70,>f			;Kill electricity
	ASKIL	>70,7
	ASKIL	>10,7
	ASKIL	>20,7
	ASRUN	fry_jmpup_as
	ASXY	>40,0,0,-8
	ASRUN	fry_clampfly_as
	ASNEW	fryclexp_t
	ASFRA	BLUEEXP,>28,1
	ASFRA	BLUEEXP,>29,1
	ASFRA	BLUEEXP,>2a,1
	ASFRA	BLUEEXP,>2b,1
	ASSND	GLSEXP

	ASXYV	>80,0,->30000,0

	ASANI	ECPHD1A,>40
	ASANI	ECTOR5,>41
	ASANI	ECTOR5,>46
	ASANI	ECWRIST3,>42
	ASANI	ECWRIST3,>47
	ASANI	ECFIST2,>43
	ASANI	ECFIST2,>48
	ASANI	ECLEG2,>44
	ASANI	ECLEG2,>49
	ASANI	ECLEG2A,>45
	ASANI	ECLEG2A,>4a

	ASSLP	10

	ASANI	ECTOR6,>41
	ASANI	ECTOR6,>46
	ASANI	ECWRIST4,>42
	ASANI	ECWRIST4,>47
	ASANI	ECFIST3,>43
	ASANI	ECFIST3,>48
	ASZ	>40,>f,130		;Plyr hi Z
	ASZ	>40,0,131

	ASSLP	29
	ASDELM	>28,7			;Kill explosions
	ASSND	NOWAY

	ASSLP	11
	ASANI	ECPHD1F,>40
fryp1_brkfree2				;P2 entry
	ASANI	ECLEG3,>44
	ASANI	ECLEG3,>49
	ASDEL	>45
	ASDEL	>4a

	ASDEL	>80			;P1 Meter
	ASJMP	fry_end_as


fryp1meteron_as				;Scroll in the meter
	ASNEW	fryp1meter_t
	ASLAB	100
	ASXY	>80,0,1,0
	ASSLP	1
	ASDSJ
	ASEND

fryp1meter_t
	ASITEMN	50-100,10,SM2,200,DMAWNZ,>80
	ASITEMN	26-100,13,SMARRW2,200,DMAWNZ,>80
	ASITEMN	8-100,35,STRNGTHMTR,200,DMAWNZ,>80
	ASITEMN	31-100,35,STRNGTHMTR,200,DMAWNZ+M_FLIPH,>80
	.word	-1000
	

fryp1look_l
	LW	ECPHD1B,20
	LW	ECPHD1,25
	LW	ECPHD1C,20
	LW	ECPHD1,6
	LW	ECPHD1D,20
	LW	ECPHD1,5
	LW	ECPHD1E,20
	LW	ECPHD1A,60
	LWL0	ECPHD1G,1


fryp1stretch_as
	ASANI	ECPHD2,>40
	ASXY	>40,0,0,-5
	ASANI	ECTOR2,>41
	ASANI	ECTOR2,>46
	ASANI	ECWRIST2,>42
	ASANI	ECWRIST2,>47
	ASSLP	4
	ASANI	ECPHD3,>40
	ASXY	>40,0,0,-5
	ASANI	ECTOR3,>41
	ASANI	ECTOR3,>46
	ASEND

fryp1unstretch_as
	ASANI	ECPHD2,>40
	ASXY	>40,0,0,5
	ASANI	ECTOR2,>41
	ASANI	ECTOR2,>46
	ASSLP	4
	ASANI	ECPHD1H,>40
	ASXY	>40,0,0,5
	ASANI	ECTOR1,>41
	ASANI	ECTOR1,>46
	ASANI	ECWRIST1,>42
	ASANI	ECWRIST1,>47
	ASSLP	4
	ASXY	>40,0,0,9
	ASANI	ECTOR4,>41		;Slouch
	ASANI	ECTOR4,>46
	ASSLP	4
	ASXY	>40,0,0,-9
	ASANI	ECTOR1,>41
	ASANI	ECTOR1,>46
	ASEND


fryp1face_as			;ID >20
	ASJMPR	700,fp1f10	;70%
	ASLABR	2,5		;>Blink
	ASSLPR	3,20
	ASANI	ECPHD1G,>40
	ASSLPR	3,20
	ASANI	ECPHD1H,>40
	ASDSJ
	ASEND

fp1f10	ASSND	fpain2

	ASJMPR	600,fp1f20
	ASFRA	fp1face1_l,>40,1
	ASEND
fp1f20	ASJMPR	200,fp1f30
	ASFRA	fp1face2_l,>40,1
	ASEND
fp1f30	ASFRA	fp1face3_l,>40,1
	ASEND

fp1face1_l
	LW	BUGEYE1A,5
	LW	BUGEYE1B,5
	LW	BUGEYE1C,5
	LW	BUGEYE1D,5
	LW	BUGEYE1C,5
	LW	BUGEYE1B,5
	LWL0	BUGEYE1A,5

fp1face2_l
	LW	BUGEYE2A,4
	LW	BUGEYE2B,4
	LW	BUGEYE2C,4
	LW	BUGEYE2B,4
	LWL0	BUGEYE2A,4

fp1face3_l
	LW	BUGEYE2A,3
	LW	BUGEYE2B,3
	LW	BUGEYE2C,2
	LW	BUGEYE2D,2
	LW	BUGEYE2E,2
	LW	BUGEYE2F,2
	LW	BUGEYE2E,2
	LW	BUGEYE2D,2
	LW	BUGEYE2C,3
	LW	BUGEYE2G,2
	LW	BUGEYE2H,2
	LW	BUGEYE2I,2
	LW	BUGEYE2J,2
	LW	BUGEYE2I,2
	LW	BUGEYE2H,2
	LW	BUGEYE2C,2
	LW	BUGEYE2B,2
	LWL0	BUGEYE2A,2


********************************
* Player 2 scripts

fryp2_as
	ASADDW	1,animscnt
	ASBXY	186,0			;Set base
	ASNEW	fryplyr_t
	ASSVL	BIGPL2			;Black pal
	ASPAL	>40
	ASPAL	>41
	ASPAL	>43
	ASPAL	>46
	ASPAL	>48
	ASSLP	270
	ASRUN	frypdropin_as
	ASSLP	54
	ASFRA	fryp2look_l,>40,1
	ASSLP	60
	ASFRA	clampclose_l,>20,1
	ASSLP	5
	ASSND	SETDWN
	ASSLP	15
	ASFRA	clampclose_l,>21,1
	ASSLP	5
	ASSND	SETDWN
	ASRUN	fryp2meteron_as

	ASSLP	100
	ASNEW	fryshocks_t
	ASRUNI	fryshocks_as,>70
	ASRUNI	fryshakex_as,>10
	ASRUNI	fryshakey_as,>10
	ASSLP	30

fryp2_lp
	ASRUNI	fryshakehdx_as,>30
	ASRUNI	fryshakehdy_as,>30

	ASRUN	fryp2stretch_as
	ASSLPR	5,14

	ASJMPR	750,fryp2_40		;75% skip shock
	ASRUN	fryshakescr_as
	ASSND	fpain1
	ASLABR	1,4
	ASNEW	fryshockbig_t
	ASSLPR	1,4
	ASDEL	>60
	ASNEW	fryshockbigb_t
	ASSLPR	1,4
	ASDEL	>60
	ASDSJ

	ASNEW	fryshockbig_t
	ASSLP	2
	ASDEL	>60
fryp2_40
	ASRUN	fryp2unstretch_as
	ASSLP	16

	ASRUNI	fryp1face_as,>20

	ASJMPR	800,fryp2_50		;80% skip slouch
	ASSND	fpain2
	ASXY	>40,0,0,9
	ASANI	ECTOR4,>41		;Slouch
	ASANI	ECTOR4,>46
	ASSLPR	8,70
	ASXY	>40,0,0,-9
	ASANI	ECTOR1,>41
	ASANI	ECTOR1,>46
fryp2_50
	ASCRE	fry_pulsep2,0
	ASJMPEQ	1,fryp2stat,fryp2h_lp

fryp2_80
	ASLABR	15,70
	ASASM
	move	@fryp2stat,a0
	jrn	fryp2_die
	subk	1,a0
	jrgt	fryp2_brkfree
	ASENDASM
	ASSLP	1
	ASDSJ

	ASSND	fpain3
	ASKIL	>20,7

	ASJMP	fryp2_lp


fryp2h_lp				;Hyper loop
	ASSND	fpain3
	ASKIL	>20,7

	ASRUNI	fryshakehdx_as,>30
	ASRUNI	fryshakehdy_as,>30

	ASRUN	fryp2stretch_as
	ASSLP	4

	ASRUN	fryshakescr_as
	ASSND	fpain1
	ASLABR	1,4
	ASNEW	fryshockbig_t
	ASSLPR	1,3
	ASDEL	>60
	ASNEW	fryshockbigb_t
	ASSLPR	1,3
	ASDEL	>60
	ASDSJ

	ASRUNI	frysprks2_as,>70	;More sparks
	ASNEW	fryshockbig_t
	ASSLP	2
	ASDEL	>60

	ASRUN	fryp2unstretch_as
	ASSLP	16

	ASRUNI	fryp2face_as,>20

	ASCRE	fry_pulsep2,0
	ASJMPNE	1,fryp2stat,fryp2_80

	ASSLPR	1,30
	ASJMP	fryp2h_lp


fryp2_die				;Plyr 2 fries
	ASENDASM
	ASRUN	fryp2stretch_as
	ASJMP	fryp1_die2


fryp2_brkfree				;Plyr 2 breaks free
	ASENDASM
	ASDELM	>70,>f			;Kill electricity
	ASKIL	>70,7
	ASKIL	>10,7
	ASKIL	>20,7
	ASRUN	fry_jmpup_as
	ASXY	>40,0,0,-8
	ASRUN	fry_clampfly_as
	ASNEW	fryclexp_t
	ASFRA	BLUEEXP,>28,1
	ASFRA	BLUEEXP,>29,1
	ASFRA	BLUEEXP,>2a,1
	ASFRA	BLUEEXP,>2b,1
	ASSND	GLSEXP

	ASXYV	>80,0,>30000,0

	ASANI	ECP2HD1A,>40
	ASANI	ECTOR5,>41
	ASANI	ECTOR5,>46
	ASANI	ECWRIST3,>42
	ASANI	ECWRIST3,>47
	ASANI	ECFIST2,>43
	ASANI	ECFIST2,>48
	ASANI	ECLEG2,>44
	ASANI	ECLEG2,>49
	ASANI	ECLEG2A,>45
	ASANI	ECLEG2A,>4a

	ASSLP	10

	ASANI	ECTOR6,>41
	ASANI	ECTOR6,>46
	ASANI	ECWRIST4,>42
	ASANI	ECWRIST4,>47
	ASANI	ECFIST3,>43
	ASANI	ECFIST3,>48
	ASZ	>40,>f,130		;Plyr hi Z
	ASZ	>40,0,131

	ASSLP	29
	ASDELM	>28,7			;Kill explosions
	ASSND	NOWAY

	ASSLP	11
	ASANI	ECP2HD1F,>40
	ASJMP	fryp1_brkfree2


fryp2meteron_as				;Scroll in the meter
	ASNEW	fryp2meter_t
	ASLAB	100
	ASXY	>80,0,-1,0
	ASSLP	1
	ASDSJ
	ASEND

fryp2meter_t
	ASITEMN	280+100-186,10,SM2,200,DMAWNZ,>80
	ASITEMN	372+100-186,13,SMARRW2,200,DMAWNZ+M_FLIPH,>80
	ASITEMN	366+100-186,35,STRNGTHMTR,200,DMAWNZ,>80
	ASITEMN	389+100-186,35,STRNGTHMTR,200,DMAWNZ+M_FLIPH,>80
	.word	-1000


fryp2look_l
	LW	ECP2HD1B,20
	LW	ECP2HD1,25
	LW	ECP2HD1C,20
	LW	ECP2HD1,6
	LW	ECP2HD1D,20
	LW	ECP2HD1,5
	LW	ECP2HD1E,20
	LW	ECP2HD1A,60
	LWL0	ECP2HD1G,1


fryp2stretch_as
	ASANI	ECP2HD2,>40
	ASXY	>40,0,0,-5
	ASANI	ECTOR2,>41
	ASANI	ECTOR2,>46
	ASANI	ECWRIST2,>42
	ASANI	ECWRIST2,>47
	ASSLP	4
	ASANI	ECP2HD3,>40
	ASXY	>40,0,0,-5
	ASANI	ECTOR3,>41
	ASANI	ECTOR3,>46
	ASEND

fryp2unstretch_as
	ASANI	ECP2HD2,>40
	ASXY	>40,0,0,5
	ASANI	ECTOR2,>41
	ASANI	ECTOR2,>46
	ASSLP	4
	ASANI	ECP2HD1H,>40
	ASXY	>40,0,0,5
	ASANI	ECTOR1,>41
	ASANI	ECTOR1,>46
	ASANI	ECWRIST1,>42
	ASANI	ECWRIST1,>47
	ASSLP	4
	ASXY	>40,0,0,9
	ASANI	ECTOR4,>41		;Slouch
	ASANI	ECTOR4,>46
	ASSLP	4
	ASXY	>40,0,0,-9
	ASANI	ECTOR1,>41
	ASANI	ECTOR1,>46
	ASEND

fryp2face_as			;ID >20
	ASJMPR	700,fp2f10	;70%
	ASLABR	2,5		;>Blink
	ASSLPR	3,20
	ASANI	ECP2HD1G,>40
	ASSLPR	3,20
	ASANI	ECP2HD1H,>40
	ASDSJ
	ASEND

fp2f10	ASSND	fpain2
	ASJMPR	600,fp2f20
	ASFRA	fp2face1_l,>40,1
	ASEND
fp2f20	ASJMPR	200,fp2f30
	ASFRA	fp2face2_l,>40,1
	ASEND
fp2f30	ASFRA	fp2face3_l,>40,1
	ASEND

fp2face1_l
	LW	BUG2EYE1A,5
	LW	BUG2EYE1B,5
	LW	BUG2EYE1C,5
	LW	BUG2EYE1D,5
	LW	BUG2EYE1C,5
	LW	BUG2EYE1B,5
	LWL0	BUG2EYE1A,5

fp2face2_l
	LW	BUG2EYE2A,4
	LW	BUG2EYE2B,4
	LW	BUG2EYE2C,4
	LW	BUG2EYE2B,4
	LWL0	BUG2EYE2A,4

fp2face3_l
	LW	BUG2EYE2A,3
	LW	BUG2EYE2B,3
	LW	BUG2EYE2C,2
	LW	BUG2EYE2D,2
	LW	BUG2EYE2E,2
	LW	BUG2EYE2F,2
	LW	BUG2EYE2E,2
	LW	BUG2EYE2D,2
	LW	BUG2EYE2C,3
	LW	BUG2EYE2G,2
	LW	BUG2EYE2H,2
	LW	BUG2EYE2I,2
	LW	BUG2EYE2J,2
	LW	BUG2EYE2I,2
	LW	BUG2EYE2H,2
	LW	BUG2EYE2C,2
	LW	BUG2EYE2B,2
	LWL0	BUG2EYE2A,2


********************************
* Generic electrocution scripts


FP1X	.equ	104
FP1Y	.equ	38
fryplyr_t
	ASITEMN	FP1X,FP1Y-254,ECPHD1A,101,DMAWNZ,>40
	ASITEMN	FP1X,FP1Y-254,ECTOR1,100,DMAWNZ,>41
	ASITEMN	FP1X,FP1Y-254,ECWRIST1,101,DMAWNZ,>42
	ASITEMN	FP1X,FP1Y-254,ECFIST1,103,DMAWNZ,>43
	ASITEMN	FP1X,FP1Y-254,ECLEG1,115,DMAWNZ,>44
	ASITEMN	FP1X,FP1Y-254,ECLEG1A,104,DMAWNZ,>45
	ASITEMN	FP1X-1,FP1Y-254,ECTOR1,100,DMAWNZ+M_FLIPH,>46
	ASITEMN	FP1X-1,FP1Y-254,ECWRIST1,101,DMAWNZ+M_FLIPH,>47
	ASITEMN	FP1X-1,FP1Y-254,ECFIST1,103,DMAWNZ+M_FLIPH,>48
	ASITEMN	FP1X-1,FP1Y-254,ECLEG1,115,DMAWNZ+M_FLIPH,>49
	ASITEMN	FP1X-1,FP1Y-254,ECLEG1A,104,DMAWNZ+M_FLIPH,>4a
	ASITEMN	FP1X-81,FP1Y+61,CLAMP1,102,DMAWNZ,>20
	ASITEMN	FP1X+81,FP1Y+61,CLAMP1,102,DMAWNZ+M_FLIPH,>21
	.word	-1000

frypdropin_as			;Player drops into chair
	ASLAB	11
	ASXY	>40,>f,0,6
	ASSLP	1
	ASDSJ
	ASLAB	11
	ASXY	>40,>f,0,8
	ASSLP	1
	ASDSJ
	ASLAB	10
	ASXY	>40,>f,0,10
	ASSLP	1
	ASDSJ
	ASEND

clampclose_l
	LW	CLAMP2,5
	LWL0	CLAMP3,1
clampopen_l
	LW	CLAMP2,5
	LWL0	CLAMP1,1


fryshockbig_t
	ASITEMN	FP1X,FP1Y-15,SHOCK1A,150,DMAWNZ,>60
	ASITEMN	FP1X,FP1Y-15,SHOCK1B,150,DMAWNZ,>60
	ASITEMN	FP1X,FP1Y-15,SHOCK1C,150,DMAWNZ,>60
	ASITEMN	FP1X,FP1Y-15,SHOCK1D,152,DMAWNZ,>60
	ASITEMN	FP1X-1,FP1Y-15,SHOCK1A,150,DMAWNZ+M_FLIPH,>60
	ASITEMN	FP1X-1,FP1Y-15,SHOCK1B,150,DMAWNZ+M_FLIPH,>60
	ASITEMN	FP1X-1,FP1Y-15,SHOCK1C,150,DMAWNZ+M_FLIPH,>60
	ASITEMN	FP1X-1,FP1Y-15,SHOCK1D,152,DMAWNZ+M_FLIPH,>60
	.word	-1000

fryshockbigb_t
	ASITEMN	FP1X,FP1Y-15,SHOCK2A,150,DMAWNZ,>60
	ASITEMN	FP1X,FP1Y-15,SHOCK2B,150,DMAWNZ,>60
	ASITEMN	FP1X,FP1Y-15,SHOCK2C,150,DMAWNZ,>60
	ASITEMN	FP1X,FP1Y-15,SHOCK2D,152,DMAWNZ,>60
	ASITEMN	FP1X-1,FP1Y-15,SHOCK2A,150,DMAWNZ+M_FLIPH,>60
	ASITEMN	FP1X-1,FP1Y-15,SHOCK2B,150,DMAWNZ+M_FLIPH,>60
	ASITEMN	FP1X-1,FP1Y-15,SHOCK2C,150,DMAWNZ+M_FLIPH,>60
	ASITEMN	FP1X-1,FP1Y-15,SHOCK2D,152,DMAWNZ+M_FLIPH,>60
	.word	-1000

fryshocks_t
	ASITEMN	FP1X+3,FP1Y,BLT1,110,DMAWNZ,>70
	ASITEMN	FP1X-5,FP1Y,BLT1,110,DMAWNZ+M_FLIPH,>71
	ASITEMN	FP1X-60,FP1Y+95,LILBLT1,110,DMAWNZ,>72
	ASITEMN	FP1X+60,FP1Y+95,LILBLT1,110,DMAWNZ+M_FLIPH,>73
	ASITEMN	FP1X,FP1Y+55,LILBLT1,110,DMAWNZ,>74
	ASITEMN	FP1X,FP1Y+85,LILBLT1,110,DMAWNZ+M_FLIPH,>75
	ASITEMN	FP1X,FP1Y+120,LILBLT1,118,DMAWNZ,>76
	ASITEMN	FP1X,FP1Y+160,LILBLT1,118,DMAWNZ,>77
	.word	-1000

fryshocks_as				;ID >70
	ASRUN	fryshock2_as
	ASRUN	fryshock3_as
	ASRUN	fryshock4_as
	ASRUN	fryshock5_as
	ASRUN	fryshock6_as
	ASRUN	fryshock7_as
	ASRUN	fryshock8_as
	ASRUN	fryshocksnd_as
	ASRUN	frysprks_as

fs1lp	ASFRA	dbolt_l,>70,1
	ASWAIT
	ASHIDE	>70
	ASSLPR	5,50
	ASSHOW	>70
	ASJMP	fs1lp


fryshock2_as
	ASFRA	dbolt_l,>71,1
	ASWAIT
	ASHIDE	>71
	ASSLPR	5,50
	ASSHOW	>71
	ASJMP	fryshock2_as

fryshock3_as
	ASFRA	lbolt_l,>72,1
	ASWAIT
	ASHIDE	>72
	ASSLPR	5,50
	ASSHOW	>72
	ASJMP	fryshock3_as

fryshock4_as
	ASFRA	lbolt_l,>73,1
	ASWAIT
	ASHIDE	>73
	ASSLPR	5,50
	ASSHOW	>73
	ASJMP	fryshock4_as

fryshock5_as
	ASFRA	sbolt_l,>74,1
	ASWAIT
	ASHIDE	>74
	ASSLPR	5,50
	ASSHOW	>74
	ASJMP	fryshock5_as

fryshock6_as
	ASFRA	sbolt_l,>75,1
	ASWAIT
	ASHIDE	>75
	ASSLPR	5,50
	ASSHOW	>75
	ASJMP	fryshock6_as

fryshock7_as
	ASFRA	sbolt_l,>76,1
	ASWAIT
	ASHIDE	>76
	ASSLPR	5,50
	ASSHOW	>76
	ASJMP	fryshock7_as

fryshock8_as
	ASFRA	sbolt_l,>77,1
	ASWAIT
	ASHIDE	>77
	ASSLPR	5,50
	ASSHOW	>77
	ASJMP	fryshock8_as


fryshocksnd_as				;ID >70
	ASSND	fshock
	ASSLPR	20,80
	ASJMP	fryshocksnd_as


dbolt_l	LW	BLT1,2
	LW	BLT2,2
	LW	BLT3,2
	LW	BLT4,2
	LW	BLT5,2
	LWL0	BLT6,2

lbolt_l	LW	LILBLT1,3
	LW	LILBLT2,3
	LW	LILBLT3,3
	LW	LILBLT4,3
	LW	LILBLT5,3
	LWL0	LILBLT6,3

sbolt_l	LW	LILBLT1,1
	LW	LILBLT2,1
	LW	LILBLT3,1
	LW	LILBLT4,1
	LW	SBOLT1,2
	LW	SBOLT2,2
	LW	SBOLT3,2
	LW	SBOLT4,2
	LW	SBOLT5,2
	LW	SBOLT6,2
	LWL0	SBOLT7,2


frysprks_as				;ID >70
	ASLAB	500
	ASRUNI	frysprk_as,0
	ASSLPR	5,15
	ASDSJ
	ASEND

frysprks2_as				;ID >70
	ASSLP	20
	ASLAB	6
	ASRUNI	frysprk_as,0
	ASSLPR	1,6
	ASDSJ
	ASEND

frysprk_as				;ID 0
	ASNEW	frysprk_t
	ASFRA	frysprk_l,-1,0
	ASJMPR	500,fs20		;50% L or R
	ASADDWO	M_FLIPH,OFLAGS		;Left
	ASXYRNG	-1,0,-55,-15,-20,32
	ASSVRL	->10000,->4000
	ASJMP	frysprkg_as

fs20	ASXYRNG	-1,0,15,55,-20,32	;Right
	ASSVRL	>4000,>10000
frysprkg_as				;Gravity
	ASSLP	12
	ASADLVO	OXVEL
	ASLAB	32
	ASADDLO	>3000,OYVEL
	ASSLP	1
	ASDSJ
	ASXYV0
	ASEND

frysprks3_as				;ID >70
	ASRUNI	frysprk3_as,0
	ASSLPR	2,5
	ASJMP	frysprks3_as
frysprk3_as				;ID 0
	ASNEW	frysprk_t
	ASFRA	frysprk_l,-1,0
	ASJMPR	500,fs320
	ASADDWO	M_FLIPH,OFLAGS		;Left
	ASXYRNG	-1,0,-55,-15,-20,32
	ASSVRL	->e0000,->30000
	ASJMP	frysprkg_as

fs320	ASXYRNG	-1,0,15,55,-20,32	;Right
	ASSVRL	>30000,>e0000
	ASJMP	frysprkg_as


frysprk_t
	ASITEMN	FP1X-10,FP1Y+56,SPARKL1,118,DMAWNZ,0
	.word	-1000

frysprk_l
	LW	SPARKL1,3
	LW	SPARKL2,3
	LW	SPARKL3,3
	LW	SPARKL4,3
	LW	SPARKL5,3
	LW	SPARKL6,3
	LW	SPARKL7HOLD,26
	LW	SPARKL9,3
	LW	SPARKL10,3
	LW	SPARKL11,3
	LW	SPARKL12,3
	LW	SPARKL13,3
	LW	SPARKL14,3
	LW	SPARKL15,3
	LW	SPARKL16,3
	LW	SPARKL17,3
	LW	SPARKL18,3
	LW	SPARKL19,3
	LWL0	SPARKL20,3


fryshakex_as			;ID >10
	ASJMPR	500,fsx20
	ASXY	>40,>f,-1,0
	ASSLPR	1,2
	ASXY	>40,>f,1,0
	ASSLPR	1,2
	ASJMP	fryshakex_as

fsx20	ASXY	>40,>f,1,0
	ASSLPR	1,2
	ASXY	>40,>f,-1,0
	ASSLPR	1,2
	ASJMP	fryshakex_as

fryshakey_as			;ID >10
	ASXY	>40,>f,0,-1
	ASSLPR	1,3
	ASXY	>40,>f,0,1
	ASSLPR	1,3
	ASJMP	fryshakey_as

fryshakehdx_as			;ID >30
	ASLAB	4
	ASXY	>40,0,-1,0
	ASSLPR	1,3
	ASXY	>40,0,1,0
	ASSLPR	1,3
	ASXY	>40,0,1,0
	ASSLPR	1,3
	ASXY	>40,0,-1,0
	ASSLPR	1,3
	ASDSJ
	ASEND
fryshakehdy_as			;ID >30
	ASLAB	4
	ASXY	>40,0,0,1
	ASSLPR	1,3
	ASXY	>40,0,0,-1
	ASSLPR	1,3
	ASDSJ
	ASEND

fryshakescr_as
	ASASM
	movk	8,a10
	calla	SHAKER
	ASENDASM
	ASEND
fryshakescr2_as
	ASASM
	movi	100,a10
	calla	SHAKER
	ASENDASM
	ASEND


fryclexp_t
	ASITEMN	FP1X-81,FP1Y+95,CLAMP1,102,DMAWNZ,>28
	ASITEMN	FP1X-81+25,FP1Y+95,CLAMP1,102,DMAWNZ,>29
	ASITEMN	FP1X+81-25,FP1Y+95,CLAMP1,102,DMAWNZ,>2a
	ASITEMN	FP1X+81,FP1Y+95,CLAMP1,102,DMAWNZ,>2b
	.word	-1000

fry_clampfly_as
	ASZ	>20,1,250
	ASFRA	clampopen_l,>20,1
	ASFRA	clampopen_l,>21,1
	ASSLP	5
	ASXYV	>20,0,->70000,->20000
	ASXYV	>21,0,>70000,->20000
	ASSLP	90
	ASDELM	>20,1
	ASEND


fry_jmpup_as				;Jump out of chair
	ASRUN	fryplyrgrav_as
	ASXYV	>40,>f,0,->84000
	ASSLP	50
	ASXYVA	>40,>f,0,0
	ASEND

fryplyrgrav_as				;Plyr gravity
	ASLAB	49
	ASXYV	>40,>f,0,>5800
	ASSLP	1
	ASDSJ
	ASEND

fryexp_t
	ASITEMN	FP1X-60,FP1Y+20,CLD1A,120,DMAWNZ,0
	.word	-1000

okbm_l	LW	OKBM1,4
	LW	OKBM2,4
	LW	OKBM3,4
	LW	OKBM4,4
	LW	OKBM5,4
	LW	OKBM6,4
	LWL0	OKBM7,4

xpld_l	LW	XPLD1,4
	LW	XPLD2,4
	LW	XPLD3,4
	LW	XPLD4,4
	LW	XPLD5,4
	LW	XPLD6,4
	LW	XPLD7,5
	LW	XPLD8,5
	LW	XPLD9,5
	LWL0	XPLD10,5


frysmoke_as
	ASLAB	200
	ASNEW	fryexp_t
	ASXYRNG	-1,0,0,130,30,100
	ASSVRL	->10000,>10000
	ASADLVO	OXVEL
	ASSVRL	->40000,->10000
	ASADLVO	OYVEL
	ASJMPR	600,fs10		;60% hi Z
	ASADDWO	-40,OZPOS
fs10	ASFRA	okbm_l,-1,1
	ASSLP	1
	ASDSJ
	ASEND

fryskull_as				;Drop off skull
	ASZ	>40,0,118
	ASXY	>40,0,0,43
	ASFRA	skull_l,>40,1
	ASSLP	30

	ASRUN	fryskullgrav_as
	ASXYV	>40,0,>10000,>2000

	ASSLP	29
	ASXYV	>40,0,->1f000,->84000
	ASSND	fskullb

	ASSLP	34
	ASXYV	>40,0,0,->84000
	ASSND	fskullb

	ASSLP	31
	ASXYVA	>40,0,0,0
	ASSND	fskullb
	ASEND

fryskullgrav_as				;Skull gravity
	ASLAB	92
	ASXYV	>40,0,0,>3800
	ASSLP	1
	ASDSJ
	ASEND


skull_l	LWL	SKULL1,NEWPALET+30,MTRP
	LW	SKULL2,6
	LW	SKULL3,7
	LW	SKULL4,8
	LW	SKULL5,8
	LW	SKULL4,6
	LW	SKULL3,5
	LW	SKULL2,5
	LW	SKULL1,5
	LWW	SKULL2,FLIPBITS+4,M_FLIPH
	LW	SKULL3,4
	LWL0	SKULL4,1

bonetor_l
	LWL	BONES1,NEWPALET+230,MTRP
	LW	BONES2,3
	LW	BONES3,3
	LW	BONES4,3
	LW	BONES5,3
	LWL0	BONES6,3

frywisp_as
	ASLAB	80
	ASNEW	frywisp_t
	ASXYRNG	-1,0,-50,50,-28,17
	ASJMPR	500,fryw10		;50% either wisp
	ASFRA	frywisp1_l,-1,0
	ASJMP	fryw20
fryw10	ASFRA	frywisp2_l,-1,0
fryw20	ASJMPR	500,fryw40		;50% low Z
	ASADDWO	18,OZPOS
fryw40	ASSLP	2
	ASDSJ
	ASEND

frywisp_t
	ASITEMN	FP1X,FP1Y+66,WISP1,101,DMAWNZ,0
	.word	-1000

frywisp1_l
	LW	WISP1,5
	LW	WISP2,5
	LW	WISP3,5
	LW	WISP4,5
	LW	WISP5,5
	LW	WISP6,5
	LW	WISP7,5
	LW	WISP8,5
	LW	WISP9,5
	LW	WISP10,5
	LW	WISP11,5
	LW	WISP12,5
	LW	WISP13,5
	LW	WISP14,5
	LWL0	WISP15,5
frywisp2_l
	LWW	WISP1,FLIPBITS+8,M_FLIPH
	LW	WISP2,8
	LW	WISP3,8
	LW	WISP4,8
	LW	WISP5,8
	LW	WISP6,8
	LW	WISP7,8
	LW	WISP8,8
	LW	WISP9,8
	LW	WISP10,8
	LW	WISP11,8
	LW	WISP12,8
	LW	WISP13,8
	LW	WISP14,8
	LWL0	WISP15,8



********************************
* Fry dictator scripts

frydict_as
	ASADDW	1,animscnt
	ASBXY	91,0			;Set base
	ASNEW	frydict_t

	ASFRA	frydlook_l,>40,1
	ASSND	ahkbang
	ASSLP	75+60
	ASFRA	clampclose_l,>20,1
	ASSLP	5
	ASSND	SETDWN
	ASSLP	15
	ASFRA	clampclose_l,>21,1
	ASSLP	5
	ASSND	SETDWN
	ASRUN	frydmeteron_as

	ASSLP	80
	ASNEW	fryshocks_t
	ASRUNI	fryshocks_as,>70
	ASRUNI	fryshakex_as,>10
	ASRUNI	fryshakey_as,>10
	ASSLP	30

fryd_lp
	ASRUNI	fryshakehdx_as,>30
	ASRUNI	fryshakehdy_as,>30

	ASRUN	frydstretch_as
	ASSLPR	4,14
fryd_8
	ASASM
	move	@fryp1stat,a0
	jrz	fryd_20			;Not hyper?
	ASENDASM
	ASRUNI	frysprks2_as,>70	;More sparks
	ASRUNI	frysprks2_as,>70	;More sparks!
	ASJMP	fryd_30

fryd_20
	ASENDASM
	ASJMPR	750,fryd_40		;75% skip shock
fryd_30
	ASRUN	fryshakescr_as
	ASSND	fpain1
	ASLABR	1,4
	ASNEW	fryshockbig_t
	ASSLPR	1,4
	ASDEL	>60
	ASNEW	fryshockbigb_t
	ASSLPR	1,4
	ASDEL	>60
	ASDSJ

	ASNEW	fryshockbig_t
	ASSLP	2
	ASDEL	>60
fryd_40
	ASRUN	frydunstretch_as
	ASSLP	16

	ASRUNI	frydface_as,>20

	ASJMPR	800,fryd_50		;80% skip slouch
	ASSND	fpain2
	ASXY	>40,0,0,9
	ASANI	AKTORSO4,>41		;Slouch
	ASANI	AKTORSO4,>46
	ASSLPR	8,70
	ASXY	>40,0,0,-9
	ASANI	AKTORSO1,>41
	ASANI	AKTORSO1,>46
fryd_50
	ASCRE	fry_pulsep1,0
	ASLABR	10,50
	ASASM
	move	@fryp1stat,a0
	jrn	fryd_die
	ASENDASM
	ASSLP	1
	ASDSJ

	ASSND	fpain3
	ASKIL	>20,7

	ASJMP	fryd_lp


fryd_die				;Dict fries
	ASENDASM
	ASRUN	frydstretch_as
	ASSLP	5

	ASRUNI	frysprks3_as,>70
	ASRUN	frydexp_as
	ASRUN	frydexp_as

	ASLAB	120
	ASSND	fpain1
	ASRUN	fryshakescr2_as
	ASNEW	fryshockbig_t
	ASSLPR	1,2
	ASDEL	>60
	ASNEW	fryshockbigb_t
	ASSLPR	1,2
	ASDEL	>60
	ASDSJ

	ASDELM	>70,>f			;Kill electricity
	ASKIL	>70,7
	ASKIL	>10,7
	ASKIL	>20,7

	ASRUN	frysmoke_as
	ASRUN	frywisp_as
	ASNEW	frydbone_t		;FIX!

	ASSND	fburn
	ASXY	>40,>f,0,-12
	ASRUN	fryskull_as
	ASZ	>41,0,117
	ASZ	>46,0,117
	ASFRA	bonetor_l,>41,1
	ASFRA	bonetor_l,>46,1

	ASANI	BONELEG1,>44		;Make bones
	ASANI	BONELEG1,>49
	ASANI	BONELEG2,>45
	ASANI	BONELEG2,>4a
	ASDEL	>43
	ASDEL	>48
	ASSVL	MTRP			;Bone pal
	ASPAL	>44
	ASPAL	>49
	ASPAL	>45
	ASPAL	>4a

	ASSLP	60*2
	ASSND	totcarn
	ASJMP	fry_end_as



frydict_t
	ASITEMN	FP1X,FP1Y,AKHED1,101,DMAWNZ,>40
	ASITEMN	FP1X,FP1Y,AKTORSO1,100,DMAWNZ,>41
	ASITEMN	FP1X,FP1Y,ECFIST1,103,DMAWNZ,>43
	ASITEMN	FP1X,FP1Y,AKLEG1,115,DMAWNZ,>44
	ASITEMN	FP1X,FP1Y,AKLEG2,104,DMAWNZ,>45
	ASITEMN	FP1X-1,FP1Y,AKTORSO1,100,DMAWNZ+M_FLIPH,>46
	ASITEMN	FP1X-1,FP1Y,ECFIST1,103,DMAWNZ+M_FLIPH,>48
	ASITEMN	FP1X-1,FP1Y,AKLEG1,115,DMAWNZ+M_FLIPH,>49
	ASITEMN	FP1X-1,FP1Y,AKLEG2,104,DMAWNZ+M_FLIPH,>4a
	ASITEMN	FP1X-81,FP1Y+61,CLAMP1,102,DMAWNZ,>20
	ASITEMN	FP1X+81,FP1Y+61,CLAMP1,102,DMAWNZ+M_FLIPH,>21
	.word	-1000


frydmeteron_as				;Scroll in the meter
	ASASM
	move	@STATUS,a0
	btst	0,a0
	jrz	fdmo20
	ASENDASM
	ASNEW	frydmeter1_t
	ASASM
fdmo20	move	@STATUS,a0
	btst	1,a0
	jrz	fdmo30
	ASENDASM
	ASNEW	frydmeter2_t
	ASASM
fdmo30	ASENDASM
	ASLAB	30
	ASXY	>80,0,2,0
	ASXY	>81,0,-2,0
	ASSLP	1
	ASDSJ
	ASEND

frydmeter1_t
	ASITEMN	2-112,2+50,GGSWRD,90,DMAWNZ,>80
	ASITEMN	14-112,10+50,GGWTTS,91,DMAWNZ,>80
	.word	-1000
frydmeter2_t
	ASITEMN	2+275,2+50,GGSWRD,90,DMAWNZ,>81
	ASITEMN	14+275,10+50,GGWTTS,91,DMAWNZ,>81
	.word	-1000
	
frydlook_l
	LW	AKHED1,2			;Angry speech
	LW	AKHED9,6
	LW	AKHED1,3
	LW	AKHED9,8
	LW	AKHED1,3
	LW	AKHED9,8
	LW	AKHED1,3
	LW	AKHED9,2
	LW	AKHED1,6
	LW	AKHED9,6
	LW	AKHED1,2
	LW	AKHED9,3
	LW	AKHED1,9
	LW	AKHED9,9
	LW	AKHED1,5+10

	LW	AKHED2,20			;Look
	LW	AKHED1,10
	LWW	AKHED2,FLIPBITS+20,M_FLIPH
	LWW	AKHED1,FLIPBITS+20,0
	LW	AKHED3,25
	LW	AKHED1,5
	LWL0	AKHED6,1


frydstretch_as
	ASXY	>40,0,0,-5
	ASANI	AKTORSO2,>41
	ASANI	AKTORSO2,>46
	ASSLP	4
	ASXY	>40,0,0,-5
	ASANI	AKTORSO3,>41
	ASANI	AKTORSO3,>46
	ASEND

frydunstretch_as
	ASXY	>40,0,0,5
	ASANI	AKTORSO2,>41
	ASANI	AKTORSO2,>46
	ASSLP	4
	ASXY	>40,0,0,5
	ASANI	AKTORSO1,>41
	ASANI	AKTORSO1,>46
	ASSLP	4
	ASXY	>40,0,0,9
	ASANI	AKTORSO4,>41		;Slouch
	ASANI	AKTORSO4,>46
	ASSLP	4
	ASXY	>40,0,0,-9
	ASANI	AKTORSO1,>41
	ASANI	AKTORSO1,>46
	ASEND


frydface_as			;ID >20
	ASJMPR	800,fdf10
	ASLABR	2,5		;>Blink 20%
	ASSLPR	3,20
	ASANI	AKHED4,>40
	ASSLPR	3,20
	ASANI	AKHED8,>40
	ASDSJ
	ASEND

fdf10	ASSND	fpain2
	ASJMPR	440,fdf20
	ASJMPR	333,fdf30
	ASJMPR	500,fdf40
	ASFRA	fdface1_l,>40,1		;15%
	ASEND
fdf20	ASFRA	fdface2_l,>40,1		;35%
	ASEND
fdf30	ASFRA	fdface3_l,>40,1		;15%
	ASEND
fdf40	ASFRA	fdface4_l,>40,1		;15%
	ASEND

fdface1_l
	LW	BIGEYES1,5
	LW	BIGEYES2,5
	LW	BIGEYES3,5
	LW	BIGEYES4,5
	LW	BIGEYES5,5
	LW	BIGEYES4,5
	LW	BIGEYES3,5
	LW	BIGEYES2,5
	LWL0	BIGEYES1,5

fdface2_l
	LW	AKHED8,4
	LW	BIGEYES1,4
	LW	BIGEYES2,4
	LW	BIGEYES1,4
	LW	AKHED8,4
	LW	AKHED5,4
	LWL0	AKHED4,4

fdface3_l
	LW	AKHED9,5
	LW	AKHED10,20
	LW	AKHED9,5
	LWL0	AKHED7,5

fdface4_l
	LW	BIGEYES1,3
	LW	BIGEYES2,3
	LW	BIGEYES3,2
	LW	BIGEYES4,2
	LW	BIGEYES5,2
	LW	BIGEYES6,2
	LW	BIGEYES5,2
	LW	BIGEYES4,2
	LW	BIGEYES3,3
	LW	BIGEYES7,2
	LW	BIGEYES8,2
	LW	BIGEYES9,2
	LW	BIGEYES10,2
	LW	BIGEYES9,2
	LW	BIGEYES8,2
	LW	BIGEYES7,2
	LW	BIGEYES2,2
	LWL0	BIGEYES1,2

frydexp_as
	ASLAB	300
	ASNEW	fryexp_t
	ASXYRNG	-1,0,0,130,20,100
	ASSVRL	->e0000,>e0000
	ASADLVO	OXVEL
	ASSVRL	->e0000,>e0000
	ASADLVO	OYVEL
	ASJMPR	500,fde10		;50% low Z
	ASADDWO	40,OZPOS
fde10	ASJMPR	200,fde20
	ASJMPR	250,fde40
	ASJMPR	333,fde50
	ASJMPR	500,fde60
	ASFRA	okbm_l,-1,1
	ASJMP	fde300
fde20	ASFRA	FIREEXP,-1,1		;Has pal
	ASJMP	fde400
fde40	ASFRA	BOOM3,-1,1		;^
	ASJMP	fde400
fde50	ASFRA	BLUEEXP,-1,1		;^
	ASJMP	fde400
fde60	ASFRA	xpld_l,-1,1
fde300	ASSVRLT	frydpal_t
	ASPAL	-1
fde400	ASSND	fryexp
	ASSLP	1
	ASSND	fryexp2
	ASDSJ
	ASEND


frydpal_t
	.word	4
	.long	GREYPAL,RDBOOM,GRNBOOM,BLUBOOM

frydbone_t
	ASITEMN	FP1X,FP1Y-254,BONEARM,101,DMAWNZ,>42
	ASITEMN	FP1X-1,FP1Y-254,BONEARM,101,DMAWNZ+M_FLIPH,>47
	.word	-1000


********************************
* Run an animation script (Process)


	.bss	animscnt	,16	;# anim scripts running

	APTRPD	animslobj_p	,0	;*Last obj created
	LONGPD	animsv		,2	;Temp value
	WORDPD	animsbx		,4	;Base X
	WORDPD	animsby		,5	;Base Y
	WORDPD	animsfnum	,6	;# FRANIMs running
	APTRPD	animslp_p	,7	;*Loop point table pos
	APTRPD	animslp_t	,9	;(*Loop point, Loop cnt)*5

			;AnimScript commands
AsNEW	.equ	0	;
AsDEL	.equ	1	;ID
AsDELM	.equ	2	;ID
AsFRA	.equ	4	;ID or Last
AsANI	.equ	5	;ID
AsHIDE	.equ	6	;ID
AsSHOW	.equ	7	;ID
AsPAL	.equ	8	;ID or Last
AsXY	.equ	10	;ID
AsXYRNG	.equ	11	;ID or Last
AsXYV	.equ	13	;ID
AsXYVA	.equ	14	;ID
AsXYV0	.equ	16	;Last
AsZ	.equ	17	;ID
AsBXY	.equ	18	;
AsSLP	.equ	20	;
AsSLPR	.equ	21	;
AsWAIT	.equ	22	;
AsTXT	.equ	30	;
AsTXTK	.equ	31	;
AsLAB	.equ	40	;
AsLABR	.equ	41	;
AsDSJ	.equ	43	;
AsJMP	.equ	45	;
AsJMPR	.equ	46	;
AsJMPEQ	.equ	47	;
AsJMPNE	.equ	48	;
AsRUN	.equ	50	;
AsRUNI	.equ	51	;
AsCRE	.equ	52	;
AsKIL	.equ	53	;
AsASM	.equ	55	;
AsSND	.equ	60	;
AsADDW	.equ	70	;
AsADDWO	.equ	71	;Last
AsADDLO	.equ	72	;Last
AsADLVO	.equ	73	;Last
AsSVRL	.equ	74	;
AsSVRLT	.equ	75	;
AsSVL	.equ	76	;


 SUBRP	anim_script		;A8=*Script

	clr	a9

 SUBRP	anim_script2		;A8=*Script, A9=Base Y:X

	move	a9,*a13(animsbx),L	;Save XY

	move	*a13(PROCID),a11
	subi	ANIMPID,a11
	srl	8,a11
	sll	8,a11			;A11=ID offset (0->300)

	clr	a1
	move	a1,*a13(animsfnum)
	move	a13,a1
	addi	animslp_t,a1
	move	a1,*a13(animslp_p),L

ans50	move	*a8+,a1			;Get command
	move	*a8+,a0,L		;Get data

	cmpi	AsNEW,a1		;>New objects
	jrne	ans200
	PUSH	a8
	move	a0,a9
ans100	move	*a9+,a2,L		;*Image
	move	*a9+,a0,L		;Get XY
	move	*a13(animsbx),a3,L
	addxy	a3,a0			;Add base
	move	a0,a1
	sll	16,a0
	srl	16,a1			;Remove X
	sll	16,a1
	move	*a9+,a3			;Z
	move	*a9+,a4			;Flags
	addi	M_NOCOLL,a4
	move	*a9+,a5			;ID
	addi	CLSANIM,a5
	add	a11,a5			;+offset
	clr	a6
	clr	a7
	calla	BEGINOBJ
	move	*a9,a0
	cmpi	-1000,a0
	jrne	ans100			;End?
	move	a8,*a13(animslobj_p),L	;Save * to last one
	PULL	a8
	jruc	ans50

ans200	cmpi	AsFRA,a1		;>FRANIM
	jrne	ans300
	move	a11,a6			;Save a11
	move	a0,a9
	move	*a13(PROCID),a1		;Inherit same ID+1
	addk	1,a1
	move	*a8+,a10		;OID
	jrn	ans250			;No ID?
	addi	CLSANIM,a10
	add	a11,a10			;+offset
	move	*a8+,a11		;#Loops
	jrn	ans220
	move	*a13(animsfnum),a2	;+1 FRANIM cnt
	addk	1,a2
	move	a2,*a13(animsfnum)
ans220	movi	anims_franim,a7
	calla	GETPRC
	move	a13,*a0(anfc_p),L
	move	a6,a11
	jruc	ans50

ans250	addk	16,a8			;Skip #loops
	move	a8,a10
	move	*a13(animslobj_p),a8,L	;Get * to last one
	movi	FRQDELDIE,a7
	calla	GETPRC
	move	a10,a8
	jruc	ans50


ans300	cmpi	AsSLP,a1		;>Sleep
	jrne	ans350
	subk	16,a8			;-WORD
	calla	PRCSLP
	jruc	ans50

ans350	cmpi	AsSLPR,a1		;>Sleep random
	jrne	ans600
	subk	16,a8			;-WORD
	zext	a0
	move	*a8+,a1
	calla	RNDRNG
	calla	PRCSLP
	jruc	ans50

ans600	cmpi	AsWAIT,a1		;>Wait on FRANIMs
	jrne	ans700
	subk	32,a8			;-LONG
ans620	SLEEPK	2
	move	*a13(animsfnum),a1
	jrnz	ans620
	jruc	ans50

ans700	cmpi	AsXY,a1			;>New XY rel to current pos
	jrne	ans800
	subk	16,a8			;-WORD
	move	*a8+,a2
	move	*a8+,a4
	move	*a8+,a5
anshs	move	a0,a1			;Entry for HIDE/SHOW
	zext	a1
ansxyr	addi	CLSANIM,a1
	add	a11,a1			;+offset
	move	@OBJLST,a0,L
ans720	callr	obj_find
	jrz	ans50
	move	*a0(OXPOS),a6		;New X
	add	a4,a6
	move	a6,*a0(OXPOS)
	move	*a0(OYPOS),a6		;New Y
	add	a5,a6
	move	a6,*a0(OYPOS)
	move	*a0,a0,L
	jrnz	ans720
	jruc	ans50

ans800	cmpi	AsXYRNG,a1		;>New XY rel to current pos in rndrng
	jrne	ans900
	subk	16,a8			;-WORD
	sext	a0
	move	*a8+,a1
	calla	RNDRNG
	move	a0,a4
	move	*a8+,a0
	move	*a8+,a1
	calla	RNDRNG
	move	a0,a5
	move	*a8+,a1
	jrn	ans850			;No ID?
	move	*a8+,a2
	jruc	ansxyr

ans850	addk	16,a8			;Skip mask
	move	*a13(animslobj_p),a0,L	;Get * to last one
	move	*a0(OXPOS),a6		;New X
	add	a4,a6
	move	a6,*a0(OXPOS)
	move	*a0(OYPOS),a6		;New Y
	add	a5,a6
	move	a6,*a0(OYPOS)
	jruc	ans50

ans900	cmpi	AsXYV,a1		;>Set XYVel
	jrne	ans1000
	move	a0,a4
	move	*a8+,a5,L
	move	*a8+,a1
	move	*a8+,a2
	addi	CLSANIM,a1
	add	a11,a1			;+offset
	move	@OBJLST,a0,L
ans920	callr	obj_find
	jrz	ans50
	move	*a0(OXVEL),a6,L
	add	a4,a6
	move	a6,*a0(OXVEL),L
	move	*a0(OYVEL),a6,L
	add	a5,a6
	move	a6,*a0(OYVEL),L
	move	*a0,a0,L
	jrnz	ans920
	jruc	ans50

ans1000	cmpi	AsXYVA,a1		;>Set XYVel absolute
	jrne	ans1050
	move	a0,a4
	move	*a8+,a5,L
	move	*a8+,a1
	move	*a8+,a2
	addi	CLSANIM,a1
	add	a11,a1			;+offset
	move	@OBJLST,a0,L
ans1020	callr	obj_find
	jrz	ans50
	move	a4,*a0(OXVEL),L
	move	a5,*a0(OYVEL),L
	move	*a0,a0,L
	jrnz	ans1020
	jruc	ans50

ans1050	cmpi	AsXYV0,a1		;>XYVel = 0
	jrne	ans1100
	subk	32,a8			;-LONG
	move	*a13(animslobj_p),a0,L	;Get * to last one
	clr	a1
	move	a1,*a0(OXVEL),L
	move	a1,*a0(OYVEL),L
	jruc	ans50

ans1100	cmpi	AsZ,a1			;>Set Z pos
	jrne	ans1200
	subk	16,a8			;-WORD
	move	*a8+,a2
	move	*a8+,a4
	move	a0,a1
	zext	a1
	addi	CLSANIM,a1
	add	a11,a1			;+offset
	move	@OBJLST,a0,L
ans1120	callr	obj_find
	jrz	ans50
	move	a4,*a0(OZPOS)
	move	*a0,a0,L
	jrnz	ans1120
	jruc	ans50

ans1200	cmpi	AsLAB,a1		;>Set label
	jrne	ans1250
	subk	16,a8			;-WORD
anslab	move	*a13(animslp_p),a2,L
	move	a8,*a2+,L		;Save *
	move	a0,*a2+
	move	a2,*a13(animslp_p)
	jruc	ans50

ans1250	cmpi	AsLABR,a1		;>Set label randomly
	jrne	ans1300
	subk	16,a8			;-WORD
	zext	a0
	move	*a8+,a1
	calla	RNDRNG
	jruc	anslab

ans1300	cmpi	AsDSJ,a1		;>Decrement and loop to label
	jrne	ans1400
	subk	32,a8			;-LONG
	move	*a13(animslp_p),a1,L
	move	-*a1,a2
	subk	1,a2
	move	a2,*a1
	jrz	ans1330
	move	-*a1,a8,L		;Get *Loop
	jruc	ans50
ans1330	subk	32,a1			;Del loop entry
	move	a1,*a13(animslp_p),L
	jruc	ans50

ans1400	cmpi	AsPAL,a1		;>Set palette
	jrne	ans1600
	subk	32,a8
	move	*a13(animsv),a0,L	;Get *Pal
	calla	GETFPAL
	move	a0,a4
	move	*a8+,a1
	jrn	ans1450
	addi	CLSANIM,a1
	add	a11,a1			;+offset
	move	@OBJLST,a0,L
	clr	a2			;No mask
ans1420	callr	obj_find
	jrz	ans50
	move	a4,*a0(OPAL)
	move	*a0,a0,L
	jrnz	ans1420			;More?
	jruc	ans50

ans1450	move	*a13(animslobj_p),a0,L	;Get * to last obj
	move	a4,*a0(OPAL)
	jruc	ans50

ans1600	cmpi	AsANI,a1		;>Do ANI on OID
	jrne	ans1800
	move	a0,a5
	move	*a8+,a1			;OID
	addi	CLSANIM,a1
	add	a11,a1			;+offset
	move	@OBJLST,a0,L
	clr	a2			;No mask
ans1620	callr	obj_find
	jrz	ans50
	move	a8,a9
	move	a5,a1			;*Img
	move	a0,a8			;*Obj
	move	*a8(OFLAGS),a4		;Same flags
	calla	ANI
	move	a8,a0
	move	a9,a8
	move	*a0,a0,L
	jrnz	ans1620			;More?
	jruc	ans50

ans1800	cmpi	AsDEL,a1		;>Delete obj
	jrne	ans2000
	subk	16,a8			;-WORD
	clr	a1
ans1850	zext	a0
	addi	CLSANIM,a0
	add	a11,a0			;+offset
	calla	KILOBJN
	jruc	ans50

ans2000	cmpi	AsDELM,a1		;>Delete obj with mask
	jrne	ans2400
	subk	16,a8			;-WORD
	move	*a8+,a1
	jruc	ans1850

ans2400	cmpi	AsRUN,a1		;>Run a new anim script
	jrne	ans2450
	move	*a13(PROCID),a1		;Inherit same ID
ans2420	move	a8,a10
	move	a0,a8			;*Script
	move	*a13(animsbx),a9,L	;Get base XY
	movi	anim_script2,a7
	calla	GETPRC
	move	a10,a8
	jruc	ans50

ans2450	cmpi	AsRUNI,a1		;>Run a new anim script with ID
	jrne	ans2500
	move	*a8+,a1
	addi	ANIMPID,a1
	add	a11,a1			;+offset
	jruc	ans2420

ans2500	cmpi	AsCRE,a1		;>Create a process
	jrne	ans2600
	move	*a8+,a9,L		;Pass A9 to process
	movi	ANIMPID+>ff,a1
	add	a11,a1			;+offset
	move	a0,a7
	calla	GETPRC
	jruc	ans50

ans2600	cmpi	AsKIL,a1		;>Kill processes with mask
	jrne	ans2700
	subk	16,a8			;-WORD
	zext	a0
	addi	ANIMPID,a0
	add	a11,a0			;+offset
	move	*a8+,a1
	calla	KILALLN
	jruc	ans50

ans2700	cmpi	AsJMP,a1		;>Jump to new location
	jrne	ans2750
	move	a0,a8
	jruc	ans50

ans2750	cmpi	AsJMPR,a1		;>Jump to new location if RND<#
	jrne	ans2780
	move	a0,a4
	movi	999,a0			;.1 % resolution
	calla	RNDRNG0
	move	*a8+,a1
	cmp	a1,a0
	jrhs	ans50
	move	a4,a8			;Do jmp
	jruc	ans50

ans2780	cmpi	AsJMPEQ,a1		;>Jump to new location if = to mem
	jrne	ans2790
	move	*a0,a0			;Get value
	move	*a8+,a2,L
	move	*a8+,a1
	cmp	a1,a0
	jrne	ans50			;Not same?
	move	a2,a8			;Do jmp
	jruc	ans50

ans2790	cmpi	AsJMPNE,a1		;>Jump to new location if != to mem
	jrne	ans2900
	move	*a0,a0			;Get value
	move	*a8+,a2,L
	move	*a8+,a1
	cmp	a1,a0
	jreq	ans50			;Same?
	move	a2,a8			;Do jmp
	jruc	ans50

ans2900	cmpi	AsSND,a1		;>Do a snd call
	jrne	ans3000
	calla	ONESND
	jruc	ans50

ans3000	cmpi	AsASM,a1		;>Inline code
	jrne	ans3200
	subk	32,a8			;-LONG
	exgpc	a8
	jruc	ans50

ans3200	cmpi	AsHIDE,a1		;>Hide an OID (X+1000)
	jrne	ans3300
	movi	1000,a4
ans3220	subk	16,a8			;-WORD
	clr	a2
	clr	a5
	jruc	anshs

ans3300	cmpi	AsSHOW,a1		;>Show an OID (X-1000)
	jrne	ans3500
	movi	-1000,a4
	jruc	ans3220

ans3500	cmpi	AsADDW,a1		;>Add WORD to mem
	jrne	ans3600
	move	*a8+,a1
	move	*a0,a2
	add	a1,a2
	move	a2,*a0
	jruc	ans50

ans3600	cmpi	AsADDWO,a1		;>Add WORD to last obj+offset
	jrne	ans3700
	subk	16,a8
	move	*a13(animslobj_p),a1,L	;Get * to last one
	move	*a8+,a2			;Offset
	add	a2,a1
	move	*a1,a2
	sext	a0
	add	a0,a2
	move	a2,*a1
	jruc	ans50

ans3700	cmpi	AsADDLO,a1		;>Add LONG # to last obj+offset
	jrne	ans3800
	move	*a13(animslobj_p),a1,L	;Get * to last one
	move	*a8+,a2			;Offset
	add	a2,a1
	move	*a1,a2,L
	add	a0,a2
	move	a2,*a1,L
	jruc	ans50

ans3800	cmpi	AsADLVO,a1		;>Add LONG value to last obj+offset
	jrne	ans4000
	subk	16,a8
	move	*a13(animslobj_p),a1,L	;Get * to last one
	zext	a0
	add	a0,a1			;+Offset
	move	*a13(animsv),a0,L	;Get value
	move	*a1,a2,L
	add	a0,a2
	move	a2,*a1,L
	jruc	ans50

ans4000	cmpi	AsSVRL,a1		;>Set value to rnd long
	jrne	ans4200
	move	*a8+,a1,L
	calla	RNDRNG
	move	a0,*a13(animsv),L
	jruc	ans50

ans4200	cmpi	AsSVRLT,a1		;>Set value to rnd long from a table
	jrne	ans4400
	move	a0,a4
	move	*a4+,a0			;#Table entries
	subk	1,a0
	calla	RNDRNG0
	sll	5,a0			;*32
	add	a0,a4
	move	*a4,a0,L
	move	a0,*a13(animsv),L
	jruc	ans50

ans4400	cmpi	AsSVL,a1		;>Set value to long
	jrne	ans5000
	move	a0,*a13(animsv),L
	jruc	ans50

ans5000	cmpi	AsBXY,a1		;>Add # to BaseXY
	jrne	ans6000
	move	*a13(animsbx),a1,L
	addxy	a0,a1
	move	a1,*a13(animsbx),L
	jruc	ans50

ans6000	cmpi	AsTXT,a1		;>Print text
	jrne	ans6100
	callr	prt0_xy
	jruc	ans50

ans6100	cmpi	AsTXTK,a1		;>Kill text
	jrne	ans9000
	move	a8,-*a12,L		;Save in process stack
	calla	ERASE_TXT
;	movk	4,a11			;Save A11!
;	JSRP	text_shrink		;Sleeps
	move	*a12+,a8,L
	subk	32,a8			;-LONG
	jruc	ans50


ans9000	SLEEPK	1			;>Wait on FRANIMs before exit
	move	*a13(animsfnum),a1
	jrnz	ans5000

	DIE



********************************
* Animation of a part (Process)

	APTRPD	anfc_p,0	;*AnimScrpt process that made me, set by AS
	APTRPD	anfl,2		;*Franim list


 SUBRP	anims_franim		;A9=*FRAN list, A10=OID, A11=# Loops

	move	@OBJLST,a8,L		;>Find object
anf100	move	*a8(OID),a0
	cmp	a10,a0
	jreq	anf300
	move	*a8,a8,L
	jrnz	anf100
	jruc	anf700			;No match!

anf300	move	a9,*a13(anfl),L
anf340	JSRP	FRANIMQ
	move	*a13(anfl),a9,L		;Go to 1st
	move	a11,a11
	jrn	anf340			;-=Infinite
	dsj	a11,anf340

anf700	move	a11,a11
	jrn	anf800
	move	*a13(anfc_p),a0,L	;Get *Creator
	move	*a0(animsfnum),a2	;#Frans-1
	subk	1,a2
	move	a2,*a0(animsfnum)
anf800	DIE



********************************
* Wait for animation processes to finish

 SUBRP	anim_wait

anw10	SLEEPK	3
	move	@animscnt,a1
	jrgt	anw10
	RETP


********************************
* Kill all animation processes and objects

 SUBR	anim_killall

	clr	a0
	move	a0,@animscnt

	movi	ANIMPID,a0	;>Kill processes
	movi	>3ff,a1
	calla	KILALLN

	movi	CLSANIM,a0	;>Delete objs
	movi	>3ff,a1
	jauc	KILOBJN



********************************
* Find an object by OID

 SUBRP	obj_find		;A0=*1st obj, A1=OID, A2=!Mask, A3=Trashed

	andn	a2,a1
of20	move	*a0(OID),a3
	andn	a2,a3		;Remove bits
	cmp	a1,a3
	jreq	of50
	move	*a0,a0,L
	jrnz	of20
of50	move	a0,a0		;A0=*Obj or 0
	rets			;Pass CC




********************************
* Extra junk!!!

	NOTINUSE

********************************
* Calls DO_RACKUP

	.ref	SCORE_FLAG
	.ref	KILBGND,KILALL

 SUBRP	rackcaller
rc10	SLEEPK	30
	move	@SLDEBUG,a0
	btst	0,a0
	jrz	rc10

	movk	1,a0
	move	a0,@INTRO

	calla	KILBGND
	clr	a0
	clr	a1
	calla	KILALL
	clr	a0
	clr	a1
	calla	KILOBJ
	clr	a0
	move	a0,@SCORE_FLAG
	clr	a0
	move	a0,@WORLDTLX+16
	movi	>35b,a0
	move	a0,@WORLDTLY+16
	jruc	DO_RACKUP



	movi	statspal,a0		;>Cycle color loop
	movk	31,a1
	clr	a2
rp45	move	a2,*a0+
	addk	16,a2
	dsj	a1,rp45

	movi	60*4,a8
	clr	a9
	clr	a10

rp50	move	@PCNT,a0
	sll	32-2,a0
	srl	32-2,a0
	jrnz	rp70			;Skip cycle

	movi	31*32*32+ 31*32+ 1,a0
	movi	colorbuf,a1
	move	a0,*a1+			;Set 1st color
	movi	statspal,a2
	movk	30,a4
rp55	move	*a2,a3			;Get color #
	addk	16,a3
	movi	statscolor_t,a0
	add	a3,a0
	move	*a0(16),a5		;Next is end?
	jrge	rp60
	clr	a3			;Restart
rp60	move	*a0+,*a1+
	move	a3,*a2+
	dsj	a4,rp55

	callr	setpal0

rp70	SLEEPK	1			;Sleep 4??
	dsj	a8,rp50


********************************
* Set palette 0 from buffer

	.bss	colorbuf	,16*31		;31 Color buffer

 SUBRP	setpal0
	PUSH	a1,a2
	movi	colorbuf,a0		;*Color
	movk	1,a1			;Palette 0, Color 1
	movk	31,a2			;# Colors
	calla	PALSET
	PULL	a1,a2
	rets



********************************
* Convert BCD to ASCII

	.bss	scorebuf	,12*8	;11 char_s

 SUBRP	bcdtoasc		;A0.L=BCD

	PUSH	a1,a2,a3
	movi	scorebuf+11*8,a1
	clr	a2
	movb	a2,*a1
	movk	4,a3
bcd5	dsj	a3,bcd10		;Convert BCD
	movk	3,a3
	movi	',',a2
	subk	8,a1
	movb	a2,*a1
bcd10	movk	>f,a2
	and	a0,a2
	addi	'0',a2
	subk	8,a1
	movb	a2,*a1
	srl	4,a0
	jrne	bcd5
	move	a1,a0
	PULL	a1,a2,a3
	rets


********************************
* Read joysticks

 SUBRP	joy_read
	move	@SWITCH,a0
	not	a0
	rets			;Pass CC

********************************

;	movi	bonush_st,a0		;>Rackup items
;	movi	hostage_l,a1
;	move	@P1DATA+THSTGS,a2
;	move	@P2DATA+THSTGS,a3
;	movk	5,a4
;	JSRP	bonus_showrack
;
;	movi	bonusf_st,a0
;	movi	flag_l,a1
;	move	@P1DATA+TFLAGS,a2
;	move	@P2DATA+TFLAGS,a3
;	movk	6,a4
;	JSRP	bonus_showrack
;
;	movi	bonusg_st,a0
;	movi	gems_l,a1
;	move	@P1DATA+CASHCNT,a2
;	move	@P2DATA+CASHCNT,a3
;	movk	3,a4
;	JSRP	bonus_showrack



********************************
* Do a bonus rack

	APTRPD	BONUSLP,0	;*Bonus anim list
	WORDPD	BONUSC1,2	;Play 1 # items
	WORDPD	BONUSC2,3	;Play 2 ^
	WORDPD	BONUSPT,4	;Points per item


 SUBRP	bonus_showrack	;A0=*XY text, A1=*Anim list, A2=1Cnt, A3=2Cnt
			;A4=Points per item

	move	@STATUS,a8
	btst	0,a8
	jrnz	bsr20
	clr	a2
bsr20	btst	1,a8
	jrnz	bsr25
	clr	a3
bsr25
	move	a1,*a13(BONUSLP),L
	move	a2,*a13(BONUSC1)
	move	a3,*a13(BONUSC2)
	move	a4,*a13(BONUSPT)

	callr	prt0_xy

	movi	racksup,a0
	calla	ONESND

	movk	10,a0
	move	a0,@boanimdeath1
	move	a0,@boanimdeath2

	movi	hostxy_t,a8		;A8=*Next XY
	clr	a9			;A9=Play1 cnt
	clr	a10			;A10=Play2 cnt
	clr	a11			;A11=P1/2 Death delay bits


bsr40	move	*a13(BONUSC1),a0
	cmp	a0,a9
	jrlo	bsr70			;Cnt up?
	move	@boanimdeath1,a0
	jrle	bsr90
	btst	0,a11
	jrnz	bsr60
	addk	1,a11			;Set bit 0
	PUSH	a0,a8,a9
	move	a13,a8
	clr	a9
	CREATE0	bonus_flashwinblk
	PULL	a0,a8,a9
	addk	14,a0			;Add delay
bsr60	subk	1,a0
	move	a0,@boanimdeath1
	jruc	bsr90

bsr70	addk	1,a9
	move	@P1DATA+PSCORE,a0,L
	move	*a13(BONUSPT),a1
	add	a1,a0			;Add bonus
	move	a0,@P1DATA+PSCORE,L
	movi	rack1it,a0
	calla	ONESND
	move	*a8,a1			;Get X
	jrn	bsr90
	PUSH	a9,a10,a11
	move	*a13(BONUSLP),a9,L
	clr	a10
	movi	boanimdeath1,a11
	CREATE0	bonus_anim
	PULL	a9,a10,a11
bsr90
	move	*a13(BONUSC2),a0
	cmp	a0,a10
	jrlo	bsr120
	move	@boanimdeath2,a0
	jrle	bsr150
	btst	1,a11
	jrnz	bsr100
	addk	2,a11			;Set bit 1
	PUSH	a0,a8,a9
	move	a13,a8
	movk	1,a9
	CREATE0	bonus_flashwinblk
	PULL	a0,a8,a9
	addk	14,a0			;Add delay
bsr100	subk	1,a0
	move	a0,@boanimdeath2
	jruc	bsr150

bsr120	addk	1,a10
	move	@P2DATA+PSCORE,a0,L
	move	*a13(BONUSPT),a1
	add	a1,a0			;Add bonus
	move	a0,@P2DATA+PSCORE,L
	movi	rack1it,a0
	calla	ONESND
	move	*a8,a1			;Get X
	jrn	bsr150
	PUSH	a9,a10,a11
	move	*a13(BONUSLP),a9,L
	movi	184,a10			;X offset
	movi	boanimdeath2,a11
	CREATE0	bonus_anim
	PULL	a9,a10,a11

bsr150
	move	*a8,a0
	jrn	bsr180
	addk	32,a8			;Next XY
bsr180	movk	3,a0
	callr	sleep_var
	move	@boanimdeath1,a0	;Both done?
	jrgt	bsr40
	move	@boanimdeath2,a0
	jrgt	bsr40

	movi	kilfgnd,a0
	calla	ONESND

	calla	ERASE_TXT

	RETP

hostxy_t
	.word	30,45, 60,45, 90,45, 120,45, 150,45
	.word	45,65, 75,65, 105,65, 135,65
	.word	30,85, 60,85, 90,85, 120,85, 150,85
	.word	45,105, 75,105, 105,105, 135,105
	.word	-1



********************************
* Flash other players blocks if he won

 SUBRP	bonus_flashwinblk	;A8=*Creators process, A9=P1 or P2 (0-1)

	move	*a8(BONUSC1),a1
	move	*a8(BONUSC2),a2
	move	@WORLDTLX+16,a10
	move	a9,a9
	jrnz	bfwb70
	SWAP	a1,a2
	addi	190,a10			;A10=Min X of tiles
bfwb70	cmp	a2,a1
	jrlo	bfwbx			;Win round?
	movi	190,a11			;A11=X range of tiles

	movk	3,a8
bfwb80	movi	DMACNZ+M_NOCOLL,a3
	callr	bonus_flashblk
	SLEEPK	2
	movi	DMAWNZ+M_NOCOLL,a3
	callr	bonus_flashblk
	SLEEPK	8
	dsj	a8,bfwb80

bfwbx	DIE


 SUBRP	bonus_flashblk		;A3=OFLAGS, A10=XMin, A11=XWidth

	move	@OBJLST,a1,L
bfb20	move	*a1(OZPOS),a0
	subi	200,a0
	subk	1,a0
	jrhi	bfb30			;Not 200-201?
	move	*a1(OXPOS),a0
	sub	a10,a0
	cmp	a11,a0
	jrhi	bfb30
	move	a3,*a1(OFLAGS)
	movi	>909,a0
	move	a0,*a1(OCONST)
bfb30	move	*a1,a1,L
	jrnz	bfb20
	rets


********************************
* Animation of a bonus item (Process)

 SUBRP	bonus_anim		;A8=*XY, A9=*FRANIM table, A10=X offset
				;A11=*boanimdeath var
	move	*a8+,a0			;Get X
	move	*a8+,a1			;Get Y
	move	*a11,a2
	move	a2,*a13(PDATA)		;Save death #
	addk	1,a2			;+1
	move	a2,*a11
	add	a10,a0
	sll	16,a0
	sll	16,a1
	move	*a9,a2,L
	movi	220,a3
	movi	DMAWNZ+M_NOCOLL,a4
	clr	a5
	clr	a6
	clr	a7
	calla	BEGINOBJ
	move	a9,*a13(PDATA+16),L
bo40	movk	4,a1			;Do one, no sleep
	JSRP	FRANIM
	jrnc	bo60
	move	*a13(PDATA+16),a9,L
	jruc	bo40
bo60	move	a0,a10
bo80	SLEEPK	1
	move	*a11,a0			;Get death #
	move	*a13(PDATA),a1
	cmp	a0,a1
	jrgt	bo90
	dsj	a10,bo80
	jruc	bo40
bo90	move	a8,a0
	calla	DELOBJ
	DIE



********************************
	.endif


	.end

