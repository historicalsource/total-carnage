**************************************************************
*
* Software:		Shawn Liptak
* Initiated:		June 27,1991
*
* Modified:		!
*
* COPYRIGHT (C) 1991 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 12/19/91 23:04
**************************************************************
      	.FILE	'SHAWN.ASM'
	.TITLE	'TOTAL CARNAGE GAME PROGRAM'
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

	.include	"mproc.equ"
	.include	"disp.equ"
	.include	"\video\sys\sys.inc"
	.include	"\video\sys\gsp.inc"
	.include	"game.equ"
	.include	"imgtbl.glo"
	.include	"shawn.hdr"
	.include	"shawn.tbl"


;sound headers used

	.ref	ALTEXP1,EXP1L,SQUISH
	.ref	AGLSEXP,GLSEXP,NOWAY

mslexpsnd	.word	>f480,20,>8048,0	;Missile explosion
walksnd		.word	>f4E0,10,>812E,0	;Spidermom walk
flingsnd	.word	>f38e,>18,>8080,0	;Spider fling snd
crashsnd	.word	>fcf5,68,>8038,0	;Car crash explosion

;symbols externally defined

	.ref	WAVE,PCNT,TINGSND
	.ref	ANI,FRANIM,FRANIMQ,BEGINOBJ,BEGINOBJ2,PLYRPRCS,CK_GOOB
	.ref	XBOOM2,BOOM3,STATUS,EXP3,SKIPR_DN
	.ref	GET_WVADDR,RANDPER,SLOW_DWN,RANGRAND
	.ref	FIEND,getcloseplyr,FLASHME,DO_PUNISH
	.ref	SKIPR_CNT,EXPCNT
	.ref	OUT_FLG
	.ref	SCRADD2,P1DATA,P2DATA
	.ref	CHUNK_OBJ,PCTOT
	.ref	INHERE
	.ref	GETFPAL
	.ref	HULK_CNT,SHULK
	.ref	BLUEEXP,FIREEXP
	.ref	SHAKER,SBSND,SBOMB,bombn_killp,PLYROBJS
	.ref	HALT,FB_FADEIN,FB_FADEOUT,FADEIN,FADEOUT,PAL_TOWHT,PAL_FMWHT
	.ref	COLCYC,CYCLEON
	.ref	RNDRNGS
	.ref	CLNPAL
	.ref	digit_t,WTIMER0
	.ref	SKGHXT,SHXT

;symbols defined in this file

	.def	CIRCL_FLG,LOTS_FLAG
	.def	WINNER,WVBONUS,LOSER
	.def	NEUTRONB,bombnon
	.def	DONT_WARP

;uninitialized ram definitions

	.bss	CIRCL_FLG	,16
	.bss	bombnpalmem1	,5*16*2		;Cycle mem
	.bss	bombnpalmem2	,5*16*2		;^
	.bss	bombnon		,16		;!0=Neutron bomb active
	.bss	IN_BOMB		,16		;FLAG FOR BMB IN PROGRESS
	.bss	LOTS_FLAG 	,16		;FLAG FOR BARRAGE OF BMBS
	.bss	DONT_WARP,16

	.text


********************************
* Start a spider baby (Process)
* A9=[Y,X] spot to spawn from
* A10=Direction (1-8)

 SUBR	GSKIPR

	MOVE	A10,A0
	SLL	5,A0
	ADDI	SKGHXT,A0
	MOVE	*A0,A4,L
	MOVE	*A4+,A2,W
	MOVE	A2,B0
	MOVE	*A4+,A2,W
	MOVE	A2,B1
	CALLA	RANGRAND
	SLL	16,A0
	ADD	A9,A0
	MOVE	A0,A1
	MOVE	*A4+,A2,W
	MOVE	A2,B0
	MOVE	*A4+,A2,W
	MOVE	A2,B1
	CALLA	RANGRAND
	MOVX	A9,A2
	ADD	A0,A2
	SLL	16,A2
	MOVE	A2,A0		;NEED A0=[X,0000],A1=[Y,0000]
	jruc	spidb_start

********************************
* Start a spider baby (Process)
* A8=1-4 for grunt # for this release
* A9=[Y,X] spot to spawn from
* A10=Direction (1-8)

 SUBR	ASKIPR

	MOVE	A10,A0
	SLL	5,A0
	ADDI	SHXT,A0
	MOVE	*A0,A4,L
	SLL	6,A8
	ADD	A8,A4
	MOVE	*A4+,A1,L	;GET Y FIRST
	ADD	A9,A1
	SLL	16,A9
	MOVE	*A4,A0,L
	ADD	A9,A0		;NEED A0=[X,0000],A1=[Y,0000]
	jruc	spidb_start


********************************
* Send bingo obj to scoreboard

 SUBR	DOBINGO

	move	*a10(PNUM),a10
	subk	1,a10
	move	*a8(OXVAL),a0,L
	move	*a8(OYVAL),a1,L
	movi	BINGO,a2		;*IMG
	movi	DMAWNZ|M_NOCOLL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	movi	460,a3			;Z
	calla	BEGINOBJ2		;No world added in
	calla	CYCLEON
	SLEEP	90
	clr	a11
	jauc	INHERE

 SUBR	DODUD

	move	*a10(PNUM),a10
	subk	1,a10
	move	*a8(OXVAL),a0,L
	move	*a8(OYVAL),a1,L
	movi	DUD,a2		;*IMG
	movi	DMAWNZ|M_NOCOLL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	movi	500,a3			;Z
	calla	BEGINOBJ2		;No world added in
	calla	CYCLEON
	SLEEP	90
	movi	NOWAY,a0
	calla	ONESND
	jauc	DELOBJDIE


********************************
* Enemy spawner for testing


; SUBR	DO_SHAWN
;
;	movi	eyemaker_t,a8
;	CREATE	0,eye
;	movi	morttnk_t,a8
;	CREATE	0,morttnk
;	movi	morttnk2_t,a8
;	CREATE	0,morttnk
;	movi	spitter_t,a8
;	CREATE	0,spitter
;	movi	msltnk_t,a8
;	CREATE	0,msltnk
;	CREATE0	mslstrike
;	DIE

;eyemaker_t
;	.word	200,90,50,DMAWNZ,CLSENMY
;	.long	PDOME
;morttnk_t
;	.word	30,150,158,DMAWNZ,CLSENMY
;	.long	MTNK6
;morttnk2_t
;	.word	370,150,158,DMAWNZ,CLSENMY
;	.long	MTNK6
;spitter_t
;	.word	50,100,158,DMAWNZ,CLSENMY
;	.long	SPITR1
;msltnk_t
;	.word	30,150,158,DMAWNZ,CLSENMY
;	.long	MTNK6


********************************
* Slime pool (Process)

	WORDPD	slimex,0
	WORDPD	slimey,1

 SUBR	POND

	movi	DMAWNZ+M_NOCOLL,a0
	move	a0,*a8(OFLAGS)		;Collisions off
	movi	CLSDEAD,a0
	move	a0,*a8(OID)
	movi	50,a0
	move	a0,*a8(OZPOS)

sp100	SLEEPK	1
  	MOVE	@HALT,A0
	jrnz	sp100
	movi	>ff,a0
	callr	rnd
	addk	20,a0
	calla	PRCSLP		;SLEEP some
	movk	3,a0
	callr	rnd
	btst	1,a0		;Rnd mode
	jrnz	sp500

	move	a0,a11		;>At player 0-1
	movi	slimepat_t,a9
	movk	7,a0
	callr	rnd
	addk	1,a0
	move	a0,a10		;Loop 1-8
sp200	PUSH	a10
	movi	goob_l,a10
	callr	bloop_snd
	CREATE	shawnpid,mortar_atp
	PULL	a10
	addk	32,a9		;Next slot
	movk	>1f,a0
	callr	rnd
	jrz	sp300
	calla	PRCSLP		;SLEEP 0-31
sp300	dsj	a10,sp200
	jruc	sp800

sp500
	move	@HULK_CNT,a0	;If hulk_cnt+aircnt too many don't do circle!
	subk	12,a0
	jrge	sp550
	move	@CIRCL_FLG,a0
	jrnz	sp550

	movk	1,a0
	callr	rnd
	jrz	sp600		;50% do circle

sp550	move	a13,a9		;>Random shot
	addi	slimex,a9
	movi	>ff,a0
	callr	rnd
	subi	>7f,a0
	move	a0,*a9		;X
	movi	>7f,a0
	callr	rnd
	subi	>3f,a0
	move	a0,*a9(16)	;Y
	movi	goob_l,a10
	CREATE	shawnpid,mortar_relsrc
	callr	bloop_snd
	jruc	sp800

sp600	movi	slimepat2_t-512,a9	;>Circle pattern
  	movk	1,a0
	move	a0,@CIRCL_FLG
sp605	movk	3,a0
	callr	rnd
	jrz	sp605
	sll	9,a0			;*512
	add	a0,a9

	movi	bubl1snd,a0	
	calla	ONESND
	movk	2,a11
sp610	movk	16,a10
sp620	PUSH	a10
	movi	goob_l,a10
	CREATE	shawnpid,mortar_relsrc
	PULL	a10
	addk	32,a9
	dsj	a10,sp620
	SLEEP	40
	movi	bubl2snd,a0	
	calla	ONESND
	dsj	a11,sp610

	SLEEP	60*3			;Wait a while
	movi	bubl1snd,a0	
	calla	ONESND
	SLEEP	60*5			;Wait a while
	clr	a0
	move	a0,@CIRCL_FLG

sp800	move	@SCRNTL,a2,L		;Get screen top left
	move	@SCRNLR,a3,L		;Get screen lower rgt
	movi	[40,40],a1
	subxy	a1,a2	     
	addxy	a1,a3
	calla	SCRTSTG
	jrz	sp100			;Continue till scroll off bottom

	jauc	DELOBJDIE


slimepat_t
	.word	0,0, -30,-20, 30,20, -30,20, 30,-20, -40,0, 40,0, 0,0

slimepat2_t
	.word	0,-80,30,-74,56,-56,74,-30
	.word	80,0,74,30,56,56,30,74
	.word	0,80,-30,74,-56,56,-74,30
	.word	-80,0,-74,-30,-56,-56,-30,-74

	.word	0,-60,23,-55,42,-42,55,-23
	.word	60,0,55,23,42,42,23,55
	.word	0,60,-23,55,-42,42,-55,23
	.word	-60,0,-55,-23,-42,-42,-23,-55

	.word	0,-40,15,-37,28,-28,37,-15
	.word	40,0,37,15,28,28,15,37
	.word	0,40,-15,37,-28,28,-37,15
	.word	-40,0,-37,-15,-28,-28,-15,-37

	.word	0,-30,11,-28,21,-21,28,-11
	.word	30,0,28,11,21,21,11,28
	.word	0,30,-11,28,-21,21,-28,11
	.word	-30,0,-28,-11,-21,-21,-11,-28

goob_l	.long	slimeburst_l
	LW	GOOB1,4
	LW	GOOB2,4
	LW	GOOB3,5
	LW	GOOB4,6
	LW	GOOB5,7
	LW	GOOB6,8
	LW	GOOB7,6
	LW	GOOB8,4
	LW	GOOB7,4
	LW	GOOB6,8
	LW	GOOB5,8
	LW	GOOB4,6
	LW	GOOB3,5
	LW	GOOB2,4
	LWL0	GOOB1,3
	.word	DMAWNZ+M_NOCOLL
	.long	slimesplat_l

slimeburst_l
	LW	GBLOB1,10
	LW	GBLOB2,10
	LW	GBLOB3,10
	LWL0	GBLOB4,10
slimesplat_l
	LW	GOOB9,10
	LWL0	GOOB10,10


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

bubl1snd 	.word	>f5e5,20,>8131,0	;Blood bubbling
bubl2snd	.word	>f0e5,20,>8130,0	;^
blp1snd		.word	>f575,20,>8134,0	;Bloop snd
blp2snd		.word	>f575,20,>8136,0	;
blp3snd		.word	>f575,20,>8138,0	;
blp4snd		.word	>f575,20,>813a,0	;


