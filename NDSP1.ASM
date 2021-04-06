**************************************************************************
*	GSP DMA OBJECT HANDLER
*
*	VERSION 1.0  BY WARREN DAVIS 9/1/87
*	VERSION 2.01 BY EUGENE JARVIS 10/25/87 
*	VERSION 3.0  BY EUGENE JARVIS 12/20/87
*	VERSION 3.1  BY EUGENE JARVIS 7/4/88
*	VERSION 3.2  BY EUGENE JARVIS 8/8/88
*	VERSION 3.21 BY Shawn Liptak 7/24/91 - Minor improvements
*	VERSION 3.3  BY Shawn Liptak 9/13/91 - More improvements
*
*	COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*	ALL RIGHTS RESERVED.
*
*.Last mod - 1/7/92 13:45
**************************************************************************
	.FILE	'NDSP1.ASM'
	.TITLE	"GSP DISPLAY PROCESSOR VER. 3.3"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST


	.INCLUDE	\VIDEO\SYS\GSP.INC
	.INCLUDE	\VIDEO\SYS\SYS.INC
	.INCLUDE	\VIDEO\SYS\MACROS.HDR
	.INCLUDE	MPROC.EQU
	.INCLUDE	DISP.EQU
	.include	"shawn.hdr"		;Macros

	.if	DEBUG
	.include	GAME.EQU
	.endif

;	.def	QDMA
	.def	DMAQ,QDMAFLG,ANI		;FOR FILE SCORE USAGE
	.DEF	PULLOBJ
	.REF	HALT,GETFPAL,FRANIMQ

	.if	DEBUG
	.ref	SLDEBUG
	.endif

* GLOBAL VARIABLES

	.SECT	"OFIXED"

OBJLST		.LONG	0	;POINTER TO ACTIVE OBJECT LIST
OFREE		.LONG	0	;POINTER TO FREE OBJECT BLOCK
ENDOFREE	.LONG	0
BAKLST		.LONG	0	;BACKGROUND LIST
;BAK2LST	.LONG	0	;SLOW SCROLL BACKGROUND PLANE


	.SECT	".text"

	.BSS	SCROLLX,32		;X SCROLL VALUE
	.BSS	SCROLLY,32		;Y SCROLL VALUE
	.BSS	WORLDTLX,32		;TOP LEFT X SCREEN COORD (WORLD)
	.BSS	WORLDTLY,32		;TOP LEFT Y SCREEN COORD (WORLD)
	.BSS	WORLDTL,32		;PACKED TOP LEFT WORLD COORD
	.BSS	SCRNTL,32		;TOP LEFT [Y,X] SCREEN (SCRN COORD.)
	.BSS	SCRNLR,32		;LOWER RIGHT [Y,X] SCREEN (SCRN COORD.)
;	.BSS	BAK2TLY,32		;TOP LFT Y SLOW SCROLL BACKGROUND
;	.BSS	BAK2TLX,32		;TOP LFT X SLOW SCROLL BACKGROUND
	.BSS	QSYNC,16		;SIGNALS ACTIVE Q
	.BSS	DMAQCUR,32		;CURRENT DMAQ
	.BSS	DMAQCNT,16		;CURRENT DMAQ COUNT
	.BSS	BOTQ0CNT,16		;BOTTOM QUEUE COUNT #0
	.BSS	BOTQ1CNT,16		;BOTTOM QUEUE COUNT #1
	.BSS	TOPQ0CNT,16		;TOP QUEUE COUNT #0
	.BSS	TOPQ1CNT,16		;TOP QUEUE COUNT #1
	.BSS	BOTQ0FLG,16		;BOTTOM Q0 VALID FLAG  VALID=NE
	.BSS	BOTQ1FLG,16		;BOTTOM Q1 VALID FLAG  VALID=NE
	.BSS	TOPQ0FLG,16		;TOP Q0 VALID FLAG  VALID=NE
	.BSS	TOPQ1FLG,16		;TOP Q1 VALID FLAG  VALID=NE
	.BSS	OBJSTR,NOBJ*OBSIZ	;OBJECT STRUCTURE LIST START
	.BSS	OBJLSTND,0		;OBJECT LIST END
QSIZE	.SET	NOBJ*BQCELL		;SIZE OF QUEUES
	.BSS	BOTQ0,QSIZE		;BOTTOM OBJECT DMA Q #0
	.BSS	BOTQ1,QSIZE		;BOTTOM OBJECT DMA Q #1
	.BSS	TOPQ0,QSIZE		;TOP OBJECT DMA Q #0
	.BSS	TOPQ1,QSIZE		;TOP OBJECT DMA Q #1
	.BSS	DMAQ,QSIZE		;MISC. NON-SYNC DMA QUEUE
	.BSS	DISPLAYON,16		;DO DISPLAY PROCESSING WHEN != 0
	.BSS	QDMAFLG,16		;SPECIAL DMAQ BEING UPDATED=1
***************OVERLOAD
****>	.BSS	OVTOP,16		;TOP SCREEN OVERLOAD
****>	.BSS	OVBOT,16		;BOTTOM SCREEN OVERLOAD


* NO CODE BEFORE DMA INT!!! (Cache aligned)

********************************
* DMA INTERRUPT

DMAINT
	mmtm	b12,b6,b7,b8,b9		;Stuff DMA regs
	move	b10,-*b12
	move	b11,-*b12
	addi	>a0,b12			;DMAREGS (End of DMA)
	subk	1,b13
	jrle	dmaint1			;Queue empty?
	subi	>140,b14		;Setup Q pull
	mmfm	b14,b6,b7,b8,b9,b10	;Get data
	move	b10,b11
	srl	16,b10
	reti

dmaint1	callr	DMANUQ			;Look to start a new q
	reti


********************************
* GET NEW DMA Q CALLED FROM DMA INTERRUPT

DMANUQ
	CLR	B13
	MOVE	@TOPQ0FLG,B14
	JREQ	DMANUQ1
	CLR	B14
	MOVE	B14,@TOPQ0FLG
	MOVE	@TOPQ0CNT,B13
	JREQ	DMANUQ1
	MOVE	B14,@TOPQ0CNT
	MOVI	TOPQ0+(QSIZE),B14
	JRUC	DMANUQL

DMANUQ1	MOVE	@TOPQ1FLG,B14
	JREQ	DMANUQ2
	CLR	B14
	MOVE	B14,@TOPQ1FLG
	MOVE	@TOPQ1CNT,B13
	JREQ	DMANUQ2
	MOVE	B14,@TOPQ1CNT
	MOVI	TOPQ1+(QSIZE),B14
	JRUC	DMANUQL

DMANUQ2	MOVE	@BOTQ0FLG,B14
	JREQ	DMANUQ3
	CLR	B14
	MOVE	B14,@BOTQ0FLG
	MOVE	@BOTQ0CNT,B13
	JREQ	DMANUQ3
	MOVE	B14,@BOTQ0CNT
	MOVI	BOTQ0+(QSIZE),B14
	JRUC	DMANUQL

DMANUQ3	MOVE	@BOTQ1FLG,B14
	JREQ	DMANUQX
	CLR	B14
	MOVE	B14,@BOTQ1FLG
	MOVE	@BOTQ1CNT,B13
	JREQ	DMANUQX
	MOVE	B14,@BOTQ1CNT
	MOVI	BOTQ1+(QSIZE),B14

DMANUQL	SUBI	>A0,B14
	MMFM	B14,B6,B7,B8,B9,B10	;LOAD HER UP
	MOVE	B10,B11
	SRL	16,B10
	RETS

DMANUQX	MOVE	@INTENB,B14		;DISABLE DMA INTERRUPT
	ANDI	>FFFD,B14
	MOVE	B14,@INTENB
	RETS


********************************
* Load DMA Qs from obj list
* A0=*Obj list, A13=Screen BR, A14=Screen TL
* B4=World Y:X, B5=OFLAGS offset

	.align

