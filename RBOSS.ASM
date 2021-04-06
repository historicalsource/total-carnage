**************************************************************
*
* Orcus software:	Eugene Jarvis, Shawn Liptak
* Initiated:		7/12/91 from RBOSS SMASH TV
*
* Modified:		Shawn Liptak, 9/25/91	-Started big fix
* 			Shawn Liptak, 11/7/91	-Done??
*
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 1/13/92 19:04
**************************************************************
	.TITLE	'Orcus'
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

;Symbols externally defined

	.ref	SUCIDE,GANIOF,BEGINOBJ2,GAMSTATE
	.ref	PLYROBJS,PLYRPRCS,P1DATA,P2DATA,WAVE,STATUS
	.ref	FLASHME,KILALL,KILL
	.ref	SCRADD2,BONE,HEXTOASC
	.ref	FRANIM,FRANIMQ,GETFPAL,HALT
	.ref	RD15FONT,WRLD,STRCNRMO,STRLNRMO
	.ref	CYCLE_TABLE,START_PJ,DOIT
	.ref	FLMUP1,FLMUP2,FLMUP3,FLMUP4,FLMUP5
	.ref	RNDRNGS,RNDRNG
	.ref	NOSHOOT,FLMUP6
	.ref	RUN_AWAY
	.ref	BLUEEXP,FIREEXP,XBOOM2,BOOM3,BURST
	.ref	ONESND,ONESNDOVR
	.ref	SHAKER,OUT_FLG
	.ref	getcloseplyr
	.ref	YZSORT
	.ref	LIMO,TRY_RCK,PCNT,ICONS_DN
	.ref	aud_addnumplyrs
	.ref	ABOOBJUMP

;Symbols defined in this file

	.def	bossd_t
	.def	ORCHINT		;Image
	.DEF	bloflg

;Sound headers

	.ref	LOVEIT

musicsnd	.word	>f3fe,10,>8009,0	;Boss music
gscottsnd	.word	>f9f7,16,>814b,0	;Great scott
landsnd		.word	>fc88,30,>8030,0	;Land from a jump
laughsnd	.word	>f194,30,>80f2,0	;When plyr dies
exp1snd		.word	>fc80,7,>803e,0		;Explosion
exp2snd		.word	>fd80,10,>80d9,0	;^
;pain1snd	.word	>f985,20,>80f6,0	;
;pain2snd	.word	>f985,20,>80f9,0	;
groansnd	.word	>f985,20,>8113,0	;Groan
groanlndsnd	.word	>f185,20,>8113,0	;^ interruptable
oofsnd		.word	>f985,20,>8114,0	;Oof
yowl1snd	.word	>f985,30,>8115,0	;
yowl2snd	.word	>f985,30,>8116,0	;
roarsnd		.word	>f990,40,>8117,0	;Roar
roarlongsnd	.word	>f990,120,>8117,0	;Roar
houchsnd	.word	>f985,20,>8120,0	;
hyowlsnd	.word	>f985,20,>8122,0	;
stvpainsnd	.word	>f985,30,>8123,0	;
bubl1snd 	.word	>f5e5,20,>8131,0	;Blood bubbling
bubl2snd	.word	>f0e5,20,>8130,0	;^

myeyesnd	.word	>f9e0,110,>8118,0	;
myarmsnd	.word	>f9e0,120,>8119,0	;
myheadsnd	.word	>f9e0,70,>8121,0	;

msllnchsnd	.word	>f290,10,>80b9,0	;Missile launch
;msllnchsnd	.word	>f290,10,>80b6,0	;Missile launch
mslexpsnd	.word	>f470,10,>8048,0	;Missile explosion
tungsnd		.word	>f290,10,>80b6,0	;Tongue launch
youwillsnd	.word	>f9f7,32,>8153,0	;


;Process subtypes

SUBLGUN		.equ	1	;Left gun controller
SUBRGUN		.equ	2	;Right gun controller
SUBTHRST	.equ	3	;Thrust
SUBNOSEF	.equ	4	;Nose flamers
SUBANI		.equ	5	;Eye/mouth animation
SUBWEAPON	.equ	9	;Missile/tongue launcher
SUBBOSSHALT	.equ	>80	;Halts boss processes

ZACC	.equ	>1000	;z accel constant

;Ram allocation for orcus
	.bss	bossram,0
	.bss	bossjmphi,16	;!0=In high jump (Must preceed bossd_t)
	.bss	bossd_t,25*16*4	;Boss object data structure

	.bss	bossxv,32	;XV
	.bss	bossyv,32	;YV
	.bss	bosszv,32	;Z velocity
	.bss	bossz,32	;Z pos (height)

	.bss	hdani_p,32	;*Head animation process or 0
	.bss	iani_p,32	;*Eye animation process or 0
	.bss	mani_p,32	;*Mouth animation process or 0
	.bss	armani_p,32	;*Arm animation process or 0

				;*Must stay in order!!!
;ARMSTAT	.equ	0
GUNDIR	.equ	>10
GUNMODE	.equ	>20
GUNSWP	.equ	>30
GUNNUM	.equ	>40
GUNBLOW	.equ	>50

	.bss	larmdata,0	;
	.bss	larmstat,16	;LArm status:-=Gone, 0=OK, 1=On fire
				; 2=Exploding, 3=Stump
	.bss	lgundir,16	;LGun direction 0-5
	.bss	lgunmode,16	;LGun shooting mode 0-7
	.bss	lgswflg,16	;LGun sweep direction flag 0=Down, !0=Up
	.bss	lgunnum,16	;Gun # (0)
	.bss	lgunblow,16	;LGun ready to blow: 0=No, !0=Yes
	.bss	rarmdata,0	;
	.bss	rarmstat,16	;RArm same as ^
	.bss	rgundir,16	;^
	.bss	rgunmode,16	;^
	.bss	rgswflg,16	;^
	.bss	rgunnum,16	;Gun # (1)
	.bss	rgunblow,16	;^

	.bss	hdstat,16	;!0=Head blown off
	.bss	shldrstat,16	;!0=Shoulders blow off and # hits for big blow
	.bss	leyestat,16	;!0=L eye blown out
	.bss	reyestat,16	;!0=R eye blown out
	.bss	bodystat,16	;!0=Everything blown out

	.bss	bossmode,16	;Boss mode, -=Firing, 0=Stationary, +=Hopping
	.bss	bmtimer,16	;Boss mode timer
	.bss	bloflg,16	;-=Blow on; 0=No blow, +=Blow on but weapons OK
	.bss	bflmrstat,16	;!0=Flamer on
	.bss	bossramend,0

BOSSJMPHI	.set	-16	;Offset from bossd_t

;Boss data struct

BOOBJ	.set	>0	;*Parts obj
BODAMR	.set	>20	;Damage resistance (0-?)
BOAFRM	.set	>28	;Current animation frame
BODAM	.set	>30	;Damage
*>040=IMAGE 1 ETC.

AX	.equ	43	;Ani point offsets
AY	.equ	-84


	.bss	bombtotal,16	;Total bombs at start of boss


********************************
* Orcus boss monster (Process)

 SUBR	BOSS

;	movi	musicsnd,a0
;	calla	ONESND
	movi	roarlongsnd,a0
	calla	ONESNDOVR

	SLEEPK	30
	clr	a0			;>Clear out boss variables
	movi	bossram,a1
bossclr	move	a0,*a1+
	cmpi	bossramend,a1
	jrlo	bossclr

	move	@GAMSTATE,a0
	cmpi	INAMODE,a0
	jreq	bi100

	movk	AUDBOSS1,a0
	calla	aud_addnumplyrs

bi100	move	@P1DATA+BMBSUSED,a0
	move	@P2DATA+BMBSUSED,a1
	add	a0,a1
	move	a1,@bombtotal		;For bomb message

	movk	1,a0
	move	a0,@lgundir		;Init LR gun angles down
	move	a0,@rgundir
	move	a0,@rarmdata+GUNNUM

	move	@WORLDTLX+16,a0		;Get starting coord
	addi	200,a0
	sll	16,a0
	move	@WORLDTLY+16,a1
	subi	150,a1			;Y Off screen
	sll	16,a1
	clr	a11			;Damage level
	callr	boss_init		;Initialize

	movi	bossd_t,a8		;A8=*Boss data struct

	CREATE	BOSSPID,cycle_eye
	CREATE	BOSSPID|SUBNOSEF,nose_flamers
	movi	larmdata,a11
	CREATE	BOSSPID|SUBLGUN,gun
	movi	rarmdata,a11
	CREATE	BOSSPID|SUBRGUN,gun
	CREATE	BOSSPID|SUBWEAPON,weapon_launcher
	CREATE	BOSSPID|SUBBOSSHALT,boss_halter

	callr	bossjump_center
	movi	60*15,a2		;No blows for awhile
;TURMELL
;	movi	60*17,a2		;No blows for awhile
	callr	set_bloflg
	SLEEPK	2
	CREATE0	gscott_snd
	movi	60*3,a0
	jruc	b30

					;** A8 Must not be trashed!!
bosslp
	move	@PCNT,a0
	sll	32-6,a0
	jrnz	bl15
	movi	>8140,a1
	move	@PLYRPRCS,a0,L
	jrz	bl10
	move	*a0(LEG_PRC),a0,L
	move	a1,*a0(SHOECNT)		;Always with shoes
bl10	move	@PLYRPRCS+32,a0,L
	jrz	bl15
	move	*a0(LEG_PRC),a0,L
	move	a1,*a0(SHOECNT)

bl15	move	@bossmode,a0
	jrnz	b50

	move	@bmtimer,a0		;>Boss main loop
	subk	1,a0
	move	a0,@bmtimer
	jrge	b50			;Same mode?

	movk	>f,a0			;>New Mode
	callr	rnd
	sll	3,a0			;*8
	addi	bossmode_t,a0
	movb	*a0,a0
	move	a0,@bossmode
	movi	220,a0
	callr	rndrng0
	addi	60,a0
b30	move	a0,@bmtimer		;Set new time


b50	move	@bodystat,a0
	jrnz	b1000			;Totally blown?

	move	@HALT,a0
	jrz	b100			;No halt?
	clr	a0
	move	a0,@bossxv,L
	move	a0,@bossyv,L
	move	a0,@bosszv,L
	jruc	b1300



b100	move	@iani_p,a0,L		;>Big eyes
	jrnz	b200			;Animating?

	movi	eyequad_t,a9		;>Follow player
	clr	a0			;X offset
	movi	80,a1			;Y offset
	callr	bossseekp_ani32
	callr	aniboss



b200	move	@hdstat,a0		;>Little head
	jrnz	b400			;Head blown?
	move	@hdani_p,a0,L
	jrnz	b400			;Animating?

	move	@PLYRPRCS,a0,L
	jrz	b220
	move	*a0(DEAD),a0
	jrnz	b260			;P1 dead?
b220	move	@PLYRPRCS+32,a0,L
	jrz	b300
	move	*a0(DEAD),a0
	jrz	b300			;P2 alive?
b260	move	a8,a6
	movi	grinner,a8		;Smile
	movi	hdani_p,a11
	CREATE	BOSSPID|SUBANI,aniseqq
	move	a6,a8
	movi	laughsnd,a0
	calla	ONESND

b300
	movi	hdquad_t,a9		;>Follow player
	clr	a0			;X offset
	movi	80,a1			;Y offset
	callr	bossseekp_ani32
	callr	aniboss



b400	move	@mani_p,a0,L		;>Mouth and tongue
	jrnz	b450
	movk	2,a0			;33%
	callr	rndrng0
	move	a0,a0
	jrnz	b450
	movi	mouthrnd_t,a1
	movi	mani_p,a2
	callr	ani_rnd



b450	movi	99,a0			;>1% New gun mode
	callr	rndrng0
	move	a0,a0
	jrnz	b500
	movk	7,a0
	callr	rndrng0
	move	a0,@lgunmode
	movk	7,a0
	callr	rndrng0
	move	a0,@rgunmode


**** Jump setup code

b500	move	@bossz,a0,L
	jrnz	b1000			;Jump in progress?
	move	@bflmrstat,a0
	jrnz	b1000			;Flamers on?
	move	@bossmode,a0
	jrn	b1000			;Firing?

	move	*a8,a0,L
	move	*a0(OYPOS),a2
	subk	25,a2
	movk	1,a0
	callr	rnd
	jrz	b530			;Skip P1? So we don't pick on P1
	move	@PLYROBJS,a0,L
	jrz	b530
	move	*a0(OYPOS),a1
	cmp	a2,a1
	jrlt	b540			;P1 Y < OrcY?
b530	move	@PLYROBJS+32,a0,L
	jrz	b570
	move	*a0(OYPOS),a1
	cmp	a2,a1
	jrge	b570			;P2 Y >= OrcY?
b540	movk	4,a0			;Short jmps
	move	a0,@bossmode

b570	move	@WORLDTLX+16,a4		;A4=World X
	move	@WORLDTLY+16,a5		;A5=World Y
	callr	boss_scrntst
	jrz	b600			;On screen?
	movk	1,a0			;Jmp rnd
	move	a0,@bossmode
	jruc	b750


b600	move	@bossmode,a0
	jrle	b1000			;Fire or sit still mode?
	cmpi	4,a0			;>Short jmp
	jrne	b650
	clr	a0			;X offset
	movi	80,a1			;Y offset
	callr	boss_getcloseplyr
	jrz	b1000
	movi	75,a2
	movi	ZACC/2/2,a3
b630	move	*a0(OYPOS),a1		;Get plyr XY
	move	*a0(OXPOS),a0
	callr	bossjump_zacc		;Jump!
	jruc	b1000

b650	cmpi	6,a0			;>Big jump
	jrne	b670
	movi	roarsnd,a0
	calla	ONESND
	clr	a0			;X offset
	movi	80,a1			;Y offset
	callr	boss_getcloseplyr
	movi	180,a2
	movi	ZACC/2,a3
	move	a0,a0
	jrnz	b630
	jruc	b1000


b670	subk	5,a0
	jrne	b750

	movi	yowl1snd,a0
	calla	ONESND

	movi	60,a0			;>Jump on plyr
	callr	rndrng0
	subk	30,a0
	move	a0,a6			;X offset +/-30

	movi	30,a0
	callr	rndrng0
	subk	15,a0
	move	a0,a7			;Y offset

	callr	getplyr
	jrz	b750			;No player?
	move	*a0(OYPOS),a1		;Get plyr XY
	move	*a0(OXPOS),a0
	add	a6,a0			;Add in offset
	add	a7,a1
	sub	a4,a0			;>Check bounds
	sub	a5,a1
	cmpi	25,a0			;XMin
	jrge	b680
	movk	25,a0
b680	cmpi	370,a0			;XMax
	jrle	b690
	movi	370,a0
b690	cmpi	-10,a1			;YMin
	jrge	b700
	movi	-10,a1
b700	cmpi	180,a1			;YMax
	jrle	b800
	movi	180,a1
	jruc	b800


b750	movi	129,a0
	callr	rndrng0
	addi	45,a0
	move	a0,a2
	movi	249,a0
	callr	rndrng0
	addi	75,a0			;Rnd X dest
	move	a2,a1			;Rnd Y dest

	move	@bossmode,a3
	subk	2,a3			;2=Jump rnd X
	jrne	b790
	movk	10,a1			;Y dest
	movi	60*4,a2
	move	a2,@bmtimer		;Sit at top for tongues
b790	subk	1,a3			;3=Jump rnd Y
	jrne	b800
	movi	200,a0			;X dest

b800	add	a4,a0			;Add in world XY
	add	a5,a1
	movi	100,a2
	callr	bossjump		;Jump!


b1000
	move	@bossz,a2,L		;>Update Z height
	jrle	b1300			;No Z?
	move	a2,a3
	move	@bosszv,a0,L
	subi	ZACC,a0
	move	a0,@bosszv,L
	add	a0,a2			;A2=Z+ZV
	jrgt	b1200			;In air?

	sub	a2,a0			;>Land
	move	a0,a4
	move	*a8(BOSSJMPHI),a0
	jrz	b1100
	callr	boss_setlow
b1100	movk	20,a10
	calla	SHAKER
	movi	landsnd,a0
	calla	ONESND
	movi	groanlndsnd,a0
	calla	ONESND
	move	@bossmode,a0
	subk	5,a0
	jrne	b1120			;!Sml jmp?
	movk	5,a0			;17%
	callr	rndrng0
	move	a0,a0
	jrnz	b1130			;Keep jumping?
b1120	clr	a0
	move	a0,@bossmode		;Sit still
b1130	move	a4,a0
	clr	a2
	move	a2,@bosszv,L
	move	a2,@bossxv,L
	move	a2,@bossyv,L
	move	a2,*a8(BOSSJMPHI)

b1200	move	a2,@bossz,L
	callr	vel_setz
	move	*a8(BOSSJMPHI),a0
	jrnz	b1300			;High?
	srl	16,a2
	subk	16,a2			;0-15 Z is low
	jrlt	b1300			;Too low?
	callr	boss_sethi
	movk	1,a0
	move	a0,*a8(BOSSJMPHI)

b1300	move	@bossxv,a0,L
	move	@bossyv,a1,L
	callr	vel_set
	SLOOP	1,bosslp


;Boss mode table
;0=Sit still, 1=Rnd jump, 2=Jmp X rnd Y top, 3=Jmp X center Y rnd
;4=Small jmp at plyr, 5=Jmp at plyr, 6=BigJmp
;7=Center jmp (blow)
bossmode_t
	.byte	0,0,0,1,2,2,3,3,4,4,4,5,5,5,6,6


********************************
* Boss jump to screen center
* Trashes A0-A2

 SUBRP	bossjump_center

	PUSH	a7
	CREATE	BOSSPID,bossjump_center2
	PULL	a7
	rets


bjc2	SLEEPK	1

 SUBRP	bossjump_center2

	move	@bossz,a0,L
	jrnz	bjc2			;Jump in progress?
	move	@bflmrstat,a0
	jrnz	bjc2			;Flamers on?

	movk	7,a0
	move	a0,@bossmode

	move	@WORLDTLX+16,a0
	move	@WORLDTLY+16,a1
	addi	200,a0
	addi	100,a1
	movi	100,a2			;Time
	movi	SUCIDE,a3
	move	a3,-*sp,L		;We'll DIE

********************************
* Boss jump
* A0=DestX
* A1=DestY
* A2=Time
* Trashes A3

 SUBRP	bossjump

	movi	ZACC/2,a3


********************************
* Boss jump with custom ZACC
* A0=DestX
* A1=DestY
* A2=Time
* A3=ZACC

 SUBRP	bossjump_zacc

	PUSH	a2,a4,a7,a8,a10
	move	@bossd_t,a8,L		;A8=*1st obj

	move	*a8(OYPOS),a4
	sub	a4,a1
	sll	16,a1
	divs	a2,a1			;YV
	move	a1,@bossyv,L

	move	a0,a1
	move	*a8(OXPOS),a4
	addi	AX,a4			;X center
	sub	a4,a1
	sll	16,a1
	divs	a2,a1			;XV
	move	a1,@bossxv,L

	move	a3,a1
	mpys	a2,a1			;ZV
	move	a1,@bosszv,L
	movk	1,a0
	move	a0,@bossz,L

	movi	BOSSPID|SUBTHRST,a0	;Kill thrusters
	calla	KIL1C
	movk	4,a10
	CREATE	BOSSPID|SUBTHRST,thrusters_fire

	PULL	a2,a4,a7,a8,a10
	rets


********************************
* Do great scott sound (Process)

 SUBRP	gscott_snd

	SLEEP	50
	movi	gscottsnd,a0
	calla	ONESND
	DIE


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
* Part of boss monster takes a hit
* A0=*Obj that hit
* A8=*Boss obj

 SUBR	orcus_hit

	mmtm	sp,a1,a2,a3,a4,a5,a6,a7,a9,a10,a11

	movk	1,a1
	move	a1,@OUT_FLG		;Stop scan

	move	@bodystat,a1
	jrnz	ohx			;All blown?

	move	a0,a11			;A11=*Obj that hit
	move	*a11(OID),a10		;Get subtype
	sll	32-3,a10
	srl	32-3-4,a10		;*16
	jrz	oh100			;Bomb?
	move	@shldrstat,a1
	jrz	oh100			;All blown?
	move	@bloflg,a0
	jrn	oh100			;Blow in progress?
	callr	bosshit_big

