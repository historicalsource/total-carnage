	.FILE 'imgtbl.asm'
	.OPTION B,D,L,T

	.include imgtbl.glo
	.DATA
	.even
TEST1:
	.word	6,7,3,3
	.long	>2000000
	.long	KRACK
TEST2:
	.word	8,8,4,3
	.long	>20001C0
TEST3:
	.word	14,13,7,7
	.long	>20003C0
TEST4:
	.word	16,14,7,5
	.long	>2000A40
TEST5:
	.word	22,20,11,10
	.long	>2001140
TEST6:
	.word	22,21,11,10
	.long	>2002040
TEST7:
	.word	23,26,11,12
	.long	>2003000
ARPRT9:
	.word	30,61,0,0
	.long	>2666920
	.long	ARPRTPL
JEEP:
	.word	79,114,40,-7
	.long	>266A620
	.long	JEEPP
JEEPDRVRS:
	.word	51,17,25,-53
	.long	>267C320
	.long	JEEPP
JSHAD:
	.word	21,90,-37,-30
	.long	>267DEC0
	.long	JEEPP
JEEP2:
	.word	79,101,40,-20
	.long	>2682240
	.long	JEEPP
JSHAD2:
	.word	21,90,-37,-30
	.long	>2691EC0
	.long	JEEPP
JEEP4:
	.word	129,76,57,-21
	.long	>2696240
	.long	JEEPP
GBUL12:
	.word	9,14,4,6
	.long	>26A9BC0
	.long	FING1
GBUL115:
	.word	9,12,4,5
	.long	>26AA100
	.long	FING1
GBUL11:
	.word	11,11,5,5
	.long	>26AA580
	.long	FING1
GBUL10:
	.word	13,10,6,5
	.long	>26AA9A0
	.long	FING1
GBUL9:
	.word	15,7,7,3
	.long	>26AAEA0
	.long	FING1
GBUL85:
	.word	13,10,6,5
	.long	>26AB220
	.long	FING1
GBUL8:
	.word	11,11,5,5
	.long	>26AB720
	.long	FING1
GBUL7:
	.word	9,12,4,6
	.long	>26ABB40
	.long	FING1
GBUL6:
	.word	9,14,4,8
	.long	>26ABFC0
	.long	FING1
PTGNR1:
	.word	30,61,15,-9
	.long	>26AC500
	.long	FING1
GNNRBUL12:
	.word	3,14,1,7
	.long	>26B0200
	.long	FING1
GNNRBUL115:
	.word	7,12,3,6
	.long	>26B03C0
	.long	FING1
GNNRBUL11:
	.word	10,9,5,4
	.long	>26B06C0
	.long	FING1
GNNRBUL10:
	.word	14,8,8,4
	.long	>26B0A20
	.long	FING1
GNNRBUL9:
	.word	15,3,8,1
	.long	>26B0E20
	.long	FING1
GNNRBUL85:
	.word	14,8,8,3
	.long	>26B0FA0
	.long	FING1
GNNRBUL8:
	.word	10,9,5,4
	.long	>26B13A0
	.long	FING1
GNNRBUL7:
	.word	7,12,4,4
	.long	>26B1700
	.long	FING1
GNNRBUL6:
	.word	3,14,1,6
	.long	>26B1A00
	.long	FING1
PTGNR2:
	.word	36,60,19,-8
	.long	>26B1BC0
PTGNR3:
	.word	49,54,29,-7
	.long	>26B5F40
PTGNR4:
	.word	60,42,36,-11
	.long	>26BB700
PTGNR5:
	.word	70,39,39,-22
	.long	>26C05C0
PTGNR6:
	.word	58,50,31,-15
	.long	>26C5D80
PTGNR7:
	.word	50,55,23,-10
	.long	>26CBB40
PTGNR8:
	.word	39,61,15,-6
	.long	>26D14A0
PTGNR9:
	.word	29,63,15,-5
	.long	>26D60E0
CLIFF2A:
	.word	57,48,0,0
	.long	>26D9FE0
	.long	DESRTPL
CLIFF3A:
	.word	60,55,0,0
	.long	>26DF9E0
	.long	DESRTPL
PITDR1:
	.word	33,26,0,0
	.long	>26E6100
PITDR2:
	.word	33,26,0,0
	.long	>26E7E40
UNDRPT1:
	.word	52,40,0,0
	.long	>26E9B80
UNDRPT2:
	.word	31,71,0,0
	.long	>26EDC80
UNDRPT3:
	.word	47,30,0,0
	.long	>26F2380
GUNPIT2:
	.word	75,89,0,0
	.long	>26F5080
VGUNPIT2:
	.word	65,63,0,0
	.long	>27023E0
UNDRPT1A:
	.word	52,40,0,0
	.long	>270A9C0
UNDRPT2A:
	.word	31,71,0,0
	.long	>270EAC0
UNDRPT3A:
	.word	47,30,0,0
	.long	>27131C0
WARP:
	.word	142,53,0,0
	.long	>2715EC0
	.long	WARPP
WTIMER0:
	.word	5,7,0,0
	.long	>2724D40
	.long	WARPP
ARW2:
	.word	9,5,0,0
	.long	>2724F00
	.long	WARPP
SPIN1:
	.word	31,28,0,0
	.long	>27250E0
	.long	WARPP
WTIMER1:
	.word	5,7,0,0
	.long	>2726CE0
	.long	WARPP
OTHERP:
	.word	5,7,0,0
	.long	>2726CE0
	.long	WARPP2
WTIMER2:
	.word	5,7,0,0
	.long	>2726EA0
WTIMER3:
	.word	5,7,0,0
	.long	>2727060
WTIMER4:
	.word	5,7,0,0
	.long	>2727220
WTIMER5:
	.word	5,7,0,0
	.long	>27273E0
WTIMER6:
	.word	5,7,0,0
	.long	>27275A0
WTIMER7:
	.word	5,7,0,0
	.long	>2727760
WTIMER8:
	.word	5,7,0,0
	.long	>2727920
WTIMER9:
	.word	5,7,0,0
	.long	>2727AE0
SPIN2:
	.word	31,28,0,0
	.long	>2727CA0
SPIN3:
	.word	31,28,0,0
	.long	>27298A0
SPIN4:
	.word	31,28,0,0
	.long	>272B4A0
SPIN5:
	.word	31,28,0,0
	.long	>272D0A0
SPIN6:
	.word	31,28,0,0
	.long	>272ECA0
SPIN7:
	.word	31,28,0,0
	.long	>27308A0
SPIN8:
	.word	31,28,0,0
	.long	>27324A0
OGUNBUL:
	.word	10,9,5,4
	.long	>295CB20
	.long	AHMEDP
EXPL1:
	.word	8,8,4,3
	.long	>295CE80
	.long	EORNGPAL
EXPL2:
	.word	20,20,10,9
	.long	>295D080
EXPL3:
	.word	30,28,15,13
	.long	>295DD00
EXPL4:
	.word	35,31,18,15
	.long	>295F900
EXPL5:
	.word	43,41,20,20
	.long	>2961BE0
EXPL6:
	.word	50,55,24,25
	.long	>2965440
EXPL7:
	.word	62,56,31,28
	.long	>296ADA0
EXPL8:
	.word	69,62,35,30
	.long	>2971DA0
EXPL9:
	.word	67,57,34,27
	.long	>297A920
EXPL10:
	.word	55,46,29,22
	.long	>2982240
EXPL11:
	.word	54,47,27,22
	.long	>29872C0
EXPL12:
	.word	54,47,27,24
	.long	>298C500
MTNK10:
	.word	50,38,20,8
	.long	>2991740
	.long	MTNKP
RTNK:
	.word	50,38,20,8
	.long	>2991740
	.long	MTNKP2
ANT:
	.word	5,29,0,0
	.long	>2995500
	.long	MTNKP
MTNK11:
	.word	49,36,22,11
	.long	>2995C40
	.long	MTNKP
