**************************************************************
*
* Software:		TODD ALLEN
* Initiated:		1989?
*
* Modified:		Mark Turmell, 7/17/90	-Total Carnage
* 			Shawn Liptak, 7/?/91	-Speed improvements
* 			Shawn Liptak, 7/?/91	-SL type stuff
* 			Shawn Liptak, 8/30/91	-New collision loop
* 			Shawn Liptak, 9/18/91	-Pixscan improvements
*
* COPYRIGHT (C) 1991 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 12/13/91 20:27
**************************************************************
	.FILE	'COLL2.ASM'
	.TITLE	"COLLISION ROUTINES"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST


****************************************************************************
* When writing collision routines which are to be called from the collision
* scanner in this file, the following things should be taken into
* consideration:
*   The collision routines are called, not created..
*   The collision routine receives a ptr to the victims OBJ in A8
*   The collision routine receives a ptr to the killers OBJ in A0
*   The collision routine can destroy A0,A8,A14,B0,B1.
*   Other registers must be preserved!
*
*   When OBJ1,OBJ2 collide, two routines are called, one with
*    OBJ1 in A8 and the other with OBJ2 in A8.  A collision routine
*    should only affect the victim, and not the killer.
*   If a victim object is deleted, it will not be scanned futher.
*   If any other object is deleted, the collision scan will be aborted.
*   To prevent multiple simultaneous collisions of the same victim
*   object, the object ID of the victim object should be modified
*   by the collision routine, if the victims nature is changed.


; GET THE SYSTEM STUFF

	.INCLUDE	"MPROC.EQU"		;MPROC EQUATES
	.INCLUDE	"DISP.EQU"		;DISPLAY PROCESSOR EQUATES
	.INCLUDE	"\VIDEO\SYS\SYS.INC"	;ZUNIT SYSTEM EQUATES
	.INCLUDE	"\VIDEO\SYS\GSP.INC"	;ZUNIT SYSTEM EQUATES
	.INCLUDE	"\VIDEO\SYS\MACROS.HDR"	;MACROS, YEAH!
	.INCLUDE	"GAME.EQU"
	.INCLUDE	"IMGTBL.GLO"


;SOUNDS



;SYMBOLS EXTERNALLY DEFINED

	.ref	BMBLTSON,RANDPER,GATE_PLYR,GETUGH,LAND
	.ref	SPRAYON,EXTRA,RINGON,NSTPON,KEYON,SHOEON,SMRTON,BMBON
	.ref	KILL_PLYR,KILL_BULL,BNC_PLYR,BNC_PLYR2,KILL_GATE,BMLM2,PCNT
	.ref	GOT_HSTG,KILL_CRT,KILL_HULK,BAT_PLYR,DEL_BULL,TCSH,KILL_CRT2
	.ref	PUSH_FT,YKIL_FT,YKIL_FT2,FIREON,SPDGON,GRENON,HLPON,LSDMG
	.ref	KILL_HULKZ,KILL_CBALL,KILL_BULL2,KILL_BULL3
	.ref	I_FLM,YKIL_RNG,FND_PROXCHK
	.ref	HIT_TURET,HIT_TNK,HIT_TNK2,P1DATA,P2DATA
	.ref	FLAME_LAY,YKIL_LAY,KILL_BULLG
	.ref	KILL_AHMDZ,KILL_AHMD,plyr_spiton
	.ref	slt_hit,slt_ringhit,slt_bbhit,spidegg_touch
	.ref	bombsmn_touch
	.ref	orcus_hit,bossd_t,aboss_hit

;SYMBOLS DEFINED IN THIS FILE

	.DEF	COLLISIONS,SHORT_PLYR,OUT_FLG

;UNINITIALIZED RAM DEFINITIONS

	.BSS	PList,32*(NOBJ+1)	;list of objects of class player
	.BSS	NList,32*(NOBJ+1)	;list of objects of class neutral
	.BSS	EList,32*(NOBJ+1)	;list of objects of class enemy
	.BSS	DumObj,OBSIZ
	.BSS	OUT_FLG,16		;1=DON'T CONT SCANNING THIS OBJECT
	.BSS	BRAM,16			;RAM FOR THROWING OUT PLTK COLLIDES
;NOBJ=NUMBER OF OBJECTS TO DISPLAY


;EQUATES FOR THIS FILE

ODMAIMG	.EQU	OIMG
ODMAFLG	.EQU	OFLAGS

IBAT		.EQU	PDATA+464	;UHW	BAT FLAG 0=OFF, 1=ON
;SAME AS IN NEWHULK.ASM


****************************************************************************
* Old collision loop

	.if	0			;Not used!!
	.def	debugtime
	.def	debugtimem
	.bss	debugtime	,16
	.bss	debugtimem	,16

COLLISIONS
	SLEEPK	1
	move	@VCOUNT,b5

	move	@WORLDTLX+16,A6	;* COLLISION SCAN FOR OBJECTS ON SCREEN
	movi	400,A14		;End of Scan area

coll1	move	A6,A7		;A7 Sector Xmin
	addi	128,A6		;A6 Sector Xmax

	subi	128,A14
	jrnn	XmaxOk
	add	A14,A6

XmaxOk	movi	OBJLST,a0	;Object list to check
	callr	cscnrng

	move	A14,A14
	jrp	coll1


	move	@VCOUNT,b0
	sub	b5,b0
	jrhs	coll10
	addi	>120,b0		;VTOTAL
coll10	move	@debugtime,b1
	add	b0,b1
	srl	1,b1
	move	b1,@debugtime
	move	@debugtimem,b2
	cmp	b1,b2
	jrge	coll20
	move	b1,@debugtimem	;New max
coll20	jruc	COLLISIONS


********************************
*A0 * to obj list to scan
*A6 Xmax
*A7 Xmin
*Scan OBJ list, any collideable OBJ overlapping Xmin-Xmax put on
*either EList,PList or NList depending on class
*Call ColLists with each pair of lists

cscnrng
	mmtm	sp,a6,a7,a14
	
	movi	PList,A9		;Build collision lists
	move	a9,a4
	movi	EList,A10
	movi	NList,A11
	jruc	MkLists