ldmaqlp	move	*a0(OXPOS),a10		;
	move	*a0(OYVAL),a2,L		;Get int Y
	movy	a2,a10			;A10=Obj Y:X
	move	b4,a6			;A6=World TL Y:X
	subxy	a6,a10			;-world coord to get screen coord
	move	b5,a3			;Get OFLAGS offset
	add	a0,a3
	mmfm	a3,a12,a11,a9,a8

*	CHECK FOR FLIPPING, NECESSITY OF CLIPPING, ADJUST OFFSET, SAG
*	A3=AMOUNT TO CLIP OFF TOP, LEFT	(TC,LC)
*	A8=CONST:PALETTE
*	A9=VS : HS
*	A10=DAG (Y : X)
*	A11=SAG
*	A12=CONTROL WORD B0-15; OFFSET B16-31

				;COMPUTE LC, RC, TC, BC
	CLR	A6		;UPPER LEFT SCREEN COORDINATES
	CLR	A1		;A1=USE FOR CLEARING NOW, BECOMES OFFSET LATER
	MOVE	A10,A2		;
	ADDXY	A9,A2		;A2=Obj BR Y:X
	SUBXY	A13,A2		;PT - WEND -> A2  ( BC : RC )
	JRYGE	ldmaq10
	MOVY	A1,A2		;CLEAR BC IF Y NEGATIVE
ldmaq10	JRXGE	ldmaq20
	MOVX	A1,A2		;CLEAR RC IF X NEGATIVE

ldmaq20	MOVE	A14,A7		;MOVE WSTART
	CLR	A3				;
	SUBXY	A10,A7		;WSTART - PT -> A7 (TC : LC)
	JRYLT	ldmaq30
	MOVY	A7,A3		;TC IN UPPER HALF OF A3
	MOVY	A14,A10		;ADJUST START POSITION TO WINDOW EDGE

ldmaq30	JRXLT	ldmaq35
	MOVX	A7,A3		;LC IN LOWER HALF OF A3
	MOVX	A14,A10		;ADJUST START POSITION TO WINDOW EDGE

ldmaq35	MOVX	A9,A6		;GET TOTAL HORIZONTAL SIZE (MORSEL CORRECTED)
	ADD	A3,A2		;(TC+BC : LC+RC) IN A2
	JREQ	NOCLIP		;TOTAL CLIP IS ZERO, NOCLIP
	SUBXY	A2,A9		;GET CLIPPED SIZE...TOTALLY CLIPPED?
	JRXLE	NODIS		;Totally clipped?
	JRYLE	NODIS

				;CLIP THE SAG, HS, VS, AND ADJUST OFFSET
	MOVX	A3,A1		;GET LEFT CLIP
	SRL	16,A3		;GET TOP CLIP
	JREQ	CLIP1
	MOVE	*A0(OXCLIP),A7
	ADD	A6,A7		;ADD PRECLIP TO THE WIDTH TO CALC NEW SAG
	MPYS	A7,A3		;TOP CLIP X TOTAL HORIZ SIZE

CLIP1	SLL	16,A2
	BTST	B_FLIPH,A12
	JREQ	CLIP2
	NEG	A2		;NEGATE RC+LC
	NEG	A1		;NEGATE LC

CLIP2	BTST	B_FLIPV,A12
	JREQ	CLIP3
	NEG	A3		;NEGATE	THS*TC

CLIP3	ADD	A1,A3		;ADD LEFT CLIP TERM +  TC*THS
	SLL	3,A3
	ADD	A3,A11		;ADD TO SAG
	ADD	A2,A12		;ADD CLIP OFFSET TO OFFSET

*BEAM AVOIDANCE, AT HALF SCREEN, DMA TOP HALF
*		 AT FULL SCREEN, DMA BOTTOM HALF
*B1=HALF SCREEN LINE COUNT
*B2=BOTTOM Q COUNT
*B3=TOP Q COUNT
*A4=BOTTOM DMA Q TO LOAD
*A5=TOP DMA Q TO LOAD
*A6=TOTAL HORIZONTAL SIZE
*A8=CONST:PALETTE XLATE
*A9=VSIZE:HSIZE
*A10=DESTINATION Y:X
*A11=IMAGE SAG
*A12=OFFSET:CONTROL

NOCLIP	MOVE	B1,A2		;GET HALF SCREEN LINE NUMBER(Y ADJUSTED)
	subxy	a10,a2		;WHERE'S THE IMAGE?
	JRYLE	BEAM_STKIMG	;Completely on the other side? Stack it

	CMPXY	A2,A9		;DETERMINE HEIGHT ABOVE MID SCREEN
	JRYLE	BEAM_DODMA	;BR = YES, DMA AS IS

	MOVE	A9,B0		;SAVE THE SIZES
	MOVY	A2,A9		;STUFF NEW VSIZE AND DO IT

	MMTM	A5,A8,A9,A10,A11,A12	;SAVE THE DMA REGS
	INC	B3


	MOVE	B0,A9		;SET UP DMA REGS FOR BOTTOM HALF AND STACK EM
	SRL	16,A2		;Shift down the Y differential
	MOVE	*A0(OXCLIP),A3	;ADD PRECLIP TO WIDTH
	ADD	A6,A3		;WE NEED TS IN AN ODD REG. FOR 32 BIT MULT.

	SLL	3,A3		;TS = TS*8
	MPYU	A2,A3		;A3 = SAG OFFSET
	SLL	16,A2		;Y DIFF BACK TO Y POS
	SUBXY	A2,A9		;NEW VSIZE
	ADDXY	A2,A10		;NEW DMA POSITION

	BTST	B_FLIPV,A12
	JREQ	BEAM_ADDSAG	;BR = SUBTRACT FOR NEW SAG BECAUSE OF VFLIP

	NEG	A3		;SAG = -SAG

BEAM_ADDSAG
	ADD	A3,A11		;SAG = SAG + OFFSET

BEAM_STKIMG
	MMTM	A4,A8,A9,A10,A11,A12	;SAVE THE DMA REGS
	INC	B2
	JRUC	NODIS

BEAM_DODMA
	MMTM	A5,A8,A9,A10,A11,A12	;SAVE THE DMA REGS
	INC	B3

NODIS	move	*a0,a0,L	;Get next link
	jrnz	ldmaqlp		;More?
	rets


********************************
* DISPLAY OBJECT LIST - CALLED AT MIDSCREEN INTERRUPT

DISPLAY
	move	@QSYNC,a1
	jrne	disp1
	MOVI	BOTQ0+(QSIZE),A4	;SETUP NEW INTERRUPT LOAD DMA QUEUES
	MOVI	TOPQ0+(QSIZE),A5
	jruc	disp2

disp1	MOVI	BOTQ1+(QSIZE),A4	;SETUP NEW INTERRUPT LOAD DMA QUEUES
	MOVI	TOPQ1+(QSIZE),A5

disp2	dint
	move	@INTENB,a0		;Enable display interrupt
	ori	DIE,a0
	move	a0,@INTENB
	eint

;	move	@DISPLAYON,a0
;	jrz	dispx			;Stop all new display processing?

	move	@HALT,a0
	jrnz	disp30			;Skip vel update?
	movi	OBJLST,a0
	callr	vel_add
disp30

*CLIP AND LOAD DMA
*A4=BOTTOM DMA Q TO LOAD
*A5=TOP DMA Q TO LOAD
*B1=HALF SCREEN ADDRESS
*B2=BOTTOM Q COUNT
*B3=TOP Q COUNT
*B4=WORLD TOP LEFT [Y,X]

DCLIP
	MOVI	(HSINT-20)*>10000,B1	;GET HALF SCREEN LINE #(Y ADJUSTED) ;27
	CLR	B3		;TOP Q COUNT
	CLR	B2		;BOTTOM Q COUNT
	movi	OFLAGS,b5	;B5=PARAMETER LOCATION

	move	@DISPLAYON,a0
	jrz	disp100		;Stop DMA of objects except for score?

