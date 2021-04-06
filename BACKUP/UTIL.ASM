**************************************************************
*
* Software:		?
* Initiated:		?
*
* Modified:		Shawn Liptak, 7/?/91	-Improved FLASHME, new FRANIMQ
* 			Shawn Liptak, 7/?/91	-New and improved random stuff
* 			Shawn Liptak, 9/13/91	-Fixed various junk (STRINGER)
*
* COPYRIGHT (C) 1991 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 9/24/91 19:28
**************************************************************
	.FILE	'UTIL.ASM'
	.TITLE	" UTILITY - GENERAL PURPOSE SUBROUTINES"
	.WIDTH	132
	.OPTION	B,D,L
	.MNOLIST

	.INCLUDE	"MPROC.EQU"
	.INCLUDE	"DISP.EQU"
	.INCLUDE	"\VIDEO\SYS\GSP.INC"
	.INCLUDE	"\VIDEO\SYS\SYS.INC"
	.INCLUDE	"\VIDEO\SYS\MACROS.HDR"
	.INCLUDE	GAME.EQU
	.include	"shawn.hdr"		;Macros


*UTILITY SUBROUTINE EQUATES
	.GLOBAL	SCRCLR,MYOINIT,SETPPROC,GPALOBJ,GBPALOBJ
	.GLOBAL SHVELCPY,SHVELFLP,FLP,OBJOFF,OBJON,CLRPDATA
	.GLOBAL	ADDSUPP,DELSUPP,STRLNRM,STRCNRM,STRCNRMO,STRLNRMO,STRCNRMO_1
	.GLOBAL	RANDU,RANDOM,SRAND,RANGRAND,RANDPER,BLNKAREA
	.GLOBAL FRANIM,FRANIMQ,AUTOEOFF,AUTOEON,DMAQWAIT,SYNCHALF
	.GLOBAL	STRNGLEN,DMAN,CLRWORLD,CLR_SCRN
	.GLOBAL STRRNRM,FILLAREA,SYNCFULL,SCRFIL,GETCPNT
;	.def	DTIME
*PAL EQUATES
	.GLOBL DELPAL,GETFPAL,INITBPAL,FINDPAL,INITPAL,PALSET
*RAM EQUATES
	.GLOBL	INTSYNC0,INTSYNC1,NOAUTOE,SYSCOPY
	.GLOBL	GAMERASE

	.REF	LOWZ


;DEFINED IN THIS FILE

	.DEF	STRNGRAM,HEXTOASC,GETANIX,DMAHALT,WRLD,PSTOP
	.DEF	COLCYC,CYCLE_TABLE,DMAWAIT,FLASHME
	.def	RNDRNG,RNDRNG0

;RAM
	.BSS	STRNGRAM,20*16
	.BSS	WRLD,16

	.EVEN

	.TEXT

********************************
* Flash an image by making a constant color
*A8=*Image to flash
*A9=Color to flash with *64K

FLASHME
	move	*a8(OCONST),a10
	jrnz	fmx			;Flashing?
	srl	16,a9
	move	a9,*a8(OCONST)		;Set color
	move	*a8(OFLAGS),a0
	movk	8,a1
	or	a1,a0			;Set constant
	move	a0,*a8(OFLAGS)
	SLEEPK	2
	clr	a0
	move	a0,*a8(OCONST)		;Clr color
	move	*a8(OFLAGS),a0
	andi	>fff5,a0		;Clr constant & nonzero
	addk	2,a0			;Set nonzero
	move	a0,*a8(OFLAGS)
fmx	DIE


********************************
*CHEAP COLOR CYCLER
*CYCLES ANY NUMBER OF COLORS
*A8=PALETTE NAME
*A9=RAM STORAGE AREA
*A10=MSW START COLOR, LSW END COLOR
*A11=SPEED, A11=NEGATIVE FOR REVERSE CYCLER

COLCYC	
	SLEEPK	4
	MOVE	A8,A0
	CALLA	FINDPAL		;FIND PALETTE
	JRZ	COLCYC		;WAIT TILL IT SHOWS UP FOLKS...

	CLR	A1		;GET THE COLORS INTO RAM
	MOVX	A10,A1		;GET END COLOR
	SRL	16,A10		;ADJUST START COLOR
	SUB	A10,A1		;GET COUNT
	MOVE	A1,*A13(PDATA)	;SAVE COUNT
	MOVE	A1,A4
	SLL	4,A1		;COUNT IN WORDS
	MOVE	A10,A5
	SLL	4,A5		;OFFSET INTO PALETTE
	ADD	A8,A5
	ADDK	16,A5		;SKIP PALETTE WORD COUNT
	MOVE	A9,A3
	MOVE	A9,A6
	ADD	A1,A6
	MOVE	A6,A8

COLCYC1	MOVE	*A5+,A7		;TRANSFER IT TWICE
	MOVE	A7,*A3+
	MOVE	A7,*A6+
	DSJS	A4,COLCYC1

	SRL	8,A0
	SLL	8,A0
	ADD	A0,A10			;COLRAM DESTINATION

COLCYCB
	MOVE	A8,*A13(PDATA+>20),L	;SAVE RAM ADDRESS
COLCYCBL
	MOVE	A8,A0			;GET SOURCE ADDRESS
	MOVE	A10,A1			;GET DESTINATION CONSTANT
	MOVE	*A13(PDATA),A2,W	;GET COUNT
	CALLA	PALSET
	SUBK	16,A8
	CMP	A8,A9
	JRLO	CCYCBSLP
	MOVE	*A13(PDATA+>20),A8,L	;GET SOURCE TABLE START
CCYCBSLP
	MOVE	A11,A0		;GET SLEEP TIME
	CALLA	PRCSLP
	JRUC	COLCYCBL