MTNK12:
	.word	37,36,14,12
	.long	>29996C0
	.long	MTNKP
MTNK12B:
	.word	37,36,14,12
	.long	>299C3C0
	.long	MTNKP
MTNK6:
	.word	37,36,15,8
	.long	>299F0C0
	.long	MTNKP
MTNK6B:
	.word	37,36,15,8
	.long	>29A1DC0
	.long	MTNKP
MTNK7:
	.word	45,37,19,7
	.long	>29A4AC0
	.long	MTNKP
MTNK8:
	.word	45,36,21,8
	.long	>29A8240
	.long	MTNKP
MTNK9:
	.word	41,34,18,8
	.long	>29AB840
	.long	MTNKP
MTNK9B:
	.word	41,34,18,8
	.long	>29AE700
	.long	MTNKP
BTR60:
	.word	182,98,64,-35
	.long	>29B15C0
	.long	BTRP
TURT12:
	.word	29,66,14,-7
	.long	>29D4940
	.long	BTRP
BTIRE1:
	.word	37,36,18,26
	.long	>29D8B40
	.long	BTRP
SCUD1:
	.word	228,106,87,-29
	.long	>29DB840
	.long	SCUDP
MISSLE:
	.word	201,56,48,-10
	.long	>2A0AB80
	.long	SCUDP
TURT9:
	.word	59,33,44,-40
	.long	>2A21080
	.long	BTRP
SCUD2:
	.word	19,12,0,-17
	.long	>2A24E60
	.long	SCUDP
BTRECK:
	.word	182,98,64,-35
	.long	>2A255E0
BTIRE2:
	.word	37,36,18,26
	.long	>2A48960
TURT12A:
	.word	29,47,14,-26
	.long	>2A4B660
TURT11:
	.word	37,60,22,-13
	.long	>2A4E560
TURT11A:
	.word	29,44,13,-29
	.long	>2A53060
TURT10:
	.word	48,54,33,-19
	.long	>2A55C60
TURT10A:
	.word	33,39,18,-34
	.long	>2A5AD60
TURT9A:
	.word	44,33,29,-40
	.long	>2A5D940
TURT9B:
	.word	54,43,39,-30
	.long	>2A606A0
TURT9BA:
	.word	38,36,23,-37
	.long	>2A651E0
TURT8:
	.word	57,36,42,-40
	.long	>2A67EE0
TURT8A:
	.word	41,33,26,-40
	.long	>2A6C260
TURT7:
	.word	49,49,34,-40
	.long	>2A6EFC0
TURT7A:
	.word	37,37,22,-40
	.long	>2A73F60
TURT6:
	.word	29,62,14,-40
	.long	>2A76DA0
TURT6A:
	.word	29,48,14,-40
	.long	>2A7ABA0
TURT6B:
	.word	37,58,22,-40
	.long	>2A7DBA0
TURT6BA:
	.word	30,44,15,-40
	.long	>2A82420
DOC1:
	.word	18,37,8,-9
	.long	>2A85020
	.long	PPLP
BM1:
	.word	5,11,2,-30
	.long	>2A86740
	.long	PPLP
NSDR1:
	.word	19,38,9,-7
	.long	>2A86A00
	.long	PPLP
BGRL1:
	.word	15,38,8,-11
	.long	>2A881C0
	.long	PPLP
GN1:
	.word	17,38,9,-11
	.long	>2A894C0
	.long	PPLP
SLUD1:
	.word	12,8,4,3
	.long	>2A8AC80
	.long	PPLP
GRL1:
	.word	12,34,6,-5
	.long	>2A8AF80
	.long	PPLP
NSDRRUN1:
	.word	15,32,9,-7
	.long	>2A8BC40
	.long	PPLP
PILOT1:
	.word	16,33,0,0
	.long	>2A8CC40
	.long	PPLP
BABE1:
	.word	25,31,12,4
	.long	>2A8DCC0
	.long	PPLP
REPO1:
	.word	28,40,13,-12
	.long	>2A8F7E0
	.long	PPLP
SHCAKLDD1:
	.word	30,42,13,-12
	.long	>2A91AE0
	.long	PPLP
SHCAKLDD2:
	.word	30,43,13,-11
	.long	>2A944E0
	.long	PPLP
SHCAKLDD3:
	.word	30,45,13,-9
	.long	>2A96FE0
	.long	PPLP
SHCAKLDE1:
	.word	23,41,11,-11
	.long	>2A99CE0
	.long	PPLP
SHCAKLDF1:
	.word	24,40,12,-10
	.long	>2A9BBA0
	.long	PPLP
SHACKX1:
	.word	24,39,8,-12
	.long	>2A9D9A0
	.long	PPLP
SHACKX2:
	.word	29,39,13,-12
	.long	>2A9F6E0
	.long	PPLP
SHACKX3:
	.word	26,39,10,-12
	.long	>2AA1DE0
	.long	PPLP
SECBON:
	.word	41,18,0,0
	.long	>2AA4000
	.long	PPLP
SHACKY1:
	.word	25,38,9,-13
	.long	>2AA58C0
	.long	PPLP
SHACKY2:
	.word	38,38,17,-13
	.long	>2AA7A00
	.long	PPLP
SHACKY3:
	.word	28,41,12,-10
	.long	>2AAA980
	.long	PPLP
BIGBONE:
	.word	66,25,38,17
	.long	>2AACD60
	.long	PPLP
PTS1:
	.word	36,19,19,-14
	.long	>2AB0280
PTS2:
	.word	36,19,19,-14
	.long	>2AB17E0
PTS3:
	.word	36,19,19,-14
	.long	>2AB2D40
PTS4:
	.word	36,19,19,-14
	.long	>2AB42A0
PTS5:
	.word	36,19,19,-14
	.long	>2AB5800
PTS6:
	.word	36,19,19,-14
	.long	>2AB6D60
PTS7:
	.word	36,19,19,-14
	.long	>2AB82C0
PTS8:
	.word	36,19,19,-14
	.long	>2AB9820
PTS9:
	.word	36,19,19,-14
	.long	>2ABAD80
PTS10:
	.word	36,19,19,-14
	.long	>2ABC2E0
BABE2:
	.word	26,32,12,5
	.long	>2ABD840
BABE3:
	.word	23,32,11,4
	.long	>2ABF440
BABE4:
	.word	25,31,12,4
	.long	>2AC0C40
DOC2:
	.word	23,37,11,-9
	.long	>2AC2760
DOC3:
	.word	24,37,12,-9
	.long	>2AC4320
DOC4:
	.word	24,37,12,-9
	.long	>2AC5EE0
BM2:
	.word	11,22,5,-25
	.long	>2AC7AA0
BM3:
	.word	15,29,7,-20
	.long	>2AC82E0
BM4:
	.word	19,34,9,-17
	.long	>2AC9160
BM5:
	.word	19,46,9,-11
	.long	>2ACA6A0
BM6:
	.word	19,46,9,-10
	.long	>2ACC360
BM7:
	.word	19,46,9,-10
	.long	>2ACE020
BM8:
	.word	19,46,9,-10
	.long	>2ACFCE0
BM9:
	.word	19,46,9,-10
	.long	>2AD19A0
BM10:
	.word	17,46,9,-10
	.long	>2AD3660
NSDR2:
	.word	20,38,10,-7
	.long	>2AD5320
NSDR3:
	.word	20,37,10,-8
	.long	>2AD6AE0
NSDR4:
	.word	19,36,9,-8
	.long	>2AD8200
NSDR8:
	.word	19,38,9,-7
	.long	>2AD9880
NSDR9:
	.word	20,38,10,-7
	.long	>2ADB040
SWAVE1:
	.word	19,42,9,-3
	.long	>2ADC800
SWAVE2:
	.word	19,40,9,-5
	.long	>2ADE240
SWAVE3:
	.word	24,38,12,-7
	.long	>2ADFB40
BGRL2:
	.word	24,36,12,-13
	.long	>2AE17C0
