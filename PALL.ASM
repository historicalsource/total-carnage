**************************************************************
*
* Software:		? and MARK TURMELL
* Initiated:		APRIL 13,1989 (palstuff)
*
* Modified:		Shawn Liptak, 7/23/91	-New FADEIN/OUT
* 			Shawn Liptak, 7/28/91	-Merged with fbstuff
* 			Shawn Liptak, 8/12/91	-PAL_TOWHT/PAL_FMWHT
* 			Shawn Liptak, 8/21/91	-Merged pall & palstuff
* 			Shawn Liptak, 9/13/91	-Clean up!
* 			Shawn Liptak, 9/17/91	-New PAL struct
* 			Shawn Liptak, 11/19/91	-Improved GETxPAL with CLNPAL
*
* COPYRIGHT (C) 1991 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 1/7/92 15:02
**************************************************************
	.TITLE	'PALETTE ALLOCATOR V1.0 AND FADER CONTROL'
	.FILE	'PALL.ASM'
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST


	.include	"mproc.equ"
	.include	"disp.equ"
	.include	"\video\sys\sys.inc"
	.include	"\video\sys\gsp.inc"
	.include	"bgndtbl.glo"
	.include	"imgtbl.glo"
	.include	"game.equ"
	.include	"shawn.hdr"		;Macros


;PALETTE SUBROUTINE EQUATES
	.GLOBAL	GETFPAL,PALTRANS,CLRBPAL,INITPAL,CLRFPAL,FINDPAL
	.GLOBAL	GETBPAL,INITBPAL,CLRPAL
	.GLOBAL	PALSET,CLNPAL			;,CLNBPAL
;	.global	DELPAL,FREEPAL
	.global	UNGETPAL
;RAM EQUATES
	.GLOBAL	PALRAM,FPALRAM,BPALRAM,PTRRAM


;SYMBOLS EXTERNALLY DEFINED

	.REF	SCOREPAL
	.REF	RANGRAND
	.REF	IRQSKYE,REACTR,RANDPER
	.REF	EXP2
	.ref	WAVE

;SYMBOLS DEFINED IN THIS FILE

	.DEF	PUMP_RED,PCOUNT,PUMP_CLDS
	.DEF	BLAKOUT
	.DEF	FB_FADEOUT,FB_FADEIN

;EQUATES FIRST ORIGINATED IN THIS FILE

FPALNUM	.equ	8
FPALSZ	.equ	65*16


;UNINITIALIZED RAM DEFINITIONS


	.BSS	FADERAM	,FPALSZ*FPALNUM	;Fade mem for palettes
	.BSS	PCOUNT	,16
	.BSS	KPBASE	,32
	.bss	irqskyeo,16		;Orignal autoerase color

	.text

********************************
* Cleanup unused palettes

CLNPAL
	PUSH	a0,a1,a2,a3,a4
	movi	FPALRAM+PALRSIZ,a1	;Skip 1st pal
	movi	NUMPAL-1,a3		;Chk all fgnd pals
	movi	>0101,a4		;2nd PAL #

cp10	move	@OBJLST,a0,L
	jrz	cp30			;No objs, chk backgnd

cp20	move	*a0(OPAL),a2
	cmp	a2,a4
	jreq	cp80			;Found use, chk next
	move	*a0,a0,L
	jrnz	cp20

cp30	move	@BAKLST,a0,L		;Check in bgnd list
	jrz	cp60			;No objects, clean it out

cp50	move	*a0(OPAL),a2
	cmp	a2,a4
	jreq	cp80			;Found use, chk next
	move	*a0,a0,L
	jrnz	cp50

cp60	move	*a1,a0,L
	cmpi	WARPP,a0
	jrne	cp70			;Not warp pal?

	move	a1,a2
	movi	CYCPID,a0
	movi	-1,a1
	calla	EXISTP
	move	a2,a1
	move	a0,a0
	jrnz	cp80			;Found cycler?

cp70	clr	a0			;Palette not used, free it
	move	a0,*a1,L

cp80	addi	>0101,a4		;Next pal
	btst	4,a4
	jrz	cp90
	addi	>3030,a4
	sext	a4			;For compare

cp90	addk	PALRSIZ,a1
	dsj	a3,cp10

	PULL	a0,a1,a2,a3,a4
	rets


