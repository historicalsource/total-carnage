**************************************************************
*
* Software:		Shawn Liptak
* Initiated:		11/17/91 from Orcus
*
* Modified:		Shawn Liptak, 1/6/92	-Done??
* 			Shawn Liptak, 1/24/92	-DIP switch for keys
*
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 1/24/92 22:49
**************************************************************
	.TITLE	'Akhboobs flying death machine,face & pleasure domes'
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

	.include	"mproc.equ"
	.include	"disp.equ"
	.include	"\video\sys\sys.inc"
	.include	"\video\sys\gsp.inc"
	.include	"game.equ"
	.include	"imgtbl.glo"
	.include	"audit.equ"
	.include	"shawn.hdr"		;My macros
	.include	"orcus.tbl"
	.include	"akhbboss.tbl"


	.ref	CURRENT,BCURRENT,TARGET,HZSPD,ICLIST,ICN5A
	.ref	TTORSO,SETC2,WIPEOUT
	.ref	PLYRPRCS,P1DATA,P2DATA
	.ref	FADEIN,COLCYC,FB_FADEOUT,FB_FADEIN,IRQSKYE,FADE_STRT
	.ref	ONESNDOVR
	.ref	OUT_FLG,FLASHME,GAMERASE
	.ref	PCNT,WAVE,HALT,NOSHOOT,START
	.ref	FRANIMQ,GETFPAL,CLNPAL
	.ref	XBOOM2,BOOM3
	.ref	SCRADD2
	.ref	RNDRNGS,RNDRNG
	.ref	anim_script			;anim_wait
	.ref	prt0_xy
	.ref	fry_plyrs
	.ref	getcloseplyr
	.ref	BAKMODS,KILBGND,BGND_UD1
	.ref	CRSRAM,CTOTAL,T72PNTR
	.ref	BOTMBMOD,DOMEBMOD,THRONEBMOD
	.ref	TAUNTOUT,NO_START,SHK_ON,ICONS_DN,ESCAPED
	.ref	SCRLUP,SCORE_FLAG,INIT_SCORE,BONE
	.ref	PLYRS_CNTR,JOY_UPDATE,P1CTRL,P2CTRL
	.ref	STATUS,DRAW_PLYR_TORSO,DMA_SCORE,ZONE_TXT2
	.ref	FIXGUNS,SETDET,COLLISIONS
	.ref	AFTR_WRP,LSHIT
	.ref	GAMEOVER,vidhwfx_flyin
	.ref	endome_p
	.ref	STRCNRMO,SPECT,ERASE_TXT
	.ref	RD15FONT,RD7FONT
	.ref	aud_addnumplyrs,AUD
	.ref	FINDPAL,girls

	.ref	mortar_akhboob
	.ref	mk_objfranim
	.ref	seekob_dir32la
	.ref	rocket_fireab
	.ref	missile_fireab
	.ref	aboss_smoketrail
	.ref	sodboss


	.def	WFLG,WATR1,WATR2,WATR3
	.def	bossmeterv

;Sound headers

	.ref	LOVEIT

yousuck		.word	>f9a0,10,>80c5,0	;You suck at this game!
musicsnd	.word	>f3fe,10,>800e,0	;Boss music
;landsnd	.word	>fc88,30,>8030,0	;Land from a jump
;laughsnd	.word	>f194,30,>80f2,0	;When plyr dies
exp1snd		.word	>fc80,7,>803e,0		;Explosion
exp2snd		.word	>fd80,10,>80d9,0	;^
;pain1snd	.word	>f985,20,>80f6,0	;
;pain2snd	.word	>f985,20,>80f9,0	;
;groansnd	.word	>f985,20,>8113,0	;Groan
;groanlndsnd	.word	>f185,20,>8113,0	;^ interruptable
;oofsnd		.word	>f985,20,>8114,0	;Oof
;yowl1snd	.word	>f985,30,>8115,0	;
;yowl2snd	.word	>f985,30,>8116,0	;
;roarsnd	.word	>f990,40,>8117,0	;Roar
;roarlongsnd	.word	>f990,120,>8117,0	;Roar
;houchsnd	.word	>f985,20,>8120,0	;
;hyowlsnd	.word	>f985,20,>8122,0	;
;stvpainsnd	.word	>f985,30,>8123,0	;
bubl1snd 	.word	>f5e5,20,>8130,0	;Blood bubbling
;bubl2snd	.word	>f0e5,20,>8131,0	;^
;bubl3snd	.word	>f2e5,20,>8086,0	;^

;myeyesnd	.word	>f9e0,110,>8118,0	;
;myarmsnd	.word	>f9e0,120,>8119,0	;
;myheadsnd	.word	>f9e0,70,>8121,0	;

msllnchsnd	.word	>f290,10,>80b6,0	;Missile launch
mslexpsnd	.word	>f470,10,>8048,0	;Missile explosion
whawhasnd	.word	>fbee,90,>8088,0	;Whawha
racktunesnd	.word	>f3fe,10,>800d,0 	;Rackup tune

* Aboss
ahkb1		.word	>f9a0,60,>80eb,0	;Akhboob speech
ahkb2		.word	>f9a0,60,>80ec,0	;^
ahkb3		.word	>f9a0,60,>80ed,0	;^
ahkbsta		.word	>f9a0,60,>80ee,0	;^ start angry
ahkbang		.word	>f9a0,60,>80ef,0	;^ angry
doorsldsnd	.word	>f480,2,>804c,0		;Door slides
rcktlnchsnd	.word	>f290,10,>812c,0	;Rocket launch
;puffsnd	.word	>f280,10,>8085,0	;Attack balls puffing
tungsnd		.word	>f290,10,>80b6,0	;Tongue launch
pain1snd	.word	>f1f1,40,>8141,0	;Ow
pain2snd	.word	>f1f1,60,>814c,0	;Laugh
pain3snd	.word	>f1f1,60,>8150,0	;Hahaha
pain4snd	.word	>f1f1,80,>8156,0	;See if I care
germ1snd	.word	>f9f7,120,>8142,0
germ2snd	.word	>f9f7,60,>8143,0
germ3snd	.word	>f9f7,80,>8144,0
germ4snd	.word	>f9f7,60,>8145,0
germ5snd	.word	>f9f7,60,>8146,0
germ6snd	.word	>f9f7,60,>8147,0
yougoodsnd	.word	>f9f7,60,>8148,0	;Your really good
excusesnd	.word	>f9f0,10,>814f,0	;Excuse me
painbpsnd	.word	>f9f7,80,>8154,0	;Pain before pleasure
laffsnd		.word	>f9f7,60,>814c,0	;Laugh
peacesnd	.word	>f9f7,90,>8155,0	;Peaceful citizen
amnotsnd	.word	>f9f7,60,>8149,0	;Not

* Pleasure dome
pdtunesnd	.word	>f3fe,10,>800b,0	;Pleasure tune
pdwelcomesnd	.word	>f9a0,60,>813f,0	;Welcome
TOTCARN		.word	>f9f0,120,>80cf,0	;"TOTAL CARNAGE"
WOO1		.word	>f97e,>24,>80cb,0	;WHHOOO
WOO2		.word	>f97e,>24,>80cc,0	;"YEAH"
gosnd		.word	>f17e,20,>8140		;Go
		.word	>f17e,20,>8140
		.word	>f17e,20,>8140,0
pddoorsnd	.word	>f0c0,10,>811a,0	;Big door



	.bss	bossd_t,25*16*4		;Boss object data structure
	.bss	cycmem,16*10*2		;10 color words *2 for cycle
	.bss	abossshld,16		;-1=Eject, 0=Invulnerable, +=Shield str
	.bss	abossaballnum,16	;Num atkballs active
	.bss	bodystat,16		;-=Dead face, 0=Ship, 1-3=face
	.bss	bloflg,16
	.bss	abramend,0

	.bss	keytotal,16		;Plyrs key total at end for prt

	.bss	bossmeterv,16		;Meter value 0-250*16 (4 bits frac)
	.bss	WFLG,16 		;0=NOT ON, 1=YES IT IS ON


****************************************************************
* Akhboob's flying death machine & killer wall (Process)
****************************************************************

EASY		.equ	0	;Makes easy for DEBUG

SUBABANI	.equ	1	;Akhboob ani process
SUBFEYEANI	.equ	2	;Face eye ani process
SUBABMORT	.equ	3	;Akhboob mortar
SUBABGRNT	.equ	>20	;Akhboob grunt
SUBBOSSHALT	.equ	>80	;Freezes action on halt

;Boss data struct

ABDOBJ	.set	>0	;*Parts obj
ABDXO	.set	>20	;X offset from ani pt
ABDSHLD	.set	>30	;Shield, 0=Dead, +=OK


ABXO	.equ	24	;1st obj offsets for center
ABYO	.equ	40
PDX	.equ	2364	;Pleasure dome XY
PDY	.equ	3020

ABWRLDTY .set	100	;Bkgnd world top Y for end of scroll

	WORDPD	abmode		,0	;Mode, -=At top, 0=Msl mania,
					; 1=Chase plyr, 2=Balls
	WORDPD	absko		,1	;Seek offset -1/1
	WORDPD	abdrag		,2	;Drag shift
	WORDPD	abmtrdie	,3	;!0=Boss meter dies

********************************
* Main aboss loop
* A8=Mode (0=Normal, 1=Debug)

 SUBR	aboss

	movk	AUDBOSSEND,a0
	calla	aud_addnumplyrs

	movi	base1,a0
	move	a0,@CURRENT,L

	movi	35,a0
	move	a0,@WAVE

	movi	musicsnd,a0
	calla	ONESND

	clr	a0			;>Clear out boss variables
	movi	bossd_t,a1
abossc	move	a0,*a1+
	cmpi	abramend,a1
	jrlo	abossc

	CREATE	BOSSPID,plyr_shoeson

	.if	DEBUG
	move	a8,a8
	jrnz	aboss_test		;Do test?
	.endif

	move	@WORLDTLX+16,a8		;>Scroll up to pit
	addk	5,a8	   		;A8=X target line to trigger scroll
	clr	a9			;A9=0 (no check for y target)
	movi	path1_t,a10		;Scroll table
	movi	>10000,a0
	move	a0,@HZSPD,L
	CREATE	TARGPID,TARGET

	movi	boss_as,a8
	CREATE	ANIMPID,anim_script

abl50	SLEEPK	5
	movi	TARGPID,a0
	movi	-1,a1
	calla	EXISTP
	jrnz	abl50			;Scroll on?

	calla	CLNPAL

	SLEEP	356
	clr	a0
	move	a0,*a13(abmtrdie)
	move	a13,a11
	CREATE	BOSSPID,ab_bossmeter

	movi	abosspal_t,a0
	movk	2,a1
	calla	FADEIN

	SLEEPK	4+6*3

	movi	200,a0
	movi	SHPY+310,a1
	movi	abossshp_t,a9		;*Init data
	callr	aboss_init

	movi	BBSHPAL,a8
	movi	cycmem,a9		;Ram area
	movi	[60,64],a10		;Begin/end color #
	movk	3,a11			;Rate in ticks
	CREATE	CYCPID,COLCYC		;Color cycler on

	move	@bossd_t,a8,L		;A8=*1st obj
	move	a13,a11
	CREATE	BOSSPID,ab_scrollstrt
	CREATE	BOSSPID,ab_gunturrets
	CREATE	BOSSPID,ab_msllauncher
	CREATE	BOSSPID|SUBABANI,ab_akhboobani
	CREATE	BOSSPID|SUBBOSSHALT,boss_halter

	clr	a10			;A10=Dir 0-31

	movk	1,a0
	move	a0,*a13(absko)		;-1 or 1
	movi	-4,a0			;Normal speed
	move	a0,*a13(abdrag)
	move	a0,*a13(abmode)		;Neg
	movi	60*14,a11		;A11=Mode cnt down (Chase time)
	.if	EASY
	movi	10,a11			;DEBUG
	.endif


abosslp
	SLEEPK	1

	move	*a13(abmode),a0		;>Mode change
	jrle	abl200			;Guns still good?

	subk	1,a11
	jrgt	abl200			;Still counting?
	movi	60*60*20,a11		;Ball time

abl150	addk	1,a0
	move	a0,*a13(abmode)
	subk	2,a0
	jrne	abl200			;!Ball time?
	movi	bossd_t+BLPART,a9	;*Left ball data
	CREATE	BOSSPID,ab_atkball
	movi	bossd_t+BRPART,a9	;*Rgt ball data
	CREATE	BOSSPID,ab_atkball
	movk	2,a0
	move	a0,@abossaballnum

abl200	movk	1,a0
	callr	rnd
	jrnz	abl230			;No smoke?
	CREATE0	aboss_smoketrail


abl230	movk	3,a0			;>Turn
	callr	rnd
	jrz	abl500			;Skip seek?

	move	*a13(abmode),a7
	subk	1,a7
	jrne	abl250			;Go top?

	calla	getcloseplyr		;>Chase plyr
	jrz	abl250			;No player?
	callr	abossseeko_dir32
	jruc	abl300

abl250	movk	32,a0			;Y
	subk	2-1,a7
	jrne	abl260			;!Ball time?
	addk	22,a0			;Lower
	move	@abossshld,a3
	jrge	abl260			;!Docking?
	movk	28,a0
abl260	callr	abossseektop_dir32

abl300	sub	a10,a0			;A0=Difference
	jrz	abl500

	move	a0,a1
	abs	a0
	cmpi	2,a0
	jrle	abl340			;In seeker view?
	move	*a13(abmode),a7
	subk	2,a7
	jreq	abl340			;Ball time?

	move	*a13(absko),a2
	movk	>f,a0
	callr	rnd
	jrnz	abl320			;No dir change?
	neg	a2
	move	a2,*a13(absko)
abl320	add	a2,a10
	jruc	abl400

abl340	subk	16,a0
	jrle	abl350
	neg	a1
abl350	move	a1,a1
	jrnn	abl360
	subk	2,a10			;-1
abl360	addk	1,a10			;+1

abl400	ANDK	>1f,a10			;Make 0-31


abl500	move	a10,a0			;>Thrust
	sll	4,a0			;*16
	addi	missilev_t,a0
	move	*a0(8*16),a6		;XV
	move	*a0,a7			;YV

	move	*a13(abdrag),a2
	move	*a8(OXVEL),a0,L
	move	a0,a3
	sra	a2,a3
	sub	a3,a0			;-Drag
	add	a6,a0			;+Vel
	move	*a8(OYVEL),a1,L
	move	a1,a3
	sra	a2,a3
	sub	a3,a1			;-Drag
	add	a7,a1			;+Vel

	move	a8,a6
	movi	bossd_t,a8		;A8=*Boss data struct
	callr	vel_set
	move	a6,a8

