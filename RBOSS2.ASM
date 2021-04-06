**************************************************************
*
* Orcus software:	Eugene Jarvis, Shawn Liptak
* Initiated:		7/12/91 from RBOSS SMASH TV
*
* Modified:		Shawn Liptak, 9/25/91	-Started big fix
* 			Shawn Liptak, 11/7/91	-Done??
*
**************************************************************
*
* AFDM software:	Shawn Liptak
* Initiated:		11/17/91
*
* Modified:		!
*
**************************************************************
*
* COPYRIGHT (C) 1991 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 11/23/91 17:38
**************************************************************

;	.include	"mproc.equ"
;	.include	"disp.equ"
;	.include	"\video\sys\sys.inc"
;	.include	"\video\sys\gsp.inc"
;	.include	"game.equ"
;	.include	"imgtbl.glo"
;	.include	"audit.equ"
;	.include	"shawn.hdr"		;My macros
;	.include	"orcus.tbl"
;	.include	"akhbship.tbl"
;
;
;	.ref	puffsnd
;	.ref	abossaballnum
;	.ref	BCURRENT
;	.ref	missilev_t
;	.ref	FRANIMQ
;	.ref	boss_scorehit
;	.ref	msllnchsnd
;	.ref	HALT
;	.ref	anim_script
;	.ref	seekob_dir32la
;	.ref	rocket_fireab
;	.ref	TARGET
;	.ref	abossseektop_dir32
;	.ref	boss_addrndxy
;	.ref	OUT_FLG
;	.ref	bossram
;	.ref	FLASHME
;	.ref	mslnofuel_l
;	.ref	missile_fireab
;	.ref	getplyr
;	.ref	ahkbang
;	.ref	getcloseplyr
;	.ref	PCNT
;	.ref	rndrng0
;	.ref	musicsnd
;	.ref	rcktlnchsnd
;	.ref	COLCYC
;	.ref	mslexpsnd
;	.ref	BOOM3
;	.ref	cycmem
;	.ref	bodystat
;	.ref	ahkb1
;	.ref	ahkb2
;	.ref	FADEIN
;	.ref	ahkb3
;	.ref	HZSPD
;	.ref	vel_set
;	.ref	abossseeko_dir32
;	.ref	aboss_smoketrail
;	.ref	WAVE
;	.ref	rnd
;	.ref	bloflg
;	.ref	ONESNDOVR
;	.ref	mk_objfranim
;	.ref	ahkbsta
;	.ref	abossshld
;	.ref	XBOOM2
;	.ref	TTORSO
;	.ref	doorsldsnd
;	.ref	bossramend
;	.ref	exp1snd
;	.ref	boss_addxy
;	.ref	PLYRPRCS
;	.ref	exp2snd
;	.ref	rocketv_t
;	.ref	CURRENT
;	.ref	bossd_t



**************************************************************
*
* Orcus software:	Eugene Jarvis, Shawn Liptak
* Initiated:		7/12/91 from RBOSS SMASH TV
*
* Modified:		Shawn Liptak, 9/25/91	-Started big fix
* 			Shawn Liptak, 11/7/91	-Done??
*
**************************************************************
*
* AFDM software:	Shawn Liptak
* Initiated:		11/17/91
*
* Modified:		!
*
**************************************************************
*
* COPYRIGHT (C) 1991 WILLIAMS ELECTRONICS GAMES, INC.
*
*.Last mod - 11/23/91 17:38
**************************************************************

;Sound headers

	.ref	LOVEIT

musicsnd	.word	>f3fe,10,>8009,0	;Boss music
landsnd		.word	>fc88,30,>8030,0	;Land from a jump
laughsnd	.word	>f194,30,>80f2,0	;When plyr dies
exp1snd		.word	>fc80,7,>803e,0		;Explosion
exp2snd		.word	>fd80,10,>80d9,0	;^
;pain1snd	.word	>f985,20,>80f6,0	;
;pain2snd	.word	>f985,20,>80f9,0	;
groansnd	.word	>f985,20,>8113,0	;Groan
groanlndsnd	.word	>f185,20,>8113,0	;^ interruptable
oofsnd		.word	>f985,20,>8114,0	;Oof
yowl1snd	.word	>f985,30,>8115,0	;
yowl2snd	.word	>f985,30,>8116,0	;
roarsnd		.word	>f990,40,>8117,0	;Roar
roarlongsnd	.word	>f990,120,>8117,0	;Roar
houchsnd	.word	>f985,20,>8120,0	;
hyowlsnd	.word	>f985,20,>8122,0	;
stvpainsnd	.word	>f985,30,>8123,0	;
bubl1snd 	.word	>f5e5,20,>8131,0	;Blood bubbling
bubl2snd	.word	>f0e5,20,>8130,0	;^

myeyesnd	.word	>f9e0,110,>8118,0	;
myarmsnd	.word	>f9e0,120,>8119,0	;
myheadsnd	.word	>f9e0,70,>8121,0	;

msllnchsnd	.word	>f290,10,>80b6,0	;Missile launch
mslexpsnd	.word	>f470,10,>8048,0	;Missile explosion

* Aboss
ahkb1		.word	>f9a0,60,>80eb,0	;Akhboob speech
ahkb2		.word	>f9a0,60,>80ec,0	;^
ahkb3		.word	>f9a0,60,>80ed,0	;^
ahkbsta		.word	>f9a0,60,>80ee,0	;^ start angry
ahkbang		.word	>f9a0,60,>80ef,0	;^ angry
doorsldsnd	.word	>f480,2,>804c,0		;Door slides
rcktlnchsnd	.word	>f290,10,>812c,0	;Rocket launch
puffsnd		.word	>f280,10,>8085,0	;Attack balls puffing


********************************
* Animation scripts

*ANIMATION NUMBERS
MOUTHCL		.set	1	;MOUTH CLOSED
MOUTHOP1	.set	2	;MOUTH OPENING
MOUTHOP2	.set	3
MOUTHOP3	.set	4
EYEBLD		.set	5
EYECNT		.set	6	;EYES CENTER
EYECL1		.set	7	;EYES CLOSING
EYECL2		.set	8
EYEBUG		.set	9	;BUG EYES
EYERT1		.set	10	;EYES RIGHT
EYERT2		.set	11
EYELFT1		.set	12	;EYES LEFT
EYELFT2		.set	13
SIDE		.set	14
SHOULDER	.set	15
ARMDN		.set	16	;ARM DOWN
ARMDN1		.set	17	;ARM DOWN RECOIL
ARMDN2		.set	18
ARML1		.set	19	;ARM ROTATING TO LEFT
ARML2		.set	20
ARML3		.set	21
ARML4		.set	22
ARMR1		.set	23	;ARM ROTATING TO RIGHT
HDST		.set	24	;LITTLE HEAD STRAIGHT
HDFROWN		.set	25
HDROAR		.set	26
HDOOOH		.set	27
HDGRIN		.set	28
HDL1NT		.set	29	;LIL HEAD SLIGHT LEFT W/TEETH
HDL1T		.set	30
HDL2NT		.set	31
HDL2T		.set	32
HDL3		.set	33
HDL4		.set	34
HDL5		.set	35
NUSHD		.set	36
;free		.set	37
NULLOBJ		.set	38
TNG1		.set	39
TNG2		.set	40
TNG3		.set	41
TNG4		.set	42
TNG5		.set	43
TNGL		.set	44
TNGR		.set	45
NULLOBJ1	.set	46
ARMDNPT		.set	47
ARML1PT		.set	48
ARML2PT		.set	49
ARML3PT		.set	50
ARML4PT		.set	51
ARMR1PT		.set	52
THRUST1		.set	53
THRUST2		.set	54
HDRIPL		.set	55
TOPRIPL		.set	56
THRUSTNULL	.set	57
BASERIPA	.set	58
LSTANI		.set	58


MOUTHL	.set	1		;Part numbers
MOUTHR	.set	2
SIDEL	.set	3
SIDER	.set	4
EYEL	.set	5
EYER	.set	6
SHLDRL	.set	7
SHLDRR	.set	8
LILHD	.set	9		;LIL HEAD
ARML	.set	10
ARMR	.set	11
LILHDF	.set	14		;FLIPPED LIL HEAD
TONGUE	.set	15
THRUSTL	.set	16
THRUSTR	.set	17

*ANIANITB
*SEQ(32),TIME(16)

hddam_t	.long	frowner,frowner,frowner,frowner
	.long	grimmr,grimmr,grimmr,grimmr
	.long	oooher,oooher,oooher,oooher
	.long	oooher,oooher,oooher,oooher

grinner	LW	HDGRINA,15
	LW	HDGRINA,15
	LWL0	HDGRINA,15

frowner	LW	HDFRWNA,10
	LW	HDFRWNA,10
	LWL0	HDFRWNA,10

oooher	LW	HDOOOHA,30
	LWL0	HDOOOHA,20

grimmr	LW	HDGRIM,1
	LW	HDGRIM,1
	LW	HDGRIM,1
	LWL0	HDGRIM,1


eyequad_t			;Eyeball table
	.long	EYESCNT,EYESCNT,EYESCNT,EYESRT1
	.long	EYESRT1,EYESRT1,EYESRT2,EYESRT2
	.long	EYESRT2,EYESRT2,EYESRT2,EYESRT1
	.long	EYESRT1,EYESRT1,EYESCNT,EYESCNT
	.long	EYESCNT,EYESCNT,EYESCNT,EYESLFT1
	.long	EYESLFT1,EYESLFT1,EYESLFT2,EYESLFT2
	.long	EYESLFT2,EYESLFT2,EYESLFT2,EYESLFT1
	.long	EYESLFT1,EYESLFT1,EYESCNT,EYESCNT

hdquad_t			;Lil head table
	.long	HEAD225,HEAD225,HEAD225,HEAD225
	.long	HEAD225,HEAD270,HEAD270,HEAD270
	.long	HEAD270,HEAD270,HEAD300,HEAD300
	.long	HEAD330,HEAD330,HEAD330,HEAD0
	.long	HEAD0,HEAD0,HEAD30,HEAD30
	.long	HEAD30,HEAD60,HEAD60,HEAD90
	.long	HEAD90,HEAD90,HEAD90,HEAD90
	.long	HEAD135,HEAD135,HEAD135,HEAD135

