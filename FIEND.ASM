**************************************************************
*
* Software:		Mark Turmell
* Initiated:		12/3/89
*
* Modified:		!
*
* COPYRIGHT (C) 1992 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 1/7/92 13:23
**************************************************************
 	.FILE	'FIEND.ASM'
	.TITLE	'TOTAL CARNAGE GAME PROGRAM'
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST


	.INCLUDE	"MPROC.EQU"		;MPROC EQUATES
	.INCLUDE	"DISP.EQU"		;DISPLAY PROC. EQUATES
	.INCLUDE	"\VIDEO\SYS\SYS.INC"	;Z UNIT SYSTEM EQUATES
	.INCLUDE	"IMGTBL.GLO"
	.INCLUDE	"GAME.EQU"
	.INCLUDE	"FINGRNT.TBL"
	.include	"\video\sys\gsp.inc"
	.include	"shawn.hdr"


;SOUNDS EXTERNAL
	.REF	EXP2HIB,ALTEXP5,EXP5,SALTXP4
	.REF	FNDSND,UGH2,UGH3,EXP3,EXP2HI,TOTCARN,CHUCK,SQUISH
	.REF	ALTEXP1,AGLSEXP,FIREDI
	.REF	UGH1,UGH4

;SYMBOLS EXTERNALLY DEFINED

	.REF	bomb_neutron,SHK_ON,RNDRNG0
	.REF	DO_DIFF2,INTO,SPINFLGS,P1DATA,P2DATA,HALT,PLYROBJS
	.ref	FRANIM,FRANIMQ
	.REF	PCNT,FLASHME,SCRADD2,RNDRNG,RANDOM,WAVE,PBLSTS
	.REF	RANDPER,PCTOT,CHUNK_OBJ,GETFPAL,XBOOM2,BOOM2
	.REF	BLSTS,GPALOBJ,TBLST,SHAKEME,BLSTS2,BOOMS
;	.REF	GOBACK
	.ref	sine_get,PLYRPRCS,GET_WVADDR,DO_GOOJ,OBJOFF
	.ref	SLM,OUT_FLG
	.REF	SHORT_PLYR
	.ref	bossmeterv

;SYMBOLS DEFINED IN THIS FILE

	.DEF	HIT_TURET,MORE2,MORE3,FLAMES,SCORE_IT,FAME4,FAME2,FAME3
	.DEF	YKIL_FT,KILL_F2,PUSH_FT,YKIL_FT2,XYSKOBJ,FND_NOWLK
	.DEF	KILL_CBALL,GETUGH,KBM,PUSHME,JFLAMES
	.DEF	MAXFND,FND_CNT

;UNINITIALIZED RAM DEFINITIONS

	.BSS	MAXFND,16		;MAXIMUM ALLOWED ON SCRN THE WAVE
	.BSS	FND_CNT,16		;CURRENT TOTAL FIENDS ON SCRN
	.BSS	FND_NOWLK,16		;1=DO NOT WALK, 0=WALK IF YOU LIKE
	.bss	fndnumfire,16		;# of firing fiends

;EQUATES FOR THIS FILE


HITFND	.EQU	4*30
HITTRT	.EQU	20*30	;30*30		;ABOVE T72 TANK
;HITTRT2	.EQU	15*30		;BTR60 TURRET	;19*30
HITTRT2	.EQU	5*30			;NORMAL BTR60 TURRET
HITTRT2A .EQU	9*30			;BTR60 TURRET FOR ROADWAY
HITTRT3	.EQU	25*30			;SAND BAG GUNNER
HITTRT4	.EQU	400*30			;BOOB SHIP TURRET

;KPTSOBJ		.EQU	PDATA		;UHL
;KPTSOBJ IS DEFINED IN T72.ASM

;Fiend process offsets
	WORDPD	DIS,2		;Object distance count
	WORDPD	SK_DIR,4	;Seek dir 1-8
	WORDPD	LEVEL,5		;Difficulty level

	APTRPD	KPTANKO,6
;KPTANKO IS DEFINED IN ARAB.ASM
;HSPD		.EQU	PDATA+128
;H2SPD		.EQU	PDATA+160
;VSPD		.EQU	PDATA+192
;V2SPD		.EQU	PDATA+224

	WORDPD	ABSRB,16	;ABSRB IS REFERENCED IN ARAB.ASM
	WORDPD	SQ_NUM,17	;Squat #
	WORDPD	JFLG,18		;!0=Jumping
	WORDPD	INDEX,19	;0-4
	WORDPD	DIR,20		;Current direction 1-8
	APTRPD	fndsp_p,21	;*Spit process or 0

	APTRPD	KPTSO,22	;

;THIS IS SAME AS IN T72.ASM
;TANK/SHRAPNEL BULLET DATA STRUCTURE

BNCS	.EQU	PDATA		;UHW
LAST	.EQU	PDATA+16	;UHW
FDLY	.EQU	PDATA+32	;UHW	;FRANIM DELAY


	.TEXT

********************************

;ON TOP OF GUNPIT GUNNER
;MORE EXPLOSIONS FROM PIT

MOREP	MOVE	A8,A9		;A9=TANK BASE IMG PNTR
	MOVK	10,A10		;SEND MORE EXPLOSIONS OUT OF OLD TURRET AREA
ZMP	SLEEPK	1
	CREATE	FUTUREPID,SMLEP
	MOVI	ALTEXP5,A0
	CALLA	ONESND
	MOVI	EXP5,A0
	CALLA	ONESND
	DSJ	A10,ZMP
	DIE

********************************

MOREG
;ON TANK BASE DEATH - GREY CLOUDS
;MORE EXPLOSIONS FROM TANK
	MOVE	A8,A9		;A9=TANK BASE IMG PNTR
	MOVI	80,A10		;SEND MORE EXPLOSIONS OUT OF OLD TURRET AREA
GZM1	SLEEPK	3
	CREATE	FUTUREPID,SMLE1G
	DSJ	A10,GZM1
	DIE
MORE2
	CREATE0	MOREG
;	CREATE0	MORESND
;	MOVE	A0,*A13(PDATA),L
;ON TANK BASE DEATH
;MORE EXPLOSIONS FROM TANK
	MOVE	A8,A9		;A9=TANK BASE IMG PNTR
	MOVI	190,A10		;SEND MORE EXPLOSIONS OUT OF OLD TURRET AREA
	CREATE0	DBMS
ZM1
	SLEEPK	1
	CREATE	FUTUREPID,SMLE1
	DSJ	A10,ZM1
;	MOVE	*A13(PDATA),A0,L
;	CALLA	KILL
	DIE
DBMS
	JSRP	BOOMS
	SLEEP	60
	DIE

********************************

MOREZ
	MOVK	30,A10	 ;35		;FOR ON ROAD TURRET BLOW
	JRUC	MRZ
MORE
	MOVI	70,A10
MRZ	MOVE	*A8(OPLINK),A0,L
;MORE EXPLOSIONS FROM TANK
	MOVE	*A0(KPTANKO),A9,L
	MOVI	ALTEXP5,A0
	CALLA	ONESND
	SLEEPK	10
;SEND MORE EXPLOSIONS OUT OF OLD TURRET AREA
	CREATE0 DBMS
SM1	SLEEPK	1
	CREATE	FUTUREPID,SMLE
	MOVI	EXP2HIB,A0
	CALLA	ONESND
	DSJ	A10,SM1
	DIE

********************************
MYTYP		.EQU	PDATA+448	;UHW	0-3

MORE3	MOVE	A8,A9
;EXPLOSIONS FROM MID LINE OF BTR60 VEHICLE
;A8=VEHICLE PNTR
	MOVI	044H,A10
	MOVE	A8,A11
	MOVE	*A8(OPLINK),A0,L
	MOVE	*A0(MYTYP),A0
	CMPI	5,A0
	JRC	XM1
	MOVK	10,A10			;10
XM1	SLEEPK	1
	CREATE	FUTUREPID,SMLE2A
	CREATE	FUTUREPID,SMLE2A
	DSJ	A10,XM1
	DIE

********************************

SMLE2A	MOVI	KBMJ,A14	  
	CALLR	ALGN
	MOVE	*A11(OFLAGS),A2	;STRETCH EXPLOSIONS OUT OVER LENGTH OF BTR60
	MOVI	-6AH,A0
	MOVI	2EH,A1
	BTST	B_FLIPH,A2
	JRNZ	WB1
	MOVI	-2EH,A0
	MOVI	6AH,A1
WB1	CALLA	RNDRNG
	MOVE	*A8(OXPOS),A1
	ADD	A0,A1
	MOVE	A1,*A8(OXPOS)
	MOVE	*A8(OYPOS),A1
	ADDK	8,A1
	MOVE	A1,*A8(OYPOS)
	MOVI	TBLST,A11		;COLORFUL BURSTS
	MOVI	-010000H,A0
	MOVI	010000H,A1
	CALLA	RNDRNG
	MOVE	A0,*A8(OXVEL),L
	MOVI	-050000H,A0
	MOVI	030000H,A1
	JRUC	SMLE2
SMLEP		;FOR SAND PIT GUNNER
	MOVI	BOOMN,A11
	MOVI	KBMX,A14
	CALLR	ALGN
	MOVE	*A8(OYPOS),A0
	SUBK	16,A0
	MOVE	A0,*A8(OYPOS)
	MOVI	-020000H,a0
	MOVI	020000H,a1
	CALLA	RNDRNG
	MOVE	A0,*A8(OXVEL),L
	MOVI	-020000H,a0
	MOVI	020000H,a1
	JRUC	SMLE2
SMLE1	
	MOVI	BOOMN,A11
	MOVI	KBMX,A14
	CALLR	ALGN
SMO	MOVI	-060000H,a0
	MOVI	060000H,a1
	CALLA	RNDRNG
	MOVE	A0,*A8(OXVEL),L
	MOVI	-060000H,a0
	MOVI	060000H,a1
	JRUC	SMLE2
SMLE1G	;GREY CLOUDS
	MOVI	BOOMNG,A11
	MOVI	KBMXG,A14
	CALLR	ALGN
	MOVI	-018000H,a0
	MOVI	018000H,a1
	CALLA	RNDRNG
	MOVE	A0,*A8(OXVEL),L
	MOVI	-018000H,a0
	MOVI	018000H,a1
	JRUC	SMLE2
SMLE
	MOVI	KBM,A14			;BLOOD
	CALLR	ALGN

;FROM MINE LAYER DEATH
	MOVI	TBLST,A11		;BOOMN,A9
	MOVI	-050000H,a0
	MOVI	050000H,a1
	CALLA	RNDRNG
	MOVE	A0,*A8(OXVEL),L
	MOVI	-050000H,a0
	MOVI	050000H,a1
SMLE2
	CALLA	RNDRNG
	MOVE	A0,*A8(OYVEL),L
	MOVI	FUTUREPID,A0
	MOVE	A0,*A13(PROCID)
	MOVE	A11,A9
	jauc	FRQDELDIE


********************************


;START X NUMBER OF FLAME PACKETS ON JETS
;DIFFERENT RATES
;ANGLED CORRECTLY

JFLAMES		;A8=JET IMG PNTR
	MOVI	FIREDI,A0
	CALLA	ONESND
	MOVE	A8,A11
	MOVK	7,A10
JFLMS	PUSH	A10
	MOVE	A11,A9
	MOVI	KBMZ,A14
	CALLR	ALGN
	PULL	A10
	MOVE	A10,A0
	SLL	4,A0
	MOVE	*A11(OFLAGS),A4
	BTST	B_FLIPH,A4
	JRNZ	JOFLM1
	MOVI	JFXOF2,A1		;BTR60 TRAVELLING TO RIGHT
	ADD	A0,A1
	MOVE	*A1,A1
	MOVE	*A8(OXPOS),A2
	ADD	A1,A2
	MOVE	A2,*A8(OXPOS)
	MOVI	JFYOF2,A1
	ADD	A0,A1
	MOVE	*A1,A1
	MOVE	*A8(OYPOS),A2
	ADD	A1,A2
	MOVE	A2,*A8(OYPOS)
	SLL	1,A0
	MOVI	JFLOF2,A1
	JRUC	JOFLM2

