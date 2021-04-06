	.FILE 'imgtbl.asm'
	.OPTION B,D,L,T

	.include imgtbl.glo
	.DATA
	.even
ARPRT9:
	.word	30,61,0,0
	.long	>27C80E0
	.long	ARPRTPL
GBUL12:
	.word	9,14,4,6
	.long	>27CBDE0
	.long	FING1
GBUL115:
	.word	9,12,4,5
	.long	>27CC320
	.long	FING1
GBUL11:
	.word	11,11,5,5
	.long	>27CC7A0
	.long	FING1
GBUL10:
	.word	13,10,6,5
	.long	>27CCBC0
	.long	FING1
GBUL9:
	.word	15,7,7,3
	.long	>27CD0C0
	.long	FING1
GBUL85:
	.word	13,10,6,5
	.long	>27CD440
	.long	FING1
GBUL8:
	.word	11,11,5,5
	.long	>27CD940
	.long	FING1
GBUL7:
	.word	9,12,4,6
	.long	>27CDD60
	.long	FING1
GBUL6:
	.word	9,14,4,8
	.long	>27CE1E0
	.long	FING1
PTGNR1:
	.word	30,61,15,-9
	.long	>27CE720
	.long	FING1
GNNRBUL12:
	.word	3,14,1,7
	.long	>27D2420
	.long	FING1
GNNRBUL115:
	.word	7,12,3,6
	.long	>27D25E0
	.long	FING1
GNNRBUL11:
	.word	10,9,5,4
	.long	>27D28E0
	.long	FING1
GNNRBUL10:
	.word	14,8,8,4
	.long	>27D2C40
	.long	FING1
GNNRBUL9:
	.word	15,3,8,1
	.long	>27D3040
	.long	FING1
GNNRBUL85:
	.word	14,8,8,3
	.long	>27D31C0
	.long	FING1
GNNRBUL8:
	.word	10,9,5,4
	.long	>27D35C0
	.long	FING1
GNNRBUL7:
	.word	7,12,4,4
	.long	>27D3920
	.long	FING1
GNNRBUL6:
	.word	3,14,1,6
	.long	>27D3C20
	.long	FING1
PTGNR2:
	.word	36,60,19,-8
	.long	>27D3DE0
PTGNR3:
	.word	49,54,29,-7
	.long	>27D8160
PTGNR4:
	.word	60,42,36,-11
	.long	>27DD920
PTGNR5:
	.word	70,39,39,-22
	.long	>27E27E0
PTGNR6:
	.word	58,50,31,-15
	.long	>27E7FA0
PTGNR7:
	.word	50,55,23,-10
	.long	>27EDD60
PTGNR8:
	.word	39,61,15,-6
	.long	>27F36C0
PTGNR9:
	.word	29,63,15,-5
	.long	>27F8300
CLIFF2A:
	.word	57,48,0,0
	.long	>27FC200
	.long	DESRTPL
CLIFF3A:
	.word	60,55,0,0
	.long	>2801C00
	.long	DESRTPL
GUNPIT2:
	.word	75,89,0,0
	.long	>280BDA0
VGUNPIT2:
	.word	65,63,0,0
	.long	>2819100
WARP:
	.word	142,53,0,0
	.long	>28216E0
	.long	WARPP
ARW2:
	.word	9,5,0,0
	.long	>2830560
	.long	WARPP
SPIN1:
	.word	31,28,0,0
	.long	>2830740
	.long	WARPP
WTIMER1:
	.word	5,7,0,0
	.long	>2832340
	.long	WARPP
OTHERP:
	.word	5,7,0,0
	.long	>2832340
	.long	WARPP2
VBOLT1:
	.word	16,97,8,47
	.long	>2AD79C0
	.long	KRACK
VBOLT2:
	.word	15,90,6,42
	.long	>2ADAA40
	.long	KRACK
VBOLT3:
	.word	15,91,6,41
	.long	>2ADD740
	.long	KRACK
OGUNBUL:
	.word	10,9,5,4
	.long	>2AE04C0
	.long	AHMEDP
EXPL1:
	.word	8,8,4,3
	.long	>2AE0820
	.long	EORNGPAL
EXPL2:
	.word	20,20,10,9
	.long	>2AE0A20
EXPL3:
	.word	30,28,15,13
	.long	>2AE16A0
EXPL4:
	.word	35,31,18,15
	.long	>2AE32A0
EXPL5:
	.word	43,41,20,20
	.long	>2AE5580
EXPL6:
	.word	50,55,24,25
	.long	>2AE8DE0
EXPL7:
	.word	62,56,31,28
	.long	>2AEE740
EXPL8:
	.word	69,62,35,30
	.long	>2AF5740
EXPL9:
	.word	67,57,34,27
	.long	>2AFE2C0
EXPL10:
	.word	55,46,29,22
	.long	>2B05BE0
EXPL11:
	.word	54,47,27,22
	.long	>2B0AC60
EXPL12:
	.word	54,47,27,24
	.long	>2B0FEA0
MTNK10:
	.word	50,38,20,8
	.long	>2B150E0
	.long	MTNKP
RTNK:
	.word	50,38,20,8
	.long	>2B150E0
	.long	MTNKP2
ANT:
	.word	5,29,0,0
	.long	>2B18EA0
	.long	MTNKP
MTNK11:
	.word	49,36,22,11
	.long	>2B195E0
	.long	MTNKP
MTNK12:
	.word	37,36,14,12
	.long	>2B1D060
	.long	MTNKP
MTNK12B:
	.word	37,36,14,12
	.long	>2B1FD60
	.long	MTNKP
MTNK6:
	.word	37,36,15,8
	.long	>2B22A60
	.long	MTNKP
MTNK6B:
	.word	37,36,15,8
	.long	>2B25760
	.long	MTNKP
MTNK7:
	.word	45,37,19,7
	.long	>2B28460
	.long	MTNKP
MTNK8:
	.word	45,36,21,8
	.long	>2B2BBE0
	.long	MTNKP
MTNK9:
	.word	41,34,18,8
	.long	>2B2F1E0
	.long	MTNKP
MTNK9B:
	.word	41,34,18,8
	.long	>2B320A0
	.long	MTNKP
BTR60:
	.word	182,98,64,-35
	.long	>2B34F60
	.long	BTRP
TURT12:
	.word	29,66,14,-7
	.long	>2B582E0
	.long	BTRP
BTIRE1:
	.word	37,36,18,26
	.long	>2B5C4E0
	.long	BTRP
SCUD1:
	.word	228,106,87,-29
	.long	>2B5F1E0
	.long	SCUDP
MISSLE:
	.word	201,56,48,-10
	.long	>2B8E520
	.long	SCUDP
TURT9:
	.word	59,33,44,-40
	.long	>2BA4A20
	.long	BTRP
SCUD2:
	.word	19,12,0,-17
	.long	>2BA8800
	.long	SCUDP
BTRECK:
	.word	182,98,64,-35
	.long	>2BA8F80
BTIRE2:
	.word	37,36,18,26
	.long	>2BCC300
TURT12A:
	.word	29,47,14,-26
	.long	>2BCF000
TURT11:
	.word	37,60,22,-13
	.long	>2BD1F00
TURT11A:
	.word	29,44,13,-29
	.long	>2BD6A00
TURT10:
	.word	48,54,33,-19
	.long	>2BD9600
TURT10A:
	.word	33,39,18,-34
	.long	>2BDE700
TURT9A:
	.word	44,33,29,-40
	.long	>2BE12E0
TURT9B:
	.word	54,43,39,-30
	.long	>2BE4040
TURT9BA:
	.word	38,36,23,-37
	.long	>2BE8B80