BGRL3:
	.word	15,37,8,-12
	.long	>2AE32C0
GN2:
	.word	18,38,9,-11
	.long	>2AE4540
GN3:
	.word	18,38,9,-11
	.long	>2AE5D00
GN4:
	.word	18,38,9,-11
	.long	>2AE74C0
GN5:
	.word	18,38,9,-11
	.long	>2AE8C80
GN6:
	.word	18,38,9,-11
	.long	>2AEA440
SLUD2:
	.word	9,11,3,4
	.long	>2AEBC00
SLUD3:
	.word	12,10,5,5
	.long	>2AEC020
SLUD4:
	.word	15,9,8,4
	.long	>2AEC3E0
SLUD5:
	.word	13,11,4,6
	.long	>2AEC860
SLUD6:
	.word	11,8,4,3
	.long	>2AECDE0
GRL2:
	.word	13,34,6,-5
	.long	>2AED0E0
GRL3:
	.word	13,33,5,-6
	.long	>2AEE1E0
GRL4:
	.word	12,33,4,-6
	.long	>2AEF260
SLMD1:
	.word	8,7,3,2
	.long	>2AEFEC0
SLMD2:
	.word	11,14,5,4
	.long	>2AF0080
SLMD3:
	.word	16,23,7,6
	.long	>2AF05C0
SLMD4:
	.word	17,27,7,6
	.long	>2AF1140
NSDRRUN2:
	.word	18,32,9,-7
	.long	>2AF2220
NSDRRUN3:
	.word	17,32,8,-7
	.long	>2AF3620
NSDRRUN4:
	.word	16,33,8,-7
	.long	>2AF4A20
PILOT2:
	.word	16,32,0,0
	.long	>2AF5AA0
PILOT3:
	.word	16,32,0,0
	.long	>2AF6AA0
PILOT4:
	.word	16,33,0,0
	.long	>2AF7AA0
SCHAKLDA1:
	.word	25,43,9,-8
	.long	>2AF8B20
SCHAKLDA2:
	.word	27,40,11,-11
	.long	>2AFB0C0
SCHAKLDA3:
	.word	25,38,9,-13
	.long	>2AFD3C0
SCHAKLDB1:
	.word	27,40,11,-11
	.long	>2AFF500
SCHAKLDB2:
	.word	24,40,8,-11
	.long	>2B01800
SCHAKLDB3:
	.word	25,40,9,-11
	.long	>2B03600
SCHAKLDB4:
	.word	24,40,8,-11
	.long	>2B05900
SHCAKLDC1:
	.word	25,41,9,-14
	.long	>2B07700
SHCAKLDC2:
	.word	25,41,9,-14
	.long	>2B09AE0
SHCAKLDC3:
	.word	29,41,13,-14
	.long	>2B0BEC0
SHCAKLDC4:
	.word	23,41,7,-14
	.long	>2B0E7C0
BLLN1:
	.word	21,29,0,0
	.long	>2B10680
	.long	BLLNP5
BLLN2:
	.word	22,29,0,0
	.long	>2B11C40
	.long	BLLNP5
BLLN3:
	.word	23,21,0,0
	.long	>2B13200
	.long	BLLNP5
SQUAD:
	.word	115,23,0,0
	.long	>2B141C0
	.long	BLLNP3
GSCOTT:
	.word	65,25,0,0
	.long	>2B19520
	.long	BLLNP5
BOON1:
	.word	73,59,0,0
	.long	>2B1CA40
	.long	BLLNP5
BOON2:
	.word	33,15,0,0
	.long	>2B25660
	.long	BLLNP5
BOON2B:
	.word	23,35,0,0
	.long	>2B26740
	.long	BLLNP5
DARM1:
	.word	134,60,107,-20
	.long	>2B2C020
	.long	DHNDP
THUMB:
	.word	41,29,-43,10
	.long	>2B3BF20
	.long	DHNDP
DHND1:
	.word	122,60,-27,-19
	.long	>2B3E700
	.long	DHNDP
DHND2:
	.word	86,61,-27,-19
	.long	>2B4CF80
	.long	DHNDP
CENS1:
	.word	56,71,1,0
	.long	>2B57740
	.long	CENSP
CENS2:
	.word	50,79,0,0
	.long	>2B5F380
	.long	CENSP
CENS3:
	.word	45,77,1,1
	.long	>2B673E0
	.long	CENSP
CENS4:
	.word	71,78,0,0
	.long	>2B6E760
	.long	CENSP
TARM1:
	.word	27,34,-30,-70
	.long	>2B796E0
TARM2:
	.word	32,34,-30,-71
	.long	>2B7B4A0
TARM3:
	.word	38,35,-30,-71
	.long	>2B7D6A0
GH1:
	.word	36,43,18,-4
	.long	>2B80260
GH2:
	.word	38,42,19,-5
	.long	>2B832C0
GH3:
	.word	39,43,20,-4
	.long	>2B86740
GH3A:
	.word	39,43,20,-4
	.long	>2B89D00
GLARM1:
	.word	27,94,35,-59
	.long	>2B8D2C0
GLARM2:
	.word	34,85,41,-59
	.long	>2B92500
GLARM3:
	.word	41,65,49,-59
	.long	>2B984A0
GRARM1:
	.word	14,88,-30,-63
	.long	>2B9DE00
GRARM2:
	.word	19,72,-30,-62
	.long	>2BA0A00
GRARM3:
	.word	25,70,-30,-52
	.long	>2BA3700
PEYE1:
	.word	56,18,29,-47
	.long	>2BA7440
PEYE2:
	.word	56,18,29,-47
	.long	>2BA93C0
PEYE3:
	.word	56,18,29,-47
	.long	>2BAB340
PEYE4:
	.word	56,20,29,-45
	.long	>2BAD2C0
PMTH1:
	.word	22,16,12,-86
	.long	>2BAF5C0
PMTH2:
	.word	22,14,12,-86
	.long	>2BB01C0
PMTH3:
	.word	22,13,12,-86
	.long	>2BB0C40
PMTH4:
	.word	20,21,11,-85
	.long	>2BB1600
GRARM4:
	.word	18,56,-30,-61
	.long	>2BB2320
GRARM5:
	.word	30,49,-18,-40
	.long	>2BB4620
GRARM6:
	.word	37,77,-10,-11
	.long	>2BB7720
GLARM4:
	.word	40,53,48,-58
	.long	>2BBD760
GLARM5:
	.word	57,48,62,-47
	.long	>2BC19A0
GLARM6:
	.word	64,82,57,-13
	.long	>2BC73A0
VBOX1:
	.word	16,1,8,-27
	.long	>2BD17A0
	.long	BOXP
HBOX1:
	.word	52,37,27,-9
	.long	>2BD1820
	.long	BOXP
VBOX6:
	.word	52,37,27,-9
	.long	>2BD5440
VBOX2:
	.word	22,7,11,-24
	.long	>2BD9060
VBOX3:
	.word	27,13,14,-21
	.long	>2BD95A0
VBOX4:
	.word	34,19,18,-18
	.long	>2BDA100
VBOX5:
	.word	40,25,21,-15
	.long	>2BDB660
HBOX6:
	.word	52,37,27,-9
	.long	>2BDD5A0
HBOX2:
	.word	52,37,27,-9
	.long	>2BE11C0
HBOX3:
	.word	52,37,27,-9
	.long	>2BE4DE0
HBOX4:
	.word	52,37,27,-9
	.long	>2BE8A00
HBOX5:
	.word	52,37,27,-9
	.long	>2BEC620
PODA:
	.word	11,11,5,5
	.long	>2BF0240
	.long	GOOBP
FLG1:
	.word	35,39,0,0
	.long	>2BF0660
	.long	FRTCLS
GOOBR:
	.word	16,58,0,0
	.long	>2BF3240
	.long	GOOBP
GOOBB:
	.word	68,14,0,0
	.long	>2BF4F40
	.long	GOOBP