oh100	move	*a11(OXVEL),a1,L
	move	*a11(OYVEL),a2,L
	addi	buldat_t,a10		;A10=*Data_t
	move	*a10,a9			;>Push back
	sra	a9,a1
	sra	a9,a2
	callr	boss_addxy

	move	*a10,a0			;>Shake
	addk	10,a0
	callr	boss_addrndxy

	movk	3,a0			;75%
	callr	rnd
	jrnz	ohx			;No damage?

	movi	>1f1f0000,a9
	CREATE0	FLASHME

	move	*a8(OPLINK),a9,L	;A9=*Obj data struct
	move	*a10(>80),a2		;A2=Weapon damage
	jrnn	oh140			;!Bomb?
	movk	1,a0
	callr	rnd
	move	a0,a2			;Bomb damage 0 or 1
oh140	movb	*a9(BODAMR),a0
	jrz	oh150
	addk	1,a2
	srl	a0,a2			;Shift damage down
oh150	callr	damage_react
	move	*a9(BODAM),a3		;A3=Damage
	add	a2,a3
	move	a2,a4
	callr	boss_chknblowpart	;Check for special destruction


	move	@bloflg,a0		;>Damage correct part for stupid plyrs
	jrnz	oh400			;Blow or lockout in progress?

	movk	7,a0			;13%
	callr	rnd
	jrnz	oh400			;Skip xfer?

	move	@larmstat,a0
	subk	3,a0
	jrlo	oh400			;!Stump?
	move	@rarmstat,a0
	subk	3,a0
	jrlo	oh400			;!Stump?

	movi	9*>40,a1		;Part 10
	move	@larmstat,a0
	jrnn	oh300

	movi	10*>40,a1		;Part 11
	move	@rarmstat,a0
	jrnn	oh300

	movi	4*>40,a1		;Part 5
	move	@leyestat,a0
	jrz	oh300			;LEye OK?

	movi	5*>40,a1		;Part 6
	move	@reyestat,a0
	jrz	oh300			;REye OK?

	movi	8*>40,a1		;Part 9
	move	@hdstat,a0
	jrz	oh300			;Head OK?

	movi	6*>40,a1		;Part 7
	move	@shldrstat,a0
	jrnz	oh400			;Top blown?

oh300	addi	bossd_t,a1
	cmp	a1,a9
	jreq	oh400			;Same part?

	move	*a1(BODAM),a0
	add	a4,a0
	cmpi	48,a0
	jrhs	oh350			;Maxed?
	PUSH	a3,a8,a9
	move	*a1,a8,L		;Get obj
	move	a1,a9
	move	a0,a3			;A3=Damage
	callr	boss_chknblowpart	;Check for special destruction
	move	a4,a2
	callr	damage_set
	PULL	a3,a8,a9
oh350

oh400	move	a4,a2
	cmpi	47,a3
	jrls	oh500			;!Maxed?
	callr	damage_xfer		;Xfer damage to other parts!
	movi	47,a3
oh500	callr	damage_set

	move	*a10(>80),a1		;Get score
	abs	a1
	callr	boss_scorehit

ohx	mmfm	sp,a1,a2,a3,a4,a5,a6,a7,a9,a10,a11
	rets

; Bullet subtype data table
;SUBLZR		1	;Regular shots
;SUBSPRY	2	;Spray
;SUBFIRE1	3	;Flame thrower
;SUBGRND	4	;Arcing balls
;SUBNOSTP	5	;Non-stopping rockets
;SUBSPDG1	6	;Fast blue balls
buldat_t
	.word	-2,-3,-3,-3, 0, 0,-2,0		;Shift count
	.word	-1, 1, 1, 3, 4, 3, 1,0		;Damage/score


********************************
* Make pieces from where boss is hit
* A11=*Obj that hit
* Trashes A0-A7,A9

 SUBRP	bosshit_big

	PUSH	a8,a11

	movk	3,a0
	callr	rnd
	sll	5,a0			;*32
	addi	bigpain_t,a0
	move	*a0,a0,L
	calla	ONESND

	movi	t72blst_l,a9

	move	*a11(OXVEL),a6,L
	move	*a11(OYVEL),a7,L

	move	*a11(OXPOS),a0
	move	*a11(OSIZEX),a2
	srl	1,a2			;/2
	add	a2,a0
	move	*a11(OYPOS),a1
	move	*a11(OSIZEY),a2
	srl	1,a2			;/2
	add	a2,a1
	subk	22,a1
	sll	16,a0			;X
	sll	16,a1			;Y
	movi	T72BLAST1,a2
	move	*a11(OZPOS),a3
	addk	30,a3
	movi	DMAWNZ+M_NOCOLL,a4	;No collisions
	movi	CLSDEAD,a5

	PUSH	a0,a1,a7
	calla	BEGINOBJ2
	CREATE	BOSSPID,FRQDELDIE
	PULL	a0,a1,a7

	sll	1,a6			;*2
	sll	1,a7
	calla	BEGINOBJ2
	CREATE	BOSSPID,FRQDELDIE

	PULL	a8,a11
	rets

t72blst_l
	LW	T72BLAST2,2
	LW	T72BLAST3,4
	LW	T72BLAST4,4
	LW	T72BLAST5,4
	LW	T72BLAST6,4
	LW	T72BLAST7,4
	LWL0	T72BLAST8,4

bigpain_t
	.long	yowl1snd,yowl2snd,roarsnd,stvpainsnd


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
* Heads react to damage
* A2=New damage

 SUBRP	damage_react

	cmpi	2,a2
	jrhs	damage_react2		;Always pain?
	movk	>f,a0			;6%
	callr	rnd
	jrnz	drxx

 SUBRP	damage_react2

	mmtm	sp,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11

	movk	4,a0			;>Random pain
	move	@hdstat,a1
	jrnz	dr1			;Head blown?
	movk	6,a0
dr1	callr	rndrng0
	sll	5,a0			;*32
	addi	painsnd_t,a0
	move	*a0,a0,L
	calla	ONESND

	move	@hdstat,a0		;>Lil head pain
	jrnz	dr5			;Head blown?
	movi	hdani_p,a2
	move	*a2,a0,L
	jrz	dr2			;Head inactive?
	calla	KILL
	clr	a0
	move	a0,*a2,L
dr2	movi	hddam_t,a1
	callr	randseq			;Start new ani

dr5	move	@bodystat,a0
	jrnz	drx			;Body blown?
	movi	iani_p,a2		;>Big eyes pain
	move	*a2,a0,L
	jrz	dr50			;Eye inactive?
	calla	KILL
	clr	a0
	move	a0,*a2,L
dr50	movi	eyedam_t,a1
	callr	randseq			;Start new ani

drx	mmfm	sp,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11
drxx	rets


painsnd_t
	.long	groansnd,oofsnd,yowl1snd,yowl2snd
	.long	stvpainsnd,houchsnd,hyowlsnd


********************************
* Check a hit part for special damage or explosions
* A3=Damage
* A8=*Boss object hit
* A9=*Boss data struct for part
* A11=*Bullet obj
* Trashes A0-A2
* >A3=Damage

 SUBRP	boss_chknblowpart

	move	@bloflg,a0
	jrnz	ckbx				;Blow or lockout in progress?

	movb	*a8(OID),a1
	cmpi	SUBHD,a1
	jrlo	ckb100				;Nothing special?

	cmpi	SUBARML,a1			;>L arm blow ?
	jrne	ckb10
	move	@larmstat,a0
	jrnn	lftarmblo			;Damage it?
	jruc	ckb100

ckb10	cmpi	SUBARMR,a1			;>R arm blow?
	jrne	ckb20
	move	@rarmstat,a0
	jrnn	rtarmblo			;Damage it?
	jruc	ckb100


ckb20	move	@larmstat,a0
	jrnn	ckbx0				;LArm still there?
	move	@rarmstat,a0
	jrnn	ckbx0				;RArm ^

	cmpi	SUBMTHL,a1			;>Mouth not damaged until arms
	jreq	ckb100
	cmpi	SUBMTHR,a1
	jreq	ckb100

	cmpi	SUBEL,a1			;>L eye
	jrne	ckb30
	move	@leyestat,a0
	jrz	lfteyeblo
	jruc	ckb100

ckb30	cmpi	SUBER,a1			;>R eye
	jrne	ckb40
	move	@reyestat,a0
	jrz	rteyeblo
	jruc	ckb100


ckb40	move	@leyestat,a0
	jrz	ckbx0				;LEye OK?
	move	@reyestat,a0
	jrz	ckbx0				;REye OK?

	cmpi	SUBHD,a1
	jrne	ckb50				;!Head?
	cmpi	32,a3				;32 or higher=destroyed
	jrlo	ckb100
	move	@hdstat,a0
	jrz	head_startblow			;Destroy?
	jruc	ckb100


ckb50	move	@hdstat,a0
	jrz	ckbx0				;Head OK?

	cmpi	SUBSHLDL,a1
	jreq	ckb60				;Shoulder?
	cmpi	SUBSHLDR,a1
	jrne	ckb100
ckb60	cmpi	32,a3				;32 or higher=destroyed
	jrlo	ckb100
	move	@shldrstat,a0
	jrz	shldr_startblow			;Blow shoulders?

ckb100	move	@shldrstat,a0
	jrz	ckbx				;Top OK?
	subk	1,a0				;-1 hit for blow
	jrle	body_startblow			;Wasted?
	move	a0,@shldrstat
ckbx	rets

ckbx0	clr	a3				;Reset damage
	rets


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
* Blow left or right arm
* A3=Damage
* A8=*Arm object
* A9=*Boss data struct for part
* A11=*Bullet obj
* >A3=New damage value

lftarmblo
	PUSH	a7,a9,a10,a11
	movi	larmdata,a10
	jruc	lrab20

rtarmblo
	PUSH	a7,a9,a10,a11
	movi	rarmdata,a10

lrab20	cmpi	16,a3
	jrlo	lrab200			;Working?
	move	*a10,a1			;Get status
	jrgt	lrab70
					;>Start a fire!
	CREATE	BOSSPID,arm_burnblow
	callr	damage_react2		;Pain!

	clr	a3			;Set damage zero
	movk	1,a2			;Burn status
	jruc	lrab150

lrab70	subk	1,a1
	jrgt	lrab500			;!Burning?
	movk	2,a2			;Explode status
	movk	15,a3
lrab100	move	*a10(GUNBLOW),a0
	jrz	lrab200			;Can't blow?
;	clr	a0
;	move	a0,*a10(GUNBLOW)	;Clr it
	movi	>1500,a1
	callr	boss_scorebonusword
	movi	-1,a1
	move	a1,@bloflg
lrab150	move	a2,*a10			;Set status
lrab200	PULL	a7,a9,a10,a11
	rets

lrab500	cmpi	32,a3
	jrlo	lrab200			;Stump ok?
	movi	-1,a2			;Gone status
;	movk	31,a3
	jruc	lrab100


********************************
* Arm destruction sequence (Process)
* A8=*Arm object
* A9=*Boss data struct for part
* A10=*Arm data struct

 SUBRP	arm_burnblow

	PUSHP	a9
	move	a10,a11			;A11=*Arm data struct

	clr	a9
	CREATE	BOSSPID,arm_1gunflame
	SLEEP	120
	CREATE	BOSSPID,arm_1gunflame
	SLEEP	120
	movi	192,a9
	CREATE	BOSSPID,arm_1gunflame
	movi	192*2,a9
	CREATE	BOSSPID,arm_1gunflame
	SLEEP	60*27

	movi	BOSSPID|SUBLGUN,a0
	move	*a11(GUNNUM),a1
	jrz	abn60
	movi	BOSSPID|SUBRGUN,a0
abn60	calla	KIL1C			;Kill gun process


	clr	a9			;>Random gun movement
	move	*a11(GUNNUM),a1
	jrz	abn100
	movk	6,a9
abn100	movk	5,a10
	JSRP	gun_seek

	movk	1,a0
	move	a0,*a11(GUNBLOW)	;We can blow

abn110	SLEEPK	3
	movk	>1f,a0
	callr	rnd
	jrnz	abn120
	movk	5,a10
	JSRP	gun_seek
	movk	3,a0
	callr	rnd
	addk	2,a0
	move	a0,a10
	JSRP	gun_seek
abn120	move	*a11,a0			;Get status
	subk	1,a0
	jreq	abn110			;Still on fire?


	callr	bossjump_center
	movi	myarmsnd,a0
	calla	ONESNDOVR

	movk	3,a5
abn300	PUSHP	a5
	movk	1,a6
	JSRP	gun_blow
	movk	19,a0
	callr	rndrng0
	addk	10,a0
	calla	PRCSLP
	PULLP	a5
	dsj	a5,abn300

	movk	10,a6
	JSRP	gun_blow
	SLEEP	45
	movi	myarmsnd,a0
	calla	ONESNDOVR
	movk	30,a6
	JSRP	gun_blow
	SLEEPK	30
	movi	60,a6
	JSRP	gun_blow
	movi	myarmsnd,a0
	calla	ONESNDOVR
	movi	120,a6
	JSRP	gun_blow


	movk	3,a0			;Stump status
	move	a0,*a11
	move	*a12,a9,L
	movk	16,a3
	callr	damage_setalways	;Show stump
	movk	1,a0
	move	a0,@bloflg		;Enable weapons


	movi	60*3,a6
abn500	move	a11,a5			;>Stump bleeds
	movi	blooddn_t,a9
	movi	68,a0
	move	*a11(GUNNUM),a1
	callr	boss_getanipt
	addi	53,a11			;Y
	CREATE	BOSSPID,mk_objbvfranim
	move	a6,a9
	move	a5,a11
	SLEEPK	1
	move	a9,a6
	dsj	a6,abn500

	SLEEP	60*10
	clr	a0
	move	a0,@bloflg		;Let blows continue


abn550	SLEEPK	1
	move	*a11,a0			;Get status
	jrnn	abn550			;Stump ok?

	callr	bossjump_center
	movi	myarmsnd,a0
	calla	ONESNDOVR

	movi	60*5,a6			;>Blow off stumps
abn600	move	a11,a5
	movi	armripl_t,a9
	clr	a0
	move	*a11(GUNNUM),a1
	jrz	abn620
	movi	armripr_t,a9
abn620	callr	boss_getanipt
	addk	1,a11			;Y
	CREATE	BOSSPID,mk_objfranim
	move	a6,a9
	move	a5,a11
	SLEEPK	1
	move	a9,a6
	cmpi	60*3,a6
	jreq	abn640
	cmpi	60*1,a6
	jrne	abn650
abn640	movi	myarmsnd,a0
	calla	ONESNDOVR
abn650	callr	damage_react2		;Pain!
	movi	exp1snd,a0
	calla	ONESND
	movi	exp2snd,a0
	calla	ONESND
	movk	8,a0
	callr	boss_addrndxy		;Shake!
	dsj	a6,abn600


	PULLP	a9
	movk	32,a3
	callr	damage_setalways	;Show null
	movk	1,a0
	move	a0,@bloflg		;Enable weapons
	move	*a8(OFLAGS),a0
	addi	M_NOCOLL,a0
	srl	4,a0			;Clr DMA bits
	sll	4,a0
	move	a0,*a8(OFLAGS)

	movi	60*3,a6
abn700	move	a11,a5
	movi	bloodl_t,a9		;>Shoulder bleeds
	movi	38,a0
	move	*a11(GUNNUM),a1
	jrz	abn720
	movi	bloodr_t,a9
abn720	callr	boss_getanipt
	subk	4,a10			;X
	addk	26,a11			;Y
	CREATE	BOSSPID,mk_objbvfranim
	move	a6,a9
	move	a5,a11
	SLEEPK	1
	move	a9,a6
	dsj	a6,abn700

	SLEEP	60*10
	clr	a0
	move	a0,@bloflg

	DIE


gunlexp_t
	.long	FIREEXP
	.word	187,->800,->100,->400,>400
gunrexp_t
	.long	FIREEXP
	.word	187,>100,>800,->400,>400
gunlexp2_t
	.long	XBOOM2
	.word	187,->800,0,->800,>800
gunrexp2_t
	.long	XBOOM2
	.word	187,0,>800,->800,>800

blooddn_t
	.long	bldclt_l
	.word	181,->110,>110,>30,>180

armripl_t
	.long	armripl_l
	.word	181,->a00,->200,->300,>300
armripr_t
	.long	armripr_l
	.word	181,>200,>a00,->300,>300
armripr_l
	LWW	ARMRIP,FLIPBITS+1,M_FLIPH
armripl_l
	LW	ARMRIP,15
	LWLW	OKBM1,NEWPALET+DELTAY+3,GRNBOOM,50
	LW	OKBM2,3
	LW	OKBM3,3
	LW	OKBM4,3
	LW	OKBM5,3
	LW	OKBM6,3
	LWL0	OKBM7,3

bloodl_t
	.long	bldclt_l
	.word	161,->200,->80,->100,>100
bloodr_t
	.long	bldclt_l
	.word	161,>80,>200,->100,>100

bldclt_l	;Oval blood spurt
	LW	bldclt1,4
	LW	bldclt2,4
	LW	bldclt3,4
	LW	bldclt4,4
	LW	bldclt5,4
	LW	bldclt6,4
	LW	bldclt7,4
	LWL0	bldclt8,4


********************************
* Flame on gun (Process)
* A9=XY table offset
* A11=*Arm data struct

	WORDPD	flamexyto	,0

 SUBRP	arm_1gunflame

	move	a9,*a13(flamexyto)

	clr	a0
	clr	a1
	movi	LFLM1,a2
	movi	185,a3			;Z
	movi	DMAWNZ+M_NOCOLL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2

a1gf20	movk	1,a10
	movi	lflm_l,a9

a1gf50	move	*a8(OFLAGS),a4
	dsj	a10,a1gf100
	movk	5,a0
	callr	rndrng0
	addk	2,a0
	move	a0,a10			;>Sleep 2-7
	move	*a9+,a1,L
	jrz	a1gf20			;End?
	calla	ANI

a1gf100	move	*a13(flamexyto),a0
	callr	arm_getcenter
	movk	1,a0
	callr	rnd
	add	a0,a2
	movk	1,a0
	callr	rnd
	add	a0,a3
	move	a8,a0
	sll	16,a2
	sll	16,a3
	calla	GANISAG
	SLEEPK	1
	move	*a11,a0			;Get status
	subk	2,a0
	jrls	a1gf50			;Burning or exploding?

	jauc	DELOBJDIE


lflm_l	.long	LFLM1,LFLM2,LFLM3,LFLM4,LFLM5,LFLM6,0



********************************
* Get center of gun
* A0=XY table offset
* A11=*Arm data struct
* >A2=Y
* >A3=X

 SUBRP	arm_getcenter

	move	*a11(GUNDIR),a2
	sll	5,a2			;*32
	addi	gunxy_t,a2
	add	a0,a2
	move	*a2+,a3			;XO
	move	*a2,a2			;YO
	move	*a11(GUNNUM),a0
	jrz	agc80
	neg	a3
agc80	move	@bossd_t,a0,L		;Get * 1st obj
	move	*a0(OXPOS),a1
	addi	AX+2,a1			;+Ani pt X offset
	add	a1,a3
	move	*a0(OYPOS),a1
	addi	AY,a1			;+Ani pt Y offset
	add	a1,a2
	rets

gunxy_t
	.word	-62,35, -66,41, -70,35, -74,36
	.word	-73,29, -77,26
	.word	-60,41, -66,47, -72,41, -78,40
	.word	-79,31, -85,26
	.word	-58,47, -66,53, -74,47, -82,44
	.word	-85,33, -93,26