JOFLM1	MOVI	JFXOF,A1			;BTR60 TRAVELLING TO LEFT
	ADD	A0,A1
	MOVE	*A1,A1,W
	MOVE	*A8(OXPOS),A2
	ADD	A1,A2
	MOVE	A2,*A8(OXPOS)
	MOVI	JFYOF,A1
	ADD	A0,A1
	MOVE	*A1,A1,W
	MOVE	*A8(OYPOS),A2
	ADD	A1,A2
	MOVE	A2,*A8(OYPOS)
	SLL	1,A0
	MOVI	JFLOF,A1
JOFLM2	ADD	A0,A1
	MOVE	*A1,A9,L		;FLAME LIST
	CREATE	FUTUREPID,JDOFLM
	SLEEPK	1
	DSJ	A10,JFLMS
	SLEEP	100
	MOVI	FIREDI,A0
	CALLA	ONESND
	SLEEP	100
	MOVI	FIREDI,A0
	CALLA	ONESND
	DIE	

JDOFLM	MOVE	A9,A10
	MOVI	18*2,A11		;22 SEC ROUGHLY
	JRUC	DOF1

;JET FACING LEFT
JFXOF	.WORD	0,058H,062H,0-50,12H-50,20H-50
	.WORD	32H-50,3CH-50
JFYOF	.WORD	0,0FFC4H,0FFCCH,0FFACH,0FFBCH,0FFBBH
	.WORD	0FFAFH,0FFA6H
JFLOF	.LONG	0,FAME3,FAME2,FAME6,FAME1,FAME2
	.LONG	FAME4,FAME5

;JET FACING RIGHT
JFXOF2	.WORD	0,0FFA4H,0FFB6H,0,18H,24H		;SMALLS
	.WORD	32H,3CH
JFYOF2	.WORD	0,0FFC4H,0FFCCH,0FFACH,0FFBCH,0FFBBH
	.WORD	0FFAFH,0FFA6H
JFLOF2	.LONG	0,BFAME3,BFAME2,BFAME6,BFAME1,BFAME2
	.LONG	BFAME4,BFAME5

;START X NUMBER OF FLAME PACKETS ON BTR60
;DIFFERENT RATES
;ANGLED CORRECTLY

FLAMES		;A8=BTR60 IMG PNTR

	SLEEPK	20
	MOVE	A8,A11
	MOVK	10,A10

FLMS	PUSH	A10
	MOVE	A11,A9
	MOVI	KBMZ,A14
	CALLR	ALGN
	PULL	A10
	MOVE	*A11(OXVEL),A0,L
	MOVE	A0,*A8(OXVEL),L
	MOVE	A10,A0
	SLL	4,A0
	MOVE	*A11(OFLAGS),A4
	BTST	B_FLIPH,A4
	JRZ	OFLM1
	MOVI	FXOF2,A1		;BTR60 TRAVELLING TO RIGHT
	ADD	A0,A1
	MOVE	*A1,A1
	MOVE	*A8(OXPOS),A2
	ADD	A1,A2
	MOVE	A2,*A8(OXPOS)
	MOVI	FYOF2,A1
	ADD	A0,A1
	MOVE	*A1,A1
	MOVE	*A8(OYPOS),A2
	ADD	A1,A2
	MOVE	A2,*A8(OYPOS)
	SLL	1,A0
	MOVI	FLOF2,A1
	JRUC	OFLM2

OFLM1	MOVI	FXOF,A1			;BTR60 TRAVELLING TO LEFT
	ADD	A0,A1
	MOVE	*A1,A1,W
	MOVE	*A8(OXPOS),A2
	ADD	A1,A2
	MOVE	A2,*A8(OXPOS)
	MOVI	FYOF,A1
	ADD	A0,A1
	MOVE	*A1,A1,W
	MOVE	*A8(OYPOS),A2
	ADD	A1,A2
	MOVE	A2,*A8(OYPOS)
	SLL	1,A0
	MOVI	FLOF,A1
OFLM2	ADD	A0,A1
	MOVE	*A1,A9,L		;FLAME LIST
	CREATE	FUTUREPID,DOFLM
	SLEEPK	1
	DSJ	A10,FLMS
	DIE	

DOFLM	MOVE	A9,A10
	MOVI	22*2,A11		;22 SEC ROUGHLY
DOF1	JSRP	FRANIMQ
	DEC	A11
	JRZ	DOFO
	MOVE	A10,A9
	CALLA	SCRTST
	JRZ	DOF1
DOFO	jauc	DELOBJDIE

;BTR60 FACING LEFT
FXOF	.WORD	0,5CH,6CH-34,6CH-97,6CH-84,6CH-58		;SMALLS
	.WORD	6CH-51,6CH-98,6CH-29,6CH-70,6CH-99
FYOF	.WORD	0,-28,-28-18,-28+12,-28+4,-28-8
	.WORD	-28-7,-28-25,-28-14,-28-10,-28-4
FLOF	.LONG	0,FAME3,FAME2,FAME1,FAME1,FAME2
	.LONG	FAME4,FAME5,FAME6,FAME5,FAME4

;BTR60 FACING RIGHT
FXOF2	.WORD	0,-5CH,-6CH+34,-6CH+97,-6CH+84,-6CH+58		;SMALLS
	.WORD	-6CH+51,-6CH+98,-6CH+29,-6CH+70,-6CH+99
FYOF2	.WORD	0,-28,-28-18,-28+12,-28+4,-28-8
	.WORD	-28-7,-28-25,-28-14,-28-10,-28-4
FLOF2	.LONG	0,BFAME3,BFAME2,BFAME1,BFAME1,BFAME2
	.LONG	BFAME4,BFAME5,BFAME6,BFAME5,BFAME4

FAME1	.LONG	LFLM1			;FLAMES ANGLE TO RIGHT
	.WORD	FLIPBITS|3,0
	.LONG	LFLM2
	.WORD	3
	.LONG	LFLM3
	.WORD	3
	.LONG	LFLM4
	.WORD	3
	.LONG	LFLM5
	.WORD	3
	.LONG	LFLM6
	.WORD	3
	.LONG	0
FAME2	.LONG	LFLM1			;FLAMES ANGLE TO RIGHT
	.WORD	FLIPBITS|2,0
	.LONG	LFLM2
	.WORD	2
	.LONG	LFLM3
	.WORD	2
	.LONG	LFLM4
	.WORD	2
	.LONG	LFLM5
	.WORD	2
	.LONG	LFLM6
	.WORD	2
	.LONG	0
FAME3	.LONG	LFLM1			;FLAMES ANGLE TO RIGHT
	.WORD	FLIPBITS|5,0
	.LONG	LFLM2
	.WORD	5
	.LONG	LFLM3
	.WORD	5
	.LONG	LFLM4
	.WORD	5
	.LONG	LFLM5
	.WORD	5
	.LONG	LFLM6
	.WORD	5
	.LONG	0
FAME4	.LONG	FLM1			;FLAMES ANGLE TO RIGHT
	.WORD	FLIPBITS|3,0
	.LONG	FLM2
	.WORD	3
	.LONG	FLM3
	.WORD	3
	.LONG	FLM4
	.WORD	3
	.LONG	FLM5
	.WORD	3
	.LONG	FLM6
	.WORD	3
	.LONG	0
FAME5	.LONG	FLM1			;FLAMES ANGLE TO RIGHT
	.WORD	FLIPBITS|2,0
	.LONG	FLM2
	.WORD	2
	.LONG	FLM3
	.WORD	2
	.LONG	FLM4
	.WORD	2
	.LONG	FLM5
	.WORD	2
	.LONG	FLM6
	.WORD	2
	.LONG	0
FAME6	.LONG	FLM1			;FLAMES ANGLE TO RIGHT
	.WORD	FLIPBITS|4,0
	.LONG	FLM2
	.WORD	4
	.LONG	FLM3
	.WORD	4
	.LONG	FLM4
	.WORD	4
	.LONG	FLM5
	.WORD	4
	.LONG	FLM6
	.WORD	4
	.LONG	0
;FLAMES FACING OTHER WAY
BFAME1	.LONG	LFLM1			;FLAMES ANGLE TO RIGHT
	.WORD	FLIPBITS|3,(M_FLIPH)
	.LONG	LFLM2
	.WORD	3
	.LONG	LFLM3
	.WORD	3
	.LONG	LFLM4
	.WORD	3
	.LONG	LFLM5
	.WORD	3
	.LONG	LFLM6
	.WORD	3
	.LONG	0
BFAME2	.LONG	LFLM1			;FLAMES ANGLE TO RIGHT
	.WORD	FLIPBITS|4,(M_FLIPH)
	.LONG	LFLM2
	.WORD	4
	.LONG	LFLM3
	.WORD	4
	.LONG	LFLM4
	.WORD	4
	.LONG	LFLM5
	.WORD	4
	.LONG	LFLM6
	.WORD	4
	.LONG	0
BFAME3	.LONG	LFLM1			;FLAMES ANGLE TO RIGHT
	.WORD	FLIPBITS|5,(M_FLIPH)
	.LONG	LFLM2
	.WORD	5
	.LONG	LFLM3
	.WORD	5
	.LONG	LFLM4
	.WORD	5
	.LONG	LFLM5
	.WORD	5
	.LONG	LFLM6
	.WORD	5
	.LONG	0
BFAME4	.LONG	FLM1			;FLAMES ANGLE TO RIGHT
	.WORD	FLIPBITS|3,(M_FLIPH)
	.LONG	FLM2
	.WORD	3
	.LONG	FLM3
	.WORD	3
	.LONG	FLM4
	.WORD	3
	.LONG	FLM5
	.WORD	3
	.LONG	FLM6
	.WORD	3
	.LONG	0
BFAME5	.LONG	FLM1			;FLAMES ANGLE TO RIGHT
	.WORD	FLIPBITS|2,(M_FLIPH)
	.LONG	FLM2
	.WORD	2
	.LONG	FLM3
	.WORD	2
	.LONG	FLM4
	.WORD	2
	.LONG	FLM5
	.WORD	2
	.LONG	FLM6
	.WORD	2
	.LONG	0
BFAME6	.LONG	FLM1			;FLAMES ANGLE TO RIGHT
	.WORD	FLIPBITS|5,(M_FLIPH)
	.LONG	FLM2
	.WORD	5
	.LONG	FLM3
	.WORD	5
	.LONG	FLM4
	.WORD	5
	.LONG	FLM5
	.WORD	5
	.LONG	FLM6
	.WORD	5
	.LONG	0




ALGN	CALLA	GPALOBJ			;ALLOCATE A COLOR PALETTE 
	CALLA	STFOBJ			;STUFF OBJECT DATA 
	CALLA	INSOBJ			;INSERT OBJECT INTO LIST
	MOVE	A0,A10			;A8
	clr	a0
	move	a0,*a10(OPAL+16)

	MOVE	A9,A8
	CALLA	GETANIXY
	MOVE	A10,A0

	MOVE	*A0(OFLAGS),A4		;SAME FLAGS AS BEFORE
	ADDI	0230000H,A2		;1C
	CALLA	GANISAG
	MOVE	A10,A8
	RETS

KBM 
	.LONG	0,0,T72BLAST1
	.WORD	282,DMAWNZ+M_FLIPH+M_NOCOLL,CLSDEAD
	.LONG	0H,0H
