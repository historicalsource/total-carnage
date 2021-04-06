	.FILE	'UTIL.ASM'
	.TITLE	" <<< FOOTBALL GENERAL PURPOSE SUBROUTINES >>>"

**************************************************************************
*                                                                        *
* 	COPYRIGHT (C) 1988 WILLIAMS ELECTRONICS GAMES, INC. 		     *
* 	ALL RIGHTS RESERVED.						               *
*                                                                        *
**************************************************************************

	.WIDTH	132
	.OPTION	B,D,L
	.MNOLIST

*	GET THE SYSTEM STUFF

	.INCLUDE	"MPROCEQU.ASM"	;MPROC equates
	.INCLUDE	"DISPEQU.ASM"	;Display processor equates
         .INCLUDE        "SYSEQU.ASM"      ;SYS.INC and GSP.INC
	.INCLUDE	"MACROS.HDR"	;Macros, Yeah!
	.INCLUDE	"MAINEQU.ASM"
         .INCLUDE        IMGTBL.GLO



	.EVEN
	.TEXT


*EUGENE'S SCORE ROUTINES
*
*BCD ADD ROUTINE
*A0=SCORE (8 DIGIT BCD) 32 BITS
*A1=NUMBER TO ADD TO A0	(8 DIGIT BCD)
*PACKED BCD FORMAT 4-BITS/ DIGIT
BCDADD:	
	MMTM	SP,A1,A3,A4,A5,A6
	MOVK	8,A5  		;DO 8 DIGITS
	CLRC			;CLEAR THE CARRY
	MOVK	0Ah,A6
BCDLP:
	MOVK	0Fh,A3
	MOVK	0Fh,A4
	AND	A1,A3		;MASK GARBAGE
	AND	A0,A4
	ADDC	A3,A4
	CMP	A6,A4		;NEED TO ADJUST?
	JRLO	BCDAD1
	ADDK	6,A4
	SRL	4,A0
	SLL	28,A4
	ADD	A4,A0
	SRL	4,A1
	SETC
	DSJS	A5,BCDLP
	JRUC	BCDADX
BCDAD1:	
	SRL	4,A0	
	SLL	28,A4
	ADD	A4,A0
	SRL	4,A1
	CLRC
	DSJS	A5,BCDLP
BCDADX:	
	MMFM	SP,A1,A3,A4,A5,A6	
	RETS
*	
*PLAYER SCORE ROUTINE
*A1=SCORE VALUE
*A2=PLAYER INDEX
;SCORE:
;	MMTM	SP,A0,A2
;	MOVE	@GSTATE,A0,W
;	CMPI	INAMODE,A0
;	JREQ	SCOREX			;NO SCORING IN ATTRACT MODE
;	MOVE	*A2(PSCORE),A0,L	;GET SCORE
;	CALLR	BCDADD			;ADD IN NEW VALUE
;	CALLR	REPCK			;CHECK REPLAY
;	MOVE	A0,*A2(PSCORE),L	;STORE SCORE
;*	CALLR	OUTSCR			;OUTPUT CURRENT PLAYER SCORE
;SCOREX
;	MMFM	SP,A0,A2
;	RETS
;
;*	
;*PLAYER SCORE IMMEADIATE ROUTINE, DOESN'T WAIT FOR SCORE REFRESH
;*DO NOT USE THIS DURING HEAVY GAME ACTION PLEASE
;*A1=SCORE VALUE
;*A2=PLAYER INDEX
;SCRIMM:
;	MMTM	SP,A0,A2
;	MOVE	@GSTATE,A0,W
;	CMPI	INAMODE,A0
;	JREQ	SCRIMMX			;NO SCORING IN ATTRACT MODE
;	MOVE	*A2(PSCORE),A0,L	;GET SCORE
;	CALLR	BCDADD			;ADD IN NEW VALUE
;	MOVE	A0,*A2(PSCORE),L	;STORE SCORE
;	CALLR	OUTSCR			;OUTPUT CURRENT PLAYER SCORE
;SCRIMMX
;	MMFM	SP,A0,A2
;	RETS
;*
;*OUTPUT SCORE TO SCREEN
;*A0=CURRENT PLAYER SCORE
;*A2=PLINDX=PLAYER DATA AREA
;*
;OUTSCR:
;	MMTM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A14
;	MOVK	8,A6			;DIGIT COUNT
;	MOVE	*A2(PSCRAD),A3,L	;PLAYER SCORE ADDRESS
;	MOVI	SCRSPC,A4		;SPACING BETWEEN DIGITS	
;	CLR	A7			;INIT BLANKING FLAG
;	MOVI	9|8000H,A5		;CONTROL REGISTER
;
;OUTSCL:
;	MOVE	A0,A1
;	SRL	28,A1
;	JRNE	OUTSC1			;NON-ZERO DIGIT
;	CMPI	2,A6
;	JRLS	OUTSC1			;LAST DIGITS - OUTPUT ANYWAY
;	MOVE	A7,A7	   		;BLANKING OVER?
;	JREQ	OUTSC2			;NO
;OUTSC1:	
;	INC	A7			;BLANKING IS OVER
;	SLL	7,A1			;MULTIPLY BY 128
;	MOVE	A1,A14
;	ADDI	RRD0,A14		;ADDRESS OF IMAGE HEADER
;
;	MOVE	@GSTATE,A1,W
;	CMPI	INAMODE,A1
;	JREQ	OUTSC10			;BR = NO FLASH SCORE DURING AMODE
;	
;	MOVE	*A2(POBJ),A1,L		;IS THE PLAYER ACTIVE
;	JRNE	OUTSC1A			;BR = YES, DO A FLASHY SCORE
;OUTSC10
;	MOVI	0F9F90000H,A1		;CONSTANT COLOR:PALETTE SELECT
;	JRUC	OUTSC1B
;OUTSC1A
;	MOVI	0F5F50000H,A1		;CONSTANT COLOR:PALETTE SELECT
;OUTSC1B
;	CALLA	DTIME			;OUTPUT THE SUCKER
;OUTSC2:
;	ADDXY	A4,A3			;SPACE TO NEXT DIGIT
;	SLL	4,A0
;	DSJ	A6,OUTSCL
;	MMFM	SP,A0,A1,A2,A3,A4,A5,A6,A7,A14
;	RETS


**************************************************************************
*                                                                        *
* OBJECT BLOCK INITIALIZATION ROUTINES					          *
*                                                                        *
**************************************************************************

**************************************************************************
*                                                                        *
* SHVELCPY - COPY VELOCITIES TO SHADOW (IF ANY)                          *
* A8=OBJECT                                                              *
*                                                                        *
**************************************************************************
SHVELCPY: 
	MMTM	SP,A0,A1
	MOVE	*A8(OSHAD),A0,L
	JREQ	SHVLCPX
	MOVE	*A8(OXVEL),*A0(OXVEL),L
	MOVE	*A8(OZVEL),*A0(OZVEL),L
SHVLCPX:
	MMFM	SP,A0,A1
	RETS

*
*SHVELFLP - COPY SHADOW VELOCITY AND FLIP HIM
*A8=OBJECT
*A3=OXVEL
SHVELFLP:
	CALLR	SHVELCPY
	MOVE	*A8(OXVEL+>10),A14,W		;TEST X VELOCITY
*FLIPDUDE
*A8=OBJECT, N=SIGN OF XVEL
FLP:
	JAN	YFLP
	JAUC	NOYFLP

**************************************************************************
*                                                                        *
* OBJOFF - TURN AN OBJECT "OFF" I.E. SET DMA OUTPUT TO 0		          *
* A0 = PTR TO OBJECT BLOCK						               *
*                                                                        *
**************************************************************************
OBJOFF
	PUSH	A4
	MOVE	*A0(OFLAGS),A4,W
	SRL	4,A4
	SLL	4,A4
	MOVE	A4,*A0(OFLAGS),W
	PULL	A4
	RETS
**************************************************************************
*                                                                        *
* OBJON - TURN AN OBJECT "ON" I.E. SET DMA OUTPUT TO WRITE <> 0		*
* A0 = PTR TO OBJECT BLOCK						               *
*                                                                        *
**************************************************************************
OBJON
	PUSH	A4
	MOVE	*A0(OFLAGS),A4,W
	SRL	4,A4
	SLL	4,A4
	ADDK	2,A4
	MOVE	A4,*A0(OFLAGS),W
	PULL	A4
	RETS

**************************************************************************
*                                                                        *
* Z POSITIONING ROUTINES						 *
*                                                                        *
**************************************************************************