********************************
* Get ani point of boss plus X offset
* A0=X offset to right
* A1=Side: 0=Left, !0=Right
* >A10=X
* >A11=Y

 SUBRP	boss_getanipt

	move	a1,a1
	jrnz	bgap50			;Right?
	neg	a0			;Left
bgap50	move	@bossd_t,a11,L		;Get * 1st obj
	move	*a11(OXPOS),a10
	addi	AX+2,a10		;+Ani pt X offset
	add	a0,a10
	move	*a11(OYPOS),a11
	addi	AY,a11			;+Ani pt Y offset
	rets


********************************
* Shoot explosions and chunks from gun
* A6=# Loops
* A8=*Arm object
* A11=*Arm data struct

 SUBRP	gun_blow

	movi	stvpainsnd,a0
	calla	ONESND
	callr	damage_react2		;Pain!

gb200	clr	a0
	callr	arm_getcenter
	movi	gunlexp_t,a9
	movi	gunlexp2_t,a4
	move	*a11(GUNNUM),a0
	jrz	gb240
	movi	gunrexp_t,a9
	movi	gunrexp2_t,a4
gb240	move	a11,a5
	move	a3,a10
	move	a2,a11
	addi	54,a11			;Y
	CREATE	BOSSPID,mk_objfranim
	btst	0,a6
	jrz	gb260
	move	a4,a9
	CREATE	BOSSPID,mk_objfranim
	movi	exp1snd,a0
	calla	ONESND
	movi	exp2snd,a0
	calla	ONESND
gb260	move	a5,a11

	movk	>f,a0
	and	a6,a0
	jrnz	gb300			;Skip piece?
	CREATE	BOSSPID,gun_piece
gb300	move	a6,a9
	SLEEPK	1
	move	a9,a6
	movk	8,a0
	callr	boss_addrndxy		;Shake!
	dsj	a6,gb200
	RETP

********************************
* Gun piece flying off (Process)
* A8=*Arm object
* A11=*Arm data struct

 SUBRP	gun_piece

	movi	>30000,a0
	callr	rndrng0
	addi	>100000,a0
	move	a0,a6			;XV

	move	*a11(GUNNUM),a10
	jrnz	gp20			;#1?
	neg	a6

gp20	movi	>140000,a0
	calla	RNDRNGS
	move	a0,a7			;YV

	move	*a11(GUNDIR),a10
	subk	1,a10
	cmpi	5,a10
	jrlo	gp40
	clr	a10
gp40	sll	6,a10			;*64
	movi	gunfly_l,a9

	move	*a8(OFLAGS),a5
	btst	B_FLIPH,a5
	jrz	gp60
	neg	a10
	jrz	gp60			;Don't flip?
	movi	gunflyend,a9		;for flipped case
gp60	add	a10,a9			;get starting address
	calla	GETANIXY		;Get pos to start
	move	a3,a0
	move	a2,a1
	movi	gunoff_t,a5
	abs	a10			;correct negative case
	srl	1,a10
	add	a10,a5
	move	*a5+,a2			;get your offset
	move	*a5,a3
	move	*a8(OFLAGS),a5
	btst	B_FLIPH,a5
	jrz	gp100
	neg	a2			;negate offset for flip case
gp100	sll	16,a2
	sll	16,a3
	add	a2,a0
	add	a3,a1

	move	*a9,a2,L		;get animation
	movi	170,a3			;Z
	movi	DMAWNZ+M_NOCOLL,a4
	movi	CLSDEAD,a5
	sra	2,a6			;Slow down velocity
	sra	2,a7
	calla	BEGINOBJ2
	movi	90,a10			;Timeout cnt

gplp	clr	a1
	JSRP	FRANIM
	jrnc	gp300
	movi	gunfly_l,a9
gp300	calla	SCRTST
	jrnz	gpx

	movk	1,a0
	callr	rnd
	jrnz	gp400
	CREATE0	make_smoketrail

gp400	dsj	a10,gplp		;Time out check

gpx	SLEEPK	1
	jauc	DELOBJDIE


gunoff_t	;XY offsets
	.word	-70,107, -78,98, -84,94, -85,81
	.word	-90,74, -51,100

gunfly_l
	LWW	GUNRIP1,>4002,0
	LWW	GUNRIP2,>4002,0
	LWW	GUNRIP3,>4002,0
	LWW	GUNRIP4,>4002,0
	LWW	GUNRIP5,>4002,0
	LWW	GUNRIP4,>4002,M_FLIPV
	LWW	GUNRIP3,>4002,M_FLIPV
	LWW	GUNRIP2,>4002,M_FLIPV
	LWW	GUNRIP1,>4002,M_FLIPV
	LWW	GUNRIP2,>4002,M_FLIPV+M_FLIPH
	LWW	GUNRIP3,>4002,M_FLIPV+M_FLIPH
	LWW	GUNRIP4,>4002,M_FLIPV+M_FLIPH
	LWW	GUNRIP5,>4002,M_FLIPV+M_FLIPH
	LWW	GUNRIP4,>4002,M_FLIPH
	LWW	GUNRIP3,>4002,M_FLIPH
	LWW	GUNRIP2,>4002,M_FLIPH
gunflyend
	.long	0


********************************
* Hit the eyes
* A3=Damage
* A8=*Eye object
* A9=*Boss data struct for part
* A11=*Bullet obj

rteyeblo
	cmpi	32,a3			;32 or higher=destroyed
	jrlo	eyebx
	movk	1,a2
	move	a2,@reyestat		;set blown flag
	jruc	eyeb30

lfteyeblo
	cmpi	32,a3			;32 or higher=destroyed
	jrlo	eyebx
	movk	1,a2
	move	a2,@leyestat		;set blown flag

eyeb30	movi	60*7,a2
;	movi	60*8,a2
	callr	set_bloflg
	CREATE	BOSSPID,eye_blow
	movi	>1500,a1
	callr	boss_scorebonusword
eyebx	rets


********************************
* Start blowup of little head
* A8=*Arm object
* A9=*Boss data struct for part
* A11=*Bullet obj

 SUBRP	head_startblow

	PUSH	a7,a9,a10,a11

	movi	60*7,a2		;Set effect lockout flag
;	movi	60*8,a2		;Set effect lockout flag
	callr	set_bloflg
	movi	>1500,a1
	callr	boss_scorebonusword
	movk	1,a0
	move	a0,@hdstat		;Set blown flag
	move	@hdani_p,a0,L		;>Kill HD process
	jrz	hsb30
	calla	KILL
	clr	a0
	move	a0,@hdani_p,L

hsb30	CREATE	BOSSPID,head_blow

	PULL	a7,a9,a10,a11
	rets


********************************
* Start shoulder destruction
* A8=*Shoulder obj
* A9=*Boss data struct for part
* A11=*Bullet obj

 SUBRP	shldr_startblow

	PUSH	a7,a9,a10,a11

;	movi	60*15,a2
	movi	60*12,a2
	callr	set_bloflg
	movi	>1500,a1
	callr	boss_scorebonusword
	movi	100,a0
	move	a0,@shldrstat		;Set blown and hits required for biggy

ssb50	CREATE	BOSSPID,shldr_blow

	PULL	a7,a9,a10,a11
	rets

********************************
* Start the body explosion
* A8=*Any big death object
* A9=*Boss data struct for part
* A11=*Bullet obj

 SUBRP	body_startblow

	PUSH	a7,a9,a10,a11

	movi	60*4,a2
;	movi	60*5,a2
	callr	set_bloflg
	movi	>2500,a1			;2500 pts!
	callr	boss_scorebonusword
	movk	1,a0
	move	a0,@bodystat			;Blown!

	callr	bossjump_center

	movi	BOSSPID|SUBANI,a0		;Kill any animations
	calla	KIL1C
	movi	BOSSPID|SUBNOSEF,a0		;Kill nose flamer
	calla	KIL1C
	movi	BOSSPID|SUBWEAPON,a0
	calla	KIL1C

	CREATE	BOSSPID,body_blow

	PULL	a7,a9,a10,a11
	rets


********************************
* Blow out an eye (Process)
* A8=*Eye object
* A9=*Boss data struct for part

 SUBRP	eye_blow

	movk	32,a3
	callr	damage_setalways	;Show gunk

	callr	bossjump_center
	movi	myeyesnd,a0
	calla	ONESNDOVR
	CREATE	BOSSPID,eye_bleed

	movi	70-15,a6
eb100	movi	>ff,a0
	callr	rnd
	subi	>7f,a0
	move	a0,a10			;X
	movi	>7f,a0
	callr	rnd
	move	a0,a11			;Y
	movi	eye_l,a9
	movk	3,a0
	callr	rnd
	jrnz	eb200
	movi	bld_l,a9
eb200	CREATE	BOSSPID,mortar_releye
	move	a6,a11
	SLEEPK	3+1
	move	a11,a6

	cmpi	45-10,a6
	jreq	eb300
	cmpi	20-10,a6
	jrne	eb300
eb250	movi	myeyesnd,a0
	calla	ONESNDOVR

eb300	callr	damage_react2		;Pain!
	movi	exp1snd,a0
	calla	ONESND
	movk	6,a0
	callr	boss_addrndxy		;Shake!
	dsj	a6,eb100
	SLEEP	160
	movk	1,a0
	move	a0,@bloflg		;Enable weapons
	DIE



eye_l	.long	0
EYEFLY	LW	I1,1
	LW	I2,2
	LW	I3,4
	LW	I4,8
	LW	I5,12
	LW	I6,14
	LWW	I6,FLIPBITS|14,M_FLIPH
	LW	I5,12
	LW	I4,8
	LW	I3,4
	LW	I2,2
	LWL0	I1,1
	.word	DMAWNZ+M_NOCOLL
	.long	bldsplt_l


********************************
* Shoot blood from the eye
* A8=*Eye obj

 SUBRP	eye_bleed

	movi	60*5/2,a11
eblp	move	a11,a5
	movi	blooddn_t,a9
	move	*a8(OXPOS),a10
	addk	16,a10
	move	*a8(OFLAGS),a0
	btst	B_FLIPH,a0
	jrz	eb70
	addk	8,a10
eb70	move	*a8(OYPOS),a11
	subk	8,a11				;3
	CREATE	BOSSPID,mk_objbvfranim
	move	a5,a11
	SLEEPK	1+1
	dsj	a11,eblp

	DIE



********************************
* Blow off the lil head (Process)
* A8=*Head object
* A9=*Boss data struct for part

 SUBRP	head_blow

	PUSHP	a9

	callr	bossjump_center

	movi	60*5,a6
hb100	movi	head_t,a9
	move	*a8(OXPOS),a10
	move	*a8(OYPOS),a11
	addk	22,a10
	CREATE	BOSSPID,mk_objfranim
	movk	7,a0
	and	a6,a0
	jrnz	hb200
	callr	head_blowbld

hb200	move	a6,a9
	SLEEPK	1
	move	a9,a6
	movi	myheadsnd,a0
	calla	ONESND
	callr	damage_react2		;Pain!
	movi	exp1snd,a0
	calla	ONESND
	movi	exp2snd,a0
	calla	ONESND
	movk	8,a0
	callr	boss_addrndxy		;Shake!
	clr	a1
	movi	>8000,a2
	callr	boss_addxy
	dsj	a6,hb100

	PULLP	a9
	movk	32,a3
	callr	damage_setalways
	movi	hdblo_seq,a9
	callr	aniboss			;Show gunk
	movk	1,a0
	move	a0,@bloflg		;Enable weapons

	movi	60*6/8,a6
hb300	callr	head_blowbld
	move	a6,a9
	SLEEPK	8
	move	a9,a6
	dsj	a6,hb300

	DIE


 SUBRP	head_blowbld

	movi	>ff,a0
	callr	rnd
	subi	>7f,a0
	move	a0,a10			;X
	movi	>7f,a0
	callr	rnd
	move	a0,a11			;Y
	movi	bld_l,a9
	CREATE	BOSSPID,mortar_relhd
	rets



head_t	.long	head_l
	.word	190,->300,>300,->500,->100
head_l
	LW	FLYHD1,2
	LW	FLYHD2,2
	LW	FLYHD3,2
	LW	FLYHD4,2
	LW	FLYHD5,2
	LW	FLYHD6,2
	LWW	FLYHD6,FLIPBITS+2,M_FLIPH
	LW	FLYHD5,2
	LW	FLYHD4,2
	LW	FLYHD3,2
	LW	FLYHD2,2
	LW	FLYHD1,2
	LWLW	OKBM1,NEWPALET+DELTAY+3,GRNBOOM,25
	LW	OKBM2,3
	LW	OKBM3,3
	LW	OKBM4,3
	LW	OKBM5,3
	LW	OKBM6,3
	LWL0	OKBM7,3



bld_l	.long	0
	LW	BLD1,1
	LW	BLD2,2
	LW	BLD3,4
	LW	BLD4,8
	LW	BLD5,12
	LW	BLD6,14
	LWW	BLD6,FLIPBITS|14,M_FLIPH
	LW	BLD5,12
	LW	BLD4,8
	LW	BLD3,4
	LW	BLD2,2
	LWL0	BLD1,1
	.word	DMAWNZ+M_NOCOLL
	.long	bldsplt_l


bldsplt_l
	LWL	BLDSPLT1,NEWPALET+6,RIPAL
	LW	BLDSPLT2,6
	LWL0	BLDSPLT3,6


********************************
* Blow off the shoulders (Process)
* A8=*Shoulder object
* A9=*Boss data struct for part

 SUBRP	shldr_blow

	PUSHP	a9

	callr	bossjump_center
	movi	stvpainsnd,a0
	calla	ONESNDOVR

	movi	60*5,a6
sb100
	move	@bossd_t,a11,L		;Get * 1st obj
	move	*a11(OXPOS),a10
	addi	AX+2,a10		;+Ani pt X offset
	move	*a11(OYPOS),a11
	subi	40,a11
	movk	3,a0
	and	a6,a0
	jrnz	sb150
	movi	shldrexp_t,a9		;>Explosion
	CREATE	BOSSPID,mk_objfranim
sb150	addi	AY+40,a11
	movi	shldrl_t,a9		;>Alternate LR shoulder
	btst	0,a6
	jrz	sb200
	movi	shldrr_t,a9
sb200	CREATE	BOSSPID,mk_objfranim
	movk	7,a0
	and	a6,a0
	jrnz	sb300
	movi	>ff,a0
	callr	rnd
	subi	>7f,a0
	move	a0,a10			;X
	movi	>7f,a0
	callr	rnd
	move	a0,a11			;Y
	movi	bld_l,a9
	CREATE	BOSSPID,mortar_relbshldr

sb300	move	a6,a9
	SLEEPK	1
	move	a9,a6
	callr	damage_react2		;Pain!
	movi	exp1snd,a0
	calla	ONESND
	movi	exp2snd,a0
	calla	ONESND
	movk	8,a0
	callr	boss_addrndxy		;Shake!
	clr	a1
	movi	>c000,a2
	callr	boss_addxy
	dsj	a6,sb100


	PULLP	a9
	movk	32,a3
	callr	damage_setalways
	movi	shldrblo_seq,a9
	callr	aniboss			;Show gunk
	movk	1,a0
	move	a0,@bloflg		;Enable weapons


	movi	60*4/10,a6
sb600	movi	>ff,a0
	callr	rnd
	subi	>7f,a0
	move	a0,a10			;X
	movi	>7f,a0
	callr	rnd
	move	a0,a11			;Y
	movi	bld_l,a9
	CREATE	BOSSPID,mortar_relbshldr
	move	a6,a9
	movk	7,a0
	callr	rnd
	addk	10,a0			;10-17
	calla	PRCSLP
	move	a9,a6
	dsj	a6,sb600

	DIE


shldrexp_t
	.long	XBOOM2
	.word	190,->800,>800,->800,0
shldrl_t
	.long	shldrl_l
	.word	190,->800,->200,->400,0
shldrr_t
	.long	shldrr_l
	.word	190,>200,>800,->400,0

shldrr_l
	LWW	SHLDR,FLIPBITS+1,M_FLIPH
shldrl_l
	LW	SHLDR,15
	LWLW	OKBM1,NEWPALET+DELTAY+3,GRNBOOM,50
	LW	OKBM2,3
	LW	OKBM3,3
	LW	OKBM4,3
	LW	OKBM5,3
	LW	OKBM6,3
	LWL0	OKBM7,3



********************************
* Blow the body apart (Process)

 SUBRP	body_blow

	movk	1,a0
	move	a0,@ICONS_DN		;Stop icons from coming out

	SLEEP	60
	movi	stvpainsnd,a0
	calla	ONESNDOVR
	move	@bossd_t,a8,L		;A8=*1st obj

	movi	60*12,a6
bb200	cmpi	60*8,a6
	jrlo	bb220			;Do blows?
	btst	0,a6
	jrnz	bb250
	move	*a8(OXPOS),a10
	addi	AX+2,a10		;+Ani pt X offset
	move	*a8(OYPOS),a11
	movi	bodyexp1_t,a9		;>Explosion
	CREATE	BOSSPID,mk_objfranim
	movi	exp1snd,a0
	calla	ONESND
	movi	exp2snd,a0
	calla	ONESND
	jruc	bb250

bb220	move	a6,a0
	srl	6,a0			;/64
	jrz	bb230			;Always?
	callr	rndrng0
	move	a0,a0
	jrnz	bb250			;Skip?
bb230	callr	body_blowone
bb250	movi	>3f,a0
	callr	rnd
	jrnz	bb260			;Skip pain snd?
	movi	stvpainsnd,a0
	calla	ONESND
bb260	movk	10,a0
	callr	boss_addrndxy		;Shake!
	cmpi	60*5,a6
	jreq	bb265
	cmpi	60*2,a6
	jrne	bb270
bb265	callr	bossjump_center
bb270	move	a6,a9
	SLEEPK	1
	move	a9,a6
	dsj	a6,bb200


	movi	bodyblo_seq,a9
	callr	aniboss			;Show blown out base

	movi	bossd_t,a3,L		;NOCOLL on parts except base
	jruc	bb450
bb400	move	*a2(OIMG),a1,L
	cmpi	NUSHAD,a1
	jreq	bb440			;Shadow?
	cmpi	BASERIP,a1
	jrne	bb420			;!Rip?
	movi	CLSNEUT|TYPTRUNK,a0
	move	a0,*a2(OID)
	jruc	bb430
bb420	move	*a2(OFLAGS),a0
	ori	M_NOCOLL,a0
	move	a0,*a2(OFLAGS)
bb430	movi	151,a0
	move	a0,*a2(OZPOS)
bb440	addk	32,a3
bb450	move	*a3+,a2,L
	jrnz	bb400			;More?


	movk	1,a0
	move	a0,@NOSHOOT		;Don't let plyrs shoot

	CREATE0	body_bubblesnd
	PUSHP	a0

	movi	60*7/2,a6		;Big bog

bb500	btst	0,a6
	jrnz	bb550
	movi	>7f,a0
	callr	rnd
	subi	>3f,a0
	move	a0,a10			;X
	movi	>3f,a0
	callr	rnd
	move	a0,a11			;Y
	movi	bld_l,a9
	CREATE	BOSSPID,mortar_relbbase

bb550	move	*a8(OXPOS),a10
	addi	AX+10,a10		;+Ani pt X offset
	move	*a8(OYPOS),a11
	addk	30,a11
	movi	bloodc_t,a9
	CREATE	BOSSPID,mk_objfranim
	CREATE	BOSSPID,mk_objfranim
	btst	0,a6
	jrnz	bb570
	CREATE	BOSSPID,mk_objfranim