abl700
	callr	ab_keeponscrn

	move	@abossshld,a3
	addk	1,a3
	jrge	abosslp			;Vehicle in air?


aboss_test

;	.ref	BEACONS			;DEBUG
;	CREATE0	BEACONS			;Show cruise msl zones

	calla	CLNPAL

	clr	a0
	clr	a1
	movi	bossd_t,a8		;A8=*Boss data struct
	callr	vel_set

	SLEEP	60*2

	calla	SETC2			;Start land mine color cycle

	clr	a0
	move	a0,@CRSRAM,L
	move	a0,@T72PNTR
	movk	1,a0
	move	a0,@CTOTAL
	movi	36,a0
	move	a0,@WAVE

	movi	BOSSPID|SUBABANI,a0	;Kill akhboob ani
	calla	KIL1C

	movi	bossd_t,a9		;>Delete all objs
	jruc	abl830
abl800	calla	DELOBJ
	clr	a0
	move	a0,*a9+,L		;Clr out *
	addk	32,a9
abl830	move	*a9,a0,L
	jrnz	abl800

	movi	200,a0
	movi	-236,a1
	movi	abossface_t,a9		;*Init data
	callr	aboss_init

	move	@bossd_t,a8,L		;A8=*1st obj

	CREATE	BOSSPID|SUBFEYEANI,ab_faceeyeani
	CREATE	BOSSPID,ab_faceweapons
	CREATE	BOSSPID,ab_minelauncher
	clr	a9
	CREATE	BOSSPID,ab_wtube
	movk	1,a9
	CREATE	BOSSPID,ab_wtube

	movk	1,a0
	move	a0,@bodystat		;Face mode 1
	movi	1500,a9
	.if	EASY
	movi	10,a9			;DEBUG
	.endif
	move	a9,@abossshld
	sll	4-2,a9			;/4 (skip fractions)
	move	a9,@bossmeterv
;	CREATE	BOSSPID,ab_bossmeterup


abllp2	SLEEPK	1

	move	@WORLDTLY+16,a6
	move	*a8(OYPOS),a0
	sub	a6,a0
	move	@bodystat,a4
	jrge	abl1100
	addk	8,a0
abl1100	addk	2,a0
	jrge	abl1200			;Max Y?

	clr	a1			;>Move down 1
	movk	1,a2
	sll	16,a2
	move	@bloflg,a0
	jrz	abl1150			;!Blowing?
	srl	1,a2			;/2
abl1150	callr	boss_addxy


abl1200	move	a4,a4
	jrnn	abllp2

	movk	1,a0
	move	a0,*a13(abmtrdie)	;Kill mtr

	move	@ESCAPED,a0
	jrnz	abl1300			;Akhboob escaped?

	cmpi	ABWRLDTY+300,a6
	jrlt	abllp2


	movi	BOSSPID|SUBABMORT,a0	;Kill akhboob mortar
	calla	KIL1C
	movi	ahkbang,a0
	calla	ONESNDOVR

	SLEEP	60*4

	clr	a0			;Caught akhboob
abl1300	PUSHP	a0

	movi	BOSSPID,a0		;Kill boss procs
	movi	>ff,a1
	calla	KILALLN

	movk	1,a0
	move	a0,@HALT
	move	a0,@TAUNTOUT
	move	a0,@NO_START
	move	a0,@SHK_ON
	movi	TARGPID,a0
       	calla	KIL1C

	calla	INIT_SCORE		;Make scoreboards into images
	SLEEPK	2
	clr	a0
	move	a0,@SCORE_FLAG
	CREATE	3100,SCRLUP

	movi	fade_t,a11
	JSRP	FADE_STRT

	clr	a0
	move	a0,@SHK_ON
	move	a0,@WFLG

	callr	procobjpal_delall
	clr	a0
	move	a0,@HALT
	movi	40,a0
	move	a0,@WAVE

	movk	AUDRPDOME,a0
	calla	aud_addnumplyrs

	movk	1,a8			;Fry akhboob
	movk	23,a10
	PULLP	a0
	jrz	abl1800			;Caught akhboob?
;	jruc	abl1800			;DEBUG
	movi	yousuck,a0	
	calla	ONESND
	movi	whawhasnd,a0
	calla	ONESND
	movk	2,a8			;Escaped
	movk	24,a10
abl1800	clr	a9
	CREATE0	ZONE_TXT2
	SLEEP	60*6
	CREATE0	fry_plyrs		;Fry dictator (A8)

abl2000	SLEEPK	10
	move	@TAUNTOUT,a0
	subk	3,a0
	jrne	abl2000			;Rackup not done?


 SUBR	TEXTTST				;Test

	movi	fade_t,a11
	JSRP	FADE_STRT
	calla	WIPEOUT
	callr	procobjpal_delall
	movk	1,a0
	move	a0,@GAMERASE
	SLEEPK	2

	movk	1,a0
	move	a0,@NO_START

	clr	a9
	movk	25,a10			;Pleasure domes
	CREATE0	ZONE_TXT2
	SLEEP	60*5

	movi	->1004,a0		;Hide screen
	move	a0,@DPYSTRT

	movi	PDX+8,a0		;>Turn on underground
	move	a0,@WORLDTLX+16
	movi	4745,a0
	move	a0,@WORLDTLY+16
	SLEEPK	2
	callr	procobjpal_delall
	movi	pdbkgnd_t,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1

	callr	fountains_strtani

	move	@STATUS,a6		;>Start plyrs
	move	a2,@AFTR_WRP
	btst	0,a6
	jrz	abl2400
	movk	1,a8
	CREATE	PLY1PID,DRAW_PLYR_TORSO
abl2400	btst	1,a6
	jrz	abl2450
	movk	2,a8
	CREATE	PLY2PID,DRAW_PLYR_TORSO
abl2450

	clr	a11			;A11=Key flag
	move	@P1DATA+TKEYS,a2
	move	@P2DATA+TKEYS,a0
	add	a0,a2			;A2=Total keys
	move	a2,@keytotal
	movi	220,a1			;Default # keys
	move	@SWITCH+>30,a7
	btst	7,a7
	jrnz	abl2500
	movi	200,a1			;Easier # keys
abl2500	cmp	a1,a2			;# Keys required
	jrlt	abl2600			;Too low?
	movk	1,a11
	movi	pdwelcomesnd,a0
	calla	ONESND
abl2600	PUSHP	a11

	move	@P1DATA+PSCORE,a0,L
	cmpi	>450000,a0
	jrge	abl2610			;Most of game?
	move	@P2DATA+PSCORE,a0,L
	cmpi	>450000,a0
	jrlt	abl2640			;!Most of game?

abl2610
	movi	AUDKEYTOT,a0		;>Add in keys
	move	a2,a1
	calla	AUD

	movi	AUDFULLGAMES,a0
	movk	1,a1
	calla	AUD
;	calla	aud_addnumplyrs


abl2640	movi	pdtunesnd,a0
	calla	ONESND

	move	a11,a11			;>Fade up with guys running in
	jrz	abl2650			;Not enough keys?
	calla	INIT_SCORE
abl2650	movi	fade_t,a0
	movk	2,a1
	calla	FADEIN
	clr	a0
	calla	FB_FADEIN
	SLEEPK	2
	calla	PLYRS_CNTR
	movi	-4,a0			;Show screen
	move	a0,@DPYSTRT
	SLEEP	40
	move	*a12,a11,L
	jrz	abl2670			;Not enough keys?
	calla	DMA_SCORE
abl2670	SLEEP	40

	calla	SPECT			;Start scorepal cycle

	movi	keycoll_st,a0		;>Show ammount
	calla	prt0_xy
	PULLP	a11
	jrnz	abl2700			;Enough keys?
	calla	prt0_xy			;No entry

abl2700	SLEEP	60*2

	movi	485*>10000/>18333,a8
	move	a11,a11
	jrnz	abl2800			;Enough keys to get in?
	movi	230*>10000/>18333,a8
abl2800	movi	->18333,a9
	CREATE	TARGPID,scroll_y

;	SLEEP	37

abllp3	SLEEPK	1			;>Wait till right before doors
	move	@WORLDTLY+16,a0
	cmpi	5000-215,a0
	jrgt	abllp3

	movk	1,a0
	movb	a0,@P1CTRL
	movb	a0,@P2CTRL

	move	a11,a11
	jrz	abl3300			;Not enough keys?

	move	@keytotal,a0
	cmpi	500,a0
	jreq	abl3000			;Neil (AZAZ) password cheat?

	movk	AUDEPDOME,a0
	calla	aud_addnumplyrs
abl3000

	move	@BAKLST,a0,L		;>Delete entry doors
abl3100	move	*a0(OZPOS),a1
	cmpi	64,a1
	jrne	abl3150
	move	*a0(OSIZE),a1,L
	cmpi	[49,36],a1
	jrne	abl3150
	move	*a0,a3,L		;Get * next
	calla	DELBOBJ
	move	a3,a0
	jruc	abl3170
abl3150	move	*a0,a0,L
abl3170	jrnz	abl3100			;Continue?


abl3300	SLEEPK	5
	movi	TARGPID,a0
	movi	-1,a1
	calla	EXISTP
	jrnz	abl3300			;Scroll on?


	calla	ERASE_TXT

	movi	pdsnd_t,a8		;Akhboob talking
	CREATE0	snd_script

	movi	nopdometxt_s,a8		;No fry akhboob
	move	@ESCAPED,a0
	jrnz	abl3500
	movi	nopdometxt2_s,a8	;Fryed ahkboob!

abl3500	move	a11,a11
	jrz	abl7000			;Not enough keys?

	move	@WORLDTLX+16,a8		;>Scroll through pleasuredome
	addk	5,a8
	clr	a9
	movi	pathpd_t,a10
	movi	>10000,a0
	move	a0,@HZSPD,L
	CREATE	TARGPID,TARGET
	CREATE	COLPID,COLLISIONS
	CREATE0	pdome_rndspch

abllp4	SLEEPK	1
	move	@WORLDTLY+16,a0
	cmpi	4290,a0
	jrgt	abllp4

	movi	pdwelcomesnd,a0
	calla	ONESNDOVR

	clr	a0
	move	a0,@NOSHOOT

	movi	basepd_t,a0		;>Give control to plyrs
	move	a0,@CURRENT,L
	CREATE	JOYPID,JOY_UPDATE
;	CREATE	BOSSPID,plyr_shoeson
	movi	endome_p,a8 		;*Pal
	movi	cycmem,a9		;Ram
	movi	[55,64],a10		;Begin/end color #
	movk	4,a11			;Rate
	CREATE	CYCPID,COLCYC

	clr	a0
	move	a0,@NO_START

	movi	60*90/8,a11		;A11=Time out
abl4000	SLEEPK	8

	movk	3,a0			;75%
	callr	rnd
	jrnz	abl4200
	move	@WORLDTLY+16,a0
	cmpi	3680,a0
	jrgt	abl4200			;South of pools?
	cmpi	3370,a0
	jrlt	abl4200			;North of pools?
	movi	bubl1snd,a0
	calla	ONESND

abl4200	movi	TARGPID,a0
	movi	-1,a1
	calla	EXISTP
	jrz	abl4500			;Scroll done?
	dsj	a11,abl4000

	movi	whawhasnd,a0		;Didn't scroll all the way
	calla	ONESND

abl4500	SLEEP	60*8

;DO CANNED LIST OF SPEEC CALLS HERE?

	movk	1,a0
	move	a0,@NO_START

	movi	pddoorsnd,a0
	calla	ONESND

	move	@OBJLST,a0,L		;>Big doors scroll up
abl5100	move	*a0(OZPOS),a1
	cmpi	159,a1
	jrne	abl5150
	move	*a0(OSIZE),a1,L
	cmpi	[108,64],a1
	jrne	abl5150
	movi	-3,a1
	move	a1,*a0(OYVEL+16)
abl5150	move	*a0,a0,L
	jrnz	abl5100			;More?

	SLEEPK	30

	calla	INIT_SCORE		;>Scroll up scoreboards and fadeout
	SLEEPK	2
	clr	a0
	move	a0,@SCORE_FLAG
	CREATE	3100,SCRLUP
	movi	fade_t,a11
	JSRP	FADE_STRT
	callr	procobjpal_delall

	movi	2057,a0			;>Show thrones
	move	a0,@WORLDTLY+16
	SLEEPK	2
	clr	a0
	move	a0,@GAMERASE
	move	a0,@IRQSKYE		;Black
	movi	->1004,a0		;Start display at bottom of screen
	move	a0,@DPYSTRT
	movi	thronebkgnd_t,a0
	move	a0,@BAKMODS,L
	calla	BGND_UD1

;	move	@pdcash,a0
;	cmpi	200,a0
;	jrge	abl6500			;All prizes?

	jruc	abl6500			;DEBUG

	movi	girls,a0
	calla	FINDPAL
	jrz	abl6500			;No PAL?
	sext	a0
	move	a0,a4
	move	@BAKLST,a0,L		;>Delete girls
abl6000	move	*a0(OPAL),a1
	cmp	a4,a1
	jrne	abl6050
	move	*a0,a3,L		;Get * next
	calla	DELBOBJ
	move	a3,a0
	jruc	abl6100
abl6050	move	*a0,a0,L
abl6100	jrnz	abl6000			;Continue?


abl6500	SLEEPK	3
	clr	a0
	move	a0,@DISPLAYON
	SLEEPK	2
	movi	-4,a0			;Show screen
	move	a0,@DPYSTRT
	calla	vidhwfx_flyin
	movk	1,a0
	move	a0,@DISPLAYON
	movi	victorytxt_s,a8

	SLEEP	60*2

abl7000
	clr	a0
	movb	a0,@P1CTRL
	movb	a0,@P2CTRL
	move	a0,@HALT

	calla	SPECT			;Start scorepal cycle

	JSRP	prt_scrolltxt

	SLEEP	60*10
	calla	CLNPAL
	movi	fade2_t,a11
	JSRP	FADE_STRT
	callr	procobjpal_delall
	jauc	GAMEOVER


path1_t	.word	1,314,0

abosspal_t
	.long	BBSHPAL,0

missilev_t
	.word	-7000,-6866,-6467,-5820,-4950,-3889,-2679,-1365
	.word	0,1365,2678,3889,4950,5820,6467,6865
	.word	7000,6865,6467,5820,4950,3889,2679,1365
	.word	0,-1365,-2678,-3889,-4950,-5820,-6467,-6865
	.word	-7000,-6866,-6467,-5820,-4950,-3889,-2679,-1365

fade_t	.long	3*32*32+4*32+5,0
fadein_t
	.long	SCOREPAL,0

pdbkgnd_t
;	LWW	BOTMBMOD,1000,5000
	LWW	DOMEBMOD,PDX,3018
	.long	-1