TURT8:
	.word	57,36,42,-40
	.long	>2BEB880
TURT8A:
	.word	41,33,26,-40
	.long	>2BEFC00
TURT7:
	.word	49,49,34,-40
	.long	>2BF2960
TURT7A:
	.word	37,37,22,-40
	.long	>2BF7900
TURT6:
	.word	29,62,14,-40
	.long	>2BFA740
TURT6A:
	.word	29,48,14,-40
	.long	>2BFE540
TURT6B:
	.word	37,58,22,-40
	.long	>2C01540
TURT6BA:
	.word	30,44,15,-40
	.long	>2C05DC0
DOC1:
	.word	18,37,8,-9
	.long	>2C089C0
	.long	PPLP
BM1:
	.word	5,11,2,-30
	.long	>2C0A0E0
	.long	PPLP
NSDR1:
	.word	19,38,9,-7
	.long	>2C0A3A0
	.long	PPLP
BGRL1:
	.word	15,38,8,-11
	.long	>2C0BB60
	.long	PPLP
GN1:
	.word	17,38,9,-11
	.long	>2C0CE60
	.long	PPLP
SLUD1:
	.word	12,8,4,3
	.long	>2C0E620
	.long	PPLP
GRL1:
	.word	12,34,6,-5
	.long	>2C0E920
	.long	PPLP
NSDRRUN1:
	.word	15,32,9,-7
	.long	>2C0F5E0
	.long	PPLP
PILOT1:
	.word	16,33,0,0
	.long	>2C105E0
	.long	PPLP
BABE1:
	.word	25,31,12,4
	.long	>2C11660
	.long	PPLP
REPO1:
	.word	28,40,13,-12
	.long	>2C13180
	.long	PPLP
SHCAKLDD1:
	.word	30,42,13,-12
	.long	>2C15480
	.long	PPLP
SHCAKLDD2:
	.word	30,43,13,-11
	.long	>2C17E80
	.long	PPLP
SHCAKLDD3:
	.word	30,45,13,-9
	.long	>2C1A980
	.long	PPLP
SHCAKLDE1:
	.word	23,41,11,-11
	.long	>2C1D680
	.long	PPLP
SHCAKLDF1:
	.word	24,40,12,-10
	.long	>2C1F540
	.long	PPLP
SHACKX1:
	.word	24,39,8,-12
	.long	>2C21340
	.long	PPLP
SHACKX2:
	.word	29,39,13,-12
	.long	>2C23080
	.long	PPLP
SHACKX3:
	.word	26,39,10,-12
	.long	>2C25780
	.long	PPLP
SECBON:
	.word	41,18,0,0
	.long	>2C279A0
	.long	PPLP
SHACKY1:
	.word	25,38,9,-13
	.long	>2C29260
	.long	PPLP
SHACKY2:
	.word	38,38,17,-13
	.long	>2C2B3A0
	.long	PPLP
SHACKY3:
	.word	28,41,12,-10
	.long	>2C2E320
	.long	PPLP
BIGBONE:
	.word	66,25,38,17
	.long	>2C30700
	.long	PPLP
PTS1:
	.word	36,19,19,-14
	.long	>2C33C20
PTS2:
	.word	36,19,19,-14
	.long	>2C35180
PTS3:
	.word	36,19,19,-14
	.long	>2C366E0
PTS4:
	.word	36,19,19,-14
	.long	>2C37C40
PTS5:
	.word	36,19,19,-14
	.long	>2C391A0
PTS6:
	.word	36,19,19,-14
	.long	>2C3A700
PTS7:
	.word	36,19,19,-14
	.long	>2C3BC60
PTS8:
	.word	36,19,19,-14
	.long	>2C3D1C0
PTS9:
	.word	36,19,19,-14
	.long	>2C3E720
PTS10:
	.word	36,19,19,-14
	.long	>2C3FC80
BABE2:
	.word	26,32,12,5
	.long	>2C411E0
BABE3:
	.word	23,32,11,4
	.long	>2C42DE0
BABE4:
	.word	25,31,12,4
	.long	>2C445E0
DOC2:
	.word	23,37,11,-9
	.long	>2C46100
DOC3:
	.word	24,37,12,-9
	.long	>2C47CC0
DOC4:
	.word	24,37,12,-9
	.long	>2C49880
BM2:
	.word	11,22,5,-25
	.long	>2C4B440
BM3:
	.word	15,29,7,-20
	.long	>2C4BC80
BM4:
	.word	19,34,9,-17
	.long	>2C4CB00
BM5:
	.word	19,46,9,-11
	.long	>2C4E040
BM6:
	.word	19,46,9,-10
	.long	>2C4FD00
BM7:
	.word	19,46,9,-10
	.long	>2C519C0
BM8:
	.word	19,46,9,-10
	.long	>2C53680
BM9:
	.word	19,46,9,-10
	.long	>2C55340
BM10:
	.word	17,46,9,-10
	.long	>2C57000
NSDR2:
	.word	20,38,10,-7
	.long	>2C58CC0
NSDR3:
	.word	20,37,10,-8
	.long	>2C5A480
NSDR4:
	.word	19,36,9,-8
	.long	>2C5BBA0
NSDR8:
	.word	19,38,9,-7
	.long	>2C5D220
NSDR9:
	.word	20,38,10,-7
	.long	>2C5E9E0
SWAVE1:
	.word	19,42,9,-3
	.long	>2C601A0
SWAVE2:
	.word	19,40,9,-5
	.long	>2C61BE0
SWAVE3:
	.word	24,38,12,-7
	.long	>2C634E0
BGRL2:
	.word	24,36,12,-13
	.long	>2C65160
BGRL3:
	.word	15,37,8,-12
	.long	>2C66C60
GN2:
	.word	18,38,9,-11
	.long	>2C67EE0
GN3:
	.word	18,38,9,-11
	.long	>2C696A0
GN4:
	.word	18,38,9,-11
	.long	>2C6AE60
GN5:
	.word	18,38,9,-11
	.long	>2C6C620
GN6:
	.word	18,38,9,-11
	.long	>2C6DDE0
SLUD2:
	.word	9,11,3,4
	.long	>2C6F5A0
SLUD3:
	.word	12,10,5,5
	.long	>2C6F9C0
SLUD4:
	.word	15,9,8,4
	.long	>2C6FD80
SLUD5:
	.word	13,11,4,6
	.long	>2C70200
SLUD6:
	.word	11,8,4,3
	.long	>2C70780
GRL2:
	.word	13,34,6,-5
	.long	>2C70A80
GRL3:
	.word	13,33,5,-6
	.long	>2C71B80
GRL4:
	.word	12,33,4,-6
	.long	>2C72C00
SLMD1:
	.word	8,7,3,2
	.long	>2C73860
SLMD2:
	.word	11,14,5,4
	.long	>2C73A20
SLMD3:
	.word	16,23,7,6
	.long	>2C73F60
SLMD4:
	.word	17,27,7,6
	.long	>2C74AE0
NSDRRUN2:
	.word	18,32,9,-7
	.long	>2C75BC0
NSDRRUN3:
	.word	17,32,8,-7
	.long	>2C76FC0
NSDRRUN4:
	.word	16,33,8,-7
	.long	>2C783C0
PILOT2:
	.word	16,32,0,0
	.long	>2C79440
PILOT3:
	.word	16,32,0,0
	.long	>2C7A440
PILOT4:
	.word	16,33,0,0
	.long	>2C7B440
SCHAKLDA1:
	.word	25,43,9,-8
	.long	>2C7C4C0
SCHAKLDA2:
	.word	27,40,11,-11
	.long	>2C7EA60
