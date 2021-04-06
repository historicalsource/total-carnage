	.OPTION	B,D,L,T
	.include	"BGNDTBL.GLO"
	.DATA
GRNDP:	;PAL #2
	.word	64	;pal size
	.word >0,>0,>C63,>1084,>10A3,>10C3,>14A5,>18C6,>14E4,>1904
	.word >2108,>1924,>1564,>1184,>842,>1063,>1083,>1482,>1483,>14A3
	.word >18A3,>1484,>14A4,>18A4,>18A5,>841,>480,>1880,>20C0,>C0
	.word >100,>2900,>A0,>120,>8E1,>E0,>140,>9A2,>DA2,>19A6
	.word >DE1,>E63,>1440,>1460,>1860,>1C80,>18A0,>1CA0,>294A,>318C
	.word >7E60,>7F20,>84,>C6,>E7,>108,>129,>16C,>7CA3,>0
	.word >0,>0,>0,>0
HNGRP:	;PAL #5
	.word	64	;pal size
	.word >0,>0,>800,>820,>C40,>2400,>C60,>1060,>1480,>14A0
	.word >18A0,>18C0,>1CC0,>20E0,>2100,>2500,>843,>1481,>18A2,>1CC3
	.word >C64,>20E4,>2505,>40A,>14A6,>C0F,>1CE8,>252A,>3000,>2D20
	.word >2926,>2D60,>2D47,>3168,>2D6C,>3800,>3560,>4400,>6400,>3589
	.word >35A0,>39AA,>45C0,>3DCB,>41EC,>460D,>4A2E,>4211,>4E4F,>5270
	.word >1084,>14A5,>3160,>45E0,>4600,>39CE,>0,>0,>0,>0
	.word >0,>0,>0,>0
UFLP:	;PAL #7
	.word	43	;pal size
	.word >0,>2,>842,>443,>844,>864,>C65,>C85,>1084,>10A6
	.word >14C7,>18E8,>7E00,>7E60,>7EC0,>7F20,>860,>801,>820,>802
	.word >822,>C02,>C22,>C03,>C04,>1002,>1003,>1004,>1043,>1403
	.word >1404,>1804,>1824,>1005,>1405,>1406,>1806,>1807,>1C05,>1C25
	.word >2005,>1C07,>1C08
CANDB:	;PAL #8
	.word	64	;pal size
	.word >0,>820,>840,>C40,>1040,>1060,>1460,>84,>A5,>1480
	.word >14A0,>1880,>C6,>E7,>18C6,>108,>109,>129,>16C,>1CE
	.word >252,>1CA0,>20A1,>20C0,>28C0,>2CE0,>3100,>3942,>4185,>45A7
	.word >522B,>7E60,>0,>0,>0,>0,>0,>0,>0,>0
	.word >0,>0,>0,>0,>0,>0,>0,>0,>0,>0
	.word >0,>0,>0,>0,>0,>0,>0,>0,>0,>0
	.word >0,>0,>0,>7FFF
JEEPP2:	;PAL #11
	.word	64	;pal size
	.word >0,>0,>40,>80,>A1,>C1,>101,>121,>162,>182
	.word >1C2,>1E3,>223,>243,>283,>2E4,>0,>842,>1084,>18C6
	.word >2108,>294A,>318C,>39CE,>4210,>4E73,>6318,>739C,>7FF7,>60
	.word >A1,>121,>4C1,>521,>D81,>DE1,>E02,>16A3,>10A4,>1906
	.word >C63,>3C00,>6C43,>5400,>5ECA,>6306,>5ACE,>4E6B,>ED,>171
	.word >237,>0,>0,>0,>0,>0,>0,>0,>0,>0
	.word >0,>0,>0,>7FFF

BBPALS:
	.long	ARPRTPL
	.long	DESRTPL
	.long	GRNDP
	.long	FRTCLS
	.long	DGP1
	.long	HNGRP
	.long	PPLP
	.long	UFLP
	.long	CANDB
	.long	BLUJET
	.long	BULLET
	.long	JEEPP2
	.long	DGP3
	.long	SPYDERP1
	.long	FNDP
	.long	JEEPP
