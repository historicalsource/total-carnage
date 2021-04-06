	.FILE	'TRIG.ASM'
	.TITLE	'TOTAL CARNAGE GAME PROGRAM'
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

	.INCLUDE	"DISP.EQU"		;DISPLAY PROC. EQUATES
	.include	"\video\sys\sys.inc"
	.include	"mproc.equ"
	.include	"game.equ"
	.include	"shawn.hdr"		;My macros
	.include	"audit.equ"

	.DEF	GETSIN,GETCOS
	.DEF	XYSEEK2,XYSEEK2A

	.DEF	animscnt

	.REF	FRANIMQ,ERASE_TXT,GET_ADJ,RNDRNG0,prt0_xy,GETFPAL,RNDRNG

HALFPI	.set	102944
PI		.set	205887
X3HALFPI	.set	308831
X2PI	.set	411775


	.text


********************************
* Run an animation script (Process)


	.bss	animscnt	,16	;# anim scripts running

	APTRPD	animslobj_p	,0	;*Last obj created
	LONGPD	animsv		,2	;Temp value
	WORDPD	animsbx		,4	;Base X
	WORDPD	animsby		,5	;Base Y
	WORDPD	animsfnum	,6	;# FRANIMs running
	APTRPD	animslp_p	,7	;*Loop point table pos
	APTRPD	animslp_t	,9	;(*Loop point, Loop cnt)*5


 SUBR	anim_script		;A8=*Script

	clr	a9

 SUBRP	anim_script2		;A8=*Script, A9=Base Y:X

	move	a9,*a13(animsbx),L	;Save XY

	move	*a13(PROCID),a11
	subi	ANIMPID,a11
	srl	8,a11
	sll	8,a11			;A11=ID offset (0->300)

	clr	a1
	move	a1,*a13(animsfnum)
	move	a13,a1
	addi	animslp_t,a1
	move	a1,*a13(animslp_p),L

anslp	move	*a8+,a1			;Get command

	addi	anims_t,a1
	move	*a1,a1,L
	jump	a1

	.long	asEND
anims_t	.long	asNEW,asDEL,asDELM,asFRA
	.long	asANI,asHIDE,asSHOW,asPAL
	.long	asXY,asXYRNG,asYA,asXYV
	.long	asXYVA,asXYV0,asZ,asBXY
	.long	asSLP,asSLP1,asSLPR
	.long	asWAIT,asTXT
	.long	asTXTR,asTXTK,asLAB,asLABR
	.long	asDSJ,asDSJS1,asJMP,asJMPR,asJMPEQ
	.long	asJMPNE,asRUN,asRUNI,asCRE
	.long	asKIL,asASM,asSND,asSNDD
	.long	asADDW
	.long	asADDWO,asADDLO,asADLVO,asSVRL
	.long	asSVRLT,asSVL


asNEW					;>New objects
	move	*a8+,a9,L		;Get data
	PUSH	a8
ans100	move	*a9+,a2,L		;*Image
	move	*a9+,a0,L		;Get XY
	move	*a13(animsbx),a3,L
	addxy	a3,a0			;Add base
	clr	a1
	movy	a0,a1
	sll	16,a0
	move	*a9+,a3			;Z
	move	*a9+,a4			;Flags
	addi	M_NOCOLL,a4
	move	*a9+,a5			;ID
	addi	CLSANIM,a5
	add	a11,a5			;+offset
	clr	a6
	clr	a7
	calla	BEGINOBJ
	move	*a9,a0
	cmpi	-1000,a0
	jrne	ans100			;End?
	move	a8,*a13(animslobj_p),L	;Save * to last one
	PULL	a8
	jruc	anslp

asFRA					;>FRANIM
	move	a11,a6			;Save a11
	move	*a8+,a9,L		;Get data
	move	*a13(PROCID),a1		;Inherit same ID+1
	addk	1,a1
	move	*a8+,a10		;OID
	jrn	ans250			;No ID?
	addi	CLSANIM,a10
	add	a11,a10			;+offset
	move	*a8+,a11		;#Loops
	jrn	ans220
	move	*a13(animsfnum),a2	;+1 FRANIM cnt
	addk	1,a2
	move	a2,*a13(animsfnum)