SCHAKLDA3:
	.word	25,38,9,-13
	.long	>2C80D60
SCHAKLDB1:
	.word	27,40,11,-11
	.long	>2C82EA0
SCHAKLDB2:
	.word	24,40,8,-11
	.long	>2C851A0
SCHAKLDB3:
	.word	25,40,9,-11
	.long	>2C86FA0
SCHAKLDB4:
	.word	24,40,8,-11
	.long	>2C892A0
SHCAKLDC1:
	.word	25,41,9,-14
	.long	>2C8B0A0
SHCAKLDC2:
	.word	25,41,9,-14
	.long	>2C8D480
SHCAKLDC3:
	.word	29,41,13,-14
	.long	>2C8F860
SHCAKLDC4:
	.word	23,41,7,-14
	.long	>2C92160
BLLN1:
	.word	21,29,0,0
	.long	>2C94020
	.long	BLLNP5
BLLN2:
	.word	22,29,0,0
	.long	>2C955E0
	.long	BLLNP5
BLLN3:
	.word	23,21,0,0
	.long	>2C96BA0
	.long	BLLNP5
SQUAD:
	.word	115,23,0,0
	.long	>2C97B60
	.long	BLLNP3
GSCOTT:
	.word	65,25,0,0
	.long	>2C9CEC0
	.long	BLLNP5
BOON1:
	.word	73,59,0,0
	.long	>2CA03E0
	.long	BLLNP5
BOON2:
	.word	33,15,0,0
	.long	>2CA9000
	.long	BLLNP5
BOON2B:
	.word	23,35,0,0
	.long	>2CAA0E0
	.long	BLLNP5
DARM1:
	.word	134,60,107,-20
	.long	>2CB0080
	.long	DHNDP
THUMB:
	.word	41,29,-43,10
	.long	>2CBFF80
	.long	DHNDP
DHND1:
	.word	122,60,-27,-19
	.long	>2CC2760
	.long	DHNDP
DHND2:
	.word	86,61,-27,-19
	.long	>2CD0FE0
	.long	DHNDP
CENS1:
	.word	56,71,1,0
	.long	>2CDB7A0
	.long	CENSP
CENS2:
	.word	50,79,0,0
	.long	>2CE33E0
	.long	CENSP
CENS3:
	.word	45,77,1,1
	.long	>2CEB440
	.long	CENSP
CENS4:
	.word	71,78,0,0
	.long	>2CF27C0
	.long	CENSP
VBOX1:
	.word	16,1,8,-27
	.long	>2D55800
	.long	BOXP
HBOX1:
	.word	52,37,27,-9
	.long	>2D55880
	.long	BOXP
VBOX6:
	.word	52,37,27,-9
	.long	>2D594A0
VBOX2:
	.word	22,7,11,-24
	.long	>2D5D0C0
VBOX3:
	.word	27,13,14,-21
	.long	>2D5D600
VBOX4:
	.word	34,19,18,-18
	.long	>2D5E160
VBOX5:
	.word	40,25,21,-15
	.long	>2D5F6C0
HBOX6:
	.word	52,37,27,-9
	.long	>2D61600
HBOX2:
	.word	52,37,27,-9
	.long	>2D65220
HBOX3:
	.word	52,37,27,-9
	.long	>2D68E40
HBOX4:
	.word	52,37,27,-9
	.long	>2D6CA60
HBOX5:
	.word	52,37,27,-9
	.long	>2D70680
PODA:
	.word	11,11,5,5
	.long	>2D742A0
	.long	GOOBP
FLG1:
	.word	35,39,0,0
	.long	>2D746C0
	.long	FRTCLS
GOOBR:
	.word	16,58,0,0
	.long	>2D772A0
	.long	GOOBP
GOOBB:
	.word	68,14,0,0
	.long	>2D78FA0
	.long	GOOBP
RCTRPC1:
	.word	33,44,0,0
	.long	>2D7AD60
	.long	REACTR
RCTRPC2:
	.word	25,52,0,0
	.long	>2D7DEE0
	.long	REACTR
GOOB1:
	.word	6,5,3,2
	.long	>2D80C60
	.long	GOOBP
WSTPOOL:
	.word	58,44,0,0
	.long	>2D80DA0
	.long	GOOBP
RCTR2:
	.word	104,114,0,0
	.long	>2D86020
	.long	REACTR
OPC1:
	.word	8,4,3,1
	.long	>2D9D2A0
	.long	REACTR
FLAG1:
	.word	36,39,0,0
	.long	>2D9D3A0
	.long	GOOBP
GOOB2:
	.word	8,7,4,3
	.long	>2D9FF80
GOOB3:
	.word	10,9,5,4
	.long	>2DA0140
GOOB4:
	.word	12,12,6,6
	.long	>2DA04A0
GOOB5:
	.word	14,14,7,6
	.long	>2DA0920
GOOB6:
	.word	19,19,9,9
	.long	>2DA1020
GOOB7:
	.word	18,20,9,9
	.long	>2DA1C00
GOOB8:
	.word	16,18,9,9
	.long	>2DA2880
GOOB9:
	.word	22,18,11,8
	.long	>2DA3180
GOOB10:
	.word	27,23,13,9
	.long	>2DA3F00
GSLMD1:
	.word	8,8,3,4
	.long	>2DA5320
GSLMD2:
	.word	11,15,5,5
	.long	>2DA5520
GSLMD3:
	.word	16,23,8,7
	.long	>2DA5AC0
GSLMD4:
	.word	17,27,8,7
	.long	>2DA6640
GBLOB1:
	.word	10,9,5,4
	.long	>2DA7720
GBLOB2:
	.word	13,14,6,6
	.long	>2DA7A80
GBLOB3:
	.word	19,16,9,7
	.long	>2DA8180
GBLOB4:
	.word	18,17,9,8
	.long	>2DA8B80
GPOOL1:
	.word	42,44,0,0
	.long	>2DA9620
GPOOL4:
	.word	42,39,0,0
	.long	>2DAD2A0
GPOOL5:
	.word	40,41,0,0
	.long	>2DB0840
FLG2:
	.word	37,39,0,0
	.long	>2DB3B80
FLG3:
	.word	36,39,0,0
	.long	>2DB6C40
FLG4:
	.word	37,39,0,0
	.long	>2DB9820
FLG5:
	.word	37,39,0,0
	.long	>2DBC8E0
BROKN:
	.word	39,59,0,0
	.long	>2DBF9A0
BROKN2:
	.word	32,38,0,0
	.long	>2DC4360
CRT3:
	.word	32,31,0,0
	.long	>2DC6960
OPC2:
	.word	9,6,4,2
	.long	>2DC8860
OPC3:
	.word	13,10,5,4
	.long	>2DC8AA0
OPC4:
	.word	11,15,4,7
	.long	>2DC8FA0
OPC5:
	.word	12,19,5,9
	.long	>2DC9540
OPC6:
	.word	12,25,6,12
	.long	>2DC9C60
OPC7:
	.word	11,15,6,7
	.long	>2DCA5C0
OPC8:
	.word	11,7,5,3
	.long	>2DCAB60
OPC9:
	.word	9,4,4,1
	.long	>2DCAE00
FLAG2:
	.word	38,39,0,0
	.long	>2DCAF80
FLAG3:
	.word	37,39,0,0
	.long	>2DCE040
FLAG4:
	.word	38,39,0,0
	.long	>2DD1100
FLAG5:
	.word	38,39,0,0
	.long	>2DD41C0
CRT1:
	.word	35,42,0,0
	.long	>2DD7280
BRRL2:
	.word	17,28,0,0
	.long	>2DDA1C0