KBMJ
	.LONG	0,0,T72BLAST1
	.WORD	282,DMAWNZ+M_FLIPH+M_NOCOLL,CLSNEUT
	.LONG	0H,0H
KBMZ	;ARM RGT
	.LONG	0,0,FLM1
	.WORD	282,DMAWNZ+M_FLIPH+M_NOCOLL,CLSDEAD
	.LONG	0H,0H
KBMX
	.LONG	0,0,FIRE1
	.WORD	282,DMAWNZ+M_FLIPH+M_NOCOLL,CLSDEAD
	.LONG	0H,0H
KBMXG
	.LONG	0,0,CLD1A
	.WORD	282,DMAWNZ+M_FLIPH+M_NOCOLL,CLSDEAD
	.LONG	0H,0H

BOOMN	.LONG	KBM1
	.WORD	4
	.LONG	KBM2
	.WORD	4
	.LONG	KBM3
	.WORD	4
	.LONG	KBM4
	.WORD	4
	.LONG	KBM5
	.WORD	4
	.LONG	KBM6
	.WORD	4
	.LONG	KBM7
	.WORD	4
	.LONG	0
BOOMNG	.LONG	OKBM1
	.WORD	4
	.LONG	OKBM2
	.WORD	4
	.LONG	OKBM3
	.WORD	4
	.LONG	OKBM4
	.WORD	4
	.LONG	OKBM5
	.WORD	4
	.LONG	OKBM6
	.WORD	4
	.LONG	OKBM7
	.WORD	4
	.LONG	0



KILL_CBALL
	PUSH	A1
	MOVE	*A8(OPLINK),A0,L
	JREQ	RET
	CLR	A1
	MOVE	A1,*A8(OPLINK),L
	CALLA	KILL
	CALLA	DELOBJA8
RET	MMFM	SP,A1
	RETS


********************************
* Fiend code

* Fiend from rectangle

 SUBR	ONE_FND		;A9=YX, A10=Dir (1/3/5/7)

	movi	FND,a2
	calla	GET_WVADDR

	move	*a0(32),a1		;Get difficulty level
	move	a1,*a13(LEVEL)

	move	*a0(16),a1		;Wave ram cnt -1
	dec	a1
	move	a1,*a0(16)

	clr	a1
	movy	a9,a1			;A1=Y
	move	a9,a0
	sll	16,a0			;A0=X

	movk	1,a11			;Sleep
	jruc	fiend2


********************************
* Fiend from backgnd

 SUBR	STRT_FND	;A8=*Fiend obj

;	movi	FNDPID,a0
;	move	a0,*a13(PROCID)
	movi	CLSENMY|TYPFND,a0
	move	a0,*a8(OID)
	move	a13,*a8(OPLINK),L
	movk	2,a0
	move	a0,*a13(LEVEL)
	MOVI	159,A0
	MOVE	A0,*A8(OZPOS)
	movk	1,a10			;DIR
	movk	2,a11			;Sleep
	jruc	fiend3



********************************
* From a crate

 SUBR	FIEND		;A8=*Src obj

	movk	2,a0
	move	a0,*a13(LEVEL)
	movk	3,a10
	move	*a8(OFLAGS),a0
	btst	B_FLIPH,a0
	jrz	fnd1
	movk	7,a10
fnd1	move	*a8(OXPOS),a0
	addk	15,a0
	sll	16,a0
	move	*a8(OYPOS),a1
	subk	20,a1
	sll	16,a1
	movk	1,a11			;Sleep

fiend2	movi	FIEND1,a2
	movi	JZ,a3			;Z
	movi	DMAWNZ,a4
	movi	CLSENMY|TYPFND,a5
	clr	a6	
	clr	a7
	calla	BEGINOBJ2

fiend3
;	movi	FNDP4,a0		;Set new pallette
;	calla	GETFPAL
;	move	a0,*a8(OPAL),L

;GET A RANDOM COLOR FOR THIS FIEND
	move	@vcount,A0
	ANDI	01FH,A0
	SLL	5,A0
	MOVE	A0,*A13(FND_COLOR),W
	ADDI	FCOLORS,A0
	MOVE	*A0,A0,L
	CALLA	GETFPAL
	MOVE	A0,*A8(OPAL),L

	clr	a0
	move	a0,*a8(OPAL+16)

	move	a10,*a13(DIR)
	move	a10,*a13(SK_DIR)
	movi	-1,a0
	move	a0,*a13(DIS)

	move	@FND_CNT,a0
	inc	a0
	move	a0,@FND_CNT

	clr	a0
	move	a0,*a13(fndsp_p),L
	move	a0,*a13(fjsobj_p),L
	move	a0,*a13(ABSRB)
	move	a0,*a13(SQ_NUM)
	move	a0,*a13(JFLG)
	movi	>14000,a1		;Speed
	calla	DO_DIFF2
	callr	fiend_getfran		;Get 1st *franim for dir

	move	a11,a0
	calla	PRCSLP			;Sleep some

	subk	1,a10
	jrz	jmponp			;Dir 1?
	subk	4,a10
	jrz	jmponp			;Dir 5?

fndlp	move	@HALT,a0		;Fiend loop
	jrnz	gotop

	move	*a13(SK_DIR),a1		;>Do turn
	move	*a13(DIR),a0
	cmp	a0,a1
	jreq	noturn
	callr	fiend_seekdir
gotop	SLEEPK	5
	jruc	fndlp


FCOLORS	.LONG	FNDP,FNDP,FNDP,FNDP,FNDP,FNDP,FNDP,FNDP,FNDP,FNDP,FNDP,FNDP
	.LONG	FNDP,FNDP,FNDP,FNDP,FNDP,FNDP,FNDP,FNDP,FNDP,FNDP,FNDP,FNDP
	.LONG	FNDP,FNDP,FNDPGRN,FNDPRED,FNDPRED,FNDPGRN,FNDPBLU,FNDPPUR
;FCOLORS2
;	.LONG	GRNTPNK,GRNTPNK,GRNTPNK,GRNTPNK,GRNTPNK,GRNTPNK,GRNTPNK
;	.LONG	GRNTPNK,GRNTPNK,GRNTPNK,GRNTPNK,GRNTPNK
;	.LONG	GRNTPNK,GRNTPNK,GRNTPNK,GRNTPNK,GRNTPNK,GRNTPNK,GRNTPNK
;	.LONG	GRNTPNK,GRNTPNK,GRNTPNK,GRNTPNK,GRNTPNK
;	.LONG	GRNTPNK,GRNTPNK,GRNTGRN,GRNTRED,GRNTRED,GRNTGRN,GRNTBLU
;	.LONG	GRNTPUR


noturn	move	*a13(DIS),a0		;>Facing proper direction
	jrz	fndcj
	jrp	fndwlk

	callr	fiend_getfran		;Start walking
	move	*a13(DIR),a0
	calla	INTO			;Get velocity for this dir
	movk	6,a0
	movk	30,a1
	calla	RNDRNG

fndwlk	dec	a0
	move	a0,*a13(DIS)
	jrz	fndstmv

	move	*a8(OXPOS),a1
	move	@WORLDTLX+16,a0
	sub	a0,a1
	move	*a13(DIR),a2
	subk	3,a2
	jrnz	fndlf
	cmpi	336,a1			;Max rgt
	jrlt	wlkani
	movk	7,a0			;Hit edge!
fnd180	movi	-1,a1
	move	a1,*a13(DIS)
	jruc	setturn

fndlf	movk	3,a0
	subi	100,a1			;SUBK 32
	jrlt	fnd180			;Hit left edge?

wlkani	clr	a1			;Walk FRANIM
	JSRP	FRANIM
	jrnc	fndlp			;Not at end of script?
	callr	fiend_getfran
	jruc	fndlp


fndcj	move	*a13(JFLG),a0
	jrz	noj			;Jump?

	SLEEPK	20
	JSRP	fiend_jump
	clr	a0
	move	a0,*a13(JFLG)
	SLEEPK	10
	jruc	fndnewmd


noj	calla	SCRTST			;Chk if on screen
	jrnz	jmponp			;Jump on player?

	move	@fndnumfire,a0		;Max of 2 can fire
	subk	2,a0
	jrge	fndnewmd
	move	*a13(DIR),a9
	sll	5,a9
	move	a13,a10
	move	*a13(SQ_NUM),a0
	jrz	reg
	CREATE	SHOTPID,SPITIT2		;>Squat fire
	addi	SQLST2,a9
	jruc	reg2

reg	CREATE	SHOTPID,SPITIT		;>Shoot
	addi	SQLST,a9
reg2	move	a0,*a13(fndsp_p),L	;Save *process
	move	*a9,a9,L
	JSRP	FRANIMQ

	move	*a13(SQ_NUM),a0
	jrz	fndnewmd
	dec	a0			;>Do squat turn
	move	a0,*a13(SQ_NUM)
	move	*a13(SK_DIR),a0		;Seek +1
	movk	7,a1
	and	a1,a0
	inc	a0
	move	a0,*a13(SK_DIR)
	jruc	gotop

fndnewmd
	SLEEPK	4
	clr	a0			;Jump to a random mode
	movk	15,a1
	calla	RNDRNG
	sll	5,a0
	addi	jmp_t,a0
	move	*a0,a0,L
	jump	a0


jmp_t	.long	wlk,wlk,wlk,wlkrnd,wlkrnd,spinr
	.long	jmponp,jmponp,jmponp,jmponp,jmponp
	.long	squats,squats,spinrp,spinrp,spinrp


;1=Decide to walk left or right based on what half of the screen he is on
;  then spin to 3 or 7 and reset (dis), then walk.
;2=Spin to a random angle and spit
;3=Spin to a random player and spit
;4=If toward bottom of screen, check wave # and maybe
;  jump up higher up on scrn.
;5=Squat mode, go to each angle and squat, sometimes shooting, but not 100%


wlk	MOVE	@FND_NOWLK,A0
	JRNZ	fndnewmd
	callr	getcloseplyr		;>Walk toward closer player
	jrz	fndnewmd
	move	*a0(OXPOS),a1
	move	*a8(OXPOS),a3
	movk	3,a2			;Left
	cmp	a1,a3
	jrlo	wlk1
	movk	7,a2			;Rgt
wlk1	move	a2,*a13(SK_DIR)
	movi	-1,a0
	move	a0,*a13(DIS)
	jruc	gotop

wlkrnd	MOVE	@FND_NOWLK,A0
	JRNZ	fndnewmd
	movi	-1,a0			;>Walk random
	move	a0,*a13(DIS)
	movk	3,a2
	calla	RANDOM
	jrn	wlkr1
	movk	7,a2
wlkr1	move	a2,*a13(SK_DIR)
	jruc	gotop

squats	movk	1,a0			;>Squating turn
	movk	3,a1
	calla	RNDRNG
	move	a0,*a13(SQ_NUM)

spinr	movk	1,a0			;>Rnd spin
	movk	8,a1
	calla	RNDRNG
	move	a0,*a13(SK_DIR)
	jruc	gotop

spinrp	callr	getcloseplyr		;>Face player
	jrz	fndnewmd
	callr	XYSKOBJ
	move	a5,a1
	move	a6,a2
	callr	GETADIR2
setturn	move	a0,*a13(SK_DIR)
fndstmv	clr	a0
	move	a0,*a8(OXVEL),L		;Kill vel
	move	a0,*a8(OYVEL),L
	jruc	gotop


jmponp	callr	getcloseplyr		;>Jump on closer player
	jrz	fndnewmd
	move	*a0(OYPOS),a1
	move	*a8(OYPOS),a3
	movk	1,a4			;Jump north
	sub	a1,a3
	jrgt	fndj5
	movk	5,a4			;Jump south
	abs	a3