ans220	movi	anims_franim,a7
	calla	GETPRC
	move	a13,*a0(anfc_p),L
	move	a6,a11
	jruc	anslp

ans250	addk	16,a8			;Skip #loops
	move	a8,a10
	move	*a13(animslobj_p),a8,L	;Get * to last one
	movi	FRQDELDIE,a7
	calla	GETPRC
	move	a10,a8
	jruc	anslp


asSLP					;>SLEEP
	move	*a8+,a0			;Get time
	calla	PRCSLP
	jruc	anslp

asSLP1					;>SLEEP 1
	movk	1,a0
	calla	PRCSLP
	jruc	anslp

asSLPR					;>Sleep random
	move	*a8+,a0			;Get time
	move	*a8+,a1
	calla	RNDRNG
	calla	PRCSLP
	jruc	anslp

asWAIT					;>Wait on FRANIMs
	SLEEPK	2
	move	*a13(animsfnum),a1
	jrnz	asWAIT
	jruc	anslp

asXY					;>New XY rel to current pos
	move	*a8+,a1			;Get ID
	move	*a8+,a2
	move	*a8+,a4
	move	*a8+,a5
asxyhs					;Entry for HIDE/SHOW
asxyr	addi	CLSANIM,a1
	add	a11,a1			;+offset
	move	@OBJLST,a0,L
ans720	callr	obj_find
	jrz	anslp
	move	*a0(OXPOS),a6		;New X
	add	a4,a6
	move	a6,*a0(OXPOS)
	move	*a0(OYPOS),a6		;New Y
	add	a5,a6
	move	a6,*a0(OYPOS)
	move	*a0,a0,L
	jrnz	ans720
	jruc	anslp

asXYRNG					;>New XY rel to current pos in rndrng
	move	*a8+,a0
	move	*a8+,a1
	calla	RNDRNG
	move	a0,a4
	move	*a8+,a0
	move	*a8+,a1
	calla	RNDRNG
	move	a0,a5
	move	*a8+,a1
	jrn	asxyr5			;No ID?
	move	*a8+,a2
	jruc	asxyr

asxyr5	addk	16,a8			;Skip mask
	move	*a13(animslobj_p),a0,L	;Get * to last one
	move	*a0(OXPOS),a6		;New X
	add	a4,a6
	move	a6,*a0(OXPOS)
	move	*a0(OYPOS),a6		;New Y
	add	a5,a6
	move	a6,*a0(OYPOS)
	jruc	anslp

asYA					;>Set Y ani pt world relative
	move	*a8+,a1
	move	*a8+,a2			;Mask
	move	*a8+,a5			;
	sll	16,a5
	move	@WORLDTLY,a0,L
	add	a0,a5
	addi	CLSANIM,a1
	add	a11,a1			;+offset
	move	@OBJLST,a0,L
asya10	callr	obj_find
	jrz	asya90

	PUSH	a1,a2
	move	*a0(OIMG),a1,L
	move	*a0(OSIZE),a2,L
	move	*a0(OFLAGS),a4
	calla	GANIOF
	move	*a0(OXVAL),a3,L
	add	a6,a3			;Old X
	move	a5,a2			;New Y
	calla	GANISAG
	PULL	a1,a2

	move	*a0,a0,L
	jrnz	asya10
asya90	jruc	anslp

asXYV					;>Set XYVel
	move	*a8+,a4,L
	move	*a8+,a5,L
	move	*a8+,a1
	move	*a8+,a2
	addi	CLSANIM,a1
	add	a11,a1			;+offset
	move	@OBJLST,a0,L