*
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
XZCHK:
	MOVE	A0,A4
	CALLR	GETANIX			;GET X ANIMATION POINT
	MOVE	A0,A3
	SWAP	A4,A8
	CALLR	GETANIX
	MOVE	A0,A1
	MOVE	A8,A0
	MOVE	A4,A8
	MOVE	*A8(OZPOS),A4,W	       
	MOVE	*A0(OZPOS),A2,W
	SUB	A4,A2
	SUB	A3,A1
	MOVE	A1,A3
	MOVE	A2,A4
	ABS	A3
	ABS	A4
	CMP	A5,A3
	JRNC	XZCHKX
	CMP	A6,A4
XZCHKX:
	RETS
	
**************************************************************************
*                                                                        *
* CLRPDATA - CLEAR THE PDATA AREA OF A PROCESS BLOCK			 *
* A13 = PTR TO PROCESS BLOCK						 *
*                                                                        *
**************************************************************************
CLRPDATA
	MMTM	SP,A1,A6,A14
	MOVE	A13,A14
	CLR	A1
	ADDI	PDATA,A14
	MOVI	(PSDATA-PDATA)/16,A6
CLRSHL
	SRL	1,A6
	JRNC	CLRPDL
	MOVE	A1,*A14+,W	;STUFF THE ODD WORD	
CLRPDL
	MOVE	A1,*A14+,L		
	DSJS	A6,CLRPDL
	MMFM	SP,A1,A6,A14
	RETS
**************************************************************************
*                                                                        *
* GET BOTTOM Y OF AN OBJECT						 *
* A8 = OBJECT BLOCK PTR							 *
* RETURN(S)								 *
* A1 = 16 BIT BOTTOM Y IN LSW						 *
* STATUS SET ACCORDING TO THE BOTTOM Y					 *
*NOTE: MAKE SURE OBLOCK IS INIT'D WITH GSAGOF BEFORE CALLING		 *
*                                                                        *
**************************************************************************
GETBOTY
	PUSH	A2
	MOVE	*A8(OYPOS),A1,W		;GET Y POSITION
	MOVE	*A8(OSIZEY),A2,W	;GET THE CURRENT SIZE
	ADD	A2,A1			;A1 = BOTTOM Y
	MMFM	SP,A2
	RETS

**************************************************************************
*                                                                        *
* GETCPNT - RETURNS THE CENTER XY POSITION OF A GIVEN IMAGE		 *
* A8 = IMAGE OBLOCK							 *
* RETURN(S)								 *
* A1 = CENTER Y:CENTER X							 *
*                                                                        *
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
*                                                                        *
* GETCENT - RETURNS THE CENTER POINT OF A BOX		      		 *
* A0 = UPPER LEFT Y:UPPER LEFT X					 *
* A1 = Y_SIZE:X_SIZE   							 *
* RETURN(S)								 *
* A0 = CENTER Y(LSW)							 *
* A1 = CENTER X(LSW)							 *
*                                                                        *
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
*                                                                        *
* GETSCRRX - THE THE WORLD X COORDINATE OF THE SCREEN RIGHT END		 *
* RETURNS								 *
* A0 = SCREEN RIGHT X, 32 BITS						 *
*                                                                        *
**************************************************************************
GETSCRRX
	PUSH	A2
	MOVE	@SCRNLR,A0,W
	MOVE	@WORLDTL,A2,W
	ADD	A2,A0			;GET SCREEN LOWER RT.
	SLL	16,A0
	PULL	A2
	RETS

*
*GETANIX - GET ANIMATION POINT X COORD
*CALLING PARMS: A8=OBJECT
*RETURNS A0=16 BIT WORLD COORD OF UPPER LEFT
*
GETANIX:
	MMTM	SP,A1,A2
	MOVE	*A8(OIMG),A1,L
	MOVE	*A1(IANIOFF),A2,W
	MOVE	*A8(OFLAGS),A0,W
	BTST	B_FLIPH,A0
	JRZ	GETAX1
	MOVE	*A1(ISIZE),A0,W
	SUB	A2,A0
	DEC	A0
	MOVE	A0,A2
GETAX1:
	MOVE	*A8(OXPOS),A0,W
	ADD	A2,A0
	MMFM	SP,A1,A2
	RETS

**************************************************************************
*                                                                        *
* GETZMID - GET THE Z MIDPOINT OF AN OBJECT.				 *
* A8 = PTR TO OBJECT							 *
* RETURNS:								 *
* A0 = 32 BIT Z CENTER							 *
*                                                                        *
**************************************************************************
;GETZMID
;	MMTM	SP,A1,A2
* THIS OBJECT FIELD HAS BEEN REDEFINED, IF YOU STILL WANNA USE THIS
* ROUTINE YOU WILL HAVE TO MODIFY IT FOR THE NEW "OZSIZE" (EJB-5/5/90)
;	MOVE	*A8(OZSIZ),A2,L
;	MOVY	A2,A1				;A1 = OZPLUS
;	SRL	16,A1
;	ZEXT	A2
;	ADD	A1,A2				;A2 = TOTAL Z WIDTH
;	SLL	15,A2				;DIVIDE FOR HALF
;	SLL	16,A1
;	MOVE	*A8(OZVAL),A0,L
;	ADD	A1,A0				;GET TO THE EDGE
;	SUB	A2,A0				;GO BACK TO MIDPOINT	
;	MMFM	SP,A1,A2	
;	RETS

**************************************************************************
*                                                                        *
* CLRWORLD - CLEAR ALL WORLD COORDINATES AND SCROLL VELOCITIES.		 *
*                                                                        *
**************************************************************************
CLRWORLD
	PUSH	A0
	CLR	A0
	MOVE	A0,@SCROLLX,L		;X SCROLL VALUE
	MOVE	A0,@SCROLLY,L		;Y SCROLL VALUE
	MOVE	A0,@WORLDTLX,L		;TOP LEFT X SCREEN COORD (WORLD)
	MOVE	A0,@WORLDTLY,L		;TOP LEFT Y SCREEN COORD (WORLD)
	MOVE	A0,@WORLDTL,L
	MOVE	A0,@BAK2TLY,L		;TOP LFT Y SLOW SCROLL BACKGROUND
	MOVE	A0,@BAK2TLX,L		;TOP LFT X SLOW SCROLL BACKGROUND
	MOVI	SCRNST,A0
	MOVE	A0,@SCRNTL,L
	MOVE	A0,@SCRNTL2,L
	MOVE	A0,@SCRNTL3,L
	MOVI	SCRNEND,A0
	MOVE	A0,@SCRNLR,L
	MOVE	A0,@SCRNLR2,L
	MOVE	A0,@SCRNLR3,L
	PULL	A0
	RETS

**************************************************************************
*                                                                        *
* GETSCRBY - THE THE WORLD Y COORDINATE OF THE SCREEN BOTTOM		 *
* RETURNS								 *
* A0 = SCREEN BOTTOM Y							 *
*                                                                        *
**************************************************************************
GETSCRBY
	PUSH	A2
	MOVE	@SCRNLR+16,A0,W
	MOVE	@WORLDTL+16,A2,W
	ADD	A2,A0			;GET SCREEN BOTTOM Y
	SLL	16,A0			;MAKE IT A 32 BIT VALUE
	PULL	A2
	RETS
**************************************************************************
*                                                                        *
* SETYPOS - SETUP OBJECTS Y POSITION SO HES ON THE GROUND				*	 *
* A0 = OBJECT BLOCK										*
*                                                                        *
**************************************************************************
SETYPOS	MOVE	A1,-*SP,L
	MOVE	*A0(OSIZEY),A1,W
	NEG	A1
	SLL	16,A1
	MOVE	A1,*A0(OYVAL),L
	MOVE	*SP+,A1,L
	RETS

**************************************************************************
*                                                                        *
* MYOINIT - INITIALIZE SUPPLEMENTAL OBJECT LIST HEADERS			     *
*                                                                        *
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
	CLR	A5	 		;STUFF OFFSET
	MOVE	A5,-*A0,W
	MOVI	DMACAL,A5		; CONTROL &
	MOVE	A5,-*A0,W		; GO!
         CALLA   CLRPAL               ; CLEAR PALETTE RAM

         CLR     A0
         MOVE    A0,@SL_OFFENSE,L
         MOVE    A0,@SL_DEFENSE,L     ; RE-INIT SUPPLEMENTAL LISTS

	MOVK    1,A0
	MOVE	A0,@GAMERASE
	CALLA	AUTOEON              ; AUTOERASE / GAME ERASE ON !!!

         MOVI    boonpal,A0
         CALLA   GETFPAL              ; FOOTBALL FIXED PALETTE !!
	MMFM	SP,A0,A1,A2,A3,A4,A5
	JAUC	OINIT