RCTRPC1:
	.word	33,44,0,0
	.long	>2BF6D00
	.long	REACTR
RCTRPC2:
	.word	25,52,0,0
	.long	>2BF9E80
	.long	REACTR
GOOB1:
	.word	6,5,3,2
	.long	>2BFCC00
	.long	GOOBP
WSTPOOL:
	.word	58,44,0,0
	.long	>2BFCD40
	.long	GOOBP
RCTR2:
	.word	104,114,0,0
	.long	>2C01FC0
	.long	REACTR
OPC1:
	.word	8,4,3,1
	.long	>2C19240
	.long	REACTR
FLAG1:
	.word	36,39,0,0
	.long	>2C19340
	.long	GOOBP
GOOB2:
	.word	8,7,4,3
	.long	>2C1BF20
GOOB3:
	.word	10,9,5,4
	.long	>2C1C0E0
GOOB4:
	.word	12,12,6,6
	.long	>2C1C440
GOOB5:
	.word	14,14,7,6
	.long	>2C1C8C0
GOOB6:
	.word	19,19,9,9
	.long	>2C1CFC0
GOOB7:
	.word	18,20,9,9
	.long	>2C1DBA0
GOOB8:
	.word	16,18,9,9
	.long	>2C1E820
GOOB9:
	.word	22,18,11,8
	.long	>2C1F120
GOOB10:
	.word	27,23,13,9
	.long	>2C1FEA0
GSLMD1:
	.word	8,8,3,4
	.long	>2C212C0
GSLMD2:
	.word	11,15,5,5
	.long	>2C214C0
GSLMD3:
	.word	16,23,8,7
	.long	>2C21A60
GSLMD4:
	.word	17,27,8,7
	.long	>2C225E0
GBLOB1:
	.word	10,9,5,4
	.long	>2C236C0
GBLOB2:
	.word	13,14,6,6
	.long	>2C23A20
GBLOB3:
	.word	19,16,9,7
	.long	>2C24120
GBLOB4:
	.word	18,17,9,8
	.long	>2C24B20
GPOOL1:
	.word	42,44,0,0
	.long	>2C255C0
GPOOL4:
	.word	42,39,0,0
	.long	>2C29240
GPOOL5:
	.word	40,41,0,0
	.long	>2C2C7E0
FLG2:
	.word	37,39,0,0
	.long	>2C2FB20
FLG3:
	.word	36,39,0,0
	.long	>2C32BE0
FLG4:
	.word	37,39,0,0
	.long	>2C357C0
FLG5:
	.word	37,39,0,0
	.long	>2C38880
BROKN:
	.word	39,59,0,0
	.long	>2C3B940
BROKN2:
	.word	32,38,0,0
	.long	>2C40300
CRT3:
	.word	32,31,0,0
	.long	>2C42900
OPC2:
	.word	9,6,4,2
	.long	>2C44800
OPC3:
	.word	13,10,5,4
	.long	>2C44A40
OPC4:
	.word	11,15,4,7
	.long	>2C44F40
OPC5:
	.word	12,19,5,9
	.long	>2C454E0
OPC6:
	.word	12,25,6,12
	.long	>2C45C00
OPC7:
	.word	11,15,6,7
	.long	>2C46560
OPC8:
	.word	11,7,5,3
	.long	>2C46B00
OPC9:
	.word	9,4,4,1
	.long	>2C46DA0
FLAG2:
	.word	38,39,0,0
	.long	>2C46F20
FLAG3:
	.word	37,39,0,0
	.long	>2C49FE0
FLAG4:
	.word	38,39,0,0
	.long	>2C4D0A0
FLAG5:
	.word	38,39,0,0
	.long	>2C50160
CRT1:
	.word	35,42,0,0
	.long	>2C53220
BRRL2:
	.word	17,28,0,0
	.long	>2C56160
LTRBOX1:
	.word	24,21,0,0
	.long	>2C572E0
	.long	LBOXP1
LTRBOX2:
	.word	24,21,0,0
	.long	>2C572E0
	.long	LBOXP2
DET1:
	.word	12,12,0,0
	.long	>2C582A0
	.long	STUFFP
BMBLETS:
	.word	17,19,0,0
	.long	>2C58720
	.long	STUFFP
MEP1:
	.word	65,18,0,0
	.long	>2C59300
	.long	STUFFP
MEP2:
	.word	64,18,0,0
	.long	>2C5B940
	.long	STUFFP
RACKBLK:
	.word	46,46,0,0
	.long	>2C5DD40
	.long	STUFFP
GEMS1:
	.word	39,32,2,-6
	.long	>2C62240
	.long	STUFFP
LFTARRW:
	.word	28,31,0,0
	.long	>2C64A40
	.long	STUFFP
UPARRW:
	.word	27,28,0,0
	.long	>2C66560
	.long	STUFFP
RGTARRW:
	.word	28,31,0,0
	.long	>2C67DE0
	.long	STUFFP
SPRAY:
	.word	24,21,0,0
	.long	>2C69900
	.long	STUFFP
RING:
	.word	23,13,0,0
	.long	>2C6A8C0
	.long	STUFFP
PLAYER:
	.word	26,29,0,0
	.long	>2C6B280
	.long	STUFFP
KEY:
	.word	32,22,0,0
	.long	>2C6CBE0
	.long	STUFFP
NONSTOP:
	.word	27,19,0,0
	.long	>2C6E1E0
	.long	STUFFP
SMART:
	.word	16,20,0,0
	.long	>2C6F280
	.long	STUFFP
SHOES:
	.word	36,25,0,0
	.long	>2C6FC80
	.long	STUFFP
GRENADE:
	.word	38,21,0,0
	.long	>2C718A0
	.long	STUFFP
STAT6:
	.word	64,32,0,0
	.long	>2C732E0
	.long	STATICP
SPDGUN:
	.word	38,20,0,0
	.long	>2C772E0
	.long	STUFFP
FIRE:
	.word	36,22,0,0
	.long	>2C78BE0
	.long	STUFFP
BLADE:
	.word	24,22,0,0
	.long	>2C7A4A0
	.long	STUFFP
JEM1:
	.word	16,12,6,5
	.long	>2C7B520
	.long	STUFFP
JEM2:
	.word	18,15,8,6
	.long	>2C7BB20
	.long	STUFFP
JEM3:
	.word	17,11,7,4
	.long	>2C7C480
	.long	STUFFP
SHOES2:
	.word	27,22,0,0
	.long	>2C7CB60
	.long	STUFFP
CRS12V1:
	.word	28,83,13,19
	.long	>2C7DEA0
	.long	STUFFP
XHAIR:
	.word	20,20,0,0
	.long	>2C82740
	.long	STUFFP
USFLG:
	.word	22,14,0,0
	.long	>2C833C0
	.long	STUFFP
MAPBUTN:
	.word	39,20,0,0
	.long	>2C83E40
	.long	STUFFP
BALL1:
	.word	4,5,1,2
	.long	>2C85740
	.long	STUFFP
BALL6:
	.word	14,15,7,7
	.long	>2C857E0
	.long	STUFFP
SHADW:
	.word	9,7,4,3
	.long	>2C85F60
	.long	STUFFP
DET2:
	.word	12,12,0,0
	.long	>2C86200
DET3:
	.word	12,12,0,0
	.long	>2C86680
BALL2:
	.word	6,7,3,3
	.long	>2C86B00
BALL3:
	.word	8,9,4,4
	.long	>2C86CC0
BALL4:
	.word	10,11,5,5
	.long	>2C86F00
BALL5:
	.word	12,13,6,6
	.long	>2C87320
BALL7:
	.word	18,19,9,9
	.long	>2C87800
GEMS2:
	.word	39,32,2,-6
	.long	>2C883E0
GEMS3:
	.word	39,32,2,-6
	.long	>2C8ABE0
GEMS4:
	.word	39,32,2,-6
	.long	>2C8D3E0
STAT1:
	.word	64,32,0,0
	.long	>2C8FBE0