csr20	move	a0,*a10+,L		;Insert obj on enemy list
MkLists	move	*a0,a0,L		;Get next obj
	jrz	GotLists

	move	*a0(OXPOS),a1		;OBJ CAN LIE ON max/min boundary
	cmp	a6,a1
	jrhi	MkLists

	move	*a0(OSIZEX),a2
	add	a2,a1
	cmp	a7,a1
	jrlo	MkLists			;Out of range?

	movb	*a0(OFLAGS+B_NOCOLL-7),a2
	jrn	MkLists			;Not collideable?

	move	*a0(OID),a2		;Check Class
	jrn	csr20			;Enemy?
	btst	14,a2
	jrnz	csr40			;Player?

	move	a0,*a11+,L		;Insert obj on neutral list
	jruc	MkLists

csr40	move	a0,*a9+,L		;Insert obj on player list
	jruc	MkLists

GotLists
	clr	a0			;Null terminate each list
	move	a0,*a9,L
	move	a0,*a10,L
	move	a0,*a11,L

	move	*A4,A0,L
	jrz	NoPList			;Nothing on player list?

	movi	EList,A3		;E/P
	callr	ColLists

	movi	NList,A3		;N/P
	movi	PList,A4
	callr	ColLists

NoPList

ScnRngX	mmfm	sp,a6,a7,a14
	rets
	.endif



****************************************************************************
* Collision loop (New version)

COLLISIONS
	SLEEPK	1

	move	@WORLDTLX+16,a6		;A6=Xmin
	move	a6,a7
	addi	100,a7			;A7=Xmax
	move	a7,b3
	callr	collx

	move	b3,a6
	move	a6,a7
	addi	100,a7
	move	a7,b3
	callr	collx

	move	b3,a6
	move	a6,a7
	addi	100,a7
	move	a7,b3
	callr	collx

	move	b3,a6
	move	a6,a7
	addi	100,a7
	callr	collx

	jruc	COLLISIONS

********************************
* Build lists and collide based on X
* A6=XMin
* A7=XMax (+1)

collx
	movi	OBJLST,a0		;Object list to check

	movi	PList,a9		;Build collision lists
	move	a9,b4			;Set A5/B4 for 1st collision call
	movi	EList,a10
	move	a10,a5
	movi	NList,a11
	jruc	mklists

csr20	move	a0,*a10+,L		;Insert on enemy list
mklists	move	*a0,a0,L		;Get next obj
	jrz	gotlists

	movb	*a0(OFLAGS+B_NOCOLL-7),a2
	jrn	mklists			;Not collideable?

	move	*a0(OXPOS),a1		;Obj can lie on max/min boundary
	cmp	a7,a1
	jrge	mklists			;Out of range?

	move	*a0(OSIZEX),a2
	add	a2,a1
	cmp	a6,a1
	jrle	mklists			;Out of range?

	move	*a0(OID),a2		;Check Class
	jrn	csr20			;Enemy?
	btst	14,a2
	jrnz	csr40			;Player?

	move	a0,*a11+,L		;Insert on neutral list
	jruc	mklists

csr40	move	a0,*a9+,L		;Insert on player list
	jruc	mklists

gotlists
	move	a0,*a9,L		;Null terminate each list
	move	a0,*a10,L
	move	a0,*a11,L

	callr	ColLists		;Collide enemy to player

	movi	NList,a5
	movi	PList,b4
;	jruc	ColLists		;Collide neutral to player
					;Fall through

********************************
* Collide objects on list A5 with those on LIST B4
* A5,B4=ptrs to null terminated tables of object ptrs

ColLists
CLstsLp0
	move	*a5+,a1,L
	jrz	scndone
					;Load up coors of obj from first list
	move	*a1(OXPOS),a9		;A9=OBJ1 Xmin
	jrz	CLstsLp0		;Deleted?
	move	*a1(OSIZEX),a10		;A10=OBJ1 Xmax (+1)
	add	a9,a10
	move	*a1(OYPOS),a7		;A7=OBJ1 Ymin
	move	*a1(OSIZEY),a11		;A11=OBJ1 Ymax (+1)
	add	a7,a11

	move	b4,a6			;Load head of second list

PScnLp1	move	*a6+,a2,L
	jrz	CLstsLp0

	move	*a2(OYPOS),a0		;Check objs A1,A2 for intersection
	cmp	a11,a0
	jrge	PScnLp1			;Y2Min >= Y1Max?
	move	*a2(OSIZEY),a14
	add	a14,a0
	cmp	a7,a0
	jrle	PScnLp1			;Y2Max <= Y1Min?

	move	*a2(OXPOS),a0		;Signed compares because objs may lie on 0
	jrz	PScnLp1			;Deleted?
	cmp	a10,a0
	jrge	PScnLp1			;X2Min >= X1Max?
	move	*a2(OSIZEX),a14
	add	a14,a0
	cmp	a9,a0
	jrle	PScnLp1			;X2Max <= X1Min?

	callr	ColFunc			;>Call colfunc for obj A1 and A2
	move	b0,b1			;B1=*Collision routine for obj A1
	SWAP	a1,a2
	callr	ColFunc
	SWAP	a1,a2
	move	b0,b2			;B2=*Collision routine for obj A2
	or	b1,b0			;Set z flag if both are zero
	jrz	PScnLp1

	movb	*A1(OFLAGS+B_PIXSCAN-7),A14 ;Is PIXSCAN ON
	jrn	DoPScn0
	movb	*A2(OFLAGS+B_PIXSCAN-7),A14 ;Is PIXSCAN ON
	jrnn	SkPxScn0
DoPScn0	callr	PIXSCAN
	jrnc	PScnLp1			;BR=THIS WASN'T REALLY A COLLISION
SkPxScn0

	clr	a0
	move	a0,@OUT_FLG		;Clr flag

	move	b1,b1
	jrz	PObj2Col
	move	a1,a8
	move	a2,a0
	call	b1			;Call collision for A1

PObj2Col
	move	b2,b2
	jrz	PCkFree
	move	a2,a8
	move	a1,a0
	call	b2			;Call collision for A2

PCkFree	move	@OUT_FLG,a0
	jrz	PScnLp1			;Continue scan?
	jruc	CLstsLp0

scndone	rets


****************************************************************************
* Return in B0 routine for obj A1 struck by obj A2
* Trashes A3-A4