keycoll_st
	XYTXT	PRTF15,200,80,63,"KEYS COLLECTED"
	XYNUM	PRTDEC|PRTF15,200,106,63,keytotal
	XYTXT	PRTF15|PRTE,200,160,63,"ENTRY DENIED"
	.word	-1

pdsnd_t	.word	60*17
	LW	painbpsnd,60*3
	LW	painbpsnd,60*2
	LW	laffsnd,60*10
	LW	peacesnd,60*2
	LW	amnotsnd,-1

pathpd_t
	.word	1,1195,0
basepd_t
	.word	PDX,10,PDX+38,9000		;Left Wall
	.word	PDX+360,10,PDX+400,9000		;Rgt ^
	.word	PDX,10,PDX+400,3196		;Top
	.word	PDX,3200,PDX+84,3249		;LColumn
	.word	PDX,3400,PDX+95,3499		;LSnake wall
	.word	PDX,3700,PDX+84,3752		;LC
	.word	PDX,4150,PDX+84,4206		;LC
	.word	0

thronebkgnd_t
	LWW	THRONEBMOD,>944,>7D3
	.long	-1

fade2_t	.long	0,0


********************************
* Delete all processes, objects and palettes

 SUBRP	procobjpal_delall

	clr	a0
	movi	PLYRPRCS,a1
	move	a0,*a1+,L		;These must be cleared!
	move	a0,*a1+,L
	movi	>efff,a1		;Keep only the coin process
	calla	KILALLN
	clr	a0
	clr	a1
	calla	KILOBJ
	calla	KILBGND
	jauc	CLNPAL

********************************
* Scroll background Y
* A8=# Ticks for scroll
* A9=Y add

 SUBRP	scroll_y

sylp	move	@WORLDTLY,a0,L
	add	a9,a0
	move	a0,@WORLDTLY,L
	calla	BGND_UD1
	SLEEPK	1
	dsj	a8,sylp
	DIE


********************************
* Anim script for aboss

boss_as
	ASNEW	bossrisenew_t		;>Ship in pit and sliding door

	ASASM
abas50	SLEEPK	5
	movi	TARGPID,a0
	movi	-1,a1
	calla	EXISTP
	jrnz	abas50			;Scroll on?
	ASENDASM

	ASSLP	60

	ASRUN	doorsnd_as
	ASLAB	27			;>Slide door up
	ASXY	>10,>f,0,-1
	ASDSJS1
	ASHIDE	>10
	ASLAB	33
	ASXY	>10,>f,0,-1
	ASDSJS1
	ASHIDE	>11
	ASLAB	33
	ASXY	>10,>f,0,-1
	ASDSJS1
	ASHIDE	>12
	ASLAB	27
	ASXY	>10,>f,0,-1
	ASDSJS1

	ASSLP	180

	ASSND	rcktlnchsnd
	ASXY	>20,3,-400,0		;>Ship rises
	ASXYV	>20,3,0,->18000
	ASSLP	6
	ASANI	LILBBSHP2,>20
	ASANI	LILBBSHP2A,>21
	ASSLP	6
	ASANI	LILBBSHP3,>20
	ASANI	LILBBSHP3A,>21
	ASSLP	6
	ASDELM	>20,1

	ASLAB	27			;>Slide door down
	ASXY	>10,>f,0,1
	ASDSJS1
	ASSHOW	>12
	ASLAB	33
	ASXY	>10,>f,0,1
	ASDSJS1
	ASSHOW	>11
	ASLAB	33
	ASXY	>10,>f,0,1
	ASDSJS1
	ASSHOW	>10
	ASLAB	27
	ASXY	>10,>f,0,1
	ASDSJS1

	ASASM
	movi	base2,a0
	move	a0,@CURRENT,L
	ASENDASM

	ASSLP	60*40
	ASDELM	0,>ff



	ASASM
abas100	SLEEPK	10
	move	@WORLDTLY+16,a0
	cmpi	ABWRLDTY+90,a0
	jrgt	abas100

	move	@OBJLST,a2,L		;>Set wall Z down
abas200	move	*a2(OZPOS),a0
	cmpi	281,a0
	jrne	abas240
	movi	140,a0
	move	a0,*a2(OZPOS)
abas240	move	*a2,a2,L
	jrnz	abas200			;More?

	ASENDASM

	ASNEW	abwallnew_t

	ASASM
abas400	SLEEPK	15
	move	@WORLDTLY+16,a0
	cmpi	ABWRLDTY+20,a0
	jrgt	abas400
	move	@abossshld,a0
	jrnn	abas400			;Ship OK?
	ASENDASM

	ASLAB	70			;>Slide doors open
	ASXY	>44,0,-1,0
	ASXY	>45,0,1,0
	ASDSJS1

	ASSLP	60*2

	ASASM
abas500	SLEEPK	15
	move	@WORLDTLY+16,a0
	cmpi	ABWRLDTY+3,a0
	jrgt	abas500

	movi	120,a1
	move	@bossd_t,a0,L		;>Set Z low
	move	a1,*a0(OZPOS)
	move	@bossd_t+AKPART,a0,L
	move	a1,*a0(OZPOS)
	movi	-2,a0
	move	a0,@abossshld
	ASENDASM

	ASLAB	69			;>Slide doors closed
	ASXY	>44,0,1,0
	ASXY	>45,0,-1,0
	ASDSJS1

	ASSLP	60*2

	ASLAB	69			;>Slide doors open
	ASXY	>44,0,-1,0
	ASXY	>45,0,1,0
	ASDSJS1

	ASDELM	>44,1

	ASEND

SHPY	.set	48-310
BDX	.set	196-70
BDY	.set	59-310

bossrisenew_t
	ASITEMN	600,SHPY+93,LILBBSHP1,15,DMAWNZ,>20
	ASITEMN	600-1,SHPY+93,LILBBSHP1,15,DMAWNZ+M_FLIPH,>20
	ASITEMN	600,SHPY+93,LILBBSHP1A,15,DMAWNZ,>21
	ASITEMN	600-1,SHPY+93,LILBBSHP1A,15,DMAWNZ+M_FLIPH,>21
	ASITEMN	BDX-25,BDY-35,PCCOVER,25,DMAWNZ,8
	ASITEMN	BDX+166,BDY-35,PCCOVER,25,DMAWNZ+M_FLIPH,8
	ASITEMN	BDX,BDY,STEELPC1,20,DMAWNZ,>10
	ASITEMN	BDX+141,BDY,STEELPC1,20,DMAWNZ+M_FLIPH,>10
	ASITEMN	BDX,BDY+27,STEELPC2,20,DMAWNZ,>11
	ASITEMN	BDX+141,BDY+27,STEELPC2,20,DMAWNZ+M_FLIPH,>11
	ASITEMN	BDX,BDY+60,STEELPC2,20,DMAWNZ,>12
	ASITEMN	BDX+141,BDY+60,STEELPC2,20,DMAWNZ+M_FLIPH,>12
	ASITEMN	BDX,BDY+118,STEELPC1,20,DMAWNZ+M_FLIPV,>13
	ASITEMN	BDX+141,BDY+118,STEELPC1,20,DMAWNZ+M_FLIPH+M_FLIPV,>13
	.word	-1000


BWX	.set	130		;Door XY
BWY	.set	-90
;BHDX	.set	199
;BHDY	.set	-236

abwallnew_t
;	ASITEMN	BWX,BWY,DORWAY1,50,DMAWNZ,>40
;	ASITEMN	BWX+137,BWY,DORWAY1,50,DMAWNZ+M_FLIPH,>40
	ASITEMN	BWX,BWY,BIGDOR,130,DMAWNZ,>44
	ASITEMN	BWX+137,BWY,BIGDOR,130,DMAWNZ+M_FLIPH,>45
	.word	-1000


doorsnd_as
	ASLAB	120/5		;Open
	ASSND	doorsldsnd
	ASSLP	5
	ASDSJ

	ASSLP	60
	ASSND	ahkbang		;Yell!
	ASSLP	126

	ASLAB	120/5		;Close
	ASSND	doorsldsnd
	ASSLP	5
	ASDSJ
	ASEND

********************************
* Initialize boss
* A0=X, A1=Y, A9=*Init table
* Trashes A0-A10

 SUBRP	aboss_init

	move	@WORLDTLX+16,a2		;>Add in WORLDXY
	add	a2,a0
	sll	16,a0
	move	@WORLDTLY+16,a2
	add	a2,a1
	sll	16,a1

	movi	bossd_t,a10

abinlp	move	*a9+,a4			;Get OFLAGS
	jrz	abinx			;End?
	move	*a9+,a5			;OID
	zext	a5
	move	*a9+,a3			;Z
	move	*a9+,a2,L		;*Img
	clr	a6			;XV
	clr	a7			;YV
	PUSH	a0
	CALLA	BEGINOBJ2
	PULL	a0
	move	a10,*a8(OPLINK),L	;Link object to block structure
	move	a8,*a10+,L		;Save pointer to obj
	clr	a2
	move	a2,*a10+,L		;Clr offset & damage
	jruc	abinlp

abinx	clr	a0
	move	a0,*a10,L		;Zero last pointer to mark end

	CREATE	BOSSPID,aboss_glue	;Keep boss together

	rets

ABZ	equ	160
CETA	equ	CLSENMY|TYPABOSS

abossshp_t
	.word	DMAWNZ,CETA|SUBABBACK,ABZ		;Back
	.long	BBSHP1
akpart	.word	DMAWNZ|M_NOCOLL,CLSDEAD|1,ABZ+5		;Akhboob
	.long	AKB1ARMUP1
shpart	.word	DMAWNZ|M_NOCOLL,CLSDEAD,120		;L shadow (2 in row)
	.long	BIGSHAD
	.word	DMAWNZ|M_FLIPH|M_NOCOLL,CLSDEAD,120	;R shadow
	.long	BIGSHAD
	.word	DMAWNZ,CETA,ABZ				;Center
	.long	BBSHP2
	.word	DMAWNZ,CETA,ABZ				;Front
	.long	BBSHP3
	.word	DMAWNZ,CETA,ABZ				;Close left
	.long	BBSHP4
	.word	DMAWNZ,CETA,ABZ				;Far left
	.long	BBSHP5
	.word	DMAWNZ|M_FLIPH,CETA,ABZ			;Close rgt
	.long	BBSHP4
	.word	DMAWNZ|M_FLIPH,CETA,ABZ			;Far rgt
	.long	BBSHP5
blpart	.word	DMAWNZ|M_PIXSCAN,CETA,ABZ-1		;Left ball (3 in row)
	.long	BBALL1
	.word	DMAWNZ,CETA,ABZ-1			;Left arm
	.long	BBARM
	.word	DMAWNZ,CETA,ABZ-1			;Left arm2
	.long	BBARM2
brpart	.word	DMAWNZ|M_PIXSCAN|M_FLIPH,CETA,ABZ-1	;Rgt ball
	.long	BBALL1
	.word	DMAWNZ|M_FLIPH,CETA,ABZ-1		;Rgt arm
	.long	BBARM
	.word	DMAWNZ|M_FLIPH,CETA,ABZ-1		;Rgt arm2
	.long	BBARM2
	.word	0

;SHPART	equ	(shpart-abossshp_t)/80*64
AKPART	equ	(akpart-abossshp_t)/80*64
BLPART	equ	(blpart-abossshp_t)/80*64
BRPART	equ	(brpart-abossshp_t)/80*64

ABFZ	equ	158

abossface_t
	.word	DMAWNZ,CETA,ABFZ			;L head
	.long	TOPHED
	.word	DMAWNZ|M_FLIPH,CETA,ABFZ		;R ^
	.long	TOPHED
	.word	DMAWNZ,CETA,ABFZ			;L hd tubes
	.long	HEDTUBES
	.word	DMAWNZ|M_FLIPH,CETA,ABFZ		;R ^
	.long	HEDTUBES
eyepart	.word	DMAWNZ,CETA,ABFZ			;L eye
	.long	DCI1
	.word	DMAWNZ|M_FLIPH,CETA,ABFZ		;R ^
	.long	DCI1
mthpart	.word	DMAWNZ,CETA,ABFZ			;L mouth
	.long	DCIMTH1
	.word	DMAWNZ|M_FLIPH,CETA,ABFZ		;R ^
	.long	DCIMTH1
	.word	DMAWNZ|M_PIXSCAN,CETA,ABFZ		;L
	.long	CHEEK
	.word	DMAWNZ|M_FLIPH|M_PIXSCAN,CETA,ABFZ	;R
	.long	CHEEK
	.word	DMAWNZ,CETA,ABFZ			;L
	.long	CHIN
	.word	DMAWNZ|M_FLIPH,CETA,ABFZ		;R
	.long	CHIN
	.word	DMAWNZ,CETA,ABFZ			;L
	.long	EAR
	.word	DMAWNZ|M_FLIPH,CETA,ABFZ		;R
	.long	EAR
	.word	0

EYEPART	equ	(eyepart-abossface_t)/80*64
MTHPART	equ	(mthpart-abossface_t)/80*64



********************************
* Boss meter (Process)
* A11=*aboss process

 SUBRP	ab_bossmeter

	movi	bossmeterv,a10
	clr	a0
	move	a0,*a10

	movi	[35,0],a0
	clr	a1
	movi	bmeter,a2
	movk	30,a3			;Z
	movi	DMAWNZ+M_NOCOLL,a4
	movi	CLSDEAD,a5		;ID
	clr	a6
	clr	a7
	calla	BEGINOBJ		;bmeter name
	move	a8,a9
	movi	[35+74,0],a0
	movi	DMACAL+M_NOCOLL,a4
	calla	BEGINOBJ		;bmeter bar
	clr	a0
	move	a0,*a8(OPAL)

	movk	1,a0
	move	a0,*a8(OSIZEX)

abbmlp	move	*a10,a0
	sra	4,a0			;/16
	cmpi	250,a0
	jrle	abbm80			;In range?
	movi	250,a0			;Set max
abbm80
	movi	>c0c,a3			;Green
	cmpi	155,a0
	jrge	abbm120
	movi	>3b3b,a3		;Yellow
	cmpi	70,a0
	jrge	abbm120
	movi	>f0f,a3			;Red
abbm120
	movk	32,a2			;Off bottom
	move	a0,a0
	jrle	abbm400			;No bar?
	clr	a2
	move	a3,*a8(OCONST)
	move	*a8(OSIZEX),a1		;Bar X
	cmp	a0,a1
	jreq	abbm400			;Correct size?
	jrgt	abbm200			;Shrink?
	addk	1,a1
	move	a1,a0
abbm200	move	a0,a1
	move	a1,*a8(OSIZEX)		;Bar X

abbm400	move	@WORLDTLY+16,a1
	addi	242,a1
	move	a1,*a9(OYPOS)
	add	a2,a1
	move	a1,*a8(OYPOS)		;Keep on screen

	SLEEPK	1

	move	*a11(abmtrdie),a0
	jrz	abbmlp			;Continue?

	move	a9,a0
	calla	DELOBJ
	jauc	DELOBJDIE