********************************
*CLEAR OUT PALETTE ALLOCATION RAM
*Trashes A0-A1, B0

CLRPAL
	MOVI	PALRSIZ*NUMPAL/16,B0	;GET # OF WORDS
CLRPALF	MOVI	FPALRAM,A0		;GET ADDRESS OF RAM

CLRPALB	CLR	A1
clrp5	MOVE	A1,*A0+
	DSJS	B0,clrp5

	MOVI	PTRRAM,A0		;GET ADDRESS OF RAM
	MOVI	PTRSIZ*NUMPTR/16,B0	;GET # OF WORDS

clrp8	MOVE	A1,*A0+
	DSJS	B0,clrp8
	RETS

********************************
*CLEAR ONLY FOREGROUND PALETTES
CLRFPAL
	MOVI	PALRSIZ*NMFPAL/16,B0	;GET # OF WORDS
	JRUC	CLRPALF

********************************
*CLEAR ONLY BACKGROUND PALETTES
CLRBPAL
	MOVI	BPALRAM,A0		;GET ADDRESS OF RAM
	MOVI	PALRSIZ*NMBPAL/16,B0	;GET # OF WORDS
	JRUC	CLRPALB


**************************************************************************
*									 *
* FINDPAL - FIND THE COLOR MAP # TO WHICH THE GIVEN PALETTE IS ASSIGNED. *
* A0 = 32 BIT PALETTE ADDRESS						 *
* RETURNS:								 *
* Z BIT SET = PALETTE NOT FOUND ---> A0 = 0				 *
* Z BIT CLR = PALETTE FOUND ---> A0 = PALETTE #(CORRECT FORMAT FOR DMA)	 *
*									 *
**************************************************************************
FINDPAL
	PUSH	a1,a2,a3
	movi	PALRAM,a1
	movi	NUMPAL,a3
findp0
	move	*a1+,a2,L	;Get * palette
	cmp	a0,a2
	jreq	findp1		;Found?
	dsjs	a3,findp0
	clr	a0		;Failure, SET Z BIT
	jruc	findpx

findp1	subi	NUMPAL,a3	;COMPUTE PALETTE #
	neg	a3

	.if	YUNIT
	movk	>f,a2
	and	a3,a2		;A2=4 low bits
	srl	4,a3		;Move B4/B5 to B6/B7
	sll	6,a3
	add	a2,a3
	.endif

	move	a3,a0		;Return palette #
	sll	8,a3
	add	a3,a0		;double it up for loffredo brain damage
	addk	1,a3		;Clr Z (OK)
findpx	PULL	a1,a2,a3
	rets