JETPAL:	;PAL #4
	.word	64	;pal size
	.word >0,>0,>1420,>1880,>1C00,>2000,>1CA0,>20A0,>20C0,>2400
	.word >24C0,>24E0,>2800,>2C00,>28E0,>2900,>2D00,>1,>421,>463
	.word >C63,>1483,>14A2,>1084,>14A5,>10C6,>1CE7,>1D08,>156C,>2529
	.word >294A,>2D6B,>29CF,>3000,>3400,>3100,>3120,>3520,>3540,>3800
	.word >3841,>3920,>3940,>3C00,>3D40,>3D60,>4000,>4160,>4C21,>318C
	.word >35AD,>4180,>4580,>4980,>4DA0,>59E0,>39CE,>31F0,>3DEF,>3A32
	.word >4210,>4631,>4E73,>5EF7

ZZPALS:
	.long	BULLET
	.long	DESRTPL
	.long	GRNDP
	.long	FRTCLS
	.long	JETPAL
	.long	HNGRP
	.long	PPLP
	.long	GRNJET
PITP:	;PAL #0
	.word	2	;pal size
	.word >0,>1861

AAPALS:
	.long	PITP
	.long	DESRTPL
	.long	FRTCLS
	.long	GRNDP
	.long	PPLP
	.long	BULLET
	.long	JEEPP2

XXPALS:
	.long	PITP
	.long	DESRTPL
	.long	JEEPP2
	.long	GRNDP
	.long	PPLP
	.long	BULLET
BACK1:	;PAL #0
	.word	32	;pal size
	.word >0,>0,>1,>2,>403,>404,>405,>406,>407,>808
	.word >809,>80A,>82B,>82C,>C2D,>C2E,>C2F,>C30,>C31,>1032
	.word >1033,>1034,>1035,>1036,>1437,>1438,>1439,>143A,>143B,>183D
	.word >183E,>185F
carn3:	;PAL #1
	.word	61	;pal size
	.word >0,>0,>18C6,>6000,>64C6,>7880,>78A0,>78C0,>78E0,>7900
	.word >7920,>7940,>7946,>7960,>7980,>79A0,>79C0,>79E0,>7A00,>7986
	.word >79E6,>7A20,>7A40,>7A60,>7A80,>7AA0,>7AC0,>7AE0,>7B00,>7B20
	.word >7B40,>7B60,>7AC6,>7B0B,>7B6B,>7B6F,>7C80,>7CA0,>7CC0,>7CE0
	.word >7D20,>7D46,>7D60,>7D80,>7DC0,>7DE0,>7E00,>7E20,>7DC6,>7E40
	.word >7E60,>7E80,>7EA0,>7EC0,>7EE0,>7F00,>7F20,>7F40,>7F60,>7EC6
	.word >7F4C

PGPALS:
	.long	BACK1
	.long	carn3
	.long	BIGPL1
	.long	GUNSP1
CRMP:	;PAL #0
	.word	64	;pal size
	.word >0,>0,>400,>842,>1440,>C63,>1084,>10A5,>1484,>14A5
	.word >18A5,>160,>201,>221,>241,>2A1,>18C6,>1CC6,>18E7,>1CE7
	.word >1CE8,>1016,>2108,>2129,>2509,>2529,>292A,>294A,>A75,>2D6B
	.word >316C,>2D8B,>318C,>31AC,>31AD,>3569,>358D,>35AD,>39AD,>39CE
	.word >39EE,>6D44,>39EF,>3DEF,>3E0F,>4210,>4631,>4A52,>4E73,>5273
	.word >4E93,>5294,>52B4,>56B5,>5AD6,>5EF7,>34C0,>7C00,>1000,>2820
	.word >3C60,>5840,>3C60,>2820
IRAQPAL:	;PAL #1
	.word	64	;pal size
	.word >0,>914,>FF2C,>34E1,>4565,>4DA7,>5A2B,>7EC0,>7F6A,>7FD2
	.word >6A90,>1155,>1998,>2E3D,>7FE0,>7300,>6680,>5DA0,>0,>7F76
	.word >7713,>6AB0,>5E6D,>520A,>4186,>2CE1,>2080,>842,>1084,>18C6
	.word >2108,>294A,>318C,>3DEF,>4A52,>56B5,>6739,>77BD,>11E3,>2285
	.word >1F04,>3842,>4884,>58C6,>76EA,>6EA8,>6666,>1104,>1164,>11E4
	.word >2108,>2108,>2108,>2108,>2108,>2108,>2108,>2108,>2108,>2108
	.word >2108,>2108,>2108,>2108