********************************
* Keep plyrs shoes on (Process)

 SUBRP	plyr_shoeson

	movi	PLYRPRCS,a8
	movi	>8140,a9

psolp	move	*a8,a0,L
	jrz	pso50
	move	*a0(LEG_PRC),a0,L
	move	a9,*a0(SHOECNT)
pso50	move	*a8(32),a0,L
	jrz	pso100
	move	*a0(LEG_PRC),a0,L
	move	a9,*a0(SHOECNT)
pso100	SLOOP	90,psolp


********************************
* Starts various scrollers
* A11=*Aboss process

 SUBRP	ab_scrollstrt

	SLEEP	120

	move	@WORLDTLX+16,a8		;>Start 1st scroll
	addk	5,a8	   		;A8=X target line to trigger scroll
	clr	a9			;A9=0 (not checking for y target)
	movi	pathb2,a10		;Scroll table
	movi	>8000,a0
	move	a0,@HZSPD,L
	CREATE	TARGPID,TARGET
;	clr	a9			;A9=0 for up, 1 for rgt
;	CREATE	ARWPID,ONARRW		;Turn on lft arrow
;	CREATE	FUTUREPID,AOF		;Arrow off after a time

;	movi	baseb2,a0
	clr	a0
	move	a0,@BCURRENT,L


asslp1	SLEEPK	30
	move	*a11(abmode),a0
	jrn	asslp1			;Guns OK?
	movi	TARGPID,a0
	movi	-1,a1
	calla	EXISTP
	jrnz	asslp1			;Scroll on?

	move	@WORLDTLX+16,a8		;>Start 2nd scroll
	addk	5,a8	   		;A8=X target line to trigger scroll
	clr	a9			;A9=0 (not checking for y target)
	movi	pathb3,a10
	movi	>2000,a0
	.if	EASY
	movi	>4000*16,a0		;DEBUG
	.endif
	move	a0,@HZSPD,L
	CREATE	TARGPID,TARGET

	movi	base3,a0
	move	a0,@CURRENT,L
	movi	baseb3,a0
	move	a0,@BCURRENT,L

	SLEEPK	30
	clr	a0

asslp2	sll	2,a0			;*4
	move	a0,a1
	sll	1,a0			;=*8
	add	a1,a0			;=*12
	move	a0,@bossmeterv
ass200	SLEEPK	15
	move	@WORLDTLY+16,a0
	subi	ABWRLDTY+380,a0
	jrgt	asslp2			;!Halfway there?

	movk	1,a0
	move	a0,*a11(abmode)		;Start chase plyr

asslp3	SLEEPK	30
	move	*a11(abmode),a0
	subk	1,a0
	jreq	asslp3			;Still chasing?
	movi	TARGPID,a0
	movi	-1,a1
	calla	EXISTP
	jrnz	asslp3			;Scroll on?

asslp4	SLEEPK	30
	move	@abossaballnum,a0
	jrgt	asslp4			;Atkballs OK?

	move	@WORLDTLX+16,a8		;>Start 3rd scroll
	addk	5,a8	   		;A8=X target line to trigger scroll
	clr	a9			;A9=0 (not checking for y target)
	movi	pathb4,a10
	movi	>4000,a0
	move	a0,@HZSPD,L
	CREATE	TARGPID,TARGET

	movi	ICN5A,a0
	move	a0,@ICLIST,L

	DIE


pathb2	.word	1,212*2,0
	.if	EASY
pathb3	.word	1,532*4/16,0		;DEBUG
	.else
pathb3	.word	1,532*8,0
	.endif
pathb4	.word	1,100*4,0


BXO	.set	>578
BYO	.set	>95

base1	.word	>bab-BXO,>47b-BYO,>c3c-BXO,>4ed-BYO	;Pit
base2	.word	>b20-BXO,>420-BYO,>b50-BXO,>52a		;Lower side wall
	.word	>c9b-BXO,>420-BYO,>cd0-BXO,>1000
	.word	>b20-BXO,20,>b46-BXO,>430-BYO		;Top side wall
	.word	>ca6-BXO,20,>cd0-BXO,>430-BYO
	.word	0
base3	.word	>b2b-BXO,10,>b44-BXO,>3000
	.word	>ca8-BXO,10,>cc7-BXO,>3000
	.word	>b2b-BXO,10,>b86-BXO,>17c-BYO		;Tube up left
	.word	>c64-BXO,10,>cd6-BXO,>17c-BYO		;Tube up rght
	.word	>b2b-BXO,10,>d16-BXO,>140-BYO		;Back wall
	.word	0

baseb2	.WORD	0B2BH-BXO,10,0B5BH-12-BXO,3000H		;SIDE WALL
	.WORD	0C8BH+12-BXO,10,0CC7H-BXO,3000H		;SIDE WALL
	.WORD	0
baseb3	.WORD	0B2BH-BXO,10,0B40H-12-BXO,03000H
	.WORD	0CA8H+12-BXO,10,0CC7H-BXO,03000H
	.WORD	0B2BH-BXO,10,0B86H-12-BXO,17CH-12-BYO	;TUBE UP LEFT
	.WORD	0C64H+12-BXO,10,0CD6H-BXO,017CH-12-BYO	;TUBE UP RGHT
	.WORD	0B2BH-BXO,10,0D16H-BXO,0140H-12-BYO	;BACK WALL
	.WORD	0



********************************
* Keep boss objects together

 SUBRP	aboss_glue

	movi	bossd_t,a8		;A8=*Data block

	move	*a8+,a10,L		;First piece index
	jaz	SUCIDE
	move	a8,a9
	move	*a10(OIMG),a1,L
	move	*a10(OSIZE),a2,L
	move	*a10(OFLAGS),a4
	calla	GANIOF			;Get XY ani offset
	PUSH	a12,a13
	move	a6,a12			;Save X anioff
	move	a7,a13			;Save Y anioff
	jruc	abg40

abglp	move	*a8(OIMG),a1,L
	move	*a8(OSIZE),a2,L
	move	*a8(OFLAGS),a4
	calla	GANIOF			;Get XY ani offset
	sub	a12,a6
	sub	a13,a7

	move	*a8(OID),a0		;Get oid
	move	*a9,a1			;ABDXO

	btst	B_FLIPH,a4
	jrz	abg5			;No flip fix?
	addi	>10000,a6
	neg	a1

abg5	cmpi	CLSDEAD,a0		;>Adjust shadow for height
	jrne	abg10
	btst	B_FLIPH,a4
	jrz	abg8			;No flip fix?
	addi	>10000,a6		;One more
abg8
;	move	@bossz,a0,L
;	sub	a0,a7
	subk	10,a7

abg10	move	*a10(OXVAL),a0,L
	sub	a6,a0
	sll	16,a1
	sub	a1,a0
	move	a0,*a8(OXVAL),L
	move	*a10(OYVAL),a1,L
	sub	a7,a1
	move	a1,*a8(OYVAL),L

abg40	addk	32,a9
	move	*a9+,a8,L		;Get next index
	jrnz	abglp			;More?

	PULL	a12,a13

	SLOOP	1,aboss_glue



********************************
* Check if boss on screen
* A8=*Boss 1st obj
*Rets: Z if on screen, Trashes A0-A3

 SUBRP	ab_keeponscrn

	PUSH	a4,a5
	clr	a2

	move	*a8(OXPOS),a4
	addi	ABXO,a4			;Center X
	move	*a8(OYPOS),a5
	addi	ABYO,a5			;Center Y
	move	*a8(OXVEL),a0,L
	move	*a8(OYVEL),a1,L

	move	@WORLDTLX+16,a3
	sub	a3,a4			;X
	move	@WORLDTLY+16,a3
	sub	a3,a5			;Y

	cmpi	50,a4			;XMin
	jrge	akos50
	movk	1,a2
	abs	a0			;+

akos50	cmpi	350,a4			;XMax
	jrle	akos80
	movk	1,a2
	abs	a0
	neg	a0			;-

akos80	cmpi	-25,a5			;YMin
	jrge	akos120
	movk	1,a2
	abs	a1			;+


akos120	cmpi	250,a5			;YMax
	jrle	akos300
	movk	1,a2
	abs	a1
	neg	a1			;-

akos300	move	a2,a2
	jrz	akosx
	move	a8,a2
	movi	bossd_t,a8		;A8=*Boss data struct
	callr	vel_set
	move	a2,a8

akosx	PULL	a4,a5
	rets


********************************
* Aboss akhboob pilot animations (Process)
* A11=*Aboss process


 SUBRP	ab_akhboobani

	move	@bossd_t+AKPART,a8,L	;*Akhboob obj
aabalp
	movk	15,a0
	callr	rndrng0
	sll	5,a0			;*32
	addi	aaba_t,a0
	move	*a0,a9,L
	move	*a9+,a2			;Get delay
	jrn	aaba50			;No speech?
	CREATE	BOSSPID,ab_akhb_rndspch
	move	a2,*a0(PTIME)
aaba50	JSRP	FRANIMQ
	movi	>7f,a0
	callr	rnd
	addk	10,a0
	calla	PRCSLP
	jruc	aabalp


aaba_t	.long	akbrchl_l,akbrchl_l,akbrchr_l,akbrchr_l
	.long	akbrchl_l,akbrchl_l,akbrchr_l,akbrchr_l
	.long	akbhdtrn_l,akbhdtrn_l,akbhdtrn_l,akbhdtrn_l
	.long	akb1aup_l,akb2aup_l,akbyak_l,akblean_l

akbrchl_l
	.word	-1
	LWW	AKBREACH,FLIPBITS|15,0
	LWL0	AKB1ARMUP1,1
akbrchr_l
	.word	-1
	LWW	AKBREACH,FLIPBITS|15,M_FLIPH
	LWL0	AKB1ARMUP1,1
akbhdtrn_l
	.word	-1
	LW	AKBHEDTURN,40
	LWL0	AKB1ARMUP1,1
akb1aup_l
	.word	4*3
	LW	AKB1ARMUP1,4
	LW	AKB1ARMUP2,4
	LW	AKB1ARMUP3,4
	LW	AKB1ARMUP4,4
	LW	AKB1ARMUP5,4
	LW	AKB1ARMUP6,5
	LW	AKB1ARMUP5,4
	LW	AKB1ARMUP6,5
	LW	AKB1ARMUP5,4
	LW	AKB1ARMUP6,4
	LW	AKB1ARMUP5,4
	LW	AKB1ARMUP4,4
	LW	AKB1ARMUP3,4
	LW	AKB1ARMUP2,4
	LWL0	AKB1ARMUP1,1
akb2aup_l
	.word	4*3
	LW	AKB2ARMUP1,4
	LW	AKB2ARMUP2,4
	LW	AKB2ARMUP3,4
	LW	AKB2ARMUP4,4
	LW	AKB2ARMUP5,5
	LW	AKB2ARMUP4,5
	LW	AKB2ARMUP5,5
	LW	AKB2ARMUP4,5
	LW	AKB2ARMUP5,4
	LW	AKB2ARMUP4,4
	LW	AKB2ARMUP3,4
	LW	AKB2ARMUP2,4
	LWL0	AKB2ARMUP1,1
akbyak_l
	.word	0
	LW	AKBYAK,5
	LW	AKB1ARMUP1,5
	LW	AKBYAK,4
	LW	AKB1ARMUP1,5
	LW	AKBYAK,5
	LW	AKB1ARMUP1,4
	LW	AKBYAK,4
	LW	AKB1ARMUP1,4
	LW	AKBYAK,4
	LWL0	AKB1ARMUP1,1
akblean_l
	.word	0
	LW	AKBLEAN1,5
	LW	AKBLEAN2,5
	LW	AKBLEAN3,5
	LW	AKBLEAN4,5
	LW	AKBLEAN3,5
	LW	AKBLEAN4,5
	LW	AKBLEAN3,5
	LW	AKBLEAN4,5
	LW	AKBLEAN3,5
	LW	AKBLEAN2,5
	LW	AKBLEAN1,5
	LWL0	AKB1ARMUP1,1


********************************
* Random akhboob speech (Process)

 SUBRP	ab_akhb_rndspch

	movk	5,a0
	callr	rndrng0
	sll	5,a0			;*32
	addi	abakhspeech_t,a0
	move	*a0,a0,L
	calla	ONESND
	DIE

abakhspeech_t
	.long	ahkb1,ahkb2,ahkb3,ahkbsta,ahkbang,peacesnd


********************************
* ABOSS turret spawner (Process)
* A8=*1st boss obj
* A11=*ABOSS process

	APTRPD	KPTSOBJ		,0	;For turret (in ARAB)

 SUBRP	ab_gunturrets

	movi	250*16,a0
	move	a0,@bossmeterv

	movk	3,a9			;Gun type
	move	a13,a10
	CREATE	T72PID,TTORSO
	CREATE	T72PID,TTORSO
	CREATE	T72PID,TTORSO

abgtlp	SLEEPK	30
	movi	T72PID,a0
	movi	-1,a1
	calla	EXISTP
	jrnz	abgtlp			;Still alive?

	clr	a0
	move	a0,@bossmeterv
	SLEEP	60
	movi	[30,0],a9
	movk	27,a10			;Survive this barrage of missiles!
	CREATE0	ZONE_TXT2
	SLEEP	4*60	
	clr	a0
	move	a0,*a11(abmode)		;Start missile attack

	DIE



********************************
* Aboss missile launcher (Process)
* A11=*Aboss process

	APTRPD	amlabproc	,0	;*AB proc

 SUBRP	ab_msllauncher

	move	a11,*a13(amlabproc),L

amllp	SLEEPK	8

	move	*a13(amlabproc),a2,L
	move	*a2(abmode),a0
	jrnz	amlslp			;No missile mania?

	move	@bossd_t,a8,L		;*1st obj
	movi	abmslo_t,a9
	movk	1,a0
	callr	rnd
	jrnz	aml500			;Msl?

	callr	getplyr			;>Rocket
	jrz	amlslp			;No player?
	callr	abossseeko_dir32
	move	a0,a10
	subk	6,a10
	movk	7,a11
aml350	CREATE	BOSSPID,rocket_fireab
	movi	rcktlnchsnd,a0
	calla	ONESND
	SLEEPK	1
	addk	2,a10			;Turn
	dsj	a11,aml350
	jruc	amlslp

aml500	movk	3,a11			;>Missile
aml550	movk	4,a0
	callr	rndrng0
	addk	14,a0
	move	a0,a10			;14-18
	CREATE	BOSSPID,missile_fireab
	movi	msllnchsnd,a0
	calla	ONESND
	SLEEPK	7
	addk	32,a9			;Next slot
	dsj	a11,aml550