********************************
* Eye (Process)

	WORDPD	eyex,0
	WORDPD	eyey,1

 SUBRP	eye

	callr	obj_get
e100	movi	>7f,a0
	callr	rnd
	calla	PRCSLP		;SLEEP some
	movk	3,a0
	callr	rnd
	btst	1,a0		;Rnd mode
	jrnz	e500

	move	a0,a11		;>At player 0-1
	movi	eyepat_t,a9
	movk	>f,a0
	callr	rnd
	addk	1,a0
	move	a0,a10		;Loop 1-16
e200	PUSH	a10
	movi	eye_l,a10
	CREATE	shawnpid,mortar_atpnoa
	movk	5,a1
	move	a1,*a0(msinea)
	PULL	a10
	addk	32,a9		;Next slot
	movk	>f,a0
	callr	rnd
	jrz	e300
	calla	PRCSLP		;SLEEP 0-31
e300	dsj	a10,e200
	jruc	e800

e500	movk	7,a0
	callr	rnd
	jrz	e600		;13% do circle

	move	a13,a9		;>Random shot
	addi	eyex,a9
	movi	>ff,a0
	callr	rnd
	subi	>7f,a0
	move	a0,*a9		;X
	movi	>7f,a0
	callr	rnd
	subi	>3f,a0
	move	a0,*a9(16)	;Y
	PUSH	a10
	movi	eye_l,a10
	CREATE	shawnpid,mortar_relsrcnoa
	movk	5,a1
	move	a1,*a0(msinea)
	PULL	a10
	jruc	e800

e600	movi	eyepat2_t,a9	;>Circle pattern
	movk	16,a10
e620	PUSH	a10
	movi	eye_l,a10
	CREATE	shawnpid,mortar_relsrcnoa
	movk	5,a1
	move	a1,*a0(msinea)
	PULL	a10
	addk	32,a9
	dsj	a10,e620

e800	move	@WORLDTLY+16,a0
	move	*a8(OYPOS),a1
	subi	250,a1
	cmp	a0,a1
	jrlt	e100		;Continue till scroll off bottom

	jauc	DELOBJDIE


eyepat_t
	.word	0,0, -30,-20, 30,20, -30,20, 30,-20, -40,0, 40,0, 0,0

eyepat2_t
	.word	0,-80, 31,-74, 57,-57, 74,-31, 80,0, 74,31, 57,57, 31,74
	.word	0,80, -31,74, -57,57, -74,31, -80,0, -74,-31, -57,-57, -31,-74

eye_l	.long	eyeburst_l
	LW	I1,1
	LW	I2,2
	LW	I3,4
	LW	I4,8
	LW	I5,12
	LW	I6,14
	LW	I6,14
	LW	I5,12
	LW	I4,8
	LW	I3,4
	LW	I2,2
	LWL0	I1,1
	.word	DMAWNZ+M_NOCOLL
	.long	eyesplat_l

eyeburst_l
	LWL0	GOOB9,10
eyesplat_l
	LWL0	GOOB9,10



;ARE WE USING THIS STUFF?
********************************
* Mortar tank (Process)

 SUBRP	morttnk
	callr	obj_get
	movi	-1,a11
mt100	movi	>ff,a0
	callr	rnd
;	movk	7,a0		;DEBUG
	calla	PRCSLP
	movk	5,a10		;#Shots in pattern
	movi	mortpat_t,a9
mt200	PUSH	a10
	movi	mortar_l,a10
	CREATE	shawnpid,mortar_atp
	PULL	a10
	addk	32,a9
;	SLEEPK	1
	dsj	a10,mt200
	dsj	a11,mt100
	DIE

mortpat_t
	.word	0,0, -30,-20, 30,20, -30,20, 30,-20

mortar_l
	.long	0		;*FRANIM
	LW	BALL1,2		;82 Ticks
	LW	BALL2,3
	LW	BALL3,4
	LW	BALL4,6
	LW	BALL5,9
	LW	BALL6,11
	LW	BALL7,12
	LW	BALL6,11
	LW	BALL5,9
	LW	BALL4,6
	LW	BALL3,4
	LW	BALL2,3
	LWL0	BALL1,2
	.word	DMAWNZ
	.long	BOOM3		;*FRANIM


********************************
* Hovering spitter (Process)

; SUBRP	spitter		;A8=*Data_t
;
;	callr	obj_get
;
;spi100	SLEEPK	1
;	calla	getcloseplyr
;	jrz	spi100
;	movi	>800,a3
;	callr	seekob_vel
;	move	*a8(OXVEL),a0,L
;	move	a0,a1
;	sra	6,a1
;	sub	a1,a0			;-Drag
;	add	a6,a0			;+Vel
;	move	a0,*a8(OXVEL),L
;	move	*a8(OYVEL),a0,L
;	move	a0,a1
;	sra	6,a1
;	sub	a1,a0			;-Drag
;	add	a7,a0			;+Vel
;	move	a0,*a8(OYVEL),L
;
;	movi	>ff,a0
;	callr	rnd
;	jrnz	spi150
;	CREATE	shawnpid,missile_fire	OLD!
;
;spi150	movi	>ff,a0
;	callr	rnd
;	jruc	spi800			;DEBUG
;	jrnz	spi800
;	movk	5,a10			;#Shots in pattern
;	movi	spitpat_t,a9
;spi200	PUSH	a10
;	movi	spitter_l,a10
;	CREATE	shawnpid,mortar_atp
;	PULL	a10
;	addk	32,a9
;	dsj	a10,spi200
;spi800	jruc	spi100
;	DIE
;
;
;spitpat_t
;	.word	0,0, -30,-20, 30,20, -30,20, 30,-20
;
;spitter_l
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
* Mortar shot (Process)

	APTRPD	msobj_p	,0	;*Mortar shadow object
	WORDPD	mpos	,2	;Mortar pos in arc
	WORDPD	msinea	,3	;Sine add per tick
	LONGPD	MYLIST	,4	;*FRANIM for player death
	LONGPD	MYSND	,6	;*Sound for ^
	WORDPD	FXOR	,9	;Player 0 or 1

MZ	.set	158

 SUBRP	mortar_relsrc		;A8=*Src Obj, A9=*SrcXY offset_t, A10=*Obj_t

	movk	1,a0
	move	a0,*a13(msinea)

 SUBRP	mortar_relsrcnoa	;^

	move	*a8(OXPOS),a6		;Get X
	move	*a8(OSIZEX),a3
	srl	1,a3
	add	a3,a6
	move	*a8(OYPOS),a7		;Get Y
	move	*a8(OSIZEY),a3
	srl	1,a3
	add	a3,a7
	jruc	mortar_shot

 SUBRP	mortar_atp		;A8=*Src Obj, A9=*DestXY offset_t, A10=*Obj_t
				;A11=0-1 (P1-P2)
	movk	1,a0
	move	a0,*a13(msinea)

 SUBRP	mortar_atpnoa		;^

	move	@PLYRPRCS,a2,L
	move	@STATUS,a3
	jrz	ms900			;Demo?
	btst	0,a11
	jrz	ma20
	btst	1,a3			;P2 valid?
	jrnz	ma30
ma20	btst	0,a3			;P1 valid?
	jrnz	ma40
ma30	move	@PLYRPRCS+32,a2,L
ma40	move	*a2(LEG_PTR),a2,L
	move	*a2(OXPOS),a6
	cmpi	>1a00,a6		;Off screen?
	jrge	ms900
	addk	10,a6
	move	*a2(OYPOS),a7
	addk	16,a7
	movk	7,a0
	callr	rnd
	subk	3,a0
	add	a0,a6			;X offset -3 to 4
	movk	7,a0
	callr	rnd
	subk	3,a0
	add	a0,a7			;Y^

 SUBRP	mortar_shot		;A8=*Src Obj, A9=*XY offset_t, A10=*Obj_t

	clr	a0
	move	a0,*a13(FXOR)		;Player 0
	movi	gslime_l,a0		;Green slimed franim
	move	a0,*a13(MYLIST),L
	movi	EXP3,a0			;Soft explosion
	move	a0,*a13(MYSND),L

	move	*a8(OXPOS),a0		;Get X
	move	*a8(OSIZEX),a3
	srl	1,a3
	add	a3,a0			;Center X
	move	*a8(OYPOS),a1		;Get Y
	move	*a8(OSIZEY),a3
	srl	1,a3
	add	a3,a1			;Center Y
	sll	16,a0
	sll	16,a1

	move	*a9+,a3
	add	a3,a6			;+X offset
	sll	16,a6
	sub	a0,a6			;DestX-SrcX
	move	*a9+,a3
	add	a3,a7			;+Y offset
	sll	16,a7
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

ms200	move	*a8(OZPOS),a3
	addk	2,a3
	movi	DMAWNZ+M_NOCOLL,a4	;No collisions
	movi	CLSDEAD,a5
	move	a10,a9
	addk	32,a10
	move	*a10,a2,L		;Get *1st obj
	mmtm	a12,a0,a1,a3,a4,a6,a7
	clr	a6
	clr	a7
	calla	BEGINOBJ2		;Get shot obj

	move	*a9,a9,L		;Get *FRANIM list
	jrz	ms250
	JSRP	FRANIMQ			;Fire sequence

ms250	mmfm	a12,a0,a1,a3,a4,a6,a7
	movi	SHADW,a2
	subk	1,a3
	movi	CLSENMY+TYPGOO,a5
	move	a8,a9
	calla	BEGINOBJ2		;Get shadow obj
	move	a8,*a13(msobj_p),L
	move	a9,a8

	move	a5,*a8(OID)
	move	a10,a9
	clr	a0
	move	a0,*a13(mpos)
	jruc	ms400

ms300	movi	DMAWNZ+M_NOCOLL,a4	;No collisions
	calla	ANI			;New frame
	move	*a9+,a10		;Get #ticks for frame
ms350	move	a8,a0
	callr	GANIOFQ
	move	*a13(msobj_p),a5,L
	move	*a5(OXPOS),a1
	sub	a6,a1
	move	a1,*a8(OXPOS)		;Set shot X
	move	*a13(mpos),a0		;New height
	move	*a13(msinea),a1
	add	a1,a0
	cmpi	82,a0			;Max table range
	jrlo	ms370
	clr	a0
ms370	move	a0,*a13(mpos)
	callr	sine_get
	srl	5,a0			;/32
	move	*a5(OYPOS),a1
	sub	a0,a1
	sub	a7,a1
	move	a1,*a8(OYPOS)		;Set shot Y
	move	a0,a1
	addi	MZ+130,a0
	move	a0,*a8(OZPOS)
	subk	10,a1
	jrhi	ms380
	calla	CK_GOOB
ms380	SLEEPK	1
	dsj	a10,ms350

ms400	move	*a9+,a1,L		;Get *Img
	jrnz	ms300

	move	*a13(msobj_p),a0,L	;Kill shadow

	clr	a10			;A10=Dir 0-3 (UPL,UPR,DNL,DNR)
	move	*a0(OXVEL+16),a1
	jrn	ms500
	addk	1,a10
ms500	move	*a0(OYVEL+16),a1
	jrn	ms520
	addk	2,a10
ms520
	calla	DELOBJ

	movi	36,a0			;21
	move	a0,*a8(OZPOS)

	move	*a9+,a0			;Get OFLAGS
	move	a0,*a8(OFLAGS)
	movi	CLSDEAD,a0
	move	a0,*a8(OID)
	move	*a9+,a9,L		;Get *FRANIM list
	jrz	ms880
	JSRP	FRANIMQ			;Explode

	move	*a8(OYPOS),a9		;A9=[Y,X] Spot to spawn from
	subk	26,a9
	sll	16,a9
	move	*a8(OXPOS),a0
	addk	12,a0
	movx	a0,a9
	clr	a11
	CREATE	HULKPID,SHULK		;Start one hulk
	SLEEP	2EH

ms880	calla	DELOBJA8
ms900	DIE


gslime_l
	LW	GSLMD1,NEWPALET+5
	.long	GOOBP
	LW	GSLMD2,5
	LW	GSLMD3,5
	LW	GSLMD4,15
	LW	GSLMD3,4
	LW	GSLMD2,4
	LWL0	GSLMD1,4