;	MOVE	@SCROLLX,A6,L	;GET Y:X SCROLL VALUES
;	MOVE	@SCROLLY,A7,L
;	SRA	1,A6
;	SRA	1,A7		;SCROLL 1/2 AS FAST
;	MOVE	@BAK2TLY,A14,L	;BACKGRD 2 SCREEN TL Y INTEGER:FRACTION
;	MOVE	@BAK2TLX,A13,L	;BACKGRD 2 SCREEN TL X INTEGER:FRACTION
;	ADD	A7,A14
;	MOVE	A14,@BAK2TLY,L
;	ADD	A6,A13
;	MOVE	A13,@BAK2TLX,L
;	SRL	16,A13
;	MOVX	A13,A14		;COMBINE TO FORM TOP LEFT Y:X
;	MOVE	A14,B4		;SETUP WORLD TOP LEFT [Y,X]
;	MOVE	@SCRNTL,A14,L	;GET SCREEN BOUNDARIES
;	MOVE	@SCRNLR,A13,L

;	MOVE	@OVTOP,A0,W	;IF OVERLOAD SKIP BAK2 UPDATE
;	MOVE	@OVBOT,A1,W
;	OR	A0,A1
;	JRNE	DCLIP1

;	MOVI	BAK2LST,A0,L
;	CALLR	NODIS
;DCLIP1

	MOVE	@SCROLLX,A6,L	;GET Y:X SCROLL VALUES
	MOVE	@SCROLLY,A7,L
	MOVE	@WORLDTLY,A14,L	;SCROLL YOUR SCREEN FOLKS
	MOVE	@WORLDTLX,A13,L
	ADD	A6,A13
	ADD	A7,A14
	MOVE	A14,@WORLDTLY,L
	MOVE	A13,@WORLDTLX,L
	SRL	16,A13
	MOVX	A13,A14		;COMBINE TO FORM TOP LEFT Y:X

	MOVE	A14,B4		;SETUP WORLD TOP LEFT [Y,X]
	MOVE	B4,@WORLDTL,L	;STORE THE WORLD TOP LEFT [Y,X]
	MOVE	@SCRNTL,A14,L	;GET SCREEN BOUNDARIES
	MOVE	@SCRNLR,A13,L

***********Z PLANE CHECK KLUDGE***********************************
*
*	.GLOBAL		PLZMIN
*	MOVE	@PLZMIN,A1,W
*	SUBI	10,A1			;FUDGE FACTOR
*	MOVE	@OBJLST,A0,L
*	JREQ	DISPBAK			;FORGET IT NULL LIST
*	MOVE	*A0(OZPOS),A2,W		;FIND STUFF IN BACK
*	CMP	A1,A2
*	JRGE	DISPBAK			;TEST FIRST ONE, NOTHING IN BACK
*DZCHL
*	MOVE	*A0(OZPOS),A2,W		;FIND STUFF IN BACK
*	CMP	A1,A2
*	JRGE	DZCHK1
*	MOVE	*A0,A0,L
*	JRNE	DZCHL
*
*	MOVI	OBJLST,A0,L		;EVERYTHINGS IN BACK
*	CALLR	NODIS
*
*	MOVI	BAKLST,A0,L
*	CALLR	NODIS
*	JRUC	DISPX
*
*DZCHK1:
*	MOVE	*A0,A1,L
*	MMTM	SP,A0,A1		;SAVE OLD LIST POINTERS
*	CLR	A1
*	MOVE	A1,*A0,L		;ZERO OUT LIST (SPLIT IT UP)
*
*	MOVI	OBJLST,A0,L		;OUTPUT BACK OBJECTS
*	CALLR	NODIS
*
*	MOVI	BAKLST,A0,L		;OUTPUT BACKGROUND PLANE
*	CALLR	NODIS
*
*	MMFM	SP,A0,A1
*	MOVE	A1,*A0,L		;RESTORE LIST
*	MOVE	A0,A0
*	CALLR	NODIS1			;PROCESS REST OF OBJECT LIST
*	JRUC	DISPX
*****************************************************************************

DISPBAK
	MOVI	BAKLST,A0,L
	CALLR	NODIS

	MOVI	OBJLST,A0,L
	CALLR	NODIS
				;PUT DMA SCORE AREA ON TOP OF EVERYTHING!
disp100	MOVE	@QDMAFLG,A2	;Q BEING MODIFIED?
	JRNZ	DISPX0		;YES, DON'T SCREW WITH IT
	MOVE	@DMAQCUR,A2,L
	MOVI	DMAQ+QSIZE,A1
	CMP	A1,A2
	JREQ	DISPX0		;NONE
	MOVE	A1,@DMAQCUR,L	;RESET TOP OF QUEUE

DISPXL	MOVE	-*A1,-*A5,L	;TRANSFER YOUR Q'S
	MOVE	-*A1,-*A5,L
	MOVE	-*A1,-*A5,L
	MOVE	-*A1,-*A5,L
	MOVE	-*A1,-*A5,L
	INC	B3		;INCREMENT COUNT
	CMP	A2,A1
	JRHI	DISPXL

DISPX0
	MOVI	NULLDMA,A0		;PUT NULL DMA ON DMA QUEUES
	MMFM	A0,A8,A9,A10,A11,A12
	MMTM	A5,A8,A9,A10,A11,A12	;NULL DMA JUNK TOPQ
	MMTM	A4,A8,A9,A10,A11,A12	;NULL DMA JUNK BOTQ

	.if	DEBUG
	move	@SLDEBUG,a0
	btst	3,a0
	jrz	skipline
	move	@ERASELOC,a1
	movi	8,a0
	move	a0,@ERASELOC
	move	a1,@ERASELOC
skipline
	.endif

	move	@QSYNC,a0
	jrne	dispx1
	MOVE	B2,@BOTQ0CNT
	MOVE	B3,@TOPQ0CNT
dispx	rets

dispx1	MOVE	B2,@BOTQ1CNT
	MOVE	B3,@TOPQ1CNT
	rets

*NULL DMA DATA
NULLDMA	.long	>8000,IROM,0,>00010001,0


********************************
* Velocity add loop

valp	move	a0,a1
	addk	>20,a1			;+OXVEL offset

	mmfm	a1,a9,a10,a11,a12	;A12=XV, A11=YV, A10=X, A9=Y

	add	a11,a9			;Add YVEL to YVAL
	move	a9,-*a1,L
	add	a12,a10			;Add XVEL to XVAL (Uses hidden cycle!)
	move	a10,-*a1,L

vel_add	move	*a0,a0,L
	jrnz	valp			;!End?
	rets

********************************
* ENABLE TOP DISPLAY QUEUES

DISPQT
	MOVK	1,A0		;ENABLE YOUR QUEUES
	MOVE	@QSYNC,A1
	NOT	A1
	MOVE	A1,@QSYNC
	JRNE	DISPQT1
	MOVE	A0,@TOPQ1FLG
	jruc	dmastrt

DISPQT1	MOVE	A0,@TOPQ0FLG
	jruc	dmastrt

;	MOVK	1,A1
;	MOVE	@DMACTRL,A0	;DMA BUSY?
;	JRN	DISP3
;	CLR	A1		;NO OVERLOAD
;DISP3	MOVE	A1,@OVBOT	;STORE OVERLOAD 
;	jruc	dmastrt

********************************
* PRIME DMA INTERRUPT FOR BOTTOM QUEUE

DISPH
	MOVK	1,A0		;ENABLE YOUR QUEUES
	MOVE	@QSYNC,A1
	JRNE	DISPH1
	MOVE	A0,@BOTQ1FLG
	JRUC	DISPH2

DISPH1	MOVE	A0,@BOTQ0FLG
DISPH2

