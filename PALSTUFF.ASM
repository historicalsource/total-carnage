**************************************************************
*
* INITIATED:		APRIL 13,1989
* SOFTWARE:		MARK TURMELL
*
* MODIFIED:		Shawn Liptak, 7/23/91	-New FADEIN/OUT
* 			Shawn Liptak, 7/28/91	-Merged with fbstuff
*
* COPYRIGHT (C) 1991 WILLIAMS ELECTRONICS GAMES, INC.
*
**************************************************************
	.TITLE	'PALSTUFF.ASM'
	.FILE	'PALETTE FADER CONTROL'
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST


	.INCLUDE	"MPROC.EQU"		;MPROC EQUATES
	.INCLUDE	"DISP.EQU"		;DISPLAY PROC. EQUATES
	.INCLUDE	"\VIDEO\SYS\SYS.INC"	;Z UNIT SYSTEM EQUATES
	.INCLUDE	"BGNDTBL.GLO"
	.INCLUDE	"IMGTBL.GLO"
	.INCLUDE	"GAME.EQU"
	.include	"shawn.hdr"		;Macros

;SYMBOLS EXTERNALLY DEFINED

	.REF	GETFPAL,PALSET,UNGETPAL,DELPAL,FINDPAL,RANGRAND
	.REF	IRQSKYE,REACTR,RANDPER
	.REF	PALSET,PALRAM,EXP2

;SYMBOLS DEFINED IN THIS FILE

	.DEF	PUMP_RED,COUNT,PUMP_CLDS
	.DEF	BLAKOUT
	.DEF	FB_FADEOUT,FB_FADEIN

;EQUATES FIRST ORIGINATED IN THIS FILE

FPALNUM	.equ	8
FPALSZ	.equ	65*16


;UNINITIALIZED RAM DEFINITIONS


	.BSS	FADERAM	,FPALSZ*FPALNUM	;Fade mem for palettes
	.BSS	COUNT	,16
	.BSS	KPBASE	,32
	.bss	irqskyeo,16		;Orignal autoerase color


********************************
* BLAKOUT - BLACK OUT SELECTED PALETTE
* A0=NAME OF PALETTE TO BLACK OUT

BLAKOUT
	CALLA	FINDPAL
	SLL	8,A0
	MOVE	A0,A1
	JRZ	NOTALLOC
	MOVI	FADERAM,A0
	MOVI	128,A3
	CLR	A2

CLRBLP	MOVE	A2,*A0+,L
	DSJS	A3,CLRBLP
	MOVI	FADERAM,A0		;NOW BLACK OUT PALETTE
	MOVI	256,A2
	CALLA	PALSET			;ERASE PALETTE SLOT
NOTALLOC
	RETS

********************************
* CLOUDS BEHIND REPORTER
* PUMP_RED PROCESS
* CYCLE NUCLEAR REACTORS

PUMP_CLDS
	SLEEP	3
	MOVI	EXP2,A0
	CALLA	ONESND
	MOVI	CLDSZ,A0
	MOVE	A0,@KPBASE,L
	CALLA	FINDPAL
	JRZ	CREDOUT
	SLL	8,A0
	MOVE	A0,A11			;NEEDED LATER FOR PALSET

	MOVK	7,A10			;PUMP RED A10 TIMES
	MOVI	128,A8
CEDLOOP MOVI	FADERAM,A0
	ADDK	20H,A8
	CALLR	DO_MULT
	SLEEP	1
	DSJ	A10,CEDLOOP
CREDOUT
	MOVK	7,A10			;PUMP RED A10 TIMES
CRED2	MOVI	FADERAM,A0
	SUBI	20H,A8
	CALLR	DO_MULT
	SLEEP	1
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
	SLEEP	18H
	MOVI	REACTR,A0
	MOVE	A0,@KPBASE,L
	CALLA	FINDPAL
	JRZ	REDOUT
	SLL	8,A0
	MOVE	A0,A11			 ;NEEDED LATER FOR PALSET

	MOVI	25,A10			;PUMP RED A10 TIMES
	MOVI	128,A8
REDLOOP MOVI	FADERAM,A0
	ADDK	10H,A8
	CALLR	DO_MULT
	SLEEP	1
	DSJ	A10,REDLOOP
REDOUT
	MOVK	25,A10			;PUMP RED A10 TIMES