eyedam_t
	.long	bugger,bugger,bugger,bugger
	.long	bugger,bugger,bugger,bugger
	.long	blinker,blinker,blinker,blinker
	.long	blinker,blinker,blinker,blinker


bugger	LW	EYESBLNK,1
	LW	EYESBUG,15
	LW	EYESBLNK,1
	LWL0	EYESBUG,15

blinker	LW	EYESBLNK,2
	LW	EYESBLNK,2
	LW	EYESBLNK,2
	LW	EYESBLNK,2
	LW	EYESBLNK,2
	LWL0	EYESBLNK,2

mouthrnd_t
	LW	TNGSTIKA,7
	LW	bite_seq,10
	LW	CHOMP3,2
	LW	CHOMP2,3
	LW	TNGSTIKA,7
	LW	bite_seq,10
	LW	CHOMP3,5
	LW	CHOMP2,1
	LW	TNGSTIKA,7
	LW	bite_seq,10
	LW	CHOMP3,5
	LW	CHOMP2,3
	LW	TNGSTIKA,7
	LW	bite_seq,10
	LW	TNGSTIKA,7
	LW	bite_seq,10


*ANIMATION TABLE
*PART #, ANI FRAME
*-=End of frame

*Thrust sequences

thrusthi_seq	.byte	THRUSTL,THRUST2,THRUSTR,-THRUST2
thrustlo_seq	.byte	THRUSTL,THRUST1,THRUSTR,-THRUST1
thrustnull_seq	.byte	THRUSTL,THRUSTNULL,THRUSTR,-THRUSTNULL


*OPEN MOUTH

bite_seq
	.byte	MOUTHL,MOUTHOP1,MOUTHR,-MOUTHOP1
	.byte	MOUTHL,MOUTHOP2,MOUTHR,-MOUTHOP2
	.byte	MOUTHL,MOUTHOP3,MOUTHR,-MOUTHOP3
	.byte	MOUTHL,MOUTHOP2,MOUTHR,-MOUTHOP2
	.byte	MOUTHL,MOUTHOP1,MOUTHR,-MOUTHOP1
BITECL	.byte	MOUTHL,MOUTHCL,MOUTHR,-MOUTHCL
	.word	0
CHOMP3	.byte	MOUTHL,MOUTHOP1,MOUTHR,-MOUTHOP1
	.byte	MOUTHL,MOUTHOP2,MOUTHR,-MOUTHOP2
	.byte	MOUTHL,MOUTHOP3,MOUTHR,-MOUTHOP3
	.byte	MOUTHL,MOUTHOP2,MOUTHR,-MOUTHOP2
	.byte	MOUTHL,MOUTHOP1,MOUTHR,-MOUTHOP1
	.byte	MOUTHL,MOUTHCL,MOUTHR,-MOUTHCL
CHOMP2	.byte	MOUTHL,MOUTHOP1,MOUTHR,-MOUTHOP1
	.byte	MOUTHL,MOUTHOP2,MOUTHR,-MOUTHOP2
	.byte	MOUTHL,MOUTHOP3,MOUTHR,-MOUTHOP3
	.byte	MOUTHL,MOUTHOP2,MOUTHR,-MOUTHOP2
	.byte	MOUTHL,MOUTHOP1,MOUTHR,-MOUTHOP1
	.byte	MOUTHL,MOUTHCL,MOUTHR,-MOUTHCL
	.byte	MOUTHL,MOUTHOP1,MOUTHR,-MOUTHOP1
	.byte	MOUTHL,MOUTHOP2,MOUTHR,-MOUTHOP2
	.byte	MOUTHL,MOUTHOP3,MOUTHR,-MOUTHOP3
	.byte	MOUTHL,MOUTHOP2,MOUTHR,-MOUTHOP2
	.byte	MOUTHL,MOUTHOP1,MOUTHR,-MOUTHOP1
	.byte	MOUTHL,MOUTHCL,MOUTHR,-MOUTHCL
	.word	0

*EYE ANIMATIONS

EYESBLNK
	.byte	EYEL,EYECL1,EYER,-EYECL1	;EYES HALF CLOSED
	.byte	EYEL,EYECL2,EYER,-EYECL2	;EYES CLOSED
	.byte	EYEL,EYECL2,EYER,-EYECL2	;EYES CLOSED
	.byte	EYEL,EYECL1,EYER,-EYECL1	;EYES HALF CLOSED
	.byte	EYEL,EYECNT,EYER,-EYECNT	;EYES CENTERED
	.word	0
EYESCNT	.byte	EYEL,EYECNT,EYER,-EYECNT	;EYES CENTERED
EYESLFT1
	.byte	EYEL,EYELFT1,EYER,-EYERT1	;EYES LEFT
EYESLFT2
	.byte	EYEL,EYELFT2,EYER,-EYERT2	;EYES LEFT EXTREME
	.byte	EYEL,EYELFT1,EYER,-EYERT1	;EYES LEFT
	.byte	EYEL,EYECNT,EYER,-EYECNT	;EYES CENTERED
EYESRT1	.byte	EYEL,EYERT1,EYER,-EYELFT1	;EYES RIGHT
EYESRT2	.byte	EYEL,EYERT2,EYER,-EYELFT2	;EYES RIGHT EXTREME
	.byte	EYEL,EYERT1,EYER,-EYELFT1	;EYES RIGHT
	.byte	EYEL,EYECNT,EYER,-EYECNT	;EYES CENTERED
	.word	0
EYESLT3	.byte	EYEL,EYELFT1,EYER,-EYERT1	;EYES LEFT
	.byte	EYEL,EYELFT2,EYER,-EYERT2	;EYES LEFT EXTREME
	.byte	EYEL,EYELFT1,EYER,-EYERT1	;EYES LEFT
	.byte	EYEL,EYECNT,EYER,-EYECNT	;EYES CENTERED
	.word	0



*BUGEYES
EYESBUG	.byte	EYEL,EYEBUG,EYER,-EYEBUG	;EYES BUGGED
	.byte	EYEL,EYECNT,EYER,-EYECNT	;EYES CENTERED
	.word	0
hdblo_seq	;Little head blown
	.byte	LILHD,HDRIPL,LILHDF,-NULLOBJ

shldrblo_seq	;Shoulders blown
	.byte	LILHD,NULLOBJ,LILHDF,NULLOBJ
	.byte	SHLDRL,TOPRIPL,SHLDRR,-TOPRIPL

bodyblo_seq
	.byte	ARML,NULLOBJ,ARMR,NULLOBJ
	.byte	EYEL,NULLOBJ,EYER,NULLOBJ
	.byte	SIDEL,NULLOBJ,SIDER,NULLOBJ
	.byte	TONGUE,NULLOBJ
	.byte	THRUSTL,THRUSTNULL,THRUSTR,THRUSTNULL
	.byte	SHLDRL,NULLOBJ,SHLDRR,NULLOBJ
	.byte	MOUTHL,BASERIPA,MOUTHR,-BASERIPA

*LITTLE HEAD ROTATE
HEAD30	.byte	LILHD,HDL1NT,LILHDF,-NULLOBJ
HEAD60	.byte	LILHD,HDL2NT,LILHDF,-NULLOBJ
HEAD90	.byte	LILHD,HDL3,LILHDF,-NULLOBJ
HEAD135	.byte	LILHD,HDL4,LILHDF,-NULLOBJ
HEAD225	.byte	LILHD,NULLOBJ,LILHDF,-HDL4
HEAD270	.byte	LILHD,NULLOBJ,LILHDF,-HDL3
HEAD300	.byte	LILHD,NULLOBJ,LILHDF,-HDL2NT
HEAD330	.byte	LILHD,NULLOBJ,LILHDF,-HDL1NT
HEAD0	.byte	LILHD,HDST,LILHDF,-NULLOBJ
	.word	0


HDGRIM	.byte	LILHD,HDL1T,LILHDF,-NULLOBJ
	.byte	LILHD,HDL2T,LILHDF,-NULLOBJ
	.byte	LILHD,HDL3,LILHDF,-NULLOBJ
	.byte	LILHD,HDL2T,LILHDF,-NULLOBJ
	.byte	LILHD,HDL1T,LILHDF,-NULLOBJ
	.byte	LILHD,HDST,LILHDF,-NULLOBJ
	.byte	LILHD,NULLOBJ,LILHDF,-HDL1T
	.byte	LILHD,NULLOBJ,LILHDF,-HDL2T
	.byte	LILHD,NULLOBJ,LILHDF,-HDL3
	.byte	LILHD,NULLOBJ,LILHDF,-HDL2T
	.byte	LILHD,NULLOBJ,LILHDF,-HDL1T
	.byte	LILHD,HDST,LILHDF,-NULLOBJ
	.word	0
*HEAD GRIN
HDGRINA	.byte	LILHD,HDGRIN,LILHDF,-NULLOBJ
	.byte	LILHD,HDST,LILHDF,-NULLOBJ
	.word	0
*HEAD OOOH
HDOOOHA	.byte	LILHD,HDOOOH,LILHDF,-NULLOBJ
	.byte	LILHD,HDST,LILHDF,-NULLOBJ
	.word	0
*HEAD FROWN
HDFRWNA	.byte	LILHD,HDFROWN,LILHDF,-NULLOBJ
	.byte	LILHD,HDST,LILHDF,-NULLOBJ
	.word	0

*LEFT ARM FIRE POS. 1
LARMF1
	.byte	ARML,-ARMDN1
	.byte	ARML,-ARMDN
	.word	0
*LEFT ARM FIRE POS. 2
LARMF2
	.byte	ARML,-ARML1PT
	.byte	ARML,-ARML1
	.word	0

*LEFT ARM FIRE POS. 3
LARMF3
	.byte	ARML,-ARML2PT
	.byte	ARML,-ARML2
	.word	0
*LEFT ARM FIRE POS. 4
LARMF4
	.byte	ARML,-ARML3PT
	.byte	ARML,-ARML3
	.word	0