fndj5	sll	1,a3			;A3=Y dist*2
	move	*a0(OXPOS),a1
	move	*a8(OXPOS),a2
	sub	a1,a2
	abs	a2			;A2=X dist
	cmp	a2,a3
	jrlo	wlk
	move	a4,*a13(JFLG)		;Y>X so jump
	move	a4,*a13(SK_DIR)
	clr	a0
	move	a0,*a13(DIS)
	jruc	gotop
	


********************************
* Get franim list based on fiends direction

 SUBRP	fiend_getfran
	move	*a13(DIR),a0
	sll	5,a0			;*32
	addi	walk_t-32,a0		;calculate offset in table
	move	*a0,a9,L		;move table value into a9
	rets

walk_t	.long	fr,fr,fr,fr,fr,fr,fl,fr


fr	.long	FIEND1
	.word	FLIPBITS+3,(M_FLIPH)
	.long	FIEND2
	.word	3
	.long	FIEND3
	.word	3
	.long	FIEND4
	.word	3
	.long	FIEND5
	.word	3
	.long	FIEND6
	.word	3
	.long	FIEND7
	.word	3
	.long	0

fl	.long	FIEND1
	.word	FLIPBITS+3,0
	.long	FIEND2
	.word	3
	.long	FIEND3
	.word	3
	.long	FIEND4
	.word	3
	.long	FIEND5
	.word	3
	.long	FIEND6
	.word	3
	.long	FIEND7
	.word	3
	.long	0


********************************
* Rotates fiend toward new direction

 SUBRP	fiend_seekdir	;A0=Current dir (1-8), A1=Seek dir (1-8)

	sub	a0,a1			;A1=Difference
	subk	1,a0			;Make 0-7
	move	a1,a2
	abs	a1
	subk	5,a1
	jrlt	way1
	neg	a2
way1	move	a2,a2
	jrnn	way4
	subk	2,a0			;-1
way4	addk	1,a0			;+1

	movk	7,a1
	and	a1,a0
	addk	1,a0			;make 1-8
	move	a0,*a13(DIR)

	dec	a0
	move	a0,a2
	sll	5,a0
	addi	SPINFRMS,a0
	move	*a0,a1,L		;New OIMG
	sll	4,a2
	addi	SPINFLGS,a2
	move	*a2,a4			;New OFLAGS
	jauc	ANI

SPINFRMS
	.long	FNSTND12,FNSTND10,FNSTND9,FNSTND7,FNSTND6,FNSTND7,FNSTND9
	.long	FNSTND10


********************************
* Get * to closest player legs obj

 SUBR	getcloseplyr		;A8=*Src obj

	move	@PLYRPRCS,a1,L
	jrz	gcp400
	move	@PLYRPRCS+32,a2,L
	jrz	gcp450

	move	*a1(LEG_PTR),a0,L
	move	*a2(LEG_PTR),a1,L
	move	*a8(OXPOS),a2		;Get src XY
	move	*a8(OYPOS),a3
	move	*a0(OXPOS),a4
	sub	a2,a4
	move	*a0(OYPOS),a5
	sub	a3,a5
	abs	a4
	abs	a5
	cmp	a5,a4
	jrhs	gcp50
	move	a5,a4			;A4=P1 distance

gcp50	move	*a1(OXPOS),a5
	sub	a2,a5
	move	*a1(OYPOS),a6
	sub	a3,a6
	abs	a5
	abs	a6
	cmp	a6,a5
	jrhs	gcp70
	move	a6,a5			;A5=P2 distance
gcp70	cmp	a5,a4
	jrls	gcp80
	move	a1,a0
gcp80	move	a0,a0
	rets

gcp400	move	@PLYRPRCS+32,a1,L	;P1 bad
	jrz	gcp800
gcp450	move	*a1(LEG_PTR),a0,L	;P2 bad
	rets

gcp800	clr	a0			;P1&P2 bad
					;>A0=*Plyr legs obj
	rets				;Pass Z



********************************
* Fiend jump

	APTRPD	fjsobj_p	,23	;*Jumper shadow object
	WORDPD	fjpos		,25	;Jumper pos in arc
	WORDPD	fjsinea		,26	;Sine add per tick
	WORDPD	FND_COLOR,27   	;COLOR PAL INDEX (0-7)*32 FOR THIS FIEND

JZ	.set	159			;281
JMPSND	.WORD	>F48E,>18,>813D,0		;FIEND JUMP SND
JMPSND2	.WORD	>F58E,>18,>813E,0		;FIEND JUMP SND

 SUBRP	fiend_jump

	movi	jmpu_l,a10
	move	*a13(JFLG),a0
	subk	1,a0
	jreq	fj20
	movi	jmpd_l,a10
fj20
	movk	1,a0
	move	a0,*a13(fjsinea)


	callr	getcloseplyr
	move	*a0(OXPOS),a6
	cmpi	>1a00,a6			;Off screen?
	jrz	fj900
	addk	10,a6
	move	*a0(OYPOS),a7
	subk	30,a7

	PUSH	a6,a7
	move	*a8(OIMG),a1,L
	move	*a8(OSIZE),a2,L
	move	*a8(OFLAGS),a4
	calla	GANIOF
	move	*a8(OXPOS),a0		;Get XY
	move	*a8(OYPOS),a1
	sll	16,a0
	sll	16,a1
	add	a6,a0			;Add ani offset
	add	a7,a1
	PULL	a6,a7

	sll	16,a6
	sll	16,a7
	sub	a0,a6			;DestX-SrcX
	sub	a1,a7			;DestY-SrcY

	move	a6,a11
	abs	a11   			;A11=Distance
	move	a7,a2
	abs	a2
	cmp	a2,a11			;Use max
	jrhs	j120
	move	a2,a11
j120
	srl	6,a11			;/64
	move	a11,a2
	srl	2,a2
	sub	a2,a11			;Sub .25 = /96

	cmpi	18000,a11
	jrhs	j140
	movi	18000,a11		;Minimum

j140	sra	1,a6			;>Scale down to A11
	sra	1,a7
	move	a6,a2
	abs	a2
	cmp	a11,a2			;A6&A7 < A11
	jrgt	j140
	move	a7,a2
	abs	a2
	cmp	a11,a2
	jrgt	j140

	move	a6,a4			;>Fine scale up to A11
	move	a7,a5
	sra	4,a4			;/16
	sra	4,a5
	jrnz	j150
	move	a4,a4
	jrz	j200			;Both 0 then skip
j150	add	a4,a6
	add	a5,a7
	move	a6,a2
	abs	a2
	cmp	a11,a2
	jrgt	j200
	move	a7,a2
	abs	a2
	cmp	a11,a2
	jrle	j150

j200
	move	*a10+,a9,L		;Get *FRANIM list
	jrz	j210
	mmtm	a12,a0,a1,a6,a7		;Save XY&Vel
	JSRP	FRANIMQ			;Jump sequence
	mmfm	a12,a0,a1,a6,a7
j210	movi	100,a3			;Z
	movi	DMAWNZ+M_NOCOLL,a4	;No collisions
	movi	CLSDEAD,a5

	movi	SHAD1,a2
	move	a8,a9
	calla	BEGINOBJ2		;Get shadow obj
	move	a8,*a13(fjsobj_p),L
	move	a9,a8

	move	a10,a9
	MOVI	JMPSND,A0
	CALLA	ONESND
	MOVI	JMPSND2,A0
	CALLA	ONESND
	clr	a0
	move	a0,*a13(fjpos)
	jruc	j400

j300	movi	DMAWNZ+M_NOCOLL,a4	;No collisions
	calla	ANI			;New frame
	move	*a9+,a10		;Get #ticks for frame

j350	move	*a13(fjsobj_p),a5,L
	move	*a5(OIMG),a1,L
	move	*a5(OSIZE),a2,L
	move	*a5(OFLAGS),a4
	calla	GANIOF
	move	*a13(fjpos),a0		;New height
	move	*a13(fjsinea),a1
	add	a1,a0
	cmpi	82,a0			;Max table range
	jrlo	j370
	clr	a0
j370	move	a0,*a13(fjpos)
	callA	sine_get
	srl	6,a0			;/64
	move	*a5(OYPOS),a2
	sub	a0,a2
	addi	JZ+130,a0
	move	a0,*a8(OZPOS)
	move	a8,a0
	move	*a5(OXPOS),a3
	sll	16,a2
	sll	16,a3
	add	a6,a3			;Add Anim pt
	add	a7,a2
	move	*a8(OFLAGS),a4
	calla	GANISAG
	SLEEPK	1
	dsj	a10,j350

j400	move	*a9+,a1,L		;Get *Img
	jrnz	j300

	movi	JZ,a0
	move	a0,*a8(OZPOS)

	move	*a13(fjsobj_p),a0,L	;Kill shadow
	calla	DELOBJ
	clr	a0
	move	a0,*a13(fjsobj_p),L	;Clr *
	movi	DMAWNZ,a0
	move	a0,*a8(OFLAGS)		;Collisions ON
	move	*a9+,a9,L		;Get *FRANIM list
	jrz	fj900
	JSRP	FRANIMQ			;Land
fj900	RETP


jmpd_l	.long	jmpstrtd_l	;*FRANIM
	LW	FJUMP6C,14
	LW	FNDJUMP6C1,15
	LW	FNDJUMP6C2,24
	LW	FNDJUMP6C1,15
	LW	FJUMP6C,14
	.long	0
	.long	jmplandd_l	;*FRANIM

jmpstrtd_l
	LW	FJUMP6A,10
	LW	FJUMP6B,10
	.long	0
jmplandd_l
	LW	FJUMP6B,10
	LW	FJUMP6A,10
	.long	0


jmpu_l	.long	jmpstrtu_l	;*FRANIM
	LW	FJUMP12C,14
	LW	FNDJUMP12C1,15
	LW	FNDJUMP12C2,24
	LW	FNDJUMP12C1,15
	LW	FJUMP12C,14
	.long	0
	.long	jmplandu_l	;*FRANIM

jmpstrtu_l
	LW	FJUMP12A,10
	LW	FJUMP12B,10
	.long	0
jmplandu_l
	LW	FJUMP12B,10
	LW	FJUMP12A,10
	.long	0


********************************
* Fiend spitter (Process)

 SUBRP	SPITIT		;A10=*Fiend process

	movi	100,a0
	calla	RANDPER
	jrc	spitx
	movk	6,a0
	movk	15,a1
	calla	RNDRNG
	move	a0,a9
	jruc	spit5

 SUBRP	SPITIT2		;A10=*Fiend process

	movk	5,a9
spit5	move	@fndnumfire,a0		;Cnt +1
	addk	1,a0
	move	a0,@fndnumfire
	MOVI	CHUCK,A0
	CALLA	ONESND
	SLEEPK	5
spit10	CREATE	SHOTPID,SPITS
	SLEEPK	2
	dsj	a9,spit10
	move	@fndnumfire,a0		;Cnt -1
	subk	1,a0
	move	a0,@fndnumfire

spitx	clr	a0
	move	a0,*a10(fndsp_p),L	;Clr *process
	DIE


********************************
* Fiend spit ball (Process)


 SUBRP	SPITS		;A10=*Fiend process

	movk	5,a0
	movk	12,a1
	calla	RNDRNG
	move	a0,*a13(AGE)
	move	*a10(DIR),a2
	subk	1,a2
	move	a2,a4
	sll	5,a2			;*32
	addi	bxylh_t,a2		;Bubble x low vel
	move	*a2,a0,L
	move	*a2(8*32),a1,L
	calla	RNDRNG
	move	a0,a6			;XV
	move	*a2(16*32),a0,L
	move	*a2(24*32),a1,L
	calla	RNDRNG
	move	a0,a7			;YV
	move	*a8(OXPOS),a0		;A8=*Torso of fiend that fired me
	move	*a8(OYPOS),a1
	movi	160,a3		  	;Z, 159 for fiend
	move	a4,a2			;Set Z based on dir
	jrnz	spits3
	movi	158,a3			;Z