STAT2:
	.word	64,32,0,0
	.long	>2C93BE0
STAT3:
	.word	64,32,0,0
	.long	>2C97BE0
STAT4:
	.word	64,32,0,0
	.long	>2C9BBE0
STAT5:
	.word	64,32,0,0
	.long	>2C9FBE0
JEM1B:
	.word	16,12,6,5
	.long	>2CA3BE0
JEM1C:
	.word	16,12,6,5
	.long	>2CA41E0
JEM1D:
	.word	19,14,9,7
	.long	>2CA47E0
JEM2B:
	.word	18,15,8,6
	.long	>2CA50A0
JEM2C:
	.word	18,15,8,6
	.long	>2CA5A00
JEM2D:
	.word	18,16,8,7
	.long	>2CA6360
JEM3B:
	.word	17,12,7,5
	.long	>2CA6D60
JEM3C:
	.word	17,14,7,7
	.long	>2CA74E0
JEM3D:
	.word	19,16,9,9
	.long	>2CA7DA0
CRS12V2:
	.word	17,60,8,14
	.long	>2CA87A0
CRS12V3:
	.word	13,38,6,9
	.long	>2CAAD20
CRS12V4:
	.word	10,21,5,6
	.long	>2CAC020
CRS12V5:
	.word	12,16,6,5
	.long	>2CAC800
CRS12V6:
	.word	10,10,5,6
	.long	>2CACE00
CRS12V7:
	.word	7,6,3,6
	.long	>2CAD1C0
I1:
	.word	7,7,3,3
	.long	>2CAD340
	.long	IBALLP
RP1:
	.word	5,6,2,2
	.long	>2CAD500
	.long	RBPAL
RSR1:
	.word	8,4,3,1
	.long	>2CAD680
	.long	RBPAL
I2:
	.word	12,10,5,4
	.long	>2CAD780
I3:
	.word	14,11,5,5
	.long	>2CADB40
I4:
	.word	13,17,6,8
	.long	>2CAE0C0
I5:
	.word	19,17,11,9
	.long	>2CAE940
I6:
	.word	17,19,9,10
	.long	>2CAF3E0
RP2:
	.word	8,8,3,3
	.long	>2CAFFC0
RP3:
	.word	5,13,2,6
	.long	>2CB01C0
RP4:
	.word	9,14,4,6
	.long	>2CB0500
RP5:
	.word	17,11,8,5
	.long	>2CB0A40
RP6:
	.word	14,21,6,9
	.long	>2CB1120
RP7:
	.word	14,34,6,16
	.long	>2CB1BA0
RP8:
	.word	14,21,7,11
	.long	>2CB2CA0
RP9:
	.word	8,8,3,4
	.long	>2CB3720
RP10:
	.word	5,6,2,2
	.long	>2CB3920
RSR2:
	.word	9,6,4,2
	.long	>2CB3AA0
RSR3:
	.word	13,9,6,4
	.long	>2CB3CE0
RSR4:
	.word	11,15,5,8
	.long	>2CB4160
RSR5:
	.word	10,19,5,10
	.long	>2CB4700
RSR6:
	.word	11,25,7,13
	.long	>2CB4E20
RSR7:
	.word	11,15,6,8
	.long	>2CB5780
RSR8:
	.word	11,8,5,4
	.long	>2CB5D20
RSR9:
	.word	9,4,4,1
	.long	>2CB6020
BULLFT:
	.word	8,1,0,0
	.long	>2CB61A0
	.long	BULLET
BULUPLFT:
	.word	7,7,0,0
	.long	>2CB61E0
	.long	BULLET
BULUP:
	.word	1,8,0,0
	.long	>2CB63A0
	.long	BULLET
M1:
	.word	15,15,7,6
	.long	>2CB64A0
	.long	BULLET
FRBAL1:
	.word	8,9,3,4
	.long	>2CB6C20
	.long	BULLET
CNNBLL:
	.word	6,5,2,2
	.long	>2CB6E60
	.long	BULLET
B245:
	.word	10,10,4,4
	.long	>2CB6FA0
	.long	BULLET
B2SIDE:
	.word	12,5,6,2
	.long	>2CB7360
	.long	BULLET
B2UP:
	.word	5,12,2,6
	.long	>2CB7540
	.long	BULLET
ELECT1:
	.word	18,16,8,3
	.long	>2CB7840
	.long	BULLET
CSHIN:
	.word	28,16,0,0
	.long	>2CB8240
	.long	BULLET
SPDBL:
	.word	10,9,4,4
	.long	>2CB9040
	.long	BULLET
FIRE1:
	.word	7,8,3,4
	.long	>2CB93A0
	.long	BULLET
M2:
	.word	4,3,2,1
	.long	>2CB95A0
	.long	BULLET
GSHAD1:
	.word	9,9,4,4
	.long	>2CB9600
	.long	BULLET
CNNBLL2:
	.word	6,5,3,2
	.long	>2CB9960
	.long	BULLET
MSL1:
	.word	14,7,6,3
	.long	>2CB9AA0
	.long	BULLET
ELECT1A:
	.word	23,19,10,6
	.long	>2CB9E20
ELECT1B:
	.word	22,18,10,5
	.long	>2CBAC60
ELECT1C:
	.word	24,22,11,8
	.long	>2CBB9E0
EXPb1:
	.word	7,8,3,3
	.long	>2CBCA60
EXPb2:
	.word	15,15,7,7
	.long	>2CBCC60
EXPb3:
	.word	21,20,11,9
	.long	>2CBD3E0
EXPb4:
	.word	31,29,16,14
	.long	>2CBE2E0
EXPb5:
	.word	46,41,23,20
	.long	>2CBFFE0
EXPb6:
	.word	51,46,26,23
	.long	>2CC3D60
EXPb7:
	.word	54,47,27,24
	.long	>2CC8820
EXPb8:
	.word	57,53,28,27
	.long	>2CCDA60
EXPb9:
	.word	58,53,30,28
	.long	>2CD3DC0
M3:
	.word	5,4,2,1
	.long	>2CDA120
M4:
	.word	8,7,3,3
	.long	>2CDA220
M5:
	.word	11,9,5,4
	.long	>2CDA3E0
M6:
	.word	15,12,7,5
	.long	>2CDA740
FIRE2:
	.word	9,10,4,5
	.long	>2CDAD40
FIRE3:
	.word	10,11,4,5
	.long	>2CDB100
FIRE4:
	.word	14,13,8,6
	.long	>2CDB520
FIRE5:
	.word	15,17,7,7
	.long	>2CDBBA0
FIRE6:
	.word	18,20,9,10
	.long	>2CDC420
KBM1:
	.word	12,11,6,5
	.long	>2CDD0A0
KBM2:
	.word	22,22,11,11
	.long	>2CDD4C0
KBM3:
	.word	33,32,16,16
	.long	>2CDE540
KBM4:
	.word	34,34,18,18
	.long	>2CE0940
KBM5:
	.word	34,34,17,18
	.long	>2CE2F80
KBM6:
	.word	31,29,16,14
	.long	>2CE55C0
KBM7:
	.word	30,30,16,15
	.long	>2CE72C0
FRBAL2:
	.word	9,10,4,5
	.long	>2CDAD40
FRBAL3:
	.word	10,11,4,5
	.long	>2CDB100
FRBAL4:
	.word	14,13,8,6
	.long	>2CDB520
FRBAL5:
	.word	15,17,7,7
	.long	>2CDBBA0
FRBAL6:
	.word	18,20,9,10
	.long	>2CDC420
MSL2:
	.word	14,7,6,1
	.long	>2CE90C0
MSL3:
	.word	13,8,6,2
	.long	>2CE9440
MSL4:
	.word	13,9,5,3
	.long	>2CE9840
MSL5:
	.word	13,11,5,4
	.long	>2CE9CC0
MSL6:
	.word	11,11,4,4
	.long	>2CEA240