LTRBOX1:
	.word	24,21,0,0
	.long	>2DDB340
	.long	LBOXP1
LTRBOX2:
	.word	24,21,0,0
	.long	>2DDB340
	.long	LBOXP2
DET1:
	.word	12,12,0,0
	.long	>2DDC300
	.long	STUFFP
BMBLETS:
	.word	17,19,0,0
	.long	>2DDC780
	.long	STUFFP
MEP1:
	.word	65,18,0,0
	.long	>2DDD360
	.long	STUFFP
MEP2:
	.word	64,18,0,0
	.long	>2DDF9A0
	.long	STUFFP
RACKBLK:
	.word	46,46,0,0
	.long	>2DE1DA0
	.long	STUFFP
GEMS1:
	.word	39,32,2,-6
	.long	>2DE62A0
	.long	STUFFP
LFTARRW:
	.word	28,31,0,0
	.long	>2DE8AA0
	.long	STUFFP
UPARRW:
	.word	27,28,0,0
	.long	>2DEA5C0
	.long	STUFFP
RGTARRW:
	.word	28,31,0,0
	.long	>2DEBE40
	.long	STUFFP
SPRAY:
	.word	24,21,0,0
	.long	>2DED960
	.long	STUFFP
RING:
	.word	23,13,0,0
	.long	>2DEE920
	.long	STUFFP
PLAYER:
	.word	26,29,0,0
	.long	>2DEF2E0
	.long	STUFFP
KEY:
	.word	32,22,0,0
	.long	>2DF0C40
	.long	STUFFP
NONSTOP:
	.word	27,19,0,0
	.long	>2DF2240
	.long	STUFFP
SMART:
	.word	16,20,0,0
	.long	>2DF32E0
	.long	STUFFP
SHOES:
	.word	36,25,0,0
	.long	>2DF3CE0
	.long	STUFFP
GRENADE:
	.word	38,21,0,0
	.long	>2DF5900
	.long	STUFFP
STAT6:
	.word	64,32,0,0
	.long	>2DF7340
	.long	STATICP
SPDGUN:
	.word	38,20,0,0
	.long	>2DFB340
	.long	STUFFP
FIRE:
	.word	36,22,0,0
	.long	>2DFCC40
	.long	STUFFP
BLADE:
	.word	24,22,0,0
	.long	>2DFE500
	.long	STUFFP
JEM1:
	.word	16,12,6,5
	.long	>2DFF580
	.long	STUFFP
JEM2:
	.word	18,15,8,6
	.long	>2DFFB80
	.long	STUFFP
JEM3:
	.word	17,11,7,4
	.long	>2E004E0
	.long	STUFFP
SHOES2:
	.word	27,22,0,0
	.long	>2E00BC0
	.long	STUFFP
CRS12V1:
	.word	28,83,13,19
	.long	>2E01F00
	.long	STUFFP
XHAIR:
	.word	20,20,0,0
	.long	>2E067A0
	.long	STUFFP
USFLG:
	.word	22,14,0,0
	.long	>2E07420
	.long	STUFFP
MAPBUTN:
	.word	39,20,0,0
	.long	>2E07EA0
	.long	STUFFP
BALL1:
	.word	4,5,1,2
	.long	>2E097A0
	.long	STUFFP
BALL6:
	.word	14,15,7,7
	.long	>2E09840
	.long	STUFFP
SHADW:
	.word	9,7,4,3
	.long	>2E09FC0
	.long	STUFFP
MSLB1:
	.word	28,12,15,5
	.long	>2E0A260
	.long	STUFFP
DET2:
	.word	12,12,0,0
	.long	>2E0ACE0
DET3:
	.word	12,12,0,0
	.long	>2E0B160
BALL2:
	.word	6,7,3,3
	.long	>2E0B5E0
BALL3:
	.word	8,9,4,4
	.long	>2E0B7A0
BALL4:
	.word	10,11,5,5
	.long	>2E0B9E0
BALL5:
	.word	12,13,6,6
	.long	>2E0BE00
BALL7:
	.word	18,19,9,9
	.long	>2E0C2E0
GEMS2:
	.word	39,32,2,-6
	.long	>2E0CEC0
GEMS3:
	.word	39,32,2,-6
	.long	>2E0F6C0
GEMS4:
	.word	39,32,2,-6
	.long	>2E11EC0
STAT1:
	.word	64,32,0,0
	.long	>2E146C0
STAT2:
	.word	64,32,0,0
	.long	>2E186C0
STAT3:
	.word	64,32,0,0
	.long	>2E1C6C0
STAT4:
	.word	64,32,0,0
	.long	>2E206C0
STAT5:
	.word	64,32,0,0
	.long	>2E246C0
JEM1B:
	.word	16,12,6,5
	.long	>2E286C0
JEM1C:
	.word	16,12,6,5
	.long	>2E28CC0
JEM1D:
	.word	19,14,9,7
	.long	>2E292C0
JEM2B:
	.word	18,15,8,6
	.long	>2E29B80
JEM2C:
	.word	18,15,8,6
	.long	>2E2A4E0
JEM2D:
	.word	18,16,8,7
	.long	>2E2AE40
JEM3B:
	.word	17,12,7,5
	.long	>2E2B840
JEM3C:
	.word	17,14,7,7
	.long	>2E2BFC0
JEM3D:
	.word	19,16,9,9
	.long	>2E2C880
CRS12V2:
	.word	17,60,8,14
	.long	>2E2D280
CRS12V3:
	.word	13,38,6,9
	.long	>2E2F800
CRS12V4:
	.word	10,21,5,6
	.long	>2E30B00
CRS12V5:
	.word	12,16,6,5
	.long	>2E312E0
CRS12V6:
	.word	10,10,5,6
	.long	>2E318E0
CRS12V7:
	.word	7,6,3,6
	.long	>2E31CA0
MSLB2:
	.word	27,14,12,4
	.long	>2E31E20
MSLB3:
	.word	25,16,12,5
	.long	>2E32A60
MSLB4:
	.word	25,19,12,7
	.long	>2E33860
MSLB5:
	.word	20,20,8,7
	.long	>2E34900
MSLB6:
	.word	17,21,7,10
	.long	>2E35580
MSLB7:
	.word	16,22,6,10
	.long	>2E362A0
MSLB8:
	.word	14,23,6,10
	.long	>2E36DA0
MSLB9:
	.word	12,24,6,12
	.long	>2E37920
I1:
	.word	7,7,3,3
	.long	>2E38220
	.long	IBALLP
RP1:
	.word	5,6,2,2
	.long	>2E383E0
	.long	RBPAL
RSR1:
	.word	8,4,3,1
	.long	>2E38560
	.long	RBPAL
I2:
	.word	12,10,5,4
	.long	>2E38660
I3:
	.word	14,11,5,5
	.long	>2E38A20
I4:
	.word	13,17,6,8
	.long	>2E38FA0
I5:
	.word	19,17,11,9
	.long	>2E39820
I6:
	.word	17,19,9,10
	.long	>2E3A2C0
RP2:
	.word	8,8,3,3
	.long	>2E3AEA0
RP3:
	.word	5,13,2,6
	.long	>2E3B0A0
RP4:
	.word	9,14,4,6
	.long	>2E3B3E0
RP5:
	.word	17,11,8,5
	.long	>2E3B920
RP6:
	.word	14,21,6,9
	.long	>2E3C000
RP7:
	.word	14,34,6,16
	.long	>2E3CA80
RP8:
	.word	14,21,7,11
	.long	>2E3DB80
RP9:
	.word	8,8,3,4
	.long	>2E3E600
RP10:
	.word	5,6,2,2
	.long	>2E3E800
RSR2:
	.word	9,6,4,2
	.long	>2E3E980