ColFunc
	movb	*a1(OID+8),a3
	movb	*a2(OID+8),a4
	sll	32-5,a3
	srl	17,a3		;32 Long Word Align
	sll	32-5,a4
	srl	22,a4		;Long Align
	add	a4,a3
	addi	TypeTbl,a3

	move	*a3,a3,L
	jump	a3		;Routine can trash A0/A3/A4/A8/A14


****************************************************************************
* These are the COLLISION FUNCTIONS
* A collision function is selected by the routine ColFunc
* which uses the TYPE field of the victims OID to select a subtable
* and indexes the subtable with the TYPE field of the killer.
* This gives a ptr to a COLLISION FUNCTION which returns
* the COLLISION ROUTINE to be called for the victim in B0.
* The COLLISION FUNCS can destroy registers A0,A3,A4,A8
****************************************************************************

TypeTbl:
;0000
;NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
;0100
;PLAYER
	.LONG	NULL, NULL, NULL, PLTR, PLGT, NULL, NULL, NULL
	.LONG	NULL, PLTR, PLHU, NULL, PLHU, NULL, NULL, PLTR
	.LONG	PLTK, NULL, PLMN, PLHU, PLFG, PLSL, NULL, PLMN
	.LONG	PLJT, PLAF, PLBT, PLFL, NULL, NULL, NULL, NULL
;0200
;PLAYER BULLET
	.LONG	NULL, NULL, NULL, BLTR, BLTR, NULL, NULL, NULL
	.LONG	NULL, BLTR, BLHU, BLFN, NULL, NULL, NULL, BLGR
	.LONG	BLTK, BLTK, BLLY, BLFN, BLFG, BLSL, NULL, NULL
	.LONG	BLTR, BLAF, NULL, BLTR, NULL, NULL, NULL, NULL
;0300
;TREE TRUNK TYPE ITEMS
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
;0400
;GATES/DOORS
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
;0500
;TIME BOMBS (PLYR CLASS)
	.LONG	NULL, NULL, NULL, NULL, BMGT, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, BMLM
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
;0600
;HOSTAGES
	.LONG	NULL, HSPL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
;0700
;TEXT
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
;0800
;ICONS
	.LONG	NULL, ICPL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
;0900
;CRATE
	.LONG	NULL, NULL, CRBL, NULL, NULL, CRBM, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
;0A00
;HULK ENEMY
	.LONG	NULL, HUPL, HUBL, NULL, NULL, HUBM, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, HUBD, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
;0B00
;FIEND ENEMY
	.LONG	NULL, FNPL, FNBL, NULL, NULL, FNBM, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, FNBM, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
;0C00
;ENEMY SHOTS/CANNON BALL
	.LONG	NULL, CBPL, NULL, NULL, NULL, CBBM, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, CBLS, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
;0D00
;HELPER BLADE AROUND PLYRS/ LS
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, LSHU, LSHU, LSHU, NULL, LSHU, NULL
	.LONG	NULL, NULL, NULL, LSHU, NULL, LSHU, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
;0E00
;GOO SHRAPNEL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, CBLS, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
;0F00
;GROW FROM SLIME
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
;1000
;BIG TANK BASE
	.LONG	NULL, NULL, TKBL, NULL, NULL, TKBM, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
;1100
;TANK TORSO
	.LONG	NULL, NULL, TSBL, NULL, NULL, TSBM, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
;1200
;MINE LAYER
	.LONG	NULL, LYPL, LYBL, NULL, NULL, LYBM, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, LYBM, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
;1300
;AHMED FLAME THROWER
	.LONG	NULL, AHPL, AHBL, NULL, NULL, AHBM, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, AHBM, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
;1400
;ORCUS
	.LONG	NULL, NULL, FGBL, NULL, NULL, FGBM, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
;1500
;SHAWN SKIPPER/GRUNT ENEMY
	.LONG	NULL, SLPL, SLBL, NULL, NULL, SLBB, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, SLBB, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
;1600
;CANNON BALL THAT EXPLODES
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
;1700
;LAND MINES
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
;1800
;JETS
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
;1900
;Akhboob's flying death machine
	.LONG	NULL, NULL, AFBL, NULL, NULL, AFBM, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
;1A00
;BOLT OF ELECTRICITY
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
;1B00
;CHECKPOINT US FLAG
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
;1C00
;Free
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
;1D00
;Free
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
;1E00
;Free
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
;1F00
;Free
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
	.LONG	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL


TKBL
;BIG TANK WITH BULLET
	MOVE	*A1(OID),A0
	BTST	0,A0
	JRNZ	NULL
	MOVI	HIT_TNK,B0
	RETS

TKBM				;BIG TANK WITH TIME BOMB
	MOVE	*A1(OID),A0
	BTST	0,A0
	JRNZ	NULL
	MOVI	HIT_TNK2,B0
	RETS

TSBL				;TURRET WITH BULLET
TSBM				;TURRET WITH TIME BOMB
	MOVI	HIT_TURET,B0
	RETS

CBPL				;IF IT HIT RINGS THEN KILL IT
	movb	*a2(OID),a0
	subk	3,a0		;CHECK TO SEEK IF I'M HITTING RING NOT PLAYER
	jrz	NULL
	movb	*a1(OID),a0
	jrz	CBLS
	movi	plyr_spiton,b0
	rets


CBLS				;CANNON BALL / HELPER BLADE AROUND PLAYER
	MOVE	*A2(OIMG),A0,L
	CMPI	BLADE,A0			;HELPER BLADE IMG
	JRNE	NULL

CBBM	;WITH BOMB
	MOVI	KILL_CBALL,B0
	RETS

LSHU	;HELPER BLADE WITH ANYTHING
	MOVE	*A1(OIMG),A0,L
	CMPI	BLADE,A0
	JRNE	NULL			;MINE LAYER, BTR60, ETC.
	MOVI	LSDMG,B0		;THIS IS REALLY HELPER
	RETS

LYPL				;IF MINE LAYER HIT RINGS THEN KILL IT
	MOVE	*A1(OID),A0
	BTST	0,A0		;CHECK FOR SUBFLM!
	JRNZ	NOKL
	MOVB	*A2(OID),A0	;CHECK TO SEEK IF I'M HITTING RING NOT PLAYER
	subk	3,a0
	JREQ	LHA
NOKL	CLR	B0
	RETS