;	MOVK	1,A1
;	MOVE	@DMACTRL,A0	;DMA BUSY?
;	JRN	DISPH3		;YES, DO NOT RESTART
;	CLR	A1
;DISPH3	MOVE	A1,@OVTOP	;OVERLOAD INDICATOR


********************************
* START DMA IF APPROPRIATE

dmastrt
	dint
	move	b13,b13
	jrne	dmastx		;If count > 0, DMA already going
	callr	DMANUQ		;Get new Q
	move	b13,b13
	jrz	dmastx		;zero count dont restart
	move	@INTENB,a0	;enable dma interrupt
	ori	X1E,a0
	move	a0,@INTENB
	move	@DMACTRL,a0
	jrn	dmastx		;DMA busy?
	movi	DMAREGS,b12	;Set B12 to DMAREGS
;	clr	a0
;	move	a0,@DMACTRL	;kill any pending	NECESSARY???
	trap	1		;Cause DMA int
dmastx	eint
	rets


********************************
*QDMA PUTS IMAGE ON DMA Q
*INPUTS:
*A1=CONSTANT COLOR:PALETTE
*A3=DESTINATION Y:X
*A5=OFFSET:CONTROL
*A14=ADDRESS OF IMAGE HEADER

;QDMA
;	MMTM	SP,A2,A4,A13
;	MOVE	*A14,A2,L		;GET VSIZE:HSIZE
;	MOVE	*A14(ISAG),A4,L		;GET SAG
;	MOVK	1,A13
;	MOVE	A13,@QDMAFLG		;Q BEING MODIFIED
;	MOVE	@DMAQCUR,A13,L
;	CMPI	DMAQ,A13
;	JRLS	QDMAX			;Q OVERLOAD, CAN IT
;	MMTM	A13,A1,A2,A3,A4,A5
;	MOVE	A13,@DMAQCUR,L
;	CLR	A13
;	MOVE	A13,@QDMAFLG
;
;QDMAX	MMFM	SP,A2,A4,A13
;	RETS

********************************
* MANUAL DMA (SETUP YOUR OWN REGS)
* A1=CONSTANT COLOR:PALETTE
* A2=VSIZE:HSIZE
* A3=DESTINATION Y:X
* A4=SAG
* A5=OFFSET:CONTROL
* Trashes A0

QDMAN
	movk	1,a0
	move	a0,@QDMAFLG		;Q being modified
	move	@DMAQCUR,a0,L
	cmpi	DMAQ,a0
	jrls	qdnx			;Q full?
	mmtm	a0,a1,a2,a3,a4,a5
	move	a0,@DMAQCUR,L
	clr	a0
	move	a0,@QDMAFLG

qdnx	rets

**************************************************************************
*									 *
* STOPOBJS - ZEROS VELOCITIES FOR ALL OBJECTS ON OBJLST.		 *
*									 *
**************************************************************************
STOPOBJS
	PUSH	a0,a1
	clr	a0
	movi	OBJLST,a1
	jruc	so20

so10	MOVE	A0,*A1(OXVEL),L
	MOVE	A0,*A1(OYVEL),L
so20	move	*a1,a1,L
	jrnz	so10

	PULL	a0,a1
	rets


********************************
* Sort object list in z:y priority
* Trashes A0-A7

	.align

YZSORT	movk	1,a1			;Lowest Z
	sll	31,a1			;Make >80000000
	move	a1,a5			;Lowest Y
	movi	OBJLST,a0
	jruc	yzlp

yzlp0	move	*a2(OZPOS),a6		;Get Z
	move	*a2(OYPOS),a7		;Get Y
	cmp	a1,a6
	jrgt	priok			;Next Z > Current Z?
	jrlt	priswap

	cmp	a5,a7			;Next Y > Current Y
	jrge	priok

priswap	dint				;>Make current after next
	move	a2,*a4,L		;Point last to next
	move	*a2,*a0,L		;Point current to block after next
	move	a0,*a2,L		;Point next to current
	eint
	move	a2,a4
	jruc	yzlp			;Continue sort of current obj

priok	move	a0,a4			;A4=*Last obj
	move	a2,a0			;A0=*Current obj
	move	a6,a1			;A1=Current Z
	move	a7,a5			;A5=Current Y

yzlp	move	*a0,a2,L		;A2=*Next obj
	jrnz	yzlp0

	rets

**************************************************************************
* TEST IF OBJECT ON SCREEN
*A8=OBJECT
*RETURNS Z IF ON SCREEN

*ENTER HERE AND PROVIDE YOUR OWN SCREEN BOUNDRIES
SCRTSTG
	mmtm	sp,a1,a2,a3
	jruc	scrtst1

*NORMAL SCREEN BOUNDRIES
SCRTST
	mmtm	sp,a1,a2,a3
	move	@SCRNTL,a2,L		;Get screen top left
	move	@SCRNLR,a3,L		;Get screen lower rgt

scrtst1	move	*a8(OYPOS),a0
	move	*a8(OXPOS),a1
	sll	16,a0
	movx	a1,a0			;get top left of object
	move	@WORLDTL,a1,L
	subxy	a1,a0			;subtract out world base
	move	*a8(OSIZE),a1,L
	addxy	a0,a1			;get lower rt of object

	cmpxy	a3,a0			;is it lower than lower rt?
	JRYGE	scrtf_d			;lower
	JRXGE	scrtf_r			;to the right

	cmpxy	a2,a1
	JRYLE	scrtf_u			;above...
	JRXLE	scrtf_l			;to the left..

	mmfm	sp,a1,a2,a3
	clr	a0			;On screen Z
	rets
scrtf_l	movi	1,a0			;Pass NZ
	mmfm	sp,a1,a2,a3
	rets
scrtf_r	movi	2,a0
	mmfm	sp,a1,a2,a3
	rets
scrtf_u	movi	3,a0
	mmfm	sp,a1,a2,a3
	rets
scrtf_d	movi	4,a0
	mmfm	sp,a1,a2,a3
	rets


	.if	0
********************************
*CLIP AN OBJECT
*INPUTS:
*A2=BOTTOM:RIGHT CLIP (RELATIVE TO CURRENT SIZE)
*A3=TOP:LEFT CLIP (RELATIVE TO CURRENT SIZE)
*A8=OBJECT BLOCK
*RETURNS
*NEW SAG,H,W,OFFSET,XCLIP IN OBJECT STRUCTURE
*ALL REGISTERS PRESERVED

CLIPOBJ
	MMTM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A9,A11,A12
	MOVE	A8,A0
	MOVE	*A8(OXPOS),A4
	MOVE	*A8(OYPOS),A5
	ADDI	OFLAGS,A0	;GET INDEX INTO OBJECT STRUCTURE

*	A1 BECOMES OFFSET
*	A6= TOTAL HORIZ. SIZE
*	A9= VS:HS
*	A11= SAG
*	A12= OFFSET:FLAGS

	MMFM	A0,A9,A11,A12
	MOVE	*A8(OXCLIP),A7
	CLR	A6
	MOVX	A9,A6		;GET TOTAL HORIZ SIZE
	ADD	A3,A2		;LC+RC
	SUBXY	A2,A9		;DECREASE H,W BY XCLIP,YCLIP

*CLIP THE SAG, HS, VS, AND ADJUST OFFSET

	MOVX	A3,A1		;GET LEFT CLIP
	SEXT	A1
	ADD	A1,A4		;ADJUST OXPOS
	SRA	16,A3		;GET TOP CLIP
	ADD	A3,A5		;ADJUST OYPOS
	JREQ	OCLIP1
	ADD	A7,A6		;ADD PRECLIP TO THE WIDTH TO CALC NEW SAG
	MPYS	A6,A3		;TOP CLIP X TOTAL HORIZ SIZE
OCLIP1
	ADDXY	A2,A7
	ZEXT	A7,W		;NEW OXCLIP
	SLL	16,A2
	BTST	B_FLIPH,A12
	JREQ	OCLIP2
	NEG	A2		;NEGATE RC+LC
	NEG	A1		;NEGATE LC
