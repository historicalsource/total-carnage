	.TITLE	'FBSTUFF.ASM'
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

; ROUTINES STOLEN FROM HIGH IMPACT FOOTBALL	
;
; INITIATED:		 JAN 10,1991
; MODIFIED:		 !
; SOFTWARE:		 MARK TURMELL
;
; COPYRIGHT (C) 1989 WILLIAMS ELECTRONICS GAMES, INC.
;
;
; GET THE SYSTEM STUFF

	.INCLUDE	"MPROC.EQU"		;MPROC EQUATES
	.INCLUDE	"\VIDEO\SYS\SYS.INC"	;Z UNIT SYSTEM EQUATES
	.INCLUDE	"\VIDEO\SYS\MACROS.HDR"	;MACROS DEFINITIONS
	.INCLUDE	"GAME.EQU"
;
;SOUNDS
;
;
;SYMBOLS EXTERNALLY DEFINED
;
	.REF	PALSET,PALRAM
;
;SYMBOLS DEFINED IN THIS FILE
;
	.DEF	FB_FADEOUT,FB_FADEIN

PID_FX	.EQU	200

	.TEXT

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

FB_FADEIN:
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

FB_FADEOUT:
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

	SLEEP	2
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

	.END