**************************************************************************
* INITPAL - Get a foreground palette for use
* A14=* to object initialization table
*Rets:
* Z Clr if OK (CURPAL = palette # just created)
* Z Set if error

INITPAL
	PUSH	a0
	move	*a14(INITIMG),a0,L
	move	*a0(ICMAP),a0,L		;Get *palette
	callr	GETFPAL
	jrz	ipx			;Error?
ipok	move	a0,@CURPAL		;Save pal #
	addk	1,a0			;Clr Z
ipx	mmfm	sp,a0
	rets

**************************************************************************
* INITBPAL - Get a background palette for use
* A14=* to object initialization table
*Rets:
* Z Clr if OK (CURPAL = palette # just created)
* Z Set if error

INITBPAL
	PUSH	a0
	move	*a14(INITIMG),a0,L
	move	*a0(ICMAP),a0,L		;Get *palette
	callr	GETBPAL
	jrnz	ipok			;Ok?
	mmfm	sp,a0
	rets


********************************
* Get a foreground palette
* A0=*Palette
*Rets:
* A0=Color map allocated (0000-cfcf)
* Z set if no palette free

GETFPAL
	PUSH	a1,a2,a3
	movi	PALRAM,a1	;>Check if palette already exists
	movi	NUMPAL,a3

gfp4	move	*a1+,a2,L	;Get *palette
	cmp	a0,a2
	jreq	getpn		;Already in color ram?
	dsj	a3,gfp4

	movi	FPALRAM,a1	;>Check for a spare palette
	movk	NMFPAL,a3
gfp8	move	*a1+,a2,L
	jrz	getfp		;Palette empty? Grab it
	dsj	a3,gfp8

	.if	DEBUG
	LOCKUP
	eint
	.endif
	callr	CLNPAL

	movi	FPALRAM,a1	;>Check for a spare palette
	movk	NMFPAL,a3
gfp20	move	*a1+,a2,L
	jrz	getfp		;Palette empty? Grab it
	dsj	a3,gfp20

getperr	clr	a0		;Set Z error
	jruc	getpx


********************************
* Get a background palette
* A0=*Palette
*Rets:
* A0=Color map allocated (0000-cfcf)
* Z set if no palette free

GETBPAL
	PUSH	a1,a2,a3
	movi	PALRAM,a1	;>Check if palette already exists
	movi	NUMPAL,a3

gbp4	move	*a1+,a2,L	;Get *palette
	cmp	a0,a2
	jreq	getpn		;Already in color ram?
	dsj	a3,gbp4

	movi	BPALRAM,a1	;>Check for a spare palette
	movk	NMBPAL,a3
gbp8	move	*a1+,a2,L
	jrz	gbp30		;Palette empty? Grab it
	dsj	a3,gbp8

	.if	DEBUG
	LOCKUP
	eint
	.endif
	callr	CLNPAL

	movi	BPALRAM,a1	;>Check for a spare palette
	movk	NMBPAL,a3
gbp10	move	*a1+,a2,L
	jrz	gbp30		;Palette empty? Grab it
	dsj	a3,gbp10
	jruc	getperr


getfp	addk	NMBPAL,a3	;>Setup your new palette

gbp30	PUSH	a0,a1
	move	a3,a1		;Palette #
	subi	NUMPAL,a1	;Compute palette #
	neg	a1

	.if	YUNIT
	movk	>f,a2
	and	a1,a2		;A2=4 low bits
	srl	4,a1		;Move B4/B5 to B6/B7
	sll	6,a1
	add	a2,a1
	.endif

	sll	8,a1		;*256
	move	*a0+,a2		;Get # colors in pal
	callr	PALSET		;Setup pal transfer
	jrz	getperr		;Failed to get transfer?
	PULL	a0,a1
	subk	32,a1
	move	a0,*a1+,L	;Stuff palette *

getpn	subi	NUMPAL,a3	;Compute palette #
	neg	a3

	.if	YUNIT
	movk	>f,a2
	and	a3,a2		;A2=4 low bits
	srl	4,a3		;Move B4/B5 to B6/B7
	sll	6,a3
	add	a2,a3
	.endif

	move	a3,a0		;Return palette #
	sll	8,a3
	add	a3,a0		;Double it up for DMA

	addk	1,a3		;Clr Z for OK

getpx	PULL	a1,a2,a3
	rets			;Pass Z


**************************************************************************
*									 *
* DELPAL - DELETE AN OBJECTS PALETTE					 *
* A0 = PTR TO OBJECT							 *
*									 *
**************************************************************************
;DELPAL
;	PUSH	a0
;	move	*a0(OPAL),a0
;	callr	FREEPAL
;	PULL	a0
;	rets

********************************
*Free a palette
*A0=Palette # (0 to NUMPAL-1) to free

;FREEPAL
;	PUSH	a0,a1
;
;	SLL	32-8,A0		;MASK OFF GARBAGE
;	SRL	32-8,A0
;
;	.if	YUNIT
;	movk	>f,a1
;	and	a0,a1		;A1=4 low bits
;	srl	6,a0		;Move B6/B7 to B4/B5
;	sll	4,a0
;	add	a1,a0
;	.endif
;
;	cmpi	NUMPAL,a0
;	jrhs	freepalerr	;Bad pal #?
;
;	movi	PALRSIZ,a1
;	mpyu	a0,a1
;	addi	PALRAM+32,a1
;	move	*a1,a0
;	subk	1,a0		;Decrement its count
;	jrnn	freepal2
;
;	.if	DEBUG
;	LOCKUP
;	EINT
;	.endif
;	clr	a0
;
;freepal2
;	move	a0,*a1		;New cnt
;	jrnz	fpalx
;	move	a0,-*a1,L	;Clr *pal
;
;fpalx	PULL	a0,a1
;	rets
;
;freepalerr
;	.if	DEBUG
;	LOCKUP
;	EINT
;	.endif
;	jruc	fpalx


********************************
*UNGETPAL - Clears out a palettes allocation count
*A0=Palette # (0 to NUMPAL-1) to unallocate

UNGETPAL
	PUSH	a0,a1
	sll	32-8,a0		;mask off garbage
	srl	32-8,a0

	.IF	YUNIT
	movk	>f,a1
	and	a0,a1		;A1=4 low bits
	srl	6,a0		;Move B6/B7 to B4/B5
	sll	4,a0
	add	a1,a0
	.ENDIF

	cmpi	NUMPAL,a0
	jrlo	ungp1		;Pal # ok?

	.IF	DEBUG
	LOCKUP
	eint
	.ENDIF
	jruc	ungpx

ungp1	movk	PALRSIZ,a1
	mpyu	a0,a1
	addi	PALRAM,a1
	clr	a0
	move	a0,*a1,L

ungpx	PULL	a0,a1
	rets



********************************
* Setup palette transfer
* A0= PALSRC = * to palette color data
* A1= PALDEST= Bit 8-15 destination palette | Bit 0-7 start color
* A2= PLDCNT = 16 bit color count
*Rets: Z if unable to setup transfer, NZ if transfer OK

PALSET
	PUSH	a3,a4,a5
	movi	PTRRAM,a4
	movi	NUMPTR,a3	;# of palette transfers allowed

psetl	move	*a4+,a5
	jrz	pset5		;Cell free?
	addi	PTRSIZ-16,a4
	dsj	a3,psetl
	.if	DEBUG
	LOCKUP
	eint
	.endif
	jruc	psetx

pset5	cmpi	64,a2
	jrls	pset7
	movi	64,a2
pset7	move	a0,*a4+,L	;Set PALSRC
	move	a1,*a4		;Set PALDEST
	move	a2,*a4(-48)	;Set PLDCNT (Must set last)

psetx	move	a3,a3		;Return Z(not able to load) or NZ (ok)
	PULL	a3,a4,a5
	rets



********************************
* Transfer palette data
* Called during vblank
* Looks through PTRRAM for transfers
* Trashes A0-A13

PALTRANS
	movi	PTRRAM,a0
	movI	NUMPTR,a3	;# OF PALETTES

	clr	a6
	movi	COLRAM,a7

pltlp	move	*a0,a4		;Xfer to do
	jrz	pltx		;End?

	move	a6,*a0+		;Clear out tranfer count
	move	*a0+,a1,L	;Source address
	move	*a0+,a2		;Destination palette
	zext	a2

	.if	YUNIT
	move	a2,a5		;Convert to color ram address
	sll	32-12,a5
	srl	32-12-4,a5	;*16
	srl	14,a2		;Move B14/15 to B6/7
	sll	6+4,a2
	add	a5,a2
	.else
	sll	4,a2		;*16 for word addr
	.endif

	add	a7,a2		;+color ram base address

	srl	1,a4
	jrnc	pltgo1		;Even data count?
	move	*a1+,*a2+

pltgo1	srl	1,a4		;/2 data count
	jrnc	pltgo2		;nope
	move	*a1+,*a2+,L

pltgo2	srl	1,a4		;/2 data count
	jrnc	pltgo3		;nope
	move	*a1+,*a2+,L
	move	*a1+,*a2+,L
pltgo3	jrz	pltgo5		;Cnt=0?

pltgo4	move	*a1+,*a2+,L
	move	*a1+,*a2+,L
	move	*a1+,*a2+,L
	move	*a1+,*a2+,L
	dsj	a4,pltgo4

pltgo5	dsj	a3,pltlp	;done

pltx	rets



********************************
* BLAKOUT - BLACK OUT SELECTED PALETTE
* A0=NAME OF PALETTE TO BLACK OUT

BLAKOUT
	CALLR	FINDPAL
	SLL	8,A0
	MOVE	A0,A1
	JRZ	NOTALLOC
	MOVI	FADERAM,A0
	movk	32,a3
	clr	a2

CLRBLP	MOVE	A2,*A0+,L
	DSJS	A3,CLRBLP
	MOVI	FADERAM,A0		;NOW BLACK OUT PALETTE
	MOVI	64,A2
	CALLR	PALSET			;ERASE PALETTE SLOT
NOTALLOC
	RETS

********************************
* CLOUDS BEHIND REPORTER
* PUMP_RED PROCESS
* CYCLE NUCLEAR REACTORS

PUMP_CLDS
	SLEEPK	3
	MOVI	EXP2,A0
	CALLA	ONESND
	MOVI	CLDSZ,A0
	MOVE	A0,@KPBASE,L
	CALLR	FINDPAL
	JRZ	CREDOUT
	SLL	8,A0
	MOVE	A0,A11			;NEEDED LATER FOR PALSET

	MOVK	7,A10			;PUMP RED A10 TIMES
	MOVI	128,A8
CEDLOOP MOVI	FADERAM,A0
	ADDK	20H,A8
	CALLR	DO_MULT
	SLEEPK	1
	DSJ	A10,CEDLOOP
CREDOUT
	MOVK	7,A10			;PUMP RED A10 TIMES
CRED2	MOVI	FADERAM,A0
	SUBI	20H,A8
	CALLR	DO_MULT
	SLEEPK	1
	DSJ	A10,CRED2
	MOVI	700,A0
	CALLA	RANDPER
	JRNC	PUMP_CLDS
	MOVK	10,B0
	MOVI	3*60,B1
	CALLA	RANGRAND
	CALLA	PRCSLP
	JRUC	PUMP_CLDS


********************************
* PUMP_RED PROCESS, CYCLE NUCLEAR REACTORS

PUMP_RED
	SLEEPK	18H
	MOVI	REACTR,A0
	MOVE	A0,@KPBASE,L
	CALLR	FINDPAL
	JRZ	REDOUT
	SLL	8,A0
	MOVE	A0,A11			 ;NEEDED LATER FOR PALSET

	MOVI	25,A10			;PUMP RED A10 TIMES
	MOVI	128,A8
REDLOOP MOVI	FADERAM,A0
	ADDK	10H,A8
	CALLR	DO_MULT
	SLEEPK	1
	DSJ	A10,REDLOOP
REDOUT
	MOVK	25,A10			;PUMP RED A10 TIMES
RED2	MOVI	FADERAM,A0
	SUBI	10H,A8
	CALLR	DO_MULT
	SLEEPK	1
	DSJ	A10,RED2
	JRUC	PUMP_RED

DO_MULT
	MOVE	A8,A2
	PUSH	a8,a10,a11

	MOVE	@KPBASE,A1,L		;REACTR,A1
;PARAMS
;	A0 - DEST RAM FOR PAL
;	A1 - SRC FOR PAL
;	A2 - COLOR MULTIPLIER
; EACH COLOR IN PALETTE WILL BE MULTIPLIED BY A2 THEN DIVIDED BY 128

	move	*a1+,a14
	move	a14,*a0+
	SLL	23,A14		;TOP BITS OF FIELD ARE FLAGS
	SRL	23,A14		;ONLY 9 BITS NEEDED FOR # COLORS
	MOVI	>7C00,A4	;A4 - PRE MULT MASK FOR 5 BITS OF RED
;	MOVI	>03E0,A6	;A6 - PRE MULT MASK FOR 5 BITS OF GREEN
;	MOVI	>001F,A8	;A8 - PRE MULT MASK FOR 5 BITS OF BLUE
	MOVE	A4,A9
;	MOVE	A6,A10
;	MOVE	A8,A11
	SLL	7,A9		; A9 - POST MULT MAX FOR 5 BITS OF RED
;	SLL	7,A10		;A10 - POST MULT MAX FOR 5 BITS OF GREEN
;	SLL	7,A11		;A11 - POST MULT MAX FOR 5 BITS OF BLUE
FADELPR
	MOVE	*A1+,A3,W	;A3 - RED
	MOVE	A3,A5
	ANDI	03FFH,A5
;	MOVE	A3,A5		;A5 - GREEN
;	MOVE	A3,A7		;A7 - BLUE
	AND	A4,A3
	CMPI	1001H,A3
	JRC	REDOKR
;	AND	A6,A5
;	AND	A8,A7
	MPYU	A2,A3
;	MPYU	A2,A5
;	MPYU	A2,A7
	CMP	A9,A3
	JRLE	REDOKR
	MOVE	A9,A3
REDOKR
;	CMP	A10,A5
;	JRLE	GREENOK
;	MOVE	A10,A5
;GREENOK
;	CMP	A11,A7
;	JRLE	BLUEOK
;	MOVE	A11,A7
;BLUEOK
	AND	A9,A3
	SRL	7,A3
;	AND	A10,A5
	OR	A5,A3
;	OR	A7,A3
;	SRL	7,A3
	MOVE	A3,*A0+
	DSJS	A14,FADELPR


	PULL	a8,a10,a11

	movi	FADERAM,a0	;*Color data
	move	a11,a1		;Pal#
	move	*a0+,a2		;#Colors
	jruc	PALSET



********************************
* FADEIN - Fade in all selected palettes from black
*
* A0=*Palette list to fade in (autoerase + 0-8 pals)
* A1=Fade delay in ticks
* If 1st entry not neg then it enables autoerase fading


 SUBR	FADEIN

	move	a0,a9		;A9=*Palette list
	move	a1,a10		;A10=Fade delay
	CREATE0	fadein
	rets

fadein
	move	a13,a6
	addi	PDATA,a6
	movk	FPALNUM,a7

	move	a9,a11
	move	*a11+,a0,L		;!-=Autoerase color
	jrn	fi30
	move	a0,@irqskyeo		;Save color

fi20	move	*a11+,a0,L		;Get * palette
	jrz	fi70			;0=End
fi30	callr	FINDPAL
	jrnz	fi60			;OK?
	not	a0			;Make neg (should = -256)
fi60	sll	8,a0
	move	a0,*a6+			;Save palette #
	dsj	a7,fi20

fi70	clr	a8			;A8=Brightness


fi100	addk	8,a8

	movi	FADERAM,a5
	move	a13,a6
	addi	PDATA,a6
	movk	FPALNUM,a7

	dint
	move	a9,a11
	move	*a11,a1,L
	jrn	fi200
	addk	32,a11
	move	a8,a2
	callr	pal_fadeae

fi200	move	*a11+,a1,L
	jrz	fi400			;End?
	move	a5,a0
	move	a8,a2
	callr	pal_fade
	move	a5,a0			;*Palette colors
	move	*a6+,a1			;Palette #
	cmpi	-256,a1			;FF00
	jreq	fi230			;Couldn't find?
	move	*a0+,a2			;#Colors
	callr	PALSET
fi230	addi	FPALSZ,a5
	dsj	a7,fi200

fi400	eint
	move	a10,a0
	calla	PRCSLP
	cmpi	128,a8
	jrlo	fi100

fi800	DIE




********************************
* FADEOUT - Fade out all selected palettes to black
*
* A0=*Palette list to fade out (autoerase + 0-8 pals)
* A1=Fade delay in ticks
* If 1st entry not neg then it enables autoerase fading


 SUBR	FADEOUT

	clr	a10
	move	a10,@PCOUNT

 SUBR	FADEOUT2

	move	a0,a9		;A9=*Palette list
	move	a1,a10		;A10=Fade delay
	CREATE0	fadeout
	rets

fadeout
	move	a13,a6
	addi	PDATA,a6
	movk	FPALNUM,a7

	move	a9,a11
	move	*a11+,a0,L		;!-=Autoerase color
	jrn	fo30
	move	@IRQSKYE,a0		;Save color
	move	a0,@irqskyeo

fo20	move	*a11+,a0,L		;Get * palette
	jrz	fo70			;0=End
fo30	callr	FINDPAL
	jrnz	fo60
	not	a0			;Make neg
fo60	sll	8,a0
	move	a0,*a6+			;Save palette #
	dsj	a7,fo20

fo70	movi	128,a8			;A8=Brightness


fo100	subk	8,a8

	movi	FADERAM,a5
	move	a13,a6
	addi	PDATA,a6
	movk	FPALNUM,a7

	dint
	move	a9,a11
	move	*a11+,a1,L
	jrn	fo220
	move	a8,a2
	callr	pal_fadeae

fo200	move	*a11+,a1,L
	jrz	fo400
fo220	move	a5,a0
	move	a8,a2
	callr	pal_fade
	move	a5,a0			;*Palette colors
	move	*a6+,a1			;Palette #
	cmpi	-256,a1			;FF00
	jrz	fo250
	move	*a0+,a2			;#Colors
	callr	PALSET
fo250	addi	FPALSZ,a5
	dsj	a7,fo200

fo400	eint
	move	a10,a0
	calla	PRCSLP
	move	@PCOUNT,a0
	cmp	a0,a8
	jrgt	fo100

fo800	DIE


********************************
* Fade autoerase color

 SUBRP	pal_fadeae	;A2=Brightness (0-128)

	PUSH	a3,a5,a7,a8

	movi	IRQSKYE,a0
	movi	irqskyeo,a1
	movk	1,a14
	jruc	pf1c


********************************
* Fade a palette
* Each color in palette will be multiplied by a2 then divided by 128
* A0=*Ram for pal, A1=*Palette, A2=Brightness (0-128)

 SUBRP	pal_fade

	PUSH	a3,a5,a7,a8

	move	*a1+,a14	;# Colors
	move	a14,*a0+

	sll	32-9,a14	;Remove any flags
	srl	32-9,a14	;9 bits needed for # colors

pf1c	movk	>1f,a8		;A8=5 bit color mask

pf100	move	*a1+,a3
	movk	>1f,a7
	and	a3,a7		;A7=Blue
	srl	5,a3
	movk	>1f,a5
	and	a3,a5		;A5=Green
	srl	5,a3		;A3=Red

	mpyu	a2,a3
	mpyu	a2,a5
	mpyu	a2,a7
	srl	7,a3		;/128
	srl	7,a5
	srl	7,a7

	cmp	a8,a3
	jrls	pfrok
	move	a8,a3

pfrok	cmp	a8,a5
	jrls	pfgok
	move	a8,a5

pfgok	cmp	a8,a7
	jrls	pfbok
	move	a8,a7

pfbok	sll	10,a3
	sll	5,a5
	or	a5,a3
	or	a7,a3
	move	a3,*a0+		;Save color
	dsj	a14,pf100

	PULL	a3,a5,a7,a8
	rets



**************************************************************************
* FB_FADEIN - Fade palettes from black to their normal colors except for list
* A0=*List NOT to fade or 0

FB_FADEIN
	mmtm	sp,a0,a1,a2,a6,a7,a8,a9,a10
	movk	8,a10
	jruc	fbf10


**************************************************************************
* FB_FADEOUT - Fade palettes down to black except for list
* A0=*List NOT to fade or 0


FB_FADEOUT
	PUSH	a0,a1,a2,a6,a7,a8,a9,a10
	movi	-8,a10

fbf10	move	a0,a6
					;Start proc to fade each palette
	clr	a9			;palette slot
	movi	PALRAM,a2		;A2=*Palette table

fbf20	move	*a2+,a8,L		;Ptr to palette
	jrz	fbf70
	move	a6,a7			;A6=*List of palettes to skip
	jrz	fbf60

fbf50	move	*a7+,a1,L
	jrz	fbf60
	cmp	a1,a8
	jreq	fbf70			;Skip pal?
	jruc	fbf50

fbf60	CREATE0	fadeonep

fbf70	addk	1,a9
	cmpi	NUMPAL,a9
	jrlt	fbf20

fbfx	PULL	a0,a1,a2,a6,a7,a8,a9,a10
	rets


**************************************************************************
* fadeonep - Fade one palette (Process)
*
* A8=*Palette to be faded
* A9=Palette slot # (0 to NUMPAL-1)
* A10=Add value per fade (!0)

fadeonep

	.if	YUNIT
	movk	>f,a2
	and	a9,a2		;A2=4 low bits
	srl	4,a9		;Move B4/B5 to B6/B7
	sll	6,a9
	add	a2,a9
	.endif

	sll	8,a9		;B8-15 dest pal, B0-7 color (0)

	clr	a11		;For up fade
	move	a10,a10
	jrgt	fop60
	movi	128,a11		;For dn fade
	jruc	fop60
				;>Set up faded pal in process data space
foplp
	move	a11,a2		;A2=Color Multiplier
	move	a13,a0
	addi	PDATA,a0	;A0=Dest Ram for Pal
	move	a0,a5
	move	a8,a1		;A1=Src for Pal
	callr	pal_fade

	move	a5,a0		;>Move faded palette to palram
	move	a9,a1
	move	*a0+,a2		;Get # colors in palette
	callr	PALSET		;Set transfer

	SLEEPK	2
fop60	add	a10,a11
	cmpi	128,a11
	jrls	foplp


	SLEEPK	2		;Wait on last PALSET
	DIE


**************************************************************************
* PAL_FMWHT - Fade palettes from white to their normal colors except for list
* A0=*List NOT to fade or 0
* A1=Do Autoerase (!0=Yes)

 SUBR	PAL_FMWHT

	PUSH	a2,a6,a7,a8,a9,a10
	movi	-1,a10
	jruc	ptw10


**************************************************************************
* PAL_TOWHT - Brighten palettes to white except for list
* A0=*List NOT to fade or 0
* A1=Do Autoerase (!0=Yes)

 SUBR	PAL_TOWHT

	PUSH	a2,a6,a7,a8,a9,a10
	move	@IRQSKYE,a2		;Save color
	move	a2,@irqskyeo
	movk	1,a10

ptw10	move	a0,a6
	move	a1,a1
	jrz	ptw15			;Skip AE
	CREATE0	ADDBRT_AE
					;Start proc to fade each palette
ptw15	clr	a9			;palette slot
	movi	PALRAM,a2		;A2=*Palette table

ptw20	move	*a2+,a8,L		;Ptr to palette
	jrz	ptw70
	move	a6,a7			;A6=*List of palettes to skip
	jrz	ptw60

ptw50	move	*a7+,a1,L
	jrz	ptw60
	cmp	a1,a8
	jreq	ptw70			;Skip pal?
	jruc	ptw50

ptw60	CREATE0	brightenonep

ptw70	addk	1,a9
	cmpi	NUMPAL,A9
	jrlt	ptw20

ptwx	PULL	a2,a6,a7,a8,a9,a10
	rets


**************************************************************************
* brightenonep - Brighten one palette (Process)
*
* A8=*Palette to be faded
* A9=Palette slot #
* A10=Add value per loop (!0)

brightenonep
	.if	YUNIT
	movk	>f,a2
	and	a9,a2		;A2=4 low bits
	srl	4,a9		;Move B4/B5 to B6/B7
	sll	6,a9
	add	a2,a9
	.endif

	sll	8,a9		;B8-15 dest pal, B0-7 color (0)

	clr	a11		;For up fade
	move	a10,a10
	jrgt	bop20
	movk	31,a11		;For dn fade
bop20
				;Set up faded pal in process data space
boplp	add	a10,a11
	cmpi	31,a11
	jrhi	bopx
	move	a11,a2		;A2=Brightness
	move	a13,a0
	addi	PDATA,a0	;A0=Dest Ram for Pal
	move	a0,a5
	move	a8,a1		;A1=Src for Pal
	callr	pal_addb

	move	a5,a0		;>Move faded palette to palram
	move	a9,a1
	move	*a0+,a2		;Get # colors in palette
	callr	PALSET		;Set transfer

	SLEEPK	3
	jruc	boplp

bopx	SLEEPK	1		;give last xfer a chance to go
	DIE


********************************
* Change brightness of autoerase (Process)
*
* A10=Add value per loop (!0)

 SUBR	ADDBRT_AE

	clr	a11		;For up fade
	move	a10,a10
	jrgt	abae20
	movk	31,a11		;For dn fade
abae20
abaelp	add	a10,a11
	cmpi	31,a11
	jrhi	abaex
	move	a11,a2		;A2=Brightness
	callr	addbae

	SLEEPK	3
	jruc	abaelp

abaex	DIE


********************************
* Change brightness of autoerase

 SUBRP	addbae	;A2=Brightness (-31 to 31)

	PUSH	a3,a5,a7,a8

	movi	IRQSKYE,a0
	movi	irqskyeo,a1
	movk	1,a14
	jruc	pb1c


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
	add	a2,a5
	add	a2,a7

	cmp	a8,a3
	jrls	pbrok
	move	a8,a3

pbrok	cmp	a8,a5
	jrls	pbgok
	move	a8,a5

pbgok	cmp	a8,a7
	jrls	pbbok
	move	a8,a7

pbbok	sll	10,a3
	sll	5,a5
	or	a5,a3
	or	a7,a3
	move	a3,*a0+		;Save color
	dsj	a14,pb100

	PULL	a3,a5,a7,a8
	rets



	.end