OCLIP2
	BTST	B_FLIPV,A12
	JREQ	OCLIP3
	NEG	A3		;NEGATE	THS*TC
OCLIP3
	ADD	A1,A3		;ADD LEFT CLIP TERM +  TC*THS
	SLL	3,A3
	ADD	A3,A11		;ADD TO SAG
	ADD	A2,A12		;ADD CLIP OFFSET TO OFFSET
	PUSHST
	DINT
	MMTM	A0,A9,A11,A12
	MOVE	A4,*A8(OXPOS)
	MOVE	A5,*A8(OYPOS)
	MOVE	A7,*A8(OXCLIP)	;NEW OXCLIP
	POPST
	MMFM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A9,A11,A12
	RETS

	.endif


**************************************************************************
*									 *
* OBJECT BLOCK INITIALIZATION ROUTINES					 *
*									 *
**************************************************************************

**************************************************************************
*									 *
* OINIT - INITIALIZE FREE LIST						 *
*									 *
**************************************************************************
OINIT
	MMTM	SP,A0,A1,A2,A3		;SAVE REG

	CLR	B13			;CLEAR OUT DMA DEDICATED REGISTERS
	CLR	B14
	MOVI	NOBJ,A3			;# OF OBJECT BLOCKS TO INIT

	MOVI	SCRNST,A0,L		;INIT SCREEN TOP LEFT [Y,X]
	MOVE	A0,@SCRNTL,L
	MOVI	SCRNEND,A0,L		;INIT SCREEN LOWER RIGHT [Y,X]
	MOVE	A0,@SCRNLR,L

	PUSHST
	DINT
	MOVE	@INTENB,A0,W
	ANDNI	X1E,A0			;NO MORE DMA INTERRUPTS
	MOVE	A0,@INTENB,W
	POPST

	CLR	A0
	MOVE	A0,@WORLDTLX,L
	MOVE	A0,@WORLDTLY,L
	MOVE	A0,@WORLDTL,L
;	MOVE	A0,@BAK2TLX,L
;	MOVE	A0,@BAK2TLY,L
	MOVE	A0,@DMAQCNT,W		;CLEAR CURRENT DMAQ COUNT
	MOVE	A0,@BOTQ0CNT,W		;CLEAR BOTTOM QUEUE COUNT #0
	MOVE	A0,@BOTQ1CNT,W		;CLEAR BOTTOM QUEUE COUNT #1
	MOVE	A0,@TOPQ0CNT,W		;CLEAR TOP QUEUE COUNT #0
	MOVE	A0,@TOPQ1CNT,W		;CLEAR TOP QUEUE COUNT #1

	MOVI	DMAQ+QSIZE,A1
	MOVE	A1,@DMAQCUR,L		;INIT MISC DMA QUEUE

	MOVE	A0,@SCROLLX,L	;CLEAR SCROLLX
	MOVE	A0,@SCROLLY,L	;CLEAR SCROLLX

;	MOVE	A0,@BAK2LST,L	;NULL BACKGROUND 2 OBJECT LIST
	MOVE	A0,@BAKLST,L	;NULL BACKGROUND OBJECT LIST
	MOVE	A0,@OBJLST,L	;NULL OBJECT LIST
	MOVI	OBJSTR,A1,L
	MOVE	A1,@OFREE,L	;SETUP FREE LIST
OINITL
	MOVE	A1,A2
	ADDI	OBSIZ,A1,W
	MOVE	A1,*A2,L		;LINK EM UP
	DSJS	A3,OINITL		;CONTINUE FOR NPROC
	MOVE	A0,*A2,L		;ZERO LAST LINK
	MMFM	SP,A0,A1,A2,A3	;RESTORE REGS
	RETS

**************************************************************************
*									 *
* GETOBJ - GET A FREE OBJECT BLOCK FOR USE				 *
* RETURNS								 *
* A0 = PTR TO OBJECT BLOCK						 *
* IF NO BLOCKS WERE AVAILABLE THEN THE Z FLAG IS SET			 *
*									 *
**************************************************************************
GETOBJ
	move	a2,*-sp,L
	MOVE	@OFREE,A0,L		;POINTER TO NEXT AVAILABLE OBJ BLOCK
	JRZ	NONELFT
	MOVE	*A0,A2,L
	MOVE	A2,@OFREE,L		;ADJUST POINTER TO FREE LIST
	CLR	A2
	MOVE	A2,*A0(OXCLIP)		;CLEAR CLIP
	MOVE	A2,*A0(OPLINK),L	;CLEAR LINK
	MOVE	A2,*A0(OFLAGS)
GETOX
	move	*sp+,a2,L
	move	a0,a0			;Pass Z flag
	rets

NONELFT
	.IF	DEBUG
	LOCKUP
	EINT
	.ELSE
	CALLERR	3,1
	.ENDIF
	JRUC	GETOX

********************************
*FREE OBJECT WITH ERROR CHECKING

;FREEOBJE
;	MMTM	SP,A1,A2
;	CMPI	OBJSTR,A0
;	JRHS	FREEE1
;
;	.IF	DEBUG
;	LOCKUP
;*	CALLERR	2			;PTR TOO LOW
;	EINT
;	.ENDIF
;
;	JRUC	FREERRX
;FREEE1
;	CMPI	OBJLSTND,A0
;	JRLO	FREEE2
;
;	.IF	DEBUG
;*		CALLERR	2			;PTR TOO HIGH
;	LOCKUP
;	EINT
;	.ENDIF
;
;	JRUC	FREERRX
;FREEE2
;	MOVE	A0,A2
;	SUBI	OBJSTR,A2
;	MOVI	OBSIZ,A1
;	MODU	A1,A2
;	JRZ	FREEE3
;
;	.IF	DEBUG
;*	CALLERR	2			;PTR NOT VALID
;	LOCKUP
;	EINT
;	.ENDIF
;
;	JRUC	FREERRX
;FREEE3
;	CALLR	ISOBJ
;	JREQ	FREEE4
;
;	.IF	DEBUG
;*	CALLERR	2			;OBJECT IS ON THE ACTIVE LIST
;	LOCKUP
;	EINT
;	.ENDIF
;
;	JRUC	FREERRX
;FREEE4
;	CALLR	ISFREE
;	JREQ	FREEEC
;
;	.IF	DEBUG
;*	CALLERR	2			;OBJECT IS ALREADY ON THE FREE LIST
;	LOCKUP
;	EINT
;	.ENDIF
;
;FREERRX
;	MMFM	SP,A1,A2		;EXIT WITH ERROR
;	RETS
;FREEEC
;	MMFM	SP,A1,A2		;EVERYTHING IS O.K. CONTINUE TO FREEOBJ

********************************
*MAIN FREE OBJECT ENTRY
FREEOBJ
	PUSH	A2
	MOVE	@OFREE,A2,L
	MOVE	A2,*A0,L
	MOVE	A0,@OFREE,L		;BLOCK IS ON FREE LIST NOW
	PULL	A2
	RETS

********************************
* PULLOBJ - PULL AN OBJECT BLOCK FROM AN OBJECT LIST
*	    DO NOT PUT IT BACK ON THE FREE LIST
* A0 = PTR TO BLOCK TO BE PULLED

PULLOBJ
	MMTM 	SP,A2,A4

	MOVI	OBJLST,A4
PULLLOOP
	MOVE 	A4,A2			;PTR TO PREVIOUS IN A2
	MOVE 	*A2,A4,L		;PTR TO NEXT IN A4
	JRZ 	NOPULL			;BR = END OF LIST
	CMP  	A4,A0			;IS THIS THE GUY?
	JRNE 	PULLLOOP		;BR = NO
	MOVE 	*A0,*A2,L		;LINK AROUND THIS OBJECT
	MMFM 	SP,A2,A4
	RETS

NOPULL
	.if	DEBUG
	LOCKUP
	.endif
	MMFM 	SP,A2,A4
	RETS