ans920	callr	obj_find
	jrz	anslp
	move	*a0(OXVEL),a6,L
	add	a4,a6
	move	a6,*a0(OXVEL),L
	move	*a0(OYVEL),a6,L
	add	a5,a6
	move	a6,*a0(OYVEL),L
	move	*a0,a0,L
	jrnz	ans920
	jruc	anslp

asXYVA					;>Set XYVel absolute
	move	*a8+,a4,L
	move	*a8+,a5,L
	move	*a8+,a1
	move	*a8+,a2
	addi	CLSANIM,a1
	add	a11,a1			;+offset
	move	@OBJLST,a0,L
ans1020	callr	obj_find
	jrz	anslp
	move	a4,*a0(OXVEL),L
	move	a5,*a0(OYVEL),L
	move	*a0,a0,L
	jrnz	ans1020
	jruc	anslp

asXYV0					;>XYVel = 0
	move	*a13(animslobj_p),a0,L	;Get * to last one
	clr	a1
	move	a1,*a0(OXVEL),L
	move	a1,*a0(OYVEL),L
	jruc	anslp

asZ					;>Set Z pos
	move	*a8+,a1
	move	*a8+,a2
	move	*a8+,a4
	addi	CLSANIM,a1
	add	a11,a1			;+offset
	move	@OBJLST,a0,L
ans1120	callr	obj_find
	jrz	anslp
	move	a4,*a0(OZPOS)
	move	*a0,a0,L
	jrnz	ans1120
	jruc	anslp

asLAB					;>Set label
	move	*a8+,a0
anslab	move	*a13(animslp_p),a2,L
	move	a8,*a2+,L		;Save *
	move	a0,*a2+
	move	a2,*a13(animslp_p)
	jruc	anslp

asLABR					;>Set label randomly
	move	*a8+,a0
	move	*a8+,a1
	calla	RNDRNG
	jruc	anslab

asDSJS1					;>Sleep 1, dec and loop to label
	SLEEPK	1

asDSJ					;>Decrement and loop to label
	move	*a13(animslp_p),a1,L
	move	-*a1,a2
	subk	1,a2
	move	a2,*a1
	jrz	ans1330
	move	-*a1,a8,L		;Get *Loop
	jruc	anslp
ans1330	subk	32,a1			;Del loop entry
	move	a1,*a13(animslp_p),L
	jruc	anslp

asPAL					;>Set palette
	move	*a13(animsv),a0,L	;Get *Pal
	calla	GETFPAL
	move	a0,a4
	move	*a8+,a1
	jrn	ans1450
	addi	CLSANIM,a1
	add	a11,a1			;+offset
	move	@OBJLST,a0,L
	clr	a2			;No mask
ans1420	callr	obj_find
	jrz	anslp
	move	a4,*a0(OPAL)
	move	*a0,a0,L
	jrnz	ans1420			;More?
	jruc	anslp

ans1450	move	*a13(animslobj_p),a0,L	;Get * to last obj
	move	a4,*a0(OPAL)
	jruc	anslp

asANI					;>Do ANI on OID
	move	*a8+,a5,L
	move	*a8+,a1			;OID
	addi	CLSANIM,a1
	add	a11,a1			;+offset
	move	@OBJLST,a0,L
	clr	a2			;No mask
ans1620	callr	obj_find
	jrz	anslp
	move	a8,a9
	move	a1,a3
	move	a5,a1			;*Img
	move	a0,a8			;*Obj
	move	*a8(OFLAGS),a4		;Same flags
	calla	ANI
	move	a3,a1
	move	a8,a0
	move	a9,a8
	move	*a0,a0,L
	jrnz	ans1620			;More?
	jruc	anslp

asDEL					;>Delete obj
	move	*a8+,a0
	clr	a1
asdel5	addi	CLSANIM,a0
	add	a11,a0			;+offset
	calla	KILOBJN
	jruc	anslp

asDELM					;>Delete obj with mask
	move	*a8+,a0
	move	*a8+,a1
	jruc	asdel5

asRUN					;>Run a new anim script
	move	*a8+,a0,L
	move	*a13(PROCID),a1		;Inherit same ID