spits3	sll	4,a2			;*16
	addi	xy3_t,a2
	move	*a2,a5
	add	a5,a0
	move	*a2(>80),a5
	add	a5,a1
	sll	16,a0			;X
	sll	16,a1			;Y
	movi	PODA,a2			;*IMG
	movi	DMAWNZ,a4
	movi	CLSENMY|TYPSHOT+1,a5	;OID
	calla	BEGINOBJ2

spits5	SLEEPK	3
	move	*a13(AGE),a0
	subk	1,a0
	move	a0,*a13(AGE)
	jrnz	spits5
	MOVE	A0,*A8(OXVEL),L		;AGE TIMED OUT
	MOVE	A0,*A8(OYVEL),L
	MOVI	SMLEXP,A9
	jauc	FRQDELDIE


SMLEXP	.LONG	EXPb1
	.WORD	NEWPALET|3
	.LONG	BULLET			;NEW PAL NAME
	.LONG	EXPb2
	.WORD	3
	.LONG	EXPb1
	.WORD	3
	.LONG	0	

bxylh_t	.LONG	-010000H,008000H,0018000H,08000H,-010000H,-28000H,-30000H,-28000H
	.LONG	0010000H,028000H,030000H,28000H,010000H,-08000H,-018000H,-08000H
	.LONG	-028000H,-28000H,-010000H,08000H,018000H,008000H,-010000H,-28000H
	.LONG	-018000H,-08000H,0010000H,28000H,28000H,028000H,0010000H,-08000H

xy3_t	.word	11,17,14,17,16,9,2,4	;X
	.word	4,4,11,11,11,11,10,3	;Y



********************************
* Calc direction based on velocities


; SUBRP	GETADIR		;A8=*Object

;	move	*a8(OXVEL),a1,L
;	move	*a8(OYVEL),a2,L

 SUBR	GETADIR2	;A1=XVel, A2=YVel

	move	a1,a3
	move	a2,a4
	abs	a3		;X
	abs	a4		;Y

	move	a4,a0
	add	a4,a0
	add	a4,a0		;A0=YVel*3
	cmp	a0,a3
	jrhs	gadx		;XV > 3*YV
	move	a3,a0
	add	a3,a0
	add	a3,a0		;A0=XVel*3
	cmp	a0,a4
	jrhs	gady

	move	a1,a1		;Diagonal
	jrn	gad10
	movk	2,a0		;X pos
	move	a2,a2
	jrn	gadex
	movk	4,a0
	rets

gad10	movk	8,a0		;X neg
	move	a2,a2
	jrn	gadex
	movk	6,a0
	rets

gadx	movk	3,a0		;x velocity case
	move	a1,a1
	jrnn	gadex		;xv + case
	movk	7,a0
	rets

gady	movk	5,a0		;y velocity case
	move	a2,a2
	jrnn	gadex
	movk	1,a0
gadex	rets			;>A0=Dir of travel (1-8)
				;812
				;7 3
				;654


********************************

;NABBED FROM EUGENE JARVIS FOOTBALL CODE
;
;SEEK XY OF ACTIVE OBJECT
;A8=OBJECT SEEKING
;A0=OBJECT SEEKED
;
;RETURNS
;A5=X VEL
;A6=Y VEL
XYSKOBJ
	MOVE	*A0(OXPOS),A5
	MOVE	*A0(OYPOS),A6
;	
;SEEK X-Y COORDINATE
;A8=OBJECT SEEKING
;A5=X COORD TO SEEK
;A6=Y COORD TO SEEK

;RETURNS
;A5=X VEL
;A6=Y VEL
;
;NABBED FROM EUGENE JARVIS FOOTBALL CODE
;
 SUBRP	XYSEEK
	MMTM	SP,A0,A1,A2,A3,A4,A7
	MOVE	*A8(OXPOS),A3
	MOVE	*A8(OYPOS),A4
	SUB	A3,A5		;FIND DIFFERENCE
	SUB	A4,A6
	MOVE	A6,A3		;
	MOVE	A5,A1
	ABS	A5
	ABS	A6
	ADD	A5,A6		;CALC SUM ABS(DX+DY)
	SLL	16,A1		;SHIFT TO ACCOMODATE FRACTIONAL VELOCITY
	SLL	16,A3
	DIVS	A6,A1		;GENERATE SPEED RATIOS
	DIVS	A6,A3
	MOVE	A1,A2
	ABS	A2
	SLL	16,A2
	SRL	28,A2		;CORRECT FOR SQUARE ROOT
	SLL	4,A2
	ADDI	XYSQTAB,A2
	MOVE	*A2,A2
;	MOVK	7,A2
	MOVK	1,A5		;MULTIPLY BY VELOCITY FACTOR
	MPYU	A2,A5
	MPYS	A5,A3
	MPYS	A1,A5		;FINAL X VEL
	SRA	4,A3
	SRA	4,A5
	MOVE	A3,A6		;FINAL Y VEL
	MMFM	SP,A0,A1,A2,A3,A4,A7
	RETS

;CORRECT FOR ANGULAR VELOCITIES
XYSQTAB	.WORD	>20-28,>21-28,>22-28,>23-28,>24-28,>25-28,>26-28,>27-28
	.WORD	>27-28,>26-28,>25-28,>24-28,>23-28,>22-28,>21-28,>20-28



********************************

SQLST	.LONG	0,SQ1,SQ2,SQ3,SQ4,SQ5,SQ6,SQ7,SQ8
SQLST2	.LONG	0,ASQ1,ASQ2,ASQ3,ASQ4,ASQ5,ASQ6,ASQ7,ASQ8
SQ1	.LONG	FSQUAT12A
	.WORD	4
	.LONG	FSQUAT12A
	.WORD	60
	.LONG	FSQUAT12A
	.WORD	4
	.LONG	FNSTND12
	.WORD	4
	.LONG	0
SQ2	.LONG	FSQUAT10
	.WORD	FLIPBITS|4,(M_FLIPH)
	.LONG	FSQUAT10A
	.WORD	60
	.LONG	FSQUAT10
	.WORD	4
	.LONG	FNSTND10
	.WORD	4
	.LONG	0
SQ3	.LONG	FSQUAT9
	.WORD	FLIPBITS|4,(M_FLIPH)
	.LONG	FSQUAT9A
	.WORD	60
	.LONG	FSQUAT9
	.WORD	4
	.LONG	FNSTND9
	.WORD	4
	.LONG	0
SQ4	.LONG	FSQUAT7
	.WORD	FLIPBITS|4,(M_FLIPH)
	.LONG	FSQUAT7A
	.WORD	60
	.LONG	FSQUAT7
	.WORD	4
	.LONG	FNSTND7
	.WORD	4
	.LONG	0
SQ5	.LONG	FSQUAT6
	.WORD	4
	.LONG	FSQUAT6A
	.WORD	60
	.LONG	FSQUAT6
	.WORD	4
	.LONG	FNSTND6
	.WORD	4
	.LONG	0
SQ6	.LONG	FSQUAT7
	.WORD	4
	.LONG	FSQUAT7A
	.WORD	60
	.LONG	FSQUAT7
	.WORD	4
	.LONG	FNSTND7
	.WORD	4
	.LONG	0
SQ7	.LONG	FSQUAT9
	.WORD	4
	.LONG	FSQUAT9A
	.WORD	60
	.LONG	FSQUAT9
	.WORD	4
	.LONG	FNSTND9
	.WORD	4
	.LONG	0
SQ8	.LONG	FSQUAT10
	.WORD	4
	.LONG	FSQUAT10A
	.WORD	60
	.LONG	FSQUAT10
	.WORD	4
	.LONG	FNSTND10
	.WORD	4
	.LONG	0
ASQ1	 .LONG	 FSQUAT12A
	.WORD	4
	.LONG	FSQUAT12A
	.WORD	20
	.LONG	FSQUAT12A
	.WORD	4
	.LONG	FNSTND12
	.WORD	4
	.LONG	0
ASQ2	 .LONG	 FSQUAT10
	.WORD	FLIPBITS|4,(M_FLIPH)
	.LONG	FSQUAT10A
	.WORD	20
	.LONG	FSQUAT10
	.WORD	4
	.LONG	FNSTND10
	.WORD	4
	.LONG	0
ASQ3	 .LONG	 FSQUAT9
	.WORD	FLIPBITS|4,(M_FLIPH)
	.LONG	FSQUAT9A
	.WORD	20
	.LONG	FSQUAT9
	.WORD	4
	.LONG	FNSTND9
	.WORD	4
	.LONG	0
ASQ4	 .LONG	 FSQUAT7
	.WORD	FLIPBITS|4,(M_FLIPH)
	.LONG	FSQUAT7A
	.WORD	20
	.LONG	FSQUAT7
	.WORD	4
	.LONG	FNSTND7
	.WORD	4
	.LONG	0
ASQ5	 .LONG	 FSQUAT6
	.WORD	4
	.LONG	FSQUAT6A
	.WORD	20
	.LONG	FSQUAT6
	.WORD	4
	.LONG	FNSTND6
	.WORD	4
	.LONG	0
ASQ6	 .LONG	 FSQUAT7
	.WORD	4
	.LONG	FSQUAT7A
	.WORD	20
	.LONG	FSQUAT7
	.WORD	4
	.LONG	FNSTND7
	.WORD	4
	.LONG	0
ASQ7	 .LONG	 FSQUAT9
	.WORD	4
	.LONG	FSQUAT9A
	.WORD	20
	.LONG	FSQUAT9
	.WORD	4
	.LONG	FNSTND9
	.WORD	4
	.LONG	0
ASQ8	 .LONG	 FSQUAT10
	.WORD	4
	.LONG	FSQUAT10A
	.WORD	20
	.LONG	FSQUAT10
	.WORD	4
	.LONG	FNSTND10
	.WORD	4
	.LONG	0

FND_EXP2
	MOVI	RDBOOM,A0		;PAL TO STUFF!
	MOVE	A0,*A13(PDATA),L
	CALLA	GETANIXY
FC	MOVE	A2,A11
	MOVE	A3,A10
	CALLA	DELOBJA8
	CALLR	CLEAN_UP_FND
	MOVI	XBOOM2,A9 
	ADDI	[1AH,0],A11		;ALIGN SMART BOMB EXP ON TOP OF FND
	JRUC	NOT_FND
FND_EXP					;XFER HERE FOR EXPLOSION
	MOVE	A10,A7			;BULLET WHO KILLED FIEND
	MOVI	BULLET,A0
	MOVE	A0,*A13(PDATA),L

	CALLA	GETANIXY
	ADDI	[30H,0],A2
	MOVE	A2,A11
	MOVE	A3,A10
	CALLA	DELOBJA8

	MOVE	A9,A9
	JRNZ	NOT_FND
	CALLR	CLEAN_UP_FND

;IF SHOT BY A NON STOPPING BULLET OR FLAME THROWER, FLAME FIEND
	CMPI	CLSPLYR|TYPPLBL|SUBNOSTP,A7
	JREQ	BIGEXP			;GO TO REGULAR FIRE BOMB EXPLOSION
	CMPI	CLSPLYR|TYPPLYR|SUBRNG1,A7
	JREQ	BIGEXP			;GO TO REGULAR FIRE BOMB EXPLOSION
	
	MOVE	@PCTOT,A0
	SUBK	25,A0			;GIVE FIEND AT LEAST THIS KIND OF EXP
	JALE	SUCIDE
BIGEXP	MOVI	BOOM2,A9
	SUBI	[20,0],A11