********************************
*CYCLE A PAL WITH A FIXED ROM COLOR TABLE
*A8= [COLOR # TO START AT,# TO CYCLE]
*A9= PAL NAME TO CYCLE
*A10=TABLE TO CYCLE IT WITH
*A11=RATE OF CYCLE IN TICKS

CYC0	SLEEP	60

CYCLE_TABLE
	MOVE	A9,A0			;PAL NAME TO CYCLE
	CALLA	FINDPAL
	jrz	CYC0
	SRL	8,A0
	SLL	8,A0
	MOVY	A8,A1
	SRL	16,A1			;A1=COLOR # TO START WITH
	MOVE	A8,*A13(PDATA),W	;PDATA WILL HAVE # TO CYCLE (CNT)
	MOVE	*A10,A2,W
	MOVE	A2,*A13(PDATA+16),W	;VALUE IN TABLE TO STOP AT
	MOVE	A0,A8			;A8=[PAL #,0]
	ADD	A1,A8			;A8=[PAL #,COLOR TO START AT]
	MOVE	A10,A9			;A10=ROM TABLE TO CYCLE WITH
LOOP	MOVE	A8,A1
	MOVE	A9,A0			;A0=TABLE POSITION
	MOVE	*A13(PDATA),A2,W	;A2=COLOR COUNT
	CALLA	PALSET			;DO THE TRANSFER
	MOVE	A11,A0
	CALLA	PRCSLP
	ADDK	>10,A9
	MOVE	*A9,A0
	JRN	RESTUFF
	MOVE	*A13(PDATA+16),A1	;PDATA+16=ENTRY WE STOP AT
	CMP	A0,A1
	JRNE	LOOP
RESTUFF	MOVE	A10,A9			;REACHED END OF TABLE, RESTUFF
	JRUC	LOOP

**************************************************************************
* HEXTOASC - Converts a 32 bit hex # to a null terminated ascii string
* A8=#
*Rets:
* A8=*STRING
**************************************************************************
HEXTOASC
	PUSH	a1,a2,a9
	clr	a1
	move	a1,-*sp			;Push the null terminator
	movk	10,a1			;Divisor for decimal
	move	a8,a9
hexta1	movk	3,a2			;Comma count
hexta2	clr	a8
	divu	a1,a8
	addi	'0',a9			;Make the remainder ascii
	move	a9,-*sp			;Save here
	move	a8,a9
	jrz	hexta3			;Done?
	dsj	a2,hexta2
	movi	',',a2
	move	a2,-*sp			;Stuff a comma
	jruc	hexta1

hexta3	movi	STRNGRAM,a1		;Store here for blow out
	move	a1,a8
hexta4	move	*sp+,a9
	movb	a9,*a1
	addk	8,a1
	move	a9,a9
	jrnz	hexta4

	PULL	a1,a2,a9
	rets

**************************************************************************
*
* STRINGER - OUTPUT A TEXT STRING, THIS IS A PROCESS!
* A0  = SLEEP TIME BETWEEN CHARACTERS
* A4  = DMA CONTROL
* A6  = COLOR (16 BITS)
* A8  = PTR TO STRING
* A9  = [Y,X] SCREEN ADDRESS OF STRING
* A10 = [Y,X] SPACING
* A11 = POINTER TO FONT TABLE
* A14 = FLAGS:JUSTIFY
*	BIT 16 = 1 INSERT ON OBJECT LIST, 0 JUST QUEUE THE DMA
*	JUSTIFY = 0 LEFT JUSTIFY
*		  1 CENTER JUSTIFY
*		  2 RIGHT JUSTIFY
* WRLD = ADJUST FOR WORLD COORDINATES
* LOWZ+20000=ZPOS
*
* RETURNS:
* A8 = POINTS TO NEXT BYTE AFTER STRING TERMINATOR
* A9 = NEXT CURSOR POSITION AFTER THE STRING
* NOTE: CALL WITH JSRP
*
**************************************************************************

*STRING ENTRYPOINT, LEFT JUSTIFY, NORMAL, NOT PUT ON THE OBJECT LIST
STRLNRM
	mmtm	a12,a1,a2,a3,a4,a6,a14
	movi	DMACNZ,a4
	clr	a14
	jruc	stringr1

*STRING ENTRYPOINT, CENTER JUSTIFY, NORMAL, NOT ON THE OBJECT LIST
STRCNRM
	mmtm	a12,a1,a2,a3,a4,a6,a14
	movi	DMACNZ,a4
	movk	1,a14
	jruc	stringr1

*STRING ENTRYPOINT, RIGHT JUSTIFY, NORMAL, NOT PUT ON THE OBJECT LIST
STRRNRM
	mmtm	a12,a1,a2,a3,a4,a6,a14
	movi	DMACNZ,a4
	movk	2,a14
	jruc	stringr1

;*STRING ENTRYPOINT, LEFT JUSTIFY, INVERTED, NOT ON THE OBJECT LIST
;STRLINV
;	mmtm	a12,a1,a2,a3,a4,a6,a14
;	MOVI	DMACZ,A4
;	clr	a14
;	jruc	stringr1

;*STRING ENTRYPOINT, CENTER JUSTIFY, INVERTED, NOT ON THE OBJECT LIST
;STRCINV
;	mmtm	a12,a1,a2,a3,a4,a6,a14
;	MOVI	DMACZ,A4
;	movk	1,a14
;	jruc	stringr1
;

*STRING ENTRYPOINT, LEFT JUSTIFY, NORMAL, OBJECT LIST
STRLNRMO
	mmtm	a12,a1,a2,a3,a4,a6,a14
	movi	DMACNZ+M_NOCOLL,a4
	movi	>10000,a14
	jruc	stringr1

*STRING ENTRYPOINT, CENTER JUSTIFY, NORMAL, OBJECT LIST
STRCNRMO
	mmtm	a12,a1,a2,a3,a4,a6,a14
	movi	DMACNZ+M_NOCOLL,a4
	movi	>10001,a14
	jruc	stringr1

*STRING ENTRYPOINT, CENTER JUSTIFY, NORMAL, OBJECT LIST, MULTIPLE COLORS!
STRCNRMO_1
	mmtm	a12,a1,a2,a3,a4,a6,a14
	movi	DMAWNZ+M_NOCOLL,a4
	movi	>10001,a14
	move	a6,a5
	jruc	stringr1_1

STRINGER
	mmtm	a12,a1,a2,a3,a4,a6,a14
stringr1
	move	a6,a5
	sll	16,a5			;Setup constant color in fixed palette
stringr1_1

	clr	a7
	movx	a14,a7
	subk	1,a7
	jrn	strr10			;Normal left justify
	jrz	strrc

	callr	STRNGLEN		;Right justify
	jruc	strra

strrc	callr	STRNGLEN		;Center justify
	srl	1,a7			;STRNGLEN/2

strra	subxy	a7,a9			;Adjust string starting position
	jruc	strr10			;Start loop


strr1	addk	5,a9			;Add a space
strr5	addxy	a10,a9			;Add spacing

strr10	movb	*a8,a1			;Get a character
	jrle	strrx			;Done?
	addk	8,a8			;Next byte

	subk	32,a1
	jrle	strr1			;Space?

					;Save sleep time
strr20	PUSH	a0

	subk	1,a1			;>Calc table offset
	sll	5,a1			;*32
	add	a11,a1
	move	*a1,a1,L		;Get * image header

	PUSH	a1,a14
	
	btst	16,a14
	jrz	strrdma			;Only do DMA?

	calla	GETOBJ			;Create the character as an object
	jrz	strrdun			;No object?

	move	a1,*a0(OIMG),L
	move	a5,*a0(OPAL),L		;&CONST
	movi	CLSNEUT|TYPTEXT|SUBTXT,a14
	move	a14,*a0(OID)

	move	@LOWZ,a14
	addi	20000,a14
	move	a14,*a0(OZPOS)

	clr	a2
	move	a2,*a0(OXVEL),L
	move	a2,*a0(OYVEL),L
	movy	a9,a2			;Y
	move	a9,a3
	sll	16,a3			;X
	calla	GANISAG

	move	@WRLD,a2
	jrnz	strr100
	calla	ADJSTWTL		;Put us in the world

strr100	calla	INSOBJ
	jruc	strrdun


strrdma	calla	GSAGOF			;>Simple DMA
	calla	GANIOF
	move	a5,a1			;Constant:Palette
	move	a4,a5			;Offset:Control
	move	a3,a4			;SAG

	move	a9,a3			;A3=Y:X
	srl	16,a6
	movx	a6,a7
	subxy	a7,a3			;Sub anioffset

	calla	QDMAN
	move	a5,a4			;Fix A4
	move	a1,a5

strrdun	PULL	a1,a14

	move	*a1,a1			;Get ISIZEX
	addxy	a1,a9			;Add X size
	move	*sp+,a0,L
	jrz	strr5			;No sleep?

	mmtm	a12,a0,a4,a5,a14
	calla	PRCSLP
	mmfm	a12,a0,a4,a5,a14
	jruc	strr5

strrx	clr	a1
	move	a1,@LOWZ
	addk	8,a8			;Next byte
	mmfm	a12,a1,a2,a3,a4,a6,a14
	RETP


**************************************************************************
* STRNGLEN - RETURNS THE LENGTH, IN PIXELS, OF A GIVEN STRING
* A8 = PTR TO STRING
* A10 = [Y,X] SPACING OF STRING
* A11 = PTR TO FONT TABLE
* RETURNS:
* A7 = LENGTH OF STRING
* Z BIT SET IF LENGTH IS ZERO
**************************************************************************
STRNGLEN
	PUSH	a8,a14
	clr	a7		;A7=Length
	jruc	stl60

stl10	addk	8,a8		;Point to next
	subk	32,a14
	jrgt	stl20		;Good char?
	addk	5,a7		;Hard code a space
	jruc	stl40

stl20	subk	1,a14
	sll	5,a14		;*32
	add	a11,a14		;A14=*Correct character header
	move	*a14,a14,L
	move	*a14,a14	;Get ISIZEX

	addxy	a14,a7		;Add char length
stl40	addxy	a10,a7		;Add space length
stl60	movb	*a8,a14
	jrgt	stl10		;Next character?

	PULL	a8,a14
	zext	a7
	rets


**************************************************************************
*									 *
* OBJECT BLOCK INITIALIZATION ROUTINES					 *
*									 *
**************************************************************************
**************************************************************************
*									 *
* GPALOBJ - GET A PALETTE AND AN OBJECT BLOCK				 *
* A14 = PTR TO PLAYER INITIALIZATION TABLE.				 *
* RETURNS:								 *
* A0 = PTR TO OBJECT							 *
* Z BIT SET = FAILURE,A0 = 0						 *
*									 *
**************************************************************************
GPALOBJ
	CALLA	GETOBJ
	JRZ	GPALOBJX		;OBJECT BLOCK FAILURE
	CALLA	INITPAL			;GET THE PALETTE
;	JRNZ	GPALOBJX
;	CLR	A0
;	MOVE	A0,@CURPAL,W
;	CALLA	FREEOBJ
;	CLR	A0
GPALOBJX
	RETS
**************************************************************************
*									 *
* GBPALOBJ - GET A BACKGROUND PALETTE AND AN OBJECT BLOCK		 *
* A14 = PTR TO PLAYER INITIALIZATION TABLE.				 *
* RETURNS:								 *
* A0 = PTR TO OBJECT							 *
* Z BIT SET = FAILURE,A0 = 0						 *
*									 *
**************************************************************************
GBPALOBJ
	CALLA	GETOBJ
	JRZ	GBPALOX			;OBJECT BLOCK FAILURE
	CALLA	INITBPAL		;GET THE BACKGROUND PALETTE
	JRNZ	GBPALOX
	CALLA	FREEOBJ
	CLR	A0
GBPALOX	RETS


********************************
*SHVELCPY - COPY VELOCITIES TO SHADOW (IF ANY)
*A8=OBJECT

;SHVELCPY:
;	MMTM	SP,A0,A1
;	MOVE	*A8(OSHAD),A0,L
;	JREQ	SHVLCPX
;	MOVE	*A8(OXVEL),*A0(OXVEL),L
;**	MOVE	*A8(OZVEL),A1,L
;	MOVE	*A8(OYVEL),A1,L
;**	MOVE	A1,*A0(OZVEL),L
;	MOVE	A1,*A0(OYVEL),L
;SHVLCPX:
;	MMFM	SP,A0,A1
;	RETS


********************************
*SHVELFLP - COPY SHADOW VELOCITY AND FLIP HIM
*A8=OBJECT
*A3=OXVEL
;SHVELFLP:
;	CALLR	SHVELCPY
;	MOVE	*A8(OXVEL+>10),A14,W		;TEST X VELOCITY
*FLIPDUDE
*A8=OBJECT, N=SIGN OF XVEL
FLP	jrn	YFLP
	jruc	NOYFLP

**************************************************************************
*									 *
* OBJOFF - TURN AN OBJECT "OFF" I.E. SET DMA OUTPUT TO 0		 *
* A0 = PTR TO OBJECT BLOCK						 *
*									 *
**************************************************************************
OBJOFF
	PUSH	A4
	MOVE	*A0(OFLAGS),A4,W
	SRL	4,A4
	SLL	4,A4
	MOVE	A4,*A0(OFLAGS),W
	move	*sp+,a4,L
	RETS

**************************************************************************
*									 *
* OBJON - TURN AN OBJECT "ON" I.E. SET DMA OUTPUT TO WRITE <> 0		 *
* A0 = PTR TO OBJECT BLOCK						 *
*									 *
**************************************************************************
OBJON
	PUSH	A4
	MOVE	*A0(OFLAGS),A4,W
	SRL	4,A4
	SLL	4,A4
	ADDK	2,A4
	MOVE	A4,*A0(OFLAGS),W
	move	*sp+,a4,L
	RETS

**************************************************************************
*									 *
* Z POSITIONING ROUTINES						 *
*									 *
**************************************************************************


*XZCHK
*CALLING PARAMETERS:
*A8=OBJECT SEEKING
*A0=OBJECT SEEKED
*A5=X RANGE
*A6=Z RANGE
*RETURNS:
*CARRY SET IF HE IS CLOSE ENOUGH
*A1=DELTA X
*A2=DELTA Z
*A3=ABS DELTA X
*A4=ABS	DELTA Z
;XZCHK:
;	MOVE	A0,A4
;	CALLR	GETANIX			;GET X ANIMATION POINT
;	MOVE	A0,A3
;	SWAP	A4,A8
;	CALLR	GETANIX
;	MOVE	A0,A1
;	MOVE	A8,A0
;	MOVE	A4,A8
;	MOVE	*A8(OZPOS),A4,W	
;	MOVE	*A0(OZPOS),A2,W
;	SUB	A4,A2
;	SUB	A3,A1
;	MOVE	A1,A3
;	MOVE	A2,A4
;	ABS	A3
;	ABS	A4
;	CMP	A5,A3
;	JRNC	XZCHKX
;	CMP	A6,A4
;XZCHKX:
;	RETS
	
**************************************************************************
*									 *
* CLRPDATA - CLEAR THE PDATA AREA OF A PROCESS BLOCK			 *
* A13 = PTR TO PROCESS BLOCK						 *
*									 *
**************************************************************************
;CLRPDATA
;	MMTM	SP,A1,A6,A14
;	MOVE	A13,A14
;	CLR	A1
;	ADDI	PDATA,A14
;	MOVI	(PSDATA-PDATA)/16,A6
;CLRSHL
;	SRL	1,A6
;	JRNC	CLRPDL
;	MOVE	A1,*A14+,W	;STUFF THE ODD WORD	
;CLRPDL
;	MOVE	A1,*A14+,L		
;	DSJS	A6,CLRPDL
;	MMFM	SP,A1,A6,A14
;	RETS
**************************************************************************
*									 *
* DFRMGRND - RETURNS THE DISTANCE FROM THE BOTTOM OF			 *
*		   AN OBJECT TO THE "GROUND."				 *
* A8 = OBJECT BLOCK							 *
* RETURN(S)								 *
* A1 = DISTANCE FROM GROUND (16 BITS)					 *
* STATUS BITS SET ACCORDING TO THE SIGN OF A1				 *
* NOTE: MAX ACCEPTABLE Y = +32K, MIN ACCEPTABLE Y = -32K		 *
*									 *
**************************************************************************
;ZORIGIN	EQU	200		;Y COORDINATE OF THE Z ORIGIN
;DFRMGRND
;	PUSH	A2
;	MOVE	*A8(OYPOS),A1,W
;	MOVE	*A8(OSIZEY),A2,W
;	ADD	A1,A2			;A2 = BOTTOM Y
;	MOVE	*A8(OZPOS),A1,W
;	SUB	A2,A1
;	ADDI	ZORIGIN,A1
;	MMFM	SP,A2
;	RETS

**************************************************************************
*									 *
* GET BOTTOM Y OF AN OBJECT						 *
* A8 = OBJECT BLOCK PTR							 *
* RETURN(S)								 *
* A1 = 16 BIT BOTTOM Y IN LSW						 *
* STATUS SET ACCORDING TO THE BOTTOM Y					 *
*NOTE: MAKE SURE OBLOCK IS INIT'D WITH GSAGOF BEFORE CALLING		 *
*									 *
**************************************************************************
;GETBOTY
;	PUSH	A2
;	MOVE	*A8(OYPOS),A1,W		;GET Y POSITION
;	MOVE	*A8(OSIZEY),A2,W	;GET THE CURRENT SIZE
;	ADD	A2,A1			;A1 = BOTTOM Y
;	MMFM	SP,A2
;	RETS

**************************************************************************
*									 *
* GETCPNT - RETURNS THE CENTER XY POSITION OF A GIVEN IMAGE		 *
* A8 = IMAGE OBLOCK							 *
* RETURN(S)								 *
* A1 = CENTER Y:CENTER X						 *
*									 *
**************************************************************************
GETCPNT	MOVE	A0,-*SP,L
	MOVE	*A8(OYPOS),A0,W
	SLL	16,A0
	MOVE	*A8(OXPOS),A1,W
	MOVX	A1,A0
	MOVE	*A8(OSIZE),A1,L
	CALLR	GETCENT
	SLL	16,A0
	MOVY	A0,A1
	MOVE	*SP+,A0,L
	RETS

**************************************************************************
*									 *
* GETCENT - RETURNS THE CENTER POINT OF A BOX				 *
* A0 = UPPER LEFT Y:UPPER LEFT X					 *
* A1 = Y_SIZE:X_SIZE							 *
* RETURN(S)								 *
* A0 = CENTER Y(LSW)							 *
* A1 = CENTER X(LSW)							 *
*									 *
**************************************************************************
GETCENT	MOVE	A2,-*SP,L
	MOVY	A1,A2
	SRL	17,A2		;YSIZE/2
	SLL	16,A2		;BACK TO Y HALF
	SLL	16,A1		;CLEAR Y
	SRL	17,A1		;XSIZE/2
	MOVY	A2,A1
	ADDXY	A1,A0		;OFFSET TO CENTER
	CLR	A1
	MOVX	A0,A1		;RETURN THESE IN USEFUL POSITIONS
	SRL	16,A0
	MOVE	*SP+,A2,L
	RETS

**************************************************************************
*									 *
* GETSCRRX - THE THE WORLD X COORDINATE OF THE SCREEN RIGHT END		 *
* RETURNS								 *
* A0 = SCREEN RIGHT X, 32 BITS						 *
*									 *
**************************************************************************
;GETSCRRX
;	PUSH	A2
;	MOVE	@SCRNLR,A0,W
;	MOVE	@WORLDTL,A2,W
;	ADD	A2,A0			;GET SCREEN LOWER RT.
;	SLL	16,A0
;	PULL	A2
;	RETS


********************************
*GETANIX - GET ANIMATION POINT X COORD
*CALLING PARMS: A8=OBJECT
*RETURNS A0=16 BIT WORLD COORD OF UPPER LEFT

GETANIX
	MMTM	SP,A1,A2
	MOVE	*A8(OIMG),A1,L
	MOVE	*A1(IANIOFF),A2
	MOVE	*A8(OFLAGS),A0
	BTST	B_FLIPH,A0
	JRZ	GETAX1
	MOVE	*A1,A0		;ISIZEX
	SUB	A2,A0
	DEC	A0
	MOVE	A0,A2
GETAX1	MOVE	*A8(OXPOS),A0
	ADD	A2,A0
	MMFM	SP,A1,A2
	RETS

**************************************************************************
*									 *
* CLRWORLD - CLEAR ALL WORLD COORDINATES AND SCROLL VELOCITIES.		 *
*									 *
**************************************************************************
CLRWORLD
	PUSH	A0
	CLR	A0
	MOVE	A0,@SCROLLX,L		;X SCROLL VALUE
	MOVE	A0,@SCROLLY,L		;Y SCROLL VALUE
	MOVE	A0,@WORLDTLX,L		;TOP LEFT X SCREEN COORD (WORLD)
	MOVE	A0,@WORLDTLY,L		;TOP LEFT Y SCREEN COORD (WORLD)
	MOVE	A0,@WORLDTL,L
;	MOVE	A0,@BAK2TLY,L		;TOP LFT Y SLOW SCROLL BACKGROUND
;	MOVE	A0,@BAK2TLX,L		;TOP LFT X SLOW SCROLL BACKGROUND
	MOVI	SCRNST,A0
	MOVE	A0,@SCRNTL,L
	MOVI	SCRNEND,A0
	MOVE	A0,@SCRNLR,L
	move	*sp+,a0,L
	RETS

**************************************************************************
*									 *
* GETSCRBY - THE THE WORLD Y COORDINATE OF THE SCREEN BOTTOM		 *
* RETURNS								 *
* A0 = SCREEN BOTTOM Y							 *
*									 *
**************************************************************************
;GETSCRBY
;	PUSH	A2
;	MOVE	@SCRNLR+16,A0,W
;	MOVE	@WORLDTL+16,A2,W
;	ADD	A2,A0			;GET SCREEN BOTTOM Y
;	SLL	16,A0			;MAKE IT A 32 BIT VALUE
;	PULL	A2
;	RETS

**************************************************************************
*									 *
* MYOINIT - INITIALIZE SUPPLEMENTAL OBJECT LIST HEADERS			 *
*									 *
**************************************************************************
MYOINIT
	MMTM	SP,A0,A1,A2,A3,A4,A5
	PUSHST

	DINT
	MOVE	@INTENB,A0,W
	ANDNI	X1E,A0			;NO MORE DMA INTERRUPTS
	MOVE	A0,@INTENB,W
	POPST
	CLR	A0
	MOVE	A0,@GAMERASE
	CALLA	AUTOEOFF		;DISABLE AUTOERASE
	CALLR	DMAWAIT			;WAIT ON DMA
	MOVI	ERASECOL,A1
	SLL	16,A1			;CONSTANT:PALETTE
	MOVI	[2,511],A2		;HEIGHT:WIDTH
	MOVI	[510,0],A3		;DAG
	MOVI	2000000H,A4		;SAG
	MOVI	DMAREGS,A0
	MMTM	A0,A1,A2,A3,A4		;STORE TO LAST 2 LINES OF BITMAP
	CLR	A5			;STUFF OFFSET
	MOVE	A5,-*A0,W
	MOVI	DMACAL,A5		;CONTROL &
	MOVE	A5,-*A0,W		;GO!
	MMFM	SP,A0,A1,A2,A3,A4,A5
	JAUC	OINIT
*************************************************************************
*									 *
* ADDSUPP - ADD OBJECT TO A SUPPLEMENTAL LIST				 *
* A0 = PTR TO OBJECT							 *
* A1 = MEMORY LOCATION OF SUPPLEMENTAL LIST HEADER			 *
*									 *
**************************************************************************
;ADDSUPP	
;	MOVE	*A1(0),*A0(OSLINK),L	;LINK SLIST TO THIS BLOCK
;	MOVE	A0,*A1,L		;NEW HEAD OF THE SLIST
;	RETS

**************************************************************************
*									 *
* DELSBOBJ - DELETE OBJECT FROM SUPPLEMENTAL BACKGROUND LIST		 *
* A0 = PTR TO OBJECT							 *
*									 *
**************************************************************************
;DELSBOBJ
;	PUSH	A1
;	MOVI	BACKSLST,A1
;	CALLR	DELSUPP
;	PULL	A1
;	RETS

**************************************************************************
*									 *
* DELSUPP - DELETE OBJECT FROM THE SUPPLEMENTAL LIST			 *
* A0 = PTR TO OBJECT							 *
* A1 = MEMORY LOCATION OF SUPPLEMENTAL LIST HEADER			 *
*									 *
**************************************************************************
;DELSUPP
;	MMTM	SP,A1,A2
;	MOVE	A1,A2
;	MOVE	*A1,A1,L	;SPECIAL CASE THE HEADER
;	JRNZ	DELSCHK1
;	LOCKUP
;	JRUC	DELSX
;DELSCHK1
;	CMP	A1,A0
;	JRNE	DELSLUP
;	MOVE	*A1(OSLINK),*A2(0),L	;LINK AROUND THIS GUY	
;DELSX
;	MMFM	SP,A1,A2
;	RETS
		    ;
;DELSLUP		    ;
;	MOVE	A1,A2		;SAVE PREVIOUS
;	MOVE	*A1(OSLINK),A1,L	;SEARCHING FOR THE ELEMENT IN THE LIST
;	JRNZ	DELSCHK2
;	LOCKUP
;	JRUC	DELSX
;DELSCHK2
;	CMP	A1,A0
;	JRNE	DELSLUP		;NOT FOUND KEEP LOOKING
;
;	MOVE	*A1(OSLINK),*A2(OSLINK),L	;LINK AROUND THIS GUY	
;
;	MMFM	SP,A1,A2
;	RETS

**************************************************************************
*									 *
* ISSUPP - IS AN OBJECT ON A SUPPLEMENTAL LIST				 *
* A0 = PTR TO OBJECT							 *
* A1 = MEMORY LOCATION OF SUPPLEMENTAL LIST HEADER			 *
* RETURNS:								 *
*  Z BIT SET = NOT ON							 *
*  Z BIT CLR = IS ON							 *
*									 *
**************************************************************************
;ISSUPP
;	PUSH	A1
;	MOVE	*A1,A1,L	;SPECIAL CASE THE HEADER
;	JREQ	ISEND
;	CMP	A1,A0
;	JRNE	ISSEARCH
;ISFOUND
;	MOVE	A1,A1		;SET Z BIT
;ISEND
;	mmfm	sp,a1
;	RETS
;ISSEARCH
;	MOVE	*A1(OSLINK),A1,L	;SEARCHING FOR THE ELEMENT IN THE LIST
;	JREQ	ISEND			;ELEMENT DOES NOT EXIST
;	CMP	A1,A0
;	JRNE	ISSEARCH		;NOT FOUND KEEP LOOKING
;	JRUC	ISFOUND			;FOUND RETURN
;
**************************************************************************
*									 *
* ISSUPPID - IS AN OBJECT ON A SUPPLEMENTAL LIST(SEARCH BY OBJECT I.D.)	 *
* A0 = OBJECT I.D.							 *
* A1 = MEMORY LOCATION OF SUPPLEMENTAL LIST HEADER			 *
* RETURNS:								 *
*  Z BIT SET = NOT ON							 *
*	       A1 = ZERO						 *
*  Z BIT CLR = IS ON							 *
*	       A1 = PTR TO OBJECT					 *	
*									 *
**************************************************************************
;ISSUPPID
;	PUSH	A2	
;	MOVE	*A1,A1,L	;SPECIAL CASE THE HEADER
;	JREQ	ISENDID
;	MOVE	*A1(OID),A2,W
;	CMP	A2,A0
;	JRNE	ISSRCHID
;ISFNDID
;	MOVE	A1,A1		;SET Z BIT
;ISENDID
;	mmfm	sp,a2
;	RETS
;ISSRCHID
;	MOVE	*A1(OSLINK),A1,L	;SEARCHING FOR THE ELEMENT IN THE LIST
;	JREQ	ISENDID			;ELEMENT DOES NOT EXIST
;	MOVE	*A1(OID),A2,W
;	CMP	A2,A0
;	JRNE	ISSRCHID		;NOT FOUND KEEP LOOKING
;	JRUC	ISFNDID			;FOUND RETURN

**************************************************************************
*									 *
* CNTSUPP - COUNT THE NUMBER OF OBJECTS ON GIVEN SUPPLEMENTAL LIST.	 *
* A1 = SUPPLEMENTAL LIST						 *
* RETURNS:								 *
* A0 = OBJECT CNT							 *
*									 *
**************************************************************************
;CNTSUPP
;	PUSH	A1
;	CLR	A0
;	MOVE	*A1,A1,L
;	JRZ	CNTSUPPX	
;CNTSUPPL
;	INC	A0
;	CMPI	NOBJ,A0
;	JRHS	CNTSUPPX		;WE'VE MAXED, SOMETHING IS WRONG
;	MOVE	*A1(OSLINK),A1,L
;	JRNZ	CNTSUPPL
;CNTSUPPX	
;	PULL	A1
;	RETS

**************************************************************************
*									 *
* RANDOM - GENERATE A RANDOM NUMBER					 *
* RETURNS:								 *
* A0 = 32 BIT RANDOM #							 *
*									 *
**************************************************************************
RANDOM	PUSH	A1
	MOVE	@RAND,A0,L
	SLA	1,A0
	JRV	RND2
	movk	2,a1
	or	a1,a0
RND2	MOVE	A0,@RAND,L
	CLR	A1
	ADDC	A1,A0		;GET LAST BIT BACK TO MAKE 32
	MOVE	@HCOUNT,A1
	RL	A1,A0		;RANDOM ROTATION
	move	*sp+,a1,L
	MOVE	A0,A0		;SET STATUS BITS
	RETS

**************************************************************************
*									 *
* RANDU - GENERATE A UNIFORMLY DISTRIBUTED RANDOM # BETWEEN 1 AND [A0]	 *
* A0 = RANGE INPUT							 *
* RETURNS:								 *
* A0 = RANDOM #								 *
*									 *
**************************************************************************
RANDU	PUSH	A1
	MOVE	A0,A1
	CALLR	RANDOM
	MPYU	A1,A0
	move	*sp+,a1,L
	addk	1,a0
	rets

********************************
* GET SIGNED RANDOM # IN RANGE +/- A0
* CALLING PARAMETERS: A0
* RETURNS A0

SRAND
	PUSH	A1
	MOVE	A0,A1
	SLL	1,A0
	callr	RANDU
	SUB	A1,A0
	MMFM	SP,A1
	RETS

**************************************************************************
*									 *
* RANGRAND - GENERATE A RANDOM NUMBER IN A GIVEN RANGE.			 *
* B0 = LOWER BOUND (BUG: will never return this #)			 *
* B1 = UPPER BOUND							 *
* RETURNS								 *
* A0 = RANDOM #								 *
*									 *
**************************************************************************
RANGRAND
	PUSH	a1
	move	b0,a0
	move	b1,a1		;Set range for randu
	sub	a0,a1		;Normalize the range
	callr	RANDOM		;>Randu
	mpyu	a1,a0
	move	b0,a1
	add	a1,a0
	move	*sp+,a1,L
	addk	1,a0
	rets			;Pass CC

**************************************************************************
* RNDRNG - Quickly produce a random # in a given range
* A0 = Lower bound
* A1 = Upper bound
*
* Preserves Regs 2-13
*
* >A0 = RANDOM # (A0 to A1)
**************************************************************************
RNDRNG
	sub	a0,a1		;Normalize the range
	addk	1,a1
	move	a0,b0

	move	@RAND,a0,L
	rl	a0,a0
	move	@HCOUNT,a14
	rl	a14,a0
	add	sp,a0
	move	a0,@RAND,L

	mpyu	a1,a0
	move	b0,a1
	add	a1,a0
	rets			;Pass CC

**************************************************************************
* RNDRNG0 - Quickly produce a random # in range 0-X
* A0 = X
*
* Preserves Regs 2-13
*
* >A0 = RANDOM # (0 to A0)
**************************************************************************
RNDRNG0
	addk	1,a0

	move	@RAND,a1,L
	rl	a1,a1
	move	@HCOUNT,a14
	rl	a14,a1
	add	sp,a1
	move	a1,@RAND,L

	mpyu	a1,a0		;Condition codes not valid!
	rets

********************************
* RANDPER - RANDOM % ROUTINE
* CALLING PARAMETERS:
* A0=PROBABILITY OF EVENT (0-1000) P(A0=1000) = 1; P(A0=1) = 1/1000.
* RETURNS CS IF PROBABILITY IS TRUE, CC FOR FALSE
* RETURNS A0 = ACTUAL RANDOM # 0-999
RANDPER
	MMTM	SP,A1,A2
	MOVE	A0,A2
	callr	RANDOM
	MOVI	1000,A1
	MPYU	A1,A0
	CMP	A2,A0
	MMFM	SP,A1,A2
	RETS		

**************************************************************************
*									 *
* FILLAREA - FILL A GIVEN SQUARE AREA ON THE SCREEN WITH A COLOR	 *
* A1 = [COLOR,PALETTE]							 *
* A3 = DAG OF AREA [YPOS,XPOS]						 *
* A4 = [Y,X] SIZE OF AREA						 *
*									 *
**************************************************************************
FILLAREA
	MMTM	SP,A1,A2,A4,A5
	JRUC	AREACON
**************************************************************************
*									 *
* BLNKAREA - BLANK A GIVEN SQUARE AREA ON THE SCREEN			 *
* A3 = DAG OF AREA [YPOS,XPOS]						 *
* A4 = [Y,X] SIZE OF AREA						 *
*									 *
**************************************************************************
BLNKAREA
	MMTM	SP,A1,A2,A4,A5
	CLR	A1			;CONSTANT 0:PALETTE 0
AREACON
	MOVE	A4,A2
	MOVI	2000000H,A4		;SOMEWHERE IN IMAGE ROM
	MOVI	DMACAL,A5
	CALLR	DMAN
	MMFM	SP,A1,A2,A4,A5
	RETS

**************************************************************************
*									 *
* PFRAME - GET NEXT FRAME FROM ANIMATION LIST				 *
* A8 = POINTER TO OBJECT BLOCK						 *
* A11 = POINTER TO NEXT FRAME IN THE ANIMATION LIST			 *
* RETURN(S)								 *
* A5 = TICKS FOR THIS FRAME						 *
* C BIT SET(JXC)  = END OF LIST WAS HIT					 *
* N BIT SET(JXN)  = SPECIAL FRAME ENCOUNTERED				 *
*									 *
**************************************************************************
;PFRAME	MMTM	SP,A1,A4
;	MOVE	*A11+,A1,L		;LOAD NEXT FRAME
;	JRNE	PFRAME1			;NOT THE END OF THE LIST
;
;	SETC				;SET CARRY FLAG
;	JRUC	PFRAMEX
;
;PFRAME1
;	MOVE	*A8(OFLAGS),A4,W
;	CALLA	ANI			;SETUP NEW FRAME
;PFRAME2
;	MOVE	*A11+,A5,W		;LOAD SLEEP TICKS PER FRAME
;	CLRC	
;
;PFRAMEX	MMFM	SP,A1,A4
;	RETS

**************************************************************************
*									 *
* OBJECT VELOCITY STOP ROUTINES						 *
*									 *
**************************************************************************

********************************
*PSTOP - STOP AN OBJECT
*A8=OBJECT BLOCK PTR
PSTOP	CALLR	PSTOPX
	JRUC	PSTOPY

********************************
*PSTOPX - CLEAR AN OBJECTS X VELOCITY
*A8=OBJECT BLOCK PTR
PSTOPX	MMTM	SP,A0,A1	
	CLR	A1
	MOVE	A1,*A8(OXVEL),L
;	MOVE	*A8(OSHAD),A0,L
;	JREQ	PSTOPXX
;	MOVE	A1,*A0(OXVEL),L		;STOP THE SHADOW
;PSTOPXX
	MMFM	SP,A0,A1
	RETS

********************************
*PSTOPY - CLEAR AN OBJECTS Y VELOCITY
*A8=OBJECT BLOCK PTR
PSTOPY	MMTM	SP,A0,A1	
	CLR	A1
	MOVE	A1,*A8(OYVEL),L
;	MOVE	*A8(OSHAD),A0,L
;	JREQ	PSTOPYX
;	MOVE	A1,*A0(OYVEL),L		;STOP THE SHADOW
;PSTOPYX
	MMFM	SP,A0,A1
	RETS


********************************
*YFLP - SET OBJECT Y-FLIP
*A8=OBJECT BLOCK PTR
YFLP	MMTM	SP,A1,A4
	MOVE	*A8(OFLAGS),A4
	ORI	M_FLIPH,A4
	JRUC	STUFLAGS

********************************
*NOYFLP - CLEAR OBJECT Y-FLIP
*A8=OBJECT BLOCK PTR	
NOYFLP	MMTM	SP,A1,A4
	MOVE	*A8(OFLAGS),A4
	ANDNI	M_FLIPH,A4
STUFLAGS
	MOVE	*A8(OIMG),A1,L		;GET THE CURRENT IMAGE POINTER
	CALLA	ANI			;SETUP THE "NEW" IMAGE
UNFLPD	MMFM	SP,A1,A4
	RETS

**************************************************************************
*									 *
* SYNCUP - SYNCHRONIZE WITH THE NEXT DISPLAY INTERRUPT, I.E.		 *
*	 WAIT UNTIL THE NEXT INTERRUPT IS FINISHED BEFORE RETURNING	 *
*									 *
**************************************************************************
SYNCUP
	CLR	A0
	MOVE	A0,@INTSYNC0,L	;CLEAR HALF SCREEN SYNC

SYNCUP1	MOVE	@INTSYNC0,A0,L
	JREQ	SYNCUP1		;END HASN'T HIT YET
	RETS

**************************************************************************
*									 *
* SYNCHALF - SYNCHRONIZE WITH THE HALF SCREEN INTERRUPT			 *
*									 *
**************************************************************************
SYNCHALF
	PUSH	a1
	MOVI	INTSYNC0,A1
	JRUC	SYNCSD
**************************************************************************
*									 *
* SYNCFULL - SYNCHRONIZE WITH THE FULL SCREEN INTERRUPT			 *
*									 *
**************************************************************************
SYNCFULL
	PUSH	a1
	MOVI	INTSYNC1,A1

SYNCSD	CLR	A0
	MOVE	A0,*A1		;CLEAR HALF SCREEN SYNC

SYNCSD1	MOVE	*A1,A0
	JRZ	SYNCSD1		;END HASN'T HIT YET
	PULL	a1
	RETS

**************************************************************************
*									 *
* DTIME - USED TO DMA AN IMAGE						 *
* A1 = [CONSTANT COLOR,PALETTE(STUFFED IN DTIME)]			 *
* A3 = DAG [Y,X]							 *
* A5 = [OFFSET,CONTROL]							 *
* A14 = ADDRESS OF IMAGE HEADER						 *
*									 *
**************************************************************************
;DTIME
;	MMTM	SP,A0,A1
;	MOVE	*A14(ICMAP),A0,L	;GET THE PALETTE
;	CALLA	FINDPAL			;GET THE CORRECT COLOR MAP #
;	JRNZ	DTIME1			;BR = PALETTE WAS FOUND
;	CLR	A0			;DEFAULT TO FIXED PALETTE
;DTIME1
;	MOVX	A0,A1
;	CALLA	QDMA			;QUEUE THIS SUCKAH
;	move	*sp+,a1,L
;	move	*sp+,a0,L
;	RETS

**************************************************************************
*									 *
* DMAN - MANUAL DMA, ALL REGS MUST BE SETUP UPON CALLING		 *
*									 *
**************************************************************************
DMAN	JAUC	QDMAN
**************************************************************************
*									 *
* DMAWAIT - WAIT ON THE DMA BUSY BIT TO CLEAR				 *
*									 *
**************************************************************************
DMAWAIT	
	PUSH	A0
DMAWAITL
	MOVE	@DMACTRL,A0,W	;DMA BUSY?
	JRN	DMAWAITL	;BR = YES
	move	*sp+,a0,L
	RETS

**************************************************************************
*									 *
* DMAQWAIT - WAIT FOR DMA QUEUES TO EMPTY, THEN WAIT FOR DMA TO FINISH	 *
*	   THE LAST ONE. TURN DISPLAYON OFF.						 *
*									 *
**************************************************************************
DMAQWAIT
	MMTM	SP,A0,A1
	MOVE	@DISPLAYON,A1
	CLR	A0
	MOVE	A0,@DISPLAYON,W		;MAKE SURE DISPLAY IS OFF
DMAQWT1
	MOVE	@TOPQ0CNT,A0,W	
	JRNE	DMAQWT1
	MOVE	@TOPQ1CNT,A0,W	
	JRNE	DMAQWT1
	MOVE	@BOTQ0CNT,A0,W	
	JRNE	DMAQWT1
	MOVE	@BOTQ1CNT,A0,W	
	JRNE	DMAQWT1
DMAQWT2
	MOVE	B13,B13
	JRNZ	DMAQWT2
	CALLR	DMAWAIT
	MOVE	A1,@DISPLAYON
	MMFM	SP,A0,A1
	RETS

**************************************************************************
;* DMAQWAIT - WAIT FOR DMA QUEUES TO EMPTY, THEN WAIT FOR DMA TO FINISH	 *
;*	   THE LAST ONE.						 *
;DMAQWAIT
;	mmtm	SP,A0,A1
;	movi	25000,A1
;DMAQWT1
;	dsjs	A1,QWTX
;	MOVE	@TOPQ0CNT,A0,W	
;	JRNE	DMAQWT1
;	MOVE	@TOPQ1CNT,A0,W	
;	JRNE	DMAQWT1
;	MOVE	@BOTQ0CNT,A0,W	
;	JRNE	DMAQWT1
;	MOVE	@BOTQ1CNT,A0,W	
;	JRNE	DMAQWT1
;	mmfm	SP,A0,A1
;DMAQWT2
;	MOVE	B13,B13
;	JRZ	DMAWAIT
;	JRUC	DMAQWT2
;QWTX:
;	mmfm	SP,A0,A1
;	clr	B13
;	rets
**************************************************************************


**************************************************************************
* DMAHALT - HALT THE DMA
DMAHALT
	PUSH	A0
	CLR	A0
	MOVE	A0,@DMACTRL		;HALT THE DMA
	move	*sp+,a0,L
	RETS

**************************************************************************
*CMAPRS - RESET THE COLOR MAP SELECT

CMAPRS	CLR	A0

*CMAPSL - SELECT THE COLOR MAP(0-15 IN A0)
CMAPSL	MOVE	A1,-*SP,L
	CALLA	DMAWAIT
	MOVE	A0,@CMAPSEL
	MOVE	*SP+,A1,L
	RETS

**************************************************************************
*									 *
* CRINIT - COLOR RAM INITIALIZATION, FIRST CLEAR ALL COLOR RAM, THEN	 *
*	 FILL WITH PALETTES.						 *
*									 *
**************************************************************************
CRINIT
	MMTM	SP,A0,A1,A2,A6
	MOVI	COLRAM,A1
	CLR	A0
	MOVI	10000H,A6,L
*CLEAR ALL COLOR PALETTES
CRINIT1
	MOVE	A0,*A1+,L	;STUFF TWO WORDS AT A TIME
	DSJS	A6,CRINIT1

	MMFM	SP,A0,A1,A2,A6 ;<----
	RETS		       ;<----

**************************************************************************
*									 *
* CRLOAD - LOAD COLOR RAM FROM A ROM TABLE				 *
* A1 = START OF ROM TABLE						 *
* A2 = COLOR RAM START ADDRESS						 *
* A6 = PALETTE COUNT							 *
*									 *
**************************************************************************
CRLOAD
	MMTM	SP,A0,A1,A2
CRLOAD1
	MOVE	*A1+,A0,W	;GRAB FIRST COLOR FROM THIS TABLE
	JRN	CRLOAD4		;BR = NULL PALETTE
CRLOAD3
	MOVE	A0,*A2,W	;STUFF COLOR
	MOVE	*A1+,A0,W	;GRAB NEXT COLOR FROM THIS TABLE
	JRN	CRLOAD4		;BR = NEXT PALETTE
	ADDK	16,A2		;INC THIS WAY SO WE DON'T OVERRUN PALETTES
	JRUC	CRLOAD3

CRLOAD4
	ADDI	1000H,A2	;NEXT PALETTE
	SRL	12,A2
	SLL	12,A2		;MASK OFF LOW BULLSHIT
	DSJ	A6,CRLOAD1

	MMFM	SP,A0,A1,A2
	RETS


********************************
*SCRCLR - CLEAR THE SCREEN
*ONLY CALL WITH INTERRUPTS DISABLED AND THE DMA SHUT DOWN, OTHERWISE
*USE CLR_SCRN

SCRCLR	CLR	A0

*SCRFIL - FILL SCREEN WITH A0
SCRFIL
	MMTM	SP,A1,A2
	CLR	A1
	MOVE	A1,@CMAPSEL,W			;SELECT COLOR MAP 0
	MOVI	SCREEN,A1,L
	MOVI	(SCRNE-SCREEN)/32,A2,L
SCRLP	MOVE	A0,*A1+,L
	DSJS	A2,SCRLP
	MMFM	SP,A1,A2
	RETS


********************************
*LAST2CLR - CLEAR LAST TWO LINES OF BIT MAP(I.E. SET AUTO ERASE COLOR)
LAST2CLR
	CLR	A0

*LAST2FIL - FILL LAST TWO LINES OF BIT MAP
*A0 = FILL COLOR
LAST2FIL
	MOVE	A0,@ERASELOC,W			;STUFF DA COLOR
	RETS

**************************************************************************
*									 *
* SETPPROC - SETUP TI'S PIXEL PROCESSING REGISTER'S (BFILE), TO MATCH	 *
*	   THE ZUNIT SYSTEM.						 *
* NOTE:	   IF YOU WANT TO DO ANY SPECIAL TRICKS, DON'T USE THIS. 	 *
*									 *
**************************************************************************
SETPPROC
	PUSH	A0
	MOVI	OFFSETVAL,B4	;SET UP OFFSET REGISTER
	MOVI	0,B8			;SET BACKGROUND COLOR
	MOVI	SCRN_PTCH,A0		;GET SCREEN PITCH
	MOVE	A0,B1
	MOVE	A0,B3
	LMO	A0,A0			;CONVERT IN TEMPORARY REGISTER
	MOVE	A0,@CONVSP		;MOVE TO CONVSP IO REGISTER
	MOVE	A0,@CONVDP		;MOVE TO CONVDP IO REGISTER
	move	*sp+,a0,L
	RETS


************  CLEAR SCREEN ROUTINE  *********************
CLR_SCRN
	CLR	A0
	MMTM	SP,A1,A2,A3
	MOVE	@DISPLAYON,A3
;	CLR	A1
;	MOVE	A1,@DISPLAYON
	CALLR	DMAQWAIT			;WAIT ON DMA
	CLR	A1
	MOVE	A1,@CMAPSEL			;SELECT COLOR MAP 0
	MOVI	SCREEN,A1,L
	MOVI	((SCRNE-2000H)-SCREEN)/32,A2,L
CLRLP	MOVE	A0,*A1+,L
	DSJS	A2,CLRLP
	MOVE	A3,@DISPLAYON
	MMFM	SP,A1,A2,A3
	RETS

;*COLLISION VECTOR LISTS
;DUMCOLL	.WORD	0
;	.LONG	DUMRTSG

;DUMRTSG
;	CLR	A0			;DON'T STOP SCAN
;	CLRC				;AND DON'T DELETE
;	RETS	

**************************************************************************
* FRANIM - ANIMATION SCRIPT PROCESSOR					 *
* A1 = COMMAND:	00 = PROCESS CURRENT FRAME.				 *
*		01 = PROCESS TO END OF LIST.				 *
*		04 = PROCESS CURRENT FRAME, NO SLEEP(TIME RETRN'D IN A0) *
* A8 = PTR TO OBJECT BLOCK						 *
* A9 = PTR TO CURRENT FRAME						 *
* RETURN(S)								 *
* CARRY SET IF END OF ANIMATION LIST WAS HIT				 *
* A9 = POINTING TO NEXT FRAME, IF NOT AT END OF LIST			 *
* NOTE: CALL WITH JSRP, IT SLEEPS					 *
*									 *
* ANIMATION SCRIPT FORMAT						 *
*	.LONG	IMAGE_HEADER<-- IF = 0 END OF SCRIPT			 *
*	.WORD	SLEEP_TIME  <-- BITS 0 - 7 ARE THE SLEEP TIME.		 *
*			    <-- BITS 8 -15 ARE THE FLAGS:		 *
*				 BIT #		FLAG			 *
*				 -----		----			 *
*				   8	       UNUSED			 *
*				   9	       UNUSED			 *
*				  10	       UNUSED			 *
*BNEWPAL  EQU	13		  13	NEW PALETTE ADDRESS IS SPECIFIED *
*BFLIPBIT EQU	14		  14	NEW FLIP BITS ARE SPECIFIED	 *
*				FLAG HIERARCHY: 15 --> 8		 *
*				 OPTIONS SHOULD FOLLOW IN THIS ORDER.	 *
**************************************************************************

FRANIM
	MMTM	A12,A3,A4

	cmpi	>ffc00000,a9		;Check for bogus script pointer
	jrhs	FRAN1

	.IF	DEBUG
	LOCKUP
	EINT
	.ELSE
	CALLERR	8,3			;BOGUS IMAGE LOG
	.ENDIF
	JRUC	FRANND

FRAN1	MOVE	A1,A3			;SAVE A1

FRANL	MOVE	*A9+,A1,L		;GET THE FRAME
	JREQ	FRANND			;BR = END WAS HIT

	MOVE	*A8(OFLAGS),A4		;NORMAL FLAGS TO BE USED
	MOVE	*A9+,A0			;GET SLEEP TIME
	CMPI	>100,A0			;SPECIAL FUNCTION?
	JRLO	FRAN2			;NO, BLOW OUT OF HERE
	
	MMTM	SP,A2,A7

	BTST	BFLIPBIT,A0		;NEW FLIP?
	JREQ	FRANNOBI		;NO DICE
	MOVE	*A9+,A2			;GET THE NEW FLIP FLAGS
	ANDNI	(M_FLIPV+M_FLIPH),A4	;CLEAR THE CURRENT FLIP STATUS
	OR	A2,A4			;SET DESIRED BITS

FRANNOBI
	BTST	BNEWPAL,A0		;NEW PALETTE ?
	JREQ	FRANNOPA		;NO WAY...

	move	a0,a7
	move	*a9+,a0,L		;get the palette address
	calla	GETFPAL			;get a color map assignment
	jrz	fran10			;no palette available
	move	a0,*a8(OPAL)		;store the new palette
fran10
	move	a7,a0
FRANNOPA
	MMFM	SP,A2,A7
	SLL	24,A0
	SRL	24,A0			;WIPE OFF THE SPECIAL FUNCTION BITS

FRAN2	CALLA	ANI		;SETUP NEW ANIMATION

	CMPI	4,A3		;ONE FRAME, NO SLEEP?
	JREQ	FRAN3		;YES

	MOVE	A3,-*A12
	CALLA	PRCSLP		;SLEEP THE PROPER TIME
	MOVE	*A12+,A3
	JRNE	FRANL		;BR = LOOP 'TIL END OF LIST

FRAN3	MOVE	A3,A1		;RESTORE A1
	CLRC			;CLEAR END FLAG
	MMFM	A12,A3,A4
	RETP

FRANND	MOVE	A3,A1		;RESTORE A1
	SETC			;OTHERWISE, RETURN WITH END FLAG SET
	MMFM	A12,A3,A4
	RETP


**************************************************************************
* FRANIMQ - Animation script processor (Quick list version)
* A8=*Object
* A9=*FRANIM List
* NOTE: CALL WITH JSRP, IT SLEEPS
*
* ANIMATION SCRIPT FORMAT
*	.LONG	IMAGE_HEADER<-- IF = 0 END OF SCRIPT
*	.WORD	SLEEP_TIME  <-- BITS 0 - 7 ARE THE SLEEP TIME
*			    <-- BITS 8 -15 ARE THE FLAGS:
*				 BIT #		FLAG
*				 -----		----
*				 8-12	       UNUSED
*BNEWPAL  EQU	13		  13	NEW PALETTE ADDRESS IS SPECIFIED
*BFLIPBIT EQU	14		  14	NEW FLIP BITS ARE SPECIFIED
*				FLAG HIERARCHY: 15 --> 8
*				 OPTIONS SHOULD FOLLOW IN THIS ORDER
**************************************************************************

FRANIMQ		;Trashes a0,a1,a2,a4

	cmpi	>ffc00000,a9		;Check for bogus script pointer
	jrhs	frq80

	.IF	DEBUG
	LOCKUP
	EINT
	.ELSE
	CALLERR	8,3			;Bogus image log
	.ENDIF
	jruc	frqx

frqlp	move	*a8(OFLAGS),a4		;Normal flags to be used
	move	*a9+,a0			;Get sleep time
	cmpi	>100,a0			;Special function?
	jrlo	frq70
	
	btst	BFLIPBIT,a0		;New flip?
	jrz	frq40
	move	*a9+,a2			;Get the new flip flags
	andni	(M_FLIPV+M_FLIPH),a4	;Clear the current flip status
	or	a2,a4			;Set desired bits

frq40	btst	BNEWPAL,a0		;New palette ?
	jrz	frq60

	move	a0,a2
	move	*a9+,a0,L		;Get the palette address
	calla	GETFPAL			;Get a color map assignment
	jrz	frq50			;No palette available?
	move	a0,*a8(OPAL)		;Set new palette
frq50	move	a2,a0

frq60	sll	32-8,a0
	srl	32-8,a0			;Wipe off the special function bits

frq70	calla	ANI
	calla	PRCSLP			;Sleep

frq80	move	*a9+,a1,L		;Get frame
	jrnz	frqlp

frqx	RETP




**************************************************************************
*									 *
* FRAMSKIP - SKIP TO THE NEXT FRAME OF AN ANIMATION SCRIPT		 *
* A9 = SCRIPT PTR							 *
* RETURNS:								 *
*	C CLR = A9 IS POINTING TO NEXT FRAME				 *
*	C SET = SCRIPT END WAS HIT, A9 POINTS TO NEXT WORD		 *
*									 *
**************************************************************************
;FRAMSKIP
;	MMTM	SP,A1
;	MOVE	*A9+,A1,L		;GET THE FRAME
;	JREQ	FRAMSSC			;BR = END WAS HIT
;	MOVE	*A9+,A1,W
;	SLL	16,A1			;MOVE FLAGGIES UP HERE
;	SLL	1,A1
;	JRNC	FRAMSNSP
;	ADDI	32+16+32,A9		;PROCESS SPAWN
;FRAMSNSP
;	SLL	1,A1
;	JRNC	FRAMSNF
;	ADDK	16,A9			;NEW FLAGS
;FRAMSNF
;	SLL	1,A1
;	JRNC	FRAMSNP
;	ADDK	32,A9			;NEW PALETTE
;FRAMSNP
;	SLL	1,A1
;	JRNC	FRAMSNXZ
;	ADDK	16,A9			;DELTA X & DELTA Z
;FRAMSNXZ
;	SLL	1,A1
;	JRNC	FRAMSNY
;	ADDK	16,A9			;DELTA Y
;FRAMSNY
;	CLRC	
;	JRUC	FRAMSND
;FRAMSSC
;	SETC
;FRAMSND
;	MMFM	SP,A1
;	RETS
**************************************************************************
*									 *
* AUTOEOFF - TURN OFF AUTO ERASE					 *
* NOTE: BE SURE THE DIRQ IS OFF BEFORE CALLING				 *
*									 *
**************************************************************************
AUTOEOFF
	PUSH	A0
	PUSHST
	DINT
	MOVE	@SYSCOPY,A0,W
	ORI	AUTOERAS,A0	;DISABLE AUTO ERASE
	MOVE	A0,@SYSCOPY,W	;STORE EVERYWHERE I DID GO
	POPST
	MOVE	A0,@SYSCTRL,W
	move	*sp+,a0,L
	RETS

**************************************************************************
*									 *
* AUTOEON - TURN ON AUTO ERASE						 *
* NOTE: BE SURE THE DIRQ IS OFF BEFORE CALLING				 *
*									 *
**************************************************************************
AUTOEON
	PUSH	A0
	MOVE	@NOAUTOE,A0,W
	JRNE	AUTOEON1	;BR = DEBUGGER MAN SAYS NO AUTOERASE
	PUSHST
	DINT
	MOVE	@SYSCOPY,A0,W
	ANDNI	AUTOERAS,A0	;AUTO ERASE IS ENABLED LOW
	MOVE	A0,@SYSCOPY,W	;STORE EVERYWHERE I DID GO
	POPST
	MOVE	A0,@SYSCTRL,W
AUTOEON1
	move	*sp+,a0,L
	RETS

**************************************************************************
*									 *
* COPYOBJ	- COPIES THE CONTENTS OF ONE OBJECT BLOCK TO THE OTHER.	 *
* A0 = PTR TO DESTINATION BLOCK						 *
* A8 = PTR TO SOURCE BLOCK						 *
*									 *
**************************************************************************
;COPYOBJ
;	MMTM	SP,A0,A6,A8
;	MOVI	OBSIZ,A6,W	;GET THE SIZE OF THE BLOCK IN WORDS
;	ADDI	64,A0
;	ADDI	64,A8		;DON'T COPY THE LINKS
;	SRL	4,A6		;DIVIDE BY 16		
;	SUBK	4,A6		;SUBTRACT TO ACCOUNT FOR THE 1ST TWO LINKS
;COPYOBJL
;	MOVE	*A8+,*A0+,W	;MOVE A WORD
;	DSJS	A6,COPYOBJL
;	MMFM	SP,A0,A6,A8
;	PUSH	A6		;KLUDGE TO ZERO MISPLACED LINKS
;	CLR	A6
;	MOVE	A6,*A0(OSHAD),L
;	PULL	A6
;	RETS


	.END