********************************
* Spider mom insect (Process)

	APTRPD	smsobj_p,0	;*Shadow object
	WORDPD	smpos	,2	;Pos in arc
	WORDPD	smFREE	,3	;
	APTRPD	smobjt_p,4	;*Jumper object_t
	WORDPD	smx	,6	;X pos
	WORDPD	smy	,7	;Y pos
;	WORDPD	smdis	,8	;Distance to jump
	WORDPD	smseekx	,9	;X pos to seek
	WORDPD	smseeky	,10	;Y pos to seek
	WORDPD	smseekt	,11	;Time to seek
;	WORDPD	smseekr	,12	;!0=Need random seek
	WORDPD	smvhitsl,13	;# Velocity hits left (0-1)
	WORDPD	smhit	,14	;!0=Hit by shot
	WORDPD	ABSRB,16	;# hits taken 0-?

SPDMZ	.equ	155
SPDMPTS	.equ	>50	;BCD


 SUBR	spidmom_start		;A8=X, A9=Y

	movk	3,a0
	callr	rnd
	addk	6,a0
	sll	14,a0
	move	a0,a7

	move	a8,a0
	move	a9,a1

	sll	16,a0
	sll	16,a1

	movi	SPYDERA1,a2
	movi	SPDMZ,a3		;Z
	movi	DMAWNZ,a4
	movi	CLSENMY+TYPSL+SUBSM,a5
	clr	a6
	calla	BEGINOBJ2


;	move	@SKIPR_CNT,a0
;	addk	1,a0
;	move	a0,@SKIPR_CNT

;	movi	SKIPR,a2
;	calla	GET_WVADDR
;	move	*a0(16),a1		;Dec wave ram cnt
;	subk	1,a1
;	move	a1,*a0(16)
;	jrnz	sm70
;	movk	1,a1
;	move	a1,@SKIPR_DN
sm70
;	move	*a0(32),a1		;Get difficulty level
;	move	a1,*a13(LEVEL)

	clr	a0
	move	a0,*a13(ABSRB)


sm100
	movi	walksnd,a0
	calla	ONESND
	movi	spidm_l,a9
	jruc	sm400

sm300	move	*a8(OFLAGS),a4
	calla	ANI			;New frame
	move	*a9+,a10		;Get #ticks for frame

sm350
	SLEEPK	1
	dsj	a10,sm350

sm400	move	*a9+,a1,L		;Get *Img
	jrnz	sm300


	movk	1,a0
	callr	rnd
	jrnz	sm600
	move	a9,a5
	move	a8,a6
	move	*a6(OXPOS),a8
	addk	28,a8
	move	*a6(OYPOS),a9
	addk	2,a9
	movi	>ff,a0
	callr	rnd
	addi	60,a0
	move	a0,a10
	CREATE	shawnpid,spidb_egg
	move	a6,a8
	move	a5,a9

sm600

sm880	move	@WORLDTLY+16,a0
	move	*a8(OYPOS),a1
	addi	250,a0
	cmp	a0,a1
	jrlo	sm100

	jauc	DELOBJDIE


spidm_l
	LW	SPYDERA1,2
	LW	SPYDERA2,2
	LW	SPYDERA3,2
	LW	SPYDERA4,2
	LW	SPYDERA5,2
	LW	SPYDERA6,2
	LW	SPYDERA1,2
	LW	SPYDERA2,2
	LW	SPYDERA3,2
	LW	SPYDERA4,2
	LW	SPYDERA5,2
	LWL0	SPYDERA6,2


spidmmpat_t	;Missiles!
	.word	10,10, 0,0, 20,0, 0,20, 20,20



********************************
* Spider babies (Process)

	APTRPD	sbsobj_p,0	;*Jumper shadow object
	WORDPD	sbpos	,2	;Jumper pos in arc
	WORDPD	sbhatch	,3	;CntDn to hatch
	APTRPD	sbobjt_p,4	;*Jumper object_t
	WORDPD	sbx	,6	;X pos
	WORDPD	sby	,7	;Y pos
	WORDPD	sbdis	,8	;Distance to jump
	WORDPD	sbseekx	,9	;X pos to seek
	WORDPD	sbseeky	,10	;Y pos to seek
	WORDPD	sbseekt	,11	;Time to seek
	WORDPD	sbseekr	,12	;!0=Need random seek
	WORDPD	sbvhitsl,13	;# Velocity hits left (0-1)
	WORDPD	sbhit	,14	;!0=Hit by shot
	WORDPD	ABSRB,16	;# hits taken 0-?

SPDBZ	.equ	150
SPDBPTS	.equ	>10

 SUBRP	spidb_shootegg		;A8=*SpidMom obj, A10=Hatch time

	move	a10,*a13(sbhatch)	;Hatch time

	clr	a2
	move	a2,*a13(sbseekt)	;# Hops
	move	a2,*a13(sbseekr)	;Random off

	movk	5,a0			;>Speed
	callr	rndrng0
	addk	1,a0
	sll	13,a0			;*>200
	move	a0,a11

	movk	25,a0			;>Random origin
	callr	rndrng0
	subk	12,a0
	move	a0,a4

	movk	21,a0
	callr	rndrng0
	subk	5,a0
	move	a0,a5

	move	*a8(OXPOS),a0
	addi	35,a0
	move	a0,a6
	add	a4,a0
	sll	3,a4			;*8
	add	a4,a6

	move	*a8(OYPOS),a1
	addk	25,a1
	move	a1,a7
	add	a5,a1
	sll	3,a5			;*8
	add	a5,a7

	sll	16,a0
	sll	16,a1
	sll	16,a6
	sll	16,a7
	sub	a0,a6			;DestX-SrcX
	sub	a1,a7			;DestY-SrcY

sbs240	sra	1,a6			;>Scale down to A11
	sra	1,a7
	move	a6,a2
	abs	a2
	cmp	a11,a2			;A6&A7 < A11
	jrgt	sbs240
	move	a7,a2
	abs	a2
	cmp	a11,a2
	jrgt	sbs240


	movi	SPYDEREGG1,a2
	movi	73,a3			;Z
	movi	DMAWNZ+M_NOCOLL,a4
	movi	CLSNEUT+TYPICON+SUBSEGG,a5
	PUSH	a0,a1,a4,a6,a7
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	PULL	a0,a1,a4,a6,a7

	movi	SPYDEREGG1A,a2
	movi	72,a3			;Z
	movi	CLSDEAD,a5
	move	a8,a9
	calla	BEGINOBJ2		;Get shadow obj
	move	a8,*a13(sbsobj_p),L
	move	a9,a8

	movk	3,a0
	callr	rnd
	movi	-9,a11
	add	a0,a11

sbs300	movi	spidbegg_l,a9
	clr	a0
	move	a0,*a13(sbpos)
	jruc	sbs400

sbs330	move	*a8(OFLAGS),a4
	calla	ANI			;New frame
	move	*a9+,a10		;Get #ticks for frame

sbs350	move	*a13(sbsobj_p),a5,L
	move	a5,a0
	callr	GANIOFQ
	move	*a13(sbpos),a0		;New height
	addk	2,a0
	cmpi	82,a0			;Max table range
	jrlo	sbs370
	clr	a0
sbs370	move	a0,*a13(sbpos)
	callr	sine_get
	srl	a11,a0			;Divide it (2s comp)
	move	a0,a1
	move	*a5(OYPOS),a2
	sub	a0,a2
	addi	SPDBZ,a0
	move	a0,*a8(OZPOS)
	move	a8,a0
	move	*a5(OXPOS),a3
	add	a6,a3			;Add Anim pt
	add	a7,a2
;	subk	8,a2			;Fix Y
;	subk	6,a3			;Fix X
	sll	16,a2
	sll	16,a3
	movi	DMAWNZ+M_NOCOLL,a4
	subk	8,a1
	jrgt	sbs380
	subi	M_NOCOLL,a4
sbs380	calla	GANISAG
	SLEEPK	1
	dsj	a10,sbs350

sbs400	move	*a9+,a1,L		;Get *Img
	jrnz	sbs330

	movi	spidbeggl_l,a9
	JSRP	FRANIMQ			;Land

	subk	1,a11			;Increase divisor
	cmpi	-10,a11			;Min
	jrgt	sbs300
;	jrle	sbs500

;	movk	3,a0
;	callr	rnd
;	jrnz	sbs300


sbs500	move	*a13(sbsobj_p),a0,L	;Kill shadow
	calla	DELOBJ

	jruc	spidbaby2


spidbegg_l
	LW	SPYDEREGG,2
	LW	SPYDEREGG2,36
	LWL0	SPYDEREGG,3

spidbeggl_l
	LW	SPYDEREGG3,4
	LWL0	SPYDEREGG1,2


 SUBR	STRT_EGG		;FROM BACKGROUND DRIVER

	MOVE	@WAVE,A0
	SLL	5,A0
	ADDI	LENGTH-24*32,A0
	MOVE	*A0,A0,L
	CLR	A1
	MOVX	A0,A1
	SRL	16,A0
	MOVE	A0,B0
	MOVE	A1,B1
	CALLA	RANGRAND
	move	a0,*a13(sbhatch)	;Hatch time
	MOVE	*A8(OYVAL),A9,L
	MOVE	A8,A0
	MOVE	*A8(OXVAL),A8,L
	CALLA	DELOBJ			;DELETE FAKE BAKGND EGG
	clr	a2
	move	a2,*a13(sbseekt)	;# Hops
	move	a2,*a13(sbseekr)	;Random off
	jruc	spidbaby

LENGTH
;1ST ENTRY IS FOR WAVE 24
;MINIMUM TIME, MAX TIME TO DELAY HATCH
	.long	[8*60,12*60],[8*60,12*60],[3*60,17*60],[4*60,70*60]
	.long	[4*60,120*60],[8*60,46*60],[8*60,100*60],[4*60,20*60]
	.long	[4*60,120*60],[8*60,46*60],[8*60,100*60],[6*60,30*60]
	.long	[6*60,30*60],[4*60,17*60],[3*60,30*60],[3*60,30*60]
	.long	[6*60,50*60],[8*60,46*60],[3*60,10*60],[4*60,20*60]
	.long	0



 SUBRP	spidb_egg		;A8=X, A9=Y, A10=Hatch time

	sll	16,a8
	sll	16,a9

	clr	a2
	move	a2,*a13(sbseekt)	;# Hops
	move	a2,*a13(sbseekr)	;Random off

	move	a10,*a13(sbhatch)	;Hatch time
	jruc	spidbaby


 SUBRP	spidb_start		;A0=XL, A1=YL, A10=Dir 1-8

	addi	[20,0],a1		;Offset

	move	a0,a8
	move	a1,a9

	move	a0,a2
	move	a1,a3
	srl	16,a2
	srl	16,a3

	movi	1000,a4			;Dist
	subk	1,a10			;0-7
	srl	2,a10			;0-1
	jrnc	sb30
	jrz	sb20
	neg	a4
sb20	add	a4,a2			;+X
	jruc	sb50

sb30	jrnz	sb40
	neg	a4
sb40	add	a4,a3			;+Y

sb50	move	a2,*a13(sbseekx)	;Seek straight onto screen
	move	a3,*a13(sbseeky)

	movk	6,a2
	move	a2,*a13(sbseekt)	;# Hops
	move	a2,*a13(sbseekr)	;Random on
	movk	20,a0
	callr	rndrng0
	move	a0,*a13(sbhatch)	;Already hatched

	movi	SKIPR,a2
	calla	GET_WVADDR
;	move	*a0(32),a1		;Get difficulty level
;	move	a1,*a13(LEVEL)
	move	*a0(16),a1		;Dec wave ram cnt
	subk	1,a1
	move	a1,*a0(16)
	jrgt	sb70
	movk	1,a1
	move	a1,@SKIPR_DN
sb70


 SUBRP	spidbaby	;A8=XL, A9=YL

	move	a8,a0
	move	a9,a1

	movi	SPYDEREGG1,a2
	movi	72,a3			;Z
	movi	DMAWNZ,a4
	movi	CLSNEUT+TYPICON+SUBSEGG,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2

 SUBRP	spidbaby2

	clr	a0
	move	a0,*a13(sbsobj_p),L
	move	a0,*a13(ABSRB)
	move	a0,*a13(sbhit)

	move	*a8(OXPOS),a1
	move	a1,*a13(sbx)		;Save XY
	move	*a8(OYPOS),a1
	move	a1,*a13(sby)

	move	*a13(sbhatch),a11

