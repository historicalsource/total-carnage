**************************************************************
* GSP MULTI-PROCESSING SYSTEM
*
* Software:		Eugene P Jarvis
* Initiated:		1988?
*
* Modified:		Shawn Liptak, 7/?/91	-New KILL stuff
* 			Shawn Liptak, 8/12/91	-KOP code
* 			Shawn Liptak, 10/27/91	-Shawn.hdr
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 1/8/92 20:22
**************************************************************
	.FILE	'MPROC.ASM'
	.TITLE	"GSP MULTI-PROCESSING SYSTEM"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST


* FILES REQUIRED FOR ASSEMBLY

	.INCLUDE	\VIDEO\SYS\GSP.INC	;GSP ASSEMBLER EQUATES
	.INCLUDE	\VIDEO\SYS\SYS.INC	;ZUNIT SYSTEM EQUATES
	.INCLUDE	\VIDEO\SYS\MACROS.HDR	;MACROS
	.INCLUDE	MPROC.EQU
	.INCLUDE	DISP.EQU
	.include	"shawn.hdr"		;My macros

*	SET UP FIXED PARAMETERS AT THE BEGINNING OF SCRATCHPAD

	.REF	L_TIMER			;AUDIT


	.SECT	"FIXED"
ACTIVE	.LONG	0
FREE	.LONG	0


*GLOBAL PROCESS VARIABLES

	.BSS	TIMER,16		;IRQ TIMER 16 MSEC.
	.BSS	TIMETEMP,16		;LAST TIMER VALUE
	.BSS	OVERLOAD,16		;OVERLOAD CHECKER
	.BSS	PRCSTR,NPROC*PRCSIZ	;PROCESS STORE ALLOCATION

*MULTI-PROCESSING PROGRAM

	.TEXT			;STORE IN PROGRAM ROM

********************************
*PROCESS DISPATCH

PRCDSP
	MOVI	ACTIVE,A13,L	;LONG WORD INIT SCAN PROCESS LIST

PRCWTSRT
	CALLA	YZSORT		;SORT DISPLAY LIST

	MOVE	@TIMER,A0
	JREQ	PRCWTSRT	;BR = WAIT FOR TIMING FROM INTERRUPT, SORT
	MOVE	A0,@TIMETEMP	;SAVE

	SLL	1,A0
	MOVE	@OVERLOAD,A1,W
	ADD	A0,A1
	SRL	1,A1
	MOVE	A1,@OVERLOAD,W

	CALLA	L_TIMER			;linky timer

	CLR	A0
	MOVE	A0,@TIMER
	JRUC	PRCD1

********************************
*PROCESS SLEEP
*TOS IS WAKEUP ADDR ,A0 = SLEEP TIME

PRCSLP
	move	*SP+,A7,L		;CALLING PC->A7

	.if	DEBUG
;	.ref	WSPEED
;	move	@WSPEED,a1
;	jrge	wspdok
;	LOCKUP
;	EINT
;wspdok
	.endif

PRCLSP	move	A13,A1
	addi	PDATA,A1
	mmtm	A1,A7,A8,A9,A10,A11,A12 ;wakeup, regs, stack ptr
	move	A0,-*A1			;sleep

	.if	DEBUG
	MOVE	A13,A0
	ADDI	PSDATA,A0
	CMP	A0,A12
	JRLT	$			;Stick on Stack overflow
	ADDI	PRCSIZ-PSDATA,A0
	CMP	A0,A12
	JRGT	$			;Stick on Stack underflow
	.endif

PRCD1
************************************
*	MOVE	@TIMETEMP,A1,W		;GET THE LAST TIMER VALUE
************************************
PRCD1A
	MOVE	*A13,A13,L
	JREQ	PRCDX		;NULL LIST, EXIT
	MOVE	*A13(PTIME),A0	;GET COUNT
**************************************************************************
*	SUB	A1,A0
**************************************************************************
	DEC	A0		;DECREMENT COUNT	
	MOVE	A0,*A13(PTIME)	;PUT IT BACK
	JRGT	PRCD1A		;NOT READY, LOOP FOR NEXT

*PROCESS IS READY FOR DISPATCH

PRCD2	move	A13,A1
	addi	>40,A1
	mmfm	A1,A7,A8,A9,A10,A11,A12	;wake, regs, stack ptr
	jump	A7			;fire off proc

*DONE WITH THE SCAN

PRCDX	RETS

********************************
*PROCESS SUICIDE

SUCIDE
	MOVI	ACTIVE,A1,L
SUCLP	MOVE	A1,A2		;SAVE PREVIOUS
	MOVE	*A1,A1,L
	jrz	sucerr

	CMP	A1,A13		;CHECK FOR MATCH TO CURRENT PROCESS
	JRNE	SUCLP		;NOT FOUND KEEP LOOKING
	MOVE	*A1,*A2,L	;LINK AROUND IN ACTIVE LIST
	MOVE	@FREE,A0,L	;GET FREE POINTER
	MOVE	A0,*A1,L	;LINK INTO FREE LIST AT START
	MOVE	A1,@FREE,L
	MOVE	A2,A13		;SET CURRENT PROCESS TO PREVIOUS
	JRUC	PRCD1		;CONTINUE WITH DISPATCH