asrun5	move	a8,a10
	move	a0,a8			;*Script
	move	*a13(animsbx),a9,L	;Get base XY
	movi	anim_script2,a7
	calla	GETPRC
	move	a10,a8
	jruc	anslp

asRUNI					;>Run a new anim script with ID
	move	*a8+,a0,L
	move	*a8+,a1
	addi	ANIMPID,a1
	add	a11,a1			;+offset
	jruc	asrun5

asCRE					;>Create a process
	move	*a8+,a7,L
	move	*a8+,a9,L		;Pass A9 to process
	movi	ANIMPID+>ff,a1
	add	a11,a1			;+offset
	calla	GETPRC
	jruc	anslp

asKIL					;>Kill processes with mask
	move	*a8+,a0
	addi	ANIMPID,a0
	add	a11,a0			;+offset
	move	*a8+,a1
	calla	KILALLN
	jruc	anslp

asJMP					;>Jump to new location
	move	*a8+,a8,L
	jruc	anslp

asJMPR					;>Jump to new location if RND<#
	move	*a8+,a4,L
	movi	999,a0			;.1 % resolution
	calla	RNDRNG0
	move	*a8+,a1
	cmp	a1,a0
	jrhs	anslp
	move	a4,a8			;Do jmp
	jruc	anslp

asJMPEQ					;>Jump to new location if = to mem
	move	*a8+,a0,L
	move	*a0,a0			;Get value
	move	*a8+,a2,L
	move	*a8+,a1
	cmp	a1,a0
	jrne	anslp			;Not same?
	move	a2,a8			;Do jmp
	jruc	anslp

asJMPNE					;>Jump to new location if != to mem
	move	*a8+,a0,L
	move	*a0,a0			;Get value
	move	*a8+,a2,L
	move	*a8+,a1
	cmp	a1,a0
	jreq	anslp			;Same?
	move	a2,a8			;Do jmp
	jruc	anslp

asSNDD					;>Do a snd call in demo
	movk	ADJMUSIC,a0		;Get demo music ON/OFF
	calla	GET_ADJ
	jrz	asSND			;Do sounds?
	addk	32,a8
	jruc	anslp
asSND					;>Do a snd call
	move	*a8+,a0,L
	calla	ONESND
	jruc	anslp

asASM					;>Inline code
	exgpc	a8
	jruc	anslp

asHIDE					;>Hide an OID (X+5000)
	movi	5000,a4
ashide2	move	*a8+,a1
	clr	a2
	clr	a5
	jruc	asxyhs

asSHOW					;>Show an OID (X-5000)
	movi	-5000,a4
	jruc	ashide2

asADDW					;>Add WORD to mem
	move	*a8+,a0,L
	move	*a8+,a1
	move	*a0,a2
	add	a1,a2
	move	a2,*a0
	jruc	anslp

asADDWO					;>Add WORD to last obj+offset
	move	*a8+,a0
	move	*a13(animslobj_p),a1,L	;Get * to last one
	move	*a8+,a2			;Offset
	add	a2,a1
	move	*a1,a2
	add	a0,a2
	move	a2,*a1
	jruc	anslp

asADDLO					;>Add LONG # to last obj+offset
	move	*a8+,a0,L
	move	*a13(animslobj_p),a1,L	;Get * to last one
	move	*a8+,a2			;Offset
	add	a2,a1
	move	*a1,a2,L
	add	a0,a2
	move	a2,*a1,L
	jruc	anslp

asADLVO					;>Add LONG value to last obj+offset
	move	*a8+,a0
	move	*a13(animslobj_p),a1,L	;Get * to last one
	add	a0,a1			;+Offset
	move	*a13(animsv),a0,L	;Get value
	move	*a1,a2,L
	add	a0,a2
	move	a2,*a1,L
	jruc	anslp

asSVRL					;>Set value to rnd long
	move	*a8+,a0,L
	move	*a8+,a1,L
	calla	RNDRNG
	move	a0,*a13(animsv),L
	jruc	anslp