bb570	move	a6,a9
	calla	YZSORT
	calla	YZSORT
	calla	YZSORT
	SLEEPK	1
	move	a9,a6
	dsj	a6,bb500

	PULLP	a0
	calla	KILL

	SLEEP	60*1
	movi	LOVEIT,a0		;I love it speech
	calla	ONESND

	SLEEP	60*1			;Clean up and do rackup
	clr	a0
	move	a0,@WAVE		;So BNC_PLYR works on the limo!
	CREATE0	LIMO			;Dictator drives by!
	SLEEP	60*2


	movi	youwillsnd,a0
	calla	ONESND

	clr	a0
	move	a0,@WRLD
	movi	>3e3e,a6		;Cycle color
	movi	bombs_s,a8
 	movi	[100,>bc],a9		;YX
	movk	2,a10			;y,x spacing between charcters
	movi	RD15FONT,a11
	JSRP	STRCNRMO

	move	@P1DATA+BMBSUSED,a0
	move	@P2DATA+BMBSUSED,a8
	add	a0,a8
	move	@bombtotal,a0
	sub	a0,a8
	calla	HEXTOASC
	clr	a0
	movi	>3e3e,a6		;Cycle color
	movi	[100,>140],a9		;YX
	JSRP	STRLNRMO
	
	SLEEP	60*4
	movk	16,a0
	move	a0,@WAVE		;Normal
	movi	BOSSPID,a0
	movi	>ff,a1
	calla	KILALLN
	calla	TRY_RCK
	DIE


bloodc_t
	.long	bldclt_l
	.word	250,->b0,>b0,->b0,>b0

bombs_s	.byte "BOMBS USED ON ORCUS:",0
	.even


 SUBRP	body_bubblesnd

bbslp	movi	bubl1snd,a0
	calla	ONESND
	SLEEPK	20
	movi	bubl2snd,a0
	calla	ONESND
	SLEEPK	20
	jruc	bbslp


 SUBRP	body_blowone

	move	*a8(OXPOS),a10
	addi	AX+2,a10		;+Ani pt X offset
	move	*a8(OYPOS),a11
	movk	1,a0
	callr	rnd
	jrnz	bbo160			;Skip?
	movi	bodyexp1_t,a9		;>Explosion
	movk	1,a0
	callr	rnd
	jrnz	bbo150
	movi	bodyexp2_t,a9
bbo150	CREATE	BOSSPID,mk_objfranim

bbo160	addi	AY,a11			;>Alternate LR shoulder
	movi	bshldrl_t,a9
	movk	1,a0
	callr	rnd
	jrnz	bbo200
	movi	bshldrr_t,a9
bbo200	CREATE	BOSSPID,mk_objfranim

	movi	beyel_t,a9		;>Alt LR eye
	movk	1,a0
	callr	rnd
	jrnz	bbo250
	movi	beyer_t,a9
bbo250	CREATE	BOSSPID,mk_objfranim

	movi	bmthl_t,a9		;>Alt LR mouth
	movk	1,a0
	callr	rnd
	jrnz	bbo300
	movi	bmthr_t,a9
bbo300	CREATE	BOSSPID,mk_objfranim

	movi	exp1snd,a0
	calla	ONESND
	movi	exp2snd,a0
	calla	ONESND

	rets


bodyexp1_t
	.long	XBOOM2
	.word	191,->800,>800,->800,>800
bodyexp2_t
	.long	explb_l
	.word	191,->800,>800,->800,>800

explb_l
	LWLW	EXPL1,NEWPALET+DELTAY+3,BLUBOOM,50
	LW	EXPL2,3
	LW	EXPL3,3
	LW	EXPL4,3
	LW	EXPL5,3
	LW	EXPL6,3
	LW	EXPL7,3
	LW	EXPL8,3
	LW	EXPL9,3
	LW	EXPL10,3
	LWL0	EXPL11,3

bshldrl_t
	.long	bshldrl_l
	.word	190,->500,->40,->600,->40
bshldrr_t
	.long	bshldrr_l
	.word	190,>40,>500,->600,->40
bshldrr_l
	LWW	TOPRIP,FLIPBITS+1,M_FLIPH
bshldrl_l
	LW	TOPRIP,15
	LWLW	OKBM1,NEWPALET+DELTAY+3,GRNBOOM,50
	LW	OKBM2,3
	LW	OKBM3,3
	LW	OKBM4,3
	LW	OKBM5,3
	LW	OKBM6,3
	LWL0	OKBM7,3


beyel_t	.long	beyel_l
	.word	190,->800,->40,->300,>300
beyer_t	.long	beyer_l
	.word	190,>40,>800,->300,>300

beyer_l	LWW	OEYES1C,FLIPBITS+1,M_FLIPH
beyel_l	LW	OEYES1C,15
	LWLW	OKBM1,NEWPALET+DELTAY+3,BLUBOOM,50
	LW	OKBM2,3
	LW	OKBM3,3
	LW	OKBM4,3
	LW	OKBM5,3
	LW	OKBM6,3
	LWL0	OKBM7,3


bmthl_t	.long	bmthl_l
	.word	190,->800,->40,->80,>600
bmthr_t	.long	bmthr_l
	.word	190,>40,>800,->80,>600

bmthr_l	LWW	OMTH4B,FLIPBITS+1,M_FLIPH
bmthl_l	LW	OMTH4B,15
	LWLW	OKBM1,NEWPALET+DELTAY+3,RDBOOM,50
	LW	OKBM2,3
	LW	OKBM3,3
	LW	OKBM4,3
	LW	OKBM5,3
	LW	OKBM6,3
	LWL0	OKBM7,3



********************************
* Mortar shot (Process)

	APTRPD	msobj_p	,0	;*Mortar shadow object
	LONGPD	mzpos	,2	;
	LONGPD	mzvel	,4	;

MZ	.set	158
MZA	.set	>1800

GRUNTMODE	equ	1


 SUBR	mortar_akhboob	;A8=*Src Obj

	movi	160,a0
	move	@STATUS,a1
	subk	3,a1
	jreq	makb50			;2 plyrs?
	movi	88,a0
makb50	calla	RNDRNGS
	move	a0,a10			;X
	movi	>2f,a0
	callr	rndrng0
	addi	65,a0
	move	a0,a11			;Y
	movi	akhbjmp_l,a9
	movk	24,a0
	movi	76,a1
	jruc	ms5


akhbjmp_l
	.long	0			;82
	LWL0	ABOOBJUMP,82
	.word	DMAWNZ
	.long	GRUNTMODE


 SUBR	MORTAR_GRNT	;A8=*Src Obj

	movi	>7f,a0
	callr	rnd
	subi	>3f,a0
	move	a0,a10			;X
	movi	>28,a0
	callr	rnd
	addi	60,a0
	move	a0,a11			;Y
	movi	grnt_l,a9
	movi	>4c,a0
	movi	>28,a1
	jruc	ms5

grnt_l	.long	0			;82
	LW	FLMUP1,2
	LW	FLMUP2,2  
	LW	FLMUP3,2  
	LW	FLMUP4,2  
	LW	FLMUP5,2 
	LW	FLMUP6,2 
	LW	FLMUP1,2
	LW	FLMUP2,2 
	LW	FLMUP3,2  
	LW	FLMUP4,2  
	LW	FLMUP5,2  
	LW	FLMUP6,2
	LW	FLMUP1,2
	LW	FLMUP2,2  
	LW	FLMUP3,2  
	LW	FLMUP4,2  
	LW	FLMUP5,2 
	LW	FLMUP6,2 
	LW	FLMUP1,2
	LW	FLMUP2,2 
	LW	FLMUP3,2  
	LW	FLMUP4,2  
	LW	FLMUP5,2  
	LW	FLMUP6,2
	LW	FLMUP1,2
	LW	FLMUP2,2  
	LW	FLMUP3,2  
	LW	FLMUP4,2  
	LW	FLMUP5,2 
	LW	FLMUP6,2 
	LW	FLMUP1,2
	LW	FLMUP2,2 
	LW	FLMUP3,2  
	LW	FLMUP4,2  
	LW	FLMUP5,2  
	LW	FLMUP6,2
	LW	FLMUP1,2
	LW	FLMUP2,2 
	LW	FLMUP3,2  
	LW	FLMUP4,2  
	LWL0	FLMUP5,2
	.word	DMAWNZ
	.long	GRUNTMODE


 SUBRP	mortar_relbshldr	;A9=*Obj_l, A10=Dest XOffset, A11=DYO

	move	@bossd_t,a8,L		;Get * 1st obj
	movi	AX+2,a0			;+Ani pt X offset
	movi	-22,a1
	jruc	ms5

 SUBRP	mortar_relbbase		;A9=*Obj_l, A10=Dest XOffset, A11=DYO

	move	@bossd_t,a8,L		;Get * 1st obj
	movi	AX+14,a0		;+Ani pt X offset
	movi	50,a1
	jruc	ms5

 SUBRP	mortar_releye		;A8=*Src Obj, A9=*Obj_l, A10=DXOffset, A11=DYO

	movk	24,a0
	movk	19,a1
	jruc	ms5

 SUBRP	mortar_relaboss		;A8=*Src Obj, A9=*Obj_l, A10=DXOffset, A11=DYO

	movk	24,a0
	movk	32,a1
	jruc	ms5

 SUBRP	mortar_relhd		;A8=*Src Obj, A9=*Obj_l, A10=DXOffset, A11=DYO

	movk	26,a0
	movk	30,a1

ms5	move	*a8(OXPOS),a2		;Get X
	add	a2,a0
	move	*a8(OYPOS),a2		;Get Y
	add	a2,a1

	move	a0,a6
	move	a1,a7

	add	a10,a6			;+X offset
	add	a11,a7			;+Y offset
	sll	16,a0
	sll	16,a1
	sll	16,a6
	sll	16,a7
	sub	a0,a6			;DestX-SrcX
	sub	a1,a7			;DestY-SrcY

	move	a6,a11
	abs	a11   			;A11=Distance
	move	a7,a2
	abs	a2
	cmp	a2,a11			;Use max
	jrhs	ms30
	move	a2,a11
ms30
	srl	6,a11			;/64
	move	a11,a3
	srl	2,a3
	sub	a3,a11			;Sub .25 = /96

	cmpi	14000,a11
	jrhs	ms60
	movi	14000,a11		;Minimum

ms60	sra	1,a6			;>Scale down to A11
	sra	1,a7
	move	a6,a2
	abs	a2
	cmp	a11,a2			;A6&A7 < A11
	jrgt	ms60
	move	a7,a2
	abs	a2
	cmp	a11,a2
	jrgt	ms60

	move	a6,a4			;>Fine scale up to A11
	move	a7,a5
	sra	4,a4			;/16
	sra	4,a5
	jrnz	ms150
	move	a4,a4
	jrz	ms200			;Both 0 then skip
ms150	add	a4,a6
	add	a5,a7
	move	a6,a2
	abs	a2
	cmp	a11,a2
	jrgt	ms200
	move	a7,a2
	abs	a2
	cmp	a11,a2
	jrle	ms150

ms200	clr	a3			;Z
	movi	DMAWNZ+M_NOCOLL,a4	;No collisions
	movi	CLSDEAD,a5
	move	a9,a10
	addk	32,a10
	move	*a10,a2,L		;Get *1st obj
	mmtm	a12,a0,a1,a4,a6,a7
	clr	a6
	clr	a7
	calla	BEGINOBJ2		;Get shot obj

	move	*a9,a9,L		;Get *FRANIM list
	jrz	ms250
	JSRP	FRANIMQ			;Fire sequence

ms250	mmfm	a12,a0,a1,a4,a6,a7
	movi	SHADW,a2
	movi	70,a3			;Z
	movi	CLSDEAD,a5
	move	a8,a9
	calla	BEGINOBJ2		;Get shadow obj
	move	a8,*a13(msobj_p),L
	move	a9,a8

	move	a10,a9
	clr	a0
	move	a0,*a13(mzpos),L
	movi	41*MZA,a0
	move	a0,*a13(mzvel),L
	jruc	ms400


ms300	move	*a8(OFLAGS),a4		;No collisions
	move	*a9+,a10		;Get #ticks for frame
	cmpi	>100,a10
	jrlo	ms330
	move	*a9+,a2			;Get the new flip flags
	andni	(M_FLIPV+M_FLIPH),a4	;Clear the current flip status
	or	a2,a4			;Set desired bits
	sll	32-8,a10
	srl	32-8,a10
ms330	calla	ANI			;New frame
ms350	move	a8,a0
	callr	GANIOFQ
	move	*a13(msobj_p),a5,L
	move	*a5(OXPOS),a1
	sub	a6,a1
	move	a1,*a8(OXPOS)		;Set shot X
	move	*a13(mzvel),a1,L
	subi	MZA,a1			;Gravity
	move	*a13(mzpos),a0,L	;New height
	add	a1,a0
	jrgt	ms370
	clr	a0
	neg	a1
ms370	move	a0,*a13(mzpos),L
	move	a1,*a13(mzvel),L
	srl	16,a0
	move	*a5(OYPOS),a1
	sub	a0,a1
	sub	a7,a1
	move	a1,*a8(OYPOS)		;Set shot Y
	addi	MZ+130,a0
	move	a0,*a8(OZPOS)
	SLEEPK	1
	dsj	a10,ms350

ms400	move	*a9+,a1,L		;Get *Img
	jrnz	ms300


	move	*a13(msobj_p),a0,L	;Kill shadow
	calla	DELOBJ

	movi	51,a0
	move	a0,*a8(OZPOS)

	move	*a9+,a0			;Get OFLAGS
	move	a0,*a8(OFLAGS)
	movi	CLSDEAD,a0
	move	a0,*a8(OID)
	move	*a9+,a9,L		;Get *FRANIM list
	jrz	ms880
	cmpi	GRUNTMODE,a9
	jaz	RUN_AWAY		;Flaming grunt runs away!
	JSRP	FRANIMQ			;Land

ms880	calla	DELOBJA8
ms900	DIE


********************************
* Get animation offset
*	A0=*Obj
*
* Rets:	A6=X Anim offset
*	A7=Y Anim offset
* Trash A1,A2

GANIOFQ
	move	*a0(OIMG),a7,L
	addk	IANIOFF,a7
	move	*a7+,a6		;X
	move	*a7+,a7		;Y

	move	*a0(OFLAGS),a2
	btst	B_FLIPH,a2
	jrz	gani1
	move	*a0(OSIZEX),a1
	subk	1,a1
	neg	a6
	add	a1,a6		;Sub ths-1 for hflip

gani1	btst	B_FLIPV,a2
	jrz	gani2
	move	*a0(OSIZEY),a1
	subk	1,a1
	neg	a7
	add	a1,a7		;Sub tvs-1 for vflip

gani2	rets


********************************
* Make an obj with boss vel, franim and delete (Process)
* A9=*Data table
* A10=X
* A11=Y

 SUBRP	mk_objbvfranim

	move	@bossxv,a6,L
	move	@bossyv,a7,L
	jruc	mofbv

********************************
* Make an obj, franim and delete (Process)
* A9=*Data table
* A10=X
* A11=Y

 SUBR	mk_objfranim

	clr	a6
	clr	a7
mofbv	move	a9,a5
	move	*a5+,a9,L		;*FRANIM_l
	move	*a9,a2,L		;*IMG
	move	*a5+,a3			;Z
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
	calla	BEGINOBJ2
	jauc	FRQDELDIE



********************************
* Smoke puff trail (Process)
* A8=*Src obj

 SUBRP	make_smoketrail

	movi	okbmg_l,a9
	move	*a8(OZPOS),a3
	addk	1,a3

	move	*a8(OXVEL),a6,L
	move	*a8(OYVEL),a7,L
	sra	1,a6
	sra	1,a7

	move	*a8(OXPOS),a0
	move	*a8(OSIZEX),a2
	srl	1,a2			;/2
	add	a2,a0
	move	*a8(OYPOS),a1
	move	*a8(OSIZEY),a2
	srl	1,a2			;/2
	add	a2,a1
	sll	16,a0			;X
	sll	16,a1			;Y
	movi	CLD1A,a2
	movi	DMAWNZ+M_NOCOLL,a4	;No collisions
	movi	CLSDEAD,a5
	calla	BEGINOBJ2
	jauc	FRQDELDIE


okbmg_l	LWL	OKBM1,NEWPALET+4,GREYPAL
	LW	OKBM2,4
	LW	OKBM3,4
	LW	OKBM4,4
	LW	OKBM5,4
	LW	OKBM6,4
	LWL0	OKBM7,4


********************************
* Transfer damage on a dead part to other parts
* A2=Hit amount
* A9=*Boss data struct for part
* A11=*Bullet obj

 SUBRP	damage_xfer

	PUSH	a2,a3,a4,a8,a9
	movk	3,a0			;25%
	callr	rnd
	jrnz	dxx			;Skip it?

	subi	bossd_t,a9
	srl	6,a9			;/64
	cmpi	14,a9
	jrhs	dxx			;Not in table?
	sll	3,a9			;*8
	addi	damxfer_t,a9
	movb	*a9,a9
	jrn	dxx			;No xfer part?
	sll	6,a9			;*64
	addi	bossd_t-64,a9		;1st is 1
	move	*a9,a8,L
	move	*a9(BODAM),a3
	cmpi	47,a3
	jrhs	dxx
	add	a2,a3
	callr	boss_chknblowpart
	cmpi	47,a3
	jrls	dx20
	movi	47,a3
dx20	callr	damage_set
	movi	>1f1f0000,a9
	CREATE0	FLASHME

dxx	PULL	a2,a3,a4,a8,a9
	rets


damxfer_t
	.byte	SIDEL,SIDER,EYEL,EYER,LILHD,LILHD
	.byte	-1,-1,SHLDRL,-1,-1,-1,-1,SHLDRR



********************************
* Set damage amount and do ANI for level
* A3=Damage
* A8=*Object hit
* A9=*Bossdata_t entry

 SUBRP	damage_set

	move	@bloflg,a0
	jrnz	dsx2			;Blow in progress?

 SUBRP	damage_setalways		;Don't chk bloflg

	PUSH	a2,a3,a4

	cmpi	31,a3
	jrls	ds50

	movb	*a8(OID),a0		;Mouth kludge check...
	cmpi	SUBMTHL,a0
	jreq	ds20
	cmpi	SUBMTHR,a0
	jrne	ds50

ds20	movi	bossd_t+BODAM,a0
	move	*a0,a1
	move	*a0(64),a2
	movk	31,a3
	add	a1,a2
	cmpi	62,a2
	jrlo	ds50

	movk	32,a3
	move	a3,*a0
	move	a3,*a0(BODAM)

ds50	move	a3,*a9(BODAM)		;Save new damage
	movb	*a9(BOAFRM),a1		;get frame pointer
	subk	1,a1
	cmpi	LSTANI,a1
	jrhs	dsx			;Out of range?

	movi	BDAMSIZE,a2
	mpyu	a2,a1			;*Entry size
	addi	bossdam_t,a1		;+Base
	srl	4,a3			;Damage/16=Level
	sll	5,a3			;*32
	add	a3,a1
	move	*a1,a1,L		;OIMG
	move	*a8(OFLAGS),a4
	calla	ANI

dsx	PULL	a2,a3,a4
dsx2	rets

********************************
* Check if boss on screen
*Rets: Z if on screen, Trashes A0-A3

 SUBRP	boss_scrntst

	PUSH	a4,a5,a8
	clr	a0
	move	@bossd_t,a8,L		;Get * 1st obj
	calla	GETANIXY
	sra	16,a2
	sra	16,a3
	move	@WORLDTLX+16,a4
	move	@WORLDTLY+16,a5
	sub	a4,a3			;X
	sub	a5,a2			;Y
	cmpi	30,a3			;XMin
	jrlt	bst10
	cmpi	370,a3			;XMax
	jrgt	bst10
	cmpi	-55,a2			;YMin
	jrlt	bst10
	cmpi	170,a2			;YMax
	jrle	bston
bst10	movk	1,a0			;Off screen

bston	PULL	a4,a5,a8
	move	a0,a0			;Set CC
	rets


********************************
* Missile launcher (Process)

 SUBRP	weapon_launcher

wl50	SLEEPK	32
	move	@larmstat,a0
	subk	2,a0
	jrls	wl50			;Arm OK?
	move	@rarmstat,a0
	subk	2,a0
	jrls	wl50			;^

wllp	SLEEPK	8
	move	@bossmode,a0
	jrnz	wllp			;Jump/fire in progress?
	move	@bloflg,a0
	jrn	wllp			;Blowing?