sb100	SLEEPK	1
	cmpi	120,a11
	jrgt	sb120

	movk	3,a0
	callr	rnd
	jrnz	sb120

	movk	2,a0
	callr	rndrng0
	subk	1,a0			;-1 to 1
	move	*a13(sbx),a1
	add	a0,a1
	move	a1,*a8(OXPOS)
	movk	2,a0
	callr	rndrng0
	subk	1,a0			;-1 to 1
	move	*a13(sby),a1
	add	a0,a1
	move	a1,*a8(OYPOS)

sb120	subk	1,a11
	jrgt	sb100

	move	a8,a0
	callr	GANIOFQ
	move	*a8(OXPOS),a1
	add	a6,a1
	move	a1,*a13(sbx)		;Save XY
	move	*a8(OYPOS),a1
	add	a7,a1
	move	a1,*a13(sby)

	movi	spidbh_l,a9		;>Hatch baby
	JSRP	FRANIMQ

	movi	CLSENMY+TYPSL,a5
	move	a5,*a8(OID)

	movk	7,a0
	callr	rnd
	addk	5,a0
	sll	9,a0			;*>200
	move	a0,*a13(sbdis)

	movi	spidb_l,a10
	move	a10,*a13(sbobjt_p),L

	move	@SKIPR_CNT,a0
	addk	1,a0
	move	a0,@SKIPR_CNT


sb150	SLEEPK	1
	move	*a13(sbseekt),a0
	jrz	sb160
	move	*a13(sbseekx),a6
	move	*a13(sbseeky),a7
	subk	1,a0
	move	a0,*a13(sbseekt)
	jruc	sb230

sb160	move	*a13(sbseekr),a0
	jrz	sb190
	clr	a0			;>Go random after straight
	move	a0,*a13(sbseekr)	;Off
	movk	1,a0
	callr	rnd
	addk	1,a0
	move	a0,*a13(sbseekt)	;# Hops 1-2
	move	*a13(sbx),a6
	move	*a13(sbseekx),a2
	sub	a6,a2
	sra	5,a2			;Clr 5 LBits
	sll	5,a2
	jrz	sb170
	movk	7,a0
	callr	rnd
	neg	a0
	sra	a0,a2			;Scale down X
	add	a2,a6
	jruc	sb172
sb170	movi	80,a2
	movi	>ff,a0
	callr	rnd
	subi	>7f,a0
	jrnn	sb171
	neg	a2
sb171	add	a2,a0
	add	a0,a6			;X+/-(80 to 208)

sb172	move	*a13(sby),a7
	move	*a13(sbseeky),a2
	sub	a7,a2
	sra	5,a2
	sll	5,a2
	jrz	sb180
	movk	7,a0
	callr	rnd
	neg	a0
	sra	a0,a2			;Scale down Y
	add	a2,a7
	jruc	sb185
sb180	movi	60,a2
	movi	>7f,a0
	callr	rnd
	subi	>3f,a0
	jrnn	sb182
	neg	a2
sb182	add	a2,a0
	add	a0,a7			;Y+/-(60 to 124)

sb185	move	a6,*a13(sbseekx)
	move	a7,*a13(sbseeky)
	jruc	sb230
	

sb190	calla	getcloseplyr		;>Go for player
	jrz	sb150

	move	*a0(OXPOS),a6
	addk	10,a6
	move	*a0(OYPOS),a7
	addk	16,a7
	movk	>f,a0
	callr	rnd
	subk	7,a0
	add	a0,a6			;X offset -7 to 8
	movk	>f,a0
	callr	rnd
	subk	7,a0
	add	a0,a7			;Y^

sb230	move	*a13(sbx),a0		;Get XY
	move	*a13(sby),a1

	sll	16,a0
	sll	16,a1

	sll	16,a6
	sll	16,a7
	sub	a0,a6			;DestX-SrcX
	sub	a1,a7			;DestY-SrcY

	move	*a13(sbdis),a11
	sll	4,a11			;*16
	move	*a13(sbhit),a2		;Hit?
	jrz	sb240
	srl	2,a11			;1/4 jump

sb240	sra	1,a6			;>Scale down to A11
	sra	1,a7
	move	a6,a2
	abs	a2
	cmp	a11,a2			;A6&A7 < A11
	jrgt	sb240
	move	a7,a2
	abs	a2
	cmp	a11,a2
	jrgt	sb240

	move	a7,a2
	sra	2,a2
	sub	a2,a7			;YV*.75

	move	*a13(sbobjt_p),a10,L	;Get start of table
	move	*a10+,a9,L		;Get *FRANIM list
	jrz	sb250
	mmtm	a12,a0,a1,a6,a7		;Save XY&Vel
	JSRP	FRANIMQ			;Jump sequence
	mmfm	a12,a0,a1,a6,a7

sb250
	movi	ARACSHAD,a2
	movi	75,a3			;Z
	movi	DMAWNZ+M_NOCOLL,a4	;No collisions
	movi	CLSDEAD,a5
	move	a8,a9
	calla	BEGINOBJ2		;Get shadow obj
	move	a8,*a13(sbsobj_p),L
	move	a9,a8

	movk	1,a0
	move	a0,*a13(sbvhitsl)	;Can take 1 vel hits

	move	a10,a9
	clr	a0
	move	a0,*a13(sbpos)
	jruc	sb400

sb300	move	*a8(OFLAGS),a4
	calla	ANI			;New frame
	move	*a9+,a10		;Get #ticks for frame

sb350	move	*a13(sbsobj_p),a5,L

	move	*a13(sbvhitsl),a0	;Hits left?
	jrnz	sb365

	move	*a5(OXPOS),a2		;>Chk if close to screen edge
	move	@WORLDTLX+16,a1
	sub	a1,a2
	subk	10,a2			;Offset
	jrlo	sb360
	cmpi	300,a2			;Width
	jrhi	sb360
	move	*a5(OYPOS),a2
	move	@WORLDTLY+16,a1
	sub	a1,a2
	subi	50,a2			;Offset
	jrlo	sb360
	cmpi	195,a2			;Hgt
	jrls	sb365

sb360	clr	a1
	move	a1,*a5(OXVEL),L
	move	a1,*a5(OYVEL),L

sb365	move	a5,a0
	callr	GANIOFQ
	move	*a13(sbpos),a0		;New height
	addk	2,a0
	cmpi	82,a0			;Max table range
	jrlo	sb370
	clr	a0
sb370	move	a0,*a13(sbpos)
	callr	sine_get
	srl	8,a0			;/256
	move	*a5(OYPOS),a2
	sub	a0,a2
	addi	SPDBZ,a0
	move	a0,*a8(OZPOS)
	move	a8,a0
	move	*a5(OXPOS),a3
	add	a6,a3			;Add Anim pt
	add	a7,a2
	sll	16,a2
	sll	16,a3
	move	*a8(OFLAGS),a4
	calla	GANISAG
	SLEEPK	1
	dsj	a10,sb350

sb400	move	*a9+,a1,L		;Get *Img
	jrnz	sb300


sb600	move	*a13(sbsobj_p),a0,L	;Kill shadow
	callr	GANIOFQ
	move	*a0(OXPOS),a1
	add	a6,a1
	move	a1,*a13(sbx)		;Save XY
	move	*a0(OYPOS),a1
	add	a7,a1
	move	a1,*a13(sby)

	calla	DELOBJ
	clr	a0
	move	a0,*a13(sbsobj_p),L
	move	a0,*a13(sbhit)		;Clr hit

	move	*a9+,a9,L		;Get *FRANIM list
	jrz	sb880
	JSRP	FRANIMQ			;Land
sb880
;	calla	SCRTST
;	jreq	sb150
	jruc	sb150			;DEBUG

;	jauc	DELOBJDIE


spidbh_l
	LW	HATCH1,6
	LW	HATCH2,6
	LW	HATCH3,6
	LW	HATCH4,6
	LWL0	SPYDERB1,1

spidb_l
	.long	spidbj_l
	LWL0	SPYDERB3,41
	.long	spidbl_l

spidbj_l
	LW	SPYDERB1,4
	LW	SPYDERB2,4
	LWL0	SPYDERB1,4
spidbl_l
	LWL0	SPYDERB1,1


	NOTINUSE
skipper_l
	.long	0
	LW	SKIP1,4
	LW	SKIP2,4
	LW	SKIP3,4
	LW	SKIP4,4
	LW	SKIP5,4
	LW	SKIP1,4
	LW	SKIP2,4
	LW	SKIP3,4
	LW	SKIP4,4
	LWL0	SKIP5,5
	.long	skipperl_l


	LW	SKIP1,1
	LW	SKIP2,1
	LW	SKIP3,1
	LW	SKIP4,1
	LWL0	SKIP5,1
	.endif


********************************
* Launch small neutron bomb

 SUBR	SPAWN_SNEUT

	move	@HALT,a0
	jrnz	spret
	movi	700,a0
	calla	RANDPER
	jrnc	spret
	move	@WORLDTLX+16,a8
	movi	300,a0
	callr	rndrng0
	addi	50,a0
	add	a0,a8
	move	@WORLDTLY+16,a9
	movi	180,a0
	callr	rndrng0
	addi	70,a0
	add	a0,a9
	CREATE	NEUTPID,bomb_smneutron
spret	rets

********************************
* Launch lots of small neutron bombs

 SUBR	SPAWN_SNEUT2

	move	@HALT,a0
	jrnz	spret
	movi	190,a0		;150
	calla	RANDPER
	jrc	spret
	MOVE	@LOTS_FLAG,A0
	JRNZ	SN100
;TURN ON COLOR CYCLE
	MOVK	1,A0
	MOVE	A0,@LOTS_FLAG
;THIS FLAG WILL STOP THE WHOOPS PROC AND THE COLOR CYCLE PROC FROM STARTING!
	CREATE	NEUTPID,BMB_CYCS
SN100
	move	@WORLDTLX+16,a8
	movi	300,a0
	callr	rndrng0
	addi	50,a0
	add	a0,a8
	move	@WORLDTLY+16,a9
	movi	180,a0
	callr	rndrng0
	addi	70,a0
	add	a0,a9
	CREATE	NEUTPID,bomb_smneutron2
	rets

BMB_CYCS
;START 1 OVERALL COLOR CYCLER FOR ALL BOMBS
	movi	NEUTRONP,a8 		;>Cycle red zone
	movi	bombnpalmem1,a9		;*ram
	movi	[17,22],a10
	movk	6,a11			;Rate
	CREATE	CYCPID,COLCYC		;>Cycle green/blue lights
	MOVE	A0,*A13(PDATA),L
	movi	bombnpalmem2,a9
	movi	[22,25],a10
	movk	5,a11
	CREATE	CYCPID,COLCYC
	MOVE	A0,*A13(PDATA+32),L
BMB100	SLEEP	120
	MOVE	@LOTS_FLAG,A0
	JRNZ	BMB100
;WAVE OF BOMBS OVER!
	MOVE	*A13(PDATA),A0,L
	CALLA	KILL
	MOVE	*A13(PDATA+32),A0,L
	CALLA	KILL
	DIE
	


********************************
* Neutron bomb data

	APTRPD	bnsobj_p,0	;*Bomb shadow object
	WORDPD	bnpos	,2	;Bomb pos in arc
	APTRPD	bncyc1_p,3	;*Bomb cycle process 1
	APTRPD	bncyc2_p,5	;^2
	WORDPD	bnx	,7	;X pos
	WORDPD	bny	,8	;Y pos
	APTRPD	keepwhp	,9	;*Whoop snd proc

BOMBNZ	.equ	75


********************************
* Lots of Small neutron bomb (Process)

 SUBR	bomb_smneutron2		;A8=X dest, A9=Y dest

	movi	SNEUT2,a2
	JRUC	BMB001

********************************
* Small neutron bomb (Process)


 SUBR	bomb_smneutron		;A8=X dest, A9=Y dest

	movi	SNEUT,a2