GENP:	;PAL #3
	.word	64	;pal size
	.word >0,>420,>840,>841,>860,>861,>C60,>C81,>1081,>10A1
	.word >1480,>1C60,>14C2,>18E2,>1084,>10A2,>14C3,>18C3,>445,>14A5
	.word >889,>18C6,>14E3,>18E3,>1903,>1D03,>1D04,>1D05,>1D24,>2481
	.word >28C0,>20C1,>2124,>2125,>2145,>2545,>2565,>2944,>2945,>2108
	.word >2126,>2546,>294A,>2566,>2966,>2567,>2987,>2C81,>30A2,>3100
	.word >34C3,>2D87,>2D88,>31A9,>31AB,>35CB,>3CE3,>3CE4,>61A1,>4926
	.word >3DEE,>5547,>59AB,>0
TECPAL:	;PAL #4
	.word	64	;pal size
	.word >0,>842,>443,>464,>466,>467,>866,>886,>887,>129
	.word >889,>4AA,>8AA,>8CB,>4ED,>90E,>92F,>1CE,>273,>319
	.word >1C80,>20A0,>2882,>28C0,>2CE0,>30E0,>30A3,>3100,>3CC3,>3500
	.word >3D20,>4520,>4140,>4960,>5580,>5980,>69C0,>6DE0,>7E00,>C89
	.word >CAA,>CAB,>4505,>4D26,>5568,>5989,>5DCB,>CCD,>D51,>10CE
	.word >10EF,>10F0,>1111,>1112,>1533,>1556,>1577,>159A,>31D7,>768F
	.word >6A0E,>6F7B,>0,>0

LMPBPALS:
	.long	CRMP
	.long	IRAQPAL
	.long	STATICP
	.long	GENP
	.long	TECPAL
	.long	MAPP
	.long	DOMEP
CRMPZ:	;PAL #0
	.word	64	;pal size
	.word >0,>0,>400,>821,>1C20,>C41,>1462,>1482,>1C62,>1C82
	.word >1C82,>140,>1E0,>1E0,>200,>260,>1CA3,>24A3,>1CC3,>24C3
	.word >24C4,>140B,>2CE4,>2D04,>2CE4,>2D04,>3505,>3525,>A2B,>3D45
	.word >3D46,>3D65,>3D66,>3D86,>3D86,>4544,>4566,>4586,>4D86,>4DA7
	.word >4DC7,>7D22,>4DC7,>4DC7,>4DE7,>55E8,>5DE9,>5E09,>662A,>6E2A
	.word >664A,>6E4A,>6E6A,>6E6B,>768B,>7EAC,>44A0,>7C00,>1400,>3400
	.word >4C40,>7420,>4C40,>3400
CLDSZ:	;PAL #1
	.word	64	;pal size
	.word >0,>0,>1485,>14A7,>14C7,>14C8,>14E8,>1CC8,>1CE8,>1CE9
	.word >24C7,>24E9,>1D09,>2509,>250B,>252B,>252C,>252C,>250B,>252B
	.word >252C,>2D2C,>252C,>252E,>254C,>254E,>2D2C,>2D4C,>2D2E,>2D4E
	.word >2D4F,>354E,>354F,>2D6E,>2D6F,>356E,>356F,>358F,>3570,>3590
	.word >356F,>3590,>35B0,>35B2,>3DB2,>35D2,>3DD2,>3DD3,>45D3,>3DF2
	.word >3DF3,>45F3,>4613,>45F5,>4615,>4615,>4636,>4635,>4636,>4656
	.word >4657,>4E56,>4E57,>4E77
BGFRTP:	;PAL #3
	.word	64	;pal size
	.word >0,>421,>821,>81,>A2,>C41,>1061,>1461,>1481,>1C81
	.word >18A2,>1CA2,>C3,>E4,>105,>1CC3,>20C3,>20E4,>24E4,>2504
	.word >2505,>2525,>127,>189,>1CC,>2906,>2926,>2947,>2CC1,>2D04
	.word >2D26,>2D47,>3168,>3589,>35AA,>39AA,>3DAA,>7621,>3DCB,>41EC
	.word >45ED,>460D,>4A0D,>4A2D,>4A2E,>4E2E,>4A4F,>4E4F,>4E70,>5250
	.word >5270,>5670,>5291,>5691,>56B1,>5A91,>5AB2,>6B36,>6400,>19D
	.word >C0,>100,>1C0,>3C0