;	move	@HALT,a0
;	jrnz	wllp			;Halt?

	move	@bossd_t,a2,L		;Get * 1st obj
	move	*a2(OYPOS),a2
	move	@WORLDTLY+16,a0
	sub	a0,a2
	cmpi	140,a2
	jrgt	wllp			;Near bottom?

	callr	getplyr
	jrz	wllp			;No player?
	move	a0,a11
	movi	yowl2snd,a0
	calla	ONESND
	movi	-1,a0
	move	a0,@bossmode		;Neg
	clr	a0			;XO
	movi	120,a1			;YO
	movi	bossd_t,a8
	callr	bossseeko_dir32
	subk	9,a0
	jrlt	wl200			;<9
	subk	15,a0
	jrlt	wl400			;<24


wl200	movk	2,a11			;>Missile
	move	@bossd_t+64*14,a8,L	;Tongue obj
	movi	missileo_t,a9

wl250	movk	4,a0
	callr	rndrng0
	addk	14,a0
	move	a0,a10			;14-18
	CREATE	BOSSPID,missile_fire
	movi	msllnchsnd,a0
	calla	ONESND
	SLEEPK	7
	dsj	a11,wl250

	move	a11,@bossmode		;Clr
	SLEEP	390
	jruc	wllp


wl400	movk	25,a11			;>Tongue
	move	*a8,a8,L		;A8=*1st boss obj

wl450	movk	12,a0
	callr	rndrng0
	addk	10,a0			;10-22
	move	a0,a10
	CREATE	BOSSPID,tongue_fire
	movi	tungsnd,a0
	calla	ONESND
	SLEEPK	5
	move	@bossmode,a0
	jrnn	wl490			;Fire canceled?
	dsj	a11,wl450

	move	a11,@bossmode		;Clr
wl490	SLEEP	200
	jruc	wllp


missileo_t
	.word	9,7


********************************
* Missile, player seeking (Process)

	WORDPD	mslshield,0	;Shield strength
	WORDPD	mslsko,1	;Seek offset -1/1
	WORDPD	msldrag,2	;Drag shift
	APTRPD	mslplyro,3	;*Plyr leg obj or 0

 SUBRP	missile_dfire		;A8=*Src obj, A9=*Offset_t, A10=Dir 0-31

	movi	80,a11			;Fuel
	movk	1,a0			;Shield
	jruc	mif100

********************************
* Ground launched - shots.asm

 SUBR	missile_fire2		;A8=*Src obj, A9=*Offset_t, A10=Dir 0-31

	movi	220,a11			;Fuel
	move	*a8(OZPOS),a3
	subk	1,a3			;Under launcher top obj
	movk	4,a0
      	jruc	mif110

********************************
* At skilled player - layer.asm
* A7=*Plyr leg obj, A8=X, A9=Y, A10=Dir, A11=Fuel

 SUBR	missile_firexy_slow

	movi	-4,a0
	movk	20,a1
	jruc	mfxy100

 SUBR	missile_firexy		;A8=X, A9=Y, A10=Dir, A11=Fuel

	movi	-5,a0			;Slow speed

	abs	a11
	jrn	mfxy20			;Fuel pos?
	subk	1,a0			;Normal speed
mfxy20
	movk	4,a1
	clr	a7

mfxy100	move	a0,*a13(msldrag)
	move	a1,*a13(mslshield)
	movk	1,a0
	callr	rnd
	jrnz	jet10
	subk	1,a0
jet10	move	a0,*a13(mslsko)
	move	a8,a0
	move	a9,a1
	movi	159,a3			;Z
      	jruc	mif130


********************************
* Missile from aboss

 SUBR	missile_fireab		;A8=*Src obj, A9=*Offset_t, A10=Dir 0-31

	movi	100,a11			;Fuel
	movk	2,a0			;Shield
	movi	159,a3			;Z
	jruc	mif110


 SUBRP	missile_fire		;A8=*Src obj, A9=*Offset_t, A10=Dir 0-31

	movi	400,a11			;Fuel
	movk	5,a0

mif100	move	*a8(OZPOS),a3
	addk	1,a3

mif110	move	a0,*a13(mslshield)
	movk	1,a0
	callr	rnd
	jrnz	mif120
	subk	1,a0
mif120	move	a0,*a13(mslsko)		;-1 or 1
	movi	-6,a0			;Normal speed
	move	a0,*a13(msldrag)

	move	*a8(OXPOS),a0
	move	*a8(OYPOS),a1
	move	*a9+,a2			;+X offset
	add	a2,a0
	move	*a9+,a2			;+Y offset
	add	a2,a1

	clr	a7
mif130	move	a7,*a13(mslplyro),L

	sll	16,a0
	sll	16,a1
	movi	MSLB1,a2		;Image
	movi	DMAWNZ,a4
	movi	CLSENMY+TYPSL+SUBMSL,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2

	movk	25,a9			;Seek delay
	jruc	mif400


mif200	SLEEPK	1
;	move	@HALT,a0
;	jrnz	mif200			;Freeze?

	subk	1,a9
	jrlt	mif220
	jrgt	mif500			;Don't seek?
	movi	159,a0
	move	a0,*a8(OZPOS)

mif220	movk	1,a0
	and	a11,a0
	jrnz	mif230			;No smoke?
	cmpi	30,a11
	jrlt	mif230			;Low fuel?
	CREATE0	missile_smoketrail

mif230	movk	3,a0
	callr	rnd
	jrz	mif500			;Skip seek?

	move	*a13(mslplyro),a0,L
	jrnz	mif260			;Good plyr to kill?
	calla	getcloseplyr
	jrz	mif700			;No player?
mif260	callr	seekob_dir32la

mif300	sub	a10,a0			;A0=Difference
	jrz	mif500

	move	a0,a1
	abs	a0
	cmpi	2,a0
	jrle	mif340			;In seeker view?
	move	*a13(mslsko),a2
	movk	>f,a0
	callr	rnd
	jrnz	mif320			;No dir change?
	neg	a2
	move	a2,*a13(mslsko)
mif320	add	a2,a10
	jruc	mif400

mif340	subk	16,a0
	jrle	mif350
	neg	a1
mif350	move	a1,a1
	jrnn	mif360
	subk	2,a10			;-1
mif360	addk	1,a10			;+1


mif400	ANDK	>1f,a10			;Make 0-31

	move	a10,a0			;>New image
	sll	4,a0			;*16
	move	a0,a1			;*3
	add	a1,a0
	add	a1,a0
	addi	missileimg_t,a0
	move	*a0+,a1,L
	move	*a0,a4
	calla	ANI			;New frame

mif500	move	a10,a0
	sll	4,a0			;*16
	addi	missilev_t,a0
	move	*a0(8*16),a6		;XV
	move	*a0,a7			;YV

	move	*a13(msldrag),a2
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

mif700	movk	>f,a1
	and	a11,a1
	jrnz	mif800			;Skip screen check?
	move	@WAVE,a1
	subk	16,a1
	jrne	mif800			;!Orcus missile?
	calla	SCRTST
	janz	DELOBJDIE
mif800	move	@bloflg,a0
	jrn	mifx			;Big blow?

	subk	1,a11
	jrgt	mif200			;Got fuel?

mifx	move	*a8(OYPOS),a0
	addk	15,a0
	move	a0,*a8(OYPOS)
	movi	DMAWNZ+M_NOCOLL,a0
	move	a0,*a8(OFLAGS)
	movi	mslexpsnd,a0
	calla	ONESND
	movi	mslnofuel_l,a9		;Out of fuel!
	jauc	FRQDELDIE


missileimg_t
	LW	MSLB9,DMAWNZ
	LW	MSLB8,DMAWNZ+M_FLIPH
	LW	MSLB7,DMAWNZ+M_FLIPH
	LW	MSLB6,DMAWNZ+M_FLIPH
	LW	MSLB5,DMAWNZ+M_FLIPH
	LW	MSLB4,DMAWNZ+M_FLIPH
	LW	MSLB3,DMAWNZ+M_FLIPH
	LW	MSLB2,DMAWNZ+M_FLIPH

	LW	MSLB1,DMAWNZ+M_FLIPH
	LW	MSLB2,DMAWNZ+M_FLIPV+M_FLIPH
	LW	MSLB3,DMAWNZ+M_FLIPV+M_FLIPH
	LW	MSLB4,DMAWNZ+M_FLIPV+M_FLIPH
	LW	MSLB5,DMAWNZ+M_FLIPV+M_FLIPH
	LW	MSLB6,DMAWNZ+M_FLIPV+M_FLIPH
	LW	MSLB7,DMAWNZ+M_FLIPV+M_FLIPH
	LW	MSLB8,DMAWNZ+M_FLIPV+M_FLIPH

	LW	MSLB9,DMAWNZ+M_FLIPV
	LW	MSLB8,DMAWNZ+M_FLIPV
	LW	MSLB7,DMAWNZ+M_FLIPV
	LW	MSLB6,DMAWNZ+M_FLIPV
	LW	MSLB5,DMAWNZ+M_FLIPV
	LW	MSLB4,DMAWNZ+M_FLIPV
	LW	MSLB3,DMAWNZ+M_FLIPV
	LW	MSLB2,DMAWNZ+M_FLIPV

	LW	MSLB1,DMAWNZ
	LW	MSLB2,DMAWNZ
	LW	MSLB3,DMAWNZ
	LW	MSLB4,DMAWNZ
	LW	MSLB5,DMAWNZ
	LW	MSLB6,DMAWNZ
	LW	MSLB7,DMAWNZ
	LW	MSLB8,DMAWNZ

missilev_t
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



 SUBR	rocket_fireab		;A8=*Src obj, A9=*Offset_t, A10=Dir 0-31

	movi	100,a11			;Fuel
	movk	1,a0			;Shield
	movi	159,a3			;Z
	jruc	rf110


 SUBRP	rocket_fire		;A8=*Src obj, A9=*Offset_t, A10=Dir 0-31

	movi	400,a11			;Fuel
	movk	5,a0

rf100	move	*a8(OZPOS),a3
	addk	1,a3

rf110	move	a0,*a13(mslshield)
	movi	-6,a0			;Norm speed
	move	a0,*a13(msldrag)

	move	*a8(OXPOS),a0
	move	*a8(OYPOS),a1
	move	*a9+,a2			;+X offset
	add	a2,a0
	move	*a9+,a2			;+Y offset
	add	a2,a1

rf130	sll	16,a0
	sll	16,a1
	movi	MSL1,a2			;Image
	movi	DMAWNZ,a4
	movi	CLSENMY+TYPSL+SUBMSL,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2

	movk	25,a9			;Seek delay
	jruc	rf400


rf200	SLEEPK	1
	subk	1,a9
	jrlt	rf220
	jrgt	rf500			;Don't seek?
;	movi	159,a0
;	move	a0,*a8(OZPOS)

rf220	cmpi	-9,a9
	jrlt	rf500			;Seek time over?
	movk	1,a0
	and	a11,a0
	jrnz	rf230			;No smoke?
	CREATE0	missile_smoketrail

rf230
	calla	getcloseplyr
	jrz	rf700			;No player?
	callr	seekob_dir32la

rf300	sub	a10,a0			;A0=Difference
	jrz	rf500

	move	a0,a1
	abs	a0
	subk	16,a0
	jrle	rf350
	neg	a1
rf350	move	a1,a1
	jrnn	rf360
	subk	2,a10			;-1
rf360	addk	1,a10			;+1


rf400	ANDK	>1f,a10			;Make 0-31

	move	a10,a0			;>New image
	sll	4,a0			;*16
	move	a0,a1			;*3
	add	a1,a0
	add	a1,a0
	addi	rocketimg_t,a0
	move	*a0+,a1,L
	move	*a0,a4
	calla	ANI			;New frame

rf500	move	a10,a0
	sll	4,a0			;*16
	addi	rocketv_t,a0
	move	*a0(8*16),a6		;XV
	move	*a0,a7			;YV

	move	*a13(msldrag),a2
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

rf700
	movk	>f,a1
	and	a11,a1
	jrnz	rf800			;Skip screen check?
	calla	SCRTST
	janz	DELOBJDIE
rf800	move	@bloflg,a0
	jrn	rfx			;Big blow?

	subk	1,a11
	jrgt	rf200			;Got fuel?

rfx	move	*a8(OYPOS),a0
	addk	15,a0
	move	a0,*a8(OYPOS)
	movi	DMAWNZ+M_NOCOLL,a0
	move	a0,*a8(OFLAGS)
	movi	mslexpsnd,a0
	calla	ONESND
	movi	mslnofuel_l,a9		;Out of fuel!
	jauc	FRQDELDIE


rocketimg_t
	LW	MSL9,DMAWNZ
	LW	MSL8,DMAWNZ+M_FLIPH
	LW	MSL7,DMAWNZ+M_FLIPH
	LW	MSL6,DMAWNZ+M_FLIPH
	LW	MSL5,DMAWNZ+M_FLIPH
	LW	MSL4,DMAWNZ+M_FLIPH
	LW	MSL3,DMAWNZ+M_FLIPH
	LW	MSL2,DMAWNZ+M_FLIPH

	LW	MSL1,DMAWNZ+M_FLIPH
	LW	MSL2,DMAWNZ+M_FLIPV+M_FLIPH
	LW	MSL3,DMAWNZ+M_FLIPV+M_FLIPH
	LW	MSL4,DMAWNZ+M_FLIPV+M_FLIPH
	LW	MSL5,DMAWNZ+M_FLIPV+M_FLIPH
	LW	MSL6,DMAWNZ+M_FLIPV+M_FLIPH
	LW	MSL7,DMAWNZ+M_FLIPV+M_FLIPH
	LW	MSL8,DMAWNZ+M_FLIPV+M_FLIPH

	LW	MSL9,DMAWNZ+M_FLIPV
	LW	MSL8,DMAWNZ+M_FLIPV
	LW	MSL7,DMAWNZ+M_FLIPV
	LW	MSL6,DMAWNZ+M_FLIPV
	LW	MSL5,DMAWNZ+M_FLIPV
	LW	MSL4,DMAWNZ+M_FLIPV
	LW	MSL3,DMAWNZ+M_FLIPV
	LW	MSL2,DMAWNZ+M_FLIPV

	LW	MSL1,DMAWNZ
	LW	MSL2,DMAWNZ
	LW	MSL3,DMAWNZ
	LW	MSL4,DMAWNZ
	LW	MSL5,DMAWNZ
	LW	MSL6,DMAWNZ
	LW	MSL7,DMAWNZ
	LW	MSL8,DMAWNZ

rocketv_t
	.word	-7000,-6866,-6467,-5820,-4950,-3889,-2679,-1365
	.word	0,1365,2678,3889,4950,5820,6467,6865
	.word	7000,6865,6467,5820,4950,3889,2679,1365
	.word	0,-1365,-2678,-3889,-4950,-5820,-6467,-6865
	.word	-7000,-6866,-6467,-5820,-4950,-3889,-2679,-1365



********************************
* Missile smoke trail (Process)
* A8=*Src obj, A10=Dir 0-31

 SUBR	aboss_smoketrail

	movi	155,a3
	jruc	mstab


 SUBRP	missile_smoketrail

	move	*a8(OZPOS),a3
	movk	3,a0
	callr	rnd
	subk	2,a0
	add	a0,a3			;-2 to 1

mstab	movk	3,a0
	callr	rnd
	sll	5,a0			;*32
	addi	mslsmoke_t,a0
	move	*a0,a9,L

	move	*a8(OXVEL),a6,L
	move	*a8(OYVEL),a7,L
	sra	2,a6			;/4
	sra	2,a7

	move	*a8(OXPOS),a0
	move	*a8(OSIZEX),a2
	srl	1,a2			;/2
	add	a2,a0
	move	*a8(OYPOS),a1
	move	*a8(OSIZEY),a2
	srl	1,a2			;/2
	add	a2,a1
	addk	15,a1
	sll	4,a10			;*16
	addi	mslstxy_t,a10
	move	*a10(8*16),a2
	add	a2,a0			;+X offset
	move	*a10,a2
	add	a2,a1			;+YO
	sll	16,a0			;X
	sll	16,a1			;Y
	movi	CLDB1ORNG,a2
	movi	DMAWNZ+M_NOCOLL,a4	;No collisions
	movi	CLSDEAD,a5
	calla	BEGINOBJ2
	SLEEPK	3
	jauc	FRQDELDIE

mslstxy_t
	.word	12,12,11,10,8,6,3,1		;Y
	.word	0,-1,-3,-6,-8,-10,-11,-12	;X
	.word	-12,-12,-11,-10,-8,-6,-3,-1
	.word	0,1,3,6,8,10,11,12
	.word	12,12,11,10,8,6,3,1

mslsmoke_t
	.long	cldbw_l,cldblg_l,cldbgry_l,cldbblu_l

cldbw_l
	LWL	CLDB1,NEWPALET|2,WHTPAL
	LW	CLDB2,4
	LW	CLDB3,4
	LW	CLDB4,3
	LW	CLD5,3
	LW	CLD6,4
	LW	CLD7,4
	LW	CLD8,4
	LW	CLD9,4
	LW	CLD10,4
	LWL0	CLD11,4
cldblg_l
	LWL	CLDB1,NEWPALET|2,LGRYPAL
	LW	CLDB2,3
	LW	CLDB3,3
	LW	CLDB4,3
	LW	CLD5,3
	LW	CLD6,3
	LW	CLD7,3
	LW	CLD8,3
	LW	CLD9,3
	LW	CLD10,2
	LWL0	CLD11,2
cldbgry_l
	LWL	CLDB1,NEWPALET|2,GREYPAL
	LW	CLDB2,2
	LW	CLDB3,2
	LW	CLDB4,2
	LW	CLD5,2
	LW	CLD6,2
	LW	CLD7,3
	LW	CLD8,3
	LW	CLD9,3
	LW	CLD10,3
	LWL0	CLD11,3
cldbblu_l
	LWL	CLDB1,NEWPALET|2,BLUBOOM
	LW	CLDB2,2
	LW	CLDB3,2
	LW	CLDB4,2
	LW	CLD5,2
	LW	CLD6,2
	LW	CLD7,2
	LW	CLD8,2
	LW	CLD9,2
	LW	CLD10,2
	LWL0	CLD11,2




********************************
* Tongue flying down screen (Process)

	WORDPD	tngimgnum,0	;0-3

 SUBRP	tongue_fire		;A8=*Src obj, A10=Dir 0-31

	movi	100,a11			;Fuel

	move	*a8(OXPOS),a0
	move	*a8(OYPOS),a1
	addi	AX,a0
	addi	AY,a1
	sll	16,a0
	sll	16,a1
	movi	TUNG1,a2		;Image
	move	*a8(OZPOS),a3
	addk	1,a3
	movi	DMAWNZ,a4
	movi	CLSENMY|TYPT72|SUBTK,A5
	clr	a6
	clr	a7
	calla	BEGINOBJ2

	movi	30,a9			;Low Z delay
	sll	4,a10			;*16
	addi	tonguev_t,a10		;A10=*XY vel for dir
	jruc	tf500

tf200	SLEEPK	1
	subk	1,a9
	jrnz	tf500
	movi	158,a0
	move	a0,*a8(OZPOS)

tf500	btst	0,a11
	jrnz	tf600			;Skip?
	move	*a13(tngimgnum),a0	;>New frame
	addk	1,a0
	ANDK	3,a0
	move	a0,*a13(tngimgnum)
	sll	5,a0			;*32
	addi	tongueimg_t,a0
	move	*a0+,a1,L
	move	*a8(OFLAGS),a4
	calla	ANI

tf600	move	*a10(8*16),a6		;XV
	move	*a10,a7			;YV

	move	*a8(OXVEL),a0,L
	move	a0,a1
	sra	6,a1
	sub	a1,a0			;-Drag
	add	a6,a0			;+Vel
	move	a0,*a8(OXVEL),L
	move	*a8(OYVEL),a0,L
	move	a0,a1
	sra	6,a1
	sub	a1,a0			;-Drag
	add	a7,a0			;+Vel
	move	a0,*a8(OYVEL),L