**************************************************************************
*                                                                        *
* ADDSUPP - ADD OBJECT TO A SUPPLEMENTAL LIST				          *
* A0 = PTR TO OBJECT							               *
* A1 = MEMORY LOCATION OF SUPPLEMENTAL LIST HEADER			          *
*                                                                        *
**************************************************************************
ADDSUPP	
	MOVE	*A1(0),*A0(OSLINK),L	;LINK SLIST TO THIS BLOCK
	MOVE	A0,*A1,L		;NEW HEAD OF THE SLIST
	RETS

**************************************************************************
*                                                                        *
* DELSBOBJ - DELETE OBJECT FROM SUPPLEMENTAL BACKGROUND LIST		     *
* A0 = PTR TO OBJECT							               *
*                                                                        *
**************************************************************************
;DELSBOBJ
;	PUSH	A1
;	MOVI	BACKSLST,A1
;	CALLR	DELSUPP
;	PULL	A1
;	RETS

**************************************************************************
*                                                                        *
* DELSUPP - DELETE OBJECT FROM THE SUPPLEMENTAL LIST			 *
* A0 = PTR TO OBJECT							 *
* A1 = MEMORY LOCATION OF SUPPLEMENTAL LIST HEADER			 *
*                                                                        *
**************************************************************************
DELSUPP
	MMTM	SP,A1,A2
	MOVE	A1,A2
  	MOVE	*A1,A1,L        ;SPECIAL CASE THE HEADER
	JRNZ	DELSCHK1
	LOCKUP
	JRUC	DELSX
DELSCHK1
	CMP	A1,A0
	JRNE	DELSLUP
	MOVE	*A1(OSLINK),*A2(0),L	;LINK AROUND THIS GUY 	
DELSX
	MMFM 	SP,A1,A2
	RETS

DELSLUP
	MOVE	A1,A2       	;SAVE PREVIOUS
	MOVE	*A1(OSLINK),A1,L	;SEARCHING FOR THE ELEMENT IN THE LIST
	JRNZ	DELSCHK2
	LOCKUP
	JRUC	DELSX
DELSCHK2
	CMP	A1,A0
	JRNE	DELSLUP		;NOT FOUND KEEP LOOKING

	MOVE	*A1(OSLINK),*A2(OSLINK),L	;LINK AROUND THIS GUY 	

	MMFM 	SP,A1,A2
	RETS

**************************************************************************
*                                                                        *
* ISSUPP - IS AN OBJECT ON A SUPPLEMENTAL LIST				 *
* A0 = PTR TO OBJECT							 *
* A1 = MEMORY LOCATION OF SUPPLEMENTAL LIST HEADER			 *
* RETURNS:								 *
*  Z BIT SET = NOT ON							 *
*  Z BIT CLR = IS ON							 *
*                                                                        *
**************************************************************************
ISSUPP
	PUSH	A1
  	MOVE	*A1,A1,L        ;SPECIAL CASE THE HEADER
	JREQ	ISEND
	CMP	A1,A0
	JRNE	ISSEARCH
ISFOUND
	MOVE	A1,A1		;SET Z BIT
ISEND
	PULL	A1
	RETS
ISSEARCH
	MOVE	*A1(OSLINK),A1,L  	;SEARCHING FOR THE ELEMENT IN THE LIST
	JREQ	ISEND			;ELEMENT DOES NOT EXIST
	CMP	A1,A0
	JRNE	ISSEARCH		;NOT FOUND KEEP LOOKING
	JRUC	ISFOUND			;FOUND RETURN

**************************************************************************
*                                                                        *
* ISSUPPID - IS AN OBJECT ON A SUPPLEMENTAL LIST(SEARCH BY OBJECT I.D.)	 *
* A0 = OBJECT I.D.							 *
* A1 = MEMORY LOCATION OF SUPPLEMENTAL LIST HEADER			 *
* RETURNS:								 *
*  Z BIT SET = NOT ON							 *
*	       A1 = ZERO						 *
*  Z BIT CLR = IS ON							 *
*	       A1 = PTR TO OBJECT					 *	 
*                                                                        *
**************************************************************************
ISSUPPID
	PUSH	A2	
  	MOVE	*A1,A1,L        ;SPECIAL CASE THE HEADER
	JREQ	ISENDID
	MOVE	*A1(OID),A2,W
	CMP	A2,A0
	JRNE	ISSRCHID
ISFNDID
	MOVE	A1,A1		;SET Z BIT
ISENDID
	PULL	A2
	RETS
ISSRCHID
	MOVE	*A1(OSLINK),A1,L  	;SEARCHING FOR THE ELEMENT IN THE LIST
	JREQ	ISENDID			;ELEMENT DOES NOT EXIST
	MOVE	*A1(OID),A2,W
	CMP	A2,A0
	JRNE	ISSRCHID		;NOT FOUND KEEP LOOKING
	JRUC	ISFNDID			;FOUND RETURN

**************************************************************************
*                                                                        *
* CNTSUPP - COUNT THE NUMBER OF OBJECTS ON GIVEN SUPPLEMENTAL LIST.	 *
* A1 = SUPPLEMENTAL LIST						 *
* RETURNS:								 *
* A0 = OBJECT CNT							 *
*                                                                        *
**************************************************************************
CNTSUPP
	PUSH	A1
	CLR	A0
	MOVE	*A1,A1,L
	JRZ	CNTSUPPX	
CNTSUPPL
	INC	A0
	CMPI	NOBJ,A0
	JRHS	CNTSUPPX		;WE'VE MAXED, SOMETHING IS WRONG
	MOVE	*A1(OSLINK),A1,L
	JRNZ	CNTSUPPL
CNTSUPPX	
	PULL	A1
	RETS

**************************************************************************
*                                                                        *
* RANDOM - GENERATE A RANDOM NUMBER					 *
* RETURNS:								 *
* A0 = 32 BIT RANDOM #							 *
*                                                                        *
**************************************************************************
RANDOM:	PUSH	A1
	MOVE	@RAND,A0,L
	SLA	1,A0
	JRV	RND2
	ORI	2,A0
RND2:	MOVE	A0,@RAND,L
	CLR	A1
	ADDC	A1,A0	;GET LAST BIT BACK TO MAKE 32
	MOVE	@HCOUNT,A1
	RL	A1,A0	;RANDOM ROTATION
	MOVE	A0,A0	;SET STATUS BITS
	MMFM	SP,A1
	RETS	

**************************************************************************
*                                                                        *
* RANDU - GENERATE A UNIFORMLY DISTRIBUTED RANDOM # BETWEEN 1 AND [A0]	 *
* A0 = RANGE INPUT							 *
* RETURNS:								 *
* A0 = RANDOM #								 *
*                                                                        *
**************************************************************************
RANDU:	PUSH	A1
	MOVE	A0,A1
	CALLR	RANDOM
	MPYU	A1,A0
	INC	A0
	MMFM	SP,A1
	RETS		
*
*GET SIGNED RANDOM # IN RANGE +/- A0
*CALLING PARAMETERS: A0
*RETURNS A0
*
SRAND:
	MMTM	SP,A1
	MOVE	A0,A1
	SLL	1,A0
	CALLA	RANDU
	SUB	A1,A0
	MMFM	SP,A1
	RETS
**************************************************************************
*                                                                        *
* RANGRAND - GENERATE A RANDOM NUMBER IN A GIVEN RANGE.			 *
* B0 = LOWER BOUND							 *
* B1 = UPPER BOUND							 *
* RETURNS								 *
* A0 = RANDOM #								 *
*                                                                        *
**************************************************************************
RANGRAND
	PUSH	A1
	PUSH	B1
	SUB	B0,B1		;NORMALIZE THE RANGE
	MOVE	B1,A0		;SET RANGE FOR RANDU
	CALLR	RANDU
	MOVE	B0,A1
	ADD	A1,A0
	PULL	B1
	PULL	A1
	RETS

*
*RANDPER - RANDOM % ROUTINE
*CALLING PARAMETERS:
*A0=PROBABILITY OF EVENT (0-1000) P(A0=1000) = 1; P(A0=1) = 1/1000.
*RETURNS CS IF PROBABILITY IS TRUE, CC FOR FALSE
*RETURNS A0 = ACTUAL RANDOM # 0-999
RANDPER:
	MMTM	SP,A1,A2
	MOVE	A0,A2
	CALLA	RANDOM
	MOVI	1000,A1
	MPYU	A1,A0
	CMP	A2,A0
	MMFM	SP,A1,A2
	RETS		