RED2	MOVI	FADERAM,A0
	SUBI	10H,A8
	CALLR	DO_MULT
	SLEEP	1
	DSJ	A10,RED2
	JRUC	PUMP_RED

DO_MULT
	MOVE	A8,A2
	MMTM	SP,A8,A10,A11
;	 ADDI	 32,A0			 ;GET TO FIRST COLOR PAST 0
;	 MOVI	 63,A9
;NEXCLR  MOVE	 *A0,A1,W
;	 ZEXT	 A1,W
;	 SRL	 10,A1			;GET RED BITS

	MOVE	@KPBASE,A1,L		;REACTR,A1
;PARAMS
;	A0 - DEST RAM FOR PAL
;	A1 - SRC FOR PAL
;	A2 - COLOR MULTIPLIER
; EACH COLOR IN PALETTE WILL BE MULTIPLIED BY A2 THEN DIVIDED BY 128

;	MMTM	SP,A0,A1,A3,A4,A5,A6,A7,A8,A9,A10,A11,A14
	MOVE	*A1+,A14,W
	MOVE	A14,*A0+,W
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
FADELPR:
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
REDOKR:
;	CMP	A10,A5
;	JRLE	GREENOK
;	MOVE	A10,A5
;GREENOK:
;	CMP	A11,A7
;	JRLE	BLUEOK
;	MOVE	A11,A7
;BLUEOK:
	AND	A9,A3
	SRL	7,A3
;	AND	A10,A5
	OR	A5,A3
;	OR	A7,A3
;	SRL	7,A3
	MOVE	A3,*A0+,W
	DSJS	A14,FADELPR
;	MMFM	SP,A0,A1,A3,A4,A5,A6,A7,A8,A9,A10,A11,A14
;	RETS
;	 CMPI	 31,A1
;	 JRZ	 ROUT
;	 CMPI	 6,A1
;	 JRC	 ROUT
;	 INC	 A1
;	 SLL	 10,A1
;	 MOVE	 *A0,A2,W
;	 ANDI	 03FFH,A2
;	 OR	 A1,A2
;	 MOVE	 A2,*A0,W
;ROUT	 ADDI	 16,A0
;	 DSJS	 A9,NEXCLR

*SETUP PALETTE TRANSFER
*CALLING PARAMETERS:
*A0= PALSRC = 32 BIT SOURCE ADDRESS OF PALETTE COLOR DATA	
*A1= PALDEST = BIT 8-15 DESTINATION PALETTE | BIT 0-7 START COLOR
*A2= PLDCNT = 16 BIT COLOR COUNT
*RETURNS: EQ IF UNABLE TO SETUP TRANSFER, NE IF TRANSFER O.K.

	MMFM	SP,A8,A10,A11

	MOVI	FADERAM,A0
	MOVE	A11,A1
	MOVE	*A0+,A2
	CALLA	PALSET

	RETS


********************************
* FADEIN - Fade in all selected palettes from black
*
* A0=*Palette list to fade in (autoerase + 0-8 pals)
* A1=Fade delay in ticks
* If 1st entry not neg then it enables autoerase fading



 SUBR	FADEIN

	move	a0,a9		;A9=*Palette list
	move	a1,a10		;A10=Fade delay
	CREATE	0,fadein
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
fi30	calla	FINDPAL
	jrz	fi60
	not	a0			;Make neg
fi60	sll	8,a0
	move	a0,*a6+			;Save palette #
	dsj	a7,fi20

fi70	clr	a8			;A8=Brightness


fi100	addk	8,a8

	movi	FADERAM,a5
	move	a13,a6
	addi	PDATA,a6
	movk	FPALNUM,a7

	move	a9,a11
	move	*a11,a1,L
	jrn	fi200
	addk	32,a11
	move	a8,a2
	callr	FADEPALAE

fi200	move	*a11+,a1,L
	jrz	fi400
	move	a5,a0
	move	a8,a2
	callr	FADEPAL
	move	a5,a0			;*Palette colors
	move	*a6+,a1			;Palette #
	cmpi	-256,a1			;FF00
	jrz	fi230
	move	*a0+,a2			;#Colors
	calla	PALSET
fi230	addi	FPALSZ,a5
	dsj	a7,fi200