asSVRLT					;>Set value to rnd long from a table
	move	*a8+,a4,L
	move	*a4+,a0			;#Table entries
	subk	1,a0
	calla	RNDRNG0
	sll	5,a0			;*32
	add	a0,a4
	move	*a4,a0,L
	move	a0,*a13(animsv),L
	jruc	anslp

asSVL					;>Set value to long
	move	*a8+,a0,L
	move	a0,*a13(animsv),L
	jruc	anslp

asBXY					;>Add # to BaseXY
	move	*a8+,a0,L
	move	*a13(animsbx),a1,L
	addxy	a0,a1
	move	a1,*a13(animsbx),L
	jruc	anslp

asTXTR					;>Print rnd text from table
	move	*a8+,a4,L
	move	*a4+,a0			;#Table entries
	subk	1,a0
	calla	RNDRNG0
	sll	5,a0			;*32
	add	a0,a4
	move	*a4,a0,L
	jruc	astxt5

asTXT					;>Print text
	move	*a8+,a0,L
astxt5	calla	prt0_xy
	jruc	anslp


asTXTK					;>Kill text
	PUSHP	a8
	calla	ERASE_TXT
;	movk	4,a11			;Save A11!
;	JSRP	text_shrink		;Sleeps
	PULLP	a8
	jruc	anslp


asEND	SLEEPK	1			;>Wait on FRANIMs before exit
	move	*a13(animsfnum),a1
	jrnz	asEND
	DIE



********************************
* Animation of a part (Process)

	APTRPD	anfc_p,0	;*AnimScrpt process that made me, set by AS
	APTRPD	anfl,2		;*Franim list


 SUBRP	anims_franim		;A9=*FRAN list, A10=OID, A11=# Loops

	move	@OBJLST,a8,L		;>Find object
anf100	move	*a8(OID),a0
	cmp	a10,a0
	jreq	anf300
	move	*a8,a8,L
	jrnz	anf100
	jruc	anf700			;No match!

anf300	move	a9,*a13(anfl),L
anf340	JSRP	FRANIMQ
	move	*a13(anfl),a9,L		;Go to 1st
	move	a11,a11
	jrn	anf340			;-=Infinite
	dsj	a11,anf340

anf700	move	a11,a11
	jrn	anf800
	move	*a13(anfc_p),a0,L	;Get *Creator
	move	*a0(animsfnum),a2	;#Frans-1
	subk	1,a2
	move	a2,*a0(animsfnum)
anf800	DIE



********************************
* Wait for animation processes to finish

 SUBR	anim_wait

anw10	SLEEPK	3
	move	@animscnt,a1
	jrgt	anw10
	RETP

********************************
* Wait 50 and kill anim stuff (Process)

 SUBR	anim_kilslp

	SLEEP	50
	callr	anim_killall
	DIE


********************************
* Kill all animation processes and objects

 SUBR	anim_killall

	clr	a0
	move	a0,@animscnt

	movi	ANIMPID,a0	;>Kill processes
	movi	>3ff,a1
	calla	KILALLN

	movi	CLSANIM,a0	;>Delete objs
	movi	>3ff,a1
	jauc	KILOBJN



********************************
* Find an object by OID

 SUBRP	obj_find		;A0=*1st obj, A1=OID, A2=!Mask, A3=Trashed

	andn	a2,a1
of20	move	*a0(OID),a3
	andn	a2,a3		;Remove bits
	cmp	a1,a3
	jreq	of50
	move	*a0,a0,L
	jrnz	of20
of50	move	a0,a0		;A0=*Obj or 0
	rets			;Pass CC







;SEEK X-Y COORDINATE
;A8=OBJECT SEEKING
;A5=X COORD TO SEEK
;A6=Y COORD TO SEEK
;A7=MULTIPLIER OF VELOCITY