**************************************************************************
*                                                                        *
* FILLAREA - FILL A GIVEN SQUARE AREA ON THE SCREEN WITH A COLOR	 *
* A1 = [COLOR,PALETTE]							 *
* A3 = DAG OF AREA [YPOS,XPOS]						 *
* A4 = [Y,X] SIZE OF AREA						 *
*                                                                        *
**************************************************************************
FILLAREA
	MMTM	SP,A1,A2,A4,A5
	JRUC	AREACON

**************************************************************************
*                                                                        *
* BLNKAREA - BLANK A GIVEN SQUARE AREA ON THE SCREEN			          *
* A3 = DAG OF AREA [YPOS,XPOS]						               *
* A4 = [Y,X] SIZE OF AREA						               *
*                                                                        *
**************************************************************************
BLNKAREA
	MMTM	SP,A1,A2,A4,A5
	CLR	A1			;CONSTANT 0:PALETTE 0
AREACON
	MOVE	A4,A2
	MOVI	2000000H,A4		;SOMEWHERE IN IMAGE ROM
	MOVI	DMACAL,A5
	CALLA	QDMAN
	MMFM	SP,A1,A2,A4,A5
	RETS

**************************************************************************
*                                                                        *
* PFRAME - GET NEXT FRAME FROM ANIMATION LIST				 *
* A8 = POINTER TO OBJECT BLOCK						 *
* A11 = POINTER TO NEXT FRAME IN THE ANIMATION LIST			 *
* RETURN(S)								 *
* A5 = TICKS FOR THIS FRAME						 *
* C BIT SET(JxC)  = END OF LIST WAS HIT					 *
* N BIT SET(JxN)  = SPECIAL FRAME ENCOUNTERED				 *
*                                                                        *
**************************************************************************
PFRAME	MMTM	SP,A1,A4
	MOVE	*A11+,A1,L		;LOAD NEXT FRAME
	JRNE	PFRAME1			;NOT THE END OF THE LIST

	SETC	       			;SET CARRY FLAG
	JRUC	PFRAMEX

PFRAME1
	MOVE	*A8(OFLAGS),A4,W
	CALLA	ANI			;SETUP NEW FRAME
PFRAME2
	MOVE	*A11+,A5,W		;LOAD SLEEP TICKS PER FRAME
	CLRC	

PFRAMEX	MMFM	SP,A1,A4
	RETS


PSTOP
	MMTM	SP,A0,A1
         CLR 	A1               	; NO VELOCITY
         MOVE    A1,*A8(OXVEL),L      ; IN THE "X" DIRECTION (AND DESIGN)
         MOVE    A1,*A8(OYVEL),L      ; STOP MOVEMENT
         MOVE    A1,*A8(OZVEL),L      ; STOP MOVEMENT
         MOVE    A1,*A8(OXACC),L      ; NO ACCELERATION
         MOVE    A1,*A8(OZACC),L

	MOVE	*A8(OSHAD),A0,L
	JREQ	PSTOPX	
	MOVE	A1,*A0(OXVEL),L		; STOP THE SHADOW
	MOVE	A1,*A0(OYVEL),L
         MOVE    A1,*A0(OZVEL),L      ; STOP MOVEMENT
PSTOPX
	MMFM	SP,A0,A1
	RETS

*
*YFLP - SET OBJECT Y-FLIP, A8:OBJECT BLOCK PTR
YFLP	MMTM	SP,A1,A4
	MOVE	*A8(OFLAGS),A4
	ORI	M_FLIPH,A4
	JRUC	STUFLAGS
*
*NOYFLP - CLEAR OBJECT Y-FLIP, A8:OBJECT BLOCK PTR	
NOYFLP	MMTM	SP,A1,A4
	MOVE	*A8(OFLAGS),A4
	ANDNI	M_FLIPH,A4
STUFLAGS
	MOVE	*A8(OIMG),A1,L		;GET THE CURRENT IMAGE POINTER
	CALLA	ANI			;SETUP THE "NEW" IMAGE
UNFLPD	MMFM	SP,A1,A4
	RETS

**************************************************************************
*                                                                        *
* SYNCUP - SYNCHRONIZE WITH THE NEXT DISPLAY INTERRUPT, I.E.		 *
* 	 WAIT UNTIL THE NEXT INTERRUPT IS FINISHED BEFORE RETURNING	 *
*                                                                        *
**************************************************************************
SYNCUP	MOVE	A0,-*SP,L
	CLR	A0
	MOVE	A0,@INTSYNC0,L	;CLEAR HALF SCREEN SYNC

SYNCUP1	MOVE	@INTSYNC0,A0,L
	JREQ	SYNCUP1		;END HASN'T HIT YET
	MOVE	*SP+,A0,L
	RETS

**************************************************************************
*                                                                        *
* SYNCHALF - SYNCHRONIZE WITH THE HALF SCREEN INTERRUPT			 *
*                                                                        *
**************************************************************************
SYNCHALF
	MMTM	SP,A0,A1
	MOVI	INTSYNC0,A1
	JRUC	SYNCSD
**************************************************************************
*                                                                        *
* SYNCFULL - SYNCHRONIZE WITH THE FULL SCREEN INTERRUPT			 *
*                                                                        *
**************************************************************************
SYNCFULL
	MMTM	SP,A0,A1
	MOVI	INTSYNC1,A1

SYNCSD	CLR	A0
	MOVE	A0,*A1,W	;CLEAR HALF SCREEN SYNC

SYNCSD1	MOVE	*A1,A0,W
	JREQ	SYNCSD1		;END HASN'T HIT YET
	MMFM	SP,A0,A1
	RETS

**************************************************************************
*                                                                        *
* DTIME - USED TO DMA AN IMAGE						               *
* A1 = [CONSTANT COLOR,PALETTE(STUFFED IN DTIME)]			          *
* A3 = DAG [Y,X]							                    *
* A5 = [OFFSET,CONTROL]							               *
* A14 = ADDRESS OF IMAGE HEADER						               *
*                                                                        *
**************************************************************************
DTIME:
	MMTM	SP,A0,A1
	MOVE	*A14(ICMAP),A0,L	;GET THE PALETTE
	CALLA	FINDPAL			;GET THE CORRECT COLOR MAP #
	JRNZ	DTIME1			;BR = PALETTE WAS FOUND
	CLR	A0			;DEFAULT TO FIXED PALETTE
DTIME1
	MOVX	A0,A1
	CALLA	QDMA			;QUEUE THIS SUCKAH
	MMFM	SP,A0,A1
	RETS

**************************************************************************
*                                                                        *
* DMAWAIT - WAIT ON THE DMA BUSY BIT TO CLEAR				          *
*                                                                        *
**************************************************************************
DMAWAIT	
	PUSH	A0
DMAWAITL
	MOVE	@DMACTRL,A0,W	;DMA BUSY?
	JRN	DMAWAITL	;BR = YES
	PULL	A0
	RETS
**************************************************************************
*                                                                        *
* DMAQWAIT - WAIT FOR DMA QUEUES TO EMPTY, THEN WAIT FOR DMA TO FINISH	*
* 	   THE LAST ONE.						               *
*                                                                        *
**************************************************************************
;DMAQWAIT
;	PUSH	A0
;DMAQWT1
;	MOVE	@TOPQ0CNT,A0,W	
;	JRNE	DMAQWT1
;	MOVE	@TOPQ1CNT,A0,W	
;	JRNE	DMAQWT1
;	MOVE	@BOTQ0CNT,A0,W	
;	JRNE	DMAQWT1
;	MOVE	@BOTQ1CNT,A0,W	
;	JRNE	DMAQWT1
;	PULL	A0
;DMAQWT2
;	MOVE	B13,B13
;	JRZ	DMAWAIT
;	JRUC	DMAQWT2

**************************************************************************
*                                                                        *
* DMAHALT - HALT THE DMA						                    *
*                                                                        *
**************************************************************************
DMAHALT
	PUSH	A0
	CLR	A0
	MOVE	A0,@DMACTRL,W		;HALT THE DMA			 
	PULL	A0
	RETS
*
*CMAPRS - RESET THE COLOR MAP SELECT
CMAPRS	CLR	A0
*CMAPSL - SELECT THE COLOR MAP(0-15 IN A0)
CMAPSL	MOVE	A1,-*SP,L
	CALLA	DMAWAIT
	MOVE	A0,@CMAPSEL
	MOVE	*SP+,A1,L
	RETS

**************************************************************************
*                                                                        *
* CRINIT - COLOR RAM INITIALIZATION, FIRST CLEAR ALL COLOR RAM, THEN	 *
* 	 FILL WITH PALETTES.						 *
*                                                                        *
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