LHA	MOVI	YKIL_RNG,B0
	RETS


LYBM	MOVE	*A1(OID),A0
	BTST	0,A0			;CHECK FOR SUBFLM!
	JRNZ	NOKL
	MOVI	YKIL_LAY,B0
	RETS

LYBL	MOVE	*A1(OID),A0
	BTST	0,A0			;CHECK FOR SUBFLM!
	JRNZ	NOKL
	MOVI	FLAME_LAY,B0
	RETS

FNPL				;IF FIEND HIT RINGS THEN KILL IT
	MOVB	*A2(OID),A0	;CHECK TO SEEK IF I'M HITTING RING NOT PLAYER
	subk	3,a0
	JREQ	KHA
	MOVI	FND_PROXCHK,B0
	RETS
KHA
FNBM	MOVI	YKIL_FT2,B0
	RETS

FNBL	;IF NON STOPPING BULLET, KILL FIEND OTHERWISE, PUSH HIM
	MOVE	*A2(OID),A0
	CMPI	CLSPLYR|TYPPLBL|SUBNOSTP,A0
	JRZ	FH0			;BR=KILL FAT
	MOVI	PUSH_FT,B0	;NOW PUSH FATMAN BACK IN DIR BULLET IS TRAVELING
	RETS
FH0	MOVI	YKIL_FT,B0
	RETS

HUPL				;IF HULK HIT RINGS THEN KILL HULK
	MOVB	*A2(OID),A0	;CHECK TO SEE IF HULK IS HITTING RING NOT PLAYER
	subk	3,a0
	JREQ	KH
	MOVE	*A1(OPLINK),A0,L	;IS THIS HULK ALREADY SWINGING?
	MOVE	*A0(IBAT),A0
	JRZ	BPY
	addk	1,a0		;andi	>FF
	sll	32-8,a0		;cmpi	>FF
	JRNZ	NULL
BPY
	MOVI	BAT_PLYR,B0
	RETS
KH	MOVI	KILL_HULKZ,B0
	RETS

HUBD				;KILL HULK, BUT NO POINTS GIVEN!
HUBM				;HULK/TIME BOMB
HUBL	MOVI	KILL_HULK,B0
	RETS


AHPL				;IF AHMED HIT RINGS THEN KILL AHMED
	MOVB	*A2(OID),A0	;CHECK TO SEE IF AHMED IS HITTING RING NOT PLAYER
	subk	3,a0
	JREQ	AKH
	MOVE	*A1(OPLINK),A0,L
	MOVE	*A0(IBAT),A0	;2=FLAMING,1=PUNCHING
	subk	1,a0
	JRZ	NULL
;IF AHMED IS WALKING OR EVEN FLAMING, TURN AND DO PUNCH AT PLYR WHO TOUCHED ME
	MOVI	I_FLM,B0
	RETS

AKH
AHBM	;AHMD/TIME BOMB/RINGS/PLAYER HELPER
	MOVI	KILL_AHMDZ,B0		;WITH RING
	RETS

AHBL	MOVI	KILL_AHMD,B0
	RETS

********************************
* Shawn's enemy type collisons

SLPL	movb	*a1(OID),a0
	cmpi	SUBSHRAP,a0
	jreq	NULL			;Shrapnel?
	subk	SUBMSL,a0
	jreq	slpl5			;Missile?
	movb	*a2(OID),a0		;Player ring
	subk	3,a0
	jrne	NULL
slpl5	movi	slt_ringhit,b0
	rets

SLBL	movb	*a1(OID),a0
	subk	SUBSHRAP,a0
	jreq	NULL			;Shrapnel?
	movi	slt_hit,b0		;Bullet
	rets

SLBB	movb	*a1(OID),a0
	subk	SUBSHRAP,a0
	jreq	NULL			;Shrapnel?
	movi	slt_bbhit,b0		;Blade, bomb
	rets

BLSL	movb	*a2(OID),a0
	subk	SUBMSL,a0
	jrne	BLHU			;!Missile?
	movi	KILL_BULL2,b0
	rets


CRBL	;CRATE/BULLET
	MOVI	KILL_CRT,B0		;SHOOT CRATE
	RETS

CRBM	;CRATE/TIME BOMB
	MOVE	@PCNT,A0
	MOVK	>F,A14
	AND	A14,A0
	JRNZ	NULL
	MOVI	KILL_CRT2,B0		;KILL CRATE DEAD
	RETS

ICPL	;ICON AND PLAYER COLLIDE
	MOVE	*A2(OPLINK),A0,L
	MOVE	*A0(PNUM),A0
	MOVI	P1DATA,A3
	DEC	A0
	JRZ	DB2
	MOVI	P2DATA,A3
DB2	MOVE	*A3(TWPNS),A0
	INC	A0
	MOVE	A0,*A3(TWPNS)
	MOVE	*A1(OID),A0
	ANDI	F_SUBT,A0
	SLL	5,A0
	ADDI	ICONTBL,A0
	MOVE	*A0,A0,L
	MOVE	A0,B0
	RETS

;ICON SUB TYPES
ICONTBL	.LONG	NULL,FIREON,SPRAYON,SPDGON,EXTRA,GRENON,RINGON,NSTPON,KEYON
	.LONG	SHOEON,SMRTON,BMBON,TCSH,HLPON,BMBLTSON,0
	.long	spidegg_touch,bombsmn_touch


********************************
* Orcus

PLFG
	move	@bossd_t-16,a0
	jrnz	NULL
	move	*a2(OID),a0
	cmpi	-CLSENMY|TYPFACE|SUBHD,a0
	jreq	NULL
	cmpi	-CLSENMY|TYPFACE|SUBSHLDL,a0
	jreq	NULL
	cmpi	-CLSENMY|TYPFACE|SUBSHLDR,a0
	jreq	NULL
	cmpi	-CLSENMY|TYPFACE|SUBARML,a0
	jreq	NULL
	cmpi	-CLSENMY|TYPFACE|SUBARMR,a0
	jreq	NULL
	movb	*a1(OID),a0
	subk	3,a0
	jreq	PTK				;Rings on?
	move	*a1(OPLINK),a0,L
	move	*a0(DELYDET),a3
	jrnz	PTK				;Delay on?
	move	*a0(TSO_PTR),a3,L
	move	*a3(OIMG),a3,L
	cmpi	LAND,a3
	jrz	NULL
	move	*a0(DEAD),a3
	jrnz	bncp2				;Dead? Bounce