sucerr 
	.if	DEBUG		;this is for DEBUG only
	LOCKUP
	EINT
	.ELSE
	CALLERR	5,0
	.endif
	JRUC	PRCDSP		;RESOLVE?


********************************
*PROCESS LIST INITIALIZE
*A13 RETURNED POINTING TO ACTIVE LIST (CRPROC)

PINIT
	MMTM	SP,A0,A1,A2,A3	;SAVE REG
	MOVI	NPROC,A3,W	;# OF PROCESSES TO INIT
	CLR	A0
	MOVE	A0,@ACTIVE,L	;NULL ACTIVE LIST
	MOVI	PRCSTR,A1,L
	MOVE	A1,@FREE,L	;SETUP FREE LIST
PINITL
	MOVE	A1,A2
	ADDI	PRCSIZ,A1,W
	MOVE	A1,*A2,L	;LINK EM UP
	DSJS	A3,PINITL	;CONTINUE FOR NPROC
	MOVE	A0,*A2,L	;ZERO LAST LINK
	MOVI	ACTIVE,A13,L	;INIT CURRENT PROCESS
	MMFM	SP,A0,A1,A2,A3	;RESTORE REGS
	RETS

********************************
*KILL PROCESS
*A0 POINTS TO PROCESS TO KILL
*IF PROCESS NOT PRESENT, CAUSES ERROR
*TO KILL YOURSELF SUCIDE MUST BE USED,
*IF YOU ATTEMPT TO KILL YOURSELF IT WILL JUST RETURN

KILL
	CMP	A0,A13		;KILLING YOURSELF?
	JREQ	KILLXXX		;BR = YES, JUST ESCAPE
	PUSH	a1,a2

;	.IF	DEBUG
;HULKPID         .EQU    142
;	MOVE	*A0(PROCID),A1
;	CMPI	HULKPID,A1
;	JRNZ	KL2
;	LOCKUP
;	EINT
;KL2
;	.ENDIF

	MOVI	ACTIVE,A1,L

KILLP	MOVE	A1,A2		;SAVE PREVIOUS
	MOVE	*A1,A1,L
	JRZ	killerr

	CMP	A1,A0
	JRNE	KILLP		;NOT FOUND KEEP LOOKING
	MOVE	*A0,*A2,L	;LINK AROUND IN ACTIVE LIST	
	MOVE	@FREE,A1,L	;LINK INTO FREE LIST AT START
	MOVE	A1,*A0,L
	MOVE	A0,@FREE,L

KILLX	PULL	a1,a2

KILLXXX	RETS

killerr
	.IF	DEBUG
	LOCKUP
	EINT
	.ELSE
	CALLERR	6,2
	.ENDIF
	JRUC	KILLX


********************************
* CREATE A PROCESS
* A1=ID,A7=PC,A8,A9,A10,A11 Passed parameters
* A13=*Current process
* Rets: A0=*Created process (Flags invalid!)

GETPRC
	PUSH	a2,a12
	MOVE	@FREE,A0,L
	JREQ	NONELFT		;NONE AVAILABLE
	MOVE	*A0,A2,L
	MOVE	A2,@FREE,L	;REMOVE FROM FREE LIST
	MOVE	*A13,*A0,L	;LINK INTO ACTIVE LIST AFTER CURRENT PROCESS
	MOVE	A0,*A13,L	;CRPROC>>NEW PROC
	JRUC	XFERPRC0

NONELFT
	.IF	DEBUG
	LOCKUP
	EINT
	.ELSE
	CALLERR	4,2
	.ENDIF
	JRUC	GETPX

********************************
* XFERPROC - TRANSFER CONTROL OF AN EXISTING PROCESS
* A0= PTR OF PROCESS TO BE XFER'D
* A1= NEW I.D.
* A7= WAKE UP
* A8-A11= PASSED TO THE XFER'D PROC

XFERPROC
	PUSH	a2,a12
XFERPRC0
	cmpi	>ffc00000,a7		;ffe for 256K
	jrlo	procwakeerr		;Error?

	move	a0,a2
	addi	PDATA,a2
	move	A0,A12			;RESET PROCESS STACK POINTER
	addi	PRCSIZ,A12
	mmtm	a2,a7,a8,a9,a10,a11,a12	;Stuff wake, regs, p stack ptr
	movk	1,A12
	move	A12,-*A2		;WAKE UP AS SOON AS POSSIBLE
	move	A1,-*A2			;ID

GETPX	PULL	a2,a12
	rets				;Flags are trashed!!!

procwakeerr
	.IF	DEBUG
	LOCKUP
	EINT
	.ELSE
	CALLERR	7,2
	.ENDIF
	JRUC	GETPX

********************************
* KILL A CLASS OF PROCESSES (Old, for compatibility)
* A0=PROCID (16 BITS) ,A1=MASK (16 BITS, bits to keep)
* WILL NOT KILL CALLING PROCESS (A13)