tf700	subk	1,a11
	jrgt	tf200			;Got fuel?

	jauc	DELOBJDIE

tongueimg_t
	.long	TUNG1,TUNG2,TUNG1,TUNG3

tonguev_t
	.word	-8000,-7846,-7391,-6652,-5657,-4444,-3061,-1561
	.word	0,1560,3061,4444,5657,6652,7391,7846
	.word	8000,7846,7391,6652,5657,4444,3061,1560
	.word	0,-1560,-3061,-4444,-5657,-6652,-7391,-7846
	.word	-8000,-7846,-7391,-6652,-5657,-4444,-3061,-1561


	NOTINUSE
********************************
* Drone, player seeking (Process)

	WORDPD	drnimgnum,0	;0-3
	WORDPD	drnmode,1	;


 SUBRP	drone_fire		;A8=*Src obj, A9=*Offset_t, A10=Dir 0-31

	movi	400,a11			;Fuel
	movk	2,a0
	move	a0,*a13(drnmode)

	move	*a8(OXPOS),a0
	move	*a8(OYPOS),a1
	move	*a9+,a2			;+X offset
	add	a2,a0
	move	*a9+,a2			;+Y offset
	add	a2,a1
	sll	16,a0
	sll	16,a1
	movi	BLB1,a2			;Image
	move	*a8(OZPOS),a3
	addk	1,a3
	movi	DMAWNZ,a4
	movi	CLSENMY+TYPSL+SUBMSL,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2

	movk	25,a9			;Seek delay
	jruc	df400

df200	SLEEPK	1
	subk	1,a9
	jrlt	df220
	jrgt	df500			;Don't seek?
	movi	158,a0
	move	a0,*a8(OZPOS)

df220
	movi	>1f,a0
	callr	rnd
	jrnz	df250
	movk	2,a0			;>New mode
	callr	rndrng0
	move	a0,*a13(drnmode)


df250	move	*a13(drnmode),a0	;>
	subk	1,a0
	jrnn	df260			;Skip?
	addk	1,a10			;Rotate rgt
	jruc	df400
	
df260	jrnz	df280			;No missile?
	calla	getcloseplyr
	jrz	df500			;No player?
	callr	seekob_dir32

	PUSH	a9,a10
	movi	dronemslo_t,a9
	move	a0,a10
	CREATE	BOSSPID,missile_dfire
	PULL	a9,a10
	clr	a0			;Turn mode
	move	a0,*a13(drnmode)


df280
	calla	getcloseplyr
	jrz	df500			;No player?
	callr	seekob_dir32
	addk	6,a0
	sll	32-5,a0
	srl	32-5,a0

df300	sub	a10,a0			;A0=Difference
	jrz	df500

	move	a10,a2
	move	a0,a1
	abs	a0
	subk	16,a0
	jrle	df350
	neg	a1
df350	move	a1,a1
	jrnn	df360
	subk	2,a10			;-1
df360	addk	1,a10			;+1

df400	ANDK	>1f,a10			;Make 0-31

df500	movk	3,a0
	and	a11,a0
	jrnz	df600			;Skip?
	move	*a13(drnimgnum),a0	;>New frame
	addk	1,a0
	movk	3,a14
	and	a14,a0
	move	a0,*a13(drnimgnum)
	sll	5,a0			;*32
	addi	droneimg_t,a0
	move	*a0+,a1,L
	movi	DMAWNZ,a4
	calla	ANI

df600	move	a10,a0
	sll	4,a0			;*16
	addi	dronev_t,a0
	move	*a0(8*16),a6		;XV
	move	*a0,a7			;YV

	move	*a8(OXVEL),a0,L
	move	a0,a1
	sra	5,a1
	sub	a1,a0			;-Drag
	add	a6,a0			;+Vel
	move	a0,*a8(OXVEL),L
	move	*a8(OYVEL),a0,L
	move	a0,a1
	sra	5,a1
	sub	a1,a0			;-Drag
	add	a7,a0			;+Vel
	move	a0,*a8(OYVEL),L


df700	move	@bloflg,a0
	jrn	dfx			;Big blow?

	subk	1,a11
	jrgt	df200			;Got fuel?

dfx	move	*a8(OYPOS),a0
	addk	20,a0
	move	a0,*a8(OYPOS)
	movi	DMAWNZ+M_NOCOLL,a0
	move	a0,*a8(OFLAGS)
	movi	mslexpsnd,a0
	calla	ONESND
	movi	cldbblu_l,a9		;Out of fuel!
	jauc	FRQDELDIE

droneimg_t
	.long	BLB1,BLB2,BLB3,BLB4

dronev_t
	.word	-8000,-7846,-7391,-6652,-5657,-4444,-3061,-1561
	.word	0,1560,3061,4444,5657,6652,7391,7846
	.word	8000,7846,7391,6652,5657,4444,3061,1560
	.word	0,-1560,-3061,-4444,-5657,-6652,-7391,-7846
	.word	-8000,-7846,-7391,-6652,-5657,-4444,-3061,-1561

dronemslo_t
	.word	4,10

	.endif


********************************
* Get boss dir to face an obj
* A0=X offset from ani pt
* A1=Y offset from ani pt
* A8=*Boss data struct
* A11=*Obj to follow
* Trashes A0-A3,A6-A7
*Rets:
* A0=Dir 0-31

 SUBRP	bossseeko_dir32

	move	*a11(OXPOS),a6		;A6=Plyr X
	addk	5,a6
	move	*a11(OYPOS),a7		;A7=^ Y

	move	*a8,a3,L		;Get * 1st boss obj
	move	*a3(OXPOS),a2
	addi	AX,a2			;+Ani pt X offset
	add	a2,a0
	move	*a3(OYPOS),a2
	addi	AY,a2			;-Ani pt Y offset
	add	a2,a1

	jruc	sodboss

********************************
* Get dir to face an object
* A0=*Dest obj
* A8=*Src obj
* Trashes A0-A3,A6-A7
* >A0=Dir 0-31

 SUBR	seekob_dir32

	move	*a0(OXPOS),a6		;Get DX
	move	*a0(OSIZEX),a2
	srl	1,a2
	add	a2,a6			;Center X
	move	*a0(OYPOS),a7		;Get DY
	move	*a0(OSIZEY),a2
	srl	1,a2
	add	a2,a7			;Center Y

	move	*a8(OXPOS),a0		;Get SX
	move	*a8(OYPOS),a1		;Get SY
	jruc	sod50

 SUBR	seekob_dir32la			;Look ahead

	move	*a0(OXPOS),a6		;Get DX
	move	*a0(OSIZEX),a2
	srl	1,a2
	add	a2,a6			;Center X
	move	*a0(OYPOS),a7		;Get DY
	move	*a0(OSIZEY),a2
	srl	1,a2
	add	a2,a7			;Center Y

	move	*a8(OXPOS),a0		;Get SX
	move	*a8(OYPOS),a1		;Get SY
	move	*a8(OXVEL),a2,L		;Calc new pos
	sra	16-2,a2			;*4
	add	a2,a0
	move	*a8(OYVEL),a2,L
	sra	16-2,a2			;*4
	add	a2,a1

sod50	move	*a8(OSIZEX),a2
	srl	1,a2
	add	a2,a0			;Center X
	move	*a8(OSIZEY),a2
	srl	1,a2
	add	a2,a1			;Center Y


 SUBR	sodboss		;A0/A1=Src XY, A6/A7=Dest XY

	clr	a2			;Octant 0-1
	sub	a6,a0			;A0=SrcX-DestX
	jrnn	sod100
	abs	a0
	sub	a7,a1			;A1=SrcY-DestY
	jrnn	sod200
	abs	a1
	jruc	sod160			;Oct 2-3

sod100	movk	16,a2			;Oct 4-5
	sub	a7,a1			;A1=SrcY-DestX
	abs	a1
	jrnn	sod200
sod160	addk	8,a2			;Oct 6-7
	SWAP	a0,a1

sod200	cmp	a1,a0			;>Cmp slope
	jrhs	sod300

	move	a0,a3
	sll	2,a0			;Smaller*4
	jruc	sod250
sod220	addk	1,a2			;Next 1/4 oct
	sub	a3,a0			;-1/4
sod250	cmp	a1,a0
	jrhi	sod220
	jruc	sod400

sod300	addk	7,a2			;End of next octant
	move	a1,a3
	sll	2,a1			;Smaller*4
	jruc	sod350
sod320	subk	1,a2			;Next 1/4 oct
	sub	a3,a1			;-1/4
sod350	cmp	a0,a1
	jrhi	sod320

sod400	movk	>1f,a0
	and	a2,a0
	rets				;>A0=Dir 0-31




********************************
* Nose flame throwers (Process)

 SUBRP	nose_flamers

	movi	PLYROBJS,a10
	movi	PLYRPRCS,a11

nflp	move	@larmstat,a0
	jrnn	nf200			;Arm still there?
	move	@rarmstat,a0
	jrnn	nf200			;^
	move	@bossz,a0,L
	jrnz	nf200			;Jump in progress?
	move	@bloflg,a0
	jrn	nf200			;Blow in progress?

	move	*a10,a8,L
	jrz	nf40
	move	*a11,a0,L
	move	*a0(DELYDET),a0
	jrnz	nf40
	callr	nose_proxchk
	jrc	nf100

nf40	move	*a10(32),a8,L
	jrz	nf200
	move	*a11(32),a0,L
	move	*a0(DELYDET),a0
	jrnz	nf200
	callr	nose_proxchk
	jrnc	nf200

nf100	move	@bossd_t,a8,L
	CREATE	BOSSPID,nose_flame4
	CREATE	BOSSPID,nose_flame8
	movk	1,a0
	move	a0,@bflmrstat		;On
	SLEEP	60*4
	clr	a0
	move	a0,@bflmrstat		;Off

nf200	SLEEPK	20
	jruc	nflp


********************************
* Check flamer proximity
*Rets: C=In box

 SUBRP	nose_proxchk

	calla	GETANIXY
	move	a2,a1
	move	a3,a0
	move	@bossd_t,a8,L
	calla	GETANIXY
	sub	a3,a0
	sub	a2,a1
	sra	16,a0
	sra	16,a1
	abs	a0
	cmpi	>62,a1		;check y coords
	jrls	npc40
	cmpi	>82,a1
	jrhs	npc40
	cmpi	>14,a0
	jrls	npc40
	cmpi	>40,a0
	jrhs	npc40
npc20	setc			;In box!
	rets

npc40	cmpi	>78,a1		;check further out box
	jrls	npc70
	cmpi	>98,a1
	jrhs	npc70
	cmpi	>34,a0
	jrls	npc70
	cmpi	>60,a0
	jrlo	npc20
npc70	clrc			;Not in box
	rets


********************************
* Create a nose flamer at 4 o'clock (Process)
* A8=*1st boss obj

 SUBRP	nose_flame4

	movi	DMAWNZ|M_PIXSCAN|M_FLIPH,a4
	move	*a8(OXPOS),a0
	subk	8,a0
	sll	16,a0
	move	*a8(OYPOS),a1
	addi	>29,a1
	sll	16,a1
	movk	4,a9
	jauc	DOIT

********************************
* Create a nose flamer at 8 o'clock (Process)
* A8=*1st boss obj

 SUBRP	nose_flame8

	movi	DMAWNZ|M_PIXSCAN,a4
	move	*a8(OXPOS),a0
	addk	8,a0
	sll	16,a0
	move	*a8(OYPOS),a1
	addi	>29,a1
	sll	16,a1
	movk	5,a9
	jauc	DOIT


********************************
* Boss gun controller (Process)
* A11=*Arm data struct


 SUBRP	gun

	move	*a11(GUNMODE),a0
	sll	32-3,a0		;Mask
	srl	32-3-5,a0	;*32
	addi	gunmd_t,a0
	move	*a0,a0,L
	jump	a0

gunmd_t	.long	grand,grand,gplayr,gplayr
	.long	gdown,gside,gsweep,gsweep


gunsk	clr	a9
	move	*a11(GUNNUM),a1
	jrz	gun10
	movk	6,a9
gun10	JSRP	gun_seek
	SLEEPK	1
	add	a9,a10
	CREATE	BOSSPID,shot_fire
	SLEEPK	4		;Wait for muzzle flash to finish
	move	*a11,a0		;Get status
	jrgt	gun		;On fire?
	movk	>f,a0
	callr	rnd
	jrnz	gun20		;Skip sleep?
	SLEEP	60
	movk	1,a0
	callr	rnd
	jrnz	gun20		;Skip sleep2?
	SLEEP	40
gun20	movk	4,a0
	callr	rndrng0
	addk	1,a0
	calla	PRCSLP		;1-5
	jruc	gun


grand	movk	5,a0		;>Shoot at random
	callr	rndrng0
	move	a0,a10
	jruc	gunsk


gplayr				;>Shoot at player
	callr	getplyr		;find player to seek
	jrz	gsweep		;No player?

	PUSH	a11
	move	a11,a7
	movi	bossd_t,a8	;Get boss pointer
	move	a0,a11
	movi	-70,a0		;X offset
	movi	aiml_t,a10
	move	*a7(GUNNUM),a1
	jrz	gun70
	neg	a0
	movi	aimr_t,a10
gun70	callr	gun_aim		;Get gun dir (A10)
	PULL	a11
	jruc	gunsk

gdown	movk	1,a10		;>Shoot down
	jruc	gunsk

gside	movk	5,a10		;>Shoot side
	jruc	gunsk

gsweep	move	*a11(GUNDIR),a10 ;>Sweep
	move	*a11(GUNSWP),a0	;Sweep direction flag
	jrz	gun200
	addk	1,a10
	cmpi	5,a10
	jrls	gunsk
	clr	a10
	move	a10,*a11(GUNSWP)
	movk	5,a10
gun200	subk	1,a10
	jrnn	gunsk
	move	a10,*a11(GUNSWP)
	movk	1,a10
	jruc	gunsk


********************************
* Aim gun
* A0=X offset of gun
* A8=Boss data struct
* A10=*Aim table
* A11=*Obj to follow
*Rets: A10=Gun dir 0-5

 SUBRP	gun_aim

	movi	82,a1		;Y offset
	callr	bossseeko_dir32
	sll	3,a0
	add	a10,a0
	movb	*a0,a10
	rets

aiml_t	.byte	5,5,5,5,0,0,0,0
	.byte	0,0,0,0,0,0,0,1
	.byte	1,2,2,3,3,4,4,5
	.byte	5,5,5,5,5,5,5,5

aimr_t	.byte	5,5,5,5,5,5,5,5
	.byte	5,4,4,3,3,2,2,1
	.byte	1,0,0,0,0,0,0,0		;Right aiming table for angles 0-31
	.byte	0,0,0,0,5,5,5,5


********************************
* Seek gun direction
* A9=Seek table offset (0/6)
* A10=Postion to seek 0-5
* A11=*Arm data struct

 SUBRP	gun_seek

	PUSHP	a8,a10
	movk	1,a8
	move	*a11(GUNDIR),a0
	sub	a0,a10
	jreq	gsx		;At position?
	jrnn	gs5		;Seek +?
	neg	a8
gs5	abs	a10

gslp	move	*a11(GUNDIR),a0
	add	a8,a0
	move	a0,*a11(GUNDIR)
	PUSH	a9
	add	a0,a9
	sll	4,a9		;*16
	addi	gunsk_t,a9
	callr	aniboss		;Animate into place
	PULL	a9
	SLEEPK	2
	dsj	a10,gslp

gsx	PULLP	a8,a10
	RETP


gunsk_t	.byte	ARML,-ARMR1
	.byte	ARML,-ARMDN
	.byte	ARML,-ARML1
	.byte	ARML,-ARML2
	.byte	ARML,-ARML3
	.byte	ARML,-ARML4
	.byte	ARMR,-ARMR1
	.byte	ARMR,-ARMDN
	.byte	ARMR,-ARML1
	.byte	ARMR,-ARML2
	.byte	ARMR,-ARML3
	.byte	ARMR,-ARML4


********************************
* Shoot bullet (Process)
* A10=Gun angle 0-11

 SUBRP	shot_fire

;	move	@HALT,a0
;	janz	SUCIDE			;No shoot on halt

	PUSH	a10
	sll	5,a10
	addi	gunrecoil_t,a10
	move	*a10,a9,L		;get animation
	movk	2,a10			;get time
	movi	armani_p,a11		;arm animation flag set
	CREATE	BOSSPID,aniseq
	PULL	a0

	sll	6,a0			;*64
	addi	bullet_t,a0		;Get offset table index
	move	*a0+,a4			;Get x offset from ani pt
	move	*a0+,a5			;Get y offset from ani pt
	move	*a0+,a6			;Get x vel
	sll	7,a6			;*128
	move	*a0+,a7			;Get y vel
	sll	7,a7			;*128
	move	@bossd_t,a8,L

	move	*a8(OXVEL),a2,L		;Add in boss velocity
	move	*a8(OYVEL),a3,L
	add	a2,a6
	add	a3,a7

	calla	GETANIXY		;A2=Y, A3=X animation point
	sll	16,a4
	sll	16,a5
	add	a4,a3
	add	a5,a2
	move	a3,a0			;oxval
	move	a2,a1			;oyval
	move	a0,a10
	move	a1,a11
	PUSH	a0,a1,a7
	CREATE	BOSSPID,gun_muzblast
	PULL	a0,a1,a7
	movi	GUNBUL,a2		;*IMG
	movi	160,a3			;Z
	movi	DMAWNZ,a4
	movi	CLSENMY+TYPGOO,a5
	movi	BURST,a10
	jauc	START_PJ


bullet_t	;Bullet table (XOFF,YOFF,XV,YV)

	.word	-35,148,>200,>400	;LGun dir 6
	.word	-73,155,0,>400		;LGun dir 1
	.word	-102,143,->200,>400	;LGun dir 2
	.word	-118,129,->300,>300	;LGun dir 3
	.word	-130,105,->400,>200	;LGun dir 4
	.word	-137,74,->400,0		;LGun dir 5

	.word	34,148,->200,>400	;RGun dir 6
	.word	72,155,0,>400		;RGun dir 1
	.word	101,143,>200,>400	;RGun dir 2
	.word	117,129,>300,>300	;RGun dir 3
	.word	129,105,>400,>200	;RGun dir 4
	.word	136,74,>400,0		;RGun dir 5


gunrecoil_t
	.long	LARMF6	;LEFT GUN ANGLE 6
	.long	LARMF1	;LEFT GUN ANGLE 1
	.long	LARMF2
	.long	LARMF3
	.long	LARMF4
	.long	LARMF5

	.long	RARMF6	;RIGHT GUN ANGLE 6
	.long	RARMF1	;RIGHT GUN ANGLE 1
	.long	RARMF2
	.long	RARMF3
	.long	RARMF4
	.long	RARMF5


********************************
* Gun muzzle blast
* A8=*1st boss obj, A10=X, A11=Y

 SUBRP	gun_muzblast

	move	a10,a0
	move	a11,a1
	movi	GNFR1,a2
	movi	181,a3			;Z
	movi	DMAWNZ|M_NOCOLL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	move	a8,a10
	calla	BEGINOBJ2
	movi	gnfr_l,a9

gmblp	move	*a10(OXVEL),a6,L	;get boss velocity for puffs
	move	*a10(OYVEL),a7,L
	move	a6,*a8(OXVEL),L
	move	a7,*a8(OYVEL),L
	clr	a1
	JSRP	FRANIM
	jrnc	gmblp

	jauc	DELOBJDIE

gnfr_l	LW	GNFR1,1
	LW	GNFR2,1
	LWL0	GNFR3,1


********************************
* Jumping thrusters
* A10=Burn time

 SUBRP	thrusters_fire

	movi	thrustlo_seq,a9
	callr	aniboss
	SLEEPK	2
	movi	thrusthi_seq,a9
	callr	aniboss
	SLEEPK	2
	movi	thrustnull_seq,a9
	callr	aniboss
	SLEEPK	2
	dsj	a10,thrusters_fire
	DIE