;	clr	a3
;	move	a3,*a0(DELYDET)	
	movi	KILL_PLYR,b0
	rets

BLFG	movb	*a1(OID),a0			;Get subtype
	subk	4,a0
	jreq	blfg20				;Arc balls?
	move	@bossd_t-16,a0
	jrnz	NULL				;In air?
blfg20	movi	KILL_BULL3,b0
	rets

FGBM
FGBL	movb	*a2(OID),a0			;Get subtype
	subk	4,a0
	jreq	fgbl20				;Arc balls?
	move	@bossd_t-16,a0
	jrnz	NULL
fgbl20	movi	orcus_hit,b0
	rets

********************************
* Akhboob's flying death machine

PLAF
;	move	@bossd_t-16,a0
;	jrnz	NULL
	move	*a2(OID),a0
	cmpi	-CLSENMY|TYPABOSS|SUBABBACK,a0
	jreq	NULL				;Back?
	movb	*a1(OID),a0
	subk	3,a0
	jreq	PTK				;Rings on?
	move	*a1(OPLINK),a0,L
	move	*a0(DELYDET),a3
	jrnz	PTK				;Delay on?
	move	*a0(TSO_PTR),a3,L
	move	*a3(OIMG),a3,L
	cmpi	LAND,a3
	jrz	NULL
	move	*a0(DEAD),a3
	jrnz	bncp2				;Dead? Bounce
	movi	GATE_PLYR,b0
;	movi	KILL_PLYR,b0
	rets

BLAF	movb	*a1(OID),a0			;Get subtype
	subk	4,a0
	jreq	blaf20				;Arc balls?
;	move	@bossd_t-16,a0
;	jrnz	NULL				;In air?
blaf20	movi	KILL_BULL3,b0
	rets

AFBM
AFBL	movb	*a2(OID),a0			;Get subtype
	subk	4,a0
	jreq	fgaf20				;Arc balls?
;	move	@bossd_t-16,a0
;	jrnz	NULL
fgaf20	movi	aboss_hit,b0
	rets

********************************


PLHU
	MOVB	*A1(OID),A0	;CHECK TO SEE IF OID SAYS THIS IS A RING
	subk	3,a0
	JREQ	NULL
	MOVI	KILL_PLYR,B0
	RETS

WOO2	.WORD	>F97E,48,>80CC,0		;"YEAH"
;USA	.WORD	>F97E,48,>80F0,0		;USA
PLFL	;PLAYER/FLAG
	MOVI	WOO2,A0
	CALLA	ONESND
	MOVI	BNC_PLYR,B0	;PLYR/TREE TRUNK/CRATE
	RETS

PLFN	MOVB	*A1(OID),A0	;CHECK TO SEE IF OID SAYS THIS IS A RING
	subk	3,a0
	JREQ	NULL
PLTR	MOVI	BNC_PLYR,B0	;PLYR/TREE TRUNK/CRATE
	RETS
PLJT	MOVI	BNC_PLYR2,B0	;PLYR/JET
	RETS
PLTR2
	MOVI	600,A0
	CALLA	RANDPER
	JRC	NULL
	MOVI	BNC_PLYR,B0	;PLYR/TREE TRUNK/CRATE
	RETS


PLGT	MOVE	*A2(OID),A0
	CMPI	CLSNEUT|TYPGATE|SUBLAY,A0	;WILL BOUNCE OFF OF
	JRZ	PLTR2

	MOVI	BNC_PLYR2,B0	;PLYR/GATE

	MOVE	*A1(OPLINK),A0,L
	MOVE	*A0(DELYDET),A0
	JRNZ	EKRU
	MOVI	GATE_PLYR,B0	;PLYR/GATE
EKRU	RETS
PLBT	;PLYR WITH BOLT
	MOVE	*A1(OPLINK),A0,L
	MOVE	*A0(DELYDET),A0
	JRNZ	EKRU
	MOVI	200,A0		;THROW OUT 80% OF COLLISIONS
	CALLA	RANDPER
	JRNC	EKRU
	MOVI	GATE_PLYR,B0	;PLYR/GATE
	RETS

PLTK	movb	*a1(OID),a0	;Plyr/Big tank base
	subk	3,a0		;Ring?
	jreq	PTK
	MOVE	*A2(OIMG),A0,L
	CMPI	T72TNK2,A0	;DESTROYED TANK
	JREQ	PTK
	MOVE	@BRAM,A0
	INC	A0
	MOVE	A0,@BRAM
	sll	32-2,a0
	JRNZ	PTK
	MOVI	KILL_PLYR,B0
	RETS

PTK	MOVE	@PCNT,A0
	sll	32-4,a0
	jrnz	bncp2
	PUSH	A1
    	CALLA	GETUGH
	PULL	A1
bncp2	MOVI	BNC_PLYR2,B0
	RETS

********************************
* Player hits shawn type

PLSL	movb	*a2(OID),a0
	subk	SUBSM,a0
	jrnz	PLHU			;!Spid mom?
	jruc	PLTK


NULL	clr	b0
	rets


PLMN	;PLYR/LAND MINE/MINE LAYER/FLAME FROM AHMED FLAME THROWER
	MOVB	*A1(OID),A0
;CHECK TO SEE IF OID SAYS THIS IS A RING
	subk	3,a0		;Ring?
	JREQ	NULL
	MOVI	KILL_PLYR,B0
	RETS

HSPL	;HSTG/PLYR
	MOVI	GOT_HSTG,B0
	RETS

BMLM	;BMB/LAND MINE
	MOVI	BMLM2,B0
	RETS

BMGT	;TIME BOMB/GATES
	MOVE	*A2(OID),A0
	CMPI	CLSNEUT|TYPGATE|SUBLAY,A0	;WILL BOUNCE OFF OF
	JRZ	NULL				;MIGHT BE SAND BAGS!
	MOVI	KILL_GATE,B0
	RETS

BLHU	;BULLET/BAD GUYS
;CHECK THIS BULLETS ID AND COMPARE TO NON STOPPING BULLET!
;IF IT IS, DON'T KILL_BULL!
	MOVE	*A1(OID),A0
	CMPI	CLSPLYR|TYPPLBL|SUBNOSTP,A0
	JRNE	OKB