BMB001	clr	a0
	move	a0,*a13(keepwhp),L	;Zero whoop sound proc
	move	a0,*a13(bncyc1_p),L
	move	a0,*a13(bncyc2_p),L

	calla	GET_WVADDR
	move	*a0(16),a1		;Dec wave ram cnt for this sneut
	dec	a1
   	move	a1,*a0(16)
	jrnz	bsn60
	MOVE	A1,@LOTS_FLAG		;TABLE RAN OUT OF NEUTRONS TO RELEASE

bsn60	move	a8,a6
	move	a9,a7

	move	@WORLDTLX+16,a0
	addi	200,a0
	movi	400,a2
	cmp	a0,a8
	jrgt	bsn70
	neg	a2
bsn70	sub	a2,a0

	move	@WORLDTLY+16,a1
	addi	128,a1

	sll	16,a0
	sll	16,a1
	sll	16,a6
	sll	16,a7
	sub	a0,a6			;DestX-SrcX
	sub	a1,a7			;DestY-SrcY

	move	a6,a11
	abs	a11
	srl	6,a11			;/64
	move	a11,a3
	srl	3,a3
	sub	a3,a11			;Sub .125 = /73


bsn200	sra	1,a6			;>Scale down to A11
	sra	1,a7
	move	a6,a2
	abs	a2
	cmp	a11,a2			;A6&A7 < A11
	jrgt	bsn200
	move	a7,a2
	abs	a2
	cmp	a11,a2
	jrgt	bsn200


	movi	SMNEUTB,a2
	movi	BOMBNZ,a3
	movi	DMAWNZ+M_NOCOLL,a4
	movi	CLSNEUT+TYPICON+SUBBOMBSN,a5
	PUSH	a0,a1,a6,a7
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	PULL	a0,a1,a6,a7

	movi	SMNEUTSHAD,a2
	subk	1,a3
;	movi	DMACNZ+M_NOCOLL,a4
;	movi	CLSDEAD,a5		;SHADOW ID TO KILL
	movi	CLSNEUT+TYPICON+SUBBOMBSN,a5
	PUSH	a8
	calla	BEGINOBJ2		;Get shadow obj
	move	a8,*a13(bnsobj_p),L

	MOVE	@LOTS_FLAG,A0
	JRNZ	BC100
	callr	bombn_cycon
BC100
	PULL	a8
	movi	-4,a11

bsn300	movi	bombsn_l,a9
	clr	a0
	move	a0,*a13(bnpos)
	jruc	bsn400

bsn330	move	*a8(OFLAGS),a4
	calla	ANI			;New frame
	move	*a9+,a10		;Get #ticks for frame

bsn350	move	*a13(bnsobj_p),a5,L
	move	a5,a0
	callr	GANIOFQ
	move	*a13(bnpos),a0		;New height
	addk	1,a0
	cmpi	82,a0			;Max table range
	jrlo	bsn370
	clr	a0
bsn370	move	a0,*a13(bnpos)
	callr	sine_get
	srl	a11,a0			;Divide it (2s comp)
	move	a0,a1
	move	*a5(OYPOS),a2
	sub	a0,a2
	addi	BOMBNZ+80,a0
	move	a0,*a8(OZPOS)
	move	a8,a0
	move	*a5(OXPOS),a3
	add	a6,a3			;Add Anim pt
	add	a7,a2
;	subk	8,a2			;Fix Y
;	subk	6,a3			;Fix X
	sll	16,a2
	sll	16,a3
	movi	DMAWNZ+M_NOCOLL,a4
	subk	8,a1
	jrgt	bsn380
	subi	M_NOCOLL,a4
bsn380	calla	GANISAG
bsn385	SLEEPK	1
	move	@HALT,a0
	jrnz	bsn385
	dsj	a10,bsn350

bsn400	move	*a9+,a1,L		;Get *Img
	jrnz	bsn330

	movi	BNCSND,a0
	calla	ONESND

	move	*a13(bnsobj_p),a9,L	;Vel /2
	move	*a9(OXVEL),a1,L
	sra	2,a1
	move	a1,*a9(OXVEL),L
	move	*a9(OYVEL),a1,L
	sra	2,a1
	move	a1,*a9(OYVEL),L

	subk	2,a11			;Increase divisor
	cmpi	-10,a11			;Min
	jrgt	bsn300


	clr	a1
	move	a1,*a9(OXVEL),L
	move	a1,*a9(OYVEL),L

	move	*a8(OXPOS),a1		;>Save pos
	move	a1,*a13(bnx)
	move	*a8(OYPOS),a1
	move	a1,*a13(bny)

	move	@LOTS_FLAG,a0
	jrnz	bsn490
	move	a13,a11
	CREATE	FUTUREPID,whoops
	move	a0,*a13(keepwhp),L	;keep for killing later

bsn490	movi	180,a11
	move	@STATUS,a0
	subk	3,a0
	jreq	bsn500
	movi	220,a11			;Easier for 1 player!
bsn500	SLEEPK	1
	cmpi	90,a11
	jrgt	bsn530

	movk	4,a0
	callr	rndrng0
	subk	2,a0			;-2 to 2
	move	*a13(bnx),a1
	add	a0,a1
	move	a1,*a8(OXPOS)
	addk	3,a1
	move	a1,*a9(OXPOS)
	movk	4,a0
	callr	rndrng0
	subk	2,a0			;-2 to 2
	move	*a13(bny),a1
	add	a0,a1
	move	a1,*a8(OYPOS)
	addk	9,a1
	move	a1,*a9(OYPOS)

bsn530	move	@STATUS,a0
	jrz	bsn540
	calla	SCRTST
	jrz	bsn550

bsn540	calla	DELOBJA8
	callr	bombn_cleanup
	jruc	bsn900

bsn550	subk	1,a11
	jrgt	bsn500

	MOVE	@PLYRPRCS,A0,L
	JRZ	TAG01
	MOVE	*A0(DELYDET),A0
	JRZ	TAG02			;BR=YES SOMEONE TO KILL
TAG01	MOVE	@PLYRPRCS+32,A0,L
	JRZ	bsn555			;NO ONE WOULD DIE ANYWAY!  DON'T BLOW
	MOVE	*A0(DELYDET),A0
	JRZ	TAG02
bsn555
	movi	DISSND,a0		;DO DISARM SOUND IF NOT BLOWING
	calla	ONESND
      	JRUC	bsn540

TAG02
	movi	DMAWNZ+M_NOCOLL,a0	;>Detonate!
	move	a0,*a8(OFLAGS)

	MOVE	@IN_BOMB,A0
	JRNZ	bsn540			;in process of exploding!

	movk	30,a10
	calla	SHAKER
	CREATE0	SBSND
	move	@PLYROBJS+32,a2,L
	move	@PLYROBJS,a9,L
	jrz	bsn750
	move	a2,a2
	jrz	bsn760
	movk	1,a0			;>Give random player the smartbomb pts
	callr	rnd
	jrz	bsn760
bsn750	move	a2,a9
bsn760	CREATE0	SBOMB

	movi	LORDPID,a0
	movi	-1,a1
	calla	EXISTP
	jrz	bsn770
	movi	200,a1
	move	a1,*a0(PTIME)		;No enemies for 120 ticks
bsn770
	CREATE0	bombn_2

	CLR	A0
	MOVE	A0,*A13(PROCID)
	MOVE	A0,*A8(OID)

	movi	RDBOOM,a0		;Make sure blood pal is allocated
	calla	GETFPAL

	movi	CYCPID,a0		;Delay cyclers
	movi	260,a2
	calla	KOP_1C
	movi	POWPID,a0		;Delay cyclers
	movi	260,a2
	calla	KOP_1C

	callr	bombn_cleanup
	move	*a8(OYPOS),a0
	addk	30,a0
	move	a0,*a8(OYPOS)		;New pos for explosion

	movi	XBOOM2,a9		;>Explode
	JSRP	FRANIMQ
	calla	DELOBJA8

	SLEEP	90
	movi	bombnpal_t,a0
	movk	1,a1
	calla	PAL_FMWHT

bsn900	DIE


bombsn_l
	LWL0	SMNEUTB,82


********************************
* Warning sound (process)
* A11=*Process that created

whoops	movk	25,a10
wp1	SLEEPK	8
	movi	WARNING,a0
	calla	ONESND
	dsj	a10,wp1
	move	a10,*a11(keepwhp),L	;So cleanup doesn't try to kill
	DIE

whoops2	movi	75,a10
whp1	SLEEPK	6
	movi	WARNING2,a0
	calla	ONESND
	dsj	a10,whp1
whp2	SLEEPK	3
    	movi	WARNING2,a0
	calla	ONESND
	jruc	whp2

BNCSND	.WORD	>F865,05,>80D4,0		;NEUTRON BNC SND
WARNING	.WORD	>F87E,>8,>80D6,0		;WARNING WHISTLE
WARNING2 .WORD	>F3EE,>5,>80AC,0		;WARNING WHISTLE FOR BIG BOMB
DISSND	.WORD	>F3EE,>18,>80B0,0		;KEY MELODY TYPE SND
BAMSND	.WORD	>F3EE,>1,>8081,0		;BOOM
BAMSND2	.WORD	>F3EE,>1,>8082,0		;BOOM2



********************************
* Player touches small neutron bomb


 SUBR	bombsmn_touch	;A0=*Player obj, A8=*NBomb obj

	PUSH	a1,a2,a3,a4,a5,a6,a7,a9,a10,a11

	movk	1,a3
	move	a3,@OUT_FLG		;Stop scan

	move	*a0(OPLINK),a10,L
	move	*a10(PNUM),a10

	movi	P1DATA,a2
	subk	1,a10
	jrz	bsnt5			;P1?
	movi	P2DATA,a2

bsnt5	move	*a2(TWPNS),a0
	subk	1,a0
	move	a0,*a2(TWPNS)

	movi	DEARM,a1			;300 pts per disarm
	calla	SCRADD2

	movi	DISSND,a0
	calla	ONESND

	PUSH	a13
	move	*a8(OPLINK),a13,L
	callr	bombn_cleanup
	move	a13,a9
	PULL	a13

	movi	300,a0
	move	a0,*a8(OZPOS)
	movi	DMAWNZ+M_NOCOLL,a0
	move	a0,*a8(OFLAGS)
	CLR	A0
	MOVE	A0,*A8(OID)

	MOVE	A9,A0
	movi	FUTUREPID,a1
	movi	bombsmn_disarm,a7
	calla	XFERPROC

	PULL	a1,a2,a3,a4,a5,a6,a7,a9,a10,a11
	rets


********************************
*A8=*ICON IMG
*A10=PLYR # 0/1

 SUBRP	bombsmn_disarm

	calla	CYCLEON
	movi	bndis_l,a9
	JSRP	FRANIMQ
	clr	a11		;Not a key
	jauc	INHERE


bndis_l	LWL	DISARM,NEWPALET+90,PPLP
	.long	0	


********************************
* Neutron bomb (Process)


 SUBR	bomb_neutron		;A8=Dir (0-L,1-R)

	move	@bombnon,a0
	jrnz	bn900		;NBomb already active?
	addk	1,a0
	move	a0,@bombnon

	clr	a0
	move	a0,*a13(keepwhp),L	;Zero whoop sound proc 
	move	a0,*a13(bncyc1_p),L
	move	a0,*a13(bncyc2_p),L

	movk	5,a0
	callr	rndrng0
	subi	10,a0
	move	a0,a6			;X dest offset

	movk	21,a0
	callr	rndrng0
	subk	10,a0
	move	a0,a7			;Y dest offset

	move	@WORLDTLX+16,a0
	addi	200,a0
	movi	360,a2
	btst	0,a8
	jrz	bn70
	neg	a2
	neg	a6
bn70	add	a0,a6
	sub	a2,a0

	move	@WORLDTLY+16,a1
	addi	110,a1
	add	a1,a7

	sll	16,a0
	sll	16,a1
	sll	16,a6
	sll	16,a7
	sub	a0,a6			;DestX-SrcX
	sub	a1,a7			;DestY-SrcY

	move	a6,a11
	abs	a11
	srl	6,a11			;/64
	move	a11,a3
	srl	2,a3
	sub	a3,a11			;Sub .25 = /96