RSR3:
	.word	13,9,6,4
	.long	>2E3EBC0
RSR4:
	.word	11,15,5,8
	.long	>2E3F040
RSR5:
	.word	10,19,5,10
	.long	>2E3F5E0
RSR6:
	.word	11,25,7,13
	.long	>2E3FD00
RSR7:
	.word	11,15,6,8
	.long	>2E40660
RSR8:
	.word	11,8,5,4
	.long	>2E40C00
RSR9:
	.word	9,4,4,1
	.long	>2E40F00
BULLFT:
	.word	8,1,0,0
	.long	>2E41080
	.long	BULLET
BULUPLFT:
	.word	7,7,0,0
	.long	>2E410C0
	.long	BULLET
BULUP:
	.word	1,8,0,0
	.long	>2E41280
	.long	BULLET
M1:
	.word	15,15,7,6
	.long	>2E41380
	.long	BULLET
FRBAL1:
	.word	8,9,3,4
	.long	>2E41B00
	.long	BULLET
CNNBLL:
	.word	6,5,2,2
	.long	>2E41D40
	.long	BULLET
B245:
	.word	10,10,4,4
	.long	>2E41E80
	.long	BULLET
B2SIDE:
	.word	12,5,6,2
	.long	>2E42240
	.long	BULLET
B2UP:
	.word	5,12,2,6
	.long	>2E42420
	.long	BULLET
ELECT1:
	.word	18,16,8,3
	.long	>2E42720
	.long	BULLET
CSHIN:
	.word	28,16,0,0
	.long	>2E43120
	.long	BULLET
SPDBL:
	.word	10,9,4,4
	.long	>2E43F20
	.long	BULLET
FIRE1:
	.word	7,8,3,4
	.long	>2E44280
	.long	BULLET
M2:
	.word	4,3,2,1
	.long	>2E44480
	.long	BULLET
GSHAD1:
	.word	9,9,4,4
	.long	>2E444E0
	.long	BULLET
CNNBLL2:
	.word	6,5,3,2
	.long	>2E44840
	.long	BULLET
MSL1:
	.word	14,7,6,3
	.long	>2E44980
	.long	BULLET
KBM1:
	.word	12,11,6,5
	.long	>2E44D00
	.long	BULLET
EXPb1:
	.word	7,8,3,3
	.long	>2E45120
	.long	BULLET
NEARTNK:
	.word	88,24,0,0
	.long	>2E45320
	.long	BULLET
ELECT1A:
	.word	23,19,10,6
	.long	>2E49520
ELECT1B:
	.word	22,18,10,5
	.long	>2E4A360
ELECT1C:
	.word	24,22,11,8
	.long	>2E4B0E0
EXPb2:
	.word	15,15,7,7
	.long	>2E4C160
EXPb3:
	.word	21,20,11,9
	.long	>2E4C8E0
EXPb4:
	.word	31,29,16,14
	.long	>2E4D7E0
EXPb5:
	.word	46,41,23,20
	.long	>2E4F4E0
EXPb6:
	.word	51,46,26,23
	.long	>2E53260
EXPb7:
	.word	54,47,27,24
	.long	>2E57D20
EXPb8:
	.word	57,53,28,27
	.long	>2E5CF60
EXPb9:
	.word	58,53,30,28
	.long	>2E632C0
M3:
	.word	5,4,2,1
	.long	>2E69620
M4:
	.word	8,7,3,3
	.long	>2E69720
M5:
	.word	11,9,5,4
	.long	>2E698E0
M6:
	.word	15,12,7,5
	.long	>2E69C40
FIRE2:
	.word	9,10,4,5
	.long	>2E6A240
FIRE3:
	.word	10,11,4,5
	.long	>2E6A600
FIRE4:
	.word	14,13,8,6
	.long	>2E6AA20
FIRE5:
	.word	15,17,7,7
	.long	>2E6B0A0
FIRE6:
	.word	18,20,9,10
	.long	>2E6B920
KBM2:
	.word	22,22,11,11
	.long	>2E6C5A0
KBM3:
	.word	33,32,16,16
	.long	>2E6D620
KBM4:
	.word	34,34,18,18
	.long	>2E6FA20
KBM5:
	.word	34,34,17,18
	.long	>2E72060
KBM6:
	.word	31,29,16,14
	.long	>2E746A0
KBM7:
	.word	30,30,16,15
	.long	>2E763A0
FRBAL2:
	.word	9,10,4,5
	.long	>2E6A240
FRBAL3:
	.word	10,11,4,5
	.long	>2E6A600
FRBAL4:
	.word	14,13,8,6
	.long	>2E6AA20
FRBAL5:
	.word	15,17,7,7
	.long	>2E6B0A0
FRBAL6:
	.word	18,20,9,10
	.long	>2E6B920
MSL2:
	.word	14,7,6,1
	.long	>2E781A0
MSL3:
	.word	13,8,6,2
	.long	>2E78520
MSL4:
	.word	13,9,5,3
	.long	>2E78920
MSL5:
	.word	13,11,5,4
	.long	>2E78DA0
MSL6:
	.word	11,11,4,4
	.long	>2E79320
MSL7:
	.word	10,12,3,4
	.long	>2E79740
MSL8:
	.word	8,12,2,5
	.long	>2E79BC0
MSL9:
	.word	9,12,3,5
	.long	>2E79EC0
RRD0:
	.word	7,9,0,0
	.long	>2E7A340
	.long	SCOREPAL
RRD1:
	.word	7,9,0,0
	.long	>2E7A580
	.long	SCOREPAL
RRD2:
	.word	7,9,0,0
	.long	>2E7A7C0
	.long	SCOREPAL
RRD3:
	.word	7,9,0,0
	.long	>2E7AA00
	.long	SCOREPAL
RRD4:
	.word	7,9,0,0
	.long	>2E7AC40
	.long	SCOREPAL
RRD5:
	.word	7,9,0,0
	.long	>2E7AE80
	.long	SCOREPAL
RRD6:
	.word	7,9,0,0
	.long	>2E7B0C0
	.long	SCOREPAL
RRD7:
	.word	7,9,0,0
	.long	>2E7B300
	.long	SCOREPAL
RRD8:
	.word	7,9,0,0
	.long	>2E7B540
	.long	SCOREPAL
RRD9:
	.word	7,9,0,0
	.long	>2E7B780
	.long	SCOREPAL
BWORD:
	.word	36,8,0,0
	.long	>2E7B9C0
	.long	SCOREPAL
TSCORE:
	.word	127,27,0,0
	.long	>2E7C2C0
	.long	SCOREPAL
FIVE:
	.word	25,8,0,0
	.long	>2E82EC0
	.long	SCOREPAL
PHD1:
	.word	87,41,0,0
	.long	>2E835C0
	.long	SCOREPAL
PHD2:
	.word	87,41,0,0
	.long	>2E8A680
	.long	SCOREPAL
DROPIT:
	.word	68,33,0,0
	.long	>2E91740
	.long	SCOREPAL
TAKEIT:
	.word	90,34,0,0
	.long	>2E95D60
	.long	SCOREPAL
PATH:
	.word	97,18,0,0
	.long	>2E9BF20
	.long	SCOREPAL
PRESS2:
	.word	159,8,0,0
	.long	>2E9F760
	.long	SCOREPAL
MISN1:
	.word	68,18,0,0
	.long	>2EA1F60
	.long	SCOREPAL
TCWAY:
	.word	90,33,0,0
	.long	>2EA45A0
	.long	SCOREPAL
LOSSWAY:
	.word	98,28,0,0
	.long	>2EAA480
	.long	SCOREPAL