********************************
* INSERT AN OBJECT BLOCK INTO AN OBJECT LIST
* LIST IS SORTED BY INCREASING Z AND INCREASING Y WITHIN CONSTANT Z
*
* BLOCK TO BE INSERTED IN A0

*INSERT BACKGROUND 2 OBJECT (SORTED)
;INSB2OBJ:
;	MMTM	SP,A1,A2,A3,A4,A5
;	MOVI	BAK2LST,A4
;	JRUC	INSOBJ0

********************************
* INSERT BACKGROUND OBJECT (SORTED)

INSBOBJ
	MMTM	SP,A1,A2,A3,A4,A5
	MOVI	BAKLST,A4
	JRUC	INSOBJ0

********************************
* INSERT FOREGROUND OBJECT

INSOBJ
	MMTM	SP,A1,A2,A3,A4,A5
	MOVI	OBJLST,A4

INSOBJ0
	MOVE	*A0(OZPOS),A1		;GET Z POSITION
	MOVE	*A0(OYPOS),A5		;GET Y POSITION
INS_LOOP
	MOVE	A4,A2			;A2=PTR TO PREV
	MOVE	*A2,A4,L		;A3=PTR TO NEXT
	JRZ	INS_AT_END		;End of list?
	MOVE	*A4(OZPOS),A3		;A3=ZPOS
	CMP	A3,A1
	JRGT	INS_LOOP
	JRLT	INS_AT_END

	MOVE	*A4(OYPOS),A3		;TEST Y POSITION
	CMP	A3,A5
	JRGT	INS_LOOP

INS_AT_END
	MOVE	A4,*A0,L		;PUT NEXT LINK IN NEW BLOCK
	MOVE	A0,*A2,L		;PUT LINK TO NEW IN PREV BLOCK
	MMFM	SP,A1,A2,A3,A4,A5
	RETS


********************************
* Delete background2 object

;DELB2OBJ
;	MMTM	SP,A2,A4
;	MOVI	BAK2LST,A4
;	JRUC	DEL_LOOP

********************************
* Delete background object

DELBOBJ		;A0=*Obj

	MMTM	SP,A2,A4
	MOVI	BAKLST,A4
	JRUC	DEL_LOOP

********************************
* Delete foreground object

DELOBJA8	;A8=*Obj

	move	a8,a0

********************************
* Delete foreground object

DELOBJ		;A0=*Obj

	MMTM	SP,A2,A4

	.if	DEBUG
	move	*a0(OID),a2
	cmpi	CLSENMY|TYPGRW,A2
	jreq	hulkerr
	cmpi	CLSENMY|TYPHULK,A2
	jrne	hulkok

hulkerr	LOCKUP
	eint

hulkok
	.endif


	MOVI	OBJLST,A4
DEL_LOOP
	MOVE	A4,A2		;A2=*PREV
	MOVE	*A2,A4,L	;A4=*NEXT
	JRZ	delerr

DEL_CHK	CMP	A4,A0
	JRNE	DEL_LOOP

	MOVE	*A0,*A2,L	;PUT NEXT LINK IN PREV BLOCK
	MOVE	@OFREE,A2,L
	MOVE	A2,*A0,L
	MOVE	A0,@OFREE,L	;RETURN DELETED BLOCK TO FREE STACK

;	move	*A0(OFLAGS),A4
;	andni	M_INUSE,A4
;	move	A4,*A0(OFLAGS)
	clr	a4
	move	a4,*a0(OXPOS)	;Indicates not in use for collisions

DELOBJX	MMFM	SP,A2,A4
	RETS

delerr
	.IF	DEBUG
	LOCKUP
	EINT
;TURMELL
	.ELSE
;	CALLERR	1,5
	.ENDIF
	JRUC	DELOBJX



********************************
* FRANIM list an object, delete it and DIE

FRQDELDIE	;A8=*Obj, A9=*FRANIM list

	JSRP	FRANIMQ

********************************
* Delete foreground object and DIE

DELOBJDIE	;A8=*Obj


	.if	DEBUG
	move	*a8(OID),a1
	cmpi	CLSENMY|TYPGRW,A1
	jreq	hulk2err
	cmpi	CLSENMY|TYPHULK,A1
	jrne	hulk2ok

hulk2err
	LOCKUP
	eint
hulk2ok
	.endif


	movi	OBJLST,a1

do20	move	a1,a2		;A2=*Prev
	move	*a2,a1,L	;A1=*Next
	jrz	doerr
	cmp	a1,a8
	jrne	do20

	move	*a8,*a2,L	;Put next link in prev block
	move	@OFREE,a2,L
	move	a2,*a8,L
	move	a8,@OFREE,L	;Return deleted block to free stack

	clr	a1
	move	a1,*a8(OXPOS)	;Indicates not in use for collisions
dox	jauc	SUCIDE

doerr  
	.if	DEBUG
	LOCKUP
	eint
	.else
;	CALLERR	1,5
	.endif
	jruc	dox


*************************************************************************
*									*
* KILL A CLASS OF OBJECTS						*
* A0=OID (16 BITS) ,A1=MASK (16 BITS, Bits to keep)			*
*									*
*************************************************************************

*KILL A CLASS FROM THE BACKGROUND
;KILB2OBJ
;	MMTM	SP,A0,A2,A3,A4
;	MOVI	BAK2LST,A2,L
;	JRUC	KILGEN

*KILL A CLASS FROM THE BACKGROUND
KILBOBJ
	MMTM	SP,A0,A2,A3,A4
	MOVI	BAKLST,A2,L
	JRUC	KILGEN

********************************
* Kill one class from the obj list

KIL1OBJC	;A0=OID, A1=Trashed

	clr	a1

********************************
* Kill a class from the obj list

KILOBJN		;A0=OID, A1=!Mask (Bits to remove)

	not	a1

********************************
* Kill a class from the obj list

KILOBJ
	MMTM	SP,A0,A2,A3,A4
	MOVI	OBJLST,A2,L

KILGEN	AND	A1,A0		;FORM MATCH

KILOBP	MOVE	A2,A3		;SAVE PREVIOUS
	MOVE	*A2,A2,L	;GET NEXT
	JREQ	KILOBX		;ALL DONE
	MOVE	*A2(OID),A4
	AND	A1,A4		;CAN DONT CARE BITS
	CMP	A0,A4		;MATCH?
	JRNE	KILOBP		;NO

	MOVE	*A2,*A3,L	;LINK AROUND IN ACTIVE LIST
	MOVE	@OFREE,A4,L	;LINK INTO FREE LIST AT START
	MOVE	A4,*A2,L
	MOVE	A2,@OFREE,L	;POINT FREE TO CELL
	MOVE	A3,A2
	JRUC	KILOBP		;KILL THE REST
KILOBX
	MMFM	SP,A0,A2,A3,A4
	RETS

**************************************************************************
*									 *
* EXISTOBJ - DOES AN OBJECT FROM A CERTAIN CLASS EXIST?			 *
* A0 = OID								 *
* A1 = MASK(0'S DON'T CARE)						 *
* RETURNS:								 *
*	Z BIT SET = NO OBJECT, A0 = 0					 *
*	Z BIT CLR = YES OBJECT, A0 = PTR TO OBJECT			 *
*									 *
**************************************************************************
EXISTOBJ
	MMTM	SP,A2,A3
	MOVI	OBJLST,A2,L
	SEXT	A0
	AND	A1,A0		;FORM MATCH
EXISTOBP
	MOVE	*A2,A2,L	;GET NEXT
	JREQ	EXISTOBX	;ALL DONE
	MOVE	*A2(OID),A3
	AND	A1,A3		;CAN DONT CARE BITS
	CMP	A0,A3		;MATCH?
	JRNE	EXISTOBP	;NO
EXISTOBX
	MOVE	A2,A0
	MMFM	SP,A2,A3
	RETS