;THIS IS A NON STOPPING BULLET, DO NOT KILL, BUT INC THITS COUNT
;INC BULLET HIT TOTAL FOR THIS PLAYER
	MOVE	*A1(OPLINK),A0,L
	MOVE	*A0(MYPLYR),A0
	MOVI	P1DATA,A3
	DEC	A0
	JRZ	DB3
	MOVI	P2DATA,A3
DB3	MOVE	*A3(THITS),A0
	INC	A0
	MOVE	A0,*A3(THITS)
	CLR	B0
	RETS

OKB
BLFN	;BULLET/FIEND
	MOVI	DEL_BULL,B0
	RETS

BLLY	;BULLET/MINE LAYER/FLAME FROM AHMED
	MOVE	*A2(OID),A0
	BTST	0,A2			;CHECK FOR SUBFLM!
	JRNZ	NULL
	MOVI	DEL_BULL,B0
	RETS

BLGR	;BULLET/JUMPING OUT OF PIT
	MOVE	*A2(OID),A0		;A2=IMG BULLET IS HITTING
	BTST	0,A0
	JRNZ	NULL			;BR=SAND BAGS
	MOVI	KILL_BULLG,B0		;WITH POOF IMAGES
	RETS

BLTR	;BULLET/TREE TRUNK/CRATE
	MOVE	*A2(OID),A0		;A2=IMG BULLET IS HITTING
	BTST	0,A0
	JRNZ	NULL			;BR=SAND BAGS
	MOVI	KILL_BULL,B0		;WITH POOF IMAGES
	RETS

BLTK	;BULLET/TANK
	MOVE	*A2(OID),A0
	BTST	0,A0
	JRNZ	NULL
	MOVI	KILL_BULL2,B0
	RETS




****************************************************************************
*COLLISION ROUTINE
*A1=OBJECT ONE
*A2=OBJECT TWO
*RETURNS: CS= COLLISION, CC= NO COLLISION
*
* CLOBBERS A14
*CREATE TIME SLICE WHILE LOCKING OUT INTERRUPTS

PIXSCAN
	mmtm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13
	mmtm	sp,b0,b1

	move	a1,a10			;A10=*Obj0
	move	a2,a8			;A8=*Obj1
	dint
	move	*a10(OXPOS),a3		;Set up object box TLX,TLY
	move	*a10(OYVAL),a14,L
	movy	a14,a3			;A3=Obj0 Y:X

	move	*a8(OXPOS),a4
	move	*a8(OYVAL),a14,L
	movy	a14,a4			;A4=Obj1 Y:X

	move	*a10(OFLAGS),a6
	move	a6,b0			;B0=flags object 0
	move	*a8(OFLAGS),a6
	move	a6,b1			;B1=flags object 1

	move	*a10(OIMG),a9,L		;A9=*Image 0
	move	*a8(OIMG),a7,L		;A7=*Image 1
	eint

	move	*a9,a5,L		;ISIZE
	move	*a7,a6,L		;ISIZE
	addxy	a3,a5			;A5=Obj0 lower rgt Y:X
	addxy	a4,a6			;A6=Obj1 lower rgt Y:X
	cmpxy	a6,a3			;compare (lrx1,lry1) to (tlx0,tly0)
	JRXGE	CSFAIL
	JRYGE	CSFAIL
	cmpxy	a4,a5			;compare (tlx1,tly1) to (lrx0,lry0)
	JRXLE	CSFAIL
	JRYLE	CSFAIL


*A11=XOFF0
*A12=XOFF1
	move	a3,a2		;>Calc XOFF0,XOFF1,XSCAN
	subxy	a4,a2
	sext	a2
	jrnn	clx1	
	neg	a2
	move	a2,a11		;object 1 to the right
	clr	a12
	move	a4,a13		;rightmost top left
	jruc	clx2

clx1	move	a2,a12		;object 0 to the right
	clr	a11
	move	a3,a13		;rightmost top left
clx2	cmpxy	a5,a6		;find leftmost lower right
	jrxn	clx3
	subxy	a5,a13
	jruc	clx4

clx3	subxy	a6,a13
clx4	sext	a13
	neg	a13		;A13=XSCAN

				;>Calc YOFF0,YOFF1,YSCAN
	sra	16,a3		;Kill X half
	sra	16,a4
	sra	16,a5
	sra	16,a6
	move	a3,a2		;A3=YOFF1
	sub	a4,a2		;A2=YOFF0
	jrnn	cly1	
	neg	a2
	clr	a3		;object 1 to the right
	move	a4,a14		;rightmost top left
	jruc	cly2

cly1	move	a3,a14		;object 0 to the right
	move	a2,a3
	clr	a2
cly2	cmp	a5,a6		;find leftmost lower right
	jrn	cly3
	sub	a5,a14
	jruc	cly4
cly3	sub	a6,a14
cly4	neg	a14		;A14=YSCAN

*A2=YOFF0
*A3=YOFF1
*A4=IMAGE SOURCE ADDRESS TEMP
*A5=WIDTH TEMP
*A7=IMAGE 1 DATA HEADER POINTER
*A8=IMAGE 1 OBJECT POINTER
*A9=IMAGE 0 DATA HEADER POINTER
*A10=IMAGE 0 OBJECT POINTER
*A11=XOFF0
*A12=XOFF1
*A13=XSCAN
*A14=YSCAN

*CALCULATE OBJECT 0 STARTAD, HINC0, VINC0

	move	*a9(ISAG),a4,L	;Get image source address
	move	*a9,a5		;Get ISIZEX
	addk	3,a5		;correct erroneous width (thanx, warren)
	srl	2,A5
	sll	2,A5
	
*CHECK OBJECT 0 FLIPS

	btst	B_FLIPH,b0
	jrnz	CL0HF		;HORIZONTAL FLIP
	btst	B_FLIPV,b0
	jrnz	CL0VF		;VERTICAL FLIP
	
				;NO FLIP CASE
	move	a5,a1		;Get width
	mpyu	a2,a1		;Mult width x yoff
	add	a11,a1		;Add in x offset
	sll	3,a1		;Correct for byte addressing
	add	a1,a4		;A4=STARTAD0=IMAGEAD0+(YOFF0 X W0) + XOFF
	sub	a13,a5		;A5=VINC0=W0-XScan
	sll	3,a5		;Correct for pixel addressing
	movk	8,a2		;A2=HINC0
	jruc	CLOBJ1