*LEFT ARM FIRE POS. 5
LARMF5
	.byte	ARML,-ARML4PT
	.byte	ARML,-ARML4
	.word	0
*LEFT ARM FIRE POS. 6
LARMF6
	.byte	ARML,-ARMR1PT
	.byte	ARML,-ARMR1
	.word	0
*RT ARM FIRE POS. 1
RARMF1
	.byte	ARMR,-ARMDN1
	.byte	ARMR,-ARMDN
	.word	0
*RT ARM FIRE POS. 2
RARMF2
	.byte	ARMR,-ARML1PT
	.byte	ARMR,-ARML1
	.word	0
*RT ARM FIRE POS. 3
RARMF3
	.byte	ARMR,-ARML2PT
	.byte	ARMR,-ARML2
	.word	0

*RT ARM FIRE POS. 4
RARMF4
	.byte	ARMR,-ARML3PT
	.byte	ARMR,-ARML3
	.word	0

*RT ARM FIRE POS. 5
RARMF5
	.byte	ARMR,-ARML4PT
	.byte	ARMR,-ARML4
	.word	0

*RT ARM FIRE POS. 6
RARMF6
	.byte	ARMR,-ARMR1PT
	.byte	ARMR,-ARMR1
	.word	0

*ARM FIRE SEQUENCE
ARMFIRE
	.byte	ARML,ARMR1,ARMR,-ARMR1
	.byte	ARML,ARMR1PT,ARMR,-ARMR1PT
	.byte	ARML,ARMR1,ARMR,-ARMR1
	.byte	ARML,ARMDN,ARMR,-ARMDN
	.byte	ARML,ARMDNPT,ARMR,-ARMDNPT
	.byte	ARML,ARMDN,ARMR,-ARMDN
	.byte	ARML,ARML1,ARMR,-ARML1
	.byte	ARML,ARML1PT,ARMR,-ARML1PT
	.byte	ARML,ARML1,ARMR,-ARML1
	.byte	ARML,ARML2,ARMR,-ARML2
	.byte	ARML,ARML2PT,ARMR,-ARML2PT
	.byte	ARML,ARML2,ARMR,-ARML2
	.byte	ARML,ARML3,ARMR,-ARML3
	.byte	ARML,ARML3PT,ARMR,-ARML3PT
	.byte	ARML,ARML3,ARMR,-ARML3
	.byte	ARML,ARML4,ARMR,-ARML4
	.byte	ARML,ARML4PT,ARMR,-ARML4PT
	.byte	ARML,ARML4,ARMR,-ARML4
	.byte	ARML,ARML3,ARMR,-ARML3
	.byte	ARML,ARML2,ARMR,-ARML2
	.byte	ARML,ARML1,ARMR,-ARML1
	.byte	ARML,ARMDN,ARMR,-ARMDN
	.word	0
*TONGUE STICK OUT
TNGSTIKA
	.byte	MOUTHL,MOUTHOP1,MOUTHR,-MOUTHOP1
	.byte	MOUTHL,MOUTHOP2,MOUTHR,-MOUTHOP2
	.byte	MOUTHL,MOUTHOP3,MOUTHR,-MOUTHOP3
	.byte	TONGUE,-TNG1
	.byte	TONGUE,-TNG2
	.byte	TONGUE,-TNG3
	.byte	TONGUE,-TNG4
	.byte	TONGUE,-TNG5
	.byte	TONGUE,-TNGL
	.byte	TONGUE,-TNGR
	.byte	TONGUE,-TNGL
	.byte	TONGUE,-TNGR
	.byte	TONGUE,-TNG5
	.byte	TONGUE,-TNG4
	.byte	TONGUE,-TNG3
	.byte	TONGUE,-TNG2
	.byte	TONGUE,-TNG1
	.byte	TONGUE,-NULLOBJ1
	.byte	MOUTHL,MOUTHOP2,MOUTHR,-MOUTHOP2
	.byte	MOUTHL,MOUTHOP1,MOUTHR,-MOUTHOP1
	.byte	MOUTHL,MOUTHCL,MOUTHR,-MOUTHCL
	.word	0

********************************
* Boss damage table
* 0-255

BDAMSIZE	.equ	32*3

bossdam_t
	.long	OMTH1,OMTH1A,OMTH1B	;1 MOUTH CLOSED
	.long	OMTH2,OMTH2A,OMTH2B	;2 MOUTH SLIGHTLY OPEN
	.long	OMTH3,OMTH3A,OMTH3B	;3 MOUTH MORE OPEN
	.long	OMTH4,OMTH4A,OMTH4B	;4 MOUTH MORE OPEN
	.long	OEYES1C,OEYES1C,OEYES1C	;5 BLOODY EYE
	.long	OEYES1,OEYES1A,OEYES1C	;6 EYE CENTERED
	.long	OEYES1A,OEYES1A,OEYES1C	;7 EYE HALF CLOSED
	.long	OEYES1B,OEYES1A,OEYES1C	;8 EYE CLOSED
	.long	OEYES2,OEYES1A,OEYES1C	;9 EYE BUGGED OPEN CENTERED
	.long	OEYES3,OEYES1A,OEYES1C	;10 EYE HALF RIGHT
	.long	OEYES4,OEYES1A,OEYES1C	;11 EYE RIGHT
	.long	OEYES3A,OEYES1A,OEYES1C	;12 EYE HALF LEFT
	.long	OEYES4A,OEYES1A,OEYES1C	;13 EYE LEFT
	.long	SIDEPC,SIDEPC,SIDEPC	;14 SIDE OF CHEEK
	.long	SHLDR,SHLDR,SHLDR	;15 SHOULDER STRAP
	.long	OARM1,ARMRIP,NULO	;16 ARM DOWN
	.long	OARM1A,ARMRIP,NULO	;17 ARM DOWN PARTIAL RECOIL
	.long	OARM1B,ARMRIP,NULO	;18 ARM DOWN FULL RECOIL
	.long	OARM2,ARMRIP,NULO	;19 ARM SLIGHT ANGLE LEFT
	.long	OARM3,ARMRIP,NULO	;20 ARM MORE ANGLE LEFT
	.long	OARM4,ARMRIP,NULO	;21 ARM EVEN MORE ANGLE LEFT
	.long	OARM5,ARMRIP,NULO	;22 ARM FULL LEFT HORIZONTAL
	.long	OARM6,ARMRIP,NULO	;23 ARM SLIGHT ANGLE RIGHT
	.long	ORCHD1,ORCHD1,ORCHD1	;24 LITTLE HEAD STRAIGHT FACE
	.long	ORCHD1A,ORCHD1A,ORCHD1A	;25 LITTLE HEAD FROWN FACE
	.long	ORCHD1B,ORCHD1B,ORCHD1B	;26 LITTLE HEAD ROAR FACE
	.long	ORCHD1C,ORCHD1C,ORCHD1C	;27 LITTLE HEAD OOOOHHH FACE
	.long	ORCHD1D,ORCHD1D,ORCHD1D	;28 LITTLE HEAD TOOTHY GRIN FACE
	.long	ORCHD2,ORCHD2,ORCHD2	;29 LITTLE HEAD SLIGHTLY LEFT FACE (NO TEETH)
	.long	ORCHD2A,ORCHD2A,ORCHD2A	;30 LITTLE HEAD SLIGHTLY LEFT FACE (TEETH)
	.long	ORCHD3,ORCHD3,ORCHD3	;31 LITTLE HEAD 45 LEFT FACE (NO TEETH)
	.long	ORCHD3A,ORCHD3A,ORCHD3A	;32 LITTLE HEAD 45 LEFT FACE (TEETH)
	.long	ORCHD4,ORCHD4,ORCHD4	;33 LIL HEAD 60
	.long	ORCHD5,ORCHD5,ORCHD5	;34 LIL HEAD 90
	.long	ORCHD6,ORCHD6,ORCHD6	;35 LIL HEAD 135
	.long	NUSHAD,NUSHAD,NUSHAD	;36 SHADOW
	.long	NULO,NULO,NULO		;37 SIDE SHADOW was> OSHAD2,OSHAD2,OSHAD2
	.long	NULO,NULO,NULO		;38 NULL OBJECT
	.long	TUNG1D,TUNG1D,TUNG1D	;39 TONGUE SMALLEST
	.long	TUNG1C,TUNG1C,TUNG1C	;40 TONGUE NEXT SMALLEST
	.long	TUNG1B,TUNG1B,TUNG1B	;41 TONGUE NEXT SMALLEST
	.long	TUNG1A,TUNG1A,TUNG1A	;42 TONGUE NEXT SMALLEST
	.long	TUNG1,TUNG1,TUNG1	;43 TONGUE FULL SIZE
	.long	TUNG2,TUNG2,TUNG2	;44 TONGUE FULL SIZE CURVE TO LEFT
	.long	TUNG3,TUNG3,TUNG3	;45 TONGUE FULL SIZE CURVE TO RIGHT
	.long	NULO1,NULO1,NULO1	;46 TONGUE NULL
	.long	OARM1PT,OARM1PT,ARMRIP	;47 ARM1 FIRE ANI
	.long	OARM2PT,OARM2PT,ARMRIP	;48 ARM2 FIRE ANI
	.long	OARM3PT,OARM3PT,ARMRIP	;49 ARM3 FIRE ANI
	.long	OARM4PT,OARM4PT,ARMRIP	;50 ARM4 FIRE ANI
	.long	OARM5PT,OARM5PT,ARMRIP	;51 ARM5 FIRE ANI
	.long	OARM6PT,OARM6PT,ARMRIP	;52 ARM6 FIRE ANI
	.long	ORCFLM1,ORCFLM1,ORCFLM1	;53 FLAME 1
	.long	ORCFLM2,ORCFLM2,ORCFLM2	;54 FLAME 2
	.long	HDRIP,HDRIP,HDRIP	;55 HEAD RIPPED LEFT
	.long	TOPRIP,TOPRIP,TOPRIP	;56 TOP (SHOULDERS) RIPPED OFF
	.long	THRSTNL,THRSTNL,THRSTNL	;57 Thrust null
	.long	BASERIP,BASERIP,BASERIP	;58 BASE RIP