********************************
* Get * aniset based on dir
* A0=X offset from ani pt
* A1=Y offset from ani pt
* A8=*Boss data struct
* A9=*Animation table
* Trashes A11
*Rets:
* A9=*Animation set

 SUBRP	bossseekp_ani32

	PUSH	a0,a1
	callr	boss_getcloseplyr
	jrz	bspaerr
	move	a0,a11
	PULL	a0,a1
	callr	bossseeko_dir32
	sll	5,a0
	add	a0,a9
	move	*a9,a9,L
	rets

bspaerr	PULL	a0,a1
	move	*a9,a9,L	;Get 1st
	rets


********************************
* Add up total damage
*Rets: A0=Damage

	NOTINUSE

 SUBRP	damage_gettot

	PUSH	a1,a8
	clr	a0
	movi	bossd_t+32,a8

dt20	move	*a8(BODAM-32),a1
	add	a1,a0			;Add up
	addk	32,a8
	move	*a8+,a1,L
	jrnz	dt20			;More?

	PULL	a1,a8
	rets
	.endif

********************************
* Keep boss objects together

 SUBRP	boss_glue

	movi	bossd_t,a8		;A8=*Data block

	PUSH	a12,a13
	move	*a8+,a10,L		;first piece index
	move	a8,a9
	move	*a10(OIMG),a1,L
	move	*a10(OSIZE),a2,L
	move	*a10(OFLAGS),a4
	calla	GANIOF			;get x y ani offset
	move	a6,a12			;save x anioff
	move	a7,a13			;save y anioff
	jruc	bg40

bglp	move	*a8(OIMG),a1,L
	move	*a8(OSIZE),a2,L
	move	*a8(OFLAGS),a4
	calla	GANIOF			;get x y ani offset
	sub	a12,a6
	sub	a13,a7

	move	*a8(OID),a0		;get oid

	btst	B_FLIPH,a4		;Flip kludge ?
	jrz	bg5			;no...
	addi	>20000,a6		;adjust flip kludge
	cmpi	-CLSENMY|TYPFACE|SUBHD,a0
	jrne	bg5			;Little head?
	subi	>10000,a6

bg5	cmpi	CLSDEAD,a0		;Adjust shadow offset
	jrne	bg10
	move	@bossz,a0,L
	sub	a0,a7

bg10	move	*a10(OXVAL),a0,L
	sub	a6,a0
	move	a0,*a8(OXVAL),L
	move	*a10(OYVAL),a1,L
	sub	a7,a1
	move	a1,*a8(OYVAL),L

bg40	addk	32,a9
	move	*a9+,a8,L		;get next index
	jrnz	bglp			;More?

	PULL	a12,a13

	SLOOP	8,boss_glue


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
* Add Z change into boss objects
* A0=Z delta
* A8=*Boss data struct

 SUBRP	vel_setz

	PUSH	a2,a8
	jruc	vsz50

vszlp	move	*a2(OID),a1
	cmpi	CLSDEAD,a1
	jreq	vsz20			;Skip shadow?
	move	*a2(OYVAL),a1,L
	sub	a0,a1
	move	a1,*a2(OYVAL),L
vsz20	addk	32,a8
vsz50	move	*a8+,a2,L
	jrnz	vszlp			;More?

	PULL	a2,a8
	rets


********************************
* Set boss objects up hi
* A8=*Boss data struct

 SUBRP	boss_sethi

	PUSH	a2,a3,a4,a8
	jruc	bsh50

bshlp	move	*a2(OID),a1
	cmpi	CLSDEAD,a1
	jreq	bsh40			;Skip shadow?
	move	*a2(OZPOS),a1
	addk	20,a1
	move	a1,*a2(OZPOS)
bsh40	addk	32,a8
bsh50	move	*a8+,a2,L
	jrnz	bshlp			;More?

	PULL	a2,a3,a4,a8
	rets


********************************
* Set boss objects low Z
* A8=*Boss data struct

 SUBRP	boss_setlow

	PUSH	a2,a3,a8
	jruc	bsl50

bsllp	move	*a2(OID),a1
	cmpi	CLSDEAD,a1
	jreq	bsl40			;Skip shadow?
	move	*a2(OZPOS),a1
	subk	20,a1
	move	a1,*a2(OZPOS)
bsl40	addk	32,a8
bsl50	move	*a8+,a2,L
	jrnz	bsllp			;More?

	PULL	a2,a3,a8
	rets



********************************
* Random animator
* A1=*Ani table
* A2=*Aniflag

 SUBRP	ani_rnd

	PUSH	a9,a10,a11

	move	a2,a11		;save flag
	move	@RAND,a0
	movk	>f,a14
	and	a14,a0
	sll	4,a0		;*16
	move	a0,a9
	sll	1,a0
	add	a9,a0		;A0=*48
	add	a1,a0
	move	*a0+,a9,L
	move	*a0,a10
	CREATE	BOSSPID|SUBANI,aniseq

	PULL	a9,a10,a11
	rets


********************************
* Random sequence animator
* A1=*Animation table
* A2=*Animation flag

 SUBRP	randseq

	PUSH	a8,a11

	move	a2,a11			;Save flag
	move	@RAND,a0
	movk	>f,a14
	and	a14,a0
	sll	5,a0			;*32
	add	a1,a0
	move	*a0+,a8,L
	CREATE	BOSSPID|SUBANI,aniseqq
	move	a0,*a11,L		;Set flag for process now

	PULL	a8,a11
	rets

********************************
* aniseq (Process)
* A9=* Ani seq table
* A10=Sleep time
* A11=*Flag

 SUBRP	aniseq

	move	a13,*a11,L	;Set flag

aseqlp	move	*a9,a1
	jrz	aseqx		;Null frame?
	callr	aniboss
	move	a10,a0
	calla	PRCSLP
	jruc	aseqlp

aseqx	move	a1,*a11,L	;Clear flag
	DIE

********************************
* aniseqq (Process)
* A8=*Script index
* A11=*Flag

 SUBRP	aniseqq

	move	a13,*a11,L	;Set flag
aseqq5	move	*a8+,a9,L
	jrz	aseqqx		;End?
	move	*a8+,a10	;A10=Sleep time

aseqqlp	move	*a9,a1
	jrz	aseqq5		;Null frame?
	callr	aniboss
	move	a10,a0
	calla	PRCSLP
	jruc	aseqqlp

aseqqx	move	a9,*a11,L	;Clear flag
	DIE


********************************
* Animate boss monster
* A9=*Animation table
*Rets:
* A9=*Next frame

 SUBRP	aniboss

	PUSH	a2,a3,a4,a7,a8,a10,a11

	movi	bossd_t-64,a10		;Get object block
	subk	8,a9

ablp	addk	8,a9			;Next byte
	movb	*a9,a7			;Get part #
	sll	6,a7			;*64
	add	a10,a7
	move	*a7,a8,L		;A8=*Obj
	addk	8,a9			;Next byte
	movb	*a9,a1			;get new frame number
	abs	a1
	movb	a1,*a7(BOAFRM)

	movi	BDAMSIZE,a2
	mpyu	a2,a1			;x # entries
	addi	bossdam_t-BDAMSIZE,a1	;+Table base
	move	*a7(BODAM),a3		;Get damage level
	cmpi	47,a3
	jrls	ab60
	movi	47,a3			;Max damage
ab60	srl	4,a3			;/16
	sll	5,a3			;*32
	add	a3,a1			;+Damage level offset
	move	*a1,a1,L		;Get * new IMG

	move	*a8(OIMG),a4,L		;Get * old IMG
	move	*a4(ICMAP),a4,L		;*Pal
	move	*a1(ICMAP),a0,L		;^
	cmp	a0,a4
	jreq	ab90			;Same palette
	calla	GETFPAL
	move	a0,*a8(OPAL)		;Set new palette

ab90	move	*a8(OFLAGS),a4
	calla	ANI
	movb	*a9,a1
	jrnn	ablp			;More?

	addk	8,a9			;Next frame
	PULL	a2,a3,a4,a7,a8,a10,a11
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
* Get * to closest player legs obj
* A0/A1=XY offset
* A8=*Boss data struct
* Trashes A0-A7
* >A0=*Plyr legs obj or 0 (Pass Z)

 SUBRP	boss_getcloseplyr

	move	@PLYRPRCS,a2,L
	jrz	gcp400			;None?
	move	*a2(DEAD),a4
	jrnz	gcp400			;Dead?
	move	@PLYRPRCS+32,a3,L
	jrz	gcp450			;None?
	move	*a3(DEAD),a4
	jrnz	gcp450			;Dead?

	move	*a8,a4,L		;Get * 1st boss obj
	move	*a4(OXPOS),a6		;Get src XY
	move	*a4(OYPOS),a7
	addi	AX,a6			;+Ani pt X offset
	addi	AY,a7			;-Ani pt Y offset
	add	a0,a6			;+Offset
	add	a1,a7
	move	*a2(LEG_PTR),a0,L
	move	*a3(LEG_PTR),a1,L
	move	*a0(OXPOS),a4
	sub	a6,a4
	move	*a0(OYPOS),a5
	sub	a7,a5
	abs	a4
	abs	a5
	cmp	a5,a4
	jrhs	gcp50
	move	a5,a4			;A4=P1 distance

gcp50	move	*a1(OXPOS),a5
	sub	a6,a5
	move	*a1(OYPOS),a6
	sub	a7,a6
	abs	a5
	abs	a6
	cmp	a6,a5
	jrhs	gcp70
	move	a6,a5			;A5=P2 distance
gcp70	cmp	a5,a4
	jrls	gcp80			;P1 closer?
	move	a1,a0
gcp80	move	a0,a0
	rets

gcp400	move	@PLYRPRCS+32,a2,L	;P1 bad
	jrz	gcp800			;None?
	move	*a2(DEAD),a4
	jrnz	gcp800			;Dead?
gcp450	move	*a2(LEG_PTR),a0,L	;P2 bad
	rets

gcp800	clr	a0			;P1&P2 bad
	rets				;Pass Z