PHD2A:
	.word	87,41,0,0
	.long	>2EAFC00
	.long	SCOREPAL
BXTOP:
	.word	123,28,0,0
	.long	>2EB6CC0
	.long	SCOREPAL
BXMID:
	.word	123,60,0,0
	.long	>2EBD940
	.long	SCOREPAL
MISN2:
	.word	70,18,0,0
	.long	>2ECC1C0
	.long	SCOREPAL
MISN3:
	.word	70,18,0,0
	.long	>2ECEA40
	.long	SCOREPAL
YOUARE:
	.word	63,32,0,0
	.long	>2ED12C0
	.long	SCOREPAL
PAINFUL:
	.word	123,32,0,0
	.long	>2ED52C0
	.long	SCOREPAL
ORCUS:
	.word	104,22,0,0
	.long	>2EDCEC0
	.long	SCOREPAL
YOUARE2:
	.word	68,32,0,0
	.long	>2EE1640
	.long	SCOREPAL
SNEAK:
	.word	91,32,0,0
	.long	>2EE5A40
	.long	SCOREPAL
LV0:
	.word	15,9,0,0
	.long	>2EEB640
	.long	SCOREPAL
LV1:
	.word	15,9,0,0
	.long	>2EEBAC0
	.long	SCOREPAL
LV2:
	.word	15,9,0,0
	.long	>2EEBF40
	.long	SCOREPAL
LV3:
	.word	15,9,0,0
	.long	>2EEC3C0
	.long	SCOREPAL
LV4:
	.word	15,9,0,0
	.long	>2EEC840
	.long	SCOREPAL
LV5:
	.word	15,9,0,0
	.long	>2EECCC0
	.long	SCOREPAL
LV6:
	.word	15,9,0,0
	.long	>2EED140
	.long	SCOREPAL
LV7:
	.word	15,9,0,0
	.long	>2EED5C0
	.long	SCOREPAL
LV8:
	.word	15,9,0,0
	.long	>2EEDA40
	.long	SCOREPAL
LV9:
	.word	15,9,0,0
	.long	>2EEDEC0
	.long	SCOREPAL
USEBMB:
	.word	66,24,0,0
	.long	>2EEE340
	.long	SCOREPAL
FINDKEYS:
	.word	99,23,0,0
	.long	>2EF1640
	.long	SCOREPAL
BMB0:
	.word	30,10,0,0
	.long	>2EF5E20
	.long	SCOREPAL
BMB1:
	.word	30,10,0,0
	.long	>2EF6820
	.long	SCOREPAL
BMB2:
	.word	30,10,0,0
	.long	>2EF7220
	.long	SCOREPAL
BMB3:
	.word	30,10,0,0
	.long	>2EF7C20
	.long	SCOREPAL
BMB4:
	.word	30,10,0,0
	.long	>2EF8620
	.long	SCOREPAL
BMB5:
	.word	30,10,0,0
	.long	>2EF9020
	.long	SCOREPAL
BMB6:
	.word	30,10,0,0
	.long	>2EF9A20
	.long	SCOREPAL
BMB7:
	.word	30,10,0,0
	.long	>2EFA420
	.long	SCOREPAL
BMB8:
	.word	30,10,0,0
	.long	>2EFAE20
	.long	SCOREPAL
BMB9:
	.word	30,10,0,0
	.long	>2EFB820
	.long	SCOREPAL
PRESS:
	.word	34,18,0,0
	.long	>2EFC220
INSERT:
	.word	39,18,0,0
	.long	>2EFD660
TIMES:
	.word	6,5,0,0
	.long	>2EFECE0
DCLR:
	.word	95,11,0,0
	.long	>2F22AE0
	.long	DIAGP
FIEND1:
	.word	23,40,16,-8
	.long	>2F24BE0
	.long	FNDP
SHAD1:
	.word	17,11,9,-41
	.long	>2F269E0
	.long	FNDP
FNDSIT:
	.word	29,24,1,-46
	.long	>2F270C0
	.long	FNDP
FNDSITB:
	.word	29,24,1,-46
	.long	>2F270C0
	.long	FNDPRED
FNDSITC:
	.word	29,24,1,-46
	.long	>2F270C0
	.long	FNDPBLU
FNDSITD:
	.word	29,24,1,-46
	.long	>2F270C0
	.long	FNDPGRN
FNDSITE:
	.word	29,24,1,-46
	.long	>2F270C0
	.long	FNDPPUR
FNDJUMP12C1:
	.word	28,51,13,1
	.long	>2F288C0
FNDJUMP12C2:
	.word	29,55,13,2
	.long	>2F2B560
FNDJUMP6C1:
	.word	28,50,14,0
	.long	>2F2EC60
FNDJUMP6C2:
	.word	30,57,15,2
	.long	>2F31820
FIEND2:
	.word	21,40,13,-8
	.long	>2F35120
FIEND3:
	.word	24,40,13,-8
	.long	>2F36F20
FIEND4:
	.word	23,40,14,-8
	.long	>2F38D20
FIEND5:
	.word	24,40,14,-8
	.long	>2F3AB20
FIEND6:
	.word	24,41,13,-8
	.long	>2F3C920
FIEND7:
	.word	22,40,13,-8
	.long	>2F3E7E0
FNSTND6:
	.word	26,46,14,-8
	.long	>2F405E0
FNSTND7:
	.word	20,42,11,-8
	.long	>2F42E20
FNSTND9:
	.word	17,42,7,-8
	.long	>2F44860
FNSTND12:
	.word	23,42,11,-9
	.long	>2F462A0
FSQUAT6:
	.word	36,45,19,-9
	.long	>2F48220
FSQUAT6A:
	.word	33,43,17,-11
	.long	>2F4B4C0
FSQUAT7:
	.word	24,45,12,-9
	.long	>2F4E520
FSQUAT7A:
	.word	26,42,12,-9
	.long	>2F506E0
FSQUAT9:
	.word	18,44,8,-9
	.long	>2F52BA0
FSQUAT9A:
	.word	19,43,9,-10
	.long	>2F54720
FSQUAT10:
	.word	23,43,13,-11
	.long	>2F56200
FSQUAT10A:
	.word	23,42,13,-12
	.long	>2F58240
FSQUAT12A:
	.word	27,39,13,-12
	.long	>2F5A1C0
FNSTND10:
	.word	18,45,10,-9
	.long	>2F5C3E0
FJUMP6A:
	.word	31,45,16,-9
	.long	>2F5E000
FJUMP6B:
	.word	31,43,16,-11
	.long	>2F60D00
FJUMP6C:
	.word	25,44,13,-2
	.long	>2F63800
FJUMP12A:
	.word	27,41,13,-10
	.long	>2F65E80
FJUMP12B:
	.word	29,39,14,-11
	.long	>2F68260
FJUMP12C:
	.word	23,44,11,-2
	.long	>2F6A960
GRNTFLM1:
	.word	26,51,15,13
	.long	>308F1A0
	.long	RDBOOM
CLD1:
	.word	9,9,4,4
	.long	>3091E40
	.long	BLUBOOM
CLD1A:
	.word	9,9,4,4
	.long	>3091E40
	.long	GREYPAL
OKBM1:
	.word	12,11,6,5
	.long	>30921A0
	.long	RDBOOM
BBS1:
	.word	4,5,1,2
	.long	>30925C0
	.long	RDBOOM
bldclt1:
	.word	3,4,0,-20
	.long	>3092660
	.long	RDBOOM
CLDB1:
	.word	12,11,6,20
	.long	>30926E0
	.long	BLUBOOM
CLDB1YELL:
	.word	12,11,6,20
	.long	>30926E0
	.long	YELLPAL