amlslp
	movi	55,a0
	move	@STATUS,a1
	subk	3,a1
	jreq	aml700				;2 plyrs?
	addk	20,a0				;Easier
aml700	callr	rndrng0
	addk	10,a0
	calla	PRCSLP
	jruc	amllp


abmslo_t
	.word	ABXO,ABYO+15,ABXO-50,ABYO+15,ABXO+50,ABYO+15



********************************
* Aboss attack ball (Process)
* A9=*Ball data struct

;	APTRPD	aababproc	,0	;*AB proc
	WORDPD	aabxvel		,2	;XVel of ball

 SUBRP	ab_atkball

	movi	105,a0
	.if	EASY
	movi	1,a0			;DEBUG
	.endif
	move	a0,*a9(ABDSHLD)		;Set shield


	movi	40,a11
aab100	move	a9,a8			;>Extend ball and arms
	movk	3,a3
aab120	addk	32,a8
	move	*a8,a1			;ABDXO
	addk	1,a1
	move	a1,*a8
	addk	32,a8
	dsj	a3,aab120
	SLEEPK	1
	dsj	a11,aab100

	CREATE	BOSSPID,ab_ballopen
	SLEEP	60
	move	a13,a11
	CREATE	BOSSPID,ab_ballshoot

	movk	1,a0
	move	a0,*a13(aabxvel)

aablp	SLEEPK	1

	move	*a13(aabxvel),a2
	move	*a9(ABDXO),a3
	add	a2,a3
	cmpi	20,a3
	jrge	aab200			;OK?
	movk	20,a3
	jruc	aab400

aab200	cmpi	67,a3
	jrle	aab300			;OK?
	movi	67,a3
	jruc	aab400

aab300	movk	>1f,a0
	callr	rnd
	jrnz	aab420			;!Dir change?
aab400	neg	a2			;Neg XVel
aab420	move	a2,*a13(aabxvel)
	move	a3,*a9(ABDXO)
	move	a3,*a9(ABDXO+64)	;Arm1
	move	a3,*a9(ABDXO+64*2)	;Arm2

;aab600	movk	3,a0
;	callr	rnd
;	addk	3,a0			;3-6
;	move	a0,a6
;	move	a9,a5
;	move	*a9,a8,L
;	movi	sparkball_l,a9
;	movi	70,a0
;	calla	RNDRNGS
;	move	a0,a10
;	movk	30,a11
;aab630	CREATE	BOSSPID,mortar_relaboss
;	addk	25,a11
;	dsj	a6,aab630
;	move	a5,a9

aab800	move	*a9(ABDSHLD),a0
	jrgt	aablp			;Ball OK?

	SLEEP	60*6

aab900	move	a9,a8			;>Retract ball and arms
	movk	3,a3
aab920	addk	32,a8
	move	*a8,a1			;ABDXO
	subk	1,a1
	move	a1,*a8
	addk	32,a8
	dsj	a3,aab920
	SLEEPK	1
	move	*a9(ABDXO),a1
	subk	12,a1
	jrgt	aab900			;Still out?


	move	@abossaballnum,a0
	subk	1,a0
	move	a0,@abossaballnum
	jrgt	aabx
	movi	110,a0
	.if	EASY
	movk	1,a0			;DEBUG
	.endif
	move	a0,@abossshld		;Let ship die

aabx	DIE


;sparkball_l
;	.long	0		;*FRANIM
;	LW	TEST1,2		;82 Ticks
;	LW	TEST2,3
;	LW	TEST3,4
;	LW	TEST4,6
;	LW	TEST5,9
;	LW	TEST6,11
;	LW	TEST7,12
;	LW	TEST6,11
;	LW	TEST5,9
;	LW	TEST4,6
;	LW	TEST3,4
;	LW	TEST2,3
;	LWL0	TEST1,2
;	.word	DMAWNZ
;	.long	BOOM3		;*FRANIM


********************************
* Open the ball and animate (Process)
* A9=*Ball data struct

 SUBRP	ab_ballopen

	SLEEPK	20
	move	*a9,a8,L
	CREATE	BOSSPID,ab_ballopenex
	movi	ballopen_l,a9
	JSRP	FRANIMQ
	DIE

ballopen_l
	LW	BBALL2,7
	LW	BBALL3,7
	LWL	BLLFACE1,NEWPALET|5,GRNFCP
	LW	BLLFACE3,5
	LWL0	BLLFACE4,1


********************************
* Do extra face img for open ball (Process)
* A8=*Ball obj

 SUBRP	ab_ballopenex

	move	a8,a10
	clr	a0
	clr	a1
	movi	BLLOPEN1,a2
	movi	ABZ,a3			;Z
	move	*a10(OFLAGS),a4
	addi	M_NOCOLL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	movi	ballopenex_l,a9
	CREATE	BOSSPID,FRQDELDIE

	movk	13,a11			;>Keep face on ball
aboelp	move	a8,a0
	move	a10,a8
	calla	GETANIXY
	move	*a0(OFLAGS),a4
	calla	GANISAG
	move	a0,a8
	SLEEPK	1
	dsj	a11,aboelp
	DIE

ballopenex_l
	LW	BLLOPEN1,7
	LWL0	BLLOPEN2,7



********************************
* Fire shot from ball (Process)
* A9=*Ball data struct
* A11=*Ball main process

 SUBRP	ab_ballshoot

	move	*a9,a8,L
abslp	CREATE	BOSSPID,ab_ballpuff
	callr	bloop_snd
;	movi	puffsnd,a0
;	calla	ONESND
	SLEEPK	4
	movk	3,a10
abs50	SLEEPK	3
	CREATE	BOSSPID,ab_ballshot
	dsj	a10,abs50
	movi	40,a0
	callr	rndrng0
	move	@STATUS,a1
	subk	3,a1
	jreq	abs300				;2 plyrs?
	addi	60,a0				;Easier
abs300	addi	80,a0
	calla	PRCSLP
	move	*a9(ABDSHLD),a0
	jrgt	abslp
	DIE

********************************
* Do face puffing (Process)
* A8=*Ball obj

 SUBRP	ab_ballpuff

	movi	ballblow_l,a9
	JSRP	FRANIMQ
	DIE

ballblow_l
	LW	BLLBLOW1,2
	LW	BLLBLOW2,2
	LW	BLLBLOW3,2
	LW	BLLBLOW4,2
	LW	BLLBLOW3,2
	LW	BLLBLOW2,2
	LW	BLLBLOW1,2
	LWL0	BLLFACE4,1


********************************
* Fire shot from wall tube (Process)
* A9=Wall # (0=L,1=R)

	WORDPD	shotshield,0	;Shield strength
	WORDPD	shotdrag,2	;Drag shift

 SUBRP	ab_wtubeshot

	move	@WORLDTLX+16,a0
	addi	43,a0
	move	a9,a9
	jrz	awts40			;Left?
	addi	400-43*2,a0
awts40	move	@WORLDTLY+16,a1
	addi	80,a1
	movk	16,a10
	movi	120,a11			;Fuel
	movi	119,a3			;Z
	clr	a6
	movk	2,a7
	sll	16,a7
	jruc	smrtshot_fire


********************************
* Fire shot from atkball (Process)
* A8=*Ball obj
* A9=*Ball data struct
* A11=*Ball main process

 SUBRP	ab_ballshot

	move	*a11(aabxvel),a11
	move	*a8(OXPOS),a0
	addk	26,a0
	move	*a8(OYPOS),a1
	addi	42,a1
	move	*a8(OXVEL),a6,L
	move	*a8(OYVEL),a7,L
	jrgt	abf30			;Pos YVel?
	clr	a7
abf30	addi	>10000,a7
	sll	17,a11			;*2
	move	*a9(OFLAGS),a10
	btst	B_FLIPH,a10
	jrz	abf50			;No flip?
	neg	a11
abf50	sub	a11,a6

	movk	16,a10
	movi	200,a11			;Fuel
	movi	159,a3			;Z


 SUBRP	smrtshot_fire		;A0/A1=XY, A3=Z, A6/A7=XYV, A10=Dir 0-31

	movk	1,a2			;Shield
	move	a2,*a13(shotshield)
	movi	-5,a2			;Slow speed
	move	a2,*a13(shotdrag)

	sll	16,a0
	sll	16,a1
	movi	BALL6,a2		;*Image
	movi	DMAWNZ,a4
	movi	CLSENMY+TYPSL+SUBMSL,a5
	calla	BEGINOBJ2

	movk	25,a9			;Seek delay
	jruc	ssf400


ssf200	SLEEPK	1
	subk	1,a9
	jrlt	ssf220
	jrgt	ssf500			;Don't seek?
	movi	159,a0
	move	a0,*a8(OZPOS)

ssf220
	calla	getcloseplyr
	jrz	ssf700			;No player?
	calla	seekob_dir32la

ssf300	sub	a10,a0			;A0=Difference
	jrz	ssf500

	move	a0,a1
	abs	a0
	subk	16,a0
	jrle	ssf350
	neg	a1
ssf350	move	a1,a1
	jrnn	ssf360
	subk	2,a10			;-1
ssf360	addk	1,a10			;+1


ssf400	ANDK	>1f,a10			;Make 0-31

ssf500	move	a10,a0
	sll	4,a0			;*16
	addi	sballv_t,a0
	move	*a0(8*16),a6		;XV
	move	*a0,a7			;YV

	move	*a13(shotdrag),a2
	move	*a8(OXVEL),a0,L
	move	a0,a1
	sra	a2,a1
	sub	a1,a0			;-Drag
	add	a6,a0			;+Vel
	move	a0,*a8(OXVEL),L
	move	*a8(OYVEL),a0,L
	move	a0,a1
	sra	a2,a1
	sub	a1,a0			;-Drag
	add	a7,a0			;+Vel
	move	a0,*a8(OYVEL),L

ssf700
	movk	>f,a1
	and	a11,a1
	jrnz	ssf800			;Skip screen check?
	calla	SCRTST
	janz	DELOBJDIE
ssf800
;	move	@bloflg,a0
;	jrn	ssfx			;Big blow?

	subk	1,a11
	jrgt	ssf200			;Got fuel?

ssfx	move	*a8(OYPOS),a0
	addk	15,a0
	move	a0,*a8(OYPOS)
	movi	DMAWNZ+M_NOCOLL,a0
	move	a0,*a8(OFLAGS)
	movi	mslexpsnd,a0
	calla	ONESND
	movi	mslnofuel_l,a9		;Out of fuel!
	jauc	FRQDELDIE



sballv_t
	.word	-7000,-6866,-6467,-5820,-4950,-3889,-2679,-1365
	.word	0,1365,2678,3889,4950,5820,6467,6865
	.word	7000,6865,6467,5820,4950,3889,2679,1365
	.word	0,-1365,-2678,-3889,-4950,-5820,-6467,-6865
	.word	-7000,-6866,-6467,-5820,-4950,-3889,-2679,-1365

mslnofuel_l
	LWL	CLDB1,NEWPALET|3,BLUBOOM
	LW	CLDB2,3
	LW	CLDB4,3
	LW	CLD10,3
	LWL0	CLD11,3



********************************
* Part of boss monster takes a hit
* A0=*Obj that hit
* A8=*Boss obj

 SUBR	aboss_hit

	mmtm	sp,a1,a2,a3,a4,a5,a6,a7,a9,a10,a11

	movk	1,a1
	move	a1,@OUT_FLG		;Stop scan

	move	a0,a11			;A11=*Obj that hit
	move	*a11(OID),a10		;Get subtype
	sll	32-3,a10

	move	@bodystat,a6
	jrz	abh300			;Ship on?
	jrn	abhx

	srl	32-3-4,a10		;*16
	addi	buldat2_t,a10		;A10=*Data_t
	move	*a11(OYVEL),a2,L
	jrgt	abh100			;Bad vel?
	subi	>2000,a2
	move	*a10,a9			;>Push face up
	clr	a1
	sra	a9,a2
	callr	boss_addxy
abh100
	movk	1,a0			;50%
	callr	rnd
	jrnz	abhx			;No damage?

	move	@HCOUNT,a0
	sll	32-3,a0
	jrnz	abh110
	callr	snd_rndakhboob		;Do a speech call

abh110	movi	>2d2d0000,a9
	subk	3,a6
	jrne	abh120			;!Skull?
	movi	>35350000,a9
abh120	CREATE0	FLASHME

	move	*a8(OPLINK),a9,L	;A9=*Obj data struct
	move	*a10(>80),a2		;A2=Weapon damage
	jrnn	abh150			;!Bomb?
	movk	1,a0
	callr	rnd
	move	a0,a2			;Bomb damage 0 or 1
abh150
	move	@abossshld,a3
	jrle	abh170			;Not counting?
	sub	a2,a3
	jrgt	abh170			;OK?

	CREATE	BOSSPID,ab_facexpld
	movi	>5000,a1
	callr	boss_scorebonusword
	clr	a3
abh170	move	a3,@abossshld
	sll	4-2,a3			;/4 (skip fractions)
	move	a3,@bossmeterv

	jruc	abh700

					;>Ship collisions
abh300	srl	32-3-4,a10		;*16
;	jrz	abh350			;Bomb?
;	move	@bloflg,a0
;	jrn	abh350			;Blow in progress?
;	callr	bosshit_big

abh350	move	*a11(OXVEL),a1,L
	move	*a11(OYVEL),a2,L
	addi	buldat2_t,a10		;A10=*Data_t
	move	*a10,a9			;>Push back
	sra	a9,a1
	sra	a9,a2
	callr	boss_addxy

	move	*a10,a0			;>Shake
	addk	10,a0
	callr	boss_addrndxy

	movk	3,a0			;75%
	callr	rnd
	jrnz	abhx			;No damage?

	movi	>21210000,a9
	CREATE0	FLASHME

	move	*a8(OPLINK),a9,L	;A9=*Obj data struct
	move	*a10(>80),a2		;A2=Weapon damage
	jrnn	abh400			;!Bomb?
	movk	1,a0
	callr	rnd
	move	a0,a2			;Bomb damage 0 or 1
abh400
	move	@abossshld,a3
	jrle	abh500			;Not counting?
	sub	a2,a3
	jrgt	abh450			;OK?
	CREATE	BOSSPID,ab_afdmxpld
	movi	>4000,a1
	callr	boss_scorebonusword
	clr	a3
abh450	move	a3,@abossshld
	sll	4+2,a3			;*4 (skip fractions)
	move	a3,@bossmeterv
	jruc	abh700

abh500	move	*a9(ABDSHLD),a3		;A3=Shield strength
	jrle	abh700
	sub	a2,a3
	jrgt	abh550			;OK?
	move	@bloflg,a0
	jrnz	abh700			;Blow or lockout in progress?
	CREATE	BOSSPID,ab_ballxpld
	movi	>4000,a1
	callr	boss_scorebonusword