fi400	move	a10,a0
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
	move	a10,@COUNT

 SUBR	FADEOUT2

	move	a0,a9		;A9=*Palette list
	move	a1,a10		;A10=Fade delay
	CREATE	0,fadeout
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
fo30	calla	FINDPAL
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

	move	a9,a11
	move	*a11,a1,L
	jrn	fo200
	addk	32,a11
	move	a8,a2
	callr	FADEPALAE

fo200	move	*a11+,a1,L
	jrz	fo400
	move	a5,a0
	move	a8,a2
	callr	FADEPAL
	move	a5,a0			;*Palette colors
	move	*a6+,a1			;Palette #
	cmpi	-256,a1			;FF00
	jrz	fo230
	move	*a0+,a2			;#Colors
	calla	PALSET
fo230	addi	FPALSZ,a5
	dsj	a7,fo200

fo400	move	a10,a0
	calla	PRCSLP
	move	@COUNT,a0
	cmp	a0,a8
	jrgt	fo100

fo800	DIE


********************************
* Fade autoerase color

 SUBRP	FADEPALAE	;A2=Brightness (0-128)

	PUSH	a3,a4,a5,a6,a7,a8,a9,a10,a11

	movi	IRQSKYE,a0
	movi	irqskyeo,a1
	movk	1,a14
	jruc	fp20


********************************
* Fade a palette
* Each color in palette will be multiplied by a2 then divided by 128
* A0=*Ram for pal, A1=*Palette, A2=Brightness (0-128)

 SUBRP	FADEPAL

	PUSH	a3,a4,a5,a6,a7,a8,a9,a10,a11

	move	*a1+,a14	;# Colors
	move	a14,*a0+

fp20	sll	23,a14		;Remove any flags
	srl	23,a14		;9 bits needed for # colors
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



**************************************************************************
* FADEIN - Fade a list of palettes from black to their current colors
* A0=*List NOT to fade or 0

FB_FADEIN
	mmtm	sp,a0,a1,a2,a6,a7,a8,a9,a10
	movk	8,a10
	jruc	fbf10


**************************************************************************
* FADEOUT - Fade a list of palettes down to black
* A0=*List NOT to fade or 0


FB_FADEOUT
	mmtm	sp,a0,a1,a2,a6,a7,a8,a9,a10
	movi	-8,a10

fbf10	move	a0,a6
					;Start proc to fade each palette
	clr	a9			;palette slot
	movi	PALRAM,A2		;A2=*Palette table

fbf20	move	*A2(PALCNT),A1		;Is palette allocated?
	jrz	fbf70

	move	*A2(PALID),A8,L		;Ptr to palette
	move	A6,A7			;A6=*List of palettes to skip
	jrz	fbf60

fbf50	move	*A7+,A1,L
	jrz	fbf60
	cmp	A1,A8
	jreq	fbf70			;Skip pal?
	jruc	fbf50

fbf60	CREATE	0,fadeonep

fbf70	addi	PALRSIZ,A2
	addk	1,a9
	cmpi	NUMPAL,A9
	jrlt	fbf20

fbfx	mmfm	sp,a0,a1,a2,a6,a7,a8,a9,a10
	rets


**************************************************************************
* fadeonep - Fade one palette (Process)
*
* A8=*Palette to be faded
* A9=Palette slot #
* A10=Add value per fade (!0)

fadeonep
	sll	24,a9		;B8-15 dest pal | B0-7 start color
	srl	16,a9

	.if	YUNIT
	move    a9,a2
	srl     12,a2
	sll     14,a2
	sll     20,a9
	srl     20,a9
	add     a2,a9
	.endif

	clr	a11		;For up fade
	move	a10,a10
	jrgt	fop20
	movi	128,a11		;For dn fade
fop20
				;Set up faded pal in process data space
foplp	add	a10,a11
	cmpi	128,a11
	jrhi	fopx
	move	a11,a2		;A2=Color Multiplier
	move	a13,a0
	addi	PDATA,a0	;A0=Dest Ram for Pal
	move	a0,a5
	move	a8,a1		;A1=Src for Pal
	callr	FADEPAL

	move	a5,a0		;>Move faded palette to palram
	move	a9,a1
	move	*a0+,a2		;Get # colors in palette
	calla	PALSET		;Set transfer

	SLEEP	2
	jruc	foplp

fopx	SLEEP	1		;give last xfer a chance to go
	DIE



	.end