;RETURNS
;A5=X VEL
;A6=Y VEL
;
;NABBED FROM EUGENE JARVIS FOOTBALL CODE
;
XYSEEK2
	MOVE	*A8(OXPOS),A3,0
	MOVE	*A8(OYPOS),A4,0
XYSEEK2A
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
;	MOVI	60H,A5		;MULTIPLY BY VELOCITY FACTOR
	MOVE	A7,A5
	MPYS	A5,A3
	MPYS	A1,A5		;FINAL X VEL
	SRA	4,A3
	SRA	4,A5
	MOVE	A3,A6		;FINAL Y VEL
	RETS

******************************************************************
GETSIN:
; PARMS   - A0 = theta in s15.16
; RETURNS - A0 = sin(theta) in s15.16
;return	A14 = theta normalized to range of 0 to 2Pi

	mmtm	SP,A2

;long int getsin (theta)
;long int theta;
;{
;int indx;
;long int retval;

;while (theta < 0) theta += X2PI;
TRIGLP1:
	move	A0,A0
	jrnn	TRIGSK1
	addi	X2PI,A0,L
	jruc	TRIGLP1
TRIGSK1:
;while (theta > X2PI) theta -= X2PI;
TRIGLP2:
	cmpi	X2PI,A0,L
	jrn	TRIGSK2
	subi	X2PI,A0,L
	jruc TRIGLP2
TRIGSK2:
	move	A0,A14			;A14 theta normalized

;if (theta < HALFPI) {
;	indx = ((theta+5) >> 9);
;	retval = sintbl[indx];
;	}
	cmpi	HALFPI,A0,L
	jrnn	TRIGSK3
	move	A0,A2
	addk	5,A2
	sra	9,A2
	sla	5,A2
	addi	SINTBL,A2,L
	move	*A2,A0,1
	mmfm	SP,A2
	rets
TRIGSK3:

;else if (theta <= PI) {
;	indx = (((PI - theta)+5) >> 9);
;	retval = sintbl[indx];
;	}
	cmpi	PI,A0,L
	jrp	TRIGSK4
	movi	PI,A2,L
	sub	A0,A2
	addk	5,A2
	sra	9,A2
	sla	5,A2
	addi	SINTBL,A2,L
	move	*A2,A0,1
	mmfm	SP,A2
	rets
TRIGSK4:

;else if (theta < X3HALFPI) {
;	indx = (((theta - PI) + 5) >> 9);
;	retval = sintbl[indx];
;	retval = -retval;
;	}
	cmpi	X3HALFPI,A0,L
	jrnn	TRIGSK5
	move	A0,A2
	subi	PI,A2,L
	addk	5,A2
	sra	9,A2
	sla	5,A2
	addi	SINTBL,A2,L
	move	*A2,A0,1
	neg	A0
	mmfm	SP,A2
	rets
TRIGSK5:

;else {
;	indx = (((X2PI - theta) + 5) >> 9);
;	retval = sintbl[indx];
;	retval = -retval;
;	}
	movi	X2PI,A2,L
	sub	A0,A2
	addk	5,A2
	sra 9,A2
	sla	5,A2
	addi	SINTBL,A2,L
	move	*A2,A0,1
	neg	A0
	mmfm	SP,A2
	rets

******************************************************************


	.text
******************************************************************
GETCOS:
; PARMS   - A0 = theta in s15.16
; RETURNS - A0 = cos(theta) in s15.16

	mmtm	SP,A2

;long int getcos (theta)
;long int theta;
;{
;int indx;
;long int retval;

;while (theta < 0) theta += X2PI;
TRIGLP3:
	move	A0,A0
	jrnn	TRIGSK6
	addi	X2PI,A0,L
	jruc	TRIGLP3
TRIGSK6:
;while (theta > X2PI) theta -= X2PI;
TRIGLP4:
	cmpi	X2PI,A0,L
	jrn	TRIGSK7
	subi	X2PI,A0,L
	jruc TRIGLP4
TRIGSK7:
	move	A0,A14			;A14 theta normalized

;if (theta < HALFPI) {
;	indx = (((HALFPI - theta) + 5) >> 9);
;	retval = sintbl[indx];
;	}
	cmpi	HALFPI,A0,L
	jrnn	TRIGSK8
	movi	HALFPI,A2,L
	sub	A0,A2
	addk	5,A2
	sra	9,A2
	sla	5,A2
	addi	SINTBL,A2,L
	move	*A2,A0,1
	mmfm	SP,A2
	rets
TRIGSK8:


;else if (theta <= PI) {
;	indx = (((theta - HALFPI) + 5) >> 9);
;	retval = sintbl[indx];
;	retval = -retval;
;	}
	cmpi	PI,A0,L
	jrp	TRIGSK9
	move	A0,A2
	subi	HALFPI,A2,L
	addk	5,A2
	sra	9,A2
	sla	5,A2
	addi	SINTBL,A2,l
	move	*A2,A0,1
	neg	A0
	mmfm	SP,A2
	rets
TRIGSK9:



;else if (theta < X3HALFPI) {
;	indx = (((X3HALFPI - theta) + 5) >> 9);
;	retval = sintbl[indx];
;	retval = -retval;
;	}
;else if (theta < X3HALFPI) {
;	indx = (((theta - PI) + 5) >> 9);
;	retval = sintbl[indx];
;	retval = -retval;
;	}
	cmpi	X3HALFPI,A0,L
	jrnn	TRIGSK10
	movi	X3HALFPI,A2,L
	sub	A0,A2
	addk	5,A2
	sra	9,A2
	sla	5,A2
	addi	SINTBL,A2,L
	move	*A2,A0,1
	neg	A0
	mmfm	SP,A2
	rets
TRIGSK10:



;else {
;	indx = (((theta - X3HALFPI) + 5) >> 9);
;	retval = sintbl[indx];
;	}
	move	A0,A2
	subi	X3HALFPI,A2,L
	addk	5,A2
	sra 9,A2
	sla	5,A2
	addi	SINTBL,A2,L
	move	*A2,A0,1
	mmfm	SP,A2
	rets

*****************************************************************


;/* Table of sin from 0 through PI/2 Radians in 2**-7 increments */
	.data
	.even
SINTBL:
	.int	0,511,1023,1535,2047,2559,3070,3582
	.int	4093,4604,5114,5625,6135,6644,7153,7662
	.int	8170,8678,9185,9692,10198,10703,11208,11712
	.int	12216,12718,13220,13721,14221,14721,15219,15717
	.int	16213,16709,17204,17697,18189,18681,19171,19660
	.int	20148,20634,21120,21604,22086,22568,23048,23526
	.int	24004,24479,24953,25426,25897,26367,26835,27301
	.int	27766,28228,28690,29149,29607,30063,30517,30969
	.int	31419,31867,32314,32758,33201,33641,34080,34516
	.int	34950,35382,35812,36240,36665,37088,37509,37928
	.int	38344,38758,39170,39579,39986,40391,40793,41192
	.int	41589,41984,42375,42765,43151,43535,43917,44295
	.int	44671,45045,45415,45783,46148,46510,46869,47226
	.int	47579,47930,48278,48622,48964,49303,49639,49972
	.int	50301,50628,50951,51272,51589,51903,52214,52522
	.int	52827,53128,53426,53721,54013,54301,54586,54868
	.int	55146,55421,55693,55961,56226,56487,56745,56999
	.int	57250,57498,57741,57982,58219,58452,58682,58908
	.int	59131,59349,59565,59776,59985,60189,60390,60587
	.int	60780,60970,61156,61338,61516,61691,61862,62029
	.int	62192,62352,62507,62659,62807,62952,63092,63229
	.int	63361,63490,63615,63736,63854,63967,64076,64182
	.int	64283,64381,64475,64564,64650,64732,64810,64884
	.int	64954,65020,65082,65140,65195,65245,65291,65333
	.int	65371,65406,65436,65462,65484,65503,65517,65527
	.int	65533,65535,65534
	