**************************************************************************
*									 *
* ISFREE - IS AN OBJECT ON THE FREE LIST?				 *
* A0 = PTR TO OBJECT							 *
* RETURNS:								 *
*	Z BIT SET = NO OBJECT, A0 = 0					 *
*	Z BIT CLR = NO OBJECT, A0 = PTR TO OBJECT			 *
*									 *
**************************************************************************
;ISFREE
;	PUSH	A2
;	MOVI	OFREE,A2,L
;	JRUC	ISOBP

**************************************************************************
*									 *
* ISOBJ - IS AN OBJECT ON THE OBJECT LIST?				 *
* A0 = PTR TO OBJECT							 *
* RETURNS:								 *
*	Z BIT SET = NO OBJECT, A0 = 0					 *
*	Z BIT CLR = NO OBJECT, A0 = PTR TO OBJECT			 *
*									 *
**************************************************************************
ISOBJ
	PUSH	a2
	movi	OBJLST,a2,L

ISOBP	move	*a2,a2,L
	jrz	ISOBX		;End?
	cmp	a0,a2
	jrne	ISOBP		;No match?
	PULL	a2
	move	a0,a0		;Clr Z
	rets

ISOBX	PULL	a2
	clr	a0		;Set Z
	rets

**************************************************************************
*									 *
* ADJSTWTL - ADJUST THE OBJECT'S COORDINATES IN RELATION TO THE		 *
*	   WORLD. IT IS ASSUMED THAT THE CURRENT COORDINATES		 *
*	   ARE SCREEN RELATIVE.						 *
* A0 = PTR TO THE OBJECT BLOCK						 *
*									 *
**************************************************************************
ADJSTWTL
	MMTM	SP,A3,A5
	MOVE	@WORLDTLX,A5,L
	MOVE	*A0(OXVAL),A3,L
	ADD	A5,A3
	MOVE	A3,*A0(OXVAL),L
	MOVE	@WORLDTLY,A5,L
	MOVE	*A0(OYVAL),A3,L
	ADD	A5,A3
	MOVE	A3,*A0(OYVAL),L
	MMFM	SP,A3,A5
	RETS
**************************************************************************
*									 *
* ADJNEWTL - ADJUST AN OBJECT TO A NEW SET OF X,Y WORLD COORDINATES	 *
*	   BEFORE THEY ARE STORED(TAKE EFFECT).				 *
* NOTE: CURRENT OBJECT COORDS. MUST BE ABSOLUTE WORLD.			 *
* A0 = PTR TO OBJECT							 *
* A4 = NEW WTLX, 32 BITS						 *
* A5 = NEW WTLY, 32 BITS						 *
*									 *
**************************************************************************
ADJNEWTL
	PUSH	a1,a2
	CALLR	GSCRNREL		;SCREEN RELATIVE PLEASE
	ADD	A4,A1
	ADD	A5,A2			;ADJUST
	MOVE	A1,*A0(OXVAL),L
	MOVE	A2,*A0(OYVAL),L		;STORE
	PULL	a1,a2
	RETS
**************************************************************************
*									 *
* GSCRNREL - GET THE SCREEN RELATIVE X,Y COORDINATES OF AN OBJECT	 *
*	   IT IS ASSUMED THATE THE CURRENT X,Y COORDINATES ARE		 *
*	   WORLD ABSOLUTE.						 *
* A0 = PTR TO THE OBJECT BLOCK						 *
* RETURNS								 *
* A1 = X SCREEN RELATIVE, 32 BITS					 *
* A2 = Y SCREEN RELATIVE, 32 BITS					 *
*									 *
**************************************************************************
GSCRNREL
	PUSH	a5
	MOVE	@WORLDTLX,A5,L
	MOVE	*A0(OXVAL),A1,L
	SUB	A5,A1
	MOVE	@WORLDTLY,A5,L
	MOVE	*A0(OYVAL),A2,L
	SUB	A5,A2
	PULL	a5
	RETS

**************************************************************************
*									 *
* SCRNRELV - MAKE THE X & Y VELOCITIES OF AN OBJECT RELATIVE TO THE	 *
*	   SCREEN. IN OTHER WORDS, ADJUST THEM SO THAT THE CURRENT	 *
*	   SCROLL RATE DOESN'T AFFECT THEM. 				 *
* A0 = PTR TO OBJECT							 *
*									 *
**************************************************************************
SCRNRELV
	PUSH	a1,a5
	MOVE	@SCROLLX,A5,L
	MOVE	*A0(OXVEL),A1,L
	ADD	A5,A1
	MOVE	A1,*A0(OXVEL),L
	MOVE	@SCROLLY,A5,L
	MOVE	*A0(OYVEL),A1,L
	ADD	A5,A1
	MOVE	A1,*A0(OYVEL),L
	PULL	a1,a5
	RETS

**************************************************************************
*									 *
* GANISAG - ADJUST CURRENT OBJECT IMAGE WITH RESPECT TO IT'S		 *
*	   ANIMATION PNT. AND FLIP FLAGS				 *
* NOTE: CALL ONLY AFTER INITIALIZING WITH STFOBJ, OR SOMETHING.		 *
* A0 = PTR TO OBJECT BLOCK						 *
* A2 = NEW OYVAL							 *
* A3 = NEW OXVAL							 *
* A4 = NEW FLAGS							 *
* RETURNS								 *
* A2 = ADJUSTED OYVAL							 *
* A3 = ADJUSTED OXVAL							 *
*									 *
**************************************************************************
GANISAG
	PUSH	a1,a4,a6,a7
	PUSH	a2,a3
	MOVE	*A0(OIMG),A1,L
	CALLR	GSAGOF
	MOVE	A3,*A0(OSAG),L
	MOVE	A2,*A0(OSIZE),L
	MOVE	A4,*A0(OFLAGS),L
	CALLR	GANIOF
	PULL	A2,A3
	SUB	A6,A3
	SUB	A7,A2			;ADJUST UPPER LEFT CORNER
	MOVE	A3,*A0(OXVAL),L
	MOVE	A2,*A0(OYVAL),L
	PULL	a1,a4,a6,a7
	RETS


********************************
* Begin an object
*
* A0=OXVAL, A1=OYVAL, A2=*IMG, A3=OZPOS, A4=OFLAGS, A5=OID, A6=XVEL, A7=YVEL

BEGINOBJ
	move	@WORLDTLX,a8,L		;Adjust for world coord
	add	a8,a0
	move	@WORLDTLY,a8,L
	add	a8,a1

BEGINOBJ2
	PUSH	a1,a2,a3,a4,a6,a7,a9,a10
	move	a0,a9			;X
	move	a1,a10			;Y
	move	a2,a1			;IMG

	move	*a1(ICMAP),a0,L		;Get *palette
	.if	DEBUG
	jrnn	bopalerr		;No pallette?
	.endif
	calla	GETFPAL

bo20	move	@OFREE,a8,L		;Pointer to next available obj block
	jrz	begobjerr		;No objs?
	move	*a8,a2,L
	move	a2,@OFREE,L		;Adjust pointer to free list

	move	a0,*a8(OPAL),L		;Set pallette & constant
	clr	a0
	move	a0,*a8(OXCLIP)		;Clr stuff

	move	a3,*a8(OZPOS)
	move	a5,*a8(OID)
	move	a6,*a8(OXVEL),L
	move	a7,*a8(OYVEL),L

	callr	GSAGOF
	callr	GANIOF			;Adjust animation offset

	sub	a6,a9			;- x anioff
	sub	a7,a10			;- y anioff
	move	a9,*a8(OXVAL),L
	move	a10,*a8(OYVAL),L

	move	a1,*a8(OIMG),L
	move	a3,*a8(OSAG),L
	move	a2,*a8(OSIZE),L
	move	a4,*a8(OFLAGS),L	;&OFSET

	PULL	a1,a2,a3,a4,a6,a7,a9,a10

	move	a13,*a8(OPLINK),L
	move	a8,a0
	jruc	INSOBJ			;Insert object into list


	.if	DEBUG