NOT_FND	MOVE	A10,A0
	MOVE	A11,A1
	MOVI	FRBAL1,A2
	MOVI	158,A3			;163
	MOVI	DMAWNZ|M_NOCOLL,A4
	MOVI	CLSDEAD,A5		;OID
	CLR	A6
	CLR	A7
	CALLA	BEGINOBJ2		;NO WORLD ADDED IN
	move	*a13(PDATA),a0,L	;Set new pallette
	CALLA	GETFPAL
	MOVE	A0,*A8(OPAL)
	SLEEPK	3			;Wait on FLASHME!
	jauc	FRQDELDIE

CLEAN_UP_FND
	move	*a13(fjsobj_p),a0,L
	jrz	fnde2
	calla	DELOBJ			;Kill shadow
fnde2	move	*a13(fndsp_p),a0,L
	jrz	fnde5
	calla	KILL			;Kill spitter
	move	@fndnumfire,a0
	subk	1,a0
	move	a0,@fndnumfire
fnde5
	move	@FND_CNT,a0
	dec	a0
	move	a0,@FND_CNT
	RETS

BOOM3	.LONG	EXPb1
	.WORD	4
	.LONG	EXPb2
	.WORD	4
	.LONG	EXPb3
	.WORD	5
	.LONG	EXPb4
	.WORD	5
	.LONG	EXPb5
	.WORD	5
	.LONG	EXPb6
	.WORD	5
	.LONG	EXPb7
	.WORD	5
	.LONG	EXPb8
	.WORD	5
	.LONG	EXPb9
	.WORD	5
	.LONG	0

YKIL_FT2
;RINGS AROUND PLAYER KILLED FIEND
	PUSH	A1,A2,A3,A4,A7,A9,A10
	JRUC	YIN

YKIL_FT	MMTM	SP,A1,A2,A3,A4,A7,A9,A10
	MOVI	>2F2F,A9	;1313,A9		;COLOR TO FLASH
	MOVI	HITFND,A3
	CALLR	DO_PUNISH
	JRLT	PUSHME

YIN	MOVE	*A0(OID),A2
	CMPI	CLSPLYR|TYPPLBL|SUBNOSTP,A2
	JRZ	FE0
	CMPI	CLSPLYR|TYPPLYR|SUBRNG1,A2	;PLAYER WITH RINGS ON
	JRZ	FE0
	MOVE	@PCTOT,A2		;Kill fiend with non stopping bullets
	SUBK	25,A2
	JRGE	FE0			;HAVE ROOM FOR PIECES?
	CLR	A9			;XV
	CLR	A10			;YV
	MOVI	BLSTS,A11		;CLSTS2
	PUSH	A0
	CREATE0	CHUNK_OBJ
	MOVE	A0,A9

	MOVE	*A8(OPLINK),A0,L
	MOVE	*A0(FND_COLOR),A0,W
	ADDI	FCOLORS,A0
	MOVE	*A0,A0,L
;	MOVI	GRNTPNK,A0		;Change to speedy grunt PAL
	CALLA	GETFPAL			;GET A COLOR MAP ASSIGNMENT
	MOVE	A0,*A9(PDATA)		;TELLS CHUNKS TO USE THIS PAL
	PULL	A0

FE0	MMFM	SP,A1,A2,A3,A4,A7,A9,A10
	JRUC	KILL_F1


********************************

;TYPE PLAY BULLET SUB TYPES
;
;SUBLZR		.EQU	0001H		;REGULAR LAZER SHOTS
;SUBSPRY	.EQU	0002H		;SPRAY SUB TYPE
;SUBFIRE1	.EQU	0003H		;FIRE BALL WPN
;SUBGRND	.EQU	0004H		;GRENADE
;SUBNOSTP	.EQU	0005H		;NON STOPPING BULLET
;SUBSPDG1	.EQU	0006H		;MACHINE GUN TYP WPN


 SUBR	DO_PUNISH	;A0=*Killer obj, A3=ABSRB Max, A8=*Punished obj
			;Preserves A0,A8,A9

	movb	*a0(OID),a4		;Killers OID. Bad if not bullet
	SLL	3,A4
	ADDI	PUNISH,A4
	MOVB	*A4,A4
	MOVE	*A8(OPLINK),A1,L
	MOVE	*A1(ABSRB),A2
	ADD	A4,A2
	MOVE	A2,*A1(ABSRB)
	MOVE	*A0(OPLINK),A10,L	;>A10=*Killers process
	CMP	A3,A2
	RETS				;Pass CC


PUNISH	.BYTE	4*30,2*30,2*30,10,0,4*30,1*30		;4*30 WAS 1
	.EVEN


********************************

;KIL_TURET
;	MOVI	CLSNEUT|TYPTORSO|SUBPIT,A5
;SUBPIT		.EQU	04H		;GUNNER FROM SAND PITS
HIT_TURET
;BULLET HITS TURRET
;A8=TURRET,A0=KILL IMG PNTR
	MMTM	SP,A1,A2,A3,A4,A7,A9,A10
	MOVE	*A8(OID),A3
	ANDI	F_SUBT,A3
	JRZ	TYP1			;T72 TURRET HAS NO SUB ID
	BTST	3,A3
	JRZ	NOTBOOB
;8=BOOB TURRET
	movb	*a0(OID),a4		;Killers OID
	jrnz	ht50			;!Bomb?
	move	a0,a2
	movk	19,a0			;5%
	calla	RNDRNG0
	move	a0,a0
	jrnz	FLTB			;Skip?
	move	a2,a0

ht50	move	@bossmeterv,a1
	subk	3,a1
	move	a1,@bossmeterv
	MOVI	HITTRT4,A3
	MOVI	BLSTS2,A11		;BODY CHUNKS
	CALLR	DO_PUNISH
	JRLT	FLTB			;Boob turret OK?

	move	@bossmeterv,a0
	subi	35*16,a0
	move	a0,@bossmeterv

	MOVI	AGLSEXP,A0
	CALLA	ONESND
	CREATE	FUTUREPID,MOREP
	JRUC	TYPOO

FLTB	MOVI	030300000H,A9
	CREATE0 FLASHME
	MMFM	SP,A1,A2,A3,A4,A7,A9,A10
	RETS
NOTBOOB
	SUBK	2,A3
	JRZ	NOGUNR
;4=SAND PIT GUNNER
	MOVI	HITTRT3,A3
	MOVI	BLSTS,A11		;BODY CHUNKS
	CALLR	DO_PUNISH
	JRLT	FLT
;ABSORBED ENOUGH HITS TO GUNNER
	MOVI	AGLSEXP,A0
	CALLA	ONESND
	CREATE	FUTUREPID,MOREP
	JRUC	TYPOO

	.REF	BLSTS2A
NOGUNR
;2=GUN ON BTR60
	MOVI	BLSTS2,A11
	MOVI	HITTRT2,A3
	MOVE	@WAVE,A1
	CMPI	18,A1
	JRZ	NORD00
	CMPI	17,A1
	JRNZ	NORD
NORD00	MOVI	HITTRT2A,A3
	MOVI	BLSTS2A,A11
;	CLR	A11
NORD
;	MOVI	BLSTS2,A11
	CALLR	DO_PUNISH
	JRLT	FLT
;ABSORBED ENOUGH HITS TO DESTROY TURRET ABOVE BTR60

	PUSH	A10
	MOVE	A8,A0
	CALLA	OBJOFF
	MOVE	*A8(OPLINK),A10,L
	MOVE	*A10(KPTANKO),A10,L
	MOVE	*A10(OPLINK),A10,L
	MOVI	AGLSEXP,A0
	CALLA	ONESND
	CLR	A0
	MOVE	A0,*A10(KPTSO),L

;	MOVE	*A10(MYTYP),A1
;	CMPI	4,A1			;IF IN LOCK DOWN, STOP DEAD BTR60
;	JRNZ	NNOZ
;	CREATE	WARPPID,GOBACK
;NNOZ 
	PULL	A10
	MOVE	@WAVE,A0
	CMPI	18,A0
	JRZ	TYPOG
	CMPI	17,A0
	JRNZ	TYPO
TYPOG	CREATE	FUTUREPID,MOREZ			;ON ROAD
	JRUC	TYPOO

TYP1	MOVI	HITTRT,A3
	MOVI	PBLSTS,A11			;PINK CHUNK LIST
	PUSH	A0
	CALLR	GETUGH
	PULL	A0
	CALLR	DO_PUNISH
	JRLT	FLT
;ABSORBED ENOUGH HITS TO DESTROY TURRET ABOVE T72
	MOVK	24,A9		;14
	PUSH	A10
	MOVE	*A8(OPLINK),A10,L
	MOVE	*A10(KPTANKO),A10,L
	MOVE	*A10(OPLINK),A10,L
	CLR	A0
	MOVE	A0,*A10(KPTSO),L
	CREATE0 SHAKEME
	MOVE	@WAVE,A0
	CMPI	10,A0
	JRNZ	RR4

	CREATE0 SENDB
RR4
	PULL	A10
TYPO
	CREATE	FUTUREPID,MORE

TYPOO
	MOVE	A10,A0
	MOVI	TURTPT,A1			;AMOUNT OF SCORE
	CALLR	SCORE_IT
	MOVE	@PCTOT,A2
	SUBK	015H,A2
	JRGE	TURT_FE
;	MOVE	A11,A11
;	JRZ	TURT_FE
	CALLR	ROOM

	CREATE0 CHUNK_OBJ
	CLR	A1			;TURRET DUDE BLOWING UP
	MOVE	A1,*A0(PDATA)		;TELLS CHUNKS TO USE THIS PAL
	JRUC	TURT_FE

FLT	MOVI	03F3F0000H,A9
	CREATE0 FLASHME
	MMFM	SP,A1,A2,A3,A4,A7,A9,A10
	RETS

SENDB	SLEEPK	1
	MOVE	@SHK_ON,A0
	JRNZ	SENDB
	MOVE	@WORLDTLX,A9,L
	MOVE	@WORLDTLY,A10,L
	SLEEP	40*60
	MOVE	@WORLDTLX,A0,L
	CMP	A0,A9
	JRNZ	SBD
	MOVE	@WORLDTLY,A0,L
	CMP	A0,A10
	JRNZ	SBD
	MOVK	1,A8
	CREATE	FUTUREPID,bomb_neutron
	SLEEP	10*60
	JRUC	SENDB
SBD	DIE

********************************
* Fiend collided with player

 SUBR	FND_PROXCHK	;A0=*Player legs obj, A8=*Fiend obj
	PUSH	a1,a2,a3,a4,a5,a6,a7,a9,a10,a11

	move	*a0(OYPOS),a1
	subk	30,a1			;Offset
	move	*a8(OYPOS),a2
	sub	a2,a1
	jrgt	fpcx			;Player higher than fiend?
	addk	31,a1			;Hgt
	jrlt	fpcx			;Player lower than fiend?

	move	*a0(OPLINK),a2,L
	move	*a2(DEAD),a1
	jrnz	fpcx			;Player dead?
	move	*a2(DELYDET),a1
	jrnz	fpcx			;Player invincible?

	movk	1,a1
	move	a1,@OUT_FLG		;Stop scan

	move	a0,a9			;*PLeg
	movi	SLM,a10
	CREATE0	player_goojnoo

	MOVI	SQUISH,A0
	CALLA	ONESND
fpcx	PULL	a1,a2,a3,a4,a5,a6,a7,a9,a10,a11
	rets


