**************************************************************
*
* Software:		LARRY DEMAR and DR. J
* Initiated:		?
*
* Modified:		Shawn Liptak, 11/1/91	-Total carnage
* 			Shawn Liptak, 1/20/92	-Coinage from T2, Dipswitch
* 			Shawn Liptak, 1/24/92	-Coinage corrections
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 3/6/92 16:35
**************************************************************
	.FILE	'MENU.ASM'
	.TITLE	"TEST MENUS"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST


	.INCLUDE	"MPROC.EQU"
	.INCLUDE	"DISP.EQU"
	.INCLUDE	"\VIDEO\SYS\SYS.INC"
	.INCLUDE	"IMGTBL.GLO"
	.INCLUDE	"GAME.EQU"
	.INCLUDE	"LINK.EQU"
	.INCLUDE	"MENU.EQU"
	.include	"shawn.hdr"		;Macros

	.TEXT

;	 IN THIS MODULE

	.DEF	FACCHECK	
	.DEF	MEN_MAIN,GET_CSPT
	.DEF	MESS_FAC
	.DEF	ANY_BUT,MEN_YN
	.DEF	STR_OBJ
	.DEF	STR_FREE
	.DEF	CKPROMPT
	.DEF	GO_DIAG		;ROUTINE FOR DIAGNOSTIC MENU
	.DEF	RTR_LEV,ROM_LEV
	.DEF	MESS_MM
	.DEF	CS_ENTS		;NUMBER OF HIGHEST IN COIN TABLE
	.DEF	TWO_TS,TWO_TP
	.DEF	FAC_STUF
	.DEF	BUILD_ST
	.DEF	SCODE		;SYNTH CODE CURRENTLY BEING MADE
	.DEF	DCODE		;DIG CODE CURRENTLY BEING MADE
	.DEF	HID_P

;	 IN TEST.ASM

	.REF	WDOGDIS,GETFPAL
	.REF	GEN_MENU,B_MENU
	.REF	L_MESS,TOP_BOX
	.REF	GET_AUD
	.REF	LM_FINIS
	.REF	BAD_AUD
	.REF	MAIN_RET
	.REF	AREUSURE
	.REF	F_TITLE
	.REF	ST_STICK
	.REF	GETSTICK
	.REF	FAC_SET
	.REF	SUR_MESS
	.REF	SURE_BOX
	.REF	RT_RET
	.REF	GET_FAC
	.REF	WAIT_BUT
	.REF	DIGSRT
	.REF	DIAG_EX
;	.REF	GET_ADV
	.REF	STD_BORD
	.REF	SND_MADE
	.REF	NO_CLEAR
	.REF	LAST_BUT
	.REF	G_BORDER

;	IN AUDIT.ASM

	.REF LM_SETUP
	.REF ROM_NAME
	.REF GET_ADJ
	.REF STRCAT
;	.REF CLR_SUBS
	.REF NO_CREDS
	.REF CLR_AUDR
	.REF CLR_AUD
	.REF ADD_DUMP
	.REF DISPDUMP
	.REF CAT_A0
	.REF CK_MAX
	.REF DUMP_FS
	.REF ADJ_PAGE
	.REF F_ADC_S
	.REF WC_BYTEI
	.REF RC_WORD
	.REF DEF_PAGE
	.REF WAIT_MUT
	.REF STORE_AUDIT

;	IN HSTD.ASM

	.REF	ALL_TAB,INIT_TB,FORM_ADC,WC_WORD,CMOS_VAL
	.REF	P_FORK,GET_HSC,INIT_HSR

;	IN ADJUST.ASM

	.REF	GO_ADJ


;	IN UTIL.ASM

	.REF	FILLAREA
	.REF	CLR_SCRN

;	IN ROBOATT.ASM

	.REF	COLRSTRT
	.REF	GAMERASE
	.REF	ATSTRT

;DIAG STUFF

	.ref	SWITCHTEST
	.REF	CPU_CHK,COL_BARS,CROSS_H,BURN_IN,STRNEW1

	.REF	RD15FONT,SCRCLR,MYOINIT,STRCNRM,GAMSTATE
	.REF	STRNGRAM,BLNKAREA,STRLNRM,RD7FONT,HEXTOASC
	.REF	CLR_SCRN,STRRNRM
	.REF	WARMSET,QSNDRST

	.BSS	FAC_FLAG,16		;FLAG SAYS CLEAR AUDITS AND HSTABLE
					;IF FACTORY SETTINGS SUCCEED.
	.BSS	SCODE,16		;SYNTH CODE LAST MADE!
	.BSS	DCODE,16		;DIG CODE LAST MADE!
	.BSS	TMPOBJ,32		;TEMPORARY OBJECT FROM STR_OBJ


INDIAG	.EQU	40H

**************************************************************************
*									 *
*	   COIN TABLE							 *
*									 *
**************************************************************************
*
*	The coin table is made up of the normal entries from
*	the pinball system, as well as some new ones that
*	determine start and buy-in cost, and others that
*	aid in the determination of a "total collection".
*
*	Left Slot Multiplier		word
*	Center Slot Multiplier		word
*	Right Slot Multiplier		word
*	Units for Credit		word
*	Units for Bonus			word
*	Minimum Units			word
*	Credits to start		word
*	Credits to Continue		word
*	Divisor in money calculation	word   0 means "OFF"
*
* --------------------------------------------------------------
* The above value get copied as adjustments (and are adjustable).
* In addition, the coin table contains help on how to arrive at
* the "Total Collection" for the coin audits.
* --------------------------------------------------------------
*
*	Count for each Left coin		word
*	Count for each Center coin		word
*	Count for each Right coin		word
*	Pointer to Leading text string		long
*	Pointer to Following text string	long
*
**************************************************************************
*
*	GET_CSPT
*
*	THIS IS CALLED TO RETURN IN A6 THE CURRENT
*	CSELCT LINE AS STORED IN THE ADJUSTMENT TABLE.
*
**************************************************************************
GET_CSPT
	PUSH	a0
	movk	ADJPRICE,a0
	CALLA	GET_ADJ 	;GET THE COIN SELECT NUMBER BEING USED.
	CALLR	CS_POINT
	PULL	a0
	RETS
	
**************************************************************************
* CS_POINT - Point at selected entry in the coinage select table
* A0=Offset #
* Rets: A6=*Coinage table
**************************************************************************
CS_POINT
	MMTM	SP,A0,A1
	MOVE	A0,A0		;ZERO?
	JRZ	CS1		;YEP...RETURN FIRST LINE

	CMPI	CS_ENTS,A0	;IN RANGE?
	JRLS	CS2		;YEP...CONTINUE
	MOVK	1,A0		;TOO LARGE.......USE 1ST LINE.

CS2	DEC	A0		;INDEX INTO TABLE
CS1	MOVI	CS_SIZE,A1	;SIZE PER ENTRY
	MPYU	A0,A1		;OFFSET INTO TABLE
	ADDI	CSELCT,A1
	MOVE	A1,A6		;RETURN THE POINTER
	MMFM	SP,A0,A1
	RETS