abh550	move	a3,*a9(ABDSHLD)

	move	@bossd_t+BLPART+ABDSHLD,a0
	move	@bossd_t+BRPART+ABDSHLD,a1
	add	a0,a1
	sll	4+1,a1			;*2 (skip fractions)
	move	a1,@bossmeterv

abh700	move	*a10(>80),a1		;Get score
	abs	a1
	calla	boss_scorehit

abhx	mmfm	sp,a1,a2,a3,a4,a5,a6,a7,a9,a10,a11
	rets

; Bullet subtype data table
;SUBLZR		1	;Regular shots
;SUBSPRY	2	;Spray
;SUBFIRE1	3	;Flame thrower
;SUBGRND	4	;Arcing balls
;SUBNOSTP	5	;Non-stopping rockets
;SUBSPDG1	6	;Fast blue balls
buldat2_t
	.word	-2,-3,-3,-3, 0, 0,-2,0		;Shift count
	.word	-1, 1, 1, 3, 4, 3, 1,0		;Damage/score



********************************
* Random akhboob snd for face hit

 SUBRP	snd_rndakhboob

	movk	11,a0
	callr	rndrng0
	sll	5,a0
	addi	srp_l,a0
	move	*a0,a0,L
	jauc	ONESND	  

srp_l
	.long	pain1snd,pain2snd,pain3snd,pain4snd
	.long	pain1snd,pain2snd,pain3snd,pain4snd
	.long	pain1snd,excusesnd
	.long	germ2snd,germ6snd


********************************
* Set, wait and clear bloflg
* A2=Delay before clr

 SUBRP	set_bloflg

	PUSH	a7
	movi	-1,a0
	move	a0,@bloflg
	CREATE	BOSSPID,clr_bloflg
	move	a2,*a0(PTIME)		;Set delay time
	PULL	a7
	rets

clr_bloflg
	clr	a0
	move	a0,@bloflg
	DIE


********************************
* Explode the ball (Process)
* A8=*Ball obj
* A9=*Ball data struct

 SUBRP	ab_ballxpld


	movi	ahkbang,a0
	calla	ONESNDOVR

	movi	60*5,a6
abxlp
	move	*a8(OFLAGS),a4
	move	*a8(OXPOS),a10
	addk	25,a10			;+XO
	move	*a8(OYPOS),a11
	addk	20,a11			;+YO
	btst	0,a6
	jrnz	abx150
	movi	aballlexp_t,a9		;>Explosion
	btst	B_FLIPH,a4
	jrz	abx100			;Left ball?
	movi	aballrexp_t,a9
abx100	CREATE	BOSSPID,mk_objrpalfran
abx150
	movi	exp1snd,a0
	calla	ONESND
	movi	exp2snd,a0
	calla	ONESND
	movk	8,a0
	callr	boss_addrndxy		;Shake!
	movi	>8000,a1
	clr	a2
	btst	B_FLIPH,a4
	jrz	abx400			;LBall?
	neg	a1
abx400	callr	boss_addxy		;Push
	move	a6,a9
	SLEEPK	1
	move	a9,a6
	dsj	a6,abxlp


	movi	aballwrk_l,a9
	JSRP	FRANIMQ
	DIE

aballlexp_t
	LW	xpld_l,3
	.long	GRNPAL,BLUBOOM,ORNGPAL
	.word	190,->800,>200,->800,>800
aballrexp_t
	LW	xpld_l,3
	.long	GRNPAL,BLUBOOM,ORNGPAL
	.word	190,->200,>800,->800,>800

xpld_l	LW	XPLD1,4
	LW	XPLD2,4
	LW	XPLD3,4
	LW	XPLD4,4
	LW	XPLD5,4
	LW	XPLD6,4
	LW	XPLD7,4
	LW	XPLD8,4
	LW	XPLD9,5
	LWL0	XPLD10,5


aballwrk_l
	LWL	BBALLWRECK,NEWPALET|1,BBSHPAL
	.long	0




********************************
* Explode the death machine (Process)
* A8=*Ball obj
* A9=*Ball data struct

 SUBRP	ab_afdmxpld

	movi	ahkbang,a0
	calla	ONESNDOVR

	move	@bossd_t,a8,L		;A8=*1st obj

	movi	60*6,a6
aafxlp
	movk	3,a0
	callr	rnd
	jrz	aafx200			;25% skip explosion
	btst	0,a6
	jrnz	aafx200
	move	*a8(OXPOS),a10
	addk	25,a10			;+XO
	move	*a8(OYPOS),a11
	addi	38,a11			;+YO
	movi	afdmexp_t,a9		;>Explosion
	btst	1,a6
	jrnz	aafx150
	movi	afdmexp2_t,a9
aafx150	CREATE	BOSSPID,mk_objrpalfran

aafx200	movi	exp1snd,a0
	calla	ONESND
	movi	exp2snd,a0
	calla	ONESND
	movk	10,a0
	callr	boss_addrndxy		;Shake!

	move	a6,a9
	SLEEPK	1
	move	a9,a6
	dsj	a6,aafxlp


	movi	EJECTSEAT,a1
	move	*a8(OFLAGS),a4
	calla	ANI

	movi	bossd_t+AKPART+64,a9	;>Delete all objs except for 1-2
	jruc	aafx530
aafx500	calla	DELOBJ
	clr	a0
	move	a0,*a9+,L		;Clr out *
	addk	32,a9
aafx530	move	*a9,a0,L
	jrnz	aafx500

;	move	@bossd_t+SHPART,a8,L	;>Small shadow
;	movi	EJCTSHAD,a1
;	move	*a8(OFLAGS),a4
;	calla	ANI
;	move	@bossd_t+SHPART+64,a8,L
;	move	*a8(OFLAGS),a4
;	calla	ANI

	movi	-1,a0
	move	a0,@abossshld		;Eject!

	DIE


afdmexp_t
	LW	xpld_l,4
	.long	RDBOOM,YELLPAL,WHTPAL,ORNGPAL
	.word	190,->300,>300,->280,>280
afdmexp2_t
	LW	xpld_l,4
	.long	RDBOOM,YELLPAL,WHTPAL,ORNGPAL
	.word	190,->c00,>c00,->a00,>c00



********************************
* Explode the face (Process)

 SUBRP	ab_facexpld

	movi	BOSSPID|SUBFEYEANI,a0	;Kill eye ani
	calla	KIL1C

	movi	60*6,a2
	callr	set_bloflg

	movi	ahkbang,a0
	calla	ONESNDOVR

	move	@bossd_t,a8,L		;A8=*1st obj

	movi	60*5,a6
	.if	EASY
	movi	60*1,a6			;DEBUG
	.endif
afxlp
	move	*a8(OXPOS),a10
	addi	55,a10			;+XO
	move	*a8(OYPOS),a11
	addi	64,a11			;+YO
	btst	0,a6
	jrnz	afx150
	movi	faceexp_t,a9		;>Explosion
	CREATE	BOSSPID,mk_objrpalfran
afx150
	movi	exp1snd,a0
	calla	ONESND
	movi	exp2snd,a0
	calla	ONESND
	movk	>1f,a0			;>Move up rnd
	callr	rnd
	clr	a1
	sll	12,a0
	neg	a0
	move	a0,a2
	move	@bodystat,a0
	subk	3,a0
	jrne	afx180			;!Skull face?
	sra	1,a2			;/2
afx180	callr	boss_addxy
	move	a6,a9
	SLEEPK	1
	move	a9,a6
	dsj	a6,afxlp


	movi	bossd_t,a9		;>Ani to new face
	move	@bodystat,a1
	subk	2,a1
	jrge	afx400			;!Akhboob face?

	movi	germansnd_t,a8
	CREATE0	snd_script
	movi	abhitler_t,a10
	movi	HTLRP,a5
	jruc	afx530

afx400	movi	abskull_t,a10
	movi	RDSKULLP,a5
	subk	3-2,a1
	jrlt	afx530			;Hitler?
	movi	abskulldead_t,a10
	jruc	afx530

afx500	move	*a10+,a1,L
	move	*a8(OFLAGS),a4
	calla	ANI
	move	a5,a0
	calla	GETFPAL			;Get a color map assignment
	move	a0,*a8(OPAL)		;Set new palette

;	clr	a0
;	move	a0,*a9+,L		;Clr out *
	addk	32,a9

afx530	move	*a9+,a8,L
	jrnz	afx500			;Object?


	movi	2300,a3
	.if	EASY
	movi	10,a3			;DEBUG
	.endif
	move	@bodystat,a2
	addk	1,a2
	cmpi	4,a2
	jrlo	afx650			;!Dead?
	neg	a2
	clr	a3
afx650	move	a3,@abossshld		;New shield (Hitler/Skull)
	move	a2,@bodystat
	move	a2,a2
	jrn	afx1000			;Dead?

	sll	4-2,a3			;/4 (skip fractions)
	move	a3,@bossmeterv

	clr	a0
	move	a0,@CRSRAM,L		;More cruise msls

	CREATE	BOSSPID|SUBFEYEANI,ab_faceeyeani	;Restart
	jruc	afxx


afx1000	movk	1,a0
	move	a0,@ICONS_DN

	CREATE	BOSSPID,ab_bubblesnd	;>Bloody mess
	PUSHP	a0
	CREATE	BOSSPID,ab_facebleed

	SLEEP	60*6

	movi	LOVEIT,a0		;I love it speech
	calla	ONESND
	SLEEP	60*1

	movi	racktunesnd,a0
	calla	ONESND

	movk	1,a0
	move	a0,@NOSHOOT		;Plyrs can't shoot

	movi	[30,0],a9
	movk	22,a10			;Find real akhboob
	CREATE0	ZONE_TXT2
	SLEEP	60*5

	PULLP	a0
	calla	KILL			;Kill bubble snd

	move	@PLYRPRCS,a0,L		;>Remove helper blade
	jrz	afx2000
	move	*a0(LSRPTR),a8,L
	jrz	afx2000
	calla	LSHIT
afx2000	move	@PLYRPRCS+32,a0,L
	jrz	afx2050
	move	*a0(LSRPTR),a8,L
	jrz	afx2050
	calla	LSHIT
afx2050

	clr	a0
	move	a0,@ESCAPED		;Ahkboob escaped flag

	CREATE	BOSSPID|SUBABMORT,ab_lnch_akhboobs
	CREATE	BOSSPID|SUBABMORT,ab_lnch_rndspch
	movi	>140,a10
	CREATE0 SETDET  		;Rings on

	move	@WORLDTLX+16,a8		;>Start scroll down
	addk	5,a8	   		;A8=X target line to trigger scroll
	clr	a9			;A9=0 (not checking for y target)
	movi	pathdn_t,a10		;Scroll table
	movi	>8000,a0
	move	a0,@HZSPD,L
	CREATE	TARGPID,TARGET


afxx	DIE


faceexp_t
	LW	xpld_l,7
	.long	RDBOOM,YELLPAL,WHTPAL,ORNGPAL,GRNPAL,BLUBOOM,GREYPAL
	.word	190,->a00,>a00,->200,>c00


abhitler_t
	.long	HTLRTPHED
	.long	IMGNULL
	.long	HEDTUBES
	.long	HEDTUBES
	.long	HTLRI1
	.long	HTLRI1
	.long	HTLRMTH1
	.long	HTLRMTH1
	.long	CHEEK
	.long	CHEEK
	.long	CHIN
	.long	CHIN
	.long	EAR
	.long	EAR

abskull_t
	.long	SKULLTP
	.long	SKULLTP
	.long	IMGNULL
	.long	IMGNULL
	.long	SKULLI1
	.long	SKULLI1
	.long	SKULLMTH1
	.long	SKULLMTH1
	.long	SKULLCHEEK
	.long	SKULLCHEEK
	.long	SKULLCHIN
	.long	SKULLCHIN
	.long	IMGNULL
	.long	IMGNULL

abskulldead_t
	.long	IMGNULL
	.long	IMGNULL
	.long	SKPIPES
	.long	SKPIPES
	.long	IMGNULL
	.long	IMGNULL
	.long	IMGNULL
	.long	IMGNULL
	.long	SKULLRECK
	.long	SKULLRECK
	.long	IMGNULL
	.long	IMGNULL
	.long	IMGNULL
	.long	IMGNULL

IMGNULL	.word	1,1,1000,0
	.long	IROM+3*32

germansnd_t
	.word	60
	LW	germ1snd,>68
	LW	germ2snd,>3c
	LW	germ3snd,>3c
	LW	germ4snd,>3c
	LW	germ5snd,>3c
	LW	germ6snd,>30
	LW	germ2snd,>3c
	LW	germ1snd,>68
	LW	germ6snd,>30
	LW	germ5snd,>3c
	LW	germ3snd,>50
	LW	germ4snd,-1

pathdn_t
	.word	5,1000*2,0


 SUBRP	ab_bubblesnd

abbslp
	movi	bubl1snd,a0
	calla	ONESND
	SLEEPK	20
;	movi	bubl1snd,a0
;	calla	ONESND
;	SLEEPK	20
	jruc	abbslp


********************************
* Face stump bleeds (Process)

 SUBRP	ab_facebleed

	move	@bossd_t+64*2,a8,L	;A8=*1st pipes obj
	movi	60*7,a6

afblp
;	btst	0,a6
;	jrnz	afb150
;	movi	>7f,a0
;	callr	rnd
;	subi	>3f,a0
;	move	a0,a10			;X
;	movi	>3f,a0
;	callr	rnd
;	move	a0,a11			;Y
;	movi	bld_l,a9
;	CREATE	BOSSPID,mortar_relbbase

afb150	move	*a8(OXPOS),a10
	addk	20,a10			;+Ani pt X offset
	move	*a8(OYPOS),a11
	addi	45,a11
	movi	bloodc_t,a9
	CREATE	BOSSPID,mk_objfranim
	CREATE	BOSSPID,mk_objfranim
;	btst	0,a6
;	jrnz	afb170
;	CREATE	BOSSPID,mk_objfranim

afb170	move	a6,a9
;	calla	YZSORT
;	calla	YZSORT
;	calla	YZSORT
	SLEEPK	1
	move	a9,a6
	dsj	a6,afblp

	jruc	afblp


bloodc_t
	.long	bldclt_l
	.word	250,->c0,>c0,->c0,>c0

bldclt_l	;Oval blood spurt
	LW	bldclt1,5
	LW	bldclt2,5
	LW	bldclt3,5
	LW	bldclt4,5
	LW	bldclt5,5
	LW	bldclt6,5
	LW	bldclt7,5
	LWL0	bldclt8,5


********************************
* Fire weapons from big face (Process)

 SUBRP	ab_faceweapons