* Boss initial data table

boss_t
*PART 1 LEFT MOUTH
	.word	DMAWNZ+M_PIXSCAN		;Flags
	.word	CLSENMY|TYPFACE|SUBMTHL		;Type
	.byte	-1,MOUTHCL			;Damage resistance, Ani#
	.word	159				;Z
*PART 2 RIGHT MOUTH
	.word	DMAWNZ+M_PIXSCAN+M_FLIPH
	.word	CLSENMY|TYPFACE|SUBMTHR
	.byte	-1,MOUTHCL
	.word	159
*PART 3 LEFT SIDE PIECE
	.word	DMAWNZ+M_PIXSCAN
	.word	CLSENMY|TYPFACE|SUBSIDEL
	.byte	0,SIDE
	.word	159
*PART 4 RT SIDE PIECE
	.word	DMAWNZ+M_PIXSCAN+M_FLIPH
	.word	CLSENMY|TYPFACE|SUBSIDER
	.byte	0,SIDE
	.word	159
*PART 5 LEFT EYE
	.word	DMAWNZ
	.word	CLSENMY|TYPFACE|SUBEL
	.byte	0,EYECNT
	.word	160
*PART 6 RIGHT EYE
	.word	DMAWNZ+M_FLIPH
	.word	CLSENMY|TYPFACE|SUBER
	.byte	0,EYECNT
	.word	160
*PART 7 LEFT SHOULDER
	.word	DMAWNZ
	.word	CLSENMY|TYPFACE|SUBSHLDL
	.byte	0,SHOULDER
	.word	163
*PART 8 RT SHOULDER
	.word	DMAWNZ+M_FLIPH
	.word	CLSENMY|TYPFACE|SUBSHLDR
	.byte	0,SHOULDER
	.word	163
*PART 9 LIL HEAD
	.word	DMAWNZ
	.word	CLSENMY|TYPFACE|SUBHD
	.byte	0,HDST
	.word	163
*PART 10 LEFT ARM
	.word	DMAWNZ+M_PIXSCAN
	.word	CLSENMY|TYPFACE|SUBARML
	.byte	-1,ARMDN
	.word	160
*PART 11 RIGHT ARM
	.word	DMAWNZ+M_PIXSCAN+M_FLIPH
	.word	CLSENMY|TYPFACE|SUBARMR
	.byte	-1,ARMDN
	.word	160
*PART 12 LEFT SHADOW
	.word	DMACNZ+M_NOCOLL
	.word	CLSNEUT
	.byte	0,NUSHD
	.word	150
*PART 13 RIGHT SHADOW
	.word	DMACNZ+M_NOCOLL+M_FLIPH
	.word	CLSNEUT
	.byte	0,NUSHD
	.word	150
*PART 14 LIL HEAD FLIPPED
	.word	DMAWNZ+M_FLIPH
	.word	CLSENMY|TYPFACE|SUBHD
	.byte	0,NULLOBJ
	.word	162
*PART 15 TONGUE
	.word	DMAWNZ
	.word	CLSENMY|TYPFACE|SUBTUNG
	.byte	0,NULLOBJ1
	.word	160
*PART 16 LEFT FLAME
	.word	DMAWNZ
	.word	CLSENMY|TYPFACE|SUBFLAM
	.byte	0,THRUSTNULL
	.word	158
*PART 17 RT FLAME
	.word	DMAWNZ+M_FLIPH
	.word	CLSENMY|TYPFACE|SUBFLAM
	.byte	0,THRUSTNULL
	.word	158
	.word	0


;Null object definition
;Lil head null
NULO	.word	1,1,22,-8
	.long	IROM+3*32
	.long	ORCP1
;Tung null
NULO1	.word	1,1,11,-118
	.long	IROM+3*32
	.long	RIPAL
;Thrust null
THRSTNL	.word	1,1,11,-118
	.long	IROM+3*32
	.long	BLUBOOM




****************************************************************
* Akhboob's flying death machine (Process)
****************************************************************

;Boss data struct

ABDOBJ	.set	>0	;*Parts obj
ABDXO	.set	>20	;X offset from ani pt
ABDSHLD	.set	>30	;Shield, 0=Dead, +=OK


ABXO	.equ	24	;Obj 1 offsets for center
ABYO	.equ	40

ABWRLDTY .set	249	;Bkgnd world top Y for end of scroll

	WORDPD	abmode		,0	;Mode, -=At top, 0=Msl mania,
					; 1=Chase plyr, 2=Balls
	WORDPD	absko		,1	;Seek offset -1/1
	WORDPD	abdrag		,2	;Drag shift
;	WORDPD	abgunstat	,3	;Guns stat, 0=OK, 1=Blown


 SUBR	aboss


	clr	a0			;>Clear out boss variables
	movi	bossram,a1
abossc	move	a0,*a1+
	cmpi	bossramend,a1
	jrlo	abossc


	movi	bossrise_as,a8
	CREATE	ANIMPID,anim_script	;P1

	SLEEP	356

	movi	abosspal_t,a0
	movk	2,a1
	calla	FADEIN

	SLEEPK	4+6*3

	move	@WORLDTLX+16,a0		;Get starting coord
	addi	200,a0
	sll	16,a0
	move	@WORLDTLY+16,a1
	addi	SHPY,a1
	sll	16,a1
	callr	aboss_init

	movi	BBSHPAL,a8
	movi	cycmem,a9		;Ram area
	movi	[60,64],a10		;Begin/end color #
	movk	3,a11			;Rate in ticks
	CREATE	CYCPID,COLCYC		;Color cycler on

	move	@bossd_t,a8,L		;A8=*1st obj
	move	a13,a11
	CREATE	BOSSPID,ab_scrollstrt
	CREATE	BOSSPID,ab_gunturrets
	CREATE	BOSSPID,ab_msllauncher
	CREATE	BOSSPID,ab_akhboobani
	CREATE	BOSSPID,plyr_shoeson

	clr	a10			;A10=Dir 0-31

	movk	1,a0
	move	a0,*a13(absko)		;-1 or 1
	movi	-4,a0			;Normal speed
	move	a0,*a13(abdrag)
	move	a0,*a13(abmode)		;Neg
	movi	60*15,a11		;A11=Mode cnt down (Chase time)

abosslp
	SLEEPK	1

	move	*a13(abmode),a0		;>Mode change
	jrle	abl200			;Guns still good?

	subk	1,a11
	jrgt	abl200			;Still counting?
	movi	60*60*20,a11		;Ball time

abl150	addk	1,a0
	move	a0,*a13(abmode)
	subk	2,a0
	jrne	abl200			;!Ball time?
	movi	bossd_t+BLPART,a9	;*Left ball data
	CREATE	BOSSPID,ab_atkball
	movi	bossd_t+BRPART,a9	;*Rgt ball data
	CREATE	BOSSPID,ab_atkball
	movk	2,a0
	move	a0,@abossaballnum

abl200	movk	1,a0
	callr	rnd
	jrnz	abl230			;No smoke?
	CREATE0	aboss_smoketrail


abl230	movk	3,a0			;>Turn
	callr	rnd
	jrz	abl500			;Skip seek?

	move	*a13(abmode),a7
	subk	1,a7
	jrne	abl250			;Go top?

	calla	getcloseplyr		;>Chase plyr
	jrz	abl250			;No player?
	callr	abossseeko_dir32
	jruc	abl300

abl250	movk	32,a0			;Y
	subk	2-1,a7
	jrne	abl260			;!Ball time?
	addk	22,a0			;Lower
	move	@abossshld,a3
	jrge	abl260			;!Docking?
	movk	10,a0
abl260	callr	abossseektop_dir32

abl300	sub	a10,a0			;A0=Difference
	jrz	abl500

	move	a0,a1
	abs	a0
	cmpi	2,a0
	jrle	abl340			;In seeker view?
	move	*a13(abmode),a7
	subk	2,a7
	jreq	abl340			;Ball time?

	move	*a13(absko),a2
	movk	>f,a0
	callr	rnd
	jrnz	abl320			;No dir change?
	neg	a2
	move	a2,*a13(absko)
abl320	add	a2,a10
	jruc	abl400

abl340	subk	16,a0
	jrle	abl350
	neg	a1
abl350	move	a1,a1
	jrnn	abl360
	subk	2,a10			;-1
abl360	addk	1,a10			;+1

abl400	ANDK	>1f,a10			;Make 0-31


abl500	move	a10,a0			;>Thrust
	sll	4,a0			;*16
	addi	missilev_t,a0
	move	*a0(8*16),a6		;XV
	move	*a0,a7			;YV

	move	*a13(abdrag),a2
	move	*a8(OXVEL),a0,L
	move	a0,a3
	sra	a2,a3
	sub	a3,a0			;-Drag
	add	a6,a0			;+Vel
	move	*a8(OYVEL),a1,L
	move	a1,a3
	sra	a2,a3
	sub	a3,a1			;-Drag
	add	a7,a1			;+Vel

	move	a8,a6
	movi	bossd_t,a8		;A8=*Boss data struct
	callr	vel_set
	move	a6,a8

abl700
	callr	ab_keeponscrn

	jruc	abosslp

	move	@abossshld,a3
	jrge	abosslp			;OK?

	SLEEP	60*5

	DIE

abosspal_t
	.long	BBSHPAL,0


********************************
* Anim script for aboss flying out of pit