*
*SCRCLR - CLEAR THE SCREEN WITH EUGENE
*ONLY CALL WITH INTERRUPTS DISABLED AND THE DMA SHUT DOWN, OTHERWISE
*	USE CLR_SCRN
SCRCLR	CLR	A0
*SCRFIL - FILL SCREEN WITH A0
SCRFIL:
	MMTM	SP,A1,A2
	CLR	A1
	MOVE	A1,@CMAPSEL,W			;SELECT COLOR MAP 0
	MOVI	SCREEN,A1,L
	MOVI	(SCRNE-SCREEN)/32,A2,L
SCRLP	MOVE	A0,*A1+,L
	DSJS	A2,SCRLP
	MMFM	SP,A1,A2
	RETS
**************************************************************************
*                                                                        *
* SETPPROC - SETUP TI'S PIXEL PROCESSING REGISTER'S (BFILE), TO MATCH 	 *
* 	   THE ZUNIT SYSTEM.						 *
* NOTE:	   IF YOU WANT TO DO ANY SPECIAL TRICKS, DON'T USE THIS. 	 *
*                                                                        *
**************************************************************************
SETPPROC
	PUSH	A0
	MOVI	OFFSETVAL,B4	;Set up OFFSET register
	MOVI	0,B8		 	;Set background color
	MOVI	SCRN_PTCH,A0 		;Get Screen Pitch
	MOVE	A0,B1
	MOVE	A0,B3
	LMO	A0,A0			;Convert in temporary register
	MOVE	A0,@CONVSP		;Move to CONVSP io register
	MOVE	A0,@CONVDP		;Move to CONVDP io register
	PULL	A0
	RETS


************  CLEAR SCREEN ROUTINE  *********************
CLR_SCRN
clr_scrn:
	CLR	A0
	MMTM	SP,A1,A2,A3
	MOVE	@DISPLAYON,A3,W
	CLR	A1
	MOVE	A1,@DISPLAYON,W
;	CALLR	DMAQWAIT			;WAIT ON DMA
	CLR	A1
	MOVE	A1,@CMAPSEL,W			;SELECT COLOR MAP 0
	MOVI	SCREEN,A1,L
	MOVI	((SCRNE-2000H)-SCREEN)/32,A2,L
CLRLP	MOVE	A0,*A1+,L
	DSJS	A2,CLRLP
	MOVE	A3,@DISPLAYON,W
	MMFM	SP,A1,A2,A3
	RETS

*COLLISION VECTOR LISTS
DUMCOLL	.WORD	0
	.LONG	DUMRTSG

DUMRTSG
	CLR	A0			;DON'T STOP SCAN
	CLRC				;AND DON'T DELETE
	RETS	