bn200	sra	1,a6			;>Scale down to A11
	sra	1,a7
	move	a6,a2
	abs	a2
	cmp	a11,a2			;A6&A7 < A11
	jrgt	bn200
	move	a7,a2
	abs	a2
	cmp	a11,a2
	jrgt	bn200


	movi	NEUTRONB,a2
	movi	BOMBNZ,a3
	movi	DMAWNZ+M_NOCOLL,a4
	movi	CLSNEUT+TYPTRUNK,a5
	PUSH	a0,a1,a6,a7
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	PULL	a0,a1,a6,a7

	movi	NEUTSHAD,a2
	subk	1,a3
;	movi	DMACNZ+M_NOCOLL,a4
	movi	CLSDEAD,a5
	movi	DMAWNZ+M_NOCOLL,a4
	PUSH	a8
	calla	BEGINOBJ2		;Get shadow obj
	move	a8,*a13(bnsobj_p),L

	callr	bombn_cycon

	PULL	a8
	CREATE	BOMBNPID,bombn_togoid
	movi	-4,a11

bn300	movi	bombn_l,a9
	clr	a0
	move	a0,*a13(bnpos)
	jruc	bn400

bn330	move	*a8(OFLAGS),a4
	calla	ANI			;New frame
	move	*a9+,a10		;Get #ticks for frame

bn350	move	*a13(bnsobj_p),a5,L
	move	a5,a0
	callr	GANIOFQ
	move	*a13(bnpos),a0		;New height
	addk	1,a0
	cmpi	82,a0			;Max table range
	jrlo	bn370
	clr	a0
bn370	move	a0,*a13(bnpos)
	callr	sine_get
	srl	a11,a0			;Divide it (2s comp)
	move	a0,a1
	move	*a5(OYPOS),a2
	sub	a0,a2
	addi	BOMBNZ+80,a0
	move	a0,*a8(OZPOS)
	move	a8,a0
	move	*a5(OXPOS),a3
	add	a6,a3			;Add Anim pt
	add	a7,a2
;	subk	8,a2			;Fix Y
;	subk	6,a3			;Fix X
	sll	16,a2
	sll	16,a3
	movi	DMAWNZ+M_NOCOLL,a4
	subk	8,a1
	jrgt	bn380
	subi	M_NOCOLL,a4
bn380	calla	GANISAG
bn385	SLEEPK	1
	move	@HALT,a0
	jrnz	bn385
	dsj	a10,bn350

bn400	move	*a9+,a1,L		;Get *Img
	jrnz	bn330

	movi	BNCSND,a0
	calla	ONESND

	move	*a13(bnsobj_p),a0,L	;Vel /2
	move	*a0(OXVEL),a1,L
	sra	2,a1
	move	a1,*a0(OXVEL),L
	move	*a0(OYVEL),a1,L
	sra	2,a1
	move	a1,*a0(OYVEL),L

	subk	2,a11			;Increase divisor
	cmpi	-10,a11			;Min
	jrgt	bn300


	clr	a1
	move	a1,*a0(OXVEL),L
	move	a1,*a0(OYVEL),L

	CREATE	FUTUREPID,whoops2
	move	a0,*a13(keepwhp),L	;Keep for killing later
	.REF	LEAVE
	CREATE	FUTUREPID,LEAVE
	
	JSRP	bombn_cntdn
	jrnz	bn600			;Explode?
	calla	DELOBJA8
	callr	bombn_cleanup
	jruc	bn900

bn600 	clr	a0			;Smart bomb won't try to affect me
	move	a0,*a8(OID)
	movk	30,a10			;>Detonate!
	calla	SHAKER
	CREATE0	SBSND
	move	@PLYROBJS+32,a2,L
	move	@PLYROBJS,a9,L
	jrz	bn750
	move	a2,a2
	jrz	bn760
	movk	1,a0			;>Give random player the smartbomb pts
	callr	rnd
	jrz	bn760
bn750	move	a2,a9
bn760	CREATE0	SBOMB

	CREATE0	bombn_2

	movi	RDBOOM,a0		;Make sure blood pal is allocated
	calla	GETFPAL

	movi	CYCPID,a0		;Delay cyclers
	movi	260,a2
	calla	KOP_1C
	movi	POWPID,a0		;Delay cyclers
	movi	260,a2
	calla	KOP_1C

	callr	bombn_cleanup
	move	*a8(OYPOS),a0
	addk	30,a0
	move	a0,*a8(OYPOS)		;New pos for explosion

	movi	XBOOM2,a9		;>Explode
	JSRP	FRANIMQ
	calla	DELOBJA8

	SLEEP	125

	movi	bombnpal_t,a0
	movk	1,a1
	calla	PAL_FMWHT

bn900	DIE


bombn_l
	LWL0	NEUTRONB,82


bombnpal_t	.long	SCOREPAL,0
;	.long	nup1,nup2,ONUP1,0



********************************
* Start neutbomb color cyclers

 SUBRP	bombn_cycon

	movi	NEUTRONP,a8 		;>Cycle red zone
	movi	bombnpalmem1,a9		;*ram
	movi	[17,22],a10
	movk	6,a11			;Rate
	CREATE	CYCPID,COLCYC		;>Cycle green/blue lights
	move	a0,*a13(bncyc1_p),L
	movi	bombnpalmem2,a9
	movi	[22,25],a10
	movk	5,a11
	CREATE	CYCPID,COLCYC
	move	a0,*a13(bncyc2_p),L
	rets

********************************
* Toggle neutbomb between blade & trunk (Process)

 SUBRP	bombn_togoid

	movi	CLSPLYR|TYPHLPR|SUBLAY,a0
	move	a0,*a8(OID)
	SLEEPK	1
	movi	CLSNEUT+TYPTRUNK,a0
	move	a0,*a8(OID)
	SLEEPK	7
	jruc	bombn_togoid


********************************
* Neutron bomb counts down

 SUBRP	bombn_cntdn	;A8=*Bomb obj

	move	a8,-*a12,L

	move	*a8(OXPOS),a0
	addk	11,a0
	move	*a8(OYPOS),a1
	addk	5,a1
	sll	16,a0
	sll	16,a1
	movi	WTIMER0,a2
	movi	BOMBNZ+80,a3
	movi	DMAWNZ+M_NOCOLL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	PUSH	a0,a1
	calla	BEGINOBJ2		;Get digit 1
	move	a8,a9
	PULL	a0,a1
	addi	>70000,a0		;Next X
	calla	BEGINOBJ2		;Get digit 2

	movi	digit_t+10*32,a11
	move	-*a11,a1,L
	jruc	bnc150

bnc100	move	-*a10,a1,L		;Get * next digit 1 img
	jrnz	bnc200

	movk	1,a2
	move	-*a11,a1,L
	jrz	bnc800
bnc150	move	a8,a6
	move	a9,a8
	move	*a8(OFLAGS),a4
	calla	ANI			;New frame
	move	a6,a8

	movi	digit_t+10*32,a10
	move	-*a10,a1,L
bnc200	move	*a8(OFLAGS),a4
	calla	ANI			;New frame

	SLEEPK	6

	move	@STATUS,a0
	jrz	bnc400
	calla	SCRTST
	jrz	bnc100
bnc400	clr	a2
	movi	DISSND,a0
	calla	ONESND

bnc800	calla	DELOBJA8
	move	a9,a0
	calla	DELOBJ
	move	*a12+,a8,L

	clr	a0
	move	a0,@SLOW_DWN

	move	a2,a0			;>A0=Explode (!0=Yes)
	RETP				;Pass CC

;	.long	0
;digit_t	.long	WTIMER0,WTIMER1,WTIMER2,WTIMER3,WTIMER4
;	.long	WTIMER5,WTIMER6,WTIMER7,WTIMER8,WTIMER9


********************************
* Neutron blow up stuff

 SUBRP	bombn_2

	movk	1,a0
	move	a0,@DONT_WARP
	CREATE0	warp_delay
	CREATE0	bombn_reset
	SLEEPK	3
	calla	CLNPAL
	CREATE	FUTUREPID,bombn_expsnd
	movi	bombnpal_t,a0
	movk	1,a1
	calla	PAL_TOWHT
	SLEEPK	16

	move	@PLYRPRCS,a0,L		;>Kill both players
	jrz	bnp50
	move	*a0(DELYDET),a1
	jrnz	bnp50
	calla	bombn_killp
bnp50	move	@PLYRPRCS+32,a0,L
	jrz	bnp60
	move	*a0(DELYDET),a1
	jrnz	bnp60
	calla	bombn_killp
bnp60	DIE

 SUBRP	warp_delay

	SLEEP	5*60
	clr	a0
	move	a0,@DONT_WARP
	DIE

 SUBRP	bombn_reset

	MOVK	1,A0
	MOVE	A0,@IN_BOMB		;YES, WE ARE IN EXPLOSION
	SLEEP	2*60
	MOVI	NEUTPID,A0
	CALLA	KIL1C
	movi	CLSNEUT+TYPICON+SUBBOMBSN,a0
	CALLA	KILOBJN			;KILL SHADOWS ALSO
	SLEEP	3*60
	CLR	A0
	MOVE	A0,@IN_BOMB
	DIE

********************************
* Neutron explosion sound (Process)

 SUBRP	bombn_expsnd

	movk	15,a10
bnes1	movi	BAMSND,a9
	movk	7,a0
	callr	rndrng0
	addk	3,a0
	btst	0,a0
	jrz	bnes2
	movi	BAMSND2,a9
bnes2	calla	PRCSLP
	move	a9,a0
	calla	ONESND
	dsj	a10,bnes1
	DIE


********************************
* Cleanup neutbomb stuff

 SUBRP	bombn_cleanup

	move	*a13(sbsobj_p),a0,L	;Kill shadow
;TEST
;	MOVE	*A0(OIMG),A1,L
;	CMPI	SMNEUTSHAD,a1
;	JRZ	BC05
;    	LOCKUP
;	EINT
;BC05
	calla	DELOBJ
	movi	BOMBNPID,a0
	calla	KIL1C
	move	*a13(bncyc1_p),a0,L
	JRZ	BC10
	calla	KILL
BC10	move	*a13(bncyc2_p),a0,L
	JRZ	BC20
	calla	KILL
BC20	move	*a13(keepwhp),a0,L	;Whoop snd proc on yet?
	jrz	bncu2
	calla	KILL
bncu2	clr	a0
	move	a0,@bombnon
	rets

********************************
* Player grabs spider egg

 SUBR	spidegg_touch	;A0=*Player obj, A8=*Egg obj

	PUSH	a1,a2,a3,a4,a5,a6,a7,a9,a10,a11

	movk	1,a3
	move	a3,@OUT_FLG		;Stop scan

	move	a0,a11			;Pass to process
	move	*a0(OPLINK),a10,L
	move	*a10(PNUM),a10

	movi	P1DATA,a2
	subk	1,a10
	jrz	set5			;P1?
	movi	P2DATA,a2

set5	move	*a2(TWPNS),a0
	subk	1,a0
	move	a0,*a2(TWPNS)

	movi	EGGPT,a1			;50 pts per egg
	calla	SCRADD2

	move	*a8(OPLINK),a9,L
	move	*a9(sbsobj_p),a0,L	;Kill shadow
	jrz	set20
	calla	DELOBJ

set20
	movi	300,a0
	move	a0,*a8(OZPOS)
	movi	DMAWNZ+M_NOCOLL,a0
	move	a0,*a8(OFLAGS)

	move	a9,a0
	movi	FUTUREPID,a1
	movi	spidegg_die,a7
	calla	XFERPROC

	PULL	a1,a2,a3,a4,a5,a6,a7,a9,a10,a11
	rets


 SUBRP	spidegg_die	;A10=Plyr # 0-1

	move	@PCNT,a0
	sll	32-2,a0
	srl	32-2-5,a0
	addi	sed_l,a0
	move	*a0,a0,L
	calla	ONESND
	calla	CYCLEON
	movi	eggb_l,a9
	JSRP	FRANIMQ
	clr	a11
	jauc	INHERE			;FLY OFF TO SCOREBOARD