bossrise_as
	ASNEW	bossrisenew_t		;>Ship in pit and sliding door
	ASSLP	60

	ASRUN	doorsnd_as
	ASLAB	27			;>Slide door up
	ASXY	>10,>f,0,-1
	ASDSJS1
	ASHIDE	>10
	ASLAB	33
	ASXY	>10,>f,0,-1
	ASDSJS1
	ASHIDE	>11
	ASLAB	33
	ASXY	>10,>f,0,-1
	ASDSJS1
	ASHIDE	>12
	ASLAB	27
	ASXY	>10,>f,0,-1
	ASDSJS1

	ASSLP	180

	ASSND	rcktlnchsnd
	ASXY	>20,3,-400,0		;>Ship rises
	ASXYV	>20,3,0,->18000
	ASSLP	6
	ASANI	LILBBSHP2,>20
	ASANI	LILBBSHP2A,>21
	ASSLP	6
	ASANI	LILBBSHP3,>20
	ASANI	LILBBSHP3A,>21
	ASSLP	6
	ASDELM	>20,1

	ASLAB	27			;>Slide door down
	ASXY	>10,>f,0,1
	ASDSJS1
	ASSHOW	>12
	ASLAB	33
	ASXY	>10,>f,0,1
	ASDSJS1
	ASSHOW	>11
	ASLAB	33
	ASXY	>10,>f,0,1
	ASDSJS1
	ASSHOW	>10
	ASLAB	27
	ASXY	>10,>f,0,1
	ASDSJS1

	ASSLP	60*120
	ASDELM	0,>ff



	ASASM
abas100	SLEEPK	10
	move	@WORLDTLY+16,a0
	cmpi	ABWRLDTY+90,a0
	jrgt	abas100

	move	@OBJLST,a2,L		;>Set wall Z down
abas200	move	*a2(OZPOS),a0
	cmpi	281,a0
	jrne	abas240
;	movi	120,a0
;	move	a0,*a2(OZPOS)
abas240	move	*a2,a2,L
	jrnz	abas200			;More?

	ASENDASM

	ASNEW	abwallnew_t

	ASASM
abas400	SLEEPK	15
	move	@WORLDTLY+16,a0
	cmpi	ABWRLDTY+20,a0
	jrgt	abas400
	move	@abossshld,a0
	jrnn	abas400			;Ship OK?
	ASENDASM

	ASLAB	60			;>Slide doors open
	ASXY	>44,0,-1,0
	ASXY	>45,0,1,0
	ASDSJS1

	ASSLP	60*3

	ASASM
abas500	SLEEPK	15
	move	@WORLDTLY+16,a0
	cmpi	ABWRLDTY+2,a0
	jrgt	abas500

	movi	150,a1
	move	@bossd_t,a0,L		;>Set Z low
	move	a1,*a0(OZPOS)
	move	@bossd_t+AKPART,a0,L
	move	a1,*a0(OZPOS)

	ASENDASM

	ASLAB	60			;>Slide doors closed
	ASXY	>44,0,1,0
	ASXY	>45,0,-1,0
	ASDSJS1

	ASDEL	>40
	ASSLP	60*2

	ASLAB	60			;>Slide doors open
	ASXY	>44,0,-1,0
	ASXY	>45,0,1,0
	ASDSJS1

	ASDELM	>44,3

	ASLAB	75			;>Slide big face down
	ASXY	>60,0,0,1
	ASDSJS1

	ASEND

SHPY	.set	48
BDX	.set	196-71
BDY	.set	59

bossrisenew_t
	ASITEMN	600,SHPY+93,LILBBSHP1,20,DMAWNZ,>20
	ASITEMN	600-1,SHPY+93,LILBBSHP1,20,DMAWNZ+M_FLIPH,>20
	ASITEMN	600,SHPY+93,LILBBSHP1A,20,DMAWNZ,>21
	ASITEMN	600-1,SHPY+93,LILBBSHP1A,20,DMAWNZ+M_FLIPH,>21
	ASITEMN	BDX-25,BDY-35,PCCOVER,35,DMAWNZ,8
	ASITEMN	BDX+166,BDY-35,PCCOVER,35,DMAWNZ+M_FLIPH,8
	ASITEMN	BDX,BDY,STEELPC1,30,DMAWNZ,>10
	ASITEMN	BDX+141,BDY,STEELPC1,30,DMAWNZ+M_FLIPH,>10
	ASITEMN	BDX,BDY+27,STEELPC2,30,DMAWNZ,>11
	ASITEMN	BDX+141,BDY+27,STEELPC2,30,DMAWNZ+M_FLIPH,>11
	ASITEMN	BDX,BDY+60,STEELPC2,30,DMAWNZ,>12
	ASITEMN	BDX+141,BDY+60,STEELPC2,30,DMAWNZ+M_FLIPH,>12
	ASITEMN	BDX,BDY+118,STEELPC1,30,DMAWNZ+M_FLIPV,>13
	ASITEMN	BDX+141,BDY+118,STEELPC1,30,DMAWNZ+M_FLIPH+M_FLIPV,>13
	.word	-1000


BWX	.set	130
BWY	.set	-88
BHDX	.set	200
BHDY	.set	-168

abwallnew_t
	ASITEMN	BWX,BWY,DORWAY1,50,DMAWNZ,>40
	ASITEMN	BWX+138,BWY,DORWAY1,50,DMAWNZ+M_FLIPH,>40
	ASITEMN	BWX,BWY,BIGDOR,155,DMAWNZ,>44
	ASITEMN	BWX+138,BWY,BIGDOR,155,DMAWNZ+M_FLIPH,>45
	ASITEMN	BHDX,BWY-120,TOPHED,152,DMAWNZ,>60
	ASITEMN	BHDX,BWY-120,HEDTUBES,152,DMAWNZ,>60
	ASITEMN	BHDX,BWY-120,HEDTUBES,152,DMAWNZ+M_FLIPH,>60
	ASITEMN	BHDX,BWY-120,CHEEK,152,DMAWNZ,>60
	ASITEMN	BHDX,BWY-120,CHIN,152,DMAWNZ,>60
	ASITEMN	BHDX,BWY-120,EAR,152,DMAWNZ,>60
	.word	-1000



doorsnd_as
	ASLAB	120/5		;Open
	ASSND	doorsldsnd
	ASSLP	5
	ASDSJ

	ASSND	musicsnd
	ASSLP	60
	ASSND	ahkbang		;Yell!
	ASSLP	126

	ASLAB	120/5		;Close
	ASSND	doorsldsnd
	ASSLP	5
	ASDSJ
	ASEND

********************************
* Initialize boss
* A0=X, A1=Y

 SUBRP	aboss_init

	PUSH	a2,a3,a9,a10
	movi	aboss_t,a9		;A9=*Init data
	movi	bossd_t,a10

abinlp	move	*a9+,a4			;Get OFLAGS
	jrz	abinx			;End?
	move	*a9+,a5			;OID
	zext	a5
	move	*a9+,a3			;Z
	move	*a9+,a2,L		;*Img
	clr	a6			;XV
	clr	a7			;YV
	PUSH	a0
	CALLA	BEGINOBJ2
	PULL	a0
	move	a10,*a8(OPLINK),L	;Link object to block structure
	move	a8,*a10+,L		;Save pointer to obj
	addk	32,a10
	jruc	abinlp

abinx	clr	a0
	move	a0,*a10,L		;Zero last pointer to mark end

	CREATE	BOSSPID,aboss_glue	;Keep boss together

	PULL	a2,a3,a9,a10
	rets

ABZ	equ	160

aboss_t
	.word	DMAWNZ,CLSENMY|TYPABOSS|SUBABBACK,ABZ	;Back
	.long	BBSHP1
shpart	.word	DMAWNZ|M_NOCOLL,CLSNEUT,120		;L shadow (2 in row)
	.long	BIGSHAD
	.word	DMAWNZ|M_FLIPH|M_NOCOLL,CLSNEUT,120	;R shadow
	.long	BIGSHAD
akpart	.word	DMAWNZ|M_NOCOLL,CLSNEUT|1,ABZ+5		;Akhboob
	.long	AKB1ARMUP1
	.word	DMAWNZ,CLSENMY|TYPABOSS,ABZ		;Center
	.long	BBSHP2
	.word	DMAWNZ,CLSENMY|TYPABOSS,ABZ		;Front
	.long	BBSHP3
	.word	DMAWNZ,CLSENMY|TYPABOSS,ABZ		;Close left
	.long	BBSHP4
	.word	DMAWNZ,CLSENMY|TYPABOSS,ABZ		;Far left
	.long	BBSHP5
	.word	DMAWNZ|M_FLIPH,CLSENMY|TYPABOSS,ABZ	;Close rgt
	.long	BBSHP4
	.word	DMAWNZ|M_FLIPH,CLSENMY|TYPABOSS,ABZ	;Far rgt
	.long	BBSHP5
blpart	.word	DMAWNZ,CLSENMY|TYPABOSS,ABZ-1		;Left ball (3 in row)
	.long	BBALL1
	.word	DMAWNZ,CLSENMY|TYPABOSS,ABZ-1		;Left arm
	.long	BBARM
	.word	DMAWNZ,CLSENMY|TYPABOSS,ABZ-1		;Left arm2
	.long	BBARM2
brpart	.word	DMAWNZ|M_FLIPH,CLSENMY|TYPABOSS,ABZ-1	;Rgt ball
	.long	BBALL1
	.word	DMAWNZ|M_FLIPH,CLSENMY|TYPABOSS,ABZ-1	;Rgt arm
	.long	BBARM
	.word	DMAWNZ|M_FLIPH,CLSENMY|TYPABOSS,ABZ-1	;Rgt arm2
	.long	BBARM2
	.word	0

SHPART	equ	(shpart-aboss_t)/80*64
AKPART	equ	(akpart-aboss_t)/80*64
BLPART	equ	(blpart-aboss_t)/80*64
BRPART	equ	(brpart-aboss_t)/80*64


********************************
* Keep plyrs shoes on (Process)

 SUBRP	plyr_shoeson

	movi	PLYRPRCS,a8

psolp	movi	>8140,a1
	move	*a8,a0,L
	jrz	pso50
	move	*a0(LEG_PRC),a0,L
	move	a1,*a0(SHOECNT)
pso50	move	*a8(32),a0,L
	jrz	pso100
	move	*a0(LEG_PRC),a0,L
	move	a1,*a0(SHOECNT)
pso100	SLOOP	90,psolp