CL0HF	BTST	B_FLIPV,B0	;VERT FLIP TOO?
	JRNE	CL0HVF		;HORIZ AND VERT FLIP
				;HORIZONTAL FLIP
	MOVE	A5,A1		;GET WIDTH
	MPYU	A2,A1		;MULT WIDTH X Y OFFSET
	ADD	A5,A1		;ADD IN WIDTH
	SUB	A11,A1		;SUBTRACT X OFFSET
	DEC	A1		;-1 MORE
	SLL	3,A1		;CORRECT FOR BYTE ADDRESSING
	ADD	A1,A4		;A4=STARTAD0=IMAGEAD0+(YOFF0*W0)+W0-XOFF0-1
	MOVI	-8,A2		;A2=HINC0
	ADD	A13,A5		;A5=VINC0=W0+XSCAN
	SLL	3,A5		;CORRECT FOR PIXEL ADDRESSING
	JRUC	CLOBJ1

				;VERTICAL FLIP
CL0VF	MOVE	*A9(ISIZE+>10),A1	;GET HEIGHT
	SUB	A2,A1			;SUBTRACT YOFF0
	DEC	A1
	MPYU	A5,A1		;MULTIPLY BY WIDTH
	ADD	A11,A1		;ADD IN X OFFSET
	SLL	3,A1		;CORRECT FOR PIXEL ADDRESSING
	ADD	A1,A4		;A4=STARTAD0=IMAGEAD0+(H0-YOFF0-1)W0+XOFF0
	NEG	A5		;-W0
	SUB	A13,A5		;-XSCAN
	SLL	3,A5		;A5=VINC0=-W0-XSCAN
	MOVK	8,A2		;A2=HINC0
	JRUC	CLOBJ1

				;VERTICAL AND HORIZONTAL FLIP
CL0HVF	MOVE	*A9(ISIZE+>10),A1	;GET HEIGHT
	SUB	A2,A1			;SUBTRACT YOFF0
	DEC	A1
	MPYU	A5,A1		;MULTIPLY BY WIDTH
	ADD	A5,A1		;ADD IN WIDTH (W0)
	SUB	A11,A1		;SUBTRACT XOFF0
	DEC	A1
	SLL	3,A1		;CORRECT FOR PIXEL ADDRESSING
	ADD	A1,A4		;A4=STARTAD0=(H0-YOFF0-1)W0+W0-XOFF0-1
	NEG	A5		;-W0
	ADD	A13,A5		;+XSCAN
	SLL	3,A5		;A5=VINC0=-W0-XSCAN
	MOVI	-8,A2		;A2=HINC0


*CALCULATE OBJECT 1 STARTAD, HJUMP, VJUMP		

*A2=HINC0
*A3=YOFF1, HINC1
*A4=STARTAD0
*A5=VINC0
*A6=STARTAD1
*A7=IMAGE 1 DATA HEADER POINTER
*A8=IMAGE 1 OBJECT POINTER
*A9=IMAGE 0 DATA HEADER POINTER
*A10=IMAGE 0 OBJECT POINTER
*A11=W1, VINC1
*A12=XOFF1
*A13=XSCAN
*A14=YSCAN

CLOBJ1	move	*a7(ISAG),a6,L	;Get image source address
	move	*a7,a11		;Get ISIZEX
	addk	3,a11		;correct erroneous width (thanx, warren)
	srl	2,A11
	sll	2,A11
	
	BTST	B_FLIPH,B1	;CHECK OBJECT 1 FLIPS
	JRNE	CL1HF		;HORIZONTAL FLIP
	BTST	B_FLIPV,B1
	JRNE	CL1VF		;VERTICAL FLIP
	
*NO FLIP CASE
*A3=HINC1=8 (BYTE AT A TIME)
*A11=VINC1=W1-XSCAN
*A6=STARTAD1=IMAGEAD1+(YOFF1 X W1) + XOFF1

	MOVE	A11,A1		;GET WIDTH
	MPYU	A3,A1		;MULT WIDTH X YOFF
	ADD	A12,A1		;ADD IN X OFFSET
	SLL	3,A1		;CORRECT FOR BYTE ADDRESSING
	ADD	A1,A6		;ADD TO SOURCE ADDRESS
	MOVK	8,A3		;HINC1
	SUB	A13,A11		;VINC1=W1-XSCAN
	SLL	3,A11		;CORRECT FOR PIXEL ADDRESSING
	JRUC	CSH

*HORIZONTAL FLIP
*A3=HINC1=-8
*A11=VINC1=W1+XSCAN
*A6=STARTAD1=IMAGEAD1+(YOFF1 X W1) + W1-XOFF1-1
CL1HF	BTST	B_FLIPV,B1	;VERT FLIP TOO?
	JRNE	CL1HVF		;HORIZ AND VERT FLIP
	MOVE	A11,A1		;GET WIDTH
	MPYU	A3,A1		;MULT WIDTH X Y OFFSET
	ADD	A11,A1		;ADD IN WIDTH
	SUB	A12,A1		;SUBTRACT X OFFSET
	DEC	A1		;-1 MORE
	SLL	3,A1		;CORRECT FOR BYTE ADDRESSING
	ADD	A1,A6
	MOVI	-8,A3		;HINC1
	ADD	A13,A11		;VINC1=W1+XSCAN
	SLL	3,A11		;CORRECT FOR PIXEL ADDRESSING
	JRUC	CSH

*VERTICAL FLIP
*A3=HINC1=8
*A11=VINC1=-W1-XSCAN
*A6=STARTAD1=IMAGEAD1+(H1-YOFF1-1)W1+XOFF1
CL1VF	MOVE	*A7(ISIZE+>10),A1	;GET HEIGHT
	SUB	A3,A1			;SUBTRACT YOFF1
	DEC	A1
	MPYU	A11,A1		;MULTIPLY BY WIDTH
	ADD	A12,A1		;ADD IN X OFFSET
	SLL	3,A1		;CORRECT FOR PIXEL ADDRESSING
	ADD	A1,A6		;ADD TO SOURCE ADDRESS
	NEG	A11		;-W1
	SUB	A13,A11		;-XSCAN
	SLL	3,A11		;CORRECT FOR PIXEL ADDRESSING
	MOVK	8,A3		;HINC1
	JRUC	CSH