MSL7:
	.word	10,12,3,4
	.long	>2CEA660
MSL8:
	.word	8,12,2,5
	.long	>2CEAAE0
MSL9:
	.word	9,12,3,5
	.long	>2CEADE0
RRD0:
	.word	7,9,0,0
	.long	>2CEB260
	.long	SCOREPAL
RRD1:
	.word	7,9,0,0
	.long	>2CEB4A0
	.long	SCOREPAL
RRD2:
	.word	7,9,0,0
	.long	>2CEB6E0
	.long	SCOREPAL
RRD3:
	.word	7,9,0,0
	.long	>2CEB920
	.long	SCOREPAL
RRD4:
	.word	7,9,0,0
	.long	>2CEBB60
	.long	SCOREPAL
RRD5:
	.word	7,9,0,0
	.long	>2CEBDA0
	.long	SCOREPAL
RRD6:
	.word	7,9,0,0
	.long	>2CEBFE0
	.long	SCOREPAL
RRD7:
	.word	7,9,0,0
	.long	>2CEC220
	.long	SCOREPAL
RRD8:
	.word	7,9,0,0
	.long	>2CEC460
	.long	SCOREPAL
RRD9:
	.word	7,9,0,0
	.long	>2CEC6A0
	.long	SCOREPAL
BWORD:
	.word	36,8,0,0
	.long	>2CEC8E0
	.long	SCOREPAL
TSCORE:
	.word	127,27,0,0
	.long	>2CED1E0
	.long	SCOREPAL
FIVE:
	.word	20,8,0,0
	.long	>2CF3DE0
	.long	SCOREPAL
PHD1:
	.word	87,41,0,0
	.long	>2CF42E0
	.long	SCOREPAL
PHD2:
	.word	87,41,0,0
	.long	>2CFB3A0
	.long	SCOREPAL
DROPIT:
	.word	68,33,0,0
	.long	>2D02460
	.long	SCOREPAL
TAKEIT:
	.word	90,34,0,0
	.long	>2D06A80
	.long	SCOREPAL
PATH:
	.word	97,18,0,0
	.long	>2D0CC40
	.long	SCOREPAL
PRESS2:
	.word	159,8,0,0
	.long	>2D10480
	.long	SCOREPAL
MISN1:
	.word	68,18,0,0
	.long	>2D12C80
	.long	SCOREPAL
TCWAY:
	.word	90,33,0,0
	.long	>2D152C0
	.long	SCOREPAL
LOSSWAY:
	.word	98,28,0,0
	.long	>2D1B1A0
	.long	SCOREPAL
PHD2A:
	.word	87,41,0,0
	.long	>2D20920
	.long	SCOREPAL
BXTOP:
	.word	123,28,0,0
	.long	>2D279E0
	.long	SCOREPAL
BXMID:
	.word	123,60,0,0
	.long	>2D2E660
	.long	SCOREPAL
MISN2:
	.word	70,18,0,0
	.long	>2D3CEE0
	.long	SCOREPAL
MISN3:
	.word	70,18,0,0
	.long	>2D3F760
	.long	SCOREPAL
YOUARE:
	.word	63,32,0,0
	.long	>2D41FE0
	.long	SCOREPAL
PAINFUL:
	.word	123,32,0,0
	.long	>2D45FE0
	.long	SCOREPAL
ORCUS:
	.word	104,22,0,0
	.long	>2D4DBE0
	.long	SCOREPAL
YOUARE2:
	.word	68,32,0,0
	.long	>2D52360
	.long	SCOREPAL
LV0:
	.word	15,9,0,0
	.long	>2D56760
	.long	SCOREPAL
LV1:
	.word	15,9,0,0
	.long	>2D56BE0
	.long	SCOREPAL
LV2:
	.word	15,9,0,0
	.long	>2D57060
	.long	SCOREPAL
LV3:
	.word	15,9,0,0
	.long	>2D574E0
	.long	SCOREPAL
LV4:
	.word	15,9,0,0
	.long	>2D57960
	.long	SCOREPAL
LV5:
	.word	15,9,0,0
	.long	>2D57DE0
	.long	SCOREPAL
LV6:
	.word	15,9,0,0
	.long	>2D58260
	.long	SCOREPAL
LV7:
	.word	15,9,0,0
	.long	>2D586E0
	.long	SCOREPAL
LV8:
	.word	15,9,0,0
	.long	>2D58B60
	.long	SCOREPAL
LV9:
	.word	15,9,0,0
	.long	>2D58FE0
	.long	SCOREPAL
BMB0:
	.word	30,10,0,0
	.long	>2D59460
	.long	SCOREPAL
BMB1:
	.word	30,10,0,0
	.long	>2D59E60
	.long	SCOREPAL
BMB2:
	.word	30,10,0,0
	.long	>2D5A860
	.long	SCOREPAL
BMB3:
	.word	30,10,0,0
	.long	>2D5B260
	.long	SCOREPAL
BMB4:
	.word	30,10,0,0
	.long	>2D5BC60
	.long	SCOREPAL
BMB5:
	.word	30,10,0,0
	.long	>2D5C660
	.long	SCOREPAL
BMB6:
	.word	30,10,0,0
	.long	>2D5D060
	.long	SCOREPAL
BMB7:
	.word	30,10,0,0
	.long	>2D5DA60
	.long	SCOREPAL
BMB8:
	.word	30,10,0,0
	.long	>2D5E460
	.long	SCOREPAL
BMB9:
	.word	30,10,0,0
	.long	>2D5EE60
	.long	SCOREPAL
PRESS:
	.word	34,18,0,0
	.long	>2D5F860
INSERT:
	.word	39,18,0,0
	.long	>2D60CA0
TIMES:
	.word	6,5,0,0
	.long	>2D62320
DCLR:
	.word	95,11,0,0
	.long	>2D85F80
	.long	DIAGP
FIEND1:
	.word	23,40,16,-8
	.long	>2D88080
	.long	FNDP
SHAD1:
	.word	17,11,9,-41
	.long	>2D89E80
	.long	FNDP
FNDSIT:
	.word	29,24,1,-46
	.long	>2D8A560
	.long	FNDP
FNDSITB:
	.word	29,24,1,-46
	.long	>2D8A560
	.long	FNDPRED
FNDSITC:
	.word	29,24,1,-46
	.long	>2D8A560
	.long	FNDPBLU
FNDSITD:
	.word	29,24,1,-46
	.long	>2D8A560
	.long	FNDPGRN
FNDSITE:
	.word	29,24,1,-46
	.long	>2D8A560
	.long	FNDPPUR
FNDJUMP12C1:
	.word	28,51,13,1
	.long	>2D8BD60
FNDJUMP12C2:
	.word	29,55,13,2
	.long	>2D8EA00
FNDJUMP6C1:
	.word	28,50,14,0
	.long	>2D92100
FNDJUMP6C2:
	.word	30,57,15,2
	.long	>2D94CC0
FIEND2:
	.word	21,40,13,-8
	.long	>2D985C0
FIEND3:
	.word	24,40,13,-8
	.long	>2D9A3C0
FIEND4:
	.word	23,40,14,-8
	.long	>2D9C1C0
FIEND5:
	.word	24,40,14,-8
	.long	>2D9DFC0
FIEND6:
	.word	24,41,13,-8
	.long	>2D9FDC0
FIEND7:
	.word	22,40,13,-8
	.long	>2DA1C80
FNSTND6:
	.word	26,46,14,-8
	.long	>2DA3A80
FNSTND7:
	.word	20,42,11,-8
	.long	>2DA62C0
FNSTND9:
	.word	17,42,7,-8
	.long	>2DA7D00
FNSTND12:
	.word	23,42,11,-9
	.long	>2DA9740
FSQUAT6:
	.word	36,45,19,-9
	.long	>2DAB6C0
FSQUAT6A:
	.word	33,43,17,-11
	.long	>2DAE960
FSQUAT7:
	.word	24,45,12,-9
	.long	>2DB19C0