sed_l	.long	EGG1,EGG2,EGG3,EGG4
EGG1	.word	>F395,08,>8092,0 
EGG2	.word	>F395,08,>8093,0 
EGG3	.word	>F395,08,>8094,0 
EGG4	.word	>F395,08,>8095,0

eggb_l	LWL	EGGBON,NEWPALET+2,PPLP
	.long	0	


********************************
* Shawn type hit by bullet


 SUBR	slt_hit		;A0=*Bullet obj, A8=*Shawn type obj

	PUSH	a1,a2,a3,a4,a5,a6,a7,a9,a10,a11

	movk	1,a3
	move	a3,@OUT_FLG		;Stop scan

	move	a0,a11			;A11=*Bullet obj

	movb	*a8(OID),a2		;Missile?
	cmpi	SUBMSL,a2
	jrz	missile_hit

	movi	>3f3f0000,a9		;Flash color
	CREATE0	FLASHME

	subk	SUBSM,a2
	jrz	spidm_hit

					;>Spider
	movk	3,a0			;>Random death 12.5%
	callr	rnd
	jrz	slt_hitdie

	move	a11,a0
	movi	100,a3			;Max absorb
	calla	DO_PUNISH
	jrge	slt_hitdie

	move	*a8(OPLINK),a1,L
	movk	1,a0
	move	a0,*a1(sbhit)		;Set hit
	clr	a0
	move	a0,*a1(sbseekr)		;No random
	move	a0,*a1(sbseekt)		;No straight jump
	move	*a1(sbsobj_p),a8,L
	jrz	sh300

	move	*a1(sbvhitsl),a0	;Hits left?
	jrz	sh300
	subk	1,a0
	move	a0,*a1(sbvhitsl)

	move	*a11(OXVEL),a0,L
	move	*a11(OYVEL),a1,L

	move	*a8(OXVEL),a2,L		;Add in bullet XYV
	add	a0,a2
	move	a2,*a8(OXVEL),L
	move	*a8(OYVEL),a2,L
	add	a1,a2
	move	a2,*a8(OYVEL),L

	movi	flingsnd,a0
	calla	ONESND

sh300	PULL	a1,a2,a3,a4,a5,a6,a7,a9,a10,a11
	rets




 SUBRP	missile_hit

	move	*a8(OPLINK),a1,L
	move	*a1(PDATA),a0
	subk	1,a0
	jrle	slt_hitdie		;Dead?
	move	a0,*a1(PDATA)

	movi	>9090000,a9		;Flash color
	CREATE0	FLASHME
	jruc	sh300



 SUBRP	spidm_hit

	move	a11,a0
	movi	450,a3			;Spid mom absorb
	calla	DO_PUNISH
	jrlt	sh300
	move	@WORLDTLY+16,a0		;Check for Y low enuff on scrn
	move	*a8(OYPOS),a1
	addi	105,a0
	cmp	a0,a1
	jrlo	sh300
;okay to kill mom


********************************
* Shawn type absorbed max hits


 SUBRP	slt_hitdie		;A8=*Shawn type obj, A11=*Bullet obj

	clr	a5
	move	*a11(OPLINK),a10,L
	movi	P1DATA,a2
	move	*a10(MYPLYR),a0		;Player #
	subk	1,a0
	jrz	slt_scoredie
	movi	P2DATA,a2
	jruc	slt_scoredie



********************************
* Shawn type hit by Rings, bomb cloud or blade

 SUBR	slt_ringhit	;A0=*Killer obj, A8=*Shawn type obj

	PUSH	a1,a2,a3,a4,a5,a6,a7,a9,a10,a11
	move	*a0(OPLINK),a10,L
	clr	a5

	movb	*a8(OID),a2		;Missile?
	subk	SUBMSL,a2
	jrne	srh50
	movi	missile_shrapexp,a5
srh50	move	*a10(PNUM),a0
	jruc	slbbh


 SUBR	slt_bbhit	;A0=*Killer obj, A8=*Shawn type obj

	PUSH	a1,a2,a3,a4,a5,a6,a7,a9,a10,a11

	move	*a0(OPLINK),a10,L
	move	*a10(MYPLYR),a0
	clr	a5

slbbh	movk	1,a3
	move	a3,@OUT_FLG		;Stop scan

	movi	P1DATA,a2
	subk	1,a0
	jrz	slt_scoredie		;P1?
	subk	1,a0
	jrnz	slt_die			;P2?
	movi	P2DATA,a2


 SUBRP	slt_scoredie	;A2=*PxDATA, A5=*Diff expprc or 0, A8=*Shawn type obj
			;Must save regs before call!

	movb	*a8(OID),a1
	sll	32-4,a1
	srl	32-7,a1			;*8
	addi	sltscore_t,a1
	movb	*a1,a1			;Get score
	calla	SCRADD2			;Score it!

 SUBRP	slt_die		;A5=^, A8=*Shawn type obj
			;Must save regs before call!

	move	*a8(OPLINK),a9,L	;A9=*OPLINK

	movb	*a8(OID),a1
	sll	32-4,a1
	srl	32-9,a1			;*32
	addi	sltdie_t,a1
	move	*a1,a6,L
	exgpc	a6			;Do cleanup! Passes A6,A8,A9
					;Returns A7
	move	a5,a5
	jrz	sltd5
	move	a5,a7			;Set new explosion process

sltd5	move	a9,a0
	movi	FUTUREPID,a1
	calla	XFERPROC

	move	*a8(OFLAGS),a0
	ori	M_NOCOLL,a0
	move	a0,*a8(OFLAGS)
	movi	CLSDEAD,a0
	move	a0,*a8(OID)

	PULL	a1,a2,a3,a4,a5,a6,a7,a9,a10,a11
	rets

sltscore_t
	.byte	SPDBPTS,SPDMPTS,1,0,0,0,0,0
	.byte	0,0,0,0,0,0,0,0

sltdie_t
	.long	spidb_die,spidm_die,missile_die,0
	.long	0,0,0,0
	.long	0,0,0,0
	.long	0,0,0,0


 SUBRP	spidb_die

	move	@SKIPR_CNT,a0
	subk	1,a0
	move	a0,@SKIPR_CNT

	move	*a9(sbsobj_p),a0,L
	jrz	sbdx
	calla	DELOBJ

sbdx	movi	spidb_exp,a7
	exgpc	a6


 SUBRP	spidm_die

	movi	spidm_exp,a7
	exgpc	a6


 SUBRP	missile_die
	movi	missile_exp,a7
	exgpc	a6



********************************
* Explosion code

 SUBRP	missile_shrapexp

	CREATE0	missile_shrapoff
	movk	10,a1
	move	a1,*a0(PTIME)

	clr	a0
	move	a0,*a8(OXVEL),L
	move	a0,*a8(OYVEL),L

	movi	DMAWNZ,a4
	move	a4,*a8(OFLAGS)
	movi	CLSENMY|TYPLAYR|SUBFLM,a5	;Flames plyr
	move	a5,*a8(OID)
	movi	SHRAPPID,a0			;So smartbomb will kill proc
	move	a0,*a13(PROCID)
	movi	xpldp_l,a9
	jruc	me50


 SUBRP	missile_shrapoff

	movi	DMAWNZ+M_NOCOLL,a0
	move	a0,*a8(OFLAGS)
	DIE


 SUBRP	missile_exp

	movi	cldbyell_l,a9
me50	movi	mslexpsnd,a0
	calla	ONESND
	move	*a8(OYPOS),a0
	addk	25,a0
	move	a0,*a8(OYPOS)
	movi	168,a0
	move	a0,*a8(OZPOS)
	jauc	FRQDELDIE


xpldp_l	LWL	XPLD1,NEWPALET|4,PURPPAL
	LW	XPLD2,4
	LW	XPLD3,4
	LW	XPLD4,4
	LW	XPLD5,4
	LW	XPLD6,4
	LW	XPLD7,3
	LW	XPLD8,3
	LW	XPLD9,3
	LWL0	XPLD10,3

cldbyell_l
	LWL	CLDB1,NEWPALET|2,YELLPAL
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



 SUBRP	spidm_exp

	SLEEPK	2		;Makes sure FLASHME is gone!

	movi	GLSEXP,a0
	calla	ONESND
	movk	7,a0		;Shoot 7-14 eggs
	callr	rnd
	addk	7,a0
	move	a0,a4
sme20	movi	>3ff,a0
	callr	rnd
	move	a0,a10
	addi	60,a10
	CREATE	shawnpid,spidb_shootegg
	dsj	a4,sme20

	move	@PCTOT,a0
	subk	20,a0
	jrgt	sme200
	clr	a9			;A9=XVel
	movi	>10000,a10		;A10=YVel
	movi	spidmomch_t,a11
	CREATE	CMAN,CHUNK_OBJ
	move	a9,*a0(PDATA)		;no pal change

	SLEEPK	2
	movi	AGLSEXP,a0
	calla	ONESND
	movi	crashsnd,a0
	calla	ONESND
	jauc	DELOBJDIE

sme200	movi	BLUEEXP,a9
	jauc	FRQDELDIE


spidmomch_t
	.long	SCHUNK1,spidcnk1_l,spidcnk2_l,spidcnk3_l,spidcnk4_l
	.long	spideggp1_l,spideggp2_l,spideggp3_l,spideggp4_l
	.long	BLUEEXP,BLUEEXP,BLUEEXP,FIREEXP,FIREEXP,FIREEXP,0

spidcnk1_l
	LW	SCHUNK6,7
spidcnk2_l
	LW	SCHUNK6,7
spidcnk3_l
	LW	SCHUNK6,7
spidcnk4_l
	LW	SCHUNK6,1
	LW	SCHUNK5,4
	LW	SCHUNK4,4
	LW	SCHUNK3,4
	LW	SCHUNK2,5
	LW	SCHUNK1,5
	LWW	SCHUNK2,FLIPBITS|4,M_FLIPH
	LW	SCHUNK3,4
	LW	SCHUNK4,4
	LW	SCHUNK5,4
	LWL0	SCHUNK6,4

spideggp1_l
	LW	SEGG6,8
spideggp2_l
	LW	SEGG6,8
spideggp3_l
	LW	SEGG6,7
spideggp4_l
	LW	SEGG6,4
	LW	SEGG5,4
	LW	SEGG4,4
	LW	SEGG3,4
	LW	SEGG2,5
	LW	SEGG1,4
	LWW	SEGG2,FLIPBITS|4,M_FLIPH
	LW	SEGG3,5
	LW	SEGG4,4
	LW	SEGG5,4
	LWL0	SEGG6,4


	NOTINUSE
spidleg_l
	LW	SLEG7,2
	LW	SLEG6,2
	LW	SLEG5,2
	LW	SLEG4,2
	LW	SLEG3,2
	LW	SLEG2,2
	LW	SLEG1,2
	LW	SLEG2,FLIPBITS|5
	.word	M_FLIPH
	LW	SLEG3,2
	LW	SLEG4,2
	LW	SLEG5,2
	LW	SLEG6,2
	LWL0	SLEG7,2
	.endif



 SUBRP	spidb_exp

	movi	ALTEXP1,a0
	move	@PCNT,a1
	btst	0,a1
	jrz	sbe10
	movi	SQUISH,a0	;EXP1L,A0
sbe10	calla	ONESND
	SLEEPK	2		;Makes sure FLASHME is gone!
	movi	spidbexp_l,a9
	jauc	FRQDELDIE


spidbexp_l
	LW	SDEATH1,4
	LW	SDEATH2,4
	LW	SDEATH3,5
	LW	SDEATH4,5
	LW	SDEATH5,5
	LWL0	SDEATH6,4


********************************
* Smart bomb shawn type objects

 SUBR	slt_smartbomb	;A8=*Shawn type obj to smart bomb
			;A9=*P1DATA or P2DATA for score update

	PUSH	a1,a2,a3,a4,a5,a6,a7,a9,a10,a11

	clr	a0
	move	a0,*a8(OXVEL),L
	move	a0,*a8(OYVEL),L

	move	a9,a2
	movi	slt_smrtbexp,a5		;Overide explosions

	jruc	slt_scoredie


 SUBRP	slt_smrtbexp

	move	*a8(OYPOS),a0
	addi	35,a0
	move	a0,*a8(OYPOS)
	movi	300,a0
	move	a0,*a8(OZPOS)

	move	@EXPCNT,a0		;# explosions
	cmpi	23,a0			;Max
	jrhs	ssbe5
	addk	1,a0
	move	a0,@EXPCNT
	movi	XBOOM2,a9
	jauc	FRQDELDIE