afwlp	SLEEPK	8
	move	@bloflg,a0
	jrnz	afwslp				;Blowing?

	move	@bossd_t,a2,L			;Get * 1st obj
	move	*a2(OYPOS),a2
	move	@WORLDTLY+16,a0
	sub	a0,a2
	cmpi	-10,a2
	jrlt	afwlp				;Too hi?


	movi	facemslo_t,a9
	move	@bodystat,a0
	subk	3,a0
	jrne	afw100				;!Skull?
	movi	facesklmslo_t,a9
afw100	movk	1,a0
	callr	rnd
	jrnz	afw500				;Msl?

	callr	getplyr				;>Rocket
	jrz	afwslp				;No player?
	callr	abossseeko_dir32
	move	a0,a10

	move	@bossd_t+MTHPART,a8,L		;*LMth
	CREATE	BOSSPID,ab_fmouthani
	move	@bossd_t+MTHPART+64,a8,L	;*RMth
	CREATE	BOSSPID,ab_fmouthani
;	movi	puffsnd,a0
;	calla	ONESND
	SLEEPK	4

	move	@bossd_t,a8,L			;*1st obj
	movk	1,a11
	movk	1,a0
	callr	rnd
	jrnz	afw350				;Only 1?
	subk	8,a10
	movk	5,a11
afw350	CREATE	BOSSPID,rocket_fireab
	movi	rcktlnchsnd,a0
	calla	ONESND
	SLEEPK	1
	addk	4,a10				;Turn
	dsj	a11,afw350
	jruc	afwslp


afw500						;>Missile
	move	@bossd_t+MTHPART,a8,L		;*LMth
	CREATE	BOSSPID,ab_fmouthani
	move	@bossd_t+MTHPART+64,a8,L	;*RMth
	CREATE	BOSSPID,ab_fmouthani
;	movi	puffsnd,a0
;	calla	ONESND
	SLEEPK	4

	move	@bossd_t,a8,L			;*1st obj
	movk	1,a11
	movk	1,a0
	callr	rnd
	jrnz	afw550				;Only 1?
	movk	2,a11
	addk	32,a9				;2nd slot
afw550	movk	4,a0
	callr	rndrng0
	addk	14,a0
	move	a0,a10				;14-18
	CREATE	BOSSPID,missile_fireab
	movi	msllnchsnd,a0
	calla	ONESND
	SLEEPK	1
	addk	32,a9				;Next slot
	dsj	a11,afw550
	jruc	afwslp


afw700	movk	25,a11				;>Tongue
	move	*a8,a8,L			;A8=*1st boss obj

;wl450	movk	12,a0
;	callr	rndrng0
;	addk	10,a0				;10-22
;	move	a0,a10
;	CREATE	BOSSPID,tongue_fire
;	movi	tungsnd,a0
;	calla	ONESND
;	SLEEPK	5
;	dsj	a11,wl450


afwslp	movi	60*6,a0
	callr	rndrng0
	addk	30,a0
	move	@STATUS,a1
	subk	3,a1
	jreq	afw900				;2 plyrs?
	addi	60,a0				;Easier
afw900	calla	PRCSLP
	move	@bodystat,a0
	jrnn	afwlp

	DIE


ABFXO	.equ	55	;Face offsets for center
ABFYO	.equ	100

facemslo_t
	.word	ABFXO,ABFYO,ABFXO-10,ABFYO,ABFXO+10,ABFYO

facesklmslo_t
	.word	ABFXO-21,ABFYO-5,ABFXO-10-21,ABFYO-5,ABFXO+10-21,ABFYO-5



********************************
* Launch mines (Process)

 SUBRP	ab_minelauncher

amnllp	SLEEPK	8
	move	@bloflg,a0
	jrnz	amnl70			;Blowing?

	callr	getplyr			;>Rocket
	jrz	amnllp			;No player?
	callr	abossseeko_dir32
	move	a0,a10

	move	@bossd_t,a8,L		;*1st obj
	CREATE	BOSSPID,ab_mine
	movi	rcktlnchsnd,a0
	calla	ONESND

amnl70	movi	65,a0
	callr	rndrng0
	addk	30,a0
	calla	PRCSLP
	move	@bodystat,a0
	jrnn	amnllp

	DIE

********************************
* Mine (Process)
* A8=*1st boss obj
* A10=Dir 0-31

 SUBRP	ab_mine

	move	a10,a0
	subk	12,a10
	jrge	am40			;Min OK?
	movk	12,a0
am40	subk	20-12,a10
	jrle	am50			;Max OK?
	movk	20,a0
am50	sll	4,a0			;*16
	addi	sballv_t,a0
	move	*a0(8*16),a6		;XV
	move	*a0,a7			;YV
	sll	3,a6
	sll	3,a7

	move	@WORLDTLX,a0,L
	addi	[200,0],a0
	move	*a8(OYVAL),a1,L
	addi	[130,0],a1
	movi	M1,a2
	movi	69,a3			;Z
	movi	DMAWNZ,a4
	movi	CLSNEUT|TYPMINE,a5
	calla	BEGINOBJ2

amlp	SLEEP	90
	move	*a8(OPLINK),a0,L
	cmp	a13,a0
	jrne	amx			;Freed and reallocated?

	move	a8,a0
	calla	ISOBJ
	jrz	amx			;Deleted?

	move	*a8(OYPOS),a2
	move	@WORLDTLY+16,a0
	sub	a0,a2
	cmpi	256,a2
	jrlt	amlp			;Near bottom?
	jauc	DELOBJDIE

amx	DIE



********************************
* Face mouth ani open/close (Process)
* A8=*Mouth obj

 SUBRP	ab_fmouthani

	move	@bodystat,a0
	jrle	afmax			;Bad?
	sll	5,a0			;*32
	addi	afma_t-32,a0
	move	*a0,a9,L
	JSRP	FRANIMQ
afmax	DIE

afma_t	.long	akmth_l,htlrmth_l,skullmth_l

akmth_l
	LW	DCIMTH1,1
	LW	DCIMTH2,1
	LW	DCIMTH3,1
	LW	DCIMTH4,1
	LW	DCIMTH5,15
	LW	DCIMTH4,1
	LW	DCIMTH3,1
	LW	DCIMTH2,1
	LWL0	DCIMTH1,1

htlrmth_l
	LW	HTLRMTH1,1
	LW	HTLRMTH2,1
	LW	HTLRMTH3,1
	LW	HTLRMTH4,1
	LW	HTLRMTH5,15
	LW	HTLRMTH4,1
	LW	HTLRMTH3,1
	LW	HTLRMTH2,1
	LWL0	HTLRMTH1,1

skullmth_l
	LW	SKULLMTH1,2
	LW	SKULLMTH2,2
	LW	SKULLMTH3,15
	LW	SKULLMTH2,2
	LWL0	SKULLMTH1,1


********************************
* Face eye animations (Process)
* A11=*Aboss process

 SUBRP	ab_faceeyeani

	move	@bossd_t+EYEPART+64,a8,L	;*REye obj
afealp
	move	@bodystat,a2
	jale	SUCIDE
	sll	5,a2			;*32
	addi	afea_t-32,a2
	move	*a2,a2,L
	move	*a2+,a0			;# of pairs -1
	callr	rndrng0
	sll	6,a0			;*64
	add	a0,a2
	move	*a2+,a9,L
	CREATE	BOSSPID,afeafr
	move	*a2,a9,L
	JSRP	FRANIMQ
	movk	>1f,a0
	callr	rnd
	addk	5,a0
	calla	PRCSLP
	jruc	afealp

afeafr	move	@bossd_t+EYEPART,a8,L	;FRANIM left eye
	JSRP	FRANIMQ
	DIE


afea_t	.long	afeaak_t,afeaht_t,afeask_t

afeaak_t
	.word	4
	.long	akeyel_l,akeyer_l, akeyer_l,akeyel_l
	.long	akeyel2_l,akeyer2_l, akeyer2_l,akeyel2_l
	.long	akeyeblnk_l,akeyeblnk_l, akeyeblnk_l,akeyeblnk_l

afeaht_t
	.word	4
	.long	hteyel_l,hteyer_l, hteyer_l,hteyel_l
	.long	hteyel2_l,hteyer2_l, hteyer2_l,hteyel2_l
	.long	hteyeblnk_l,hteyeblnk_l, hteyeblnk_l,hteyeblnk_l

afeask_t
	.word	1
	.long	skeyeblnk_l,skeyeblnk_l, skeyeblnk2_l,skeyeblnk2_l


akeyel_l
	LW	DCI1A,4
	LW	DCI1B,4
	LW	DCI1C,4
	LW	DCI1B,4
	LW	DCI1A,4
	LWL0	DCI1,1
akeyer_l
	LW	DCI1D,4
	LW	DCI1E,4
	LW	DCI1F,4
	LW	DCI1E,4
	LW	DCI1D,4
	LWL0	DCI1,1
akeyel2_l
	LW	DCI1A,4
	LW	DCI1B,4
	LW	DCI1C,20
	LW	DCI1B,4
	LW	DCI1A,4
	LWL0	DCI1,1
akeyer2_l
	LW	DCI1D,4
	LW	DCI1E,4
	LW	DCI1F,20
	LW	DCI1E,4
	LW	DCI1D,4
	LWL0	DCI1,1
akeyeblnk_l
	LW	DCICLOSED,4
	LW	DCICLOSED2,4
	LW	DCICLOSED,4
	LWL0	DCI1,1

hteyel_l
	LW	HTLRI1A,4
	LW	HTLRI1B,4
	LW	HTLRI1C,4
	LW	HTLRI1B,4
	LW	HTLRI1A,4
	LWL0	HTLRI1,1
hteyer_l
	LW	HTLRI1D,4
	LW	HTLRI1E,4
	LW	HTLRI1F,4
	LW	HTLRI1E,4
	LW	HTLRI1D,4
	LWL0	HTLRI1,1
hteyel2_l
	LW	HTLRI1A,4
	LW	HTLRI1B,4
	LW	HTLRI1C,20
	LW	HTLRI1B,4
	LW	HTLRI1A,4
	LWL0	HTLRI1,1
hteyer2_l
	LW	HTLRI1D,4
	LW	HTLRI1E,4
	LW	HTLRI1F,20
	LW	HTLRI1E,4
	LW	HTLRI1D,4
	LWL0	HTLRI1,1
hteyeblnk_l
	LW	HTLRICLOSED,4
	LW	HTLRICLOSED2,4
	LW	HTLRICLOSED,4
	LWL0	HTLRI1,1

skeyeblnk_l
	LW	SKULLI2,4
	LW	SKULLI3,4
	LW	SKULLI2,4
	LWL0	SKULLI1,1
skeyeblnk2_l
	LW	SKULLI2,3
	LW	SKULLI3,3
	LW	SKULLI2,3
	LWL0	SKULLI1,1

********************************
* Wall tube weapon launcher (Process)
* A9=Wall # (0=L,1=R)

 SUBRP	ab_wtube

awtlp
	movk	8,a11
awtlp2	CREATE	BOSSPID,ab_wtubeshot
	SLEEPK	5
	dsj	a11,awtlp2
	movi	180,a0
	callr	rndrng0
	addi	60,a0
	move	@STATUS,a1
	subk	3,a1
	jreq	awt50			;2 plyrs?
	addi	120,a0			;Easier
awt50	calla	PRCSLP
	move	@bodystat,a0
	jrnn	awtlp
	DIE


********************************
* Launch akhboobs from dead face (Process)

 SUBRP	ab_lnch_akhboobs

	SLEEP	60*1
	move	@bossd_t+64*2,a8,L	;A8=*1st pipes obj

alalp	movk	3,a11
ala50	CREATE	BOSSPID|SUBABGRNT,mortar_akhboob
;	callr	bloop_snd
	SLEEPK	15
	dsj	a11,ala50

	SLEEPK	30
	jruc	alalp



********************************
* Random akhboob speech (Process)

 SUBRP	ab_lnch_rndspch

alrslp	movk	11,a0
	callr	rndrng0
	sll	5,a0			;*32
	addi	akhspch_t,a0
	move	*a0,a0,L
	calla	ONESND
	movi	60*1,a0
	callr	rndrng0
	addi	120,a0
	calla	PRCSLP
	jruc	alrslp

akhspch_t
	.long	ahkb1,ahkb2,ahkb3,ahkbsta,ahkbang
	.long	germ1snd,germ2snd,germ3snd,germ4snd,germ5snd,germ6snd
	.long	excusesnd


********************************
* Make slime pool sound

 SUBRP	bloop_snd

	move	@HCOUNT,a0
	sll	32-2,a0
	srl	32-2-5,a0
	addi	bloop_t,a0
	move	*a0,a0,L
	movk	2,a1		;repeat it
	jauc	SNDLD

bloop_t	.long	blp1snd,blp2snd,blp3snd,blp4snd

blp1snd		.word	>f575,20,>8134,0	;Bloop snd
blp2snd		.word	>f575,20,>8136,0	;
blp3snd		.word	>f575,20,>8138,0	;
blp4snd		.word	>f575,20,>813a,0	;


********************************
* Gun turret from wall (Process)
* A9=Tur # (0=L, 1-R)

; SUBRP	ab_wallturret

;	move	@WORLDTLX,a0,L
;	addi	[200,0],a0
;	move	*a8(OYVAL),a1,L
;	addi	[130,0],a1
;	movi	TURBL1,a2
;	movi	158,a3			;Z
;	movi	DMAWNZ,a4
;	movi	CLSNEUT|TYPMINE,a5
;	clr	a6
;	clr	a7
;	calla	BEGINOBJ2
;
;
;	DIE


********************************
* Halt boss processes if halt on (Process)

 SUBRP	boss_halter

bhlp	SLEEPK	8
	move	@HALT,a0
	jrz	bhlp			;No halt?
	movi	BOSSPID,a0
	movk	>1f,a1
	movk	8,a2
	calla	KOP_ALL
	jruc	bhlp


********************************
* Get aboss dir to face top of screen
* A0=Y offset
* A8=*Boss 1st obj
* Trashes A0-A3,A6-A7
*Rets:
* >A0=Dir 0-31

 SUBRP	abossseektop_dir32

	move	@WORLDTLX+16,a6		;Dest XY
	addi	200,a6
	move	@WORLDTLY+16,a7
	add	a0,a7
	jruc	absod32

********************************
* Get aboss dir to face a plyr
* A0=*Plyr obj to follow
* A8=*Boss 1st obj
* Trashes A0-A3,A6-A7
*Rets:
* >A0=Dir 0-31

 SUBRP	abossseeko_dir32

	move	*a0(OXPOS),a6		;A6=Plyr X
	addk	5,a6
	move	*a0(OYPOS),a7		;A7=^ Y

absod32	move	*a8(OXPOS),a0
	addi	ABXO,a0			;+Center pt X offset
	move	*a8(OYPOS),a1
	addi	ABYO,a1			;^YO

	jauc	sodboss