FSQUAT7A:
	.word	26,42,12,-9
	.long	>2DB3B80
FSQUAT9:
	.word	18,44,8,-9
	.long	>2DB6040
FSQUAT9A:
	.word	19,43,9,-10
	.long	>2DB7BC0
FSQUAT10:
	.word	23,43,13,-11
	.long	>2DB96A0
FSQUAT10A:
	.word	23,42,13,-12
	.long	>2DBB6E0
FSQUAT12A:
	.word	27,39,13,-12
	.long	>2DBD660
FNSTND10:
	.word	18,45,10,-9
	.long	>2DBF880
FJUMP6A:
	.word	31,45,16,-9
	.long	>2DC14A0
FJUMP6B:
	.word	31,43,16,-11
	.long	>2DC41A0
FJUMP6C:
	.word	25,44,13,-2
	.long	>2DC6CA0
FJUMP12A:
	.word	27,41,13,-10
	.long	>2DC9320
FJUMP12B:
	.word	29,39,14,-11
	.long	>2DCB700
FJUMP12C:
	.word	23,44,11,-2
	.long	>2DCDE00
CLD1:
	.word	9,9,4,4
	.long	>2EF2640
	.long	BLUBOOM
CLD1A:
	.word	9,9,4,4
	.long	>2EF2640
	.long	GREYPAL
OKBM1:
	.word	12,11,6,5
	.long	>2EF29A0
	.long	RDBOOM
BBS1:
	.word	4,5,1,2
	.long	>2EF2DC0
	.long	RDBOOM
OKBM2:
	.word	22,22,11,11
	.long	>2EF2E60
OKBM3:
	.word	33,32,16,16
	.long	>2EF3EE0
OKBM4:
	.word	34,34,18,18
	.long	>2EF62E0
OKBM5:
	.word	34,34,17,18
	.long	>2EF8920
OKBM6:
	.word	31,29,16,14
	.long	>2EFAF60
OKBM7:
	.word	30,30,16,15
	.long	>2EFCC60
BBS2:
	.word	6,7,2,3
	.long	>2EFEA60
BBS3:
	.word	11,9,5,4
	.long	>2EFEC20
BBS4:
	.word	17,13,7,5
	.long	>2EFEF80
BBS5:
	.word	26,21,12,9
	.long	>2EFF7A0
CLD2:
	.word	25,29,12,15
	.long	>2F00A00
CLD3:
	.word	29,32,15,17
	.long	>2F02360
CLD4:
	.word	25,31,13,18
	.long	>2F04360
CLD4A:
	.word	28,37,14,26
	.long	>2F05E80
CLD4B:
	.word	32,38,17,29
	.long	>2F07EE0
CLD5:
	.word	36,34,19,30
	.long	>2F0A4E0
CLD6:
	.word	36,36,20,32
	.long	>2F0CB20
CLD7:
	.word	36,36,20,32
	.long	>2F0F3A0
CLD8:
	.word	32,32,18,31
	.long	>2F11C20
CLD9:
	.word	30,29,17,28
	.long	>2F13C20
CLD10:
	.word	29,30,15,29
	.long	>2F15920
CLD11:
	.word	29,30,16,29
	.long	>2F17720
bldclt1:
	.word	3,4,0,-20
	.long	>2F19520
bldclt2:
	.word	4,5,1,-20
	.long	>2F195A0
bldclt3:
	.word	8,9,2,-19
	.long	>2F19640
bldclt4:
	.word	14,15,3,-17
	.long	>2F19880
bldclt5:
	.word	20,21,6,-14
	.long	>2F1A000
bldclt6:
	.word	20,22,6,-13
	.long	>2F1AD20
bldclt7:
	.word	26,28,8,-11
	.long	>2F1BAE0
bldclt8:
	.word	33,30,13,-10
	.long	>2F1D360
rblot9:
	.word	8,6,3,-21
	.long	>2F1F520
rblot10:
	.word	7,5,3,-22
	.long	>2F1F6A0
rblot1:
	.word	3,4,1,-22
	.long	>2F1F7E0
rblot2:
	.word	5,6,2,-22
	.long	>2F1F860
rblot3:
	.word	12,8,6,-22
	.long	>2F1F9E0
rblot4:
	.word	12,13,6,-19
	.long	>2F1FCE0
rblot5:
	.word	9,16,4,-17
	.long	>2F201C0
rblot6:
	.word	10,15,5,-17
	.long	>2F207C0
rblot7:
	.word	13,10,6,-19
	.long	>2F20D60
rblot8:
	.word	10,5,5,-22
	.long	>2F21260
XPLD1:
	.word	58,56,30,29
	.long	>2F21440
	.long	RDBOOM
X1BLU:
	.word	58,56,30,29
	.long	>2F21440
	.long	BLUBOOM
X1GRN:
	.word	58,56,30,29
	.long	>2F21440
	.long	GRNBOOM
GNFR1:
	.word	25,25,12,13
	.long	>2F27D40
	.long	RDBOOM
LFLM1:
	.word	26,52,13,-8
	.long	>2F29320
	.long	RDBOOM
FLM1:
	.word	48,61,29,-20
	.long	>2F2C0A0
	.long	RDBOOM
JTFLM1:
	.word	31,30,19,-12
	.long	>2F31C20
	.long	BLUBOOM
XPLD2:
	.word	69,66,35,37
	.long	>2F477A0
XPLD3:
	.word	83,81,42,54
	.long	>2F50C20
XPLD4:
	.word	88,88,45,63
	.long	>2F5E0C0
XPLD5:
	.word	87,87,45,69
	.long	>2F6D2C0
XPLD6:
	.word	86,85,43,71
	.long	>2F7C200
XPLD7:
	.word	87,84,44,80
	.long	>2F8ABC0
XPLD8:
	.word	87,84,42,85
	.long	>2F992C0
XPLD9:
	.word	85,79,42,87
	.long	>2FA79C0
XPLD10:
	.word	75,65,37,85
	.long	>2FB5300
LFLM2:
	.word	35,54,13,-6
	.long	>2FBED60
LFLM3:
	.word	31,64,12,4
	.long	>2FC2A20
LFLM4:
	.word	33,62,12,3
	.long	>2FC6A20
LFLM5:
	.word	35,63,15,4
	.long	>2FCAFE0
LFLM6:
	.word	29,64,15,5
	.long	>2FCF6C0
JTFLM2:
	.word	27,22,15,-16
	.long	>2FD36C0
FLM2:
	.word	65,64,32,-17
	.long	>2FD4A00
FLM3:
	.word	55,71,32,-10
	.long	>2FDD200
FLM4:
	.word	60,68,30,-13
	.long	>2FE4E40
FLM5:
	.word	63,69,33,-12
	.long	>2FECDC0
FLM6:
	.word	53,71,35,-11
	.long	>2FF57C0
GNFR2:
	.word	19,20,9,10
	.long	>2FFD400
GNFR3:
	.word	12,12,6,6
	.long	>2FFE080
PLFR1:
	.word	38,52,20,5
	.long	>2FFE500
PLFR2:
	.word	31,61,18,14
	.long	>3002600
PLFR3:
	.word	30,67,18,20
	.long	>3006300
PLFR4:
	.word	31,66,18,19
	.long	>300A600
PLFR5:
	.word	30,75,18,28
	.long	>300E800
PLFR6:
	.word	30,68,18,21
	.long	>3013300
PLFR7:
	.word	30,57,18,10
	.long	>3017700
PLFR8:
	.word	32,39,20,-8
	.long	>301B000
PLFR9:
	.word	32,36,21,-11
	.long	>301D700
PLFR10:
	.word	32,31,22,-16
	.long	>301FB00
PLFR11:
	.word	31,28,24,-18
	.long	>3021A00
PLFR12:
	.word	30,27,25,-22
	.long	>3023600
PLFR13:
	.word	30,27,25,-26
	.long	>3025100
PLFR14:
	.word	38,34,33,-28
	.long	>3026C00