********************************
* Gooj the player (Process)

	APTRPD	MYLIST	,4	;*FRANIM for player death
	APTRPD	MYSND	,6	;*Sound for ^

 SUBRP	player_goojnoo		;A9=*Player legs obj, A10=*Fran_l

	move	*a9(OXPOS),a0
	move	*a9(OYPOS),a1
	sll	16,a0
	sll	16,a1
	movi	SLUD1,a2
	movi	159,a3			;Z
	movi	DMAWNZ+M_NOCOLL,a4
	movi	CLSDEAD,a5
	clr	a6	
	clr	a7
	calla	BEGINOBJ2		;Make 1st slime

 SUBRP	player_gooj		;A8=*Src obj, A9=*Player legs obj, A10=*Fran_l

	move	a10,*a13(MYLIST),L
	movi	EXP3,a1
	move	a1,*a13(MYSND),L
	move	a9,a0
	calla	DO_GOOJ
	SLEEPK	15
	jauc	DELOBJDIE		;Kill 1st slime


********************************
* Fiend spit hit player

 SUBR	plyr_spiton	;A0=*Player legs obj, A8=*Spit obj

	PUSH	a1,a2,a3,a4,a5,a6,a7,a9,a10,a11

	move	*a0(OPLINK),a2,L
	move	*a2(DEAD),a1
	jrnz	psox			;Player dead?
	move	*a2(DELYDET),a1
	jrnz	psox			;Player safe?
					;A0=Object that hit player
					;A8=Player legs image ptr
	SWAP	A0,A8
	CALLA	SHORT_PLYR
	JRNC	psox
	SWAP	A0,A8

	move	a0,a9
	movi	gooj_l,a10
	movi	DMAWNZ+M_NOCOLL,a0
	move	a0,*a8(OFLAGS)
	move	a0,@OUT_FLG		;Stop scan
	move	*a8(OPLINK),a0,L
	clr	a1
	movi	player_gooj,a7
	calla	XFERPROC

psox	PULL	a1,a2,a3,a4,a5,a6,a7,a9,a10,a11
	rets

gooj_l
	LW	GSLMD1,NEWPALET+5
	.long	GOOBP
	LW	GSLMD2,5
	LW	GSLMD3,5
	LW	GSLMD4,15
	LW	GSLMD3,4
	LW	GSLMD2,4
	LW	GSLMD1,4
	.long	0	

********************************

PUSH_FT	;A8=FIEND IMG PNTR, A0=KILLER IMG PNTR

	MMTM	SP,A1,A2,A3,A4,A7,A9,A10
	MOVI	HITFND,A3
	MOVI	>2F2F,A9	;1313,A9		;COLOR TO FLASH
	CALLR	DO_PUNISH
	JRLT	PUSHME

	MOVE	A10,A0			;ABSORBED ENOUGH HITS TO DESTROY IT
	MOVI	FNDPT,A1		;AMOUNT OF SCORE
	CALLR	SCORE_IT

	MOVE	@PCTOT,A2
	SUBK	015H,A2
	JRGE	FE
	CALLR	ROOM

	MOVI	BLSTS,A11
	CREATE0	CHUNK_OBJ
	MOVE	A0,A9

	MOVE	*A8(OPLINK),A0,L
	MOVE	*A0(FND_COLOR),A0,W
	ADDI	FCOLORS,A0
	MOVE	*A0,A0,L
;	MOVI	GRNTPNK,A0		;Change to speedy grunt PAL
	CALLA	GETFPAL			;GET A COLOR MAP ASSIGNMENT
	MOVE	A0,*A9(PDATA)		;TELLS CHUNKS TO USE THIS PAL



;	MOVI	GRNTPNK,A0		;Change to speedy grunt PAL
;	CALLA	GETFPAL			;GET A COLOR MAP ASSIGNMENT
;	MOVE	A0,*A9(PDATA)		;TELLS CHUNKS TO USE THIS PAL

FE	MMFM	SP,A1,A2,A3,A4,A7,A9,A10
	MMTM	SP,A1,A2,A7
	CLR	A9			;FIENDS HAVE NO FIRE CLOUD
	JRUC	CONT
TURT_FE	MMFM	SP,A1,A2,A3,A4,A7,A9,A10
	MMTM	SP,A1,A2,A7
	MOVI	BOOM3,A9		;FRANIM LIST FOR THIS TURRET EXP
	JRUC	CONT2

ROOM					;HAVE ROOM FOR PIECES
	MOVE	*A10(BLTDIR),A10	;A10 SHOULD BE 1-8!
	DEC	A10
	MOVK	7,A0
	AND	A0,A10			;IN CASE A BLADE STRUCK HULK
	SLL	5,A10
	
	MOVI	RNGXL,A0
	ADD	A10,A0
	MOVE	*A0,A0,L
	MOVE	A0,A9			;XVEL

	MOVI	RNGYL,A0
	ADD	A10,A0
	MOVE	*A0,A0,L
	MOVE	A0,A10			;YVEL
	RETS

KILL_F2				;FROM SMART BOMB - FIEND KILL
	MMTM	SP,A1,A2,A7,A9
	MOVE	A9,A2
	MOVI	FNDPT,A1
	CALLA	J5
	CLR	A0
	MOVE	A0,*A8(OID)
	MOVI	300,A0			;200
	MOVE	A0,*A8(OZPOS)
	MOVE	*A8(OPLINK),A0,L
	MOVI	FND_EXP2,A7
	CLR	A1
	CALLA	XFERPROC
	MMFM	SP,A1,A2,A7,A9
	RETS

;KILL FIEND BECAUSE OF COLLISION WITH BULLETS
;A8=FIEND IMG PNTR
;A0=BULLET
KILL_F1
	MMTM	SP,A1,A2,A7
	MOVE	*A0(OID),A10 		;KEEP BULLET OID
	MOVE	*A0(OPLINK),A0,L
	MOVI	FNDPT,A1		;AMOUNT OF SCORE
	CALLR	SCORE_IT
	CLR	A9
CONT
	MOVI	FNDSND,A0
	MOVE	@PCNT,A1
	BTST	0,A1
	JRZ	CN2
	MOVI	ALTEXP1,A0	
CN2	CALLA	ONESND
CONT2
	CLR	A0
	MOVE	A0,*A8(OID)
	MOVE	*A8(OFLAGS),A0
	ORI	M_NOCOLL,A0
	MOVE	A0,*A8(OFLAGS)
	MOVE	*A8(OPLINK),A0,L
	MOVI	FND_EXP,A7		;TURRET DEATHS
	CLR	A1
	CALLA	XFERPROC
	MOVE	A8,A0
	CALLA	OBJOFF
	MMFM	SP,A1,A2,A7
ret	RETS


********************************

SCORE_IT	;A0=*Killer with myplyr stored inside, A1=*Score
	MOVE	*A0(MYPLYR),A0
	MOVI	P1DATA,A2
	SUBK	1,A0			;P1
	JREQ	J5
	SUBK	1,A0			;P2
	JRNZ	ret
	MOVI	P2DATA,A2		;A2=P1DATA OR P2DATA
J5
	jauc	SCRADD2

RNGXL	.LONG	0,0EC00H,0EC00H,0EC00H,0,-0EC00H,-0EC00H,-0EC00H
RNGYL	.LONG	-0C000H,-0C000H,0,0C000H,0C000H,0C000H,0,-0C000H


********************************

GETUGH	MOVE	@PCNT,A1
	ANDI	03H,A1
	SLL	5,A1
	ADDI	UGHS,A1
	MOVE	*A1,A0,L
	jauc	ONESND
UGHS	.LONG	UGH1,UGH2,UGH3,UGH4


********************************


PUSHME	;A9=Flash color

	CALLR	GETUGH
	sll	16,a9
	CREATE0	FLASHME		;FLASH THIS GUY

	MOVE	*A10(BLTDIR),A2		;Bad if non-bullet hit
	SLL	3,A2
	MOVI	YAD-8,A0
	ADD	A2,A0
	MOVB	*A0,A10			;A10=AMOUT TO ADD TO Y OF FATMAN

	MOVE	*A8(OYPOS),A0
	MOVE	*A8(OXPOS),A1
	SLL	16,A0
	MOVX	A1,A0			;GET TOP LEFT OF OBJECT
	MOVE	@WORLDTL,A1,L
	SUBXY	A1,A0			;SUBTRACT OUT WORLD BASE
	MOVX	A0,A1
	SLL	16,A1			;A1=X,A0=Y

	ADD	A10,A0
	CMPI	>380000,A0
	JRLT	SKP
	CMPI	>E10000,A0
	JRGE	SKP

	MOVE	*A8(OYPOS),A0		;OKAY
	ADD	A10,A0
	MOVE	A0,*A8(OYPOS)
SKP	ADDI	XAD-8,A2
	MOVB	*A2,A2			;A1=AMOUNT TO ADD TO X OF FAT
	ADD	A2,A1
	CMPI	>200000,A1
	JRLT	SKP2
	CMPI	>1380000,A1
	JRGE	SKP2
	MOVE	*A8(OXPOS),A0
	ADD	A0,A2
	MOVE	A2,*A8(OXPOS)

SKP2	MMFM	SP,A1,A2,A3,A4,A7,A9,A10
	RETS

YAD	.BYTE	-6,-6,0,6,6,6,0,-6
XAD	.BYTE	0,6,6,6,0,-6,-6,-6
	.EVEN

	.DEF	ENRECT1,ERECT1,ERECT11,ENRECT11,ENRECT13,ERECT13,ENRECT14
	.DEF	ERECT5,ENRECT5,ERECT3,ENRECT3,ENRECT4,ERECT4,ERECT2
	.DEF	ERECT12,ERECT7,ERECT8,ERECT10,ENRECT10,ENRECT12,ERECT6

;8	1	2
;7		3
;6	5	4
;RECTANGLE TYPE,DIRECTION ENEMY WILL MOVE,RECT [X,Y],[X,Y]
;TYPE=0 FOR FIXED RECTANGLE,1=FLOATING LFT RECT,2=FLOATING RGT,3=FLOATING TOP
;4=FLOATING BOTM,5=FIXED WITHOUT LOTS OF RANGE,6=FROM TOP ROOF,7=FROM RIGHT
;ROOF
ERECT1
	.WORD	0,7,645-XX,1225-YY,650-XX,1268-YY	;FOR SPAWNING
	.WORD	0,7,645-XX,1225-YY,650-XX,1268-YY
	.WORD	0,7,645-XX,1225-YY,650-XX,1268-YY
	.WORD	0,7,645-XX,1000-YY,650-XX,1110-YY
	.WORD	0,7,645-XX,1000-YY,650-XX,1110-YY
	.WORD	0,3,200-XX,1000-YY,205-XX,1025-YY
	.WORD	0,3,200-XX,1000-YY,205-XX,1025-YY
	.WORD	0,3,200-XX,1000-YY,205-XX,1025-YY
ERECT2	.WORD	0,3,200-XX,779-YY,205-XX,789-YY 	;FOR SPAWNING
	.WORD	0,7,645-XX,779-YY,663-XX,780-YY
	.WORD	5,7,600-XX,535-YY,640-XX,555-YY		;HUT
	.WORD	5,7,600-XX,535-YY,640-XX,555-YY
	.WORD	5,7,600-XX,665-YY,640-XX,670-YY 	;HUT SPAWN
	.WORD	3,5,150,-60,210,-45			;FLOATING IN FROM TOP
	.WORD	3,5,150,-60,210,-45	  		;FLOATING IN FROM TOP
	.WORD	3,5,150,-60,210,-45	  		;FLOATING IN FROM TOP
ERECT3
	.WORD	0,1,463-XX,443-YY,483-XX,453-YY
	.WORD	0,1,463-XX,443-YY,483-XX,453-YY
	.WORD	0,7,611-XX,318-YY,631-XX,336-YY
	.WORD	0,3,368-XX,327-YY,383-XX,342-YY 	;FOR REACTOR AREA
	.WORD	0,3,368-XX,327-YY,383-XX,342-YY 	;FOR REACTOR AREA
	.WORD	0,7,611-XX,318-YY,631-XX,336-YY
	.WORD	0,4,277-XX,395-YY,299-XX,405-YY		;BOTM OF REACTOR
	.WORD	6,5,415-XX,145-YY,425-XX,155-YY		;FROM ROOF