PROFP2:	;PAL #4
	.word	64	;pal size
	.word >0,>0,>866,>14A5,>C87,>10A9,>10CB,>2108,>2528,>252B
	.word >290A,>294A,>2D6B,>10CC,>10EC,>14CC,>14EC,>18EC,>14EE,>1510
	.word >1910,>1930,>294C,>316C,>318C,>356D,>358C,>35AD,>1D2F,>2151
	.word >2571,>2DB1,>38C4,>40E4,>4127,>39CE,>3DCE,>39CF,>39D0,>39EF
	.word >3DEF,>3DF0,>420F,>4210,>3DF1,>4631,>4A52,>4E73,>4A75,>5294
	.word >5295,>56B5,>56D7,>5AD6,>5AD7,>5EF7,>5EF8,>6318,>6739,>6B5A
	.word >6F7B,>739C,>77BD,>7BDE
PROFP:	;PAL #6
	.word	64	;pal size
	.word >0,>0,>840,>C40,>1060,>1460,>1480,>1880,>1881,>18A0
	.word >1C60,>1CA0,>20C0,>24A0,>28E0,>2D00,>3520,>842,>1CA3,>24A2
	.word >2882,>2CA3,>30A3,>34C4,>38C4,>38E4,>3CE4,>40E4,>34E5,>3CE5
	.word >40E5,>4105,>1D2D,>3D48,>4400,>4420,>4505,>4506,>4526,>4527
	.word >4820,>4926,>4947,>4948,>4C00,>4D47,>6441,>49A0,>4D68,>5168
	.word >4D69,>5169,>5189,>5589,>55AA,>59AA,>55AB,>59CB,>5DCC,>5DEC
	.word >5E0D,>620D,>5A51,>6318

TPALS:
	.long	CRMPZ
	.long	CLDSZ
	.long	FRTCLS
	.long	BGFRTP
	.long	PROFP2
	.long	GOOBP
	.long	PROFP
CLDS8:	;PAL #1
	.word	64	;pal size
	.word >0,>0,>CA4,>10C5,>10E5,>10E6,>1106,>14E6,>1506,>1507
	.word >18E5,>1907,>1527,>1927,>1928,>1948,>1949,>1969,>1D28,>1D48
	.word >1D49,>2149,>1D69,>1D6A,>1D89,>1D8A,>2169,>2189,>216A,>218A
	.word >218B,>258A,>258B,>21AA,>21AB,>25AA,>25AB,>25CB,>25AC,>25CC
	.word >29AB,>29CC,>29EC,>29ED,>2DED,>2A0D,>2E0D,>2E0E,>320E,>2E2D
	.word >2E2E,>322E,>324E,>322F,>324F,>364F,>3270,>366F,>3670,>3690
	.word >3691,>3A90,>3A91,>3AB1

OBPALS:
	.long	CRMP
	.long	CLDS8
	.long	FRTCLS
	.long	BGFRTP
	.long	SOLDB
	.long	TECPAL
	.long	GENP
	.long	STATICP
	.long	GOOBP

RTPALS:
	.long	FRTCLS
	.long	GRNDP
	.long	REACTR
	.long	BULLET
	.long	GOOBP
	.long	PPLP
	.long	CANDB
	.long	UFLP
CHUTE2:	;PAL #7
	.word	24	;pal size
	.word >0,>0,>840,>C60,>1080,>14A1,>24A0,>28C0,>18E2,>18C6
	.word >1D03,>1D23,>1D24,>2124,>2144,>2145,>2545,>2108,>2566,>2966
	.word >2987,>294A,>318C,>35EE
FNDP3:	;PAL #15
	.word	20	;pal size
	.word >0,>1400,>842,>2108,>2800,>3000,>3000,>3800,>3C00,>4000
	.word >39AF,>4800,>5400,>6000,>6800,>7000,>7800,>7D49,>5294,>7FFF

LDPALS:
	.long	PITP
	.long	DESRTPL
	.long	STUFFP
	.long	DISHPAL
	.long	GOOBP
	.long	CANDB
	.long	GRNDP
	.long	CHUTE2
	.long	BULLET
	.long	PPLP
	.long	DGP1
	.long	DGP3
	.long	DGP2
	.long	FRTCLS
	.long	FNDP
	.long	FNDP3
	.long	MTNKP