********************************
* Starts various scrollers
* A11=*Aboss process

 SUBRP	ab_scrollstrt

	SLEEP	120

	move	@WORLDTLX+16,a8		;>Start 1st scroll
	addk	5,a8	   		;A8=X target line to trigger scroll
	clr	a9			;A9=0 (not checking for y target)
	movi	pathb2,a10		;Scroll table
	movi	>8000,a0
	move	a0,@HZSPD,L
	CREATE	TARGPID,TARGET
;	clr	a9			;A9=0 for up, 1 for rgt
;	CREATE	ARWPID,ONARRW		;Turn on lft arrow
;	CREATE	FUTUREPID,AOF		;Arrow off after a time
	movi	35,a0
	move	a0,@WAVE

	movi	base2,a0		;DEBUG
	move	a0,@CURRENT,L
;	movi	baseb2,a0
	clr	a0
	move	a0,@BCURRENT,L


asslp1	SLEEPK	30
	move	*a11(abmode),a0
	jrn	asslp1			;Guns OK?
	movi	TARGPID,a0
	movi	-1,a1
	calla	EXISTP
	jrnz	asslp1			;Scroll on?

	move	@WORLDTLX+16,a8		;>Start 2nd scroll
	addk	5,a8	   		;A8=X target line to trigger scroll
	clr	a9			;A9=0 (not checking for y target)
	movi	pathb3,a10
	movi	>2000,a0
	move	a0,@HZSPD,L
	CREATE	TARGPID,TARGET

	movi	base3,a0
	move	a0,@CURRENT,L
	movi	baseb3,a0
	move	a0,@BCURRENT,L


asslp2	SLEEPK	30
	move	@WORLDTLY+16,a0
	cmpi	ABWRLDTY+430,a0
	jrgt	asslp2			;!Halfway there?

	movk	1,a0
	move	a0,*a11(abmode)		;Start chase plyr

asslp3	SLEEPK	30
	move	*a11(abmode),a0
	subk	1,a0
	jreq	asslp3			;Guns OK?
	movi	TARGPID,a0
	movi	-1,a1
	calla	EXISTP
	jrnz	asslp3			;Scroll on?

asslp4	SLEEPK	30
	move	@abossaballnum,a0
	jrgt	asslp4			;Atkballs OK?

	move	@WORLDTLX+16,a8		;>Start 3rd scroll
	addk	5,a8	   		;A8=X target line to trigger scroll
	clr	a9			;A9=0 (not checking for y target)
	movi	pathb4,a10
	movi	>4000,a0
	move	a0,@HZSPD,L
	CREATE	TARGPID,TARGET

	DIE


pathb2	.word	1,212*2,0
pathb3	.word	1,534*8,0
pathb4	.word	1,100*4,0


base2	.WORD	0B3BH,10,0B6BH,3000H		;SIDE WALL
	.WORD	0C9BH,10,0CD7H,3000H		;SIDE WALL
	.WORD	0
base3	.WORD	0B3BH,10,0B50H,03000H
	.WORD	0CB8H,10,0CD7H,03000H
	.WORD	0B3BH,10,0B96H,17CH		;TUBE UP LEFT
	.WORD	0C74H,10,0CE6H,017CH		;TUBE UP RGHT
	.WORD	0B3BH,10,0D26H,0140H		;BACK WALL
	.WORD	0
baseb2	.WORD	0B3BH,10,0B6BH-12,3000H		;SIDE WALL
	.WORD	0C9BH+12,10,0CD7H,3000H		;SIDE WALL
	.WORD	0
baseb3	.WORD	0B3BH,10,0B50H-12,03000H
	.WORD	0CB8H+12,10,0CD7H,03000H
	.WORD	0B3BH,10,0B96H-12,17CH-12	;TUBE UP LEFT
	.WORD	0C74H+12,10,0CE6H,017CH-12	;TUBE UP RGHT
	.WORD	0B3BH,10,0D26H,0140H-12		;BACK WALL
	.WORD	0



********************************
* Keep boss objects together

 SUBRP	aboss_glue

	movi	bossd_t,a8		;A8=*Data block

	PUSH	a12,a13
	move	*a8+,a10,L		;First piece index
	move	a8,a9
	move	*a10(OIMG),a1,L
	move	*a10(OSIZE),a2,L
	move	*a10(OFLAGS),a4
	calla	GANIOF			;Get XY ani offset
	move	a6,a12			;Save X anioff
	move	a7,a13			;Save Y anioff
	jruc	abg40

abglp	move	*a8(OIMG),a1,L
	move	*a8(OSIZE),a2,L
	move	*a8(OFLAGS),a4
	calla	GANIOF			;Get XY ani offset
	sub	a12,a6
	sub	a13,a7

	move	*a8(OID),a0		;Get oid
	move	*a9,a1			;ABDXO

	btst	B_FLIPH,a4
	jrz	abg5			;No flip fix?
	addi	>10000,a6
	neg	a1

abg5	cmpi	CLSNEUT,a0		;>Adjust shadow for height
	jrne	abg10
	btst	B_FLIPH,a4
	jrz	abg8			;No flip fix?
	addi	>10000,a6		;One more
abg8
;	move	@bossz,a0,L
;	sub	a0,a7
	subk	10,a7

abg10	move	*a10(OXVAL),a0,L
	sub	a6,a0
	sll	16,a1
	sub	a1,a0
	move	a0,*a8(OXVAL),L
	move	*a10(OYVAL),a1,L
	sub	a7,a1
	move	a1,*a8(OYVAL),L

abg40	addk	32,a9
	move	*a9+,a8,L		;Get next index
	jrnz	abglp			;More?

	PULL	a12,a13

	SLOOP	1,aboss_glue



********************************
* Check if boss on screen
* A8=*Boss 1st obj
*Rets: Z if on screen, Trashes A0-A3

 SUBRP	ab_keeponscrn

	PUSH	a4,a5
	clr	a2

	move	*a8(OXPOS),a4
	addi	ABXO,a4			;Center X
	move	*a8(OYPOS),a5
	addi	ABYO,a5			;Center Y
	move	*a8(OXVEL),a0,L
	move	*a8(OYVEL),a1,L

	move	@WORLDTLX+16,a3
	sub	a3,a4			;X
	move	@WORLDTLY+16,a3
	sub	a3,a5			;Y

	cmpi	50,a4			;XMin
	jrge	akos50
	movk	1,a2
	abs	a0			;+

akos50	cmpi	350,a4			;XMax
	jrle	akos80
	movk	1,a2
	abs	a0
	neg	a0			;-

akos80	cmpi	-25,a5			;YMin
	jrge	akos120
	movk	1,a2
	abs	a1			;+


akos120	cmpi	250,a5			;YMax
	jrle	akos300
	movk	1,a2
	abs	a1
	neg	a1			;-

akos300	move	a2,a2
	jrz	akosx
	move	a8,a2
	movi	bossd_t,a8		;A8=*Boss data struct
	callr	vel_set
	move	a2,a8

akosx	PULL	a4,a5
	rets


********************************
* Aboss akhboob pilot animations (Process)
* A11=*Aboss process


 SUBRP	ab_akhboobani

	move	@bossd_t+AKPART,a8,L	;*Akhboob obj
aabalp
	movk	15,a0
	callr	rndrng0
	sll	5,a0			;*32
	addi	aaba_t,a0
	move	*a0,a9,L
	move	*a9+,a2			;Get delay
	jrn	aaba50			;No speech?
	CREATE	BOSSPID,ab_akhb_rndspch
	move	a2,*a0(PTIME)
aaba50	JSRP	FRANIMQ
	movi	>7f,a0
	callr	rnd
	addk	10,a0
	calla	PRCSLP
	jruc	aabalp


aaba_t	.long	akbrchl_l,akbrchl_l,akbrchr_l,akbrchr_l
	.long	akbrchl_l,akbrchl_l,akbrchr_l,akbrchr_l
	.long	akbhdtrn_l,akbhdtrn_l,akbhdtrn_l,akbhdtrn_l
	.long	akb1aup_l,akb2aup_l,akbyak_l,akblean_l

akbrchl_l
	.word	-1
	LWW	AKBREACH,FLIPBITS|15,0
	LWL0	AKB1ARMUP1,1
akbrchr_l
	.word	-1
	LWW	AKBREACH,FLIPBITS|15,M_FLIPH
	LWL0	AKB1ARMUP1,1
akbhdtrn_l
	.word	-1
	LW	AKBHEDTURN,40
	LWL0	AKB1ARMUP1,1
akb1aup_l
	.word	4*3
	LW	AKB1ARMUP1,4
	LW	AKB1ARMUP2,4
	LW	AKB1ARMUP3,4
	LW	AKB1ARMUP4,4
	LW	AKB1ARMUP5,4
	LW	AKB1ARMUP6,5
	LW	AKB1ARMUP5,4
	LW	AKB1ARMUP6,5
	LW	AKB1ARMUP5,4
	LW	AKB1ARMUP6,4
	LW	AKB1ARMUP5,4
	LW	AKB1ARMUP4,4
	LW	AKB1ARMUP3,4
	LW	AKB1ARMUP2,4
	LWL0	AKB1ARMUP1,1
akb2aup_l
	.word	4*3
	LW	AKB2ARMUP1,4
	LW	AKB2ARMUP2,4
	LW	AKB2ARMUP3,4
	LW	AKB2ARMUP4,4
	LW	AKB2ARMUP5,5
	LW	AKB2ARMUP4,5
	LW	AKB2ARMUP5,5
	LW	AKB2ARMUP4,5
	LW	AKB2ARMUP5,4
	LW	AKB2ARMUP4,4
	LW	AKB2ARMUP3,4
	LW	AKB2ARMUP2,4
	LWL0	AKB2ARMUP1,1
akbyak_l
	.word	0
	LW	AKBYAK,5
	LW	AKB1ARMUP1,5
	LW	AKBYAK,4
	LW	AKB1ARMUP1,5
	LW	AKBYAK,5
	LW	AKB1ARMUP1,4
	LW	AKBYAK,4
	LW	AKB1ARMUP1,4
	LW	AKBYAK,4
	LWL0	AKB1ARMUP1,1