CLDB1WHT:
	.word	12,11,6,20
	.long	>30926E0
	.long	WHTPAL
CLDB1ORNG:
	.word	12,11,6,20
	.long	>30926E0
	.long	ORNGPAL
CLDB1LGRY:
	.word	12,11,6,20
	.long	>30926E0
	.long	LGRYPAL
CLDB1GRN:
	.word	12,11,6,20
	.long	>30926E0
	.long	GRNPAL
CLDB1PURP:
	.word	12,11,6,20
	.long	>30926E0
	.long	PURPPAL
GRNTFLM2:
	.word	18,50,11,13
	.long	>3092B00
GRNTFLM3:
	.word	15,54,10,17
	.long	>3094A40
GRNTFLM4:
	.word	11,62,8,27
	.long	>3096540
GRNTFLM5:
	.word	8,60,5,26
	.long	>3097C80
GRNTFLM6:
	.word	5,43,6,13
	.long	>3098B80
OKBM2:
	.word	22,22,11,11
	.long	>3099640
OKBM3:
	.word	33,32,16,16
	.long	>309A6C0
OKBM4:
	.word	34,34,18,18
	.long	>309CAC0
OKBM5:
	.word	34,34,17,18
	.long	>309F100
OKBM6:
	.word	31,29,16,14
	.long	>30A1740
OKBM7:
	.word	30,30,16,15
	.long	>30A3440
BBS2:
	.word	6,7,2,3
	.long	>30A5240
BBS3:
	.word	11,9,5,4
	.long	>30A5400
BBS4:
	.word	17,13,7,5
	.long	>30A5760
BBS5:
	.word	26,21,12,9
	.long	>30A5F80
CLD2:
	.word	25,29,12,15
	.long	>30A71E0
CLD3:
	.word	29,32,15,17
	.long	>30A8B40
CLD4:
	.word	25,31,13,18
	.long	>30AAB40
CLD4A:
	.word	28,37,14,26
	.long	>30AC660
CLD4B:
	.word	32,38,17,29
	.long	>30AE6C0
CLD5:
	.word	36,34,19,30
	.long	>30B0CC0
CLD6:
	.word	36,36,20,32
	.long	>30B3300
CLD7:
	.word	36,36,20,32
	.long	>30B5B80
CLD8:
	.word	32,32,18,31
	.long	>30B8400
CLD9:
	.word	30,29,17,28
	.long	>30BA400
CLD10:
	.word	29,30,15,29
	.long	>30BC100
CLD11:
	.word	29,30,16,29
	.long	>30BDF00
bldclt2:
	.word	4,5,1,-20
	.long	>30BFD00
bldclt3:
	.word	8,9,2,-19
	.long	>30BFDA0
bldclt4:
	.word	14,15,3,-17
	.long	>30BFFE0
bldclt5:
	.word	20,21,6,-14
	.long	>30C0760
bldclt6:
	.word	20,22,6,-13
	.long	>30C1480
bldclt7:
	.word	26,28,8,-11
	.long	>30C2240
bldclt8:
	.word	33,30,13,-10
	.long	>30C3AC0
rblot9:
	.word	8,6,3,-21
	.long	>30C5C80
rblot10:
	.word	7,5,3,-22
	.long	>30C5E00
rblot1:
	.word	3,4,1,-22
	.long	>30C5F40
rblot2:
	.word	5,6,2,-22
	.long	>30C5FC0
rblot3:
	.word	12,8,6,-22
	.long	>30C6140
rblot4:
	.word	12,13,6,-19
	.long	>30C6440
rblot5:
	.word	9,16,4,-17
	.long	>30C6920
rblot6:
	.word	10,15,5,-17
	.long	>30C6F20
rblot7:
	.word	13,10,6,-19
	.long	>30C74C0
rblot8:
	.word	10,5,5,-22
	.long	>30C79C0
CLDB2:
	.word	22,22,13,25
	.long	>30C7BA0
CLDB3:
	.word	28,30,16,28
	.long	>30C8C20
CLDB4:
	.word	32,31,17,29
	.long	>30CA660
XPLD1:
	.word	58,56,30,29
	.long	>30CC560
	.long	RDBOOM
X1BLU:
	.word	58,56,30,29
	.long	>30CC560
	.long	BLUBOOM
X1GRN:
	.word	58,56,30,29
	.long	>30CC560
	.long	GRNBOOM
GNFR1:
	.word	25,25,12,13
	.long	>30D2E60
	.long	RDBOOM
LFLM1:
	.word	26,52,13,-8
	.long	>30D4440
	.long	RDBOOM
FLM1:
	.word	48,61,29,-20
	.long	>30D71C0
	.long	RDBOOM
JTFLM1:
	.word	31,30,19,-12
	.long	>30DCD40
	.long	BLUBOOM
XPLD2:
	.word	69,66,35,37
	.long	>30F28C0
XPLD3:
	.word	83,81,42,54
	.long	>30FBD40
XPLD4:
	.word	88,88,45,63
	.long	>31091E0
XPLD5:
	.word	87,87,45,69
	.long	>31183E0
XPLD6:
	.word	86,85,43,71
	.long	>3127320
XPLD7:
	.word	87,84,44,80
	.long	>3135CE0
XPLD8:
	.word	87,84,42,85
	.long	>31443E0
XPLD9:
	.word	85,79,42,87
	.long	>3152AE0
XPLD10:
	.word	75,65,37,85
	.long	>3160420
LFLM2:
	.word	35,54,13,-6
	.long	>3169E80
LFLM3:
	.word	31,64,12,4
	.long	>316DB40
LFLM4:
	.word	33,62,12,3
	.long	>3171B40
LFLM5:
	.word	35,63,15,4
	.long	>3176100
LFLM6:
	.word	29,64,15,5
	.long	>317A7E0
JTFLM2:
	.word	27,22,15,-16
	.long	>317E7E0
FLM2:
	.word	65,64,32,-17
	.long	>317FB20
FLM3:
	.word	55,71,32,-10
	.long	>3188320
FLM4:
	.word	60,68,30,-13
	.long	>318FF60
FLM5:
	.word	63,69,33,-12
	.long	>3197EE0
FLM6:
	.word	53,71,35,-11
	.long	>31A08E0
GNFR2:
	.word	19,20,9,10
	.long	>31A8520
GNFR3:
	.word	12,12,6,6
	.long	>31A91A0
PLFR1:
	.word	38,52,20,5
	.long	>31A9620
PLFR2:
	.word	31,61,18,14
	.long	>31AD720
PLFR3:
	.word	30,67,18,20
	.long	>31B1420
PLFR4:
	.word	31,66,18,19
	.long	>31B5720
PLFR5:
	.word	30,75,18,28
	.long	>31B9920
PLFR6:
	.word	30,68,18,21
	.long	>31BE420
PLFR7:
	.word	30,57,18,10
	.long	>31C2820
PLFR8:
	.word	32,39,20,-8
	.long	>31C6120
PLFR9:
	.word	32,36,21,-11
	.long	>31C8820
PLFR10:
	.word	32,31,22,-16
	.long	>31CAC20
PLFR11:
	.word	31,28,24,-18
	.long	>31CCB20
PLFR12:
	.word	30,27,25,-22
	.long	>31CE720
PLFR13:
	.word	30,27,25,-26
	.long	>31D0220
PLFR14:
	.word	38,34,33,-28
	.long	>31D1D20
PLFR15:
	.word	47,34,42,-36
	.long	>31D47A0
PLFR16:
	.word	46,41,41,-29
	.long	>31D7AA0
PLFR17:
	.word	46,46,41,-24
	.long	>31DB820