frtcls2:	;PAL #0
	.word	64	;pal size
	.word >400,>400,>C00,>C00,>C00,>1420,>1420,>2440,>1440,>2C80
	.word >1480,>2480,>2CA0,>34A0,>34C0,>34C0,>3CE0,>34E0,>34E0,>4500
	.word >4D40,>3D00,>4540,>4D40,>4D40,>5560,>6580,>4D60,>6DE0,>65E0
	.word >6E00,>7E00,>7E20,>6E00,>7620,>7E80,>7E40,>7E80,>7EA0,>7EE0
	.word >7F20,>7F20,>2440,>3CE0,>4D40,>7600,>7EE0,>4C0,>720,>7C00
	.word >7C00,>7C00,>400,>400,>400,>7C00,>7EC0,>7F20,>480,>500
	.word >600,>6C0,>720,>4F20

PALS:
	.long	frtcls2
	.long	GRNDP
	.long	REACTR
	.long	BULLET
	.long	GOOBP
	.long	PPLP
	.long	CANDB
	.long	UFLP
	.long	FRTCLS

PPALS:
	.long	CRMP
	.long	FRTCLS
	.long	STATICP
	.long	GENP
	.long	TECPAL

APALS:
	.long	FRTCLS
	.long	GRNDP
	.long	UFLP
	.long	CANDB
	.long	PPLP
	.long	JEEPP2

DBPALS:
	.long	PITP
	.long	DESRTPL
	.long	PPLP
	.long	BULLET
	.long	GRNDP
UPAL:	;PAL #0
	.word	64	;pal size
	.word >0,>420,>822,>841,>843,>864,>C62,>1083,>14A4,>C45
	.word >1066,>1467,>1087,>18C5,>1088,>1889,>14A9,>18CB,>1CE6,>2107
	.word >2528,>1CAB,>1CED,>20CD,>2949,>2D6A,>318B,>35AC,>39CD,>20EE
	.word >24EE,>24EF,>2510,>2511,>2911,>2D33,>3173,>3556,>3598,>41BC
	.word >4630,>4E72,>6317,>77BC,>7D60,>7E00,>7E60,>7EC0,>7F20,>0
	.word >A0,>C0,>E0,>100,>120,>160,>1A0,>200,>2C0,>360
	.word >3E0,>300,>220,>160

DCPALS:
	.long	UPAL
	.long	FRTCLS
	.long	GRNDP
	.long	UFLP
	.long	PPLP
	.long	SPYDERP1

DDPALS:
	.long	UPAL
	.long	UFLP
	.long	GRNDP
	.long	PPLP
	.long	FRTCLS
	.long	CANDB
	.long	BULLET

DJPALS:
	.long	FRTCLS
	.long	GRNDP
	.long	UFLP
	.long	GOOBP
	.long	CANDB

DHPALS:
	.long	PITP
	.long	DESRTPL
	.long	PPLP
	.long	GRNDP
	.long	BULLET
HI3:	;PAL #0
	.word	64	;pal size
	.word >0,>400,>C42,>160,>201,>221,>241,>2A1,>1CC6,>1416
	.word >2508,>2D2A,>2D4A,>2D6B,>2D8B,>358C,>35AD,>3DCE,>4610,>4E73
	.word >56B5,>5EF7,>2C80,>34E0,>3D00,>4540,>4580,>4DC0,>5600,>5E40
	.word >66A0,>7720,>7F40,>1484,>7FED,>1400,>2C00,>3400,>4400,>5C00
	.word >7C00,>0,>4400,>8,>6600,>300,>0,>0,>0,>0
	.word >0,>0,>600,>0,>0,>0,>0,>0,>4,>0
	.word >0,>0,>0,>7FFF

OREPALS:
	.long	HI3
	.long	BIGPL1
	.long	BIGPL2
	.long	STUFFP
	.long	FRTCLS
ENTER1:	;PAL #9
	.word	31	;pal size
	.word >0,>0,>1,>2,>403,>404,>405,>406,>407,>808
	.word >809,>80A,>82B,>82C,>C2D,>C2E,>C2F,>C30,>C31,>1032
	.word >1033,>1034,>1035,>1036,>1437,>1438,>1439,>143A,>143B,>183D
	.word >185F
TC2:	;PAL #11
	.word	13	;pal size
	.word >0,>0,>4,>404,>405,>826,>827,>C28,>C29,>102A
	.word >102B,>104C,>104E

RPALS:
	.long	CRMP
	.long	CLDS8
	.long	FRTCLS
	.long	BGFRTP
	.long	PROFP2
	.long	TECPAL
	.long	GENP
	.long	PROFP
	.long	STATICP
	.long	ENTER1
	.long	DUXPAL
	.long	TC2

ROOMPALS:
	.long	CHAIRP
	.long	MTRP