ssbe5	jauc	DELOBJDIE



********************************
* Missile tank (Process)

 SUBRP	msltnk

	callr	obj_get
mst100	movi	>ff,a0
	callr	rnd
;	movk	7,a0		;DEBUG
	calla	PRCSLP
	movk	5,a11		;#Shots in pattern
	clr	a10
mst200
	movi	mtmpat_t,a9
	CREATE	shawnpid,rocket_fire
	addk	32,a9
	addk	1,a10
;	SLEEPK	1
	dsj	a11,mst200
	jruc	mst100
	DIE

mtmpat_t	;Missiles!
	.word	10,10, 0,0, 20,0, 0,20, 20,20


********************************
* Missile strike from off screen (Process)

 SUBRP	mslstrike

	DIE
mss100	movi	>ff,a0
	callr	rnd
	calla	PRCSLP
	movk	20,a11		;#Shots in pattern
	clr	a2
	move	@WORLDTLY+16,a9
mss200
	move	@WORLDTLX+16,a8
	add	a2,a8
	movk	16,a10
	CREATE	shawnpid,rocket_firexy
	move	@WORLDTLX+16,a8
	addi	400,a8
	sub	a2,a8
	movk	16,a10
	CREATE	shawnpid,rocket_firexy

	addk	20,a2
	move	a2,a8
	SLEEPK	3
	move	a8,a2
	dsj	a11,mss200
	jruc	mss100
	DIE


********************************
* Missile, player seeking (Process)

	WORDPD	missfuel,0	;Fuel 0-?

 SUBRP	missile_fire		;A8=*Src obj, A9=*Offset_t, A10=Dir 0-31

	movi	200,a0
	move	a0,*a13(missfuel)

	move	*a8(OXPOS),a0
	move	*a8(OYPOS),a1
	move	*a9+,a2			;+X offset
	add	a2,a0
	move	*a9+,a2			;+Y offset
	add	a2,a1
	sll	16,a0
	sll	16,a1
	movi	MSL1,a2			;Image
	move	*a8(OZPOS),a3
	addk	1,a3
	movi	DMAWNZ,a4
	movi	CLSENMY+TYPSL+SUBMSL,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	jruc	mif300

mif200	SLEEPK	1
	calla	getcloseplyr
	jrz	mif700
	callr	seekob_dir32

	sub	a10,a0			;A0=Difference
	jreq	mif500
	move	a0,a1
	abs	a0
	subk	16,a0
	jrle	mif250
	neg	a1
mif250	move	a1,a1
	jrnn	mif260
	subk	2,a10			;-1
mif260	addk	1,a10			;+1

mif300	ANDK	>1f,a10			;Make 0-31

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

	move	*a8(OXVEL),a0,L
	move	a0,a1
	sra	7,a1
	sub	a1,a0			;-Drag
	add	a6,a0			;+Vel
	move	a0,*a8(OXVEL),L
	move	*a8(OYVEL),a0,L
	move	a0,a1
	sra	7,a1
	sub	a1,a0			;-Drag
	add	a7,a0			;+Vel
	move	a0,*a8(OYVEL),L

mif700	move	*a13(missfuel),a0
	subk	1,a0
	move	a0,*a13(missfuel)
	jrgt	mif200

	movi	BOOM3,a9		;Out of fuel!
	jauc	FRQDELDIE

missileimg_t
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


missilev_t
	.word	-4000,-3923,-3696,-3326,-2828,-2222,-1531,-780	;Y
	.word	0,780,1530,2222,2828,3326,3695,3923		;X
	.word	4000,3923,3695,3326,2828,2222,1530,780
	.word	0,-780,-1530,-2222,-2828,-3326,-3695,-3923
	.word	-4000,-3923,-3696,-3326,-2828,-2222,-1531,-780



********************************
* Rocket, arcs toward player (Process)

	WORDPD	rockfuel,0	;Fuel 0-?

 SUBRP	rocket_firexy		;A8.W=XPos, A9.W=YPos, A10=Dir 0-31

	move	a8,a0
	move	a9,a1
	movi	160,a3
	movk	1,a11
	jruc	rof100

 SUBRP	rocket_fire		;A8=*Src obj, A9=*Offset_t, A10=Dir 0-31

	clr	a11

	move	*a8(OXPOS),a0
	move	*a8(OYPOS),a1
	move	*a9+,a2			;+X offset
	add	a2,a0
	move	*a9+,a2			;+Y offset
	add	a2,a1
	move	*a8(OZPOS),a3
	addk	1,a3
rof100	sll	16,a0
	sll	16,a1
	movi	MSL1,a2			;Image
	movi	DMAWNZ,a4
	movi	CLSENMY+TYPSL+SUBMSL,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2

	movi	100,a0
	move	a0,*a13(rockfuel)

	jruc	rof300

rof200	SLEEPK	1
	move	a11,a11
	jrnz	rof500

	move	*a13(rockfuel),a0
	cmpi	90,a0
	jrlt	rof500

	calla	getcloseplyr
	jrz	rof700
	callr	seekob_dir32

	sub	a10,a0			;A0=Difference
	jreq	rof500
	move	a0,a1
	abs	a0
	subk	16,a0
	jrle	rof250
	neg	a1
rof250	move	a1,a1
	jrnn	rof260
	subk	2,a10			;-1
rof260	addk	1,a10			;+1

rof300	ANDK	>1f,a10			;Make 0-31

	move	a10,a0
	sll	4,a0			;*16
	move	a0,a1			;*3
	add	a1,a0
	add	a1,a0
	addi	missileimg_t,a0
	move	*a0+,a1,L
	move	*a0,a4
	calla	ANI			;New frame

rof500	move	a10,a0
	sll	4,a0			;*16
	addi	missilev_t,a0
	move	*a0(8*16),a6		;XV
	move	*a0,a7			;YV
	sll	1,a6
	sll	1,a7

	move	*a8(OXVEL),a0,L
	move	a0,a1
	sra	7,a1
	sub	a1,a0			;-Drag
	add	a6,a0			;+Vel
	move	a0,*a8(OXVEL),L
	move	*a8(OYVEL),a0,L
	move	a0,a1
	sra	7,a1
	sub	a1,a0			;-Drag
	add	a7,a0			;+Vel
	move	a0,*a8(OYVEL),L

rof700	move	*a13(rockfuel),a0
	subk	1,a0
	move	a0,*a13(rockfuel)
	jrgt	rof200

	movi	BOOM3,a9		;Out of fuel!
	jauc	FRQDELDIE


********************************
* Get an object

 SUBRP	obj_get		;A8=*Data
	move	*a8+,a0			;Get X
	move	*a8+,a1			;Get Y
	sll	16,a0
	sll	16,a1
	move	*a8+,a3			;Get Z
	move	*a8+,a4			;Flags
	move	*a8+,a5			;ID
	move	*a8+,a2,L		;*Img
	clr	a6
	clr	a7
	calla	BEGINOBJ
	rets			;>A8=*Object


********************************
* Get random # with mask
* Preserves Regs 2-13

 SUBRP	rnd			;A0=Mask, A1/B0=Trashed!

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

 SUBRP	rndrng0			;A0=X

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
* Test random # function for randomness

	NOTINUSE
	.bss	test,16*256

 SUBR	test_rnd

tr10	clr	a0
	movi	test,a1
	movi	256/2,a2
tr20	move	a0,*a1+,L
	dsj	a2,tr20

	movi	test,a3
tr50	clr	a0
	movi	7,a1
	calla	RNDRNG
	sll	4,a0		;*16
	add	a3,a0
	move	*a0,a1
	addk	1,a1
	jrz	trx
	move	a1,*a0
	jruc	tr50

trx	jrz	trx
	jruc	tr10
	rets
	.endif

********************************
* Get velocity to move towards an object

 SUBRP	seekob_vel	;A0=*Dest obj, A3=Vel, A8=*Src obj

	PUSH	a0

	move	*a0(OXPOS),a6		;Get X
	move	*a0(OSIZEX),a2
	srl	1,a2
	add	a2,a6			;Center X
	move	*a0(OYPOS),a7		;Get Y
	move	*a0(OSIZEY),a2
	srl	1,a2
	add	a2,a7			;Center Y
	sll	16,a6
	sll	16,a7

	move	*a8(OXPOS),a0		;Get X
	move	*a8(OSIZEX),a2
	srl	1,a2
	add	a2,a0			;Center X
	move	*a8(OYPOS),a1		;Get Y
	move	*a8(OSIZEY),a2
	srl	1,a2
	add	a2,a1			;Center Y
	sll	16,a0
	sll	16,a1

	sub	a0,a6			;DestX-SrcX
	sub	a1,a7			;DestY-SrcY


sov60	sra	1,a6			;>Scale down to A3
	sra	1,a7
	move	a6,a2
	abs	a2
	cmp	a3,a2			;A6&A7 < A3
	jrgt	sov60
	move	a7,a2
	abs	a2
	cmp	a3,a2
	jrgt	sov60

	move	a6,a4			;>Fine scale up to A3
	move	a7,a5
	sra	4,a4			;/16
	sra	4,a5
	jrnz	sov150
	move	a4,a4
	jrz	sov200			;Both 0 then skip
sov150	add	a4,a6
	add	a5,a7
	move	a6,a2
	abs	a2
	cmp	a3,a2
	jrgt	sov200
	move	a7,a2
	abs	a2
	cmp	a3,a2
	jrle	sov150

sov200
	PULL	a0
	rets				;>A6=XV, A7=YV


********************************
* Get dir to face an object

 SUBRP	seekob_dir32	;A0=*Dest obj, A8=*Src obj

	move	*a0(OXPOS),a6		;Get DX
	move	*a0(OSIZEX),a2
	srl	1,a2
	add	a2,a6			;Center X
	move	*a0(OYPOS),a7		;Get DY
	move	*a0(OSIZEY),a2
	srl	1,a2
	add	a2,a7			;Center Y

	move	*a8(OXPOS),a0		;Get SX
	move	*a8(OSIZEX),a2
	srl	1,a2
	add	a2,a0			;Center X
	move	*a8(OYPOS),a1		;Get SY
	move	*a8(OSIZEY),a2
	srl	1,a2
	add	a2,a1			;Center Y

	clr	a2			;Octant 0-1
	sub	a6,a0			;A0=SrcX-DestX
	jrnn	sod100
	abs	a0
	sub	a7,a1			;A1=SrcY-DestY
	jrnn	sod200
	movk	8,a2			;Oct 2-3
	abs	a1
	jruc	sod160

sod100	movk	16,a2			;Oct 4-5
	sub	a7,a1			;A1=SrcY-DestX
	abs	a1
	jrnn	sod200
	movk	16+8,a2			;Oct 6-7
sod160	SWAP	a0,a1

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
* Get sine

 SUBR	sine_get		;A0=0-81 (PI-Half circle)
	cmpi	41,a0		;Max table range
	jrlo	sin10
	neg	a0
	addi	81,a0		;-Table range
	jrnn	sin10
	clr	a0
sin10	sll	4,a0		;*16
	addi	sine_t,a0
	move	*a0,a0
	zext	a0		;>A0=Sin 0-4096
	rets


sine_t	.word	0,158,317,475,633,789,944,1098
	.word	1251,1401,1549,1695,1838,1979,2117,2251
	.word	2382,2510,2633,2753,2869,2980,3087,3189
	.word	3286,3379,3466,3548,3625,3696,3762,3822
	.word	3876,3925,3967,4004,4035,4059,4078,4090
	.word	4096


********************************
* Get animation offset
*	A0=*Obj
*
* Rets:	A6=X Anim offset
*	A7=Y Anim offset
* Trash A1,A2

GANIOFQA8
	move	a8,a0
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


	.end