PLFR18:
	.word	44,51,41,-18
	.long	>31DFD20
PLFR19:
	.word	40,56,38,-13
	.long	>31E4340
PLFR20:
	.word	39,60,38,-6
	.long	>31E8940
PLFR21:
	.word	37,57,37,0
	.long	>31ED440
PLFR22:
	.word	37,58,37,7
	.long	>31F1B80
PLFR23:
	.word	37,56,37,12
	.long	>31F6400
PLFR24:
	.word	1,33,17,15
	.long	>31FAA00
PLFR25:
	.word	1,21,17,17
	.long	>31FAE20
IPIECE:
	.word	72,20,73,-29
	.long	>31FB0C0
	.long	PLLT
IPC2:
	.word	23,17,41,-32
	.long	>31FDDC0
	.long	PLLT
TPHD:
	.word	47,23,48,-6
	.long	>31FEA80
	.long	PLLT
UPPRJAW:
	.word	72,36,73,-49
	.long	>3200D00
	.long	PLLT
INNRMTH:
	.word	72,28,73,-59
	.long	>3205E00
	.long	PLLT
CHK1:
	.word	19,42,92,-45
	.long	>3209D00
	.long	PLLT
CHK2:
	.word	19,42,92,-45
	.long	>320B740
	.long	PLLT
CHK3:
	.word	19,42,92,-45
	.long	>320D180
	.long	PLLT
CHK3A:
	.word	8,31,81,-87
	.long	>320EBC0
	.long	PLLT
CHK2A:
	.word	6,23,79,-87
	.long	>320F380
	.long	PLLT
SOLDR1:
	.word	91,111,43,-20
	.long	>320F940
	.long	SOLDB
BOD1:
	.word	91,80,92,-87
	.long	>3223860
	.long	PLLT
BOD1A:
	.word	91,80,43,-5
	.long	>3223860
	.long	PLLT
BOD2:
	.word	55,95,147,-72
	.long	>3231E60
	.long	PLLT
BOD2A:
	.word	55,95,31,-5
	.long	>3231E60
	.long	PLLT
BTTMJAW:
	.word	72,80,73,-64
	.long	>323C4A0
	.long	PLLT
BTJ2:
	.word	72,80,73,-83
	.long	>323C4A0
	.long	PLLT
BTJ3:
	.word	72,80,73,-90
	.long	>323C4A0
	.long	PLLT
SOLDR3:
	.word	60,48,28,-6
	.long	>32478A0
SOLDR4:
	.word	50,75,54,-35
	.long	>324D2A0
IPC3:
	.word	23,17,41,-32
	.long	>3254C80
IPC4:
	.word	23,17,41,-32
	.long	>3255940
IPC5:
	.word	23,17,41,-32
	.long	>3256600
IPC1A:
	.word	23,17,41,-32
	.long	>32572C0
IRAQMAP1:
	.word	158,190,0,0
	.long	>3257F80
	.long	MAPP
IRAQMAP2:
	.word	217,190,0,0
	.long	>3293580
	.long	MAPP
MISSION1:
	.word	78,132,0,0
	.long	>32E4FC0
	.long	MAPP
MISSION2:
	.word	78,132,0,0
	.long	>32F99C0
	.long	MAPP
MISSION3:
	.word	84,95,0,0
	.long	>330E3C0
	.long	MAPP
POINTER:
	.word	68,38,0,0
	.long	>331DD20
	.long	DOMEP
PDOME:
	.word	44,29,0,0
	.long	>3322DE0
	.long	DOMEP
DPC2:
	.word	79,63,0,0
	.long	>33255C0
	.long	DISHPAL
DPC3:
	.word	25,33,0,0
	.long	>332F340
	.long	DISHPAL
DPC4:
	.word	89,79,0,0
	.long	>3331020
T72BLAST1:
	.word	21,22,10,-3
	.long	>333F340
	.long	TNKPAL
FNDGUN9A:
	.word	56,25,48,-23
	.long	>33403C0
	.long	TNKPAL
T72TURET1:
	.word	8,74,3,-72
	.long	>3342F80
	.long	TNKPAL
TNKTRED1:
	.word	9,97,44,-17
	.long	>3344200
	.long	TNKPAL
TNKTRED1A:
	.word	30,8,45,-114
	.long	>3346660
	.long	TNKPAL
TNKSHAD1:
	.word	97,17,40,-112
	.long	>3346E60
	.long	TNKPAL
TNKSHAD2:
	.word	14,91,-9,-41
	.long	>334A380
	.long	TNKPAL
TNKBUL:
	.word	5,21,0,0
	.long	>334D100
	.long	TNKPAL
GUNBUL:
	.word	10,9,5,4
	.long	>334D640
	.long	TNKPAL
T72TNK:
	.word	80,104,39,-10
	.long	>334D9A0
	.long	TNKPAL
T72BLAST2:
	.word	30,31,14,-3
	.long	>335DDA0
	.long	TNKPAL
ABLST1:
	.word	21,17,11,8
	.long	>335FCA0
	.long	TNKPAL
T72BLAST3:
	.word	49,44,24,-4
	.long	>3360960
T72BLAST4:
	.word	48,41,24,-5
	.long	>33650E0
T72BLAST5:
	.word	47,40,23,-5
	.long	>3368E60
T72BLAST6:
	.word	47,38,24,-5
	.long	>336CA60
T72BLAST7:
	.word	46,38,23,-5
	.long	>3370360
ABLST3:
	.word	49,44,25,22
	.long	>3360960
ABLST4:
	.word	48,41,26,22
	.long	>33650E0
ABLST5:
	.word	47,40,24,22
	.long	>3368E60
ABLST6:
	.word	47,38,23,21
	.long	>336CA60
ABLST7:
	.word	46,38,25,21
	.long	>3370360
T72BLAST8:
	.word	46,38,23,-5
	.long	>3373C60
ABLST2:
	.word	30,25,15,13
	.long	>3377560
FNDGUN10A:
	.word	56,30,47,-17
	.long	>3378E60
FNDGUN10B:
	.word	64,36,55,-11
	.long	>337C2E0
FNDGUN115A:
	.word	33,46,19,-1
	.long	>3380AE0
FNDGUN115B:
	.word	41,56,26,9
	.long	>3383EA0
FNDGUN11A:
	.word	43,45,33,-2
	.long	>3388BA0
FNDGUN11B:
	.word	47,49,37,2
	.long	>338C980
FNDGUN12A:
	.word	25,47,13,0
	.long	>3391300
FNDGUN12B:
	.word	29,55,15,8
	.long	>3393C20
FNDGUN6A:
	.word	30,53,15,-23
	.long	>3397320
FNDGUN6B:
	.word	28,60,14,-23
	.long	>339A820
FNDGUN7A:
	.word	32,48,22,-23
	.long	>339DCA0
FNDGUN7B:
	.word	37,55,27,-23
	.long	>33A0CA0
FNDGUN85A:
	.word	55,34,44,-23
	.long	>33A5160
FNDGUN85B:
	.word	62,39,51,-23
	.long	>33A8CE0
FNDGUN8A:
	.word	44,43,35,-23
	.long	>33ADAE0
FNDGUN8B:
	.word	51,50,42,-23
	.long	>33B1600
FNDGUN9B:
	.word	67,26,59,-23
	.long	>33B6740
T72TNK2:
	.word	100,112,45,-11
	.long	>33B9E80
T72TURET2:
	.word	8,67,3,-72
	.long	>33CFC80
TNKTRED2:
	.word	9,97,44,-17
	.long	>33D0D40
TNKTRED2A:
	.word	30,8,45,-114
	.long	>33D31A0

	.include BGNDTBL.GLO