**************************************************************************
*
*	CKPROMPT
*
*	IS THERE A PROMPT STRING FOR THE CREDITS PAGE.
*
*	A0 RETURNS:
*
*	YES.....RETURN POINTER TO SOMETHING
*	NO......RETURN ZERO
*
*	IF A0 HAS A POINTER THEN....
*
*	IF A1 = 0 THEN A0 IS AN L_MESS STRING THAT SHOULD
*		JUST BE SENT OUT.
*
*	IF A1 != 0 THEN A0 IS A POINTER LIST OF UP TO 2 MESSAGES.
*		THAT GIVE PRICING INFO
*
*	A1 = 0 PLOT THE A0 STRING OUTRIGHT USING L_MESS
*		(IT CONTAINS ALL DATA)
*
*	A1 = 1  PLOT ONLY THE STRING LIST (1 OR 2 POINTERS
*		CENTERED APPROPRIATELY
*
*	A1 = 2  PLOT THE 1ST LINE OF THE STRING LIST ALONG
*		WITH THE 2 CREDITS TO START...1 TO CONTINUE
*
*	A1 = 3  PLOT THE 2ND LINE OF THE STRING LIST ALONG
*		WITH THE 2 CREDITS TO START...1 TO CONTINUE
*
*	A1 = 4  PLOT THE 3RD LINE OF THE STRING LIST ALONG
*		WITH THE 2 CREDITS TO START...1 TO CONTINUE
*
*	A1 = 5  PLOT THE 1ST LINE OF THE STRING LIST ALONG
*		ALONG WITH 2 COINS PER PLAYER
*
*	A1 = 6  PLOT THE 2ND LINE OF THE STRING LIST ALONG
*		ALONG WITH 2 COINS PER PLAYER
*
*	A1 = 7  PLOT THE 3RD LINE OF THE STRING LIST ALONG
*		ALONG WITH 2 COINS PER PLAYER
*
*	A1 = 8  CUSTOM MESSAGE
*
**************************************************************************
								
CKPROMPT
	PUSH	a6
	movk	ADJFREPL,a0
	CALLA	GET_ADJ
	jrnz	RET_NO			;Free play?

	CALLA	CK_MAX			;ARE WE AT MAX CREDITS?
	JRHS	RET_MAX

	movk	ADJNOCPAG,a0
	CALLA	GET_ADJ 		;CHECK THE ADJUSTMENT
	JRNZ	CKSPCASE		;WE'RE SET TO SHUT UP.JUST START/CONT

	movk	ADJ1ST6,a0		;has operator messed around?
	CALLA	GET_ADJ
	JRZ	CKSPCASE		;YEP...GO FOR GENERIC "2 TO START"

*	OPERATOR IS USING CANNED COINAGE....WE NEED TO USE THE
*	CHECK IF ITS 2/1 OR 2/2

	CALLR	CK_2_CRED		;IS IT A 2 CREDIT MODE?
	JRZ	NOT_2_MODE		;NOPE...PRINT STOCK STUFF

	MOVE	A0,A1			;COPY 2/1	 2/2 CODE
	CALLR	GET_CSPT		;POINT A6 AT CSEL FOR US NOW.
	MOVE	*A6(CS_PICK),A0		;GET INDICATION OF WHICH LINE
	JRZ	CKSPCASE		;IT SAYS JUST ENUMERATE THE MODE!

*	NOW....IF ITS 2/1, A0 HAS THE CORRECT RETURN CODE
*	IF ITS 2/2 WE NEED TO ADD 2

	subk	1,a1
	JRZ	RET_A0_VAL		;2/1?

	addk	3,a0
	JRUC	RET_A0_VAL		;RETURN THIS!

NOT_2_MODE
	CALLR	GET_CSPT		;POINT A6 AT CSEL FOR US NOW.
	MOVE	*A6(CS_PROMPT),A0,L	;FETCH POINTER TO MESSAGE (IF ANY)
	JRZ	CKSPCASE
					;WE HAVE SOMETHING STORED AT THE PROMPT
	CMPI	CSM_LAST,A0		;IS IT LITTLE?
	JRHI	CKEXIT			;NOPE..ITS A POINTER..RETURN L_MESS STATUE

RET_A0_VAL
	MOVE	A0,A1			;ITS LITTLE...RETURN IT AS A CODE
	MOVE	*A6(CS_LIST),A0,L	;PASS BACK MESSAGE LIST FOR THIS MODE
	JRUC	CK_BYE

RET_NO	CLR	A0			;IT IS FREE PLAY.
CKEXIT	CLR	A1			;NO FANCIES YET
CK_BYE	PULL	a6
	move	a0,a0			;Pass Z
	rets

*	CONTROL COMES HERE IF IT LOOKS LIKE NO MESSAGE IS
*	APPROPRIATE....CHECK FOR 2 TO START 1 TO CONTINUE GENERIC NEEDED.

CKSPCASE
	CALLR	CK_2_CRED		;CHECK IF THERE ARE 2 CREDIT MODES.
	JRZ	RET_NO			;NOT A 2 CREDIT MODE.

	subk	1,a0
	JRZ	TWO_ONE			;YEP...RETURN 2/1

	MOVI	TWO_CRED_PER_PLAYER,A0
	JRUC	CKEXIT			;RETURN IT!

TWO_ONE	MOVI	TWO_TO_START,A0
	JRUC	CKEXIT

RET_MAX	MOVI	MAX_C_M,A0
	JRUC	CKEXIT


**************************************************************************
* CK_2_CRED - Checks if in a 2-credit to start mode
*
* A0=0	NOT 2/1 OR 2/2 CREDIT MODE
* A0=1	2 TO START 1 TO CONTINUE
* A0=2	2 TO START 2 TO CONTINUE
*
* Z	NOT 2/1 OR 2/2 CREDIT MODE
* NZ	IS 2/1 OR 2/2 CREDIT MODE
**************************************************************************
CK_2_CRED
	MOVI	ADJCSTRT,A0
	CALLA	GET_ADJ 	;HOW MANY TO START
	subk	2,a0
	jrnz	c2c20		;!2 to start?

	MOVI	ADJCCONT,A0
	CALLA	GET_ADJ 	;GET CONTINUE NUMBER
	cmpi	2,a0		;1 or 2 is what we return
	jrhi	c2c20		;>2?
	move	a0,a0		;Return NZ (unless its 2/0)
	rets

c2c20	clr	a0		;Pass Z
	rets

**************************************************************************
*									 *
*	   MENU HANDLING SOFTWARE					 *
*									 *
**************************************************************************

**************************************************************************
*									 *
*	   FORCE_MAIN							 *
*									 *
*	   THIS IS CALLED TO GET TO MAIN MENU FROM LEVEL FURTHER	 *
*	   THAN 1 DOWN.  IT SETS THE GLOBAL FLAG "MAIN_RET"		 *
*	   NON ZERO.  GEN_MENU WILL KEEP RETURNING UNTIL		 *
*	   IT GETS BACK TO THE MAIN MENU.				 *
*									 *
**************************************************************************
FORCE_MAIN
	MOVK	1,A0		;POSITIVE NUMBER FORCES MAIN MENU.
	MOVE	A0,@MAIN_RET
	RETP			;NOW "RETURN TO THE MENU"

**************************************************************************
*									 *
*	  DIAGNOSTIC TESTS SELECTED......SHOW DIAGNOSTIC TEST MENU	 *
*									 *
**************************************************************************
GO_DIAG
	MOVI	MEN_DIAG,A8	;PUT UP THE MENU AND GO!
	JAUC	GEN_MENU	;THIS WILL RETURN TO LEVEL ABOVE US!

**************************************************************************
*									 *
*	  COIN BOOKKEEPING SELECTED					 *
*									 *
**************************************************************************
gb20	JSRP	DO_CLCOIN
GO_BOOK
	CALLA	CLR_SCRN
	MOVI	MES_BOOK,A2
	MOVI	ROBO_WHITE,A3
	JSRP	TOP_BOX 		;PRINT TITLE BOX.

	MOVI	COIN_AUDS,A0		;PUT TABLE UP.
	JSRP	PRNT_AUD

	MOVI	COIN1_AUDS,A0		;PUT TABLE UP.
	JSRP	PRNT_AUD

	MOVI	AUDLCOIN,A8		;NOW PRINT MONEY FOR 1ST 3
	JSRP	PRINT_COL

	MOVI	COIN2_AUDS,A0		;PUT TABLE UP.
	JSRP	PRNT_AUD

;	MOVI	COIN_A2,A0		;PUT PART 2 OF THE TABLE THERE.
;	JSRP	PRNT_AUD

	MOVI	MEN_DETAIL,A8
	MOVK	2,A9			;CURSOR ON 1ST ENTRY
	JSRP	B_MENU			;SEE IF THEY WANT PAGE 2.
	CMPI	1,A8			;DID WE GET 1'ST ENTRY?
	jreq	gb20

	RETP


;DETAIL_SCREEN
;	 CALLA	 CLR_SCRN		;CLEAR OUT FOR ACTION!
;
;	 MOVI	 DT_Y1,A0		;HEIGHT OF TOP TITLE
;	 MOVI	 ROBO_YELLOW,A9		;COLOR
;	 CALLA	 F_TITLE		;FRAME IT
;
;	 MOVI	 DT_Y2,A0		;HEIGHT OF 2ND TITLE
;	 CALLA	 F_TITLE		;FRAME IT
;
;	 MOVI	 DETAIL_TITLES,A8     ;NO ROOM FOR PRETTY TOP BOX...DO TITLES
;	 JSRP	 L_MESS 	      ;ESTABLISH THE TITLES.
;
;	 MOVI	 COIN_D1,A0	      ;DETAILED AUDIT 1
;	 JSRP	 PRNT_AUD	      ;PRINT IT
;
;	 MOVI	 AUDLCOIN,A8	      ;NOW PRINT MONEY FOR 1ST 3
;	 JSRP	 PRINT_COL	
;
;	 MOVI	 AUDLCSUB,A8	      ;SUB-TOTAL OF TOTAL MONEY
;	 JSRP	 PRINT_SUBTOTAL       ;PRINT IT.
;
;	 MOVI	 COIN_D2,A0	      ;DETAILED AUDIT 2
;	 JSRP	 PRNT_AUD
;
;	 MOVI	 AUDLCDC,A8	      ;NOW PRINT MONEY FOR DOOR CLOSED SET
;	 JSRP	 PRINT_COL
;
;	 MOVI	 AUDLCDCS,A8	      ;NOW PRINT SUB-TOTAL FOR DOOR CLOSED
;	 JSRP	 PRINT_SUBTOTAL       ;THATS IT!
;
;	 MOVI	 MEN_CLR_SUB,A8       ;CLEAR SUBTOTAL OR RETURN TO MAIN MENU
;	 MOVI	 2,A9		      ;CURSOR ON 2ND ENTRY
;	 JSRP	 B_MENU 	
;
;	 CMPI	 1,A8		      ;CHOICE 1 IS CLEAR.....
;	 JRNZ	 NO_CLEAR_SUB	      ;NOPE...RETURN TO CALLER!
;
;	 MOVI	 MESS_CLEAR_SUBS,A8   ;CLEAR COIN SUB-TOTALS...ARE YOU SURE
;	 MOVI	 CLR_SUBS,A9	      ;ROUTINE TO DO IT
;	 MOVI	 MESS_SUBS_CLEAR,A10  ;CONFIRMATION.
;	 JSRP	 AREUSURE	      ;ASK EM.
;	 JRUC	 DETAIL_SCREEN	      ;NOW PUT THIS SCREEN BACK UP.
;
;NO_CLEAR_SUB
;NO_DETAIL
;	 RETP			      ;AND RETURN TO OUR CALLER.
;
;PRINT_SUBTOTAL
;	  CALLR   ADD_AUDIT_DY	       ;PUSH THE Y 1 LEVEL
;	  MOVI	  T_SUB,A9	       ;USE "SUB-TOTAL" MESSAGE
;	  JAUC	  PRINT_MONEY	       ;AND NOW PRINT THE REQUESTED SUM.

**************************************************************************
*									 *
*	   GAME AUDITS SELECTED 					 *
*									 *
**************************************************************************

**************************************************************************
*									 *
*	   AUDITS TO BE SHOWN ON GAME AUDITS PAGE:			 *
*									 *
*	   EXTRA MEN							 *
*	   GAMES COMPLETED						 *
*	   1 PLAYER MINUTES						 *
*	   2 PLAYER MINUTES						 *
*	   TOTAL HOURS PLAYED						 *
*	   AVG "PLAYER" GAME TIME					 *
*	   AVG. ELAPSED TIME / PLAY					 *
*									 *
**************************************************************************

GO_AUD
	CALLA	CLR_SCRN
	MOVI	MES_AUD,A2
	MOVI	ROBO_CYAN,A3
	JSRP	TOP_BOX 	;PRINT TITLE BOX.

	MOVI	GAME_AUDS,A0	;PUT TABLE UP.
	JSRP	PRNT_AUD

	MOVI	MEN_AP1,A8	;AUDIT PAGE 1 MENU
	MOVK	1,A9		;CURSOR ON 1ST ENTRY
	JSRP	B_MENU		;SEE IF THEY WANT PAGE 2.

	CMPI	1,A8		;DID WE GET 1'ST ENTRY?
	JRNZ	NO_AP2		;NOPE...RETURN TO OUR CALLER
	
	CALLA	CLR_SCRN
	MOVI	MES_AUD,A2
	MOVI	ROBO_CYAN,A3
	JSRP	TOP_BOX 	;PRINT TITLE BOX.

	MOVI	GAME_AUD2,A0	;PUT TABLE UP.
	JSRP	PRNT_AUD

	MOVI	MEN_AP2,A8
	MOVK	2,A9		;CURSOR ON 2ND ENTRY
	JSRP	B_MENU		;SEE IF THEY WANT PAGE 2.

	CMPI	1,A8		;DID WE GET 1'ST ENTRY (RETURN TO PAGE 1)
	JRZ	GO_AUD		;YEP...PUT IT UP!

NO_AP2
	RETP

GO_UTIL
	MOVI	MEN_UTIL,A8
	JAUC	GEN_MENU	;PROCESS THE UTILITY MENU!
*
*	INDIVIDUAL UTILITY PROGRAMS
*

DO_CLCRED
	MOVI	MESS_CLCRED,A8	;CLEAR COIN SUB-TOTALS...ARE YOU SURE
	MOVI	CLR_CREDITS,A9	;ROUTINE TO DO IT
	MOVI	MESS_CCCONF,A10	;CONFIRMATION.
	JAUC	AREUSURE	;ASK EM......THEN RETURN!

**************************************************************************
*									 *
*	   CLR_CREDITS							 *
*									 *
*	   ROUTINE TO CLEAR OUT THE CREDITS POSTED ON THE GAME. 	 *
*									 *
**************************************************************************
CLR_CREDITS
	CALLA	NO_CREDS		;CALL THE ROUTINE THAT DOES IT
	RETP

DO_CLCOIN
	MOVI	MESS_CLCOIN,A8		;CLEAR COIN SUB-TOTALS...ARE YOU SURE
	MOVI	CLR_COINS,A9		;ROUTINE TO DO IT
	MOVI	MESS_CCNCONF,A10	;CONFIRMATION.
	JAUC	AREUSURE		;ASK EM......THEN RETURN!

CLR_COINS
	MOVI	FRST_C,A0
	MOVI	LAST_C,A1
	CALLA	CLR_AUDR
	RETP

DO_CLAUD
	MOVI	MESS_CLAUD,A8		;CLEAR COIN SUB-TOTALS...ARE YOU SURE
	MOVI	CLR_AUDITS,A9		;ROUTINE TO DO IT
	MOVI	MESS_CAUDCONF,A10	;CONFIRMATION.
	JAUC	AREUSURE		;ASK EM......THEN RETURN!

CLR_AUDITS
	MOVI	FRSTGAUD,A0
	MOVI	LASTGAUD,A1
	CALLA	CLR_AUDR
	CALLA	DUMP_FS 		;AND START THE "DUMP" RECORDS OVER
	RETP

DO_HSRES
	MOVI	MESS_HSRESET,A8
	MOVI	HSSOFT,A9
	MOVI	MESS_HSRCONF,A10
	JAUC	AREUSURE

HSSOFT
	CALLR	RES_ALL
	RETP				;PROGRAM TO DO THE JOB!

**************************************************************************
*
*	RES_ALL
*
*	RESET ALL TIME HIGH SCORE TABLE AND THE
*	HIGH SCORE RESET COUNTER.
*
**************************************************************************
RES_ALL
	MOVI	ALL_TAB,A8		;ALWAYS CLEAR OUT TODAYS TABLE
	CALLA	INIT_TB
	jauc	INIT_HSR		;RE-SET THE HIGH SCORE RESET COUNTER

DO_FACSET
	 MOVI	 MESS_FACSET,A8
	 MOVK	 1,A0
	 JRUC	 DEF_ADJ_PART

**************************************************************************
*									 *
*	   DO_DEF_ADJ	   THIS IS CALLED FROM UTILITY MENU TO		 *
*			   DO THE DEFAULT ADJUSTMENTS.			 *
*									 *
*	   DEF_ADJ_PART    THIS IS CALLED OUT OF THE FULL		 *
*			   FACTORY SETTING TO HANDLE THE		 *
*			   ADJUSTMENT PART.				 *
*									 *
*			   A8 MUST HAVE THE MESSAGE FOR "ARE YOU SURE"	 *
*			   A0 .NE. 0 FOR FULL FACTORY SETTINGS (ON	 *
*				     SUCCESS OF ADJUSTMENT PART 	 *
*									 *
**************************************************************************
DO_DEF_ADJ
	MOVI	MESS_DEF_ADJ,A8
	CLR	A0

DEF_ADJ_PART
	MOVE	A0,@FAC_FLAG,W		;INDICATE THIS IS ADJUSTMENTS ONLY
	MOVI	DEFADJSOFT,A9
	MOVI	NULL_ST,A10		;DON'T PRINT ANYTHING....ROUTINE WILL.
	JSRP	AREUSURE
	RETP

DEFADJSOFT
*
*	NOW SMASH THE CHECKSUM
*
	CALLA	FORM_ADC	       ;FORM THE CKSUM
	MOVE	A1,A0		       ;PUT IN CMOS WRITING REGGIE
	MOVI	ADJ_CKSUM,A7
	INC	A0		       ;THIS SMASHES ADJUSTMENTS
	CALLA	WC_WORD 	       ;AND STORE IT
*
*	NOW MAKE SURE ITS SMASHED
*
	CALLA	CMOS_VAL
	JRZ	AD_FAIL 	       ;WE CAN'T DO IT.....PRINT FAILURE.
*
*	NOW SET THE ADJUSTMENTS TO THE FACTORY VALUE.
*
	clr	a0		;Full
	CALLA	FAC_SET
	CALLA	CMOS_VAL	;IS IT OK NOW?
	JRNZ	AD_FAIL 	;NOPE...PRINT FAILURE

	MOVI	MESS_DEFCONF,A8 ;THIS IS SINGLE MESSAGE

	MOVE	@FAC_FLAG,A0,W	;DO WE NEED TO CLEAR THE TABLES?
	JRZ	DAX		;NOPE...POST SINGLE MESSAGE

	CALLA	CLR_SCRN	;CLEAR THE SCREEN FOR OUR MESSAGES.
	CALLR	FAC_STUF	;DO AUDITS AND HIGH SCORE TABLE

	MOVI	MESS_FFSCONF,A8 ;PRINT THE REST OF THE MESSAGES
	JSRP	L_MESS		;THAT DOES IT!

NOTABS
	RETP

*
*	ON A FULL FACTORY SETTING (EITHER REQUESTED OR
*	ADJUSTMENT FAILURE) THIS CLEARS THE AUDITS AND
*	HIGH SCORE TABLE.
*
FAC_STUF
	CALLA	CLR_AUD 	;CLEAR AUDITS TOO
	CALLR	RES_ALL 	;ALL TIME TABLE
	RETS

AD_FAIL
	MOVI	MESS_FACFAIL,A8
	JRUC	DAX

DEF_CAN
	MOVI	MESS_CANCELLED,A8
DAX
	CALLA	CLR_SCRN
	JSRP	SUR_MESS
	RETP
**************************************************************************
*									 *
*	   EXIST_LET							 *
*									 *
*	   IS THE E_INITS PROCESS RUNNING?				 *
*									 *
**************************************************************************
EXIST_LET
	MOVI	OPMES_PID,A0		       ;SETUP FOR THE EXISTP
	MOVI	0FFFFH,A1
	JAUC   EXISTP
**************************************************************************
*									 *
*	   BUILD_ST							 *
*									 *
*	   THIS IS CALLED TO TAKE THE STRING POINTED TO 		 *
*	   BY -A10- AND REMOVE LEADING AND TRAILING BLANKS		 *
*	   AND MOVE THE STRING TO "STRNGRAM".				 *
*									 *
*	   RETURN THE NUMBER OF TRAILING BLANKS IN A2.			 *
*	   RETURN .EQ. IF ALL BLANK!					 *
*									 *
**************************************************************************
BUILD_ST
	MMTM	SP,A0,A1,A3,A4,A5,A10
	CLR	A4		       ;A4 = ZERO UNTIL 1ST NON-BLANK
	MOVI	STRNGRAM-BYTE_SIZE,A5  ;LAST NON-SPACE CHAR
	MOVI	STRNGRAM,A1	     ;DESTINATION POINTER
	MOVI	CMESS_CHARS,A2	     ;CHAR COUNT

BSLOOP
	MOVB	*A10,A3 	     ;FETCH A BYTE
	ANDI	BYTE_MASK,A3	     ;KILL SIGN EXTEND.
	JRNZ	BS1		     ;NOT ZERO
	MOVI	SPACE,A3	     ;REPLACE ZERO WITH SPACE.

BS1
	CMPI	SPACE,A3	     ;IS IT A SPACE?
	JRZ	BS2		     ;IT IS...
*
*	NON-SPACE CHARACTER
*
	OR	A3,A4		     ;INDICATE 1ST NON-BLANK SEEN
	MOVE	A1,A5		     ;INDICATE THIS IS CURRENT TERMINATOR.
	JRUC	BS3

BS2
	MOVE	A4,A4		     ;HAS 1ST SPACE BEEN SEEN?
	JRZ	BS4		     ;NOT YET...DON'T STORE
BS3
	MOVB	A3,*A1		     ;STORE IT IN MEMORY
	ADDK	BYTE_SIZE,A1	     ;PUSH DESTINATION POINTER
BS4
	ADDK	BYTE_SIZE,A10	     ;PUSH SOURCE POINTER
	DSJS	A2,BSLOOP	     ;AND FINISH PARSE
*
*	 A5 NOW POINTS AT LAST NON-BLANK CHARACTER
*
	ADDK	BYTE_SIZE,A5	     ;THIS IS 1 BEYOND
	CLR	A2
	MOVB	A2,*A5		     ;TERMINATE WITH A ZERO.
*
*	FOR OUR RETURN, WE NEED TO COMPUTE THE NUMBER OF
*	TRAILING SPACES IGNORED.
*
	MOVE	A4,A4		     ;ALL BLANK?
	JRNZ	NOT_BLNK
	MOVI	CMESS_CHARS,A2	     ;ALL CHARS ARE TRAILING BLANKS
	JRUC	BL_EX		     ;RETURN THIS

NOT_BLNK
	MOVE	A1,A2		     ;THIS IS LAST CHAR WE WROTE
	SUB	A5,A2		     ;THIS IS NUMBER OF TRAILING SPACES (TIMES 8)
	SRL	3,A2		     ;DIVIDE BY 8 TO GET SPACES
BL_EX
	MOVE	A4,A4		     ;FLAG ZERO FOR ALL BLANK!
	MMFM	SP,A0,A1,A3,A4,A5,A10
	RETS

* A1 = <COLOR><PALETTE>
* A3 = DAG OF AREA [YPOS,XPOS]						
* A4 = [Y,X] SIZE OF AREA						

GO_RED
	MOVI	ROBO_RED,A1
	JAUC	SC_COL

GO_GREEN
	MOVI	ROBO_GREEN,A1
	JAUC	SC_COL

GO_BLUE
	MOVI	ROBO_BLUE,A1
SC_COL
	SLL	16,A1		     ;PALETTE 0....COLOR UP HIGH
	CLR	A3		     ;UPPER LEFT
	MOVI	19001FFH,A4
	CALLA	FILLAREA	     ;THIS DOES THE SCREEN
	JAUC	WAIT_BUT	     ;NOW WAIT FOR ANY BUTTON!

GO_CPUTEST
	JAUC	CPU_CHK
	
GO_CROSS
	CALLA	SCRCLR
	CALLA	CROSS_H
	JAUC	WAIT_BUT	     ;NOW WAIT FOR ANY BUTTON!
;	JSRP	WAIT_BUT
;	CALLA	SCRCLR
;	CALLA	MYOINIT
;	RETP

GO_SWTEST
	CALLA	SCRCLR
	clr	a0
	JSRP	SWITCHTEST
;	CALLA	SCRCLR
;	CALLA	MYOINIT
	RETP

dipsw_test
	CALLA	SCRCLR
	movk	1,a0			;DIP mode
	JSRP	SWITCHTEST
	RETP
	
;GO_ROMTEST
;	JAUC	ROM_CHK

GO_BARS
;	MOVI	8000H,A1
;	CLR	A0
;	CALLA	KILALL
	CALLA	SCRCLR
	MMTM	SP,A12,A13
	CALLA	COL_BARS
	MMFM	SP,A12,A13
	JAUC	WAIT_BUT	     ;NOW WAIT FOR ANY BUTTON!
;	JSRP	WAIT_BUT
;	CALLA	SCRCLR
;	CALLA	MYOINIT
;	CALLA	COLRSTRT
;	RETP

DO_BURN
	MOVI	MESS_BURN,A8	     ;CLEAR COIN SUB-TOTALS...ARE YOU SURE
	MOVI	BURN_IN,A9	     ;ENTRY POINT
	MOVI	MESS_BURN,A10	     ;THIS WILL NEVER BE SEEN!
	JAUC	AREUSURE	     ;ASK EM.

ANY_BUT
	MOVI	ANY_MENU,A8	     ;ANY BUTTON TO CONTINUE
	MOVK	1,A9		     ;CURSOR ON ENTRY 1
	JAUC	B_MENU		     ;DO IT....RETURN WHEN PRESSED.


********************************
* DIAGNOSTIC TESTS
*
* SOUND TEST STUFF

RESETBIT	EQU	0FE00H		;THIS IS THE ^RESET BIT
SOUNDBIT	EQU	0FD00H		;THIS IS THE SOUND SIDE STROBE
TALKPORT	EQU	SWITCH+10H	;PORT TO FIND THIS LINE
B_SIRQ		EQU	14		;BIT TO READ FOR SOUND IRQ LINE

 SUBR	SNDTST

	calla	SNDRES
	calla	SCRCLR

	move	a13,a13
	jrnz	st60			;!Auto-cycle?
	calla	WDOGDIS
	movi	3000000,a0
st50	dsjs	a0,st50
	jruc	st70

st60	SLEEPK	10

st70	movi	M_STEST,a0		;Sound test message
	movi	>4080,a1
	clr	a2
	movi	ROBO_WHITE,a3
	calla	STRNEW1

	movi	SOUNDBIT,a3		;Pull sound section interrupt
	move	a3,@SOUND		;Hit sound

	movk	8,a0
	dsj	a0,$			;Slow it down a bit

	ori	>ff00,a3		;Put out 1's
	move	a3,@SOUND

	movk	8,a0
	dsj	a0,$

	movi	390/3,a3		;180 micros max firq delay on snd board
st150	movb	@TALKPORT+B_SIRQ-7,a0
	jrnn	st400			;IRQ on?
	dsj	a3,st150

	movi	snderror_s,a0		;>No IRQ!
	movi	>5848,a1
	clr	a2
	movi	ROBO_RED,a3
	calla	STRNEW1

	move	a13,a13
	jrnz	st250			;!Auto-cycle?
	calla	WDOGDIS
st200	move	@SWITCH+>10,a0
	not	a0
	andi	>24,a0
	jrz	st200			;No button?
	jruc	st500

st250	JSRP	WAIT_BUT
	jruc	st500

st400
	movi	sndok_s,a0		;>IRQ OK
	movi	>5880,a1
	clr	a2
	movi	ROBO_GREEN,a3
	calla	STRNEW1

st500
	movi	snd_t,a8	;*Data
	movi	>7880,a9	;Y:X

sndtlp
	move	a8,a0
	move	a9,a1
	clr	a2
	movi	>1212,a3	;Med blue
	calla	STRNEW1
	move	a0,a8
	addk	8,a8
	movb	*a8,a3		;Sound #
	sll	32-8,a3		;Kill sign extend
	srl	32-8,a3
	addk	8,a8
	calla	SNDSND
	move	a13,a13
	jrnz	sndslp		;!Auto-cycle?
	calla	WDOGDIS
	movi	3000000,a0
sndauto	dsjs	a0,sndauto
	jruc	sndslp1
sndslp
	SLEEP	120
sndslp1	
	addi	>1200,a9	;Next Y
	movb	*a8,a0
	jrnz	sndtlp
	move	a13,a13		;auto cycle exit
	jrz	sndx1
	RETP

sndx1	rets

snderror_s
	.byte	"NO SOUND BOARD IRQ LINE DETECTED!",0
sndok_s
	.byte	"IRQ LINE DETECTED",0

snd_t	;String/Sound code
	.byte	"TUNE1 -1",0
	.byte	1
	.byte	"NO WAY -E6",0
	.byte	>e6
	.byte	"EXPL1 -30",0
	.byte	>30
	.byte	"TUNE2 -9",0
	.byte	9
	.byte	"SPIDER BOUNCE -83",0
	.byte	>83
	.byte	"MUSIC OFF -0",0
	.byte	0
	.byte	0		;End
	.even

**************************************************************************
*									 *
*	   MONITOR PATTERNS						 *
*									 *
**************************************************************************
GO_PATTERNS
	MOVI	MEN_PATTERNS,A8      ;PUT UP THE MENU AND GO!
	JAUC	GEN_MENU	     ;THIS WILL RETURN TO LEVEL ABOVE US!

*******************************************************************************
*******************************************************************************
*******************************************************************************
*
*	       A   U   D   I   T	D   I	S   P	L   A	Y   S
*
*******************************************************************************
*******************************************************************************
*******************************************************************************
**************************************************************************
*									 *
*	   AUDIT TABLE STRUCTURE					 *
*									 *
**************************************************************************

	APTR	AUD_MESS	,0	;*Text
	APTR	AUD_ROUTINE	,2	;*Code to call or 0
	WORD	AUD_NUMBER	,4	;Audit number to show or 0
	WORD	AUD_COLOR	,5	;Color for this line
	LABEL	AUD_T_SIZE	,6	;Size of structure

AMAC	$macro	mess,rout,audit,color
	.long	:mess:,:rout:
	.word	:audit:,:color:
	$end

TXTLINE	$macro	s
	.byte	:s:,0
	.even
	$end


AUD_LM		EQU	TIT_ULX		;SQUARE OFF AUDITS W/ HEADER.
AUD_RM		EQU	TIT_LRX
AUD_Y_STRT	EQU	54
AUD_DY		EQU	14

CP2_Y		EQU	142		;PART 2 OF COIN AUDIT PAGE.

********************************
* TOP HALF OF COIN AUDIT PAGE 1 TABLE

COIN_AUDS
	.word	AUD_Y_STRT,14			;Y start, Y spacing
	.word	AUD_LM,AUD_RM			;LFT/RGT margin X
	AMAC	M_LCOIN,0,AUDLCOIN,ROBO_YELLOW
	AMAC	M_RCOIN,0,AUDRCOIN,ROBO_YELLOW
;	AMAC	M_CCOIN,0,AUDCCOIN,ROBO_ORANGE
;	AMAC	M_XCOIN,0,AUDXCOIN,ROBO_ORANGE
	AMAC	amst_s,0,AUDBEGIN,ROBO_GREEN	;On parachute
	AMAC	M_START,STARTS,0,ROBO_GREEN
	AMAC	M_CONT,CONTINS,0,ROBO_GREEN
	.long	0

COIN1_AUDS
	.word	AUD_Y_STRT+14*5+2,AUD_DY
	.word	AUD_LM,AUD_RM
	AMAC	M_PAIDC,0,AUDPAIDC,ROBO_WHITE
	.long	0

COIN2_AUDS
	.word	CP2_Y+AUD_DY+5,AUD_DY		;Y start, Y spacing
	.word	AUD_LM,AUD_RM			;LFT/RGT margin X
	AMAC	M_SERV,0,AUDSERV,>1212
	AMAC	M_PLAYS,DOPLAYS,0,ROBO_YELLOW
	AMAC	M_HSLEFT,DOHSLEFT,0,ROBO_YELLOW
	.long	0

;*	  BOTTOM HALF OF COIN AUDIT PAGE 1 TABLE
;COIN_A2	.WORD CP2_Y 		;Y START
;	.WORD AUD_DY		;Y BETWEEN ENTRIES
;	.WORD AUD_LM		;LEFT MARGIN X
;	.WORD AUD_RM		;RIGHT MARGIN X
;	AMAC	M_START,STARTS,0,ROBO_YELLOW
;	AMAC	M_CONT,CONTINS,0,ROBO_YELLOW
;	AMAC	M_PLAYS,DOPLAYS,0,ROBO_YELLOW
;	AMAC	M_HSLEFT,DOHSLEFT,0,ROBO_YELLOW
;	.LONG 0

**************************************************************************
*									 *
*	   COIN_D1							 *
*									 *
*	   THIS IS TOP HALF OF DETAILED COIN AUDIT PAGE 		 *
*	   ITS THE SAME AS THE OTHER COIN PAGE WITH THE Y POSITIONING	 *
*	   A LITTLE DIFFERENT						 *
*									 *
**************************************************************************
;COIN_D1
;	  .WORD   39H			;Y START
;	  .WORD   11H			;Y BETWEEN ENTRIES
;	  .WORD   AUD_LM		;LEFT MARGIN X
;	  .WORD   AUD_RM		;RIGHT MARGIN X
;	  AMAC	  M_LCOIN,0,AUDLCOIN,ROBO_YELLOW
;	  AMAC	  M_CCOIN,0,AUDCCOIN,ROBO_YELLOW
;	  AMAC	  M_RCOIN,0,AUDRCOIN,ROBO_YELLOW
;	  .LONG   0
*
*	 DOOR CLOSED AUDITS.
*
;COIN_D2
;	  .WORD   090H			;Y START
;	  .WORD   11H			;Y BETWEEN ENTRIES
;	  .WORD   AUD_LM		;LEFT MARGIN X
;	  .WORD   AUD_RM		;RIGHT MARGIN X
;	  AMAC	  M_LCOIN,0,AUDLCDC,ROBO_YELLOW
;	  AMAC	  M_CCOIN,0,AUDCCDC,ROBO_YELLOW
;	  AMAC	  M_RCOIN,0,AUDRCDC,ROBO_YELLOW
;	  .LONG   0

**************************************************************************
*									 *
*	   GAME PLAY AUDIT SCREEN					 *
*									 *
**************************************************************************
GAME_AUDS
	.word	50,10,AUD_LM,AUD_RM	;Y start, Y spacing, L margin, R margin
	AMAC	amst_s,0,AUDBEGIN,ROBO_GREEN	;On parachute
	AMAC	M_START,STARTS,0,ROBO_GREEN
	AMAC	M_CONT,CONTINS,0,ROBO_GREEN
	AMAC	M_EXTRA,0,AUDEXTRA,ROBO_ORANGE	;EXTRA MEN EARNED
	AMAC	M_P1MIN,DO_P1MIN,0,>1212
	AMAC	M_P2MIN,DO_P2MIN,0,>1212
	AMAC	M_HOURS,DO_HOURS,0,>1212
	AMAC	M_AVGT,DO_AVGT,0,ROBO_YELLOW
	AMAC	M_ELAPSE,DO_ELAPSE,0,ROBO_YELLOW
	AMAC	pwwso_s,0,AUDPWWARPSO,>0808	;Med grey
	AMAC	pwws_s,0,AUDPWWARPOK,>0808
	AMAC	warpa_s,0,AUDWARPA,>1212	;Med blue
	AMAC	warpt_s,0,AUDWARPT,>1212
	AMAC	warpc_s,0,AUDWARPC,>1212
	AMAC	ecpl_s,0,AUDECHAIRPL,>0d0d	;Pink
	AMAC	ecsv_s,0,AUDECHAIRSV,>0d0d
	.long	0

amst_s	TXTLINE	"ATTRACT MODE STARTS"
pwwso_s	TXTLINE	"PASSWORD WARPS STEPPED ON"
pwws_s	TXTLINE	"PASSWORD WARPS SUCCESSFUL"
warpa_s	TXTLINE	"WARPS APPEARED"
warpt_s	TXTLINE	"WARPS TAKEN"
warpc_s	TXTLINE	"WARPS COMPLETED"
ecpl_s	TXTLINE	"PLACED IN ELECTRIC CHAIR"
ecsv_s	TXTLINE	"SURVIVED ELECTRIC CHAIR"

GAME_AUD2
	.word	50,10,AUD_LM,AUD_RM	;Y start, Y spacing, L margin, R margin
;	AMAC	adt_s,0,AUDDEATHTOT,>1212		;Med blue
	AMAC	amst_s,0,AUDBEGIN,ROBO_ORANGE		;On parachute
	AMAC	wave1_s,0,AUDTAUNT1,ROBO_ORANGE		;
	AMAC	wave2_s,0,AUDBOSS1,ROBO_ORANGE		;
	AMAC	wave3_s,0,AUDBOSS1SC,>1919		;Med green
	AMAC	wave4_s,0,AUDROAD1,ROBO_ORANGE		;
	AMAC	wave5_s,0,AUDROAD1SC,>1919
	AMAC	wave6_s,0,AUDAIRPORT,ROBO_ORANGE	;
	AMAC	wave7_s,0,AUDROAD2,ROBO_ORANGE		;
	AMAC	wave8_s,0,AUDREACTOR,ROBO_ORANGE	;
	AMAC	wave9_s,0,AUDBOSSEND,ROBO_ORANGE	;
	AMAC	wavea_s,0,AUDRPDOME,ROBO_ORANGE		;
	AMAC	afg_s,0,AUDFULLGAMES,>1919
	AMAC	aakc_s,keyavg_prt,0,>1919
	AMAC	waveb_s,0,AUDEPDOME,ROBO_ORANGE		;
	AMAC	M_LOCKUP,0,AUDLOCK,>0f0f		;Watchdog lockup, Blue-wht
	AMAC	M_TRAPS,0,AUDTRAP,>0f0f			;BAD TRAPS
	AMAC	M_HANGUP,0,AUDHANG,>0f0f		;LOCKUPS VIA HANG
	.long	0

adt_s	TXTLINE	"TOTAL DEATHS"
wave1_s	TXTLINE	"REACHED TAUNT 1"
wave2_s	TXTLINE	"REACHED ORCUS"
wave3_s	TXTLINE	" STARTS/CONTINUES DURING ORCUS"
wave4_s	TXTLINE	"REACHED ROAD 1"
wave5_s	TXTLINE	" STARTS/CONTINUES DURING ROAD 1"
wave6_s	TXTLINE	"REACHED AIRPORT"
wave7_s	TXTLINE	"REACHED ROAD 2"
wave8_s	TXTLINE	"REACHED REACTOR"
wave9_s	TXTLINE	"REACHED LAST BOSS"
wavea_s	TXTLINE	"REACHED PLEASURE DOME"
afg_s	TXTLINE	" NUMBER OF FULL GAMES"
aakc_s	TXTLINE	" AVERAGE # KEYS COLLECTED"
waveb_s	TXTLINE	"ENTERED PLEASURE DOME / FINISHED GAME"


MISC_AUD
	.word	50,18,AUD_LM,AUD_RM		;Y start, Y spacing, LMar, RMar
	AMAC	M_SECBON,0,AUDSURV,ROBO_YELLOW	;WARPS TAKEN
	AMAC	M_HIDB,0,AUDBONE,ROBO_YELLOW	;GAMES NOT FINISHED
;	AMAC	M_HANGUP,0,AUDHANG,ROBO_YELLOW	;GAMES HUNG UP
	AMAC	M_PLAYS,DOPLAYS,0,ROBO_YELLOW	;PLAYS ON TOP
	AMAC	M_P1MIN,DO_P1MIN,0,ROBO_YELLOW
	AMAC	M_P2MIN,DO_P2MIN,0,ROBO_YELLOW
	AMAC	M_AVGT,DO_AVGT,0,ROBO_YELLOW
	AMAC	M_ELAPSE,DO_ELAPSE,0,ROBO_YELLOW
	AMAC	adiff_s,diff_prt,0,>1212
	.LONG	0

adiff_s	TXTLINE	"GAME DIFFICULTY LEVEL"


********************************
* Display revision message
* Do coin DIP if enabled
* Check cmos, if bad reset to factory

FACCHECK
	CALLA	CLR_SCRN
	MOVI	DIAGP,A0
	CALLA	GETFPAL

	MOVI	AUDSTAT,A0		;CLEAR GAME STATE AUDIT
	CLR	A1
	CALLA	STORE_AUDIT

	MOVI	ROM_NAME,A2
	MOVI	ROBO_LF,A3
	JSRP	TOP_BOX			;PRINT TITLE BOX.

	.if	YUNIT
	move	@SWITCH+>30,a0
	btst	6,a0
	jrnz	fc40			;No DIP coinage?

	movk	1,a0			;Just coinage
	calla	FAC_SET
	movi	dipcoinage_mess,a8
	JSRP	L_MESS
fc40
	.endif

	SLEEP	120			;Show it

	CALLA	CMOS_VAL		;CMOS BOGUS?
	JRZ	FACC0			;NO

	MOVI	MESS_RESET,A8		;ERROR MESSAGE
	JSRP	L_MESS
	SLEEP	60

	CALLR	RES_ALL			;ALL TIME TABLE
	clr	a0			;Full
	CALLA	FAC_SET

	MOVI	MESS_FAC,A8
	CALLA	LM_SETUP		;GET CONFIRMATION DATA READY.
	JSRP	LM_FINIS
	SLEEP	60
	CALLA	CMOS_VAL		;CMOS BOGUS?
	JRZ	FACC00			;NO

	CALLA	SCRCLR
	MOVI	MESS_RESET,A8		;ERROR MESSAGE
	JSRP	L_MESS
FACC00
	SLEEP	240

FACC0	CALLA	SCRCLR
	CALLA	ATSTRT
	DIE


dipcoinage_mess
	MESS_MAC RD7FONT,SPACING20,200,65,ROBO_WHITE,STRCNRM,0
	.byte	"USING DIPSWITCH COINAGE",0,0
	.even


********************************
* THIS HAS THE OCTOPUSS STUFF SO WE CAN SHOW OUR ADJUSTMENTS
* AND CRASH TABLE.
*
* FIRST CHECK JOYSTICKS FOR LEFT ONE UP AND
* AND RIGHT ONE RIGHT

HID_P
	CALLA	MYOINIT 		;MAKE SURE A13 IS OK BEFORE ANY ACTIONS!
	CALLA	DIGSRT			;RE-INIT THE WORLD!

	MOVI	ROM_NAME,A2
	MOVI	ROBO_LF,A3
	JSRP	TOP_BOX 		;PRINT TITLE BOX.

*	A4 = UPPER LEFT Y,X					      *
*	A5 = LOWER RIGHT Y,X					      *
*	A6 = NUMBER OF SLICES GOING IN. 			      *

;	MOVI	[4EH,TIT_ULX],A4
;	MOVI	[190H,TIT_LRX],A5
;	MOVK	16,A6
;	CALLA	G_BORDER

	MOVI	M_TEAM,A8		;PUT UP THE DESIGN TEAM!
	JSRP	L_MESS

	JSRP	WAIT_BUT

	CALLA	CLR_SCRN		;Clr screen
	MOVI	GAME_AUDS,A0		;Show 1st screen
	JSRP	PRNT_AUD
	JSRP	WAIT_BUT

	CALLA	CLR_SCRN		;Clr screen
	MOVI	GAME_AUD2,A0		;Show 2nd screen
	JSRP	PRNT_AUD
	JSRP	WAIT_BUT

	CALLA	CLR_SCRN		;Clr screen
	MOVI	MISC_AUD,A0
	JSRP	PRNT_AUD
	MOVI	AUDLCOIN,A8		;Prt money
	JSRP	PRINT_COL
	JSRP	WAIT_BUT

	JSRP	DISPDUMP					
									
	JSRP	WAIT_MUT
	JAUC	DIAG_EX			;NOW GET OUT!


**************************************************************************
* PRNT_AUD - THIS IS CALLED TO PRINT OUT AN AUDIT TABLE

AT_PTR	 EQU	PDATA			;LONG
AT_Y	 EQU	PDATA+LONG_SIZE		;WORD
AT_DY	 EQU	AT_Y+WORD_SIZE		;WORD
AT_LX	 EQU	AT_DY+WORD_SIZE		;WORD LEFT MARGIN X
AT_RX	 EQU	AT_LX+WORD_SIZE		;WORD RIGHT MARGIN X
AT_OBJ	 EQU	AT_RX+WORD_SIZE		;LONG OBJECT POINTER FOR COLLECTION ROUT
AT_MESS  EQU	AT_OBJ+LONG_SIZE	;LONG PRINT_MONEY MESSAGE STASH
	
PRNT_AUD
	MOVE	*A0+,A1			;GET STARTING HEIGHT
	MOVE	A1,*A13(AT_Y)	 	;STORE

	MOVE	*A0+,A1			;GET DY TO USE
	MOVE	A1,*A13(AT_DY)		;STASH IT AWAY

	MOVE	*A0+,A1			;GET LEFT MARGIN
	MOVE	A1,*A13(AT_LX)		;STORE

	MOVE	*A0+,A1			;GET RIGHT MARGIN
	MOVE	A1,*A13(AT_RX)		;STASH IT AWAY

	MOVE	A0,*A13(AT_PTR),L	;SAVE POINTER INTO AREA

PA1	JSRP	aud_prtone

	MOVE	*A13(AT_PTR),A0,L	;GET POINTER
	ADDI	AUD_T_SIZE,A0
	MOVE	A0,*A13(AT_PTR),L	;PUT BACK

	CALLR	ADD_AUDIT_DY

	MOVE	*A0,A1,L		;ARE WE DONE?
	JRNZ	PA1

	RETP

**************************************************************************
*									 *
*	   ADD_AUDIT_DY 						 *
*									 *
*	   THIS IS CALLED TO MOVE THE AUDIT Y (STORE IN 		 *
*	   PROCESS AREA) TO THE NEXT AUDIT BY ADDING THE		 *
*	   CURRENT DY (ALSO STORED IN PROCESS AREA).			 *
*									 *
**************************************************************************
ADD_AUDIT_DY
	MMTM	SP,A1,A2
	MOVE	*A13(AT_Y),A1,W
	MOVE	*A13(AT_DY),A2,W	;GET DELTA Y
	ADD	A2,A1			;MOVE THE Y DOWN
	MOVE	A1,*A13(AT_Y),W
	MMFM	SP,A1,A2
	RETS

BEGIN_AUDIT
	MMTM	SP,A0
	CLR	A0
	MOVE	A0,@BAD_AUD,W		;MONITOR CORRUPTION.
	MMFM	SP,A0
	RETS

********************************
* Print an audit line

 SUBRP	aud_prtone

	CALLR	BEGIN_AUDIT
	MOVE	*A13(AT_PTR),A3,L	;GET POINTER
	MOVE	*A3(AUD_ROUTINE),A4,L
	jrz	apo20			;No code?

	movi	apo50,a7
	MOVE	A7,-*A12,L		;PUSH RET ADDR
	JUMP	A4			;"CALL" THE ROUTINE

apo20	MOVE	*A3(AUD_NUMBER),A0	;FETCH THE AUDIT NUMBER
	CALLA	GET_AUD 		;TURN INTO AUDIT COUNT!
	MOVE	A1,A3			;PROTECT FOR A SECOND.
	JSRP	NUMBER_WORK		;GET THE NUMBER IN A3 UP THERE!

apo50
	movi	MESS_AUD_LINE,a8
	calla	LM_SETUP		;Setup for audit printing

	move	*a13(AT_PTR),a3,L	;Get *audit
	move	*a3(AUD_COLOR),a6
	move	*a3(AUD_MESS),a8,L	;Get *text

	jruc	LEFT_FINISH


********************************
* LEFT_FINISH AND RIGHT_FINISH
*
* THESE ARE CALLED TO PUT AUDIT INFO
* ON THE LEFT OR RIGHT SIDE ONCE A8 POINTS AT
* THE CORRECT DATA TO PRINT

LEFT_FINISH
	CALLR	TURN_RED_IF_NEC
	CALLR	SET_FOR_Y		;SET FOR AUDIT'S Y
	CALLR	SET_LEFT_X		;SET FOR LEFT X
	JSRP	LM_FINIS		;AND TYPE UP THE MESSAGE!
	RETP

RIGHT_FINISH
	CALLR	TURN_RED_IF_NEC 	;CHANGE COLOR IF CORRUPTED.
	CALLR	SET_FOR_Y		;SET FOR AUDIT'S Y
	CALLR	SET_RIGHT_X
	JSRP	LM_FINIS		;FINISH THE JOB!

	MOVE	@BAD_AUD,A0,W	       ;IS IT CORRUPTED?
	JRZ	RFX		       ;NOPE....RETURN

	MOVI	MESS_ERROR,A8
	CALLA	LM_SETUP	       ;SETUP "ERROR"

	CALLR	SET_FOR_Y	       ;SET FOR AUDIT'S Y
	ADDI	40000H,A9	       ;PUSH 4 Y UNITS TO CENTER
	CALLR	SET_RIGHT_X
	JSRP	LM_FINIS	       ;FINISH THE JOB!

RFX	RETP

TURN_RED_IF_NEC
	MMTM	SP,A3
	MOVE	@BAD_AUD,A3	;CHANGE TO RED?
	JRZ	DAA_1		;NOPE...ITS OK!
	MOVI	ROBO_RED,A6    ;CHANGE COLOR TO RED
DAA_1	MMFM	SP,A3
	RETS
			
SET_FOR_Y
	MMTM	SP,A3
	MOVE	*A13(AT_Y),A3,W   ;GET Y COORDINATE
	SLL	16,A3		  ;PUT IT IN POSITION
	MOVY	A3,A9		  ;PUT IT IN PLACE
	MMFM	SP,A3
	RETS

SET_LEFT_X
	MMTM	SP,A3
	MOVE	*A13(AT_LX),A3,W
	MOVX	A3,A9		  ;PUT THE X IN PLACE
	MMFM	SP,A3
	RETS

SET_RIGHT_X
	MMTM	SP,A3
	MOVE	*A13(AT_RX),A3,W
	MOVX	A3,A9		  ;PUT THE X IN PLACE
	MMFM	SP,A3
	RETS

**************************************************************************
* NUMBER_WORK - Print audit number
* A3=#

NUMBER_WORK
	MOVI	MESS_AUD_NUM,A8 	;SETUP FOR AUDIT NUMBER
	CALLA	LM_SETUP

	MOVE	A3,A8			;NOW WE HAVE BINARY NUMBER
	CALLA	HEXTOASC		;NOW WE POINT TO THE STRING.
	move	*a13(AT_PTR),a6,L	;Get *audit
	move	*a6(AUD_COLOR),a6
	jruc	RIGHT_FINISH

**************************************************************************
*									 *
*	   GET_STARTS							 *
*									 *
*	   TOTAL GAME STARTS IN A2.					 *
*									 *
**************************************************************************
GET_STARTS
	MMTM	SP,A0,A1
	MOVK	AUD1STRT,A0
	CALLA	GET_AUD
	MOVE	A1,A2

	MOVK	AUD2STRT,A0
	CALLA	GET_AUD
	ADD	A1,A2
	MMFM	SP,A0,A1
	RETS

**************************************************************************
*									 *
*	   GET_CONTS							 *
*									 *
*	   TOTAL GAME CONTINUES IN A2.					 *
*									 *
**************************************************************************
GET_CONTS
	MMTM	SP,A0,A1
	MOVK	AUD1CONT,A0
	CALLA	GET_AUD
	MOVE	A1,A2

	MOVK	AUD2CONT,A0
	CALLA	GET_AUD
	ADD	A1,A2
	MMFM	SP,A0,A1
	RETS


**************************************************************************
* Get total plays (Beginning+starts+continues)
* Rets: A2=#

GET_PLAYS
	PUSH	a0
	movk	AUDBEGIN,a0
	calla	GET_AUD
	move	a1,a0
	callr	GET_STARTS	;Actually middle starts
	add	a2,a0
	callr	GET_CONTS
	add	a0,a2
	PULL	a0
	rets

**************************************************************************
*									 *
*	   PRINT_MONEY							 *
*									 *
*	   THIS IS CALLED TO PRINT OUT THE "MONEY" ON THE MONEY 	 *
*	   LINE OF THE AUDIT TABLE.					 *
*									 *
*	   AUDIT X AND Y IS SET FOR THE LINE TO DISPLAY IT ON.		 *
*									 *
*	   A8 HAS THE 1ST OF 3 AUDITS TO USE FOR THE CALCULATION	 *
*	   A9 HAS THE MESSAGE TO LEFT JUSTIFY ON THE CURRENT LINE	 *
*									 *
**************************************************************************
PRINT_COL
	MOVI	T_MONEY,A9	     ;THIS ENTRYPOINT IS FOR COLLECTION MESSAGE
	
PRINT_MONEY
	MOVE	A9,*A13(AT_MESS),L   ;HOLD MESSAGE FOR WHEN WE NEED IT!
	MOVI	ADJCDIV,A0	     ;IF DIVISOR IS ZERO..THEN ITS OFF!
	CALLA	GET_ADJ
	JRZ	NO_MONEY	     ;THAT'S ALL FOLKS!

	CALLR	BEGIN_AUDIT	     ;KEEP TRACK OF SANITY OF CALC.
*
*	ROUTINE IN A2 FORMS STRING BASED ON 3 AUDITS STARTING
*	WITH THE NUMBER IN A8.
*
	CALLR	STR_OBJ 	     ;GET AN OBJECT FOR STRINGING
	JRC	NO_MONEY	     ;COULDN'T GET AN OBJECT!

	CALLR	SUM_COINS	     ;ADD UP THE COIN PARTS IN A2

*
*	WE'RE DOING A PREFIX STRING...NO PREFIX IF ITS BEEN TAMPERED
*
	CALLR	SIXP		     ;HAVE THE 6 BEEN TAMPERED
	JRZ	NO_PREFIX
	CALLR	GET_CSPT	     ;A6 POINTS AT CSECECT DATA.
	MOVE	*A6(CS_LMES),A8,L    ;LEFT STRING FOR MONEY TOTAL
	CALLA	STRCAT		     ;SHOVE THE STRING IN!

NO_PREFIX
	MOVK	1,A0		     ;DIVIDE COINS BY 1 IF ITS BEEN TAMPERED WITH
	CALLR	SIXP
	JRZ	DIV_BY_1	     ;TAMPERED WITH...DIVIDE BY 1 FOR "COINS"

	MOVI	ADJCDIV,A0	     ;GET THE COIN PARTS PLEASE
	CALLA	GET_ADJ
*
*	GET QUOTIENT IN A2
*	REMAINDER IN A3
*
DIV_BY_1
	MOVE	A2,A3		     ;SETUP <A2><A3> AS DIVIDEND
	CLR	A2
	DIVU	A0,A2		     ;DIVIDE UNITS/DIVISOR

	MOVE	A2,A8		     ;WE NEED TO PUT QUOTIENT IN STRING
	CALLA	HEXTOASC	     ;THIS FORMS STRING FOR QUOTIENT

	CALLA	STRCAT		     ;ADD QUOTIENT TO PRINTOUT

	CMPI	1,A0		     ;IS DIVISOR ONE??????
	JRZ	NOFRAC		     ;YEP.......NO DECIMAL!
*
*	WE HAVE A DIVISOR.....WE NEED TO DISPLAY CENTS.
*
	MOVI	ME_DECIMAL,A8	     ;ADD DECIMAL POINT
	CALLA	STRCAT		     ;ITS THERE!
*
*	REMAINDER IS IN A3....TURN IT TO 100THS.
*
	MOVI	100,A2
	MPYU	A2,A3		     ;REMAINDER TIMES 100
	MOVE	A3,A2		     ;DIVIDEND IN A2

	CALLR	ROUNDED_A0_INTO_A2
	CALLR	A2_100TH	     ;CAT THE 100THS IN A2 TO THE A7 STRING.

NOFRAC
	MOVI	COINS_TRAIL,A8		 ;ASSUME IT WILL BE "COINS"
	CALLR	SIXP		     ;TAMPERED?
	JRZ	COIN_SUF	     ;YEP....USE " COINS"
	MOVE	*A6(CS_RMES),A8,L    ;FINISH IT OFF WITH RIGHT STRING

COIN_SUF
	CALLA	STRCAT		     ;SHOVE THE STRING IN!
	MOVI	M_MONEY,A8		  ;MESSAGE FOR THIS LINE PASSED IN A9
	CALLA	LM_SETUP

	MOVE	@TMPOBJ,A8,L	     ;POINTER TO MONEY STRING
	JSRP	RIGHT_FINISH		;PUT ON RIGHT MARGIN

	CALLR	STR_FREE

	MOVE	*A13(AT_MESS),A8,L	;SETUP PASSED MESSAGE
	CALLA	LM_SETUP
	JSRP	LEFT_FINISH		;PUT UP PASSED MESSAGE.
NO_MONEY
	RETP

**************************************************************************
*									 *
*	   STR_OBJ							 *
*									 *
*	   THIS IS CALLED TO GET AN OBJECT FOR				 *
*	   CONCATONATING STRINGS TOGETHER.				 *
*									 *
*	   A7 POINTS AT NULL STRING					 *
*									 *
*	   NOTE THAT THIS IS NO LONGER RE-ENTRANT!			 *
*									 *
*	   YOU MUST CALL STR_FREE BEFORE SLEEPING!			 *
*									 *
**************************************************************************
STR_OBJ
	MMTM	SP,A0
	CALLA	GETOBJ		     ;USE AN OBJECT BLOCK FOR STRING MANIPULATION
	JRNZ	STR_O1
*
*	NO OBJECTS DURING TEST MODE
*
	SETC	
	JRUC	STR_OFAIL

STR_O1
	MOVE	A0,@TMPOBJ,L	     ;SAVE TO FREE LATER
	MOVE	A0,A7		     ;THIS IS WHERE IT BELONGS.
	CLR	A0
	MOVB	A0,*A7		     ;MAKE STRING NULL
	CLRC			     ;RETURN SUCCESS
STR_OFAIL
	MMFM	SP,A0
	RETS

**************************************************************************
*									 *
*	   ROUNDED_A0_INTO_A2						 *
*									 *
*	   THIS DIVIDES A0 INTO A2.  IT LEAVES THE RESULT IN A2 	 *
*	   AND ROUNDS UP IF NECESSARY.					 *
*									 *
**************************************************************************
ROUNDED_A0_INTO_A2
	MMTM	SP,A3
	MOVE	A0,A0		     ;DIVIDE BY ZERO?
	JRNZ	NDZ
	MOVE	A0,A2		     ;RETURN ZERO
	JRUC	NOROUND
NDZ
	MOVE	A2,A3
	CLR	A2		     ;<A2> <A3> AS DIVIDEND
	DIVU	A0,A2		     ;DIVIDE AND A2 = PENNIES....A3 = REMAINDER
	SLL	1,A3		     ;SHIFT REMAINDER
	CMP	A0,A3		     ;COMPARE TO DIVISOR
	JRLO	NOROUND 	     ;TOO LOW TO ROUND UP
	INC	A2		     ;A2 HAS CORRECT PENNIES
NOROUND
	MMFM	SP,A3
	RETS

**************************************************************************
*									 *
*	   A2_100TH							 *
*									 *
*	   A7 HAS A STRING TO BE PRINTED.  WE HAVE THE			 *
*	   LAST TWO NUMBERS (NOT TO BE LEAD ZERO BLANKED) IN		 *
*	   A2.	CONCATONATE THEM ONTO THE A7 STRING.			 *
*									 *
*	   THIS IS USED FOR PENNIES, HOURS AND MINUTES. 		 *
*									 *
**************************************************************************
A2_100TH
	MMTM	SP,A8
	CMPI	9,A2		     ;9 OR LESS REQUIES LEAD ZERO.
	JRHI	NOLEAD

	MOVI	ME_ZERO,A8	     ;THROW IN THE LEAD ZERO
	CALLA	STRCAT		     ;THIS DOES IT!

NOLEAD
	MOVE	A2,A8
	CALLA	HEXTOASC	     ;MAKE STRING
	CALLA	STRCAT		     ;PUT IT IN!
	MMFM	SP,A8
	RETS

**************************************************************************
*									 *
*	   SUM_COINS							 *
*									 *
*	   A8 HAS FIRST OF THE 4 AUDIT NUMBERS OF INTEREST		 *
*									 *
*	   RETURN COINS TIMES THEIR FACTORS IN A2.			 *
*									 *
**************************************************************************
SUM_COINS
	MMTM	SP,A0,A1,A3,A6,A4

	MOVE	A8,A0			  ;POINT AT AUDIT NUMBER
	CLR	A2			  ;SUM = ZERO

	CALLR	GET_CSPT		  ;A6 POINTS AT CSELECT TABLE
	ADDI	CS_LVAL,A6		  ;POINT AT 1ST MULTIPLIER

	MOVI	CHUTES,A4		  ;NOW...ITERATE OVER THE CHUTES

NEXT_CHUTE
	MOVE	*A6+,A3,W		  ;GET MULTPLIER FOR THIS CHUTE
	CALLR	FIX_A3			  ;REPLACE A3 WITH 1 (MULTIPLIER) IF
					  ;ITS SOME CUSTOM MODE.
	CALLR	ADD_AUD_A0_TIMES_A3_TO_A2
	INC	A0			  ;NEXT AUDIT
	DSJS	A4,NEXT_CHUTE

	MMFM	SP,A0,A1,A3,A6,A4
	RETS

ADD_AUD_A0_TIMES_A3_TO_A2
	CALLA	GET_AUD 		  ;FETCH THE AUDIT
	MPYU	A1,A3			  ;TIME THE FACTOR
	ADD	A3,A2
	RETS

**************************************************************************
* FIX_A3
*
* THIS IS CALLED BY THE LOW LEVEL MONEY TOTALIZER.
* THE MULTIPLIER FOR THE COIN SLOT THAT ITS WORKING
* ON IS IN A3.  WE REPLACE IT WITH "1" TO SUM "TOTAL COINS"
* IF ITS IN A NON-STANDARD COIN MODE.
*
**************************************************************************
FIX_A3
	CALLR	SIXP		     ;HAS IT BEEN TAMPERED WITH?
	JRNZ	FIX_A3X 	     ;NOPE...LEAVE A3

	MOVK	1,A3
FIX_A3X
	RETS

**************************************************************************
* SIXP
*
* THIS IS CALLED TO SEE IF THE 1ST 6 COIN PARAMETERS HAVE
* BEEN TAMPERED WITH.
*
* Z=YES
*
**************************************************************************
SIXP
	MMTM	SP,A0
	MOVI	ADJ1ST6,A0
	CALLA	GET_ADJ		;HAS IT BEEN TAMPERED WITH?
	MMFM	SP,A0
	RETS

STARTS
	CALLR	GET_STARTS
	MOVE	A2,A3		;GET IN PRINTOUT REG.
	jruc	NUMBER_WORK	;AND PRINT IT

CONTINS
	CALLR	GET_CONTS
	MOVE	A2,A3		;GET IN PRINTOUT REG.
	jruc	NUMBER_WORK	;AND PRINT IT

DOPLAYS
	CALLR	GET_PLAYS
	MOVE	A2,A3		;PUT IN PLACE
	jruc	NUMBER_WORK

DOHSLEFT
	MOVI	ADJHSRES,A0
	CALLA	GET_ADJ 	;IS IF OFF?
	JRZ	DOHSOFF 	;YEP...PRINT IT

	CALLA	GET_HSC 	;GET THE COUNTER VALUE
	MOVE	A0,A3
	jruc	NUMBER_WORK	;AND SHOW IT!

DOHSOFF
	MOVI	MESS_AUD_NUM,A8
	CALLA	LM_SETUP	;SETUP FOR AUDIT PRINTING.

	MOVI	M_HSOFF,A8	;THIS EFFECTIVELY ERASES LINE!
	JAUC	RIGHT_FINISH

DO_P1MIN
	MOVI	AUD1TIME,A0
P1MJ
	CALLA	GET_AUD 	;TURN INTO NUMBER
	MOVE	A1,A4		;MOVE NUMBER TO "HOUR" COMPUTATION REGGIE
	JRUC	DH11		;AND DO LIKE THE HOURS!


DO_P2MIN
	MOVI	AUD2TIME,A0
	JRUC	P1MJ

DO_HOURS
	CALLR	TOT_TIME	;READ OUT THE TOTAL TIME.
DH11	MOVE	A4,A5		;A5 HAS RUNNING PLAY TIME
	CLR	A4		;<A4><A5> READY FOR DIVISION
	MOVK	12,A0
	DIVU	A0,A4		;A4 HAS MINUTES
	CMPI	6,A5		;ROUND PROPERLY
	JRLO	DH1		;NOT ENOUGH
	INC	A4
DH1
	MOVE	A4,A1		;NOW THIS DIVIDED BY 60 IS WHAT WE NEED
	jruc	P_TIME		;DO IT!

DO_AVGT
	CALLR	TOT_TIME	;A3 HAS WEIGHTED TIME

DOAVC	CALLR	GET_PLAYS	;GET TOTAL PLAYS IN A2
	MOVE	A2,A0		;STASH IN A0.
	MOVK	5,A1		;TURN INTO SECONDS
	MPYU	A1,A3		;A3 HAS SECONDS OF INTEREST
	MOVE	A3,A2
	CALLR	ROUNDED_A0_INTO_A2   ;DIVIDE A2 BY PLAYS (AND ROUND)
	MOVE	A2,A1		;NOW GET IN PLACE FOR P_TIME
	jruc	P_TIME		;DO IT!

DO_ELAPSE
	CALLR	TOT_TIME
	MOVE	A4,A3		;USE ELAPSED TIME
	JRUC	DOAVC		;AND THE REST IS IDENTICAL.


keyavg_prt
	movi	AUDKEYTOT,a0
	calla	GET_AUD
	move	a1,a3
	movi	AUDFULLGAMES,a0
	calla	GET_AUD
	divs	a1,a3
	jruc	NUMBER_WORK	;Print it


diff_prt
	movk	ADJDIFF,a0
	calla	GET_ADJ
	move	a0,a3
	jruc	NUMBER_WORK	;Print it


**************************************************************************
*									 *
*	   P_TIME							 *
*									 *
*	   THIS IS CALLED TO DISPLAY AN AUDIT IN TIME (0:00)		 *
*	   FORMAT.  THE NUMBER TO BE USED IS PASSED IN A1.		 *
*									 *
**************************************************************************
P_TIME
	CALLR	STR_OBJ		;USE AN OBJECT BLOCK FOR STRING MANIPULATION
	JRC	NO_OBJS		;NO OBJECTS....PRINT NOTHING

	CLR	A0		;DIVIDEND IN <A0><A1>
	MOVI	60,A2
	DIVU	A2,A0		;A0 = "MINUTES"....A1 = "SECONDS

	CALLA	CAT_A0		;ADD A0 STRING TO A7 BUILD
	MOVI	ME_COLON,A8
	CALLA	STRCAT		;PUT THE COLON IN.

	MOVE	A1,A2		;GET "SECONDS" IN A2
	CALLR	A2_100TH	;AND GET THE 100THS IN.

	MOVI	MESS_AUD_NUM,A8	;SETUP FOR AUDIT NUMBER
	CALLA	LM_SETUP
	move	*a13(AT_PTR),a6,L	;Get *audit
	move	*a6(AUD_COLOR),a6

	MOVE	A7,A8		;PUT STRING CORRECT REGGIE
	JSRP	RIGHT_FINISH	;PRINT THE LINE

	CALLR	STR_FREE	;FREE UP THE OBJECT!

NO_OBJS
	RETP			;NOW RETURN TO CALLER

STR_FREE
	MOVE	@TMPOBJ,A0,L	;GET OBJECT BACK
	JRNZ	FREE_IT_NOW

	.IF	DEBUG
	JRUC	$
	.ENDIF
	RETS			;NO OBJECT...RETURN!

FREE_IT_NOW
	jauc	FREEOBJ 	;AND LET IT GO.
	
**************************************************************************
*									 *
*	TOT_TIME							 *
*									 *
*	(1 * P1TIME) + (2 * P2TIME) IN A3				 *
*	ELAPSED TIME IN A4						 *
*									 *
**************************************************************************
TOT_TIME
	MMTM	SP,A0,A1
	MOVI	AUD1TIME,A0
	CALLA	GET_AUD
	MOVE	A1,A3
	MOVE	A1,A4
	MOVI	AUD2TIME,A0
	CALLA	GET_AUD
	ADD	A1,A4		     ;A4 HAS SIMPLE SUM NOW
	SLL	1,A1		     ;DOUBLE THE PLAYER 2 TIME
	ADD	A1,A3
	MMFM	SP,A0,A1
	RETS


********************************
**** DATA SECTION BEGINS ****

	.DATA

CSELCT

*	USA 1	25 CENTS PER CREDIT
*	L =.25, C=$1.00, R=.25
*	CHUTE	L C R 4
	.word	1,4,1,0,1,0,0		;WILLY PRICING
	.word	4			;4 COINS PER DOLLAR (FOR CALC)
	.word	1			;DISPLAY COIN FRACTIONS
	.word	1,0,1,0			;COIN VALUE
	.long	DOLLAR_LEAD,NULL_ST	;CHARACTER STRINGS.
	.long	OCOP			;ONE COIN ONE PLAY
	.long	USA_1			;*TITLE
	.long	C1111			;1 COIN PER CREDIT (SERIES OF STRINGS)
	.word	SHOW_NONE		;NO PRICING LINE ON 2/1
	.long	USA_QQ 			;QUARTER

*	USA 2	50 cents start, 25 continue
*	L =.25, C=$1.00, R=.25
*	CHUTE	L C R 4
	.word	1,4,1,0,-1,0,0		;-1 does 2/1 credits
	.word	4			;4 COINS PER DOLLAR (FOR CALC)
	.word	1			;DISPLAY COIN FRACTIONS
	.word	1,0,1,0			;COIN VALUE
	.long	DOLLAR_LEAD,NULL_ST	;CHARACTER STRINGS.
	.long	TWO_TO_START 		;2 COINS PER PLAYER
	.long	USA_2			;*TITLE
	.long	C2111			;*Credit string table
	.word	SHOW_1 			;SHOW LINE 1
	.long	USA_QQ 			;QUARTER
*					      
*	USA 3    COINAGE IS 50 CENT   3/$1.00
*
	.WORD   1,0,1,0,2,4,0		;WILLY PRICING
	.WORD   4			;4 COINS PER DOLLAR (FOR CALC)
	.WORD   1			;DISPLAY COIN FRACTIONS
	.WORD   1,0,1,0			;COIN VALUE
	.LONG   DOLLAR_LEAD,NULL_ST	;CHARACTER STRINGS.
	.LONG   CSM_LIST		;PRINT THE 2 THE OP SEES
	.LONG   USA_3			;TITLE OF COIN MODE
	.LONG   DOLLAR_3		;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD   SHOW_2			;SHOW LINE 2
	.LONG   USA_QQ			;QUARTER
*					      
*	USA 4    COINAGE IS 50 CENT   4/$1.00
*
	.WORD	3,0,3,0,4,12,6		;WILLY PRICING
	.WORD	4			;4 COINS PER DOLLAR (FOR CALC)
	.WORD	0			;NO COIN FRACTIONS
	.WORD	1,0,1,0			;COIN VALUE
	.LONG	DOLLAR_LEAD,NULL_ST	;CHARACTER STRINGS.
	.LONG	CSM_LIST		;PRINT THE 2 THE OP SEES
	.LONG	USA_4			;TITLE OF COIN MODE
	.LONG	DOLLAR_4		;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD	SHOW_2			;SHOW LINE 2
	.LONG	USA_QQ			;QUARTER
*
*	USA 5    25 CENTS PER CREDIT 
*
	.WORD   1,4,1,0,1,0,0		;WILLY PRICING
	.WORD   4			;4 COINS PER DOLLAR (FOR CALC)
	.WORD   1			;DISPLAY COIN FRACTIONS
	.WORD   1,4,1,0			;COIN VALUE
	.LONG   DOLLAR_LEAD,NULL_ST	;CHARACTER STRINGS.
	.LONG   CSM_LIST		;ONE COIN ONE PLAY
	.LONG   USA_5			;TITLE OF COIN MODE
	.LONG   U1Q4D			;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD   SHOW_2			;NO PRICING LINE ON 2/1
	.LONG   USA_QDQ			;QUARTER
*
*	USA 6    50 PER CREDIT
*
	.WORD   1,4,1,0,2,0,0		;WILLY PRICING
	.WORD   4			;4 COINS PER DOLLAR (FOR CALC)
	.WORD   1			;DISPLAY COIN FRACTIONS
	.WORD   1,4,1,0			;COIN VALUE
	.LONG   DOLLAR_LEAD,NULL_ST	;CHARACTER STRINGS.
	.LONG   CSM_LIST		;2 COINS PER PLAYER
	.LONG   USA_6			;TITLE OF COIN MODE
	.LONG   UFS2D			;2 COINS PER CREDIT (SERIES OF STRINGS)
	.WORD   SHOW_1			;SHOW LINE 1
	.LONG   USA_QDQ			;QUARTER
*					      
*	USA 7    COINAGE IS 50 CENT   3/$1.00
*
	.WORD   1,4,1,0,2,4,0		;WILLY PRICING
	.WORD   4			;4 COINS PER DOLLAR (FOR CALC)
	.WORD   1			;DISPLAY COIN FRACTIONS
	.WORD   1,4,1,0			;COIN VALUE
	.LONG   DOLLAR_LEAD,NULL_ST	;CHARACTER STRINGS.
	.LONG   CSM_LIST		;PRINT THE 2 THE OP SEES
	.LONG   USA_7			;TITLE OF COIN MODE
	.LONG   UFS3D			;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD   SHOW_2			;SHOW LINE 2
	.LONG   USA_QDQ			;QUARTER
*					      
*	USA 8    COINAGE IS 50 CENT   4/$1.00
*
	.WORD   3,12,3,0,4,12,6		;WILLY PRICING
	.WORD   4			;4 COINS PER DOLLAR (FOR CALC)
	.WORD   0			;NO COIN FRACTIONS
	.WORD   1,4,1,0			;COIN VALUE
	.LONG   DOLLAR_LEAD,NULL_ST	;CHARACTER STRINGS.
	.LONG   CSM_LIST		;PRINT THE 2 THE OP SEES
	.LONG   USA_8			;TITLE OF COIN MODE
	.LONG   UFS4D			;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD   SHOW_2			;SHOW LINE 2
	.LONG   USA_QDQ			;QUARTER
*
*	USA ELECTRONIC
*
	.WORD   20,2,5,1,5,0,0		;L,C,R,4,U/C,U/B,MINUNITS
	.WORD   20			;COINS/DOLLAR
	.WORD   1			;DISPLAY FRACTIONS
	.WORD   20,2,5,1		;L,C,R,4
	.LONG   DOLLAR_LEAD,NULL_ST	;CHARACTER STRINGS.
	.LONG   USA_ELECTRONIC		;SPECIAL MESSAGE
	.LONG   USA_ELECTITLE 		;TITLE OF COIN MODE
	.LONG   USA_EL			;SETTINGS DESCRIPTION
	.WORD   SHOW_2			;LINES TO SHOW ON
	.LONG   USA_ESLOT		;QUARTER

*
*	GERMAN 1    COINAGE IS 5 PLAYS FOR 5 DM, 1 CREDIT FOR 1 DM
*	2 CREDITS TO START, 1 TO CONTINUE
*
	.WORD   1,2,5,0,-1,0,0		;WILLY PRICING
	.WORD   1			;DMS HAVE NO FRACTIONS
	.WORD   0			;DON'T DISPLAY COIN FRACTIONS
	.WORD   1,2,5,0			;COIN VALUE
	.LONG   NULL_ST,DM_TRAIL	;CHARACTER STRINGS.
;	.LONG   CSM_LIST
	.long	TWO_TO_START 		;2 COINS PER PLAYER
	.LONG   GERMAN_1		;TITLE OF COIN MODE
	.LONG   DM_5			;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD   SHOW_ALL
	.LONG   GERMAN_15		;1 DM / 5 DM

G1SEL    EQU     ($-CSELCT)/CS_SIZE	;COIN SELECT VALUE FOR GERMAN 1
*
*	GERMAN 2    COINAGE IS 7 PLAYS FOR 5 DM
*
	.WORD   6,12,30,0,5,30,0	;WILLY PRICING
	.WORD   1			;DMS HAVE NO FRACTIONS
	.WORD   0			;DON'T DISPLAY COIN FRACTIONS
	.WORD   1,2,5,0			;COIN VALUE
	.LONG   NULL_ST,DM_TRAIL	;CHARACTER STRINGS.
	.LONG   CSM_LIST
	.LONG   GERMAN_2		;TITLE OF COIN MODE
	.LONG   DM_7			;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD   SHOW_2
	.LONG   GERMAN_15		;1 DM / 5 DM
*
*	GERMAN 3    COINAGE IS 8 PLAYS FOR 5 DM
*
	.WORD   7,14,35,0,5,35,0	;WILLY PRICING
	.WORD   1			;DMS HAVE NO FRACTIONS
	.WORD   0			;DON'T DISPLAY COIN FRACTIONS
	.WORD   1,2,5,0			;COIN VALUE
	.LONG   NULL_ST,DM_TRAIL	;CHARACTER STRINGS.
	.LONG   CSM_LIST
	.LONG   GERMAN_3		;TITLE OF COIN MODE
	.LONG   DM_8			;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD   SHOW_2
	.LONG   GERMAN_15		;1 DM / 5 DM
*
*	GERMAN 4    COINAGE IS 6 PLAYS FOR 5 DM
*
	.WORD   6,12,30,0,5,0,0		;WILLY PRICING
	.WORD   1			;DMS HAVE NO FRACTIONS
	.WORD   0			;DON'T DISPLAY COIN FRACTIONS
	.WORD   1,2,5,0			;COIN VALUE
	.LONG   NULL_ST,DM_TRAIL	;CHARACTER STRINGS.
	.LONG   CSM_LIST
	.LONG   GERMAN_4		;TITLE OF COIN MODE
	.LONG   DM_6			;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD   SHOW_2
	.LONG   GERMAN_15		;1 DM / 5 DM

*
*	GERMAN ELECTRONIC
*
	.WORD	60,12,24,0,10,0,0	;L,C,R,4,U/C,U/B,MINUNITS
	.WORD	12			;COINS/DOLLAR
	.WORD	0			;DISPLAY FRACTIONS
	.WORD	60,12,24,0		;L,C,R,4
	.LONG	NULL_ST,DM_TRAIL	;CHARACTER STRINGS.
	.LONG	GERMAN_ELECTRONIC	;SPECIAL MESSAGE
	.LONG	GERMAN_ELECTITLE	;TITLE OF COIN MODE
	.LONG	DM112265		;SETTINGS DESCRIPTION
	.WORD	SHOW_3			;LINES TO SHOW ON
	.LONG   GERMAN_ESLOT		;QUARTER

****************************************************************************
****************************************************************************
*******  THE FOLLOWING NUMBERS ARE FIGURED FOR THE FRENCH SETTINGS
*******  REQUESTED BY DIMITRI K. OF P.S.D.
*******
*******			 1F   5F   10F   U/C   U/B  M/U
*******			--------------------------------
*******  1/2F  3/5F    7/10F     3    15    30    5    30    0
*******  1/3F  2/5F    5/10F     2    10    20    5    20    0
*******  1/5F  3/10F	    1     5    10    5    10    0
*******  1/5F  3/10F   7/20F     3    15    30   10    60   15
*******  2/5F  4/10F   9/20F     2    10    20    5    40   10
*******  2/5F  5/10F  11/20F     1     5    10    2    20    5
*******
*
*
*	FRENCH 1	      2/5F    5/10F
*
*
	.WORD   2,0,4,0,1,4,0		;2/5F    5/10F
	.WORD   1			;1 FRANC PER FRANC
	.WORD   0			;DON'T DISPLAY COIN FRACTIONS
	.WORD   5,0,10,0		;COIN VALUE
	.LONG   NULL_ST,FRANC_TRAIL	;CHARACTER STRINGS.
	.LONG   CSM_LIST		;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
	.LONG   FRENCH_1		;TITLE OF COIN MODE
	.LONG   FIVE_10			;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD   SHOW_2
	.LONG   FRENCH510

F1SEL    EQU     ($-CSELCT)/CS_SIZE	;COIN SELECT VALUE FOR FRENCH 1

*
*	FRENCH 2	      2/5F    4/10F
*
*
	.WORD   2,0,4,0,1,0,0		;2/5F    4/10F
	.WORD   1			;1 FRANC PER FRANC
	.WORD   0			;DON'T DISPLAY COIN FRACTIONS
	.WORD   5,0,10,0		;COIN VALUE
	.LONG   NULL_ST,FRANC_TRAIL	;CHARACTER STRINGS.
	.LONG   CSM_LIST		;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
	.LONG   FRENCH_2		;TITLE OF COIN MODE
	.LONG   FOUR_10			;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD   SHOW_2
	.LONG   FRENCH510
*
*	FRENCH 3	      1/5F  3/10F	
*
*
	.WORD   1,0,2,0,1,2,0		;1/5F  3/10F	
	.WORD   1			;1 FRANC PER FRANC
	.WORD   0			;DON'T DISPLAY COIN FRACTIONS
	.WORD   5,0,10,0		;COIN VALUE
	.LONG   NULL_ST,FRANC_TRAIL	;CHARACTER STRINGS.
	.LONG   CSM_LIST		;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
	.LONG   FRENCH_3		;TITLE OF COIN MODE
	.LONG   THREE_10		;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD   SHOW_2
	.LONG   FRENCH510
*
*	FRENCH 4	      1/5F  2/10F   
*
*
	.WORD   1,0,2,0,1,0,0   	;1/5F  2/10F
	.WORD   1			;1 FRANC PER FRANC
	.WORD   0			;DON'T DISPLAY COIN FRACTIONS
	.WORD   5,0,10,0		;COIN VALUE
	.LONG   NULL_ST,FRANC_TRAIL	;CHARACTER STRINGS.
	.LONG   CSM_LIST		;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
	.LONG   FRENCH_4		;TITLE OF COIN MODE
	.LONG   TWO_10			;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD   SHOW_1
	.LONG   FRENCH510

*
*	FRENCH 5	      2/5F    5/10F    11/2 X 10F
*
	.WORD   5,0,10,0,2,20,0		;2/5F  5/10F  11/20F
	.WORD   1			;1 FRANC PER FRANC
	.WORD   0			;DON'T DISPLAY COIN FRACTIONS
	.WORD   5,0,10,0		;COIN VALUE
	.LONG   NULL_ST,FRANC_TRAIL	;CHARACTER STRINGS.
	.LONG   CSM_LIST		;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
	.LONG   FRENCH_5		;TITLE OF COIN MODE
	.LONG   FIVE_10_11		;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD   SHOW_3			;USE LINE 3 WHEN ONLY 1 WILL FIT
	.LONG   FRENCH510
*
*	FRENCH 6	      2/5F    4/10F    9/2 X 10F
*
	.WORD   2,0,4,0,1,8,0		;2/5F  4/10F   9/20F
	.WORD   1			;1 FRANC PER FRANC
	.WORD   0			;DON'T DISPLAY COIN FRACTIONS
	.WORD   5,0,10,0		;COIN VALUE
	.LONG   NULL_ST,FRANC_TRAIL	;CHARACTER STRINGS.
	.LONG   CSM_LIST		;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
	.LONG   FRENCH_6		;TITLE OF COIN MODE
	.LONG   FOUR_10_9		;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD   SHOW_3			;USE LINE 3 WHEN ONLY 1 WILL FIT
	.LONG   FRENCH510
*
*	FRENCH 7	      1/5F    3/10F    7/2 X 10F
*
	.WORD   3,0,6,0,2,12,0		;1/5F  3/10F   7/20F
	.WORD   1			;1 FRANC PER FRANC
	.WORD   0			;DON'T DISPLAY COIN FRACTIONS
	.WORD   5,0,10,0		;COIN VALUE
	.LONG   NULL_ST,FRANC_TRAIL	;CHARACTER STRINGS.
	.LONG   CSM_LIST		;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
	.LONG   FRENCH_7		;TITLE OF COIN MODE
	.LONG   THREE_10_7		;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD   SHOW_3			;USE LINE 3 WHEN ONLY 1 WILL FIT
	.LONG   FRENCH510
*
*	FRENCH 8	      1/5F    2/10F    5/2 X 10F
*
	.WORD   1,0,2,0,1,4,0		;1/5F  2/10F  5/20F
	.WORD   1			;1 FRANC PER FRANC
	.WORD   0			;DON'T DISPLAY COIN FRACTIONS
	.WORD   5,0,10,0		;COIN VALUE
	.LONG   NULL_ST,FRANC_TRAIL	;CHARACTER STRINGS.
	.LONG   CSM_LIST		;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
	.LONG   FRENCH_8		;TITLE OF COIN MODE
	.LONG   TWO_10_5		;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD   SHOW_3			;USE LINE 3 WHEN ONLY 1 WILL FIT
	.LONG   FRENCH510
*
*	FRENCH 9	      1/3 X 1F      2/5F
*
*	COIN SLOTS ARE  1F -- 5F
*
	.WORD   2,0,10,0,5,0,0		;1/3x1F  2/5F  
	.WORD   1			;1 FRANC PER FRANC
	.WORD   0			;DON'T DISPLAY COIN FRACTIONS
	.WORD   1,0,5,0			;COIN VALUE
	.LONG   NULL_ST,FRANC_TRAIL	;CHARACTER STRINGS.
	.LONG   CSM_LIST		;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
	.LONG   FRENCH_9		;TITLE OF COIN MODE
	.LONG   F1325			;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD   SHOW_2			;USE LINE 2 WHEN ONLY 1 WILL FIT
	.LONG   FRENCH1F5F
*
*	FRENCH 10	      1/2 X 1F      3/5F
*
*	COIN SLOTS ARE  1F -- 5F
*
	.WORD   3,0,15,0,5,0,0		;1/2x1F  3/5F  
	.WORD   1			;1 FRANC PER FRANC
	.WORD   0			;DON'T DISPLAY COIN FRACTIONS
	.WORD   1,0,5,0			;COIN VALUE
	.LONG   NULL_ST,FRANC_TRAIL	;CHARACTER STRINGS.
	.LONG   CSM_LIST		;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
	.LONG   FRENCH_10		;TITLE OF COIN MODE
	.LONG   F1235			;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD   SHOW_2			;USE LINE 2 WHEN ONLY 1 WILL FIT
	.LONG   FRENCH1F5F
*
*	FRENCH 11	      1/3 X 1F      2/5F    5/2 X 5F
*
*	COIN SLOTS ARE  1F -- 5F
*
	.WORD   2,0,10,0,5,20,0		;1/3x1F  2/5F  5/10F
	.WORD   1			;1 FRANC PER FRANC
	.WORD   0			;DON'T DISPLAY COIN FRACTIONS
	.WORD   1,0,5,0			;COIN VALUE
	.LONG   NULL_ST,FRANC_TRAIL	;CHARACTER STRINGS.
	.LONG   CSM_LIST		;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
	.LONG   FRENCH_11		;TITLE OF COIN MODE
	.LONG   F13255			;1 COIN PER CREDIT (SERIES OF STRINGS)
	.WORD   SHOW_3			;USE LINE 2 WHEN ONLY 1 WILL FIT
	.LONG   FRENCH1F5F
*
*	FRENCH 12		1/2x5F  1/10F  3/2x10F	
*
	.WORD   1,0,2,0,2,4,0		;L,C,R,4,U/C,U/B,MINUNITS
	.WORD   1			;1 FRANC PER FRANC
	.WORD   0			;DON'T DISPLAY COIN FRACTIONS
	.WORD   1,0,5,0			;COIN VALUE
	.LONG   NULL_ST,FRANC_TRAIL	;CHARACTER STRINGS.
	.LONG	CSM_LIST		;WAIT TILL HE SAYS "IF IT IS NOT POSSIBLE"
	.LONG	FRENCH_12		;TITLE OF COIN MODE
	.LONG   F12355			;COINS PER CREDIT
	.WORD	SHOW_2
	.LONG   FRENCH1F5F
*
*	FRANCE ELECTRONIC
*
	.WORD   1,15,6,0,3,0,0		;L,C,R,4,U/C,U/B,MINUNITS
	.WORD   1			;COINS/DOLLAR
	.WORD   1			;DISPLAY FRACTIONS
	.WORD   1,10,5,0		;L,C,R,4
	.LONG   NULL_ST,FRANC_TRAIL	;CHARACTER STRINGS.
	.LONG   FRANCE_ELECTRONIC	;SPECIAL MESSAGE
	.LONG   FRENCH_ELECTITLE	;TITLE OF COIN MODE
	.LONG   F13255			;COIN PAGE DESCRIPTION
	.WORD   SHOW_3			;THREE LINES FOR THIS BABY
	.LONG   FRANCE_ESLOT		;QUARTER
*					      
*	CANADA    COINAGE IS 50 CENT   3/$1.00
*
	.WORD   1,0,4,0,2,4,0		;WILLY PRICING
	.WORD	4			;4 COINS PER DOLLAR (FOR CALC)
	.WORD	1			;DISPLAY COIN FRACTIONS
	.WORD	1,0,4,0			;COIN VALUE
	.LONG	DOLLAR_LEAD,NULL_ST	;CHARACTER STRINGS.
	.LONG	CSM_LIST		;PRINT THE 2 THE OP SEES
	.LONG   CANADA			;TITLE OF COIN MODE
	.LONG	CAN_1503D		;1 PLAY 50, 3 FOR A DOLLAR
	.WORD	SHOW_2			;SHOW LINE 2
	.LONG   CAN_QD			;QUARTER

*	SWISS 1    COINAGE IS 6 PLAYS FOR 5 FRANC

	.WORD	6,0,30,0,5,0,0		;WILLY PRICING
	.WORD	1			;FRANCS HAVE NO FRACTIONS
	.WORD	0			;DON'T DISPLAY COIN FRACTION
	.WORD	1,0,5,0			;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL	;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	SWISS_1			;TITLE OF COIN MODE
	.LONG	SFRANC_6		;1 COIN PER CREDIT (SERIES
	.WORD	SHOW_2
	.LONG	SWISS15

*	SWISS 2    COINAGE IS 7 PLAYS FOR 5 FRANC

	.WORD   6,0,30,0,5,30,0		;WILLY PRICING
	.WORD   1			;FRANCS HAVE NO FRACTIONS
	.WORD   0			;DON'T DISPLAY COIN FRACTIO
	.WORD   1,0,5,0			;COIN VALUE
	.LONG   NULL_ST,FRANC_TRAIL	;CHARACTER STRINGS.
	.LONG   CSM_LIST
	.LONG   SWISS_2			;TITLE OF COIN MODE
	.LONG   SFRANC_7		;1 COIN PER CREDIT (SERIES
	.WORD   SHOW_2
	.LONG   SWISS15

*	SWISS 3     COINAGE IS 8 PLAYS FOR 5 FRANC

	.WORD   7,0,35,0,5,35,0		;WILLY PRICING
	.WORD   1			;FRANCS HAVE NO FRACTIONS
	.WORD   0			;DON'T DISPLAY COIN FRACTIO
	.WORD   1,0,5,0			;COIN VALUE
	.LONG   NULL_ST,FRANC_TRAIL	;CHARACTER STRINGS.
	.LONG   CSM_LIST
	.LONG   SWISS_3			;TITLE OF COIN MODE
	.LONG   SFRANC_8		;1 COIN PER CREDIT (SERIES
	.WORD   SHOW_2
	.LONG   SWISS15

*	ITALY COINAGE IS 1 PLAYS FOR 500 LIRE

	.WORD	1,0,1,0,1,0,0		;WILLY PRICING
	.WORD	1			;LIRE HAVE NO FRACTIONS
	.WORD	0			;DON'T DISPLAY COIN FRACTION
	.WORD	500,0,500,0		;COIN VALUE
	.LONG	NULL_ST,LIRE_TRAIL	;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	ITALY_1			;TITLE OF COIN MODE
	.LONG	P1500L			;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_1
	.LONG	ITALYLIRE

*	U.K. 1   COINAGE IS 1 PLAY FOR 20P   3 FOR 50P

	.WORD	6,0,15,0,5,0,0		;WILLY PRICING
	.WORD   10			;PENCE ARE FRACTIONS!
	.WORD	0			;DON'T DISPLAY COIN FRACTION
	.WORD	2,0,5,0			;COIN VALUE
	.LONG	POUND_LEAD,NULL_ST	;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	UK_1			;TITLE OF COIN MODE
	.LONG	UK_120			;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_2
	.LONG	UK2050

*	U.K. 2   COINAGE IS 2 PLAY FOR 20P   5 FOR 50P

	.WORD   2,0,5,0,1,0,0		;WILLY PRICING
	.WORD   10			;PENCE ARE FRACTIONS!
	.WORD   0			;DON'T DISPLAY COIN FRACTIO
	.WORD   2,0,5,0			;COIN VALUE
	.LONG   POUND_LEAD,NULL_ST	;CHARACTER STRINGS.
	.LONG   CSM_LIST
	.LONG   UK_2			;TITLE OF COIN MODE
	.LONG   UK_220			;1 COIN PER CREDIT (SERIES OF ST
	.WORD   SHOW_1
	.LONG   UK2050

*	U.K. ELECTRONIC 1

*	CENTER = 20P  XTRA = 10P  LEFT = 1 POUND  RIGHT = 50P
*	1 PLAY / 30 P
*	2 PLAY / 50 P
*	4 PLAY / 1 POUND

*	.WORD	2,10,20,0,5,0,0		;NUMBERS FOR 10/50/100
	.WORD	20,3,10,2,5,0,0		;NUMBERS FOR 100/20/50/10
	.WORD	10			;PENCE ARE FRACTIONS!
	.WORD	0			;DON'T DISPLAY COIN FRACTION
	.WORD	10,2,5,1		;COIN VALUE
	.LONG	POUND_LEAD,NULL_ST	;CHARACTER STRINGS.
	.LONG	UK_ELECTRONIC		;SPECIAL TITLE W/ POUND
	.LONG	UK_3			;TITLE OF COIN MODE
	.LONG	UK_320			;1/30P  2/50P  4/1L
	.WORD	SHOW_2
	.LONG	UK_ELEC

*	U.K. ELECTRONIC 2  (CCU)

*	CREDITS ARE AWARDED 1 COIN / 1 PLAY.....

*	CCU ACCUMULATES 4 COINS AND STROKES US AS FOLLOWS:

*	1 PLAY / 30 P
*	2 PLAY / 50 P
*	4 PLAY / 1 POUND

	.WORD   1,0,0,0,1,0,0		;NUMBERS FOR
	.WORD   1			;PENCE ARE FRACTIONS!
	.WORD   0			;DON'T DISPLAY COIN FRACTIO
	.WORD   1,0,0,0			;COIN VALUE
	.LONG   NULL_ST,COINS_TRAIL	;CHARACTER STRINGS.
	.LONG   UK_ELECTRONIC		;SPECIAL TITLE W/ POUND
	.LONG   UK_4			;TITLE OF COIN MODE
	.LONG   UK_320			;1/30P  2/50P  4/1L
	.WORD   SHOW_2
	.LONG   UK_CCU

*	SPAIN 1     1 play / 25 Peseta   5 play / 100 Peseta

	.WORD	1,0,4,0,1,4,0		;WILLY PRICING
	.WORD	1			;no fractions
	.WORD	0			;DON'T DISPLAY COIN FRACTION
	.WORD	25,0,100,0		;COIN VALUE
	.LONG	NULL_ST,PESETA_TRAIL	;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	SP_1			;TITLE OF COIN MODE
	.LONG	SP_5100			;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_2
	.LONG	PESETA25

*	SPAIN 2     1 play / 25 Peseta   4 play / 100 Peseta

	.WORD   1,0,4,0,1,0,0		;WILLY PRICING
	.WORD   1			;no fractions
	.WORD   0			;DON'T DISPLAY COIN FRACTIO
	.WORD   25,0,100,0		;COIN VALUE
	.LONG   NULL_ST,PESETA_TRAIL	;CHARACTER STRINGS.
	.LONG   CSM_LIST
	.LONG   SP_2			;TITLE OF COIN MODE
	.LONG   SP_4100			;1 COIN PER CREDIT (SERIES OF ST
	.WORD   SHOW_2
	.LONG   PESETA25

*	AUSTRALIA 1   1 play / 3 X 20 CENTS    2 FOR $1.00

	.WORD	2,0,10,0,5,0,0		;WILLY PRICING
	.WORD	5			;DOLLARS
	.WORD	0			;DON'T SHOW FRACTIONS FOR T
	.WORD	1,0,5,0			;COIN VALUE
	.LONG	DOLLAR_LEAD,NULL_ST	;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	AUS_1			;TITLE OF COIN MODE
	.LONG	AU_60			;1 COIN PER CREDIT (SERIES OF S
	.WORD	SHOW_2
	.LONG	AUST20C

*	AUSTRALIA 2   1 play / $1.00    3 plays for $2.00

	.WORD	1,0,5,0,5,10,0		;WILLY PRICING
	.WORD	5			;DOLLARS
	.WORD	1			;SHOW FRACTIONS FOR THE 3 C
	.WORD	1,0,5,0			;COIN VALUE
	.LONG	DOLLAR_LEAD,NULL_ST	;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	AUS_2			;TITLE OF COIN MODE
	.LONG	AU_100			;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_3
	.LONG	AUST20C

*	JAPAN 1  1 play / 100 yen

	.WORD	1,1,1,0,1,0,0		;WILLY PRICING
	.WORD	1			;DOLLARS
	.WORD	1			;FRACTIONS OK
	.WORD	100,100,100,0		;COIN VALUE
	.LONG	NULL_ST,YEN_TRAIL	;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	JAP_1			;TITLE OF COIN MODE
	.LONG	JAP_100			;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_1
	.LONG	YEN100

*	JAPAN 2  2 play / 100 yen

	.WORD	2,2,2,0,1,0,0		;WILLY PRICING
	.WORD	1			;DOLLARS
	.WORD	1			;FRACTIONS OK
	.WORD	100,100,100,0		;COIN VALUE
	.LONG	NULL_ST,YEN_TRAIL	;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	JAP_2			;TITLE OF COIN MODE
	.LONG	JAP_200			;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_1
	.LONG	YEN100

*	AUSTRIA  1   1 Play / 5 Schilling  2 Play / 10 Schilling

	.WORD	1,0,2,0,1,0,0		;WILLY PRICING
	.WORD	1			;DOLLARS
	.WORD	1			;FRACTIONS OK
	.WORD	5,0,10,0		;COIN VALUE
	.LONG	NULL_ST,SHILL_TRAIL	;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	ASTA_1			;TITLE OF COIN MODE
	.LONG	ASTA_15			;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_1
	.LONG	SHILL510

*	AUSTRIA  2   1 Play / 2 X 5 Schilling  3 Play / 10 Schilling

	.WORD	1,0,2,0,2,4,0		;WILLY PRICING
	.WORD	1			;DOLLARS
	.WORD	1			;FRACTIONS OK
	.WORD	5,0,10,0		;COIN VALUE
	.LONG	NULL_ST,SHILL_TRAIL	;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	ASTA_2			;TITLE OF COIN MODE
	.LONG	ASTA_10			;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_2
	.LONG	SHILL510

*	BELGIUM 1  1 play / 20F

	.WORD	1,0,1,0,1,0,0		;WILLY PRICING
	.WORD	1			;DOLLARS
	.WORD	1			;FRACTIONS OK
	.WORD	20,0,20,0		;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL	;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	BEL_1			;TITLE OF COIN MODE
	.LONG	BEL_120			;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_1
	.LONG	FRANC20

*	BELGIUM 2  3 play / 20F

	.WORD	3,0,3,0,1,0,0		;WILLY PRICING
	.WORD	1			;DOLLARS
	.WORD	1			;FRACTIONS OK
	.WORD	20,0,20,0		;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL	;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	BEL_2			;TITLE OF COIN MODE
	.LONG	BEL_320			;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_1
	.LONG	FRANC20

*	BELGIUM 3  2 play / 20F

	.WORD	2,0,2,0,1,0,0		;WILLY PRICING
	.WORD	1			;DOLLARS
	.WORD	1			;FRACTIONS OK
	.WORD	20,0,20,0		;COIN VALUE
	.LONG	NULL_ST,FRANC_TRAIL	;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	BEL_3			;TITLE OF COIN MODE
	.LONG	BEL_220			;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_1
	.LONG	FRANC20
*
*	BELGIUM ELECTRONIC
*
	.WORD	10,1,4,0,5,0,0		;L,C,R,4,U/C,U/B,MINUNITS
	.WORD	1			;COINS/DOLLAR
	.WORD	1			;DISPLAY FRACTIONS
	.WORD	50,5,20,0		;L,C,R,4
	.LONG	NULL_ST,FRANC_TRAIL	;CHARACTER STRINGS.
	.LONG	BELGIUM_ELECTRONIC	;SPECIAL MESSAGE
	.LONG	BELGIUM_ELECTITLE 	;TITLE OF COIN MODE
	.LONG	BEL_ECA			;SETTINGS DESCRIPTION
	.WORD	SHOW_2			;LINES TO SHOW ON
	.LONG	BELGIUM_ESLOT		;QUARTER

*	SWEDEN	1 play / 3 X 1 KRONA   2 PLAY  5 KRONA

	.WORD	2,0,10,0,5,0,0		;WILLY PRICING
	.WORD	1			;DOLLARS
	.WORD	0			;DON'T SHOW FRACTIONS FOR T
	.WORD	1,0,5,0			;COIN VALUE
	.LONG	NULL_ST,KRONA_TRAIL	;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	SWED_1			;TITLE OF COIN MODE
	.LONG	SWED_2X5		;1 COIN PER CREDIT (SERIES
	.WORD	SHOW_1
	.LONG	KRONA5

*	NEW ZEALAND 1	1 play / 3 X 20 CENT

	.WORD	1,0,1,0,3,0,0		;WILLY PRICING
	.WORD	5			;FIVE PER
	.WORD	1			;SHOW FRACTIONS FOR THE 3 C
	.WORD	1,0,1,0			;COIN VALUE
	.LONG	DOLLAR_LEAD,NULL_ST	;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	NZ_1			;TITLE OF COIN MODE
	.LONG	NZ_13			;1 COIN PER CREDIT (SERIES OF S
	.WORD	SHOW_1
	.LONG	NZ20


*	NEW ZEALAND 2	1 play / 2 X 20 CENT

	.WORD	1,0,1,0,2,0,0		;WILLY PRICING
	.WORD	5			;FIVE PER
	.WORD	1			;SHOW FRACTIONS FOR THE 3 C
	.WORD	1,0,1,0			;COIN VALUE
	.LONG	DOLLAR_LEAD,NULL_ST	;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	NZ_2			;TITLE OF COIN MODE
	.LONG	NZ_12			;1 COIN PER CREDIT (SERIES OF S
	.WORD	SHOW_1
	.LONG	NZ20

*	NETHERLANDS	1 PLAY / 1 HFL.   3 PLAY / 2.5 HFL.

	.WORD	1,0,3,0,1,0,0		;WILLY PRICING
	.WORD	2			;FIVE PER
	.WORD	0			;SHOW FRACTIONS FOR THE 3 C
	.WORD	2,0,5,0			;COIN VALUE
	.LONG	NULL_ST,HFL_TRAIL	;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	NETH			;TITLE OF COIN MODE
	.LONG	NETH_HF			;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_2
	.LONG	HFSLOT


*	FINLAND	1 PLAY / 1 MARKKA

	.WORD	1,0,1,0,1,0,0		;WILLY PRICING
	.WORD	1			;FIVE PER
	.WORD	0			;SHOW FRACTIONS FOR THE 3 C
	.WORD	1,0,1,0			;COIN VALUE
	.LONG	NULL_ST,MARKKA_TRAIL	;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	FINLAND			;TITLE OF COIN MODE
	.LONG	FINMKA			;1 COIN PER CREDIT (SERIES OF ST
	.WORD	SHOW_1
	.LONG	MKSLOT

*	NORWAY	1 PLAY / 2 X 1 KRONE    3/ 5 X 1 KRONE

	.WORD	3,0,3,0,5,0,0		;WILLY PRICING
	.WORD	1			;FIVE PER
	.WORD	0			;SHOW FRACTIONS FOR THE 3 C
	.WORD	1,0,1,0			;COIN VALUE
	.LONG	NULL_ST,KRONE_TRAIL	;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	NORWAY			;TITLE OF COIN MODE
	.LONG	KR_LIST			;1 COIN PER CREDIT (SERIES OF STRI
	.WORD	SHOW_2
	.LONG	NKRSLOT

*	DENMARK	1 PLAY / 2 X 1 KRONE    3/ 5 KRONE    7 / 10 KRONE

	.WORD	3,0,15,0,5,30,0		;WILLY PRICING
	.WORD	1			;FIVE PER
	.WORD	0			;SHOW FRACTIONS FOR THE 3 C
	.WORD	1,0,5,0			;COIN VALUE
	.LONG	NULL_ST,KRONE_TRAIL	;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	DENMARK			;TITLE OF COIN MODE
	.LONG	DKR_LIST		;1 COIN PER CREDIT (SERIES
	.WORD	SHOW_3
	.LONG	DKRSLOT


*	ANTILLES      1 PLAY / 25 CENTS   4 PLAYS / 1 GUILDER

	.WORD	1,0,4,0,1,0,0		;WILLY PRICING
	.WORD	4			;FIVE PER
	.WORD	0			;SHOW FRACTIONS FOR THE 3 C
	.WORD	1,0,4,0			;COIN VALUE
	.LONG	NULL_ST,GUILDER_TRAIL	;CHARACTER STRINGS.
	.LONG	CSM_LIST
	.LONG	ANTILLES		;TITLE OF COIN MODE
	.LONG	ANT_LIST		;1 COIN PER CREDIT (SERIES
	.WORD	SHOW_1
	.LONG	ANTSLOT


CS_ENTS	EQU	($-CSELCT)/CS_SIZE	;NUMBER OF ENTRIES IN TABLE


********************************
* AUDIT TEXT

MESS_ERROR
	MESS_MAC RD7FONT,SPACING07,0,0,ROBO_RED,STRLNRM,0
	TXTLINE	"  ERROR"

MESS_AUD_NUM
	MESS_MAC RD7FONT,SPACING20,367,227,ROBO_YELLOW,STRRNRM,0

MESS_AUD_LINE
	MESS_MAC RD7FONT,SPACING20,23,227,ROBO_YELLOW,STRLNRM,0


MES_AUD	TXTLINE	"GAME AUDITS"

MES_BOOK
	TXTLINE	"COIN BOOKKEEPING"

M_LCOIN TXTLINE	"LEFT SLOT COINS"

M_CCOIN TXTLINE	"CENTER SLOT (3) COINS"

M_RCOIN TXTLINE	"RIGHT SLOT COINS"

M_XCOIN TXTLINE	"EXTRA SLOT (4) COINS"

M_PAIDC TXTLINE	"PAID CREDITS"

M_SERV	TXTLINE	"SERVICE CREDITS"


M_PLAYS TXTLINE	"TOTAL PLAYS"

M_HSLEFT
	TXTLINE	"PLAYS UNTIL H.S. RESET"

M_HSOFF TXTLINE	"OFF"

M_START TXTLINE	"MID GAME STARTS"
M_CONT	TXTLINE	"GAMES CONTINUED"
M_EXTRA	TXTLINE	"EXTRA MEN COLLECTED/EARNED"
M_P1MIN	TXTLINE	"HOURS OF SINGLE PLAY"
M_P2MIN	TXTLINE	"HOURS OF DUAL PLAY"
M_HOURS	TXTLINE	"TOTAL HOURS OF PLAY"
M_AVGT	.byte	"AVG. ",ASCII_DQ,"PLAYER",ASCII_DQ," GAME TIME (MIN.)",0
	.even
M_ELAPSE
	TXTLINE	"AVG. ELAPSED TIME/PLAY"

M_MONEY	MESS_MAC  RD15FONT,SPACING20,367,227,ROBO_WHITE,STRRNRM,0

T_MONEY MESS_MAC  RD15FONT,SPACING20,23,227,ROBO_WHITE,STRLNRM,0
	TXTLINE	"TOTAL COLLECTION"

**************************************************************************
*									 *
*	   COLLECTION MESSAGES						 *
*									 *
**************************************************************************
ME_ZERO	TXTLINE	"0"

ME_DECIMAL	TXTLINE	"."

ME_COLON	TXTLINE	":"

DOLLAR_LEAD	TXTLINE	"$  "

POUND_LEAD
;	.BYTE	FONT_EPOUND
	.byte	"L  "
NULL_ST	.byte	 0
	.even

DM_TRAIL	
	TXTLINE	"  DM"

FRANC_TRAIL
       TXTLINE	"  FRANC"

LIRE_TRAIL
	TXTLINE	"  LIRE"

PESETA_TRAIL
	TXTLINE	"  PESETA"

YEN_TRAIL
	TXTLINE	"  YEN"

SHILL_TRAIL
	TXTLINE	"  SCHILLINGS"

KRONA_TRAIL
	TXTLINE	"  KRONA"

COINS_TRAIL
	TXTLINE	"  COINS"

HFL_TRAIL
	TXTLINE	"  HFI."

MARKKA_TRAIL
	TXTLINE	"  MARKKA"

KRONE_TRAIL
	TXTLINE	"  KRONE"

GUILDER_TRAIL
	TXTLINE	"  GUILDER"

M_LOCKUP
	TXTLINE	"WATCHDOGS"
M_TRAPS
	TXTLINE	"BAD TRAPS"
M_HANGUP
	TXTLINE	"SOFTWARE HANGUPS"
M_HIDB	TXTLINE	"GAMES NOT FINISHED"

M_SECBON
	TXTLINE	"WARPS"

TWO_PER_PLAYER
	MESS_MAC RD15FONT,SPACING20,CP_CX,CP_11,ROBO_LASER,STRCNRM,0
	.byte   "2 COINS PER PLAYER",0,0
	.even

OCOP	MESS_MAC RD15FONT,SPACING20,CP_CX,CP_11,ROBO_LASER,STRCNRM,0
	.byte   "1 COIN / 1 PLAY",0,0
	.even

USA_ELECTRONIC
	MESS_MAC RD15FONT,SPACING20,CP_CX,CP_12,ROBO_LASER,STRCNRM,0
	.byte	"1 CREDIT  /  25 CENTS",0,1
	.even
	MESS_MAC RD15FONT,SPACING20,CP_CX,CP_22,ROBO_LASER,STRCNRM,0
	.byte	"4 CREDITS  /  1 DOLLAR",0,0
	.even

FRANCE_ELECTRONIC
	MESS_MAC RD15FONT,SPACING20,CP_CX,CP_13,ROBO_LASER,STRCNRM,0
	.byte	"1 CREDIT  /  3 X 1F",0,1
	.even
	MESS_MAC RD15FONT,SPACING20,CP_CX,CP_23,ROBO_LASER,STRCNRM,0
	.byte	"2 CREDITS  /  5F",0,1
	.even
	MESS_MAC RD15FONT,SPACING20,CP_CX,CP_33,ROBO_LASER,STRCNRM,0
	.byte	"5 CREDITS  /  2 X 5F",0,0
	.even

GERMAN_ELECTRONIC
	MESS_MAC RD15FONT,SPACING20,CP_CX,CP_13,ROBO_LASER,STRCNRM,0
	.byte	"1 KREDIT  /  1 DM",0,1
	.even
	MESS_MAC RD15FONT,SPACING20,CP_CX,CP_23,ROBO_LASER,STRCNRM,0
	.byte	"2 KREDITE  /  2 DM",0,1
	.even
	MESS_MAC RD15FONT,SPACING20,CP_CX,CP_33,ROBO_LASER,STRCNRM,0
	.byte	"6 KREDITE  /  5 DM",0,0
	.even

BELGIUM_ELECTRONIC
	MESS_MAC RD15FONT,SPACING20,CP_CX,CP_12,ROBO_LASER,STRCNRM,0
	.byte	"1 CREDIT  /  25 F",0,1
	.even
	MESS_MAC RD15FONT,SPACING20,CP_CX,CP_22,ROBO_LASER,STRCNRM,0
	.byte	"4 CREDITS  /  100 F",0,0
	.even

UK_ELECTRONIC
	MESS_MAC RD15FONT,SPACING20,CP_CX,CP_13,ROBO_LASER,STRCNRM,0
	.byte   "1 CREDIT / 30 P",0,1
	.even
	MESS_MAC RD15FONT,SPACING20,CP_CX,CP_23,ROBO_LASER,STRCNRM,0
	.byte   "2 CREDITS / 50 P",0,1
	.even
	MESS_MAC RD15FONT,SPACING20,CP_CX,CP_33,ROBO_LASER,STRCNRM,0
	.byte	"4 CREDITS / "
;	.byte	FONT_EPOUND
	.byte	"L 1.00",0,0
	.even
*
*	THE FOLLOWING 2 MESSAGES ARE GENERIC AND WILL
*	BE DISPLAYED IF THE MODE MATCHES AND NO
*	APPROPRIATE MESSAGE EXISTS
*
*	THIS IS FOR THIS BEING THE ONLY MESSAGE DISPLAYED ON
*	THE SCREEN
*
TWO_TO_START
	MESS_MAC RD15FONT,SPACING20,CP_CX,CP_12,ROBO_LASER,STRCNRM,0
	.byte	"2 CREDITS TO START",0,1
	.even
	MESS_MAC RD15FONT,SPACING20,CP_CX,CP_22,ROBO_LASER,STRCNRM,0
	.byte	"1 CREDIT TO CONTINUE",0,0
	.even
*
*	 THIS IS FOR LINES TWO AND 3 WITH AN ADDITIONAL LINE ABOVE
*

TWO_TS	MESS_MAC RD15FONT,SPACING20,CP_CX,CP_23,ROBO_LASER,STRCNRM,0
	.byte   "2 CREDITS TO START",0,1
	.even
	MESS_MAC RD15FONT,SPACING20,CP_CX,CP_33,ROBO_LASER,STRCNRM,0
	.byte   "1 CREDIT TO CONTINUE",0,0
	.even

TWO_TP	MESS_MAC RD15FONT,SPACING20,CP_CX,CP_22,ROBO_LASER,STRCNRM,0
	.byte   "2 CREDITS PER PLAYER",0,0
	.even

TWO_CRED_PER_PLAYER
	MESS_MAC RD15FONT,SPACING20,CP_CX,CP_11,ROBO_LASER,STRCNRM,0
	.byte   "2 CREDITS PER PLAYER",0,0
	.even

MAX_C_M MESS_MAC RD15FONT,SPACING20,CP_CX,CP_11,ROBO_LF,STRCNRM,0
	.byte   "MAXIMUM CREDITS!",0,0
	.even


*	 FOR THE COINAGE ADJUSTMENT MODE:
*
*	 THIS SET IS TITLES FOR THE CANNED MODES.

USA_1	TXTLINE	"USA 1"
USA_2	TXTLINE	"USA 2"
USA_3	TXTLINE	"USA 3"
USA_4	TXTLINE	"USA 4"
USA_5	TXTLINE	"USA 5"
USA_6	TXTLINE	"USA 6"
USA_7	TXTLINE	"USA 7"
USA_8	TXTLINE	"USA 8"
USA_ELECTITLE
	TXTLINE	"USA ECA"

GERMAN_1 TXTLINE "GERMAN 1"
GERMAN_2 TXTLINE "GERMAN 2"
GERMAN_3 TXTLINE "GERMAN 3"
GERMAN_4 TXTLINE "GERMAN 4"
GERMAN_ELECTITLE
	TXTLINE	"GERMAN ECA"

FRENCH_1 TXTLINE "FRANCE 1"
FRENCH_2 TXTLINE "FRANCE 2"
FRENCH_3 TXTLINE "FRANCE 3"
FRENCH_4 TXTLINE "FRANCE 4"
FRENCH_5 TXTLINE "FRANCE 5"
FRENCH_6 TXTLINE "FRANCE 6"
FRENCH_7 TXTLINE "FRANCE 7"
FRENCH_8 TXTLINE "FRANCE 8"
FRENCH_9 TXTLINE "FRANCE 9"
FRENCH_10 TXTLINE "FRANCE 10"
FRENCH_11 TXTLINE "FRANCE 11"
FRENCH_12 TXTLINE "FRANCE 12"
FRENCH_ELECTITLE
	TXTLINE	"FRANCE ECA"

CANADA	TXTLINE	"CANADA"
SWISS_1 TXTLINE	"SWISS 1"
SWISS_2 TXTLINE	"SWISS 2"
SWISS_3 TXTLINE	"SWISS 3"
ITALY_1 TXTLINE	"ITALY"
UK_1	TXTLINE	"U.K. 1"
UK_2	TXTLINE	"U.K. 2"
UK_3	TXTLINE	"U.K. ECA"
UK_4	TXTLINE	"U.K. ELEC W/CCU"
SP_1	TXTLINE	"SPAIN 1"
SP_2	TXTLINE	"SPAIN 2"
AUS_1	TXTLINE	"AUSTRALIA 1"
AUS_2	TXTLINE	"AUSTRALIA 2"
JAP_1	TXTLINE	"JAPAN 1"
JAP_2	TXTLINE	"JAPAN 2"
ASTA_1	TXTLINE	"AUSTRIA 1"
ASTA_2	TXTLINE	"AUSTRIA 2"
BEL_1	TXTLINE	"BELGIUM 1"
BEL_2	TXTLINE	"BELGIUM 2"
BEL_3	TXTLINE	"BELGIUM 3"
BELGIUM_ELECTITLE
	TXTLINE	"BELGIUM ECA"
SWED_1	TXTLINE	"SWEDEN"
NZ_1	TXTLINE	"NEW ZEALAND 1"
NZ_2	TXTLINE	"NEW ZEALAND 2"
NETH	TXTLINE	"NETHERLANDS"

FINLAND TXTLINE	"FINLAND"
NORWAY	TXTLINE	"NORWAY"
DENMARK TXTLINE	"DENMARK"
ANTILLES TXTLINE "ANTILLES"


********************************
* This section is a pointer to string lists for the "current setting" box.


*	1 COIN / 1 CREDIT
Q_Q	.LONG	C11		;THIS POINTS AT MESSAGE
	.LONG	0		;THIS ENDS LIST

USA_EL	.LONG	EC1,DOLL4,0

C1111	.long	C11,C1S1C,0

*	1ST COIN / 2 CREDITS
*	NEXT COIN / 1 CREDIT
C2111	.long	C11,C2S1C,0

*	2 COINS / 1 CREDIT
C2_PERC .long	C21,0

*	2 COINS / 1 CREDIT
*	3 COINS / 2 CREDIT	
*	4 COINS / 3 CREDITS
DOLLAR_3
	.long	C21,C43,0

*	2 COINS / 1 CREDIT
*	4 COINS / 4 CREDITS
DOLLAR_4
	.LONG   C21,C44,0


U1Q4D	.LONG	C11		;THIS POINTS AT MESSAGE
	.LONG	DOLL4		;4 FOR A DOLLAR
	.LONG	0

UFS2D	.LONG	C21		;THIS POINTS AT MESSAGE
	.LONG	DOLL2		;2 FOR A DOLLAR
	.LONG	0

UFS3D	.LONG	C21		;THIS POINTS AT MESSAGE
	.LONG	DOLL3		;3 FOR A DOLLAR
	.LONG	0

UFS4D	.LONG	C21		;THIS POINTS AT MESSAGE
	.LONG	DOLL4		;4 FOR A DOLLAR
	.LONG	0

*	1 PLAY 1/DM
*	5 PLAY 5/DM
DM_5	.LONG	DM11
	.LONG	DM55
	.LONG	C2S1C
	.LONG	0

DM_6	.LONG	DM11
	.LONG	DM65
	.LONG	0

DM_7	.LONG	DM11
	.LONG	DM75
	.LONG	0

DM_8	.LONG	DM11
	.LONG	DM85
	.LONG	0

DM112265
	.LONG	DM11
	.LONG	DM22
	.LONG	DM65
	.LONG	0
CAN_1503D
	.LONG   C15		;THIS POINTS AT MESSAGE
	.LONG   DOLL3		;3 FOR A DOLLAR
	.LONG   0

SFRANC_6
	.LONG   SFRANC11
	.LONG	SFRANC65
	.LONG	0

SFRANC_7
	.LONG   SFRANC11
	.LONG	SFRANC75
	.LONG	0

SFRANC_8
	.LONG   SFRANC11
	.LONG	SFRANC85
	.LONG	0
*
*	2 PLAYS 5F / 5 PLAYS 10F
*
FIVE_10 .LONG	F25
	.LONG	F510
	.LONG	0

FIVE_10_11
	.LONG	F25
	.LONG	F510
	.LONG	F1120
	.LONG	0

FOUR_10 .LONG	F25
	.LONG	F410
	.LONG	0

FOUR_10_9
	.LONG	F25
	.LONG	F410
	.LONG	F4109
	.LONG	0

THREE_10
	.LONG	F15
	.LONG	F310
	.LONG	0

THREE_10_7
	.LONG	F15
	.LONG	F310
	.LONG	F4107
	.LONG	0

TWO_10	.LONG	F15
	.LONG	F210
	.LONG	0

TWO_10_5
	.LONG	F15
	.LONG	F210
	.LONG	F4105
	.LONG	0

F1325	.LONG	F3X1F
	.LONG	F2F5
	.LONG	0

F13255	.LONG	F3X1F
	.LONG	F2F5
	.LONG	F52X5
	.LONG	0

F1235	.LONG	F2X1F
	.LONG	F3F5
	.LONG	0

F12355	.LONG	F2X1F
	.LONG	F3F5
	.LONG	F72X5
	.LONG	0

FELEC	.LONG	F3X1F
	.LONG	F25510
	.LONG	0

*
*	 500 LIRE
*
P1500L	 .LONG	 P1500L_P
	 .LONG	 0
*
*	 1 PLAY / 20 P	  3 PLAYS 50 P
*
UK_120	.LONG	UK_1201
	.LONG	UK_1202
	.LONG	0

UK_220	.LONG	UK_2201
	.LONG	UK_2202
	.LONG	0

UK_320	.LONG	UK_3201
;	.LONG   UK_3202
	.LONG	UK_3203
	.LONG	0

SP_4100 .LONG	SP_11
	.LONG	SP_44
	.LONG	0

SP_5100 .LONG	SP_11
	.LONG	SP_54
	.LONG	0

AU_60	.LONG	AU_36
	.LONG	AU_2D
	.LONG	0

AU_100	.LONG	AU_520
	.LONG	AU_1D
	.LONG	AU_32D
	.LONG	0

JAP_100 .LONG	JAP_101
	.LONG	0

JAP_200 .LONG	JAP_201
	.LONG	0

ASTA_10 .LONG	ASTA101
	.LONG	ASTA102
	.LONG	0

ASTA_15 .LONG	ASTA151
	.LONG	ASTA152
	.LONG	0

BEL_120 .LONG	BEL_1201
	.LONG	0
BEL_220 .LONG	BEL_2201
	.LONG	0
BEL_320 .LONG	BEL_3201
	.LONG	0
BEL_ECA	.LONG	BEL_ECA1
	.LONG	BEL_ECA2
	.LONG	0

SWED_2X5 .LONG	SWED_S51
	 .LONG	SWED_S52
	 .LONG	0

NZ_12	 .LONG	NZ_121
	 .LONG	0

NZ_13	 .LONG	NZ_131
	 .LONG	0

NETH_HF  .LONG	HF_11
	 .LONG	HF_32
	 .LONG	0

FINMKA	 .LONG	FIN_1
	 .LONG	0

KR_LIST  .LONG	NOR_12
	 .LONG	NOR_35
	 .LONG	0

DKR_LIST .LONG	DEN_12
	 .LONG	DEN_35
;	 .LONG  DEN_710
	 .LONG	0

ANT_LIST .LONG	ANT1P25
	 .LONG	ANT4DOL
	 .LONG	0

EC1	TXTLINE	"1 CREDIT / 25 CENTS"
C11	TXTLINE	"1 CREDIT / 1 COIN"
C21	TXTLINE	"1 CREDIT / 2 COINS"
C43	TXTLINE	"3 CREDITS / 4 COINS"
C44	TXTLINE	"4 CREDITS / 4 COINS"
C15	TXTLINE	"1 CREDIT / 2 X 25 CENTS"
C1S1C	TXTLINE	"1 CREDIT START / 1 CONTINUE"
C2S1C	TXTLINE	"2 CREDITS START / 1 CONTINUE"

DOLL2	TXTLINE	"2 CREDITS / $1.00"

DOLL3	TXTLINE	"3 CREDITS / $1.00"

DOLL4	TXTLINE	"4 CREDITS / $1.00"

DM11	TXTLINE	"1 KREDIT / 1 DM"
DM22	TXTLINE	"2 KREDITE / 2 DM"
DM55	TXTLINE	"5 KREDITE / 5 DM"
DM65	TXTLINE	"6 KREDITE / 5 DM"
DM75	TXTLINE	"7 KREDITE / 5 DM"
DM85	TXTLINE	"8 KREDITE / 5 DM"

F3F5	TXTLINE	"3 CREDITS / 5F"
F2F5
F25	TXTLINE	"2 CREDITS / 5F"
F15	TXTLINE	"1 CREDIT / 5F"
F510	TXTLINE	"5 CREDITS / 10F"
F1120	TXTLINE	"11 CREDITS / 2 X 10F"
F4109	TXTLINE	"9 CREDITS / 2 X 10F"
F4107	TXTLINE	"7 CREDITS / 2 X 10F"
F4105	TXTLINE	"5 CREDITS / 2 X 10F"
F410	TXTLINE	"4 CREDITS / 10F"
F310	TXTLINE	"3 CREDITS / 10F"
F210	TXTLINE	"2 CREDITS / 10F"

F3X1F	TXTLINE	"1 CREDIT / 3 X 1F"
F25510	TXTLINE	"2 CRED/ 5F  5 CRED/ 10F"
F2X1F	TXTLINE	"1 CREDIT / 2 X 1F"
F52X5	TXTLINE	"5 CREDITS / 2 X 5F"
F72X5	TXTLINE	"7 CREDITS / 2 X 5F"

SFRANC11
	TXTLINE	"1 CREDIT / 1F"
SFRANC65
	TXTLINE	"6 CREDITS / 5F"
SFRANC75
	TXTLINE	"7 CREDITS / 5F"
SFRANC85
	TXTLINE	"8 CREDITS / 5F"

P1500L_P
	TXTLINE	"1 CREDIT / 500 LIRE"

UK_1201 TXTLINE	"1 CREDIT / 20 P"
UK_1202 TXTLINE	"3 CREDITS / 50 P"

UK_2201 TXTLINE	"2 CREDITS / 20 P"
UK_2202 TXTLINE	"5 CREDITS / 50 P"

UK_3201 TXTLINE	"1 CREDIT/30P 2 CREDITS/50P"
;UK_3202 TXTLINE	"2 CREDITS / 50 P"
UK_3203 TXTLINE	"4 CREDITS / L1.00"

SP_11	TXTLINE	"1 CREDIT / 25 PESETA"
SP_44	TXTLINE	"4 CREDITS / 100 PESETA"
SP_54	TXTLINE	"5 CREDITS / 100 PESETA"
NZ_131
AU_36	TXTLINE	"1 CREDIT / 3 X 20 CENTS"
AU_2D	TXTLINE	"2 CREDITS / $ 1.00"
AU_520	TXTLINE	"1 CREDIT / 5 X 20 CENTS"
AU_1D	TXTLINE	"1 CREDIT / $ 1.00"
AU_32D	TXTLINE	"3 CREDITS / $ 2.00"
JAP_101 TXTLINE	"1 CREDIT / 100 YEN"
JAP_201 TXTLINE	"2 CREDITS / 100 YEN"
ASTA101 TXTLINE	"1 CREDIT / 2 X 5 SCHILLING"
ASTA102 TXTLINE	"3 CREDITS / 2 X 10 SCHILLING"
ASTA151 TXTLINE	"1 CREDIT / 5 SCHILLING"
ASTA152 TXTLINE	"2 CREDITS / 10 SCHILLING"

BEL_1201	TXTLINE	"1 CREDIT / 20F"
BEL_2201	TXTLINE	"2 CREDITS / 20F"
BEL_3201	TXTLINE	"3 CREDITS / 20F"
BEL_ECA1	TXTLINE	"1 CREDIT / 25F"
BEL_ECA2	TXTLINE	"4 CREDITS / 100F"
SWED_S51	TXTLINE	"1 CREDIT / 3 X 1 KRONA"
SWED_S52	TXTLINE	"2 CREDITS / 5 KRONA"

NZ_121	TXTLINE	"1 CREDIT / 2 X 20 CENTS"

HF_11	TXTLINE	"1 CREDIT / 1 HFI"
HF_32	TXTLINE	"3 CREDITS / 2.5 HFI"

FIN_1	TXTLINE	"1 CREDIT / 1 MARKKA"

DEN_12
NOR_12	TXTLINE	"1 CREDIT / 2 X 1 KRONE"
NOR_35	TXTLINE	"3 CREDITS / 5 X 1 KRONE"

DEN_35	TXTLINE	"3 CR/5 KRONE  7 CR/2X5 KRONE"
;DEN_710	TXTLINE	"7 CREDITS / 2 X 5 KRONE"

ANT1P25	TXTLINE	"1 CREDIT / 25 CENTS"
ANT4DOL	TXTLINE	"4 CREDITS / 1 GUILDER"
	.even

**************************************************************************
*									 *
*	   COIN SLOT TITLES						 *
*									 *
**************************************************************************
USA_QQ		.byte   "25 CENT       25 CENT",0
		.even
USA_QDQ		.byte	"25 CENT     $1.00     25 CENT",0
		.even
USA_ESLOT	.byte	"1 DOLLAR  10/25/5 CENT",0
		.even
GERMAN_15	.byte   "1 DM          5 DM",0
		.even
GERMAN_3EL	.byte   "5 DM   2 DM   1 DM",0
		.even
GERMAN_ESLOT	.byte	"5/1/2 DM",0
		.even
FRENCH510	.byte   "5 F           10 F",0
	 	.even
FRENCH1510	.byte   "1 F    5 F      10 F",0
		.even
FRANCE_ESLOT	.byte	"1/10/5 FRANCS",0
		.even
FRENCH1F5F	.byte	"1 F       5 F",0
		.even
CAN_QD		.byte	"25 CENT       $ 1.00",0
		.even
SWISS15		.byte   "1 F           5 F",0
		.even
ITALYLIRE	.byte   "500 LIRE      500 LIRE",0
		.even
UK2050		.byte   "20 P          50 P",0
		.even
UK_ELEC		.byte   "L1.00   50P  20P  10P",0
		.even
UK_CCU		.byte	"CCU ON LEFT SLOT            ",0
		.even
PESETA25	.byte   "25 PESETA     100 PESETA",0
		.even
AUST20C		.byte   "20 CENT       $ 1.00",0
		.even
YEN100		.byte   "100 YEN       100 YEN",0
		.even
BELGIUM_ESLOT	.byte	"50/5/20 F",0
		.even
SHILL510     .byte   "5 SCHILLING   10 SCHILLING"
	     .BYTE 0
	     .EVEN
FRANC20      .byte   "20 F          20 F"
	     .BYTE 0
	     .EVEN
F52050	     .byte   "50 F   20 F    5 F"
	     .BYTE 0
	     .EVEN
KRONA5	     .byte   "1 KRONA       5 KRONA"
	     .BYTE 0
	     .EVEN
NZ20	     .byte   "20 CENT       20 CENT"
	     .BYTE 0
	     .EVEN
HFSLOT	     .byte   "1 HFI         2.5 HFI"
	     .BYTE 0
	     .EVEN

MKSLOT	     .byte   "1 MARKKA      1 MARKKA"
	     .BYTE 0
	     .EVEN

NKRSLOT      .byte   "1 KRONE       1 KRONE"
	     .BYTE 0
	     .EVEN

DKRSLOT      .byte   "1 KRONE       5 KRONE"
	     .BYTE 0
	     .EVEN

ANTSLOT      .byte   "25 CENTS      1 GUILDER"
	     .BYTE 0
	     .EVEN

**************************************************************************
*									 *
*	   MENU DESCRIPTORS						 *
*									 *
**************************************************************************
*
*	 MAIN TEST MENU
*
MEN_MAIN
	 .LONG	 RD7FONT	;FONT	
	 .LONG	 STRCNRM	;CENTER PLEASE
	 .LONG	 MESSMAIN	;TITLE
	 .WORD	 ROBO_WHITE	;COLOR OF TITLE
	 .WORD	 MENU_X 	;UL X
	 .WORD	 MENU_Y-3	;UL Y
	 .WORD	 MENU_DY	;VERTICAL SPACING
	 .WORD	 ROBO_WHITE	;COLOR WHEN NOT SELECTED
	 .WORD	 16		;HEIGHT OF SELECTION BAR
	 .WORD	 -4		;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
	 .WORD	 BAR_DX 	;EXTRA X ON EACH SIDE.
	 .WORD	 BAR_WID	;WIDTH OF BAR!
	 .WORD	 ROBO_DECAY	;TEXT COLOR OF SELECTED ITEM
	 .LONG	 MESS_DIAG,GO_DIAG,DIAG_HELP
	 .LONG	 MESS_COIN_AUD,GO_BOOK,COIN_HELP
	 .LONG	 MESS_GAME_AUD,GO_AUD,AUDIT_HELP
	 .LONG	 MESS_GAME_ADJ,GO_ADJ,ADJUST_HELP
	 .LONG	 MESS_UTIL,GO_UTIL,UTIL_HELP
	 .LONG	 MESS_EXIT,0,EXIT_HELP	;SPECIAL CASE!
	 .LONG	 0		;END

* UTILITES MENU GOES LEFT OF CENTER

UM_WID	 EQU	 206
UM_X	 EQU	 TIT_ULX+GAP+MB_XWID+(UM_WID/2)+C_KLUDGE

MEN_UTIL .LONG	 RD7FONT	;FONT
	 .LONG	 STRCNRM	;CENTER PLEASE
	 .LONG	 MESSUTIL	;TITLE
	 .WORD	 ROBO_PINK	;COLOR OF TITLE
	 .WORD	 UM_X		;UL X
	 .WORD	 MENU_Y-3	;UL Y
	 .WORD	 20		;VERTICAL SPACING
	 .WORD	 ROBO_PINK	;COLOR WHEN NOT SELECTED
	 .WORD	 16		;HEIGHT OF SELECTION BAR
	 .WORD	 -4		;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
	 .WORD	 BAR_DX 	;EXTRA X ON EACH SIDE.
	 .WORD	 UM_WID 	;WIDTH OF BAR!
	 .WORD	 ROBO_DECAY	;TEXT COLOR OF SELECTED ITEM
	 .LONG	 MESS_CLCRED,DO_CLCRED,CLCRED_HELP
	 .LONG	 MESS_CLCOIN,DO_CLCOIN,CLCOIN_HELP
	 .LONG	 MESS_CLAUD,DO_CLAUD,CLAUD_HELP
	 .LONG	 MESS_HSRES,DO_HSRES,HSRES_HELP
	 .LONG	 MESS_DEF_ADJ,DO_DEF_ADJ,DEF_ADJ_HELP
	 .LONG	 MESS_FACSET,DO_FACSET,FACSET_HELP
	 .LONG	 MESS_MM,0,BLNK_HELP	;RETURN TO MAIN MENU
	 .LONG	 0		;END

* DIAGNOSTIC TESTS MENU

MEN_DIAG
	.LONG	RD7FONT		;FONT
	.LONG	STRCNRM		;CENTER PLEASE
	.LONG	MESSDIAG	;TITLE
	.WORD	ROBO_RED	;COLOR OF TITLE
	.WORD	200		;UL X
	.WORD	MENU_Y-3	;UL Y
	.WORD	20		;VERTICAL SPACING
	.WORD	ROBO_RED	;COLOR WHEN NOT SELECTED
	.WORD	16		;HEIGHT OF SELECTION BAR
	.WORD	-4		;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
	.WORD	BAR_DX		;EXTRA X ON EACH SIDE.
	.WORD	195		;WIDTH OF BAR!  (A LITTLE FATTER)
	.WORD	ROBO_DECAY	;TEXT COLOR OF SELECTED ITEM
	.LONG	MESS_SWTEST,GO_SWTEST,BLNK_HELP
	.LONG	diptst_mess,dipsw_test,BLNK_HELP
ROM_LEV EQU	3		;TEST NUMBER FOLLOWING ROM TEST
	.LONG	MESS_CPUTEST,GO_CPUTEST,BLNK_HELP
RTR_LEV EQU	4		;TEST NUMBER FOLLOWING CPU TEST (FOR RETURN)
	.LONG	M_STEST,SNDTST,BLNK_HELP
	.LONG	MESS_PATTERNS,GO_PATTERNS,BLNK_HELP
	.LONG	MESS_BURN,DO_BURN,BLNK_HELP
	.LONG	MESS_MM,0,BLNK_HELP	;RETURN TO MAIN MENU
	.LONG	0

STM_WID EQU	  250


* PRESS ANY BUTTON TO CONTINUE

ANY_MENU
	.LONG	RD7FONT		;FONT
	.LONG	STRCNRM		;CENTER PLEASE
	.LONG	0		;TITLE
	.WORD	0		;COLOR OF TITLE
	.WORD	200		;UL X
	.WORD	200		;UL Y
	.WORD	MENU_DY		;VERTICAL SPACING
	.WORD	ROBO_CYAN	;COLOR WHEN NOT SELECTED
	.WORD	BAR_HITE	;HEIGHT OF SELECTION BAR
	.WORD	-12		;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
	.WORD	BAR_DX		;EXTRA X ON EACH SIDE.
	.WORD	234		;WIDTH OF BAR!
	.WORD	ROBO_DECAY	;TEXT COLOR OF SELECTED ITEM
	.LONG	MESS_ANY,0,NO_HELP
	.LONG	0

* MONITOR PATTERNS

MEN_PATTERNS
	.LONG	RD7FONT		;FONT
	.LONG	STRCNRM		;CENTER PLEASE
	.LONG	MESSPAT		;TITLE
	.WORD	ROBO_YELLOW	;COLOR OF TITLE
	.WORD	200		;UL X	    (CENTER IT!)
	.WORD	MENU_Y-3	;UL Y
	.WORD	23		;VERTICAL SPACING
	.WORD	ROBO_YELLOW	;COLOR WHEN NOT SELECTED
	.WORD	16		;HEIGHT OF SELECTION BAR
	.WORD	-4		;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
	.WORD	BAR_DX		;EXTRA X ON EACH SIDE.
	.WORD	234		;WIDTH OF BAR!
	.WORD	ROBO_DECAY	;TEXT COLOR OF SELECTED ITEM
	.LONG	MESS_RED,GO_RED,BLNK_HELP
	.LONG	MESS_GREEN,GO_GREEN,BLNK_HELP
	.LONG	MESS_BLUE,GO_BLUE,BLNK_HELP
	.LONG	MESS_BARS,GO_BARS,BLNK_HELP
	.LONG	MESS_CROSS,GO_CROSS,BLNK_HELP
	.LONG	MESS_DIAGM,0,BLNK_HELP
	.LONG	MESS_MM,FORCE_MAIN,NO_HELP	;RETURN TO MAIN MENU
	.LONG	0

* DETAILED COINAGE AVAILABLE (ON 1ST COINAGE PAGE)

MEN_DETAIL
	.LONG	RD7FONT	;FONT
	.LONG	STRCNRM	;CENTER PLEASE
	.LONG	MESSPAT	;TITLE
	.WORD	ROBO_YELLOW	;COLOR OF TITLE
	.WORD	200		;UL X	    (CENTER IT!)
	.WORD	224		;UL Y
	.WORD	12		;VERTICAL SPACING
	.WORD	ROBO_CYAN	;COLOR WHEN NOT SELECTED
	.WORD	10		;HEIGHT OF SELECTION BAR
	.WORD	-1		;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
	.WORD	BAR_DX 	;EXTRA X ON EACH SIDE.
	.WORD	157		;WIDTH OF BAR!
	.WORD	ROBO_DECAY	;TEXT COLOR OF SELECTED ITEM
;	.LONG	MESS_DETAIL,0,NO_HELP		;DETAILED SECTION
	.LONG	MESS_CLCOIN,0,NO_HELP		;Clr coins
	.LONG	MESS_MM,FORCE_MAIN,NO_HELP	;RETURN TO MAIN MENU
	.LONG	0

* YES/NO   (FOR ARE YOU SURE?)

MEN_YN	.LONG	 RD7FONT	;FONT
	.LONG	 STRCNRM	;CENTER PLEASE
	.LONG	 MESSDIAG	;TITLE
	.WORD	 ROBO_RED	;COLOR OF TITLE
	.WORD	 200		;UL X
	.WORD	 166		;UL Y
	.WORD	 19		;VERTICAL SPACING
	.WORD	 ROBO_YELLOW	;COLOR WHEN NOT SELECTED
	.WORD	 16		;HEIGHT OF SELECTION BAR
	.WORD	 -4		;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
	.WORD	 BAR_DX 	;EXTRA X ON EACH SIDE.
	.WORD	 78		;WIDTH OF BAR!  (A LITTLE FATTER)
	.WORD	 ROBO_DECAY	;TEXT COLOR OF SELECTED ITEM
	.LONG	 MESS_YES,0,NO_HELP
	.LONG	 MESS_NO,0,NO_HELP
	.LONG	 0

* NEXT AUDIT PAGE

MEN_AP1 .LONG	 RD7FONT	;FONT
	.LONG	 STRCNRM	;CENTER PLEASE
	.LONG	 MESSPAT	;TITLE
	.WORD	 ROBO_YELLOW	;COLOR OF TITLE
	.WORD	 200		;UL X	    (CENTER IT!)
	.WORD	 226		;UL Y
	.WORD	 12		;VERTICAL SPACING
	.WORD	 ROBO_CYAN	;COLOR WHEN NOT SELECTED
	.WORD	 10		;HEIGHT OF SELECTION BAR
	.WORD	 -1		;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
	.WORD	 BAR_DX 	;EXTRA X ON EACH SIDE.
	.WORD	 157		;WIDTH OF BAR!
	.WORD	 ROBO_DECAY	;TEXT COLOR OF SELECTED ITEM
	.LONG	 MESS_TOPAGE2,0,NO_HELP 	;DETAILED SECTION
	.LONG	 MESS_MM,FORCE_MAIN,NO_HELP;RETURN TO MAIN MENU
	.LONG	 0

* PREVIOUS AUDIT PAGE?  (ON 2ND GAME AUDIT PAGE)

MEN_AP2 .LONG	 RD7FONT	;FONT
	.LONG	 STRCNRM	;CENTER PLEASE
	.LONG	 MESSPAT	;TITLE
	.WORD	 ROBO_YELLOW	;COLOR OF TITLE
	.WORD	 200		;UL X	    (CENTER IT!)
	.WORD	 226		;UL Y
	.WORD	 12		;VERTICAL SPACING
	.WORD	 ROBO_CYAN	;COLOR WHEN NOT SELECTED
	.WORD	 10		;HEIGHT OF SELECTION BAR
	.WORD	 -1		;DISTANCE OF BAR FROM TOP OF TEXT (NEGATIVE)
	.WORD	 BAR_DX 	;EXTRA X ON EACH SIDE.
	.WORD	 157		;WIDTH OF BAR!
	.WORD	 ROBO_DECAY	;TEXT COLOR OF SELECTED ITEM
	.LONG	 MESS_BACKP1,0,NO_HELP		;DETAILED SECTION
	.LONG	 MESS_MM,FORCE_MAIN,NO_HELP;RETURN TO MAIN MENU
	.LONG	 0

**************************************************************************
*									 *
*	  HELP MENUS FOR MAIN MENU					 *
*									 *
**************************************************************************
*	 HM_JUST	 0 = CENTER   1 = LEFT
*	 HM_COLOR
*	 HM_ENTS

DIAG_HELP
	.WORD	0		;CENTER JUSTIFY
	.WORD	ROBO_PINK	;COLOR
	.WORD	6		;# ENTRIES
	.LONG	MESS_SWTEST
	.long	diptst_mess
	.LONG	MESS_CPUTEST
	.LONG	M_STEST
	.LONG	MESS_PATTERNS
	.LONG	U_BURNIN

COIN_HELP
	.WORD	0		;CENTER JUSTIFY
	.WORD	ROBO_PINK	;COLOR
	.WORD	3		;2 ENTRIES
	.LONG	CH_0
	.LONG	CH_1
	.LONG	CH_2

AUDIT_HELP
	.WORD	0		;CENTER JUSTIFY
	.WORD	ROBO_PINK	;COLOR
	.WORD	2		;2 ENTRIES
	.LONG	AH_1
	.LONG	AH_2

ADJUST_HELP
	.WORD	0		;CENTER JUSTIFY
	.WORD	ROBO_PINK	;COLOR
	.WORD	3		;3 ENTRIES
	.LONG	AD_1
	.LONG	AD_2
	.LONG	AD_3

UTIL_HELP
	.WORD	0		;CENTER JUSTIFY
	.WORD	ROBO_PINK	;COLOR
	.WORD	5		;6 ENTRIES
	.LONG	U_CLR_CRED
	.LONG	U_CLR_COIN
	.LONG	U_CLR_AUD
	.LONG	U_HSRESET
	.LONG	U_FACTORY

EXIT_HELP
	.WORD	0		;CENTER JUSTIFY
	.WORD	ROBO_PINK	;COLOR
	.WORD	1		;1 ENTRY
	.LONG	U_END


********************************
* HELP FOR UTILITY MENU

CLCRED_HELP
	.WORD	0		;CENTER JUSTIFY
	.WORD	ROBO_CYAN	;COLOR
	.WORD	3		;2 ENTRIES
	.LONG	MEH_CLCRED1
	.LONG	MEH_CLCRED2
	.LONG	MEH_CLCRED3

CLCOIN_HELP
	.WORD	0		;CENTER JUSTIFY
	.WORD	ROBO_CYAN	;COLOR
	.WORD	4		;2 ENTRIES
	.LONG	MEH_CLCOIN1
	.LONG	MEH_CLCOIN2
	.LONG	MEH_CLCOIN3
	.LONG	MEH_CLCOIN4

CLAUD_HELP
	.WORD	0		;CENTER JUSTIFY
	.WORD	ROBO_CYAN	;COLOR
	.WORD	2		;2 ENTRIES
	.LONG	MEH_CLAUD1
	.LONG	MEH_CLAUD2

HSRES_HELP
	.WORD	0		;CENTER JUSTIFY
	.WORD	ROBO_CYAN	;COLOR
	.WORD	3		;2 ENTRIES
	.LONG	MEH_RESHS1
	.LONG	MEH_RESHS2
	.LONG	MEH_RESHS3

DEF_ADJ_HELP
	.WORD	0		;CENTER JUSTIFY
	.WORD	ROBO_CYAN	;COLOR
	.WORD	4		;2 ENTRIES
	.LONG	MEH_DEFA1
	.LONG	MEH_DEFA2
	.LONG	MEH_DEFA3
	.LONG	MEH_DEFA4

FACSET_HELP
	.WORD	0		;CENTER JUSTIFY
	.WORD	ROBO_CYAN	;COLOR
	.WORD	6		;2 ENTRIES
	.LONG	MEH_FAC1
	.LONG	MEH_FAC2
	.LONG	MEH_FAC3
	.LONG	MEH_FAC4
	.LONG	MEH_FAC5
	.LONG	MEH_FAC6

**************************************************************************
*									 *
*	   TEXT STRINGS 						 *
*									 *
**************************************************************************
MESS_YES
	.byte	 "YES",0
	.EVEN

MESS_NO .byte	 "NO",0
	.EVEN

;MESS_CLEAR_SUBS
;	  .byte	  "CLEAR SUBTOTALS"
;	  .BYTE 	  0
;	  .EVEN
;
;MESS_SUBS_CLEAR
;	  .byte	  "SUBTOTALS CLEARED"
;	  .BYTE 	  0
;	  .EVEN

MESS_TOPAGE2
	 .byte	 "NEXT AUDIT PAGE"
	 .BYTE		 0
	 .EVEN

MESS_BACKP1
	 .byte	 "PREVIOUS AUDIT PAGE"
	 .BYTE		 0
	 .EVEN

MESS_ANY
	 .byte	 "ANY BUTTON TO CONTINUE"
	 .BYTE		 0
	 .EVEN

MESS_MM
	 .byte	 "RETURN TO MAIN MENU"
	 .BYTE		 0
	 .EVEN

MESSDIAG				;THIS IS TITLE OF PAGE
MESS_DIAG
	 .byte	 "DIAGNOSTIC TESTS"
	 .BYTE	   0
	 .EVEN
MESS_COIN_AUD
	 .byte	 "COIN BOOKKEEPING"
	 .BYTE	   0
	 .EVEN
MESS_GAME_AUD
	 .byte	 "GAME AUDITS"
	 .BYTE	   0
	 .EVEN

MESS_GAME_ADJ
	 .byte	 "GAME ADJUSTMENT"
	 .BYTE	   0
	 .EVEN
MESS_UTIL
	 .byte	 "UTILITIES"
	 .BYTE	   0
	 .EVEN

MESS_EXIT
	 .byte	 "EXIT TO GAME OVER"
	 .BYTE	   0
	 .EVEN

CH_0	 .byte	 "VIEW COINBOX"
	 .BYTE	 0
	 .EVEN
CH_1	 .byte	 "TOTALS AND"
	 .BYTE	 0
	 .EVEN
CH_2	 .byte	 "GAMEPLAY COUNTERS"
	 .BYTE	 0
	 .EVEN

AH_1	 .byte	 "VIEW GAME"
	 .BYTE	 0
	 .EVEN
AH_2	 .byte	 "PLAY STATISTICS"
	 .BYTE	 0
	 .EVEN

AD_1	 .byte	 "MAKE CHANGES"
	 .BYTE	 0
	 .EVEN
AD_2	 .byte	 "TO PRICING AND"
	 .BYTE	 0
	 .EVEN
AD_3	 .byte	 "GAME DIFFICULTY"
	 .BYTE	 0
	 .EVEN

MESS_CLCRED
U_CLR_CRED	 .byte "CLEAR CREDITS"
	 .BYTE	 0
	 .EVEN

MESS_CCCONF	 .byte "CREDITS CLEARED"
	 .BYTE	 0
	 .EVEN

MESS_CLCOIN
U_CLR_COIN	 .byte "CLEAR COIN COUNTERS"
	 .BYTE	 0
	 .EVEN

MESS_CLAUD
U_CLR_AUD	 .byte "CLEAR GAME AUDITS"
	 .BYTE	 0
	 .EVEN

MESS_HSRESET
U_HSRESET	 .byte "RESET HIGH SCORES"
	 .BYTE	 0
	 .EVEN

MESS_HSRES
	 .byte "RESET HIGH SCORES"
	 .BYTE	 0
	 .EVEN

;M_OPMESS_TIT
;U_OPMESS	  .byte "OPERATOR MESSAGE"
;	  .BYTE   0
;	  .EVEN

;M_SET_OMESS
;;MESS_OPMESS	   .byte "SET OPERATOR MESSAGE"
;	  .BYTE   0
;	  .EVEN

U_BURNIN	.byte "BURN-IN TEST",0
	.even

MESS_BURN	.byte "RUN BURN-IN TEST",0
	.even


MESS_DEF_ADJ	.byte "DEFAULT ADJUSTMENTS",0
	.even

U_FACTORY	.byte "FACTORY SETTINGS",0
	.even

MESS_FACSET	.byte "FULL FACTORY RESTORE",0
	.even

U_END	.byte "END TESTING",0
	.even

MESS_SWTEST	.byte "SWITCH TEST",0
	.even
diptst_mess	.byte "DIP SWITCH TEST",0
	.even
MESS_CPUTEST	.byte "CPU BOARD TEST",0
	.even
M_STEST	.byte	"SOUND BOARD TEST",0
	.even

MESSPAT 			;HEADER TITLE
MESS_PATTERNS	.byte "MONITOR PATTERNS",0
	.EVEN

MESS_RED	.byte "RED SCREEN",0
	.EVEN
MESS_GREEN	 .byte "GREEN SCREEN",0
	.EVEN
MESS_BLUE	 .byte "BLUE SCREEN",0
	.EVEN
MESS_BARS	 .byte "COLOR BARS",0
	.EVEN
MESS_CROSS	 .byte "CROSSHATCH  PATTERN",0
	.EVEN
MESS_DIAGM	 .byte "BACK TO DIAGNOSTICS MENU",0
	.EVEN

*	ON FULL RESTORE....THE FOLLOWING IS PRINTED.
	;0 = END OF STRING...1 = MORE MESSAGES!

MESS_RESET
	MESS_MAC  RD7FONT,SPACING20,200,80,ROBO_RED,STRCNRM,0
MESS_FACFAIL
	.byte  "FAILURE IN CMOS RAM",0,0
	.EVEN
MESS_FFSCONF
MESS_FAC MESS_MAC RD7FONT,SPACING20,200,96,ROBO_WHITE,STRCNRM,0
MESS_DEFCONF
	.byte   "DEFAULT ADJUSTMENTS RESTORED.",0,1
	.EVEN
	MESS_MAC RD7FONT,SPACING20,200,112,ROBO_YELLOW,STRCNRM,0

MESS_CCNCONF
	.byte  "COIN COUNTERS CLEARED.",0,1
	.EVEN
	MESS_MAC RD7FONT,SPACING20,200,128,ROBO_ORANGE,STRCNRM,0
MESS_CAUDCONF
	.byte  "GAME AUDITS CLEARED.",0,1
	.EVEN
	MESS_MAC RD7FONT,SPACING20,200,144,ROBO_CYAN,STRCNRM,0
MESS_HSRCONF
	.byte  "HIGH SCORE TABLE RESET.",0,0
	.EVEN

MESS_CANCELLED
	.byte "CANCELLED",0
	.EVEN

CIN_X	EQU	(TIT_ULX+TIT_LRX)/2
CR_X	EQU	CIN_X-34
CIN_Y	EQU	86

CIY1	EQU	CIN_Y+14
CIY2	EQU	CIY1+15
CIY3	EQU	CIY2+25
CIY4	EQU	CIY3+25

M_TEAM	MESS_MAC  RD7FONT,SPACING20,200,67,ROBO_WHITE,STRCNRM,0
	.byte	"TOTAL CARNAGE TEAM:",0,1
	MESS_MAC  RD7FONT,SPACING20,200,97,ROBO_WHITE,STRCNRM,0
	.byte	"MARK TURMELL",0,1
	MESS_MAC  RD7FONT,SPACING20,200,107,ROBO_WHITE,STRCNRM,0
	.byte	"JOHN TOBIAS",0,1
	MESS_MAC  RD7FONT,SPACING20,200,117,ROBO_WHITE,STRCNRM,0
	.byte	"JIM GENTILE",0,1
	MESS_MAC  RD7FONT,SPACING20,200,127,ROBO_WHITE,STRCNRM,0
	.byte	"SHAWN LIPTAK",0,1
	MESS_MAC  RD7FONT,SPACING20,200,137,ROBO_WHITE,STRCNRM,0
	.byte	"JON HEY",0,1
	MESS_MAC  RD7FONT,SPACING20,200,147,ROBO_WHITE,STRCNRM,0
	.byte	"TONY GOSKIE",0,0
	.even

**************************************************************************
*									 *
*	   STRINGS FOR UTILITY HELP MENUS				 *
*									 *
**************************************************************************
MEH_CLCRED1	 .byte "REMOVE ANY",0
		 .EVEN
MEH_CLCRED2	 .byte "POSTED CREDITS",0
		 .EVEN
MEH_CLCRED3	 .byte "FROM THE GAME",0
		 .EVEN
MEH_CLCOIN1	 .byte "CLEAR OUT PAID",0
		 .EVEN
MEH_CLCOIN2	 .byte "CREDITS TOTAL",0
		 .EVEN
MEH_CLCOIN3	 .byte "AND THE COIN",0
		 .EVEN
MEH_CLCOIN4	 .byte "SLOT COUNTERS",0
		 .EVEN
MEH_CLAUD1	 .byte "CLEAR GAMEPLAY",0
		 .EVEN
MEH_CLAUD2	 .byte "STATISTICS",0
		 .EVEN
MEH_RESHS1	 .byte "RESET HIGH SCORE",0
		 .EVEN
MEH_RESHS2	 .byte "TABLE TO FACTORY",0
		 .EVEN
MEH_RESHS3	 .byte "DEFAULT VALUES",0
		 .EVEN
MEH_DEFA1	 .byte "SET ALL GAME",0
		 .EVEN
MEH_DEFA2	 .byte "ADJUSTMENTS TO",0
		 .EVEN
MEH_DEFA3	 .byte "THEIR FACTORY",0
		 .EVEN
MEH_DEFA4	 .byte "DEFAULT VALUE",0
		 .EVEN
MEH_FAC1	 .byte "CLEAR AUDITS",0
		 .EVEN
MEH_FAC2	 .byte "COUNTERS.",0
		 .EVEN
MEH_FAC3	 .byte "RESET",0
		 .EVEN
MEH_FAC4	 .byte "ADJUSTMENTS",0
		 .EVEN
MEH_FAC5	 .byte "THE HIGH SCORE",0
		 .EVEN
MEH_FAC6	 .byte "TABLE",0
		 .EVEN
**************************************************************************
*									 *
*	  MAIN MENU NAMES						 *
*									 *
**************************************************************************
MESSMAIN
	.byte	"TOTAL CARNAGE TEST MENU",0
	.even

MESSUTIL
	.byte	"UTILITY MENU",0
	.even


	.end