PLFR15:
	.word	47,34,42,-36
	.long	>3029680
PLFR16:
	.word	46,41,41,-29
	.long	>302C980
PLFR17:
	.word	46,46,41,-24
	.long	>3030700
PLFR18:
	.word	44,51,41,-18
	.long	>3034C00
PLFR19:
	.word	40,56,38,-13
	.long	>3039220
PLFR20:
	.word	39,60,38,-6
	.long	>303D820
PLFR21:
	.word	37,57,37,0
	.long	>3042320
PLFR22:
	.word	37,58,37,7
	.long	>3046A60
PLFR23:
	.word	37,56,37,12
	.long	>304B2E0
PLFR24:
	.word	1,33,17,15
	.long	>304F8E0
PLFR25:
	.word	1,21,17,17
	.long	>304FD00
IPIECE:
	.word	72,20,73,-29
	.long	>304FFA0
	.long	PLLT
IPC2:
	.word	23,17,41,-32
	.long	>3052CA0
	.long	PLLT
TPHD:
	.word	47,23,48,-6
	.long	>3053960
	.long	PLLT
UPPRJAW:
	.word	72,36,73,-49
	.long	>3055BE0
	.long	PLLT
INNRMTH:
	.word	72,28,73,-59
	.long	>305ACE0
	.long	PLLT
CHK1:
	.word	19,42,92,-45
	.long	>305EBE0
	.long	PLLT
CHK2:
	.word	19,42,92,-45
	.long	>3060620
	.long	PLLT
CHK3:
	.word	19,42,92,-45
	.long	>3062060
	.long	PLLT
CHK3A:
	.word	8,31,81,-87
	.long	>3063AA0
	.long	PLLT
CHK2A:
	.word	6,23,79,-87
	.long	>3064260
	.long	PLLT
SOLDR1:
	.word	91,111,43,-20
	.long	>3064820
	.long	SOLDB
BOD1:
	.word	91,80,92,-87
	.long	>3078740
	.long	PLLT
BOD1A:
	.word	91,80,43,-5
	.long	>3078740
	.long	PLLT
BOD2:
	.word	55,95,147,-72
	.long	>3086D40
	.long	PLLT
BOD2A:
	.word	55,95,31,-5
	.long	>3086D40
	.long	PLLT
BTTMJAW:
	.word	72,80,73,-64
	.long	>3091380
	.long	PLLT
BTJ2:
	.word	72,80,73,-83
	.long	>3091380
	.long	PLLT
BTJ3:
	.word	72,80,73,-90
	.long	>3091380
	.long	PLLT
SOLDR3:
	.word	60,48,28,-6
	.long	>309C780
SOLDR4:
	.word	50,75,54,-35
	.long	>30A2180
IPC3:
	.word	23,17,41,-32
	.long	>30A9B60
IPC4:
	.word	23,17,41,-32
	.long	>30AA820
IPC5:
	.word	23,17,41,-32
	.long	>30AB4E0
IPC1A:
	.word	23,17,41,-32
	.long	>30AC1A0
IRAQMAP1:
	.word	158,190,0,0
	.long	>30ACE60
	.long	MAPP
IRAQMAP2:
	.word	217,190,0,0
	.long	>30E8460
	.long	MAPP
MISSION1:
	.word	78,132,0,0
	.long	>3139EA0
	.long	MAPP
MISSION2:
	.word	78,132,0,0
	.long	>314E8A0
	.long	MAPP
MISSION3:
	.word	84,95,0,0
	.long	>31632A0
	.long	MAPP
POINTER:
	.word	68,38,0,0
	.long	>3172C00
	.long	DOMEP
PDOME:
	.word	44,29,0,0
	.long	>3177CC0
	.long	DOMEP
DPC2:
	.word	79,63,0,0
	.long	>317A4A0
	.long	DISHPAL
DPC3:
	.word	25,33,0,0
	.long	>3184220
	.long	DISHPAL
DPC4:
	.word	89,79,0,0
	.long	>3185F00
T72BLAST1:
	.word	21,22,10,-3
	.long	>3194220
	.long	TNKPAL
FNDGUN9A:
	.word	56,25,48,-23
	.long	>31952A0
	.long	TNKPAL
T72TURET1:
	.word	8,74,3,-72
	.long	>3197E60
	.long	TNKPAL
TNKTRED1:
	.word	9,97,44,-17
	.long	>31990E0
	.long	TNKPAL
TNKTRED1A:
	.word	30,8,45,-114
	.long	>319B540
	.long	TNKPAL
TNKSHAD1:
	.word	97,17,40,-112
	.long	>319BD40
	.long	TNKPAL
TNKSHAD2:
	.word	14,91,-9,-41
	.long	>319F260
	.long	TNKPAL
TNKBUL:
	.word	5,21,0,0
	.long	>31A1FE0
	.long	TNKPAL
GUNBUL:
	.word	10,9,5,4
	.long	>31A2520
	.long	TNKPAL
T72TNK:
	.word	80,104,39,-10
	.long	>31A2880
	.long	TNKPAL
T72BLAST2:
	.word	30,31,14,-3
	.long	>31B2C80
	.long	TNKPAL
ABLST1:
	.word	21,17,11,8
	.long	>31B4B80
	.long	TNKPAL
T72BLAST3:
	.word	49,44,24,-4
	.long	>31B5840
T72BLAST4:
	.word	48,41,24,-5
	.long	>31B9FC0
T72BLAST5:
	.word	47,40,23,-5
	.long	>31BDD40
T72BLAST6:
	.word	47,38,24,-5
	.long	>31C1940
T72BLAST7:
	.word	46,38,23,-5
	.long	>31C5240
ABLST3:
	.word	49,44,25,22
	.long	>31B5840
ABLST4:
	.word	48,41,26,22
	.long	>31B9FC0
ABLST5:
	.word	47,40,24,22
	.long	>31BDD40
ABLST6:
	.word	47,38,23,21
	.long	>31C1940
ABLST7:
	.word	46,38,25,21
	.long	>31C5240
T72BLAST8:
	.word	46,38,23,-5
	.long	>31C8B40
ABLST2:
	.word	30,25,15,13
	.long	>31CC440
FNDGUN10A:
	.word	56,30,47,-17
	.long	>31CDD40
FNDGUN10B:
	.word	64,36,55,-11
	.long	>31D11C0
FNDGUN115A:
	.word	33,46,19,-1
	.long	>31D59C0
FNDGUN115B:
	.word	41,56,26,9
	.long	>31D8D80
FNDGUN11A:
	.word	43,45,33,-2
	.long	>31DDA80
FNDGUN11B:
	.word	47,49,37,2
	.long	>31E1860
FNDGUN12A:
	.word	25,47,13,0
	.long	>31E61E0
FNDGUN12B:
	.word	29,55,15,8
	.long	>31E8B00
FNDGUN6A:
	.word	30,53,15,-23
	.long	>31EC200
FNDGUN6B:
	.word	28,60,14,-23
	.long	>31EF700
FNDGUN7A:
	.word	32,48,22,-23
	.long	>31F2B80
FNDGUN7B:
	.word	37,55,27,-23
	.long	>31F5B80
FNDGUN85A:
	.word	55,34,44,-23
	.long	>31FA040
FNDGUN85B:
	.word	62,39,51,-23
	.long	>31FDBC0
FNDGUN8A:
	.word	44,43,35,-23
	.long	>32029C0
FNDGUN8B:
	.word	51,50,42,-23
	.long	>32064E0
FNDGUN9B:
	.word	67,26,59,-23
	.long	>320B620
T72TNK2:
	.word	100,112,45,-11
	.long	>320ED60
T72TURET2:
	.word	8,67,3,-72
	.long	>3224B60
TNKTRED2:
	.word	9,97,44,-17
	.long	>3225C20
TNKTRED2A:
	.word	30,8,45,-114
	.long	>3228080

	.include BGNDTBL.GLO