********************************
* Eye color cycler (Process)

 SUBRP	cycle_eye

	movi	>3b0001,a8	;A8=[color # to start at,# to cycle]
	movi	ORCP1,a9	;A9=pal name to cycle
	movi	eyecol_t,a10	;A10=table to cycle it with
	movk	3,a11		;A11=rate of cycle in ticks
	jauc	CYCLE_TABLE

eyecol_t
	COLORW	00,00,07, 00,00,13, 00,00,19, 00,00,25
	COLORW	00,00,31, 00,06,31, 00,12,31, 00,18,31
	COLORW	00,12,31, 00,06,31, 00,00,31, 00,00,25
	COLORW	00,00,19, 00,00,13
	.word	-1


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
* Animation scripts

*ANIMATION NUMBERS
MOUTHCL		.set	1	;MOUTH CLOSED
MOUTHOP1	.set	2	;MOUTH OPENING
MOUTHOP2	.set	3
MOUTHOP3	.set	4
EYEBLD		.set	5
EYECNT		.set	6	;EYES CENTER
EYECL1		.set	7	;EYES CLOSING
EYECL2		.set	8
EYEBUG		.set	9	;BUG EYES
EYERT1		.set	10	;EYES RIGHT
EYERT2		.set	11
EYELFT1		.set	12	;EYES LEFT
EYELFT2		.set	13
SIDE		.set	14
SHOULDER	.set	15
ARMDN		.set	16	;ARM DOWN
ARMDN1		.set	17	;ARM DOWN RECOIL
ARMDN2		.set	18
ARML1		.set	19	;ARM ROTATING TO LEFT
ARML2		.set	20
ARML3		.set	21
ARML4		.set	22
ARMR1		.set	23	;ARM ROTATING TO RIGHT
HDST		.set	24	;LITTLE HEAD STRAIGHT
HDFROWN		.set	25
HDROAR		.set	26
HDOOOH		.set	27
HDGRIN		.set	28
HDL1NT		.set	29	;LIL HEAD SLIGHT LEFT W/TEETH
HDL1T		.set	30
HDL2NT		.set	31
HDL2T		.set	32
HDL3		.set	33
HDL4		.set	34
HDL5		.set	35
NUSHD		.set	36
;free		.set	37
NULLOBJ		.set	38
TNG1		.set	39
TNG2		.set	40
TNG3		.set	41
TNG4		.set	42
TNG5		.set	43
TNGL		.set	44
TNGR		.set	45
NULLOBJ1	.set	46
ARMDNPT		.set	47
ARML1PT		.set	48
ARML2PT		.set	49
ARML3PT		.set	50
ARML4PT		.set	51
ARMR1PT		.set	52
THRUST1		.set	53
THRUST2		.set	54
HDRIPL		.set	55
TOPRIPL		.set	56
THRUSTNULL	.set	57
BASERIPA	.set	58
LSTANI		.set	58


MOUTHL	.set	1		;Part numbers
MOUTHR	.set	2
SIDEL	.set	3
SIDER	.set	4
EYEL	.set	5
EYER	.set	6
SHLDRL	.set	7
SHLDRR	.set	8
LILHD	.set	9		;LIL HEAD
ARML	.set	10
ARMR	.set	11
LILHDF	.set	14		;FLIPPED LIL HEAD
TONGUE	.set	15
THRUSTL	.set	16
THRUSTR	.set	17

*ANIANITB
*SEQ(32),TIME(16)

hddam_t	.long	frowner,frowner,frowner,frowner
	.long	grimmr,grimmr,grimmr,grimmr
	.long	oooher,oooher,oooher,oooher
	.long	oooher,oooher,oooher,oooher

grinner	LW	HDGRINA,15
	LW	HDGRINA,15
	LWL0	HDGRINA,15

frowner	LW	HDFRWNA,10
	LW	HDFRWNA,10
	LWL0	HDFRWNA,10

oooher	LW	HDOOOHA,30
	LWL0	HDOOOHA,20

grimmr	LW	HDGRIM,1
	LW	HDGRIM,1
	LW	HDGRIM,1
	LWL0	HDGRIM,1


eyequad_t			;Eyeball table
	.long	EYESCNT,EYESCNT,EYESCNT,EYESRT1
	.long	EYESRT1,EYESRT1,EYESRT2,EYESRT2
	.long	EYESRT2,EYESRT2,EYESRT2,EYESRT1
	.long	EYESRT1,EYESRT1,EYESCNT,EYESCNT
	.long	EYESCNT,EYESCNT,EYESCNT,EYESLFT1
	.long	EYESLFT1,EYESLFT1,EYESLFT2,EYESLFT2
	.long	EYESLFT2,EYESLFT2,EYESLFT2,EYESLFT1
	.long	EYESLFT1,EYESLFT1,EYESCNT,EYESCNT

hdquad_t			;Lil head table
	.long	HEAD225,HEAD225,HEAD225,HEAD225
	.long	HEAD225,HEAD270,HEAD270,HEAD270
	.long	HEAD270,HEAD270,HEAD300,HEAD300
	.long	HEAD330,HEAD330,HEAD330,HEAD0
	.long	HEAD0,HEAD0,HEAD30,HEAD30
	.long	HEAD30,HEAD60,HEAD60,HEAD90
	.long	HEAD90,HEAD90,HEAD90,HEAD90
	.long	HEAD135,HEAD135,HEAD135,HEAD135

eyedam_t
	.long	bugger,bugger,bugger,bugger
	.long	bugger,bugger,bugger,bugger
	.long	blinker,blinker,blinker,blinker
	.long	blinker,blinker,blinker,blinker


bugger	LW	EYESBLNK,1
	LW	EYESBUG,15
	LW	EYESBLNK,1
	LWL0	EYESBUG,15

blinker	LW	EYESBLNK,2
	LW	EYESBLNK,2
	LW	EYESBLNK,2
	LW	EYESBLNK,2
	LW	EYESBLNK,2
	LWL0	EYESBLNK,2

mouthrnd_t
	LW	TNGSTIKA,7
	LW	bite_seq,10
	LW	CHOMP3,2
	LW	CHOMP2,3
	LW	TNGSTIKA,7
	LW	bite_seq,10
	LW	CHOMP3,5
	LW	CHOMP2,1
	LW	TNGSTIKA,7
	LW	bite_seq,10
	LW	CHOMP3,5
	LW	CHOMP2,3
	LW	TNGSTIKA,7
	LW	bite_seq,10
	LW	TNGSTIKA,7
	LW	bite_seq,10


*ANIMATION TABLE
*PART #, ANI FRAME
*-=End of frame

*Thrust sequences

thrusthi_seq	.byte	THRUSTL,THRUST2,THRUSTR,-THRUST2
thrustlo_seq	.byte	THRUSTL,THRUST1,THRUSTR,-THRUST1
thrustnull_seq	.byte	THRUSTL,THRUSTNULL,THRUSTR,-THRUSTNULL


*OPEN MOUTH

bite_seq
	.byte	MOUTHL,MOUTHOP1,MOUTHR,-MOUTHOP1
	.byte	MOUTHL,MOUTHOP2,MOUTHR,-MOUTHOP2
	.byte	MOUTHL,MOUTHOP3,MOUTHR,-MOUTHOP3
	.byte	MOUTHL,MOUTHOP2,MOUTHR,-MOUTHOP2
	.byte	MOUTHL,MOUTHOP1,MOUTHR,-MOUTHOP1
BITECL	.byte	MOUTHL,MOUTHCL,MOUTHR,-MOUTHCL
	.word	0
CHOMP3	.byte	MOUTHL,MOUTHOP1,MOUTHR,-MOUTHOP1
	.byte	MOUTHL,MOUTHOP2,MOUTHR,-MOUTHOP2
	.byte	MOUTHL,MOUTHOP3,MOUTHR,-MOUTHOP3
	.byte	MOUTHL,MOUTHOP2,MOUTHR,-MOUTHOP2
	.byte	MOUTHL,MOUTHOP1,MOUTHR,-MOUTHOP1
	.byte	MOUTHL,MOUTHCL,MOUTHR,-MOUTHCL
CHOMP2	.byte	MOUTHL,MOUTHOP1,MOUTHR,-MOUTHOP1
	.byte	MOUTHL,MOUTHOP2,MOUTHR,-MOUTHOP2
	.byte	MOUTHL,MOUTHOP3,MOUTHR,-MOUTHOP3
	.byte	MOUTHL,MOUTHOP2,MOUTHR,-MOUTHOP2
	.byte	MOUTHL,MOUTHOP1,MOUTHR,-MOUTHOP1
	.byte	MOUTHL,MOUTHCL,MOUTHR,-MOUTHCL
	.byte	MOUTHL,MOUTHOP1,MOUTHR,-MOUTHOP1
	.byte	MOUTHL,MOUTHOP2,MOUTHR,-MOUTHOP2
	.byte	MOUTHL,MOUTHOP3,MOUTHR,-MOUTHOP3
	.byte	MOUTHL,MOUTHOP2,MOUTHR,-MOUTHOP2
	.byte	MOUTHL,MOUTHOP1,MOUTHR,-MOUTHOP1
	.byte	MOUTHL,MOUTHCL,MOUTHR,-MOUTHCL
	.word	0

*EYE ANIMATIONS

EYESBLNK
	.byte	EYEL,EYECL1,EYER,-EYECL1	;EYES HALF CLOSED
	.byte	EYEL,EYECL2,EYER,-EYECL2	;EYES CLOSED
	.byte	EYEL,EYECL2,EYER,-EYECL2	;EYES CLOSED
	.byte	EYEL,EYECL1,EYER,-EYECL1	;EYES HALF CLOSED
	.byte	EYEL,EYECNT,EYER,-EYECNT	;EYES CENTERED
	.word	0
EYESCNT	.byte	EYEL,EYECNT,EYER,-EYECNT	;EYES CENTERED
EYESLFT1
	.byte	EYEL,EYELFT1,EYER,-EYERT1	;EYES LEFT
EYESLFT2
	.byte	EYEL,EYELFT2,EYER,-EYERT2	;EYES LEFT EXTREME
	.byte	EYEL,EYELFT1,EYER,-EYERT1	;EYES LEFT
	.byte	EYEL,EYECNT,EYER,-EYECNT	;EYES CENTERED
EYESRT1	.byte	EYEL,EYERT1,EYER,-EYELFT1	;EYES RIGHT
EYESRT2	.byte	EYEL,EYERT2,EYER,-EYELFT2	;EYES RIGHT EXTREME
	.byte	EYEL,EYERT1,EYER,-EYELFT1	;EYES RIGHT
	.byte	EYEL,EYECNT,EYER,-EYECNT	;EYES CENTERED
	.word	0
EYESLT3	.byte	EYEL,EYELFT1,EYER,-EYERT1	;EYES LEFT
	.byte	EYEL,EYELFT2,EYER,-EYERT2	;EYES LEFT EXTREME
	.byte	EYEL,EYELFT1,EYER,-EYERT1	;EYES LEFT
	.byte	EYEL,EYECNT,EYER,-EYECNT	;EYES CENTERED
	.word	0



*BUGEYES
EYESBUG	.byte	EYEL,EYEBUG,EYER,-EYEBUG	;EYES BUGGED
	.byte	EYEL,EYECNT,EYER,-EYECNT	;EYES CENTERED
	.word	0
hdblo_seq	;Little head blown
	.byte	LILHD,HDRIPL,LILHDF,-NULLOBJ

shldrblo_seq	;Shoulders blown
	.byte	LILHD,NULLOBJ,LILHDF,NULLOBJ
	.byte	SHLDRL,TOPRIPL,SHLDRR,-TOPRIPL

bodyblo_seq
	.byte	ARML,NULLOBJ,ARMR,NULLOBJ
	.byte	EYEL,NULLOBJ,EYER,NULLOBJ
	.byte	SIDEL,NULLOBJ,SIDER,NULLOBJ
	.byte	TONGUE,NULLOBJ
	.byte	THRUSTL,THRUSTNULL,THRUSTR,THRUSTNULL
	.byte	SHLDRL,NULLOBJ,SHLDRR,NULLOBJ
	.byte	MOUTHL,BASERIPA,MOUTHR,-BASERIPA

*LITTLE HEAD ROTATE
HEAD30	.byte	LILHD,HDL1NT,LILHDF,-NULLOBJ
HEAD60	.byte	LILHD,HDL2NT,LILHDF,-NULLOBJ
HEAD90	.byte	LILHD,HDL3,LILHDF,-NULLOBJ
HEAD135	.byte	LILHD,HDL4,LILHDF,-NULLOBJ
HEAD225	.byte	LILHD,NULLOBJ,LILHDF,-HDL4
HEAD270	.byte	LILHD,NULLOBJ,LILHDF,-HDL3
HEAD300	.byte	LILHD,NULLOBJ,LILHDF,-HDL2NT
HEAD330	.byte	LILHD,NULLOBJ,LILHDF,-HDL1NT
HEAD0	.byte	LILHD,HDST,LILHDF,-NULLOBJ
	.word	0


HDGRIM	.byte	LILHD,HDL1T,LILHDF,-NULLOBJ
	.byte	LILHD,HDL2T,LILHDF,-NULLOBJ
	.byte	LILHD,HDL3,LILHDF,-NULLOBJ
	.byte	LILHD,HDL2T,LILHDF,-NULLOBJ
	.byte	LILHD,HDL1T,LILHDF,-NULLOBJ
	.byte	LILHD,HDST,LILHDF,-NULLOBJ
	.byte	LILHD,NULLOBJ,LILHDF,-HDL1T
	.byte	LILHD,NULLOBJ,LILHDF,-HDL2T
	.byte	LILHD,NULLOBJ,LILHDF,-HDL3
	.byte	LILHD,NULLOBJ,LILHDF,-HDL2T
	.byte	LILHD,NULLOBJ,LILHDF,-HDL1T
	.byte	LILHD,HDST,LILHDF,-NULLOBJ
	.word	0
*HEAD GRIN
HDGRINA	.byte	LILHD,HDGRIN,LILHDF,-NULLOBJ
	.byte	LILHD,HDST,LILHDF,-NULLOBJ
	.word	0
*HEAD OOOH
HDOOOHA	.byte	LILHD,HDOOOH,LILHDF,-NULLOBJ
	.byte	LILHD,HDST,LILHDF,-NULLOBJ
	.word	0
*HEAD FROWN
HDFRWNA	.byte	LILHD,HDFROWN,LILHDF,-NULLOBJ
	.byte	LILHD,HDST,LILHDF,-NULLOBJ
	.word	0

*LEFT ARM FIRE POS. 1
LARMF1
	.byte	ARML,-ARMDN1
	.byte	ARML,-ARMDN
	.word	0
*LEFT ARM FIRE POS. 2
LARMF2
	.byte	ARML,-ARML1PT
	.byte	ARML,-ARML1
	.word	0

*LEFT ARM FIRE POS. 3
LARMF3
	.byte	ARML,-ARML2PT
	.byte	ARML,-ARML2
	.word	0
*LEFT ARM FIRE POS. 4
LARMF4
	.byte	ARML,-ARML3PT
	.byte	ARML,-ARML3
	.word	0
*LEFT ARM FIRE POS. 5
LARMF5
	.byte	ARML,-ARML4PT
	.byte	ARML,-ARML4
	.word	0
*LEFT ARM FIRE POS. 6
LARMF6
	.byte	ARML,-ARMR1PT
	.byte	ARML,-ARMR1
	.word	0
*RT ARM FIRE POS. 1
RARMF1
	.byte	ARMR,-ARMDN1
	.byte	ARMR,-ARMDN
	.word	0
*RT ARM FIRE POS. 2
RARMF2
	.byte	ARMR,-ARML1PT
	.byte	ARMR,-ARML1
	.word	0
*RT ARM FIRE POS. 3
RARMF3
	.byte	ARMR,-ARML2PT
	.byte	ARMR,-ARML2
	.word	0

*RT ARM FIRE POS. 4
RARMF4
	.byte	ARMR,-ARML3PT
	.byte	ARMR,-ARML3
	.word	0

*RT ARM FIRE POS. 5
RARMF5
	.byte	ARMR,-ARML4PT
	.byte	ARMR,-ARML4
	.word	0

*RT ARM FIRE POS. 6
RARMF6
	.byte	ARMR,-ARMR1PT
	.byte	ARMR,-ARMR1
	.word	0

*ARM FIRE SEQUENCE
ARMFIRE
	.byte	ARML,ARMR1,ARMR,-ARMR1
	.byte	ARML,ARMR1PT,ARMR,-ARMR1PT
	.byte	ARML,ARMR1,ARMR,-ARMR1
	.byte	ARML,ARMDN,ARMR,-ARMDN
	.byte	ARML,ARMDNPT,ARMR,-ARMDNPT
	.byte	ARML,ARMDN,ARMR,-ARMDN
	.byte	ARML,ARML1,ARMR,-ARML1
	.byte	ARML,ARML1PT,ARMR,-ARML1PT
	.byte	ARML,ARML1,ARMR,-ARML1
	.byte	ARML,ARML2,ARMR,-ARML2
	.byte	ARML,ARML2PT,ARMR,-ARML2PT
	.byte	ARML,ARML2,ARMR,-ARML2
	.byte	ARML,ARML3,ARMR,-ARML3
	.byte	ARML,ARML3PT,ARMR,-ARML3PT
	.byte	ARML,ARML3,ARMR,-ARML3
	.byte	ARML,ARML4,ARMR,-ARML4
	.byte	ARML,ARML4PT,ARMR,-ARML4PT
	.byte	ARML,ARML4,ARMR,-ARML4
	.byte	ARML,ARML3,ARMR,-ARML3
	.byte	ARML,ARML2,ARMR,-ARML2
	.byte	ARML,ARML1,ARMR,-ARML1
	.byte	ARML,ARMDN,ARMR,-ARMDN
	.word	0
*TONGUE STICK OUT
TNGSTIKA
	.byte	MOUTHL,MOUTHOP1,MOUTHR,-MOUTHOP1
	.byte	MOUTHL,MOUTHOP2,MOUTHR,-MOUTHOP2
	.byte	MOUTHL,MOUTHOP3,MOUTHR,-MOUTHOP3
	.byte	TONGUE,-TNG1
	.byte	TONGUE,-TNG2
	.byte	TONGUE,-TNG3
	.byte	TONGUE,-TNG4
	.byte	TONGUE,-TNG5
	.byte	TONGUE,-TNGL
	.byte	TONGUE,-TNGR
	.byte	TONGUE,-TNGL
	.byte	TONGUE,-TNGR
	.byte	TONGUE,-TNG5
	.byte	TONGUE,-TNG4
	.byte	TONGUE,-TNG3
	.byte	TONGUE,-TNG2
	.byte	TONGUE,-TNG1
	.byte	TONGUE,-NULLOBJ1
	.byte	MOUTHL,MOUTHOP2,MOUTHR,-MOUTHOP2
	.byte	MOUTHL,MOUTHOP1,MOUTHR,-MOUTHOP1
	.byte	MOUTHL,MOUTHCL,MOUTHR,-MOUTHCL
	.word	0

********************************
* Boss damage table
* 0-255

BDAMSIZE	.equ	32*3

bossdam_t
	.long	OMTH1,OMTH1A,OMTH1B	;1 MOUTH CLOSED
	.long	OMTH2,OMTH2A,OMTH2B	;2 MOUTH SLIGHTLY OPEN
	.long	OMTH3,OMTH3A,OMTH3B	;3 MOUTH MORE OPEN
	.long	OMTH4,OMTH4A,OMTH4B	;4 MOUTH MORE OPEN
	.long	OEYES1C,OEYES1C,OEYES1C	;5 BLOODY EYE
	.long	OEYES1,OEYES1A,OEYES1C	;6 EYE CENTERED
	.long	OEYES1A,OEYES1A,OEYES1C	;7 EYE HALF CLOSED
	.long	OEYES1B,OEYES1A,OEYES1C	;8 EYE CLOSED
	.long	OEYES2,OEYES1A,OEYES1C	;9 EYE BUGGED OPEN CENTERED
	.long	OEYES3,OEYES1A,OEYES1C	;10 EYE HALF RIGHT
	.long	OEYES4,OEYES1A,OEYES1C	;11 EYE RIGHT
	.long	OEYES3A,OEYES1A,OEYES1C	;12 EYE HALF LEFT
	.long	OEYES4A,OEYES1A,OEYES1C	;13 EYE LEFT
	.long	SIDEPC,SIDEPC,SIDEPC	;14 SIDE OF CHEEK
	.long	SHLDR,SHLDR,SHLDR	;15 SHOULDER STRAP
	.long	OARM1,ARMRIP,NULO	;16 ARM DOWN
	.long	OARM1A,ARMRIP,NULO	;17 ARM DOWN PARTIAL RECOIL
	.long	OARM1B,ARMRIP,NULO	;18 ARM DOWN FULL RECOIL
	.long	OARM2,ARMRIP,NULO	;19 ARM SLIGHT ANGLE LEFT
	.long	OARM3,ARMRIP,NULO	;20 ARM MORE ANGLE LEFT
	.long	OARM4,ARMRIP,NULO	;21 ARM EVEN MORE ANGLE LEFT
	.long	OARM5,ARMRIP,NULO	;22 ARM FULL LEFT HORIZONTAL
	.long	OARM6,ARMRIP,NULO	;23 ARM SLIGHT ANGLE RIGHT
	.long	ORCHD1,ORCHD1,ORCHD1	;24 LITTLE HEAD STRAIGHT FACE
	.long	ORCHD1A,ORCHD1A,ORCHD1A	;25 LITTLE HEAD FROWN FACE
	.long	ORCHD1B,ORCHD1B,ORCHD1B	;26 LITTLE HEAD ROAR FACE
	.long	ORCHD1C,ORCHD1C,ORCHD1C	;27 LITTLE HEAD OOOOHHH FACE
	.long	ORCHD1D,ORCHD1D,ORCHD1D	;28 LITTLE HEAD TOOTHY GRIN FACE
	.long	ORCHD2,ORCHD2,ORCHD2	;29 LITTLE HEAD SLIGHTLY LEFT FACE (NO TEETH)
	.long	ORCHD2A,ORCHD2A,ORCHD2A	;30 LITTLE HEAD SLIGHTLY LEFT FACE (TEETH)
	.long	ORCHD3,ORCHD3,ORCHD3	;31 LITTLE HEAD 45 LEFT FACE (NO TEETH)
	.long	ORCHD3A,ORCHD3A,ORCHD3A	;32 LITTLE HEAD 45 LEFT FACE (TEETH)
	.long	ORCHD4,ORCHD4,ORCHD4	;33 LIL HEAD 60
	.long	ORCHD5,ORCHD5,ORCHD5	;34 LIL HEAD 90
	.long	ORCHD6,ORCHD6,ORCHD6	;35 LIL HEAD 135
	.long	NUSHAD,NUSHAD,NUSHAD	;36 SHADOW
	.long	NULO,NULO,NULO		;37 SIDE SHADOW was> OSHAD2,OSHAD2,OSHAD2
	.long	NULO,NULO,NULO		;38 NULL OBJECT
	.long	TUNG1D,TUNG1D,TUNG1D	;39 TONGUE SMALLEST
	.long	TUNG1C,TUNG1C,TUNG1C	;40 TONGUE NEXT SMALLEST
	.long	TUNG1B,TUNG1B,TUNG1B	;41 TONGUE NEXT SMALLEST
	.long	TUNG1A,TUNG1A,TUNG1A	;42 TONGUE NEXT SMALLEST
	.long	TUNG1,TUNG1,TUNG1	;43 TONGUE FULL SIZE
	.long	TUNG2,TUNG2,TUNG2	;44 TONGUE FULL SIZE CURVE TO LEFT
	.long	TUNG3,TUNG3,TUNG3	;45 TONGUE FULL SIZE CURVE TO RIGHT
	.long	NULO1,NULO1,NULO1	;46 TONGUE NULL
	.long	OARM1PT,OARM1PT,ARMRIP	;47 ARM1 FIRE ANI
	.long	OARM2PT,OARM2PT,ARMRIP	;48 ARM2 FIRE ANI
	.long	OARM3PT,OARM3PT,ARMRIP	;49 ARM3 FIRE ANI
	.long	OARM4PT,OARM4PT,ARMRIP	;50 ARM4 FIRE ANI
	.long	OARM5PT,OARM5PT,ARMRIP	;51 ARM5 FIRE ANI
	.long	OARM6PT,OARM6PT,ARMRIP	;52 ARM6 FIRE ANI
	.long	ORCFLM1,ORCFLM1,ORCFLM1	;53 FLAME 1
	.long	ORCFLM2,ORCFLM2,ORCFLM2	;54 FLAME 2
	.long	HDRIP,HDRIP,HDRIP	;55 HEAD RIPPED LEFT
	.long	TOPRIP,TOPRIP,TOPRIP	;56 TOP (SHOULDERS) RIPPED OFF
	.long	THRSTNL,THRSTNL,THRSTNL	;57 Thrust null
	.long	BASERIP,BASERIP,BASERIP	;58 BASE RIP



********************************
* Initialize boss
* A0=X, A1=Y, A11=Damage level

 SUBRP	boss_init

	PUSH	a2,a3,a12,a13
	movi	boss_t,a12		;A12=*Init data
	movi	bossd_t,a13

binlp	move	*a12+,a4		;Get OFLAGS
	jrz	binx			;End?
	move	*a12+,a5		;OID
	zext	a5

	move	*a12+,a6		;Get ani frame #
	move	a6,*a13(BODAMR)		;Set damage resistance & frame #
	srl	8,a6			;Dump BODAMR
	subk	1,a6
	movi	BDAMSIZE,a7
	mpyu	a6,a7			;adjust for length of entry
	addi	bossdam_t,a7		;add table base
	move	*a7,a2,L		;get oimg pointer

	clr	a6			;XV
	clr	a7			;YV
	move	*a12+,a3		;Z
	PUSH	a0
	CALLA	BEGINOBJ2
	PULL	a0
	move	a13,*a8(OPLINK),L	;Link object to block structure
	move	a11,*a13(BODAM)		;Set damage level
	move	a8,*a13+,L		;Save pointer to obj
	addk	32,a13
	jruc	binlp

binx	clr	a0
	move	a0,*a13,L		;Zero last pointer to mark end
	PULL	a2,a3,a12,a13
	CREATE	BOSSPID,boss_glue	;Keep boss together

	rets


* Boss initial data table

boss_t
*PART 1 LEFT MOUTH
	.word	DMAWNZ+M_PIXSCAN		;Flags
	.word	CLSENMY|TYPFACE|SUBMTHL		;Type
	.byte	-1,MOUTHCL			;Damage resistance, Ani#
	.word	159				;Z
*PART 2 RIGHT MOUTH
	.word	DMAWNZ+M_PIXSCAN+M_FLIPH
	.word	CLSENMY|TYPFACE|SUBMTHR
	.byte	-1,MOUTHCL
	.word	159
*PART 3 LEFT SIDE PIECE
	.word	DMAWNZ+M_PIXSCAN
	.word	CLSENMY|TYPFACE|SUBSIDEL
	.byte	0,SIDE
	.word	159
*PART 4 RT SIDE PIECE
	.word	DMAWNZ+M_PIXSCAN+M_FLIPH
	.word	CLSENMY|TYPFACE|SUBSIDER
	.byte	0,SIDE
	.word	159
*PART 5 LEFT EYE
	.word	DMAWNZ
	.word	CLSENMY|TYPFACE|SUBEL
	.byte	0,EYECNT
	.word	160
*PART 6 RIGHT EYE
	.word	DMAWNZ+M_FLIPH
	.word	CLSENMY|TYPFACE|SUBER
	.byte	0,EYECNT
	.word	160
*PART 7 LEFT SHOULDER
	.word	DMAWNZ
	.word	CLSENMY|TYPFACE|SUBSHLDL
	.byte	0,SHOULDER
	.word	163
*PART 8 RT SHOULDER
	.word	DMAWNZ+M_FLIPH
	.word	CLSENMY|TYPFACE|SUBSHLDR
	.byte	0,SHOULDER
	.word	163
*PART 9 LIL HEAD
	.word	DMAWNZ
	.word	CLSENMY|TYPFACE|SUBHD
	.byte	0,HDST
	.word	163
*PART 10 LEFT ARM
	.word	DMAWNZ+M_PIXSCAN
	.word	CLSENMY|TYPFACE|SUBARML
	.byte	-1,ARMDN
	.word	160
*PART 11 RIGHT ARM
	.word	DMAWNZ+M_PIXSCAN+M_FLIPH
	.word	CLSENMY|TYPFACE|SUBARMR
	.byte	-1,ARMDN
	.word	160
*PART 12 LEFT SHADOW
	.word	DMACNZ+M_NOCOLL
	.word	CLSDEAD
	.byte	0,NUSHD
	.word	150
*PART 13 RIGHT SHADOW
	.word	DMACNZ+M_NOCOLL+M_FLIPH
	.word	CLSDEAD
	.byte	0,NUSHD
	.word	150
*PART 14 LIL HEAD FLIPPED
	.word	DMAWNZ+M_FLIPH
	.word	CLSENMY|TYPFACE|SUBHD
	.byte	0,NULLOBJ
	.word	162
*PART 15 TONGUE
	.word	DMAWNZ
	.word	CLSENMY|TYPFACE|SUBTUNG
	.byte	0,NULLOBJ1
	.word	160
*PART 16 LEFT FLAME
	.word	DMAWNZ
	.word	CLSENMY|TYPFACE|SUBFLAM
	.byte	0,THRUSTNULL
	.word	158
*PART 17 RT FLAME
	.word	DMAWNZ+M_FLIPH
	.word	CLSENMY|TYPFACE|SUBFLAM
	.byte	0,THRUSTNULL
	.word	158
	.word	0


;Null object definition
;Lil head null
NULO	.word	1,1,1000,-8		;Off screen
	.long	IROM
	.long	ORCP1
;Tung null
NULO1	.word	1,1,11,-118
	.long	IROM
	.long	RIPAL
;Thrust null
THRSTNL	.word	1,1,1000,-118
	.long	IROM
	.long	BLUBOOM




	.end