**************************************************************************
*                                                                        *
* FRANIM - ANIMATION SCRIPT PROCESSOR					               *
* A1 = COMMAND:	00 = PROCESS CURRENT FRAME.				          *
* 		01 = PROCESS TO END OF LIST.				          *
* 		02 = PROCESS X # OF FRAMES OR TO END. A1 = [# FRMS,CMD] *
* 		03 = INFINITELY LOOP ON THE LIST.			          *
* 		04 = PROCESS CURRENT FRAME, NO SLEEP(TIME RETRN'D IN A0 *
* A8 = PTR TO OBJECT BLOCK						               *
* A9 = PTR TO CURRENT FRAME						               *
* RETURN(S)								               *
* CARRY SET IF END OF ANIMATION LIST WAS HIT				          *
* A9 = POINTING TO NEXT FRAME, IF NOT AT END OF LIST			          *
* SETS EPARENT OF THE SPAWNED CHILD POINTING TO THIS PROCESS		     *
* NOTE: CALL WITH JSRP, IT SLEEPS					               *
* 									               *
* ANIMATION SCRIPT FORMAT						               *
* 	.LONG	IMAGE_HEADER<-- IF = 0 END OF SCRIPT			     *
* 	.WORD	SLEEP_TIME  <-- BITS 0 - 7 ARE THE SLEEP TIME.	     *
* 			    <-- BITS 8 -15 ARE THE FLAGS:		     *
* 				 BIT #	DESCRIPTION		SIZE	     *
* 				 -----	-----------		----	     *
* 				   8	NEW SCRIPT ADDRESS 	(32)	          *
* 				   9	UNUSED				          *
* 				  10	UNUSED				          *
* 				  11	DELTA Y			(16) 	     *
* 				  12	PACKED DELTAS FOR X&Z 	(16)	     *
* 				  13	NEW PALETTE ADDRESS	(32)	          *
* 				  14	NEW FLIP BITS		(16)	          *
* 				  15	SPAWN PROCESS W/OFFSETS	(80)	     *
* 					 .WORD XOFF,YOFF,PROCID		     *
* 					 .LONG PROCADDR			     *
* 				FLAG HIERARCHY: 15 --> 8		          *
* 				 OPTIONS SHOULD FOLLOW IN THIS ORDER.   *
*                                                                        *
**************************************************************************
FRANIM
	MMTM	A12,A3,A11
	MOVE	A9,A11		;SAVE ENTRYPOINT FOR INFINITE CASE		
FRAN1
	MOVE	A1,A3
	MOVE	*A9+,A1,L		;GET THE FRAME
	JREQ	FRANND			;BR = END WAS HIT

	MMTM	SP,A2,A4,A5,A6,A7,A10,A14

      	MOVE	*A8(OFLAGS),A4,W	;GRAB THE FLAGS

	MOVE	*A9+,A0,W
	MOVE	A0,A14			;XFER FLAGS HERE	
	SLL	24,A0
	SRL	24,A0			;WIPE OFF THE FLAGS

	SRL	8,A14			;STRIP THE SLEEP TIME
	SLL	24,A14			;MOVE FLAGGIES UP HERE
	JRZ	FRANANI			;BR = NO FLAGS

	SLL	1,A14
	JRNC	FRANNOSP
*SPAWN A PROCESS
	MMTM	SP,A0,A1
	MOVE	*A9+,A10,L	;X AND Y FIRING OFFSETS PASSED IN A10
	MOVE	*A9+,A1,W	;GET PROCESS ID
	MOVE	*A9+,A7,L	;PROCESS STARTING ADDRESS
	CALLA	GETPRC		;SPAWN THE PROCESS
***	JREQ	FRSPAWNF	;BR = FAILED TO SPAWN
***	MOVE	A13,*A0(EPARENT),L	;RETURN LINK TO PARENT PROCESS	
FRSPAWNF
	MMFM	SP,A0,A1	
FRANNOSP
	SLL	1,A14
	JRNC	FRANNOBI
*STUFF SOME NEW FLAGS
	MOVE	*A9+,A2,W		;GET THE NEW FLIP FLAGS
	ANDNI	(M_FLIPV+M_FLIPH),A4	;CLEAR THE CURRENT FLIP STATUS
	OR	A2,A4			;SET DESIRED BITS

FRANNOBI:
	SLL	1,A14
	JRNC	FRANNOPA
*ACTIVATE A NEW PALETTE
	PUSH	A0			
	MOVE	*A9+,A0,L		;GET THE PALETTE ADDRESS
	CALLA	GETFPAL			;GET A COLOR MAP ASSIGNMENT
	JRZ	FRAN2B			;NO PALETTE AVAILABLE
	MOVE	A0,A7			;SAVE HERE
	MOVE	A8,A0
	CALLA	DELPAL
	MOVE	A7,*A8(OPAL),W		;STORE THE NEW PALETTE
FRAN2B
	PULL	A0
FRANNOPA
	SLL	1,A14
	JRNC	FRANNDXZ
*ADD DELTA X AND Z
	MOVE	*A9+,A7,W		;GET THE DELTAS
	MOVE	A7,A6
	SLL	24,A6
	SRA	24,A6			;BRING THE SIGN BACK DOWN
	JRZ	FNODX			;BR = THERE'S NO DELTA HERE
	BTST	B_FLIPH,A4
	JREQ	FNOFDX
	NEG	A6			;HE'S FLIPPED, NEGATE
FNOFDX
	MOVE	*A8(OXPOS),A5,W
	ADD	A6,A5
	MOVE	A5,*A8(OXPOS),W		;ADJUST X POSITION
FNODX
	SRA	8,A7
	JRZ	FRANNDXZ		;BR = NO Z OFFSET
	BTST	B_FLIPV,A4
	JREQ	FNOFDZ
	NEG	A7
FNOFDZ
	MOVE	*A8(OZPOS),A5,W
	ADD	A7,A5
	MOVE	A5,*A8(OZPOS),W		;ADJUST Z POSITION
	MOVE	*A8(OYPOS),A5,W
	ADD	A7,A5
	MOVE	A5,*A8(OYPOS),W		;ADJUST MATCHING Y POSITION
FRANNDXZ
	SLL	1,A14
	JRNC	FRANNDY
*ADD DELTA Y
	MOVE	*A9+,A7,W
	JRZ	FRANNDY
	BTST	B_FLIPV,A4
	JREQ	FNOFDY
	NEG	A7
FNOFDY
	MOVE	*A8(OYPOS),A5,W
	ADD	A7,A5
	MOVE	A5,*A8(OYPOS),W		;ADJUST Y POSITION
FRANNDY
	SLL	3,A14		;GET TO BIT 8, SKIP BITS 9 AND 10
	JRNC	FRANNNA		;BR = NO NEW SCRIPT ADDRESS
	MOVE	*A9,A9,L	;LOAD IN THE NEW SCRIPT ADDRESS
FRANNNA:
*JUST TO THE ANIMATION
FRANANI:
	CALLA	ANI		;SETUP NEW ANIMATION

	MMFM	SP,A2,A4,A5,A6,A7,A10,A14

	MOVE	A3,A1		;GET THE COMMAND BACK
	CMPI	4,A1		;ONE FRAME, NO SLEEP?
	JREQ	FRAN3		;YES

	PUSHP	A1
	CALLA	PRCSLP		;SLEEP THE PROPER TIME
	PULLP	A1

	CMPI	1,A1
	JREQ	FRAN1		;BR = LOOP 'TIL END OF LIST
	JRLT	FRAN3		;BR = ONE FRAME AT A TIME
         CMPI    3,A1
         JREQ    FRAN1

	SUBI	010000h,A1	;DECREMENT FRAME COUNT
    	CLR	A0
	CMPXY	A0,A1
	JRYGT	FRAN1		;FRAME COUNT HAS NOT BEEN EXHAUSTED

FRAN3	CLRC			;CLEAR END FLAG
	JRUC	FRANX			

FRANND	MOVE	A3,A1
	CMPI	3,A1
	JRNE	FRAN4		;BR = EXIT

	MOVE	A11,A9		;GET THE STARTING POINTER BACK
	JRUC	FRAN1		;LOOP INFINITELY

FRAN4	SETC			;OTHERWISE, RETURN WITH END FLAG SET
FRANX
	MMFM	A12,A3,A11
	RETP

**************************************************************************
*                                                                        *
* FRAMSKIP - SKIP TO THE NEXT FRAME OF AN ANIMATION SCRIPT		     *
* A9 = SCRIPT PTR							               *
* RETURNS:								               *
* 	C CLR = A9 IS POINTING TO NEXT FRAME				          *
* 	C SET = SCRIPT END WAS HIT, A9 POINTS TO NEXT WORD		     *
*                                                                        *
**************************************************************************
FRAMSKIP
	MMTM	SP,A1
	MOVE	*A9+,A1,L		;GET THE FRAME
	JREQ	FRAMSSC			;BR = END WAS HIT
	MOVE	*A9+,A1,W
	SRL	8,A1			;STRIP THE SLEEP
	SLL	24,A1			;MOVE FLAGGIES UP HERE
	JRZ	FRAMSANI		;BR = NO FLAGS

	SLL	1,A1
	JRNC	FRAMSNSP
	ADDI	32+16+32,A9		;PROCESS SPAWN
FRAMSNSP
	SLL	1,A1
	JRNC	FRAMSNF
	ADDK	16,A9			;NEW FLAGS
FRAMSNF
	SLL	1,A1
	JRNC	FRAMSNP
	ADDK	32,A9			;NEW PALETTE
FRAMSNP
	SLL	1,A1
	JRNC	FRAMSNXZ
	ADDK	16,A9			;DELTA X & DELTA Z
FRAMSNXZ
	SLL	1,A1
	JRNC	FRAMSNY
	ADDK	16,A9			;DELTA Y
FRAMSNY
	SLL	3,A1
	JRNC	FRAMSNNSA
	MOVE	*A9,A9,L		;JUMP TO NEW FRAME
FRAMSNNSA:
FRAMSANI:
	CLRC	
	JRUC	FRAMSND
FRAMSSC
	SETC
FRAMSND
	MMFM	SP,A1
	RETS


**************************************************************************
*                                                                        *
* AUTOEOFF - TURN OFF AUTO ERASE					                    *
* NOTE: BE SURE THE DIRQ IS OFF BEFORE CALLING				          *
*                                                                        *
**************************************************************************
AUTOEOFF
	PUSH	A0
	PUSHST
	DINT
	MOVE	@SYSCOPY,A0,W
	ORI	AUTOERAS,A0  	;DISABLE AUTO ERASE
	MOVE	A0,@SYSCOPY,W	;STORE EVERYWHERE I DID GO
	POPST
	MOVE	A0,@SYSCTRL,W
	PULL	A0
	RETS

**************************************************************************
*                                                                        *
* AUTOEON - TURN ON AUTO ERASE					 	               *
* NOTE: BE SURE THE DIRQ IS OFF BEFORE CALLING				          *   
*                                                                        *
**************************************************************************
AUTOEON
	PUSH	A0
         MOVE	@NOAUTOE,A0,W
	JRNE	AUTOEON1	;BR = DEBUGGER MAN SAYS NO AUTOERASE
	PUSHST
	DINT
	MOVE	@SYSCOPY,A0,W
	ANDNI	AUTOERAS,A0  	;AUTO ERASE IS ENABLED LOW
	MOVE	A0,@SYSCOPY,W	;STORE EVERYWHERE I DID GO
	POPST
	MOVE	A0,@SYSCTRL,W
AUTOEON1
	PULL	A0
	RETS

**************************************************************************
*                                                                        *
* COPYOBJ - COPIES THE CONTENTS OF ONE OBJECT BLOCK TO THE OTHER.	     *
* A0 = PTR TO DESTINATION BLOCK						               *
* A8 = PTR TO SOURCE BLOCK						               *
*                                                                        *
**************************************************************************
COPYOBJ
	MMTM	SP,A0,A6,A8
	MOVI	OBSIZ,A6,W	;GET THE SIZE OF THE BLOCK IN WORDS
	ADDI	64,A0
	ADDI	64,A8		;DON'T COPY THE LINKS
	SRL	4,A6		;DIVIDE BY 16		
	SUBK	4,A6		;SUBTRACT TO ACCOUNT FOR THE 1st TWO LINKS
COPYOBJL
	MOVE	*A8+,*A0+,W	;MOVE A WORD
	DSJS	A6,COPYOBJL
	MMFM	SP,A0,A6,A8
	PUSH	A6		;KLUDGE TO ZERO MISPLACED LINKS
	CLR	A6
	MOVE	A6,*A0(OSHAD),L
	PULL	A6
	RETS

*****************************************************
*
*AUTO-ANIMATOR
*A13=PLAYER PROCESS
*A8=PLAYER OBJECT
*A9=CURRENT ANI SCRIPT
*A10=CURRENT SCRIPT BASE
*
AUTOANI:
	MOVE	*A13(P_GOAL),A0,L
	JRNE	AUTOBL			;ACTIVE GOAL
	MOVE	*A13(PLGOZ),A0,W
	JRNE	AUTOZ

*GO UNTIL X COORD GOAL
AUTOX:
	MOVE	*A8(OXPOS),A0,W	    	;CURRENT XPOS
	MOVE	*A13(PLGOX),A1,W	;GOAL
	MOVE	*A8(OXVEL+>10),A2,W	;DIRECTION TO ACHEIVE
	SUB	A1,A0
	XOR	A0,A2
	JRN	AUTOEND			;WE MADE IT TO THE END
	JRUC	AUTOSLL

*GO UNTIL Z COORD GOAL
AUTOZ:
	MOVE	*A13(PLGOX),A0,W	;GOAL
	JRNE	AUTOXZ
	MOVE	*A8(OZPOS),A0,W	    	;CURRENT XPOS
	MOVE	*A13(PLGOZ),A1,W	;GOAL
	MOVE	*A8(OZVEL+>10),A2,W	;DIRECTION TO ACHEIVE
	SUB	A1,A0
	XOR	A0,A2
	JRN	AUTOEND			;WE MADE IT TO THE END
	JRUC	AUTOSLL

*GO UNTIL COMBINED X,Z GOAL
AUTOXZ:
	MOVE	*A8(OXPOS),A0,W	    	;CURRENT XPOS
	MOVE	*A13(PLGOX),A1,W	;GOAL
	MOVE	*A8(OXVEL+>10),A2,W	;DIRECTION TO ACHEIVE
	SUB	A1,A0
	XOR	A0,A2
	JRN	AUTOXZ1			;WE MADE IT TO THE END
	JRUC	AUTOSLL
*GO UNTIL Z COORD GOAL
AUTOXZ1:
	MOVE	*A8(OZPOS),A0,W	 	   	;CURRENT XPOS
	MOVE	*A13(PLGOZ),A1,W	     ;GOAL
	MOVE	*A8(OZVEL+>10),A2,W		;DIRECTION TO ACHEIVE
	SUB	A1,A0
	XOR	A0,A2
	JRN	AUTOEND				;WE MADE IT TO THE END
	JRUC	AUTOSLL

*SEEK OFFSET FROM BALL
AUTOBL:
	MOVE	*A13(P_GOAL),A0,L 		;ARE WE AT GOAL OFFSET?
	MOVE	*A0(OXPOS),A1,W
	MOVE	*A0(OSIZEX),A2,W
	SRL	1,A2
	ADD	A2,A1			     ;SEEK CENTER
	MOVE	*A0(OZPOS),A2,W
	MOVE	*A13(PLGOX),A3,W
	ADD	A3,A1
	MOVE	*A13(PLGOZ),A3,W
	ADD	A3,A2
	MOVE	*A8(OXPOS),A3,W
	MOVE	*A8(OSIZEX),A4,W
	SRL	1,A4
	ADD	A4,A3			     ;SEEK CENTER
	MOVE	*A8(OZPOS),A4,W
	SUB	A3,A1
	SUB	A4,A2
	ABS	A1
	ABS	A2
	CMPI	4,A1
	JRHS	AUTOBLOF1
	CMPI	4,A2
	JRLS	AUTOEND	 			;WE ARE THERE
AUTOBLOF1:
	MOVI	100,A0
	CALLA	RANDPER
	JRNC	AUTOSLL
AUTOBLOFST:
	MOVE	*A13(P_GOAL),A0,L
	MOVE	*A13(PLGOX),A1,W
	MOVE	*A13(PLGOZ),A2,W
	CALLA	XZSKOBOF			;GET NEW SEEK VELOCITIES
	MOVE	A5,*A8(OXVEL),L
	MOVE	A6,*A8(OZVEL),L		 	;STORE 'EM
	CALLA	SHVELCPY
	CALLA	GETADIR				;GET ANIMATION DIRECTION
	JRUC	AUTOSLL
AUTOSLL
	DECW	*A13(P_ANICOUNT)
	JRNE	AUTOSLP
	MOVE	*A13(P_ANIRATE),*A13(P_ANICOUNT),W
AUTOSL1:
	MOVK	4,A1
	JSRP	FRANIM
	JRNC	AUTOSLP			;NOT END OF SCRIPT CONTINUE
	MOVE	A10,A9
	JRUC	AUTOSL1			;RESET SCRIPT TO BEGINNING
AUTOSLP	
	SLOOP	1,AUTOANI
AUTOEND	RETP


GETDIRAC
	MMTM	SP,A1,A2,A3,A4,A5,A6,A7
         MOVE    *A8(OXACC),A1,L
         MOVE    *A8(OZACC),A2,L
         JRUC    GAD0

*
* GET ANIMATION DIRECTION
* A8=OBJECT
* A9=CURRENT SCRIPT POINTER
* A10=CURRENT SCRIPT BASE
* A13(P_ANITAB)=ANIMATION TABLE BASE
*
GETADIR:
	MMTM	SP,A1,A2,A3,A4,A5,A6,A7
	MOVE	*A8(OXVEL),A1,L
	MOVE	*A8(OZVEL),A2,L
GAD0
	MOVE	A1,A3
	MOVE	A2,A4
	ABS	A3		;UNSIGNED COMPARE
	ABS	A4
	MOVE	A3,A5
	ADD	A4,A5
	JRNE	GAD1
	CLR	A3		;STANDING CASE			  
	JRUC	GETADX
GAD1
	MOVK	3,A5
	MOVK	3,A7
	MPYU	A3,A5 		;CALC 3*X
	MPYU	A4,A7		;CALC 3*Y
	CMP	A7,A3		;XV GT 3*YV ?
	JRHS	GADX
	CMP	A5,A4
	JRHS	GADZ
*DIAGONAL XZ VELOCITY CASE
	SRL	31,A1 		;4 QUADRANTS= 0-3
	SRL	31,A2
	SLL	1,A2
	ADD	A1,A2
	ADDK	5,A2
	MOVE	A2,A3
	JRUC	GETADX
*X VELOCITY CASE
GADX
	MOVK	1,A3
	MOVE	A1,A1
	JRNN	GETADX 		;XV + CASE
	MOVK	2,A3
	JRUC	GETADX
*Z VELOCITY CASE
GADZ	
	MOVK	3,A3
	MOVE	A2,A2
	JRNN	GETADX
	MOVK	4,A3
*HAVE OFFSET IN A3, LOAD UP THE NEW ANIMATION FROM TABLE
GETADX
	SLL	5,A3
	MOVE	*A13(P_ANITAB),A2,L
	ADD	A2,A3
	MOVE	*A3,A3,L
	CMP	A3,A10		;NEW SCRIPT?
	JREQ	GETADXX		;NOPE...DON'T RESET IT !!!
	MOVE	A3,A9		;YES, RESET FOR NEW SCRIPT
	MOVE	A9,A10
GETADXX
	MMFM	SP,A1,A2,A3,A4,A5,A6,A7
	RETS
*
*SEEK OBJECT WITH OFFSET
*A0=OBJECT SEEKED
*A1=X OFFSET
*A2=Y OFFSET
*A8=OBJECT SEEKING
XZSKOBOF
	MOVE	*A0(OXPOS),A5,W
	MOVE	*A0(OSIZEX),A6,W
	SRL	1,A6
	ADD	A6,A5			;SEEK CENTER
	MOVE	*A0(OZPOS),A6,W
	ADD	A1,A5
	ADD	A2,A6
	JRUC	XZSEEK

*SEEK XZ OF ACTIVE OBJECT
*A8=OBJECT SEEKING
*A0=OBJECT SEEKED
*
XZSKOBJ
	MOVE	*A0(OXPOS),A5,W
	MOVE	*A0(OSIZEX),A6,W
	SRL	1,A6
	ADD	A6,A5			;SEEK CENTER
	MOVE	*A0(OZPOS),A6,W
*	
*SEEK X-Z COORDINATE
*A8=OBJECT SEEKING
*A5=X COORD TO SEEK
*A6=Z COORD TO SEEK
*RETURNS
*A5=X VEL
*A6=Z VEL
*
XZSEEK
	MMTM	SP,A0,A1,A2,A3,A4,A7
	MOVE	*A8(OXPOS),A3,W
	MOVE	*A8(OSIZEX),A4,W
	SRL	1,A4
	ADD	A4,A3			;SEEK CENTER
	MOVE	*A8(OZPOS),A4,W
	SUB	A3,A5		;FIND DIFFERENCE
	SUB	A4,A6
	MOVE	A6,A3		;SAVE THE SUCKERS
	MOVE	A5,A1
	ABS	A5
	ABS	A6
	ADD	A5,A6		;CALC SUM ABS(DX+DY)
	SLL	16,A1		;SHIFT TO ACCOMODATE FRACTIONAL VELOCITY
	SLL	16,A3
	DIVS	A6,A1 		;GENERATE SPEED RATIOS
	DIVS	A6,A3
	MOVE	A1,A2
	ABS	A2
	SLL	16,A2
	SRL	28,A2		;CORRECT FOR SQUARE ROOT
	SLL	4,A2
	ADDI	XZSQTAB,A2
	MOVE	*A2,A2,W
	MOVI	2,A5		;MULTIPLY BY VELOCITY FACTOR
	MPYU	A2,A5
	MPYS	A5,A3
	MPYS	A1,A5 		;FINAL X VEL
	SRA	4,A3
	SRA	4,A5
	MOVE	A3,A6		;FINAL Y VEL
	MMFM	SP,A0,A1,A2,A3,A4,A7
	RETS
*CORRECT FOR ANGULAR VELOCITIES
XZSQTAB	.WORD	>10,>11,>12,>13,>14,>15,>16,>17
	.WORD	>17,>16,>15,>14,>13,>12,>11,>10

**************************************************************************
*                                                                        *
* GPALOBJ - GET A PALETTE AND AN OBJECT BLOCK				          *
* A14 = PTR TO PLAYER INITIALIZATION TABLE.				          *
* RETURNS:								               *
* A0 = PTR TO OBJECT							               *
* Z BIT SET = FAILURE,A0 = 0						               *   
*                                                                        *
**************************************************************************
;GPALOBJ
;	PUSH	A2
;	CALLA	GETOBJ
;	JRZ	GPLOXX			; OBJECT BLOCK FAILURE
;
;         CALLA	STRTOBJ			; STUFF IT 
;
;	MOVE	A0,-*SP,L		; SAVE A0
;  	MOVE	*A0(OIMG),A0,L
;  	MOVE	*A0(ICMAP),A0,L		; GET PALETTE NAME
;	CALLR	GETFPAL			; GET A PALETTE
;	JRZ	GPALOBJX		; NONE AROUND
;	MOVE	A0,A2
;	MOVE	*SP+,A0,L
;	MOVE	A2,*A0(OPAL),W
;	JRUC	GPLOXX
;GPALOBJX
;	CALLA	FREEOBJ
;	CLR	A0
;	MMFM	SP,A0
;GPLOXX
;	MMFM	SP,A2
;	RETS

**************************************************************************
*								         *
* 	FADEALL								 *
* 									 *
* 	FADE EVERYTHING USING A GIVEN FADE ENTRY			 *
* 									 *
* 	ENTRY								 *
* 		A0	LIST OF PALETTES				 *
* 		A11	FADE MULT TABLE					 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
* 									 *
* 	CALL								 *
* 		CALL							 *
*								         *
**************************************************************************

FADEALL:
	mmtm	SP,A0,A1,A2,A6,A7,A8,A9,A11
	JRUC	Fader

**************************************************************************
*								         *
* 	FADEIN								 *
* 									 *
* 	FADE A LIST OF PALETTES FROM BLACK TO THEIR CURRENT COLORS	 *
* 									 *
* 	ENTRY								 *
* 		A0	PTR TO NULL TERMINATED LIST **NOT** TO FADE	 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

FADEIN:
	mmtm	SP,A0,A1,A2,A6,A7,A8,A9,A11
	movi	FadeIn,A11
	jruc	Fader

**************************************************************************
*								         *
* 	FADEOUT								 *
* 									 *
* 	FADE A LIST OF PALETTES DOWN TO BLACK				 *
* 									 *
* 	ENTRY								 *
* 		A0	PTR TO NULL TERMINATED LIST **NOT** TO FADE	 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

FADEOUT:
	mmtm	SP,A0,A1,A2,A6,A7,A8,A9,A11
	movi	FadeOut,A11

Fader:
	move	A0,A6		

;* WALK EUGENES PALETTE TABLE, START PROC TO FADE EACH PALETTE *
	clr	A9		;palette slot
	dec	A9
	movi	PALRAM-PALRSIZ,A2	;base of eugenes palette table
PalLp:
	addi	PALRSIZ,A2
	inc	A9
	cmpi	NUMPAL,A9
	jrge	PalLpX

	move	*A2(PALCNT),A1,W	;is palette allocated?
	jrz	PalLp
	move	*A2(PALID),A8,L		;Ptr to palette
;*** SKIP FADING PALS IN LIST POINTED TO BY A6
	move	A6,A7
	jrz	SkFPalX
SkPalLp:
	move	*A7+,A1,L
	jrz	SkFPalX
	cmp	A1,A8
	jreq	PalLp
	jruc	SkPalLp
SkFPalX:
	CREATE	PID_FX,FADEPROC
	jruc	PalLp
PalLpX:

	mmfm	SP,A0,A1,A2,A6,A7,A8,A9,A11
	rets


**************************************************************************
*								         *
* 	FADE_ONLY							 *
* 									 *
* 	FADE ONLY A CERTAIN PALETTE					 *
* 									 *
* 	ENTRY								 *
* 		A0	PALETTE TO BE FADED				 *
* 		A11	MULTIPLIER FOR PALETTES				 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
* 									 *
* 	CALL								 *
* 		CALLA							 *
*								         *
**************************************************************************

FADE_ONLY:
	mmtm	SP,A0,A1,A2,A6,A7,A8,A9,A11
	move	A0,A6		

;* WALK EUGENES PALETTE TABLE, START PROC TO FADE EACH PALETTE *

	clr	A9		;palette slot
	dec	A9
	movi	PALRAM-PALRSIZ,A2	;base of eugenes palette table
FOPalLp:
	addi	PALRSIZ,A2
	inc	A9
	cmpi	NUMPAL,A9
	jrge	FOPalLpX

	move	*A2(PALCNT),A1,W	;is palette allocated?
	jrz	FOPalLp
	move	*A2(PALID),A8,L		;Ptr to palette
	CMP	A6,A8
	JRNZ	FOPalLp			; BR = NOT THE ONE FOR ME
	CREATE	PID_FX,FADEPROC
	jruc	FOPalLp
FOPalLpX:
	mmfm	SP,A0,A1,A2,A6,A7,A8,A9,A11
	rets


**************************************************************************
*								         *
* 	FADEPROC							 *
* 									 *
* 	PROCESS TO ACTUALLY FADE A PALETTE				 *
* 									 *
* 	ENTRY								 *
* 		A8	PTR TO PALETTE TO BE FADED			 *
* 		A9	PALETTE SLOT OF PALETTE				 *
* 		A11	FADE MULTIPLIER TABLE				 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
*								         *
**************************************************************************

FADEPROC:
	sll	24,A9		;B8-15 DEST PAL | B0-7 START COLOR	
	srl	16,A9

	.IF	YUNIT
         MOVE    A9,A2
         SRL     12,A2
         SLL     14,A2
         SLL     20,A9
         SRL     20,A9
         ADD     A2,A9
         .ENDIF

FadePLp:
	;**** SET UP FADED PAL IN PROCESS DATA SPACE ****
	move	*A11+,A2,W	;A2 - Color Multiplier
	jrn	FadePrcX
	move	A13,A0
	addi	PDATA,A0	;A0 - Dest Ram for Pal
	move	A8,A1		;A1 - Src for Pal
	callr	FadePal

	;**** GET FADED PALETTE XFERRED TO PALRAM ****
	move	A9,A1		;B8-15 DEST PAL | B0-7 START COLOR
	move	A13,A0
	addi	PDATA,A0	;SRC FOR XFER
	move	*A0+,A2,W	;GET # COLORS IN PALETTE
	calla	PALSET		;SETUP PALETTE TRANSFER

	SLEEP	1
	jruc	FadePLp

FadePrcX:
	SLEEP	1		;give last xfer a chance to go
	DIE

**************************************************************************
*								         *
* 	FADEPAL								 *
* 									 *
* 	APPLY THE COLOR MULTIPLIER AND DO ONE ITERATION ON THE PALETTE	 *
* 									 *
* 	ENTRY								 *
* 		A0	DESTINATION RAM FOR PALETTE			 *
* 		A1	SOURCE FOR PALETTE				 *
* 		A2	COLOR MULTIPLIER				 *
* 									 *
* 	EXIT								 *
* 		NOTHING							 *
* 									 *
* 	NOTE:	EACH COLOR IN PALETTE WILL BE MULTIPLIED BY A2 THEN 	 *
* 		DIVIDED BY 128						 *
*								         *
**************************************************************************

FadePal:
	mmtm	SP,A8,A9,A10,A11

	move	*A1+,A14,W
	move	A14,*A0+,W
	sll	23,A14		;top bits of field are flags
	srl	23,A14		;	only 9 bits needed for # colors

	movi	>7C00,A4	;A4 - Pre Mult Mask for 5 bits of red
	movi	>03E0,A6	;A6 - Pre Mult Mask for 5 bits of green
	movi	>001F,A8	;A8 - Pre Mult Mask for 5 bits of blue
	move	A4,A9
	move	A6,A10
	move	A8,A11
	sll	7,A9		; A9 - Post Mult Max for 5 bits of red
	sll	7,A10		;A10 - Post Mult Max for 5 bits of green
	sll	7,A11		;A11 - Post Mult Max for 5 bits of blue

FadeLp:
	move	*A1+,A3,W	;A3 - RED
	move	A3,A5		;A5 - GREEN
	move	A3,A7		;A7 - BLUE
	and	A4,A3
	and	A6,A5
	and	A8,A7
	mpyu	A2,A3
	mpyu	A2,A5
	mpyu	A2,A7
	cmp	A9,A3
	jrle	RedOk
	move	A9,A3
RedOk:
	cmp	A10,A5
	jrle	GreenOk
	move	A10,A5
GreenOk:
	cmp	A11,A7
	jrle	BlueOk
	move	A11,A7
BlueOk:
	and	A9,A3
	and	A10,A5
;	and	A11,A7	;unnecessary cause bottom bits will get >> 7

	or	A5,A3
	or	A7,A3
	srl	7,A3
	move	A3,*A0+,W
	dsjs	A14,FadeLp
	
	mmfm	SP,A8,A9,A10,A11
	rets

FadeIn	.word	0,0,8,16,24,32,40,48,56,64,72,80,88,96,104,112,120,128,>FFFF
FadeOut	.word	120,112,104,96,88,80,72,64,56,48,40,32,24,16,8,0,>FFFF