akblean_l
	.word	0
	LW	AKBLEAN1,5
	LW	AKBLEAN2,5
	LW	AKBLEAN3,5
	LW	AKBLEAN4,5
	LW	AKBLEAN3,5
	LW	AKBLEAN4,5
	LW	AKBLEAN3,5
	LW	AKBLEAN4,5
	LW	AKBLEAN3,5
	LW	AKBLEAN2,5
	LW	AKBLEAN1,5
	LWL0	AKB1ARMUP1,1


********************************
* Random akhboob speech

 SUBRP	ab_akhb_rndspch

	movk	4,a0
	callr	rndrng0
	sll	5,a0			;*32
	addi	abakhspeech_t,a0
	move	*a0,a0,L
	calla	ONESND
	DIE

abakhspeech_t
	.long	ahkb1,ahkb2,ahkb3,ahkbsta,ahkbang


********************************
* ABOSS turret spawner (Process)
* A8=*1st boss obj
* A11=*ABOSS process

	APTRPD	KPTSOBJ		,0	;For turret (in ARAB)

 SUBRP	ab_gunturrets

	movk	3,a9			;Gun type
	move	a13,a10
	CREATE	T72PID,TTORSO
	CREATE	T72PID,TTORSO
	CREATE	T72PID,TTORSO

abgtlp	SLEEPK	30
	movi	T72PID,a0
	movi	-1,a1
	calla	EXISTP
	jrnz	abgtlp			;Still alive?

	clr	a0
	move	a0,*a11(abmode)		;Start missile attack

	DIE



********************************
* Aboss missile launcher (Process)
* A11=*Aboss process

	APTRPD	amlabproc	,0	;*AB proc

 SUBRP	ab_msllauncher

	move	a11,*a13(amlabproc),L

amllp	SLEEPK	8
	move	@HALT,a0
	jrnz	amllp			;Halt?

;	move	@bossd_t,a2,L		;Get * 1st obj
;	move	*a2(OYPOS),a2
;	move	@WORLDTLY+16,a0
;	sub	a0,a2
;	cmpi	140,a2
;	jrgt	amllp			;Near bottom?

	move	*a13(amlabproc),a2,L
	move	*a2(abmode),a0
	jrnz	amlslp			;No missile mania?

	move	@bossd_t,a8,L		;*1st obj
	movi	abmslo_t,a9
	movk	1,a0
	callr	rnd
	jrnz	aml500			;Msl?

	callr	getplyr			;>Rocket
	jrz	amlslp			;No player?
	callr	abossseeko_dir32
	move	a0,a10
	subk	9,a10
	movk	7,a11
aml350	CREATE	BOSSPID,rocket_fireab
	movi	rcktlnchsnd,a0
	calla	ONESND
	SLEEPK	1
	addk	3,a10			;Turn
	dsj	a11,aml350
	jruc	amlslp

aml500	movk	3,a11			;>Missile
aml550	movk	4,a0
	callr	rndrng0
	addk	14,a0
	move	a0,a10			;14-18
	CREATE	BOSSPID,missile_fireab
	movi	msllnchsnd,a0
	calla	ONESND
	SLEEPK	7
	addk	32,a9			;Next slot
	dsj	a11,aml550

amlslp	movi	55,a0
	callr	rndrng0
	addk	10,a0
	calla	PRCSLP
	jruc	amllp


abmslo_t
	.word	ABXO,ABYO+15,ABXO-50,ABYO+15,ABXO+50,ABYO+15



********************************
* Aboss attack ball (Process)
* A9=*Ball data struct

;	APTRPD	aababproc	,0	;*AB proc
	WORDPD	aabxvel		,2	;XVel of ball

 SUBRP	ab_atkball

;	movi	130,a0
	movi	20,a0
	move	a0,*a9(ABDSHLD)		;Set shield


	movi	40,a11
aab100	move	a9,a8			;>Extend ball and arms
	movk	3,a3
aab120	addk	32,a8
	move	*a8,a1			;ABDXO
	addk	1,a1
	move	a1,*a8
	addk	32,a8
	dsj	a3,aab120
	SLEEPK	1
	dsj	a11,aab100

	CREATE	BOSSPID,ab_ballopen
	SLEEP	60
	move	a13,a11
	CREATE	BOSSPID,ab_ballshoot

	movk	1,a0
	move	a0,*a13(aabxvel)

aablp	SLEEPK	1
	move	@HALT,a0
	jrnz	aablp			;Halt?

	move	*a13(aabxvel),a2
	move	*a9(ABDXO),a3
	add	a2,a3
	cmpi	20,a3
	jrge	aab200			;OK?
	movk	20,a3
	jruc	aab400

aab200	cmpi	67,a3
	jrle	aab300			;OK?
	movi	67,a3
	jruc	aab400

aab300	movk	>1f,a0
	callr	rnd
	jrnz	aab420			;!Dir change?
aab400	neg	a2			;Neg XVel
aab420	move	a2,*a13(aabxvel)
	move	a3,*a9(ABDXO)
	move	a3,*a9(ABDXO+64)	;Arm1
	move	a3,*a9(ABDXO+64*2)	;Arm2

;aab600	movk	3,a0
;	callr	rnd
;	addk	3,a0			;3-6
;	move	a0,a6
;	move	a9,a5
;	move	*a9,a8,L
;	movi	sparkball_l,a9
;	movi	70,a0
;	calla	RNDRNGS
;	move	a0,a10
;	movk	30,a11
;aab630	CREATE	BOSSPID,mortar_relaboss
;	addk	25,a11
;	dsj	a6,aab630
;	move	a5,a9

aab800	move	*a9(ABDSHLD),a0
	jrgt	aablp			;Ball OK?

	SLEEP	60*6

aab900	move	a9,a8			;>Retract ball and arms
	movk	3,a3
aab920	addk	32,a8
	move	*a8,a1			;ABDXO
	subk	1,a1
	move	a1,*a8
	addk	32,a8
	dsj	a3,aab920
	SLEEPK	1
	move	*a9(ABDXO),a1
	subk	12,a1
	jrgt	aab900			;Still out?


	move	@abossaballnum,a0
	subk	1,a0
	move	a0,@abossaballnum
	jrgt	aabx
	movi	50,a0
	move	a0,@abossshld		;Let ship die

aabx	DIE


sparkball_l
	.long	0		;*FRANIM
	LW	TEST1,2		;82 Ticks
	LW	TEST2,3
	LW	TEST3,4
	LW	TEST4,6
	LW	TEST5,9
	LW	TEST6,11
	LW	TEST7,12
	LW	TEST6,11
	LW	TEST5,9
	LW	TEST4,6
	LW	TEST3,4
	LW	TEST2,3
	LWL0	TEST1,2
	.word	DMAWNZ
	.long	BOOM3		;*FRANIM


********************************
* Open the ball and animate (Process)
* A9=*Ball data struct

 SUBRP	ab_ballopen

	SLEEPK	20
	move	*a9,a8,L
	CREATE	BOSSPID,ab_ballopenex
	movi	ballopen_l,a9
	JSRP	FRANIMQ
	DIE

ballopen_l
	LW	BBALL2,7
	LW	BBALL3,7
	LWL	BLLFACE1,NEWPALET|5,GRNFCP
	LW	BLLFACE3,5
	LW	BLLFACE4,5
	LW	BLLFACE2,5
	LW	BLLGRIN1,5
	LW	BLLGRIN2,5
	LW	BLLGRIN1,5
	LWL0	BLLFACE4,1


********************************
* Do extra face img for open ball (Process)
* A8=*Ball obj

 SUBRP	ab_ballopenex

	move	a8,a10
	clr	a0
	clr	a1
	movi	BLLOPEN1,a2
	movi	ABZ,a3			;Z
	move	*a10(OFLAGS),a4
	addi	M_NOCOLL,a4
	movi	CLSDEAD,a5
	clr	a6
	clr	a7
	calla	BEGINOBJ2
	movi	ballopenex_l,a9
	CREATE	BOSSPID,FRQDELDIE

	movk	13,a11			;>Keep face on ball
aboelp	move	a8,a0
	move	a10,a8
	calla	GETANIXY
	move	*a0(OFLAGS),a4
	calla	GANISAG
	move	a0,a8
	SLEEPK	1
	dsj	a11,aboelp
	DIE

ballopenex_l
	LW	BLLOPEN1,7
	LWL0	BLLOPEN2,7



********************************
* Fire shot from ball (Process)
* A9=*Ball data struct
* A11=*Ball main process

 SUBRP	ab_ballshoot

	move	*a9,a8,L
abslp	CREATE	BOSSPID,ab_ballpuff
	movi	puffsnd,a0
	calla	ONESND
	SLEEPK	4
	movk	3,a10
abs50	SLEEPK	3
	CREATE	BOSSPID,ab_ballshot
	dsj	a10,abs50
	movk	30,a0
	callr	rndrng0
	addi	60,a0
	calla	PRCSLP
	move	*a9(ABDSHLD),a0
	jrgt	abslp
	DIE

********************************
* Do face puffing (Process)
* A8=*Ball obj
* A9=*Ball data struct

 SUBRP	ab_ballpuff

	movi	ballblow_l,a9
	JSRP	FRANIMQ
	DIE

ballblow_l
	LW	BLLBLOW1,2
	LW	BLLBLOW2,2
	LW	BLLBLOW3,2
	LW	BLLBLOW4,2
	LW	BLLBLOW3,2
	LW	BLLBLOW2,2
	LW	BLLBLOW1,2
	LWL0	BLLFACE4,1


********************************
* Fire shot from ball (Process)
* A8=*Ball obj
* A9=*Ball data struct
* A11=*Ball main process

	WORDPD	shotshield,0	;Shield strength
;	WORDPD	shotsko,1	;Seek offset -1/1
	WORDPD	shotdrag,2	;Drag shift

 SUBRP	ab_ballshot

	move	*a11(aabxvel),a11
	move	*a8(OXPOS),a0
	addk	26,a0
	move	*a8(OYPOS),a1
	addi	42,a1
	sll	16,a0
	sll	16,a1
	move	*a8(OXVEL),a6,L
	move	*a8(OYVEL),a7,L
	jrgt	abf30			;Pos YVel?
	clr	a7