*VERTICAL AND HORIZONTAL FLIP
*A3=HINC1=-8
*A11=VINC1=-W1-XSCAN
*A6=STARTAD1=(H1-YOFF1-1)W1+W1-XOFF1-1
CL1HVF	MOVE	*A7(ISIZE+>10),A1	;GET HEIGHT
	SUB	A3,A1			;SUBTRACT YOFF1
	DEC	A1
	MPYU	A11,A1		;MULTIPLY BY WIDTH
	ADD	A11,A1		;ADD IN WIDTH (W1)
	SUB	A12,A1		;SUBTRACT XOFF1
	DEC	A1
	SLL	3,A1		;CORRECT FOR PIXEL ADDRESSING
	ADD	A1,A6		;ADD TO SOURCE ADDRESS
	NEG	A11		;-W1
	ADD	A13,A11		;+XSCAN
	SLL	3,A11		;CORRECT FOR PIXEL ADDRESSING
	MOVI	-8,A3		;HINC1

*A1= WIDTH COUNTER XSCAN
*A2=H INCREMENT IMAGE 0
*A3=H INCREMENT IMAGE 1
*A4=INDEX TO IMAGE 0
*A5=V INCREMENT IMAGE 0
*A6=INDEX TO IMAGE 1
*A7=IMAGE 1 DATA HEADER POINTER
*A8=IMAGE 1 OBJECT POINTER
*A9=IMAGE 0 DATA HEADER POINTER
*A10=IMAGE 0 OBJECT POINTER
*A11=V INCREMENT IMAGE 1
*A13=WIDTH COUNT XSCAN
*A14=HEIGHT COUNT YSCAN

CSH	cmpi	>80,a14		;no scan if xscan, yscan values out of range
	jrhs	CSFAIL
	cmpi	>80,a13
	jrhs	CSFAIL

	dint
	move	@INTENB,a0
	andni	X1E,a0
	move	a0,@INTENB
	eint

csh0	move	@DMACTRL,a0
	jrn	csh0		;DMA busy?

	.if	YUNIT
	setf	6,0,0		;6 bit field
	.else
	setf	8,0,0		;8 bit field
	.endif

csh1	move	a13,a1		;load line countdown horiz counter

cshl	move	*a4,a0		;Check image 0 corresponding non zeroes
	jrz	csnxh		;No hit?

	move	*a6,a0		;check image 1
	jrnz	pshit		;Hit?

csnxh	add	a2,a4		;Add horiz increments
	add	a3,a6
	dsjs	a1,cshl		;Loop horizontal

	add	a5,a4		;Add vert increments
	add	a11,a6
	dsjs	a14,csh1	;Loop vert

	setf	16,1,0		;Normal field

CSFAIL	move	b13,b13
	jrz	psnodma		;Skip DMA restart?
	dint
	move	@INTENB,a0
	ori	X1E,a0
	move	a0,@INTENB
	eint
psnodma	clrc			;No hit
	jruc	psx		;Exit


pshit	setf	16,1,0		;Normal field
	move	b13,b13
	jrz	csflags		;Skip DMA restart?
	dint
	move	@INTENB,a0
	ori	X1E,a0
	move	a0,@INTENB
	eint
csflags	setc			;Hit

psx	mmfm	sp,b0,b1
	mmfm	sp,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13
	rets


********************************
*PLAYER HAS BEEN COLLIDED WITH
*TELL THIS COLLISION CHECK THAT PLAYER IS REALLY SHORTER THAN HE IS
*THEN RETURN CARRY SET IF STILL A HIT, CARRY CLEAR IF THIS SHOULD NOT BE
*A COLLISION.
*A0=OBJECT THAT HIT PLAYER
*A8=PLAYER LEGS IMAGE PTR

SHORT_PLYR
	MOVE	*A8(OYPOS),A7		;A7 - OBJ1 Ymin
	ADDK	3,A7			;ADDI 0
	MOVE	*A0(OID),A11
	zext	a11
;	CMPI	CLSENMY|TYPORB,A11
;	JRNE	SP0
;	SUBK	5,A7
;	MOVE	*A8(OSIZEY),A11,W	;A11 - OBJ1 Ymax
;	SUBK	8,A11			;MAKE LEGS SHORTER IN LENGTH!
;	JRUC	SP2
;SP0
	CMPI	CLSNEUT|TYPMINE,A11
	JRNE	SP1
	ADDK	12,A7			;15
	MOVE	*A8(OSIZEY),A11		;A11 - OBJ1 Ymax
	SUBK	19,A11			;MAKE LEGS SHORTER IN LENGTH! ;21
	JRUC	SP2
SP1
	move	*A8(OSIZEY),A11		;A11 - OBJ1 Ymax
	SUBK	20,A11	 ;19		;SUBI 13 16 ;MAKE LEGS SHORTER IN LENGTH!
SP2	add	A7,A11
	move	*A0(OYPOS),A6		;CHECK OBJS A0,A8 for intersection
	cmp	A11,A6
	jrgt	CLRCR			;Y2Min > Y1Max
	move	*A0(OSIZEY),A11
	add	A11,A6
	cmp	A7,A6
	jrlt	CLRCR			;Y2Max < Y1Min

;NOW X CHECK

	move	*A8(OXPOS),A7		;A9 - OBJ1 Xmin
	addk	6,a7
	move	*A8(OSIZEX),A11		;A10 - OBJ1 Xmax
	subk	6,a11
	add	A7,A11
	move	*A0(OXPOS),A6		;USE SIGNED COMPARES BECAUSE OBJS MAY LIE ON ZERO
	cmp	A11,A6
	jrgt	CLRCR			;X2Min > X1Max
	move	*A0(OSIZEX),A11
	add	A11,A6
	cmp	A7,A6
	jrlt	CLRCR			;X2Max < X1Min

	move	@PCNT,a6
	btst	0,a6
	JRZ	CLRCR
	SETC				;GOT A BOX INTERSECTION
	RETS
CLRCR	CLRC
	RETS




	.END