bopalerr
;WE NEED TO SKIP STARTING THIS OBJECT AND HAVE OFFENDING PROCESS DIE!
	LOCKUP				;Object doesn't have pallette!
	eint
	clr	a0
	jruc	bo20
	.endif

begobjerr
	.if	DEBUG
	LOCKUP				;Out of objects!
	eint
	.else
	CALLERR	3,1
	.endif
	move	@OBJLST,a8,L		;Pass 1st obj on list
	PULL	a1,a2,a3,a4,a6,a7,a9,a10
	rets


**************************************************************************
* STFOBJ - STUFF AN OBJECT USING AN INITIALIZATION TABLE
* A0=*IMAGE
* A14=*INIT. TABLE
* INIT. TABLE:
* .LONG OXVAL,OYVAL,OIMG
* .WORD OZPOS,OFLAGS,OID
* .LONG OXVEL,OYVEL,OCVECT
* RETURNS
* A14=POINTING TO WORD AFTER INIT TAB

STFOBJ
	PUSH	a1,a2,a3,a4,a6,a7,a9,a10
	MOVE	*A14+,A9,L	;XVAL
	MOVE	*A14+,A10,L	;YVAL
	MOVE	*A14+,A1,L	;IMG

	MOVE	*A14+,A2	;ZPOS
	MOVE	A2,*A0(OZPOS)
	MOVE	*A14+,A4	;FLAGS
	MOVE	*A14+,A2	;OID
	MOVE	A2,*A0(OID)

	MOVE	*A14+,A2,L	;XVEL
	MOVE	A2,*A0(OXVEL),L
	MOVE	*A14+,A2,L	;YVEL
	MOVE	A2,*A0(OYVEL),L

	MOVE	@CURPAL,A2	;OCONST:OPAL
	MOVE	A2,*A0(OPAL),L	;Set pallette & constant

	CALLR	GSAGOF
	CALLR	GANIOF		;ADJUST ANIMATION OFFSET

	SUB	A6,A9		;SUBTRACT X ANIOFF
	SUB	A7,A10		;SUBTRACT Y ANIOFF

	MOVE	A9,*A0(OXVAL),L
	MOVE	A10,*A0(OYVAL),L
	MOVE	A1,*A0(OIMG),L
	MOVE	A3,*A0(OSAG),L
	MOVE	A2,*A0(OSIZE),L
	MOVE	A4,*A0(OFLAGS),L
	PULL	a1,a2,a3,a4,a6,a7,a9,a10
	RETS

********************************
* Get SAG for object - Adjusts SAG for flip
* A1=*Image header (OIMG)
* A4=Object flags
*Rets:
* A2=New OSIZE
* A3=New SAG
* A4=New OFFSET:OFLAGS

BKGSAGOF
	PUSH	a5,a6
	move	*a1(ISAG->20),a3,L	;GET TOP LEFT SAG (-20 -> no ani off)
	jruc	gso10

GSAGOF
	PUSH	a5,a6
	move	*a1(ISAG),a3,L	;Get top left sag

gso10	zext	a4		;Zero offset in A4
	move	*a1,a2,L	;ISIZE
	addk	3,a2		;Round up to 4 bit boundary
	srl	2,a2
	sll	2,a2
	move	a2,a5
	zext	a5
	sll	3,a5		;A5=X size*8

	btst	B_FLIPH,a4
	jrz	gsagv		;No H flip?
	add	a5,a3		;Add THS-1 to SAG
	subk	8,a3

	move	a2,a6
	sll	1,a6
	subk	1,a6		;2*THS-1 to offset
	sll	16,a6		;Move to Y
	movy	a6,a4

gsagv	btst	B_FLIPV,a4
	jrz	gsagx		;No V flip?
	move	a2,a6
	srl	16,a6		;A6=Height
	subk	1,a6		;First entry last row
	mpys	a6,a5		;THS*(TVS-1)
	add	a5,a3		;Add to sag

	movx	a2,a6
	sll	1,a6
	neg	a6		;-2*ths
	sll	16,a6		;Move to Y
	addxy	a6,a4		;Add to offset

gsagx	PULL	a5,a6
	rets

**************************************************************************
* ANI - ANIMATION SUBROUTINE
* A1=NEW IMAGE POINTER
* A4=NEW OFLAGS
* A8=OBJECT STRUCTURE POINTER TO BE UPDATED
**************************************************************************
ANI
	PUSH	a0,a2,a3,a4,a5,a6,a7

	cmpi	>FFC00000,a1
	jrlo	anierr

	move	a1,a3
	move	a4,a5
	move	*a8(OIMG),a1,L
	move	*a8(OFLAGS),a4
	cmp	a1,a3
	jrne	ani1			;Different img?

	sext	a5
	cmp	a4,a5
	jreq	anix			;All the same?

ani1	move	*a8(OSIZE),a2,L
	callr	GANIOF			;Get old animation offset
	move	a3,a1			;New OIMG
	move	a5,a4			;New OFLAGS
	move	a6,a0
	move	a7,a5
	callr	GSAGOF			;Get SAG, offset, HW
	callr	GANIOF			;Get new animation offset
	move	a1,*a8(OIMG),L
	sub	a6,a0			;Subtract new from old
	sub	a7,a5

	move	a8,a6			;Get push address of oflags,osag,osize
	addi	OFLAGS+>60,a6
	mmtm	a6,a2,a3,a4		;Save new data

	subi	>50,a6
	move	*a6,a7,L		;New OXVAL
	add	a0,a7
	move	a7,*a6+,L
	move	*a6,a7,L		;New OYVAL
	add	a5,a7
	move	a7,*a6,L
;	clr	a7
;	move	a7,*a8(OXCLIP)		;CLEAR PRECLIP

anix	PULL	a0,a2,a3,a4,a5,a6,a7
	rets

anierr 
	.IF	DEBUG
	LOCKUP
	eint
	.ELSE
	CALLERR	2,8
	.ENDIF
	jruc	anix


**************************************************************************
*									 *
* GETANIXY - GET THE X AND Y POSITIONS OF AN OBJECTS ANIMATION		 *
*	   POINT.							 *
* A8 = OBLOCK PTR.							 *
* RETURNS								 *
* A2 = APOINT OYVAL, 32 BITS						 *
* A3 = APOINT OXVAL, 32 BITS						 *
*									 *
**************************************************************************
GETANIXY
	MMTM	SP,A1,A4,A6,A7
	MOVE	*A8(OIMG),A1,L
	MOVE	*A8(OSIZE),A2,L
	MOVE	*A8(OFLAGS),A4
	CALLR	GANIOF
	MOVE	*A8(OXVAL),A3,L
	MOVE	*A8(OYVAL),A2,L
	ADD	A6,A3
	ADD	A7,A2
	MMFM	SP,A1,A4,A6,A7
	RETS

********************************
* Get animation offset (Fast!)
* A1=*Image header, A2=H:W, A4=OFLAGS
* Trashes B0
*Rets:
* A6=X ANI OFFSET X 64K
* A7=Y ANI OFFSET X 64K

GANIOF
	move	*a1(IANIOFF),a6,L
	cmpi	IROM,a6
	jrge	gani20

gani0	clr	a7
	movy	a6,a7
	sll	16,a6		;Move to upper word

	btst	B_FLIPH,a4
	jrz	gani1
	move	a2,b0
	subk	1,a2
	sll	16,a2		;Move to upper word
	neg	a6
	add	a2,a6		;Sub THS-1
	move	b0,a2

gani1	btst	B_FLIPV,a4
	jrz	ganix
	move	a2,b0
	neg	a7
	srl	16,a2
	subk	1,a2
	sll	16,a2
	add	a2,a7		;Sub TVS-1
	move	b0,a2

ganix	rets

gani20	clr	a6
	jruc	gani0


	.end