********************************
* Add random XY to boss position
* A0=XY Max (word)
* Trashes A0-A3

 SUBRP	boss_addrndxy

	sll	15,a0			;Make long
	move	a0,a3
	calla	RNDRNGS
	move	a0,a2			;Y
	move	a3,a0
	calla	RNDRNGS
	move	a0,a1			;X

********************************
* Add XY to boss position
* A1=Delta X
* A2=Delta Y

 SUBRP	boss_addxy

	PUSH	a2,a3,a4
	movi	bossd_t,a4
	jruc	baxy5

baxylp	move	*a0(OXVAL),a3,L
	add	a1,a3
	move	a3,*a0(OXVAL),L
	move	*a0(OYVAL),a3,L
	add	a2,a3
	move	a3,*a0(OYVAL),L
	addk	32,a4
baxy5	move	*a4+,a0,L
	jrnz	baxylp			;More?

	PULL	a2,a3,a4
	rets


********************************
* Stuff new velocity into boss object
* A0=XV
* A1=YV
* A8=*Boss data struct

 SUBRP	vel_set

	PUSH	a2,a8
	jruc	vs50

vslp	move	a0,*a2(OXVEL),L
	move	a1,*a2(OYVEL),L
	addk	32,a8
vs50	move	*a8+,a2,L
	jrnz	vslp			;More?

	PULL	a2,a8
	rets


********************************
* Player score
* A1=Amount to add (8 digit bcd)
* A11=*Bullet object that killed

 SUBRP	boss_scorehit

	PUSH	a2
	move	*a11(OPLINK),a0,L
	movb	*a0(MYPLYR),a0		;A0=Player #
	movi	P1DATA,a2
	subk	1,a0
	jreq	bsch1
	movi	P2DATA,a2
bsch1	calla	SCRADD2			;Do it!
	PULL	a2
	rets


********************************
* Score and send bonus word to score panel
* A1=Amount to add (8 digit bcd)
* A8=*Src obj
* A11=*Bullet obj

 SUBRP	boss_scorebonusword

	PUSH	a2,a7,a9,a10

	move	*a11(OPLINK),a10,L
	movb	*a10(MYPLYR),a0		;A0=Player #
	movi	P1DATA,a2
	subk	1,a0
	jreq	bsbw10			;P1?
	movi	P2DATA,a2
bsbw10	move	*a2(TBIGSTF),a0
	addk	1,a0
	move	a0,*a2(TBIGSTF)		;Total big stuff destroyed
	calla	SCRADD2

	movk	1,a9
	CREATE	FUTUREPID,BONE

	PULL	a2,a7,a9,a10
	rets


********************************
* Get random # with mask
* A0=Mask
* Preserves Regs 2-13

 SUBRP	rnd

	move	@RAND,a1,L
	rl	a1,a1
	move	@HCOUNT,a14
	rl	a14,a1
	add	sp,a1
	move	a1,@RAND,L

	and	a1,a0		;A0=Rnd #
	rets			;Pass CC

********************************
* Quickly produce a random # in range 0-X
* A0=X
* Preserves Regs 2-13
* >A0 = RANDOM # (0 to A0)

 SUBRP	rndrng0

	move	@RAND,a1,L
	rl	a1,a1
	move	@HCOUNT,a14
	rl	a14,a1
	add	sp,a1
	move	a1,@RAND,L
	addk	1,a0
	mpyu	a1,a0		;Condition codes not valid!

	rets


********************************
* Get a random player 1 or 2
*Rets: A0=*Player leg obj or 0 (Pass Z)

 SUBRP	getplyr

	movk	1,a0
	callr	rnd
	jrnz	getp2
	move	@PLYRPRCS,a0,L
	jrnz	getp1			;P1?
	move	@PLYRPRCS+32,a0,L
	jrz	getpx			;No players?
getp1	move	*a0(DEAD),a1
	jrz	getpok
	clr	a0
getpx	rets
getp2	move	@PLYRPRCS+32,a0,L
	jrnz	getp1			;P2?
	move	@PLYRPRCS,a0,L
	jrnz	getp1			;P1?
	rets
getpok	move	*a0(LEG_PTR),a0,L
	rets




********************************
* Make an obj, franim and delete (Process)
* A9=*Data table
* A10=X
* A11=Y

 SUBRP	mk_objrpalfran

	clr	a6
	clr	a7
mofbv	move	a9,a5
	move	*a5+,a9,L		;*FRANIM_l
	move	*a5+,a0			;Get # palettes
	move	a5,a2
	move	a0,a1
	sll	5,a1			;*32
	add	a1,a5			;Skip list
	subk	1,a0
	callr	rndrng0
	sll	5,a0			;*32
	add	a0,a2
	move	*a2,a8,L		;Get *PAL

mof20	move	*a9,a2,L		;*IMG
mof40	move	*a5+,a3			;Z
	move	*a5+,a0
	move	*a5+,a1
	calla	RNDRNG
	sll	8,a0			;*256
	add	a0,a6			;XV
	move	*a5+,a0
	move	*a5+,a1
	calla	RNDRNG
	sll	8,a0			;*256
	add	a0,a7			;YV
	move	a10,a0
	move	a11,a1
	sll	16,a0			;X
	sll	16,a1			;Y
	movi	DMAWNZ+M_NOCOLL,a4	;No collisions
	movi	CLSDEAD,a5
	move	a8,a10
	calla	BEGINOBJ2

	move	a10,a0			;*PAL
	calla	GETFPAL
	jrz	mof70			;No palette?
	move	a0,*a8(OPAL)		;Set new palette
mof70	jauc	FRQDELDIE



********************************
* Start the pleasure dome fountain anims

 SUBRP	fountains_strtani

	movi	fount_t,a8
fsalp	CREATE0	fountain_ani
	addi	80,a8
	move	*a8,a0,L
	jrnz	fsalp
	rets

fount_t	LWWW	watr_l,106,-60,DMAWNZ|M_NOCOLL
	LWWW	watr_l,300,-60,DMAWNZ|M_NOCOLL|M_FLIPH
	LWWW	fount_l,70,-1217,DMAWNZ|M_NOCOLL
	LWWW	nside_l,114,-1212,DMAWNZ|M_NOCOLL
	LWWW	wside_l,56,-1200,DMAWNZ|M_NOCOLL
	LWWW	fount_l,332,-1153,DMAWNZ|M_NOCOLL|M_FLIPH
	LWWW	nside_l,288,-1148,DMAWNZ|M_NOCOLL|M_FLIPH
	LWWW	wside_l,347,-1135,DMAWNZ|M_NOCOLL|M_FLIPH
	.long	0

watr_l	LW	WATR1,6
	LW	WATR2,6
	LWL0	WATR3,6

fount_l	LW	fount1,7
	LW	fount2,7
	LW	fount3,7
	LWL0	fount4,7

nside_l	LW	nside1,7
	LW	nside2,7
	LW	nside3,7
	LWL0	nside4,7

wside_l	LW	wside1,7
	LW	wside2,7
	LW	wside3,7
	LWL0	wside4,7


 SUBRP	fountain_ani

	move	*a8+,a9,L
	move	*a8+,a0			;X
	move	*a8+,a1			;Y
	sll	16,a0
	sll	16,a1
	move	*a9,a2,L
	movi	170,a3			;Z
	cmpi	fount_l,a9
	jrne	fa50			;!Fountain
	addk	5,a3			;+Z
fa50	move	*a8+,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ

	move	a9,a11
falp	JSRP	FRANIMQ
	move	a11,a9
	jruc	falp


********************************
* Random pdome speech (Process)

 SUBRP	pdome_rndspch

pdrslp	movk	5,a0
	callr	rndrng0
	sll	5,a0			;*32
	addi	pdspeech_t,a0
	move	*a0,a0,L
	calla	ONESND
	movi	60*5,a0
	callr	rndrng0
	addi	90,a0
	calla	PRCSLP
	jruc	pdrslp

pdspeech_t
	.long	LOVEIT,TOTCARN,WOO1,WOO2,pdwelcomesnd,gosnd


********************************
* Run a sound script (Process)
* A8=*Script

 SUBRP	snd_script

	move	*a8+,a0			;1st sleep
sslp	calla	PRCSLP
	move	*a8+,a0,L
	calla	ONESND
	move	*a8+,a0
	jrgt	sslp			;More?
	DIE


********************************
* Print text scrolling up
* A8=*String table

 SUBRP	prt_scrolltxt

	CREATE0	scrolltxt
pstlp	movb	*a8,a0
	jrnn	pst100
	move	@SWITCH+>30,a1
	btst	0,a0
	jrz	pst50			;Normal?
	not	a1			;Flip the test
pst50	btst	7,a1
	jrnz	pst80			;DIP off?
pst70	addk	8,a8
	movb	*a8,a0
	jrnz	pst70			;!End of line?
	addk	8,a8			;1st char next line
	jruc	pst300
pst80	addk	8,a8
pst100	clr	a0
	movi	>3f3f,a6		;Color
	movi	[256,200],a9		;Y:X
	movk	[0,1],a10		;Char Y:X spacing
	movi	RD15FONT,a11		;*Font
	JSRP	STRCNRMO

	SLEEP	85
pst300	movb	*a8,a0
	jrnz	pstlp
	RETP


********************************
* Scroll all text up screen, delete if off top (Process)

 SUBRP	scrolltxt

stlp	move	@WORLDTLY+16,a6
	subk	20,a6

	move	@OBJLST,a0,L
st40	move	*a0(OID),a1
	cmpi	CLSNEUT|TYPTEXT|SUBTXT,a1
	jrne	st70
	move	*a0(OYPOS),a1
	cmp	a6,a1
	jrge	st60
	move	*a0,a3,L	;Get * next
	calla	DELOBJ
	move	a3,a0
	jruc	st80

st60	movi	->8000,a1
	move	a1,*a0(OYVEL),L
st70	move	*a0,a0,L
st80	jrnz	st40		;Continue?

	SLEEPK	2
	jruc	stlp



;TX	$macro	t
;	.byte	:t:,0
;	$end

********************************
* Text - destroyed akhboobs capabilities and entered pdomes

victorytxt_s
	.byte	"Congratulations!",0
	.byte	" ",0
	.byte	"You have joined the heroes",0
	.byte	"from Smash T.V. in the",0
	.byte	"Pleasure Domes!  We have",0
	.byte	"been waiting for you!  The",0
	.byte	"ladies have been most anxious!",0
	.byte	" ",0
	.byte	"You have delivered Captain",0
	.byte	"Carnage and Major Mayhem into",0
	.byte	"a life of leisure.  Their every",0
	.byte	"wish will be granted.  Of",0
	.byte	"course, they will have to share",0
	.byte	"the goodies with the Smash boys,",0
	.byte	"but there is plenty to go around!",0
	.byte	" ",0
	.byte	"You are one of only a few",0
	.byte	"who have reached this far.",0
	.byte	" ",0
	.byte	"You are a great dual joystick",0
	.byte	"game player.",0
	.byte	" ",0
	.byte	" ",0
	.byte	"However, as greedy as you are, you",0
	.byte	"failed to pick up all the cash and",0
	.byte	"prizes sitting in the Pleasure Dome!",0
	.byte	" ",0
	.byte	"If you do this, the ladies will",0
	.byte	"prove that pain before pleasure",0
	.byte	"is worth it.",0
	.byte	" ",0
	.byte	"Can you do this?",0
	.byte	" ",0
	.byte	" ",0
	.byte	"Thank you for playing",0
	.byte	"Total Carnage.",0
	.byte	" ",0
	.byte	" ",0
	.byte	"Total Carnage Design Team:",0
	.byte	"Mark Turmell",0
	.byte	"John Tobias",0
	.byte	"Shawn Liptak",0
	.byte	"Jim Gentile",0
	.byte	"Jon Hey",0
	.byte	"Eugene Jarvis",0
	.byte	"Tony Goskie",0
	.byte	" ",0
	.byte	"Special Thanks:",0
	.byte	"George Petro",0
	.byte	"Larry Demar",0
	.byte	"Ed Boon (Voices)",0
	.byte	"Todd Allen",0
	.byte	"Cary Mednick",0
	.byte	"Sheridan Oursler",0
	.byte	"Mark Loffredo",0
	.byte	"Ray Gay",0
	.byte	"Ray Czajka",0
	.byte	"Betty Purcell",0
	.word	0

********************************
* Text - destroyed akhboobs stuff, he escaped, you failed to enter pdomes

nopdometxt_s
	.byte	"Congratulations!",0
	.byte	" ",0
	.byte	"You have destroyed Akhboob's",0
	.byte	"army and his ability to",0
	.byte	"create more mutant life",0
	.byte	"forms.  You wrecked his",0
	.byte	"Bio-Nuclear facility,",0
	.byte	"airport, communications",0
	.byte	"system, weapons arsenal,",0
	.byte	"and his military vehicles.",0
	.byte	" ",0
	.byte	"You also saved hundreds",0
	.byte	"of hostages and recovered",0
	.byte	"billions of dollars worth",0
	.byte	"of stolen gems.",0
	.byte	"That is great news!",0
	.byte	" ",0
	.byte	"However, you allowed General",0
	.byte	"Akhboob to escape!",0
	.byte	" ",0
	.byte	"Being the DUFUS you are, you",0
	.byte	>80,"also failed to collect the 220",0
	.byte	>81,"also failed to collect the 200",0
	.byte	"keys required to join other",0
	.byte	"game heroes in the Midway",0
	.byte	"Pleasure Domes.",0
	.byte	"This is not good.",0
	.byte	" ",0
	.byte	"Ahkboob lives...",0
	.byte	" ",0
	.byte	"No pleasure for you today...",0
	.byte	" ",0
	.byte	"Thank you for playing!",0
	.word	0

********************************
* Text - destroyed akhboobs stuff and akhboob, failed to enter pdomes

nopdometxt2_s
	.byte	"Congratulations!",0
	.byte	" ",0
	.byte	"You fried the hell out of",0
	.byte	"that jerk!  Great job!",0
	.byte	" ",0
	.byte	"You have destroyed Akhboob's",0
	.byte	"army and his ability to",0
	.byte	"create more mutant life",0
	.byte	"forms.  You blew up his",0
	.byte	"Bio-Nuclear facility,",0
	.byte	"airport, communications,",0
	.byte	"and weapons arsenal.  You",0
	.byte	"saved hundreds of lives!",0
	.byte	"You are a stud game player.",0
	.byte	" ",0
	.byte	"However, the real goal of",0
	.byte	"this game is to join the",0
	.byte	"heroes from Smash T.V. in",0
	.byte	"the Midway Pleasure Domes.",0
	.byte	>80,"You must collect 220 keys",0
	.byte	>81,"You must collect 200 keys",0
	.byte	"to gain entrance.",0
	.byte	"You failed to do this.",0
	.byte	" ",0
	.byte	"You suck.",0
	.byte	" ",0
	.byte	"Thank you for playing!",0
	.word	0




	.end