ERECT4
	.WORD	0,1,895-XX,463-YY,910-XX,469-YY	
	.WORD	0,1,895-XX,463-YY,910-XX,469-YY
	.WORD	0,3,690-XX,335-YY,705-XX,350-YY
	.WORD	0,3,690-XX,335-YY,705-XX,350-YY	
	.WORD	6,5,880-XX,145-YY,970-XX,165-YY 	;ROOF
	.WORD	6,5,880-XX,145-YY,970-XX,165-YY 	
	.WORD	7,7,0380H,325-YY,0390H,340-YY		;FROM ROOF
	.WORD	7,7,0380H,325-YY,0390H,340-YY		;FROM ROOF
ERECT5	.WORD	0,3,369-XX,2564-YY,384-XX,2579-YY 	;SECRET PATH #1 LOWER
	.WORD	0,3,369-XX,2564-YY,384-XX,2579-YY 	;SECRET PATH #1 LOWER
	.WORD	0,7,457-XX,2335-YY,466-XX,2410-YY
	.WORD	0,7,457-XX,2335-YY,466-XX,2410-YY
	.WORD	0,7,457-XX,2335-YY,466-XX,2410-YY
	.WORD	3,5,110,-60,170,-45	  		;FLOATING IN FROM TOP
	.WORD	3,5,110,-60,170,-45	  		;FLOATING IN FROM TOP
	.WORD	3,5,110,-60,170,-45	  		;FLOATING IN FROM TOP
ERECT6	.WORD	7,7,640-XX,1824-YY,665-XX,1850-YY 	;SECRET PATH #1 MIDDLE
	.WORD	7,7,640-XX,1824-YY,665-XX,1850-YY
	.WORD	7,7,640-XX,1824-YY,665-XX,1850-YY
	.WORD	7,7,640-XX,1824-YY,665-XX,1850-YY 	
	.WORD	3,5,110,-60,170,-45	  		
	.WORD	3,5,110,-60,170,-45	  		
	.WORD	3,5,110,-60,170,-45
	.WORD	3,5,110,-60,170,-45
ERECT7	;ROADWAY AREA
	.WORD	1,3,-50,70,-35,110
	.WORD	1,3,-50,70,-35,110
	.WORD	2,7,410,70,430,110
	.WORD	2,7,410,70,430,110
	.WORD	2,7,410,70,430,110
	.WORD	3,5,80,-60,270,-45
	.WORD	3,5,80,-60,270,-45
	.WORD	3,5,80,-60,270,-45
ERECT8	;TOP OF SECRET AREA #1
	.WORD	0,1,463-XX,443-YY,483-XX,453-YY
	.WORD	0,7,605-XX,358-YY,620-XX,372-YY
	.WORD	0,3,220-XX,358-YY,232-XX,372-YY
	.WORD	0,7,605-XX,358-YY,620-XX,372-YY
	.WORD	0,3,220-XX,358-YY,232-XX,372-YY	
	.WORD	6,5,291-XX,145-YY,326-XX,165-YY 	;ROOF
	.WORD	6,5,491-XX,145-YY,530-XX,165-YY 	
	.WORD	6,5,491-XX,145-YY,530-XX,165-YY 	


XX		.EQU	241
YY		.EQU	202
XX2	.EQU	241-13		;FOR LOWER DESERT MODULE
YY2	.EQU	202+48H
ERECT10						;1ST LOCKDOWN IN DESERT
	.WORD	0,1,621-XX2+22,4610-YY2+52,631-XX2+22,4625-YY2+52
	.WORD	0,3,447-XX2-50,4438-YY2+43,457-XX2-50,4455-YY2+43
	.WORD	0,7,839-XX2+25,4438-YY2+43,849-XX2+25,4453-YY2+43
	.WORD	0,5,595-XX2+25,4356-YY2-36,605-XX2+25,4351-YY2-20
	.WORD	0,1,621-XX2+22,4610-YY2+52,631-XX2+22,4625-YY2+52
	.WORD	0,3,447-XX2-50,4438-YY2+43,457-XX2-50,4455-YY2+43
	.WORD	0,7,839-XX2+25,4438-YY2+43,849-XX2+25,4453-YY2+43
	.WORD	0,5,595-XX2+25,4356-YY2-36,605-XX2+25,4351-YY2-20
ERECT11		;PATH A AND B AFTER FIRST LOCKDOWN
;ALSO USED FOR WAVE 13 FAST GUYS COMING DOWN AND WAVE 16
	.WORD	3,5,190,-60,250,-45   ;110!   250	;FLOATING IN FROM TOP
	.WORD	3,5,190,-60,250,-45	  		;FLOATING IN FROM TOP
	.WORD	3,5,190,-60,250,-45	  		;FLOATING IN FROM TOP
	.WORD	3,5,190,-60,250,-45	  		;FLOATING IN FROM TOP
	.WORD	3,5,190,-60,250,-45	  		;FLOATING IN FROM TOP
	.WORD	3,5,190,-60,250,-45	  		;FLOATING IN FROM TOP
	.WORD	3,5,190,-60,250,-45	  		;FLOATING IN FROM TOP
	.WORD	3,5,190,-60,250,-45	  		;FLOATING IN FROM TOP
ERECT12		;2ND DESERT LOCKDOWN WITH HUT ON LEFT
	.WORD	0,1,403-XX2+22,3185-YY2+52,413-XX2+22,3200-YY2+52
	.WORD	0,1,403-XX2+22,3185-YY2+52,413-XX2+22,3200-YY2+52
	.WORD	0,7,642-XX2+25,3019-YY2+43,648-XX2+25,3035-YY2+43
	.WORD	0,5,417-XX2+25,2935-YY2-36,427-XX2+25,2930-YY2-20
	.WORD	0,3,325-XX2-50,2985-YY2+43,335-XX2-50,2997-YY2+43
	.WORD	0,3,325-XX2-50,2985-YY2+43,335-XX2-50,2997-YY2+43
	.WORD	0,7,642-XX2+25,3019-YY2+43,648-XX2+25,3035-YY2+43
	.WORD	0,5,417-XX2+25,2935-YY2-36,427-XX2+25,2930-YY2-20
ERECT13		;1ST AIRPORT LOCKDOWN
	.WORD	0,1,0D32H,1118H,0D4CH,1120H
	.WORD	0,3,0C61H,1070H,0C6BH,10A0H
	.WORD	0,5,0D3FH,0FECH,0D42H,0FF6H
	.WORD	0,7,0E10H,1088H,0E20H,108CH
	.WORD	0,1,0D32H,1118H,0D4CH,1120H
	.WORD	0,3,0C61H,1070H,0C6BH,10A0H
	.WORD	0,5,0D3FH,0FECH,0D42H,0FF6H
	.WORD	0,7,0E10H,1088H,0E20H,108CH

ENRECT1 .WORD	240-XX,948-YY,378-XX,983-YY+10,4	;DIR TO TURN TOWARD
;FOR HULK COLLISIONS WITH BOX
	.WORD	501-XX-20,948-YY,620-XX,983-YY+10,6
	.WORD	0
ENRECT3 .WORD	280-XX,304-YY,367-XX,381-YY,3		;REACTOR AREA
	.WORD	0
ENRECT4 .WORD	836-XX,210-YY,1064-XX,300-YY,6		;ELEVATOR DOWN AREA
	.WORD	0
ENRECT5 .WORD	268-XX,2525-YY,365-XX,2617-YY,3	;SECRET PATH LOWER AREA
	.WORD	518-XX,2324-YY,609-XX,2471-YY,7	;
	.WORD	541-XX,2152-YY,640-XX,2223-YY,7	;NEAR BOXES
ENRECT6 .WORD	546-XX,1792-YY,656-XX,1999-YY,7	;SECRET PATH UPPER AREA
	.WORD	251-XX,1611-YY,352-XX,1703-YY,4
	.WORD	518-XX,1635-YY,627-XX,1701-YY,6
	.WORD	0

ENRECT10						;START OF DESERT
;PIT ON LEFT AT START OF DESERT
	.WORD	09EH,126DH-3AH-20,122H,131CH-3AH,3	;9E=CE
	.WORD	122H,127FH-3AH-20,145H,1314H-3AH,3
	.WORD	146H,128DH-3AH-20,155H,1310H-3AH,3
	.WORD	155H,12A6H-3AH-20,168H,1308H-3AH,3
	.WORD	168H,12C8H-3AH-20,17CH,12F0H-3AH,3
;MOUND ON RIGHT
	.WORD	675-XX2-20,4849+11-YY2-20,870-XX2,4917+32-YY2-16,7
;FIRST BARBED WIRE LINE
	.WORD	226+6-XX2-20,4600+17-YY2-20,603+25-XX2,4635+27-YY2,1
	.WORD	733+6-XX2-20,4600+17-YY2-20,1028+25-XX2,4635+27-YY2,1
;FOR GOING DOWN WHEN BUMPING INTO BARBED WIRE FENCE
	.WORD	226+6-XX2-20,4635+28-YY2,613+25-XX2,4635+28-YY2+30,3
	.WORD	723+6-XX2-20,4635+28-YY2,1028+25-XX2,4635+28-YY2+30,7
;GO DOWN FROM LINE
;	.WORD	226+6-XX2-20,4600+37-YY2-20,603+25-XX2,4635+37-YY2,5
;	.WORD	733+6-XX2-20,4600+37-YY2-20,1028+25-XX2,4635+37-YY2,5
	.WORD	0
ENRECT11			;START OF SCROLL PATHB AND PATHA!
	.WORD	758+6-XX2-30,4370+20-YY2-35,864+25-45-XX2+15,4407+25-YY2+10,7	;WALL TOPRGT
	.WORD	590+3-XX2-30,3891+20-YY2-35,776+20-XX2+15,3869+61+25-YY2+10,2 ;MID SCRN WAL
	.WORD	586+3-XX2-30,3669+20-YY2-35,682+20-XX2+15,3647+61+25-YY2+10,7 ;MID TURT WAL
	.WORD	372+3-XX2-30,3255+20-YY2-35,1044+25-XX2+15,3263+61+25-YY2+10,6 ;LONG WALL
	.WORD	490+3-XX2-30,3891+20-YY2-35,656+20-XX2+15,3869+61+25-YY2+10,6 ;MID SCRN WAL LFT SIDE
	.WORD	0
ENRECT12			;2ND DESERT LOCKDOWN AT HUT
	.WORD	248-XX2,2964-YY2,338+28-XX2,3099+32-YY2,4   ;HUT AT LK DWN
	.WORD	0
ENRECT13			;NEAR HUT 2 DISHES
;SCROLLING UP INTO NEW DESERT AREA FOR HULKS NEAR BIG HUTS
	.WORD	139H,5ECH-16,205H,692H+20,3			;SQR HUT
	.WORD	0
ENRECT14			;FROM TRIPLE GUNNERS UP
;SCROLLING UP INTO NEW DESERT AREA FOR PLAYERS NEAR BIG HUTS
	.WORD	97H,368H,35FH,395H,5			;TRIPLE WALL
;	.WORD	9H,227H+30,18CH,268H,3			;LOWER CLIFF
;	.WORD	100H,198H,2C5H,1E4H,6			;UPPER CLIFF
	.WORD	9H,227H+20,190H,26CH,3			;LOWER CLIFF
	.WORD	100H,198H,2C5H,1E2H,6			;UPPER CLIFF
	.WORD	0


	.END