KILALL	PUSH	a0,a1,a2,a3,a4
	not	a1
	jruc	kilan


********************************
* Kill one class of processes

KIL1C 	;A0=PROCID, A1=Trashed

	clr	a1

********************************
* Kill a class of processes

KILALLN	;A0=PROCID, A1=!Mask (Bits to remove)

	PUSH	a0,a1,a2,a3,a4
kilan	andn	a1,a0		;Form match
	MOVI	ACTIVE,A2,L

KILALP	MOVE	A2,A3		;SAVE PREVIOUS
	MOVE	*A2,A2,L	;GET NEXT
	JREQ	KILALX		;ALL DONE
	MOVE	*A2(PROCID),A4
	andn	a1,a4		;Can dont care bits
	CMP	A0,A4		;MATCH?
	JRNE	KILALP		;NO

	CMP	A2,A13		;CURRENT PROCESS?
	JREQ	KILALP		;YES DONT KILL

	MOVE	*A2,*A3,L	;LINK AROUND IN ACTIVE LIST	
	MOVE	@FREE,A4,L	;LINK INTO FREE LIST AT START
	MOVE	A4,*A2,L
	MOVE	A2,@FREE,L	;POINT FREE TO CELL
	MOVE	A3,A2
	JRUC	KILALP		;KILL THE REST

KILALX	PULL	a0,a1,a2,a3,a4
	RETS


********************************
* Knock out one class of processes

KOP_1C 	;A0=PROCID, A2=Time to add

	clr	a1

********************************
* Knock out a class of processes

KOP_ALL	;A0=PROCID, A1=!Mask (Bits to remove), A2=Time to add

	PUSH	a3,a4
	andn	a1,a0		;Form match
	movi	ACTIVE,a3,L

koplp	move	*a3,a3,L	;Get next
	jrz	kopx		;End?
	move	*a3(PROCID),a4
	andn	a1,a4		;Mask
	cmp	a0,a4
	jrnz	koplp		;No match?

	move	*a3(PTIME),a4	;Add sleep
	add	a2,a4
	move	a4,*a3(PTIME)
	jruc	koplp

kopx	PULL	a3,a4
	rets


********************************
*CHECK TO SEE IF PROCESS IN A0 EXISTS
*RETURNS:
* Z BIT SET = NO MATCH, A0 = 0
* Z BIT CLR = MATCH,	A0 = PTR TO PROCESS

PEXIST
	PUSH	a2
	MOVI	ACTIVE,A2,L

ISOBP	MOVE	*A2,A2,L	;GET NEXT
	JREQ	ISOBX		;ALL DONE
	CMP	A0,A2		;PROC?
	JRNE	ISOBP		;NO
	MOVE	A0,A0		;CLR Z BIT
ISOBX	MMFM	SP,A2
	RETS

********************************
*FIND IF AT LEAST ONE PROCESS, OTHER THAN CALLING PROCESS,
*EXISTS.
*A0=PROCID (16 BITS) ,A1=MASK (16 BITS)
*MASK BITS OF ZERO ARE DONT CARES
*RETURNS:
* Z BIT SET = NO MATCH, A0 = 0
* Z BIT CLR = MATCH,	A0 = PTR TO PROCESS

EXISTP
	PUSH	a1,a2,a4
	SEXT	A0
	AND	A1,A0		;FORM MATCH
	MOVI	ACTIVE,A2,L

EXNXT
	MOVE	*A2,A2,L	;GET NEXT
	JREQ	EXSC		;ALL DONE
	MOVE	*A2(PROCID),A4
	AND	A1,A4		;CAN DONT CARE BITS
	CMP	A0,A4		;MATCH?
	JRNE	EXNXT		;NO

	CMP	A2,A13		;CURRENT PROCESS?
	JREQ	EXNXT		;YES, THEN WE DON'T CARE
EXSC
	MOVE	A2,A0
	PULL	a1,a2,a4
	RETS

********************************
* GET A PRESERVED REGISTER FROM A SLEEPING PROCESS
* A0=*SLEEPER

GETA11	move	*A0(PA11),A11,L
	RETS
GETA10	move	*A0(PA10),A10,L
	RETS
GETA9	move	*A0(PA9),A9,L
	RETS
GETREGS
	move	*A0(PA11),A11,L
	move	*A0(PA10),A10,L
	move	*A0(PA9),A9,L
GETA8	move	*A0(PA8),A8,L
	RETS
GETWAKE	move	*A0(PWAKE),A7,L
	RETS

PUTA11	move	A11,*A0(PA11),L
	RETS
PUTA10	move	A10,*A0(PA10),L
	RETS
PUTA9	move	A9,*A0(PA9),L
	RETS
PUTREGS
	move	A11,*A0(PA11),L
	move	A10,*A0(PA10),L
	move	A9,*A0(PA9),L
PUTA8	move	A8,*A0(PA8),L
	RETS
PUTA7
PUTWAKE	move	A7,*A0(PWAKE),L
	RETS


	.END