abf30	addi	>10000,a7
	sll	17,a11			;*2
	move	*a9(OFLAGS),a10
	btst	B_FLIPH,a10
	jrz	abf50			;No flip?
	neg	a11
abf50	sub	a11,a6

	movi	smrtball_t,a9
	movk	16,a10


 SUBRP	smrtshot_fire		;A8=*Src obj, A9=*Offset_t, A10=Dir 0-31

	movi	200,a11			;Fuel
	movk	1,a0			;Shield
	movi	159,a3			;Z

	move	a0,*a13(shotshield)
	movi	-5,a0			;Slow speed
	move	a0,*a13(shotdrag)

	move	*a8(OXPOS),a0
	move	*a8(OYPOS),a1
	move	*a9+,a2			;+X offset
	add	a2,a0
	move	*a9+,a2			;+Y offset
	add	a2,a1

	sll	16,a0
	sll	16,a1
	movi	BALL6,a2		;*Image
	movi	DMAWNZ,a4
	movi	CLSENMY+TYPSL+SUBMSL,a5
	calla	BEGINOBJ2

	movk	25,a9			;Seek delay
	jruc	ssf400


ssf200	SLEEPK	1
	subk	1,a9
	jrlt	ssf220
	jrgt	ssf500			;Don't seek?
;	movi	159,a0
;	move	a0,*a8(OZPOS)

ssf220
	calla	getcloseplyr
	jrz	ssf700			;No player?
	callr	seekob_dir32la

ssf300	sub	a10,a0			;A0=Difference
	jrz	ssf500

	move	a0,a1
	abs	a0
	subk	16,a0
	jrle	ssf350
	neg	a1
ssf350	move	a1,a1
	jrnn	ssf360
	subk	2,a10			;-1
ssf360	addk	1,a10			;+1


ssf400	ANDK	>1f,a10			;Make 0-31

ssf500	move	a10,a0
	sll	4,a0			;*16
	addi	rocketv_t,a0
	move	*a0(8*16),a6		;XV
	move	*a0,a7			;YV

	move	*a13(shotdrag),a2
	move	*a8(OXVEL),a0,L
	move	a0,a1
	sra	a2,a1
	sub	a1,a0			;-Drag
	add	a6,a0			;+Vel
	move	a0,*a8(OXVEL),L
	move	*a8(OYVEL),a0,L
	move	a0,a1
	sra	a2,a1
	sub	a1,a0			;-Drag
	add	a7,a0			;+Vel
	move	a0,*a8(OYVEL),L

ssf700
	movk	>f,a1
	and	a11,a1
	jrnz	ssf800			;Skip screen check?
	calla	SCRTST
	janz	DELOBJDIE
ssf800
;	move	@bloflg,a0
;	jrn	ssfx			;Big blow?

	subk	1,a11
	jrgt	ssf200			;Got fuel?

ssfx	move	*a8(OYPOS),a0
	addk	15,a0
	move	a0,*a8(OYPOS)
	movi	DMAWNZ+M_NOCOLL,a0
	move	a0,*a8(OFLAGS)
	movi	mslexpsnd,a0
	calla	ONESND
	movi	mslnofuel_l,a9		;Out of fuel!
	jauc	FRQDELDIE



smrtball_t
	.word	26,42



********************************
* Part of boss monster takes a hit
* A0=*Obj that hit
* A8=*Boss obj

	.def	aboss_hit

 SUBR	aboss_hit

	mmtm	sp,a1,a2,a3,a4,a5,a6,a7,a9,a10,a11

	movk	1,a1
	move	a1,@OUT_FLG		;Stop scan

	move	@bodystat,a1
	jrnz	abhx			;All blown?

	move	a0,a11			;A11=*Obj that hit
	move	*a11(OID),a10		;Get subtype
	sll	32-3,a10
	srl	32-3-4,a10		;*16
	jrz	abh100			;Bomb?
	move	@bloflg,a0
	jrn	abh100			;Blow in progress?
;	callr	bosshit_big

abh100	move	*a11(OXVEL),a1,L
	move	*a11(OYVEL),a2,L
	addi	buldat2_t,a10		;A10=*Data_t
	move	*a10,a9			;>Push back
	sra	a9,a1
	sra	a9,a2
	callr	boss_addxy

	move	*a10,a0			;>Shake
	addk	10,a0
	callr	boss_addrndxy

	movk	3,a0			;75%
	callr	rnd
	jrnz	abhx			;No damage?

	movi	>21210000,a9
	CREATE0	FLASHME

	move	*a8(OPLINK),a9,L	;A9=*Obj data struct
	move	*a10(>80),a2		;A2=Weapon damage
	jrnn	abh140			;!Bomb?
	movk	1,a0
	callr	rnd
	move	a0,a2			;Bomb damage 0 or 1
abh140
	move	@abossshld,a3
	jrle	abh300			;Not counting?
	sub	a2,a3
	jrgt	abh200			;OK?
	CREATE	BOSSPID,ab_afdmxpld
	clr	a3
abh200	move	a3,@abossshld
	jruc	abh700

abh300	move	*a9(ABDSHLD),a3		;A3=Shield strength
	jrle	abh700
	sub	a2,a3
	jrgt	abh400			;OK?
	move	@bloflg,a0
	jrnz	abh700			;Blow or lockout in progress?
	CREATE	BOSSPID,ab_ballxpld

abh400	move	a3,*a9(ABDSHLD)


abh700	move	*a10(>80),a1		;Get score
	abs	a1
	callr	boss_scorehit

abhx	mmfm	sp,a1,a2,a3,a4,a5,a6,a7,a9,a10,a11
	rets

; Bullet subtype data table
;SUBLZR		1	;Regular shots
;SUBSPRY	2	;Spray
;SUBFIRE1	3	;Flame thrower
;SUBGRND	4	;Arcing balls
;SUBNOSTP	5	;Non-stopping rockets
;SUBSPDG1	6	;Fast blue balls
buldat2_t
	.word	-2,-3,-3,-3, 0, 0,-2,0		;Shift count
	.word	-1, 1, 1, 3, 4, 3, 1,0		;Damage/score


********************************
* Explode the ball (Process)
* A8=*Ball obj
* A9=*Ball data struct

 SUBRP	ab_ballxpld


	movi	ahkbang,a0
	calla	ONESNDOVR

	movi	60*3,a6
abxlp
	move	*a8(OFLAGS),a4
	move	*a8(OXPOS),a10
	addk	25,a10			;+XO
	move	*a8(OYPOS),a11
	addk	20,a11			;+YO
;	movk	3,a0
;	and	a6,a0
	btst	0,a6
	jrnz	abx150
	movi	aballlexp_t,a9		;>Explosion
	btst	B_FLIPH,a4
	jrz	abx100			;Left ball?
	movi	aballrexp_t,a9
abx100	CREATE	BOSSPID,mk_objfranim
abx150
;	addi	AY+40,a11
;	movi	shldrl_t,a9		;>Alternate LR shoulder
;	btst	0,a6
;	jrz	abx200
;	movi	shldrr_t,a9
;abx200	CREATE	BOSSPID,mk_objfranim

	movi	exp1snd,a0
	calla	ONESND
	movi	exp2snd,a0
	calla	ONESND
	movk	8,a0
	callr	boss_addrndxy		;Shake!
	movi	>8000,a1
	clr	a2
	btst	B_FLIPH,a4
	jrz	abx400			;LBall?
	neg	a1
abx400	callr	boss_addxy		;Push
	move	a6,a9
	SLEEPK	1
	move	a9,a6
	dsj	a6,abxlp


	movi	aballwrk_l,a9
	JSRP	FRANIMQ
	DIE

aballlexp_t
	.long	XBOOM2
	.word	190,->800,>200,->800,>800
aballrexp_t
	.long	XBOOM2
	.word	190,->200,>800,->800,>800

aballwrk_l
	LWL	BBALLWRECK,NEWPALET|1,BBSHPAL
	.long	0




********************************
* Explode the death machine (Process)
* A8=*Ball obj
* A9=*Ball data struct

 SUBRP	ab_afdmxpld


	movi	ahkbang,a0
	calla	ONESNDOVR

	move	@bossd_t,a8,L		;A8=*1st obj

	movi	60*5,a6
aafxlp
;	move	*a8(OFLAGS),a4
	move	*a8(OXPOS),a10
	addk	25,a10			;+XO
	move	*a8(OYPOS),a11
	addk	30,a11			;+YO
;	movk	3,a0
;	and	a6,a0
;	jrnz	aafx150
	movi	afdmexp_t,a9		;>Explosion
	CREATE	BOSSPID,mk_objfranim
aafx150
;	addi	AY+40,a11
;	movi	shldrl_t,a9		;>Alternate LR shoulder
;	btst	0,a6
;	jrz	aafx200
;	movi	shldrr_t,a9
;aafx200	CREATE	BOSSPID,mk_objfranim

	movi	exp1snd,a0
	calla	ONESND
	movi	exp2snd,a0
	calla	ONESND
	movk	10,a0
	callr	boss_addrndxy		;Shake!
	move	a6,a9
	SLEEPK	1
	move	a9,a6
	dsj	a6,aafxlp


	movi	afdmej_l,a9
	JSRP	FRANIMQ


	movi	bossd_t+AKPART+64,a9	;>Delete all objs except for 1-3
	jruc	aafx530
aafx500	calla	DELOBJ
	clr	a0
	move	a0,*a9+,L		;Clr out *
	addk	32,a9
aafx530	move	*a9,a0,L
	jrnz	aafx500

	move	@bossd_t+SHPART,a8,L	;>Small shadow
	movi	EJCTSHAD,a1
	move	*a8(OFLAGS),a4
	calla	ANI
	move	@bossd_t+SHPART+64,a8,L
	move	*a8(OFLAGS),a4
	calla	ANI

	movi	-1,a0
	move	a0,@abossshld		;Eject!

	DIE


afdmexp_t
	.long	XBOOM2
	.word	190,->800,>800,->800,>500

afdmej_l
	LWL0	EJECTSEAT,1
	.long	0






	.end
