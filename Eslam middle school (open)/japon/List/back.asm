
;CodeVisionAVR C Compiler V2.04.4a Advanced
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega16
;Program type             : Application
;Clock frequency          : 1.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _cmp=R4
	.DEF _B=R6
	.DEF _L=R8
	.DEF _R=R10
	.DEF _e=R12

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x400)
	LDI  R25,HIGH(0x400)
	LDI  R26,0x60
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x45F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x45F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x160)
	LDI  R29,HIGH(0x160)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.04.4a Advanced
;Automatic Program Generator
;© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 07/04/2017
;Author  : NeVaDa
;Company :
;Comments:
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 1.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;#include <delay.h>
;
;// I2C Bus functions
;#asm
   .equ __i2c_port=0x18 ;PORTB
   .equ __sda_bit=0
   .equ __scl_bit=1
; 0000 0021 #endasm
;#include <i2c.h>
;
;// Alphanumeric LCD Module functions
;#asm
   .equ __lcd_port=0x15 ;PORTC
; 0000 0027 #endasm
;#include <lcd.h>
;
;#define ADC_VREF_TYPE 0x40
;
;///////////////////////////cmp
;eeprom int c;
;int cmp;
;
;#define
; EEPROM_BUS_ADDRESS 0xc0
;unsigned char compass_read(unsigned char address) {
; 0000 0032 unsigned char compass_read(unsigned char address) {

	.CSEG
_compass_read:
; 0000 0033 unsigned char data;
; 0000 0034 i2c_start();
	ST   -Y,R17
;	address -> Y+1
;	data -> R17
	CALL _i2c_start
; 0000 0035 i2c_write(EEPROM_BUS_ADDRESS);
	LDI  R30,LOW(192)
	ST   -Y,R30
	CALL _i2c_write
; 0000 0036 i2c_write(address);
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _i2c_write
; 0000 0037 i2c_start();
	CALL _i2c_start
; 0000 0038 i2c_write(EEPROM_BUS_ADDRESS |1);
	LDI  R30,LOW(193)
	ST   -Y,R30
	CALL _i2c_write
; 0000 0039 data=i2c_read(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _i2c_read
	MOV  R17,R30
; 0000 003A i2c_stop();
	CALL _i2c_stop
; 0000 003B return data;
	MOV  R30,R17
	LDD  R17,Y+0
	JMP  _0x2020002
; 0000 003C }
;//////////////////////////////////
;unsigned int read_adc(unsigned char adc_input)
; 0000 003F {
_read_adc:
; 0000 0040 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0000 0041 // Delay needed for the stabilization of the ADC input voltage
; 0000 0042 delay_us(10);
	__DELAY_USB 3
; 0000 0043 // Start the AD conversion
; 0000 0044 ADCSRA|=0x40;
	SBI  0x6,6
; 0000 0045 // Wait for the AD conversion to complete
; 0000 0046 while ((ADCSRA & 0x10)==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 0047 ADCSRA|=0x10;
	SBI  0x6,4
; 0000 0048 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	JMP  _0x2020001
; 0000 0049 }
;
; int B,L,R;
; int e;
; int kr,kl,kb,kf;
; int f;
;//////////////////////////////////////////////////////////
;///////////////////////////////////////////////////////////sensor read
; int adc[16],adc_min;
; int i=0;
;void read_sensor()
; 0000 0054 {
_read_sensor:
; 0000 0055    #asm ("wdr");
	wdr
; 0000 0056 
; 0000 0057 
; 0000 0058 for(i=0;i<16;i++)
	LDI  R30,LOW(0)
	STS  _i,R30
	STS  _i+1,R30
_0x7:
	CALL SUBOPT_0x0
	SBIW R26,16
	BRLT PC+3
	JMP _0x8
; 0000 0059 {
; 0000 005A 
; 0000 005B 
; 0000 005C PORTB.4=(i/1)%2;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	BRNE _0x9
	CBI  0x18,4
	RJMP _0xA
_0x9:
	SBI  0x18,4
_0xA:
; 0000 005D PORTB.5=(i/2)%2;
	CALL SUBOPT_0x0
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x2
	BRNE _0xB
	CBI  0x18,5
	RJMP _0xC
_0xB:
	SBI  0x18,5
_0xC:
; 0000 005E PORTB.6=(i/4)%2;
	CALL SUBOPT_0x0
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x2
	BRNE _0xD
	CBI  0x18,6
	RJMP _0xE
_0xD:
	SBI  0x18,6
_0xE:
; 0000 005F PORTB.7=(i/8)%2;
	CALL SUBOPT_0x0
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL SUBOPT_0x2
	BRNE _0xF
	CBI  0x18,7
	RJMP _0x10
_0xF:
	SBI  0x18,7
_0x10:
; 0000 0060 
; 0000 0061 
; 0000 0062 adc[i]=read_adc(0);
	CALL SUBOPT_0x3
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _read_adc
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
; 0000 0063 
; 0000 0064 if(adc[adc_min]>adc[i])
	CALL SUBOPT_0x4
	LD   R0,X+
	LD   R1,X
	CALL SUBOPT_0x3
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	CP   R30,R0
	CPC  R31,R1
	BRGE _0x11
; 0000 0065 adc_min=i;
	LDS  R30,_i
	LDS  R31,_i+1
	STS  _adc_min,R30
	STS  _adc_min+1,R31
; 0000 0066 
; 0000 0067 }
_0x11:
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RJMP _0x7
_0x8:
; 0000 0068 
; 0000 0069 
; 0000 006A 
; 0000 006B 
; 0000 006C    #asm ("wdr");
	wdr
; 0000 006D 
; 0000 006E lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x5
; 0000 006F lcd_putchar((adc_min/10)%10+'0');
	CALL SUBOPT_0x6
	CALL SUBOPT_0x7
; 0000 0070 lcd_putchar((adc_min/1)%10+'0');
	CALL SUBOPT_0x6
	CALL SUBOPT_0x8
; 0000 0071 lcd_putchar(':');
	LDI  R30,LOW(58)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0072 
; 0000 0073    #asm ("wdr");
	wdr
; 0000 0074 
; 0000 0075 lcd_putchar((adc[adc_min]/1000)%10+'0');
	CALL SUBOPT_0x4
	CALL __GETW1P
	MOVW R26,R30
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL SUBOPT_0x7
; 0000 0076 lcd_putchar((adc[adc_min]/100)%10+'0');
	CALL SUBOPT_0x4
	CALL __GETW1P
	MOVW R26,R30
	CALL SUBOPT_0x9
; 0000 0077 lcd_putchar((adc[adc_min]/10)%10+'0');
	CALL SUBOPT_0x4
	CALL __GETW1P
	MOVW R26,R30
	CALL SUBOPT_0xA
; 0000 0078 lcd_putchar((adc[adc_min]/1)%10+'0');
	CALL SUBOPT_0x4
	CALL __GETW1P
	MOVW R26,R30
	CALL SUBOPT_0xB
; 0000 0079    #asm ("wdr");
	wdr
; 0000 007A 
; 0000 007B 
; 0000 007C B=read_adc(7);
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _read_adc
	MOVW R6,R30
; 0000 007D lcd_gotoxy(3,1);
	LDI  R30,LOW(3)
	CALL SUBOPT_0xC
; 0000 007E lcd_putchar((B/100)%10+'0');
	MOVW R26,R6
	CALL SUBOPT_0x9
; 0000 007F lcd_putchar((B/10)%10+'0');
	MOVW R26,R6
	CALL SUBOPT_0xA
; 0000 0080   #asm ("wdr");
	wdr
; 0000 0081 
; 0000 0082 L=read_adc(6);
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL _read_adc
	MOVW R8,R30
; 0000 0083 lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0xC
; 0000 0084 lcd_putchar((L/100)%10+'0');
	MOVW R26,R8
	CALL SUBOPT_0x9
; 0000 0085 lcd_putchar((L/10)%10+'0');
	MOVW R26,R8
	CALL SUBOPT_0xA
; 0000 0086   #asm ("wdr");
	wdr
; 0000 0087 
; 0000 0088 R=read_adc(5);
	LDI  R30,LOW(5)
	ST   -Y,R30
	RCALL _read_adc
	MOVW R10,R30
; 0000 0089 lcd_gotoxy(6,1);
	LDI  R30,LOW(6)
	CALL SUBOPT_0xC
; 0000 008A lcd_putchar((R/100)%10+'0');
	MOVW R26,R10
	CALL SUBOPT_0x9
; 0000 008B lcd_putchar((R/10)%10+'0');
	MOVW R26,R10
	CALL SUBOPT_0xA
; 0000 008C 
; 0000 008D 
; 0000 008E      #asm ("wdr");
	wdr
; 0000 008F   ////////////////////////////////back
; 0000 0090    #asm ("wdr");
	wdr
; 0000 0091 kb=read_adc(4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL _read_adc
	STS  _kb,R30
	STS  _kb+1,R31
; 0000 0092 lcd_gotoxy(9,1);
	LDI  R30,LOW(9)
	CALL SUBOPT_0xC
; 0000 0093 lcd_putchar((kb/100)%10+'0');
	CALL SUBOPT_0xD
	CALL SUBOPT_0x9
; 0000 0094 lcd_putchar((kb/10)%10+'0');
	CALL SUBOPT_0xD
	CALL SUBOPT_0xA
; 0000 0095  #asm ("wdr");
	wdr
; 0000 0096  ////////////////////////////////////left
; 0000 0097      #asm ("wdr");
	wdr
; 0000 0098 kf=read_adc(3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _read_adc
	STS  _kf,R30
	STS  _kf+1,R31
; 0000 0099 lcd_gotoxy(12,1);
	LDI  R30,LOW(12)
	CALL SUBOPT_0xC
; 0000 009A lcd_putchar((kl/100)%10+'0');
	CALL SUBOPT_0xE
	CALL SUBOPT_0x9
; 0000 009B lcd_putchar((kl/10)%10+'0');
	CALL SUBOPT_0xE
	CALL SUBOPT_0xA
; 0000 009C 
; 0000 009D      #asm ("wdr");
	wdr
; 0000 009E 
; 0000 009F  /////////////////////////////////////right
; 0000 00A0           #asm ("wdr");
	wdr
; 0000 00A1 kr=read_adc(2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _read_adc
	STS  _kr,R30
	STS  _kr+1,R31
; 0000 00A2 lcd_gotoxy(14,0);
	LDI  R30,LOW(14)
	CALL SUBOPT_0x5
; 0000 00A3 lcd_putchar((kr/100)%10+'0');
	CALL SUBOPT_0xF
	CALL SUBOPT_0x9
; 0000 00A4 lcd_putchar((kr/10)%10+'0');
	CALL SUBOPT_0xF
	CALL SUBOPT_0xA
; 0000 00A5 
; 0000 00A6      #asm ("wdr");
	wdr
; 0000 00A7 
; 0000 00A8 
; 0000 00A9 
; 0000 00AA  ////////////////////////////////////front
; 0000 00AB           #asm ("wdr");
	wdr
; 0000 00AC kl=read_adc(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _read_adc
	STS  _kl,R30
	STS  _kl+1,R31
; 0000 00AD lcd_gotoxy(11,0);
	LDI  R30,LOW(11)
	CALL SUBOPT_0x5
; 0000 00AE lcd_putchar((kf/100)%10+'0');
	CALL SUBOPT_0x10
	CALL SUBOPT_0x9
; 0000 00AF lcd_putchar((kf/10)%10+'0');
	CALL SUBOPT_0x10
	CALL SUBOPT_0xA
; 0000 00B0 
; 0000 00B1      #asm ("wdr");
	wdr
; 0000 00B2 
; 0000 00B3 
; 0000 00B4 
; 0000 00B5 
; 0000 00B6  }
	RET
;
;void motor(int ML1,int ML2,int MR2,int MR1)
; 0000 00B9 { #asm ("wdr");
_motor:
;	ML1 -> Y+6
;	ML2 -> Y+4
;	MR2 -> Y+2
;	MR1 -> Y+0
	wdr
; 0000 00BA if(MR1>255)   MR1=255;
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x12
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	ST   Y,R30
	STD  Y+1,R31
; 0000 00BB if(MR1<-255)  MR1=-255;
_0x12:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x13
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	ST   Y,R30
	STD  Y+1,R31
; 0000 00BC if(MR2>255)   MR2=255;
_0x13:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x14
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00BD if(MR2<-255)  MR2=-255;
_0x14:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x15
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00BE if(ML2>255)   ML2=255;
_0x15:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x16
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 00BF if(ML2<-255)  ML2=-255;
_0x16:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x17
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 00C0 if(ML1>255)   ML1=255;
_0x17:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x18
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 00C1 if(ML1<-255)  ML1=-255;
_0x18:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x19
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 00C2 
; 0000 00C3   #asm ("wdr");
_0x19:
	wdr
; 0000 00C4 
; 0000 00C5 ///////////////////////////////////////////////////////////////////////MR1
; 0000 00C6 
; 0000 00C7 if (MR1>0)
	LD   R26,Y
	LDD  R27,Y+1
	CALL __CPW02
	BRGE _0x1A
; 0000 00C8 {#asm ("wdr");
	wdr
; 0000 00C9 PORTD.0=0;
	CBI  0x12,0
; 0000 00CA OCR0=MR1;
	LD   R30,Y
	OUT  0x3C,R30
; 0000 00CB #asm ("wdr");}
	wdr
; 0000 00CC else if(MR1<=0)
	RJMP _0x1D
_0x1A:
	LD   R26,Y
	LDD  R27,Y+1
	CALL __CPW02
	BRLT _0x1E
; 0000 00CD {  #asm ("wdr");
	wdr
; 0000 00CE PORTD.0=1;
	SBI  0x12,0
; 0000 00CF OCR0=255+MR1;
	LD   R30,Y
	SUBI R30,-LOW(255)
	OUT  0x3C,R30
; 0000 00D0 #asm ("wdr");
	wdr
; 0000 00D1 }
; 0000 00D2 /////////////////////////////////////////////////////////////////////////MR2
; 0000 00D3 if (MR2>0)
_0x1E:
_0x1D:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __CPW02
	BRGE _0x21
; 0000 00D4 {   #asm ("wdr");
	wdr
; 0000 00D5 PORTD.1=0;
	CBI  0x12,1
; 0000 00D6 OCR1B=MR2;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 00D7 #asm ("wdr");
	wdr
; 0000 00D8 }
; 0000 00D9 else if(MR2<=0)
	RJMP _0x24
_0x21:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __CPW02
	BRLT _0x25
; 0000 00DA { #asm ("wdr");
	wdr
; 0000 00DB PORTD.1=1;
	SBI  0x12,1
; 0000 00DC OCR1B=255+MR2;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 00DD #asm ("wdr");
	wdr
; 0000 00DE }
; 0000 00DF ////////////////////////////////////////////////////////////////////////ML2
; 0000 00E0 if (ML2>0)
_0x25:
_0x24:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __CPW02
	BRGE _0x28
; 0000 00E1 { #asm ("wdr");
	wdr
; 0000 00E2 PORTD.2=0;
	CBI  0x12,2
; 0000 00E3 OCR1A=ML2;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 00E4 #asm ("wdr");
	wdr
; 0000 00E5 }
; 0000 00E6 else if(ML2<=0)
	RJMP _0x2B
_0x28:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __CPW02
	BRLT _0x2C
; 0000 00E7 {     #asm ("wdr");
	wdr
; 0000 00E8 PORTD.2=1;
	SBI  0x12,2
; 0000 00E9 OCR1A=255+ML2;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 00EA #asm ("wdr");
	wdr
; 0000 00EB }
; 0000 00EC ///////////////////////////////////////////////////////////////////////ML1
; 0000 00ED if(ML1>0)
_0x2C:
_0x2B:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __CPW02
	BRGE _0x2F
; 0000 00EE {#asm ("wdr");
	wdr
; 0000 00EF PORTD.3=0;
	CBI  0x12,3
; 0000 00F0 OCR2=ML1;
	LDD  R30,Y+6
	OUT  0x23,R30
; 0000 00F1 #asm ("wdr");
	wdr
; 0000 00F2 }
; 0000 00F3 else if(ML1<=0)
	RJMP _0x32
_0x2F:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __CPW02
	BRLT _0x33
; 0000 00F4 {  #asm ("wdr");
	wdr
; 0000 00F5 PORTD.3=1;
	SBI  0x12,3
; 0000 00F6 OCR2=255+ML1;
	LDD  R30,Y+6
	SUBI R30,-LOW(255)
	OUT  0x23,R30
; 0000 00F7 #asm ("wdr");
	wdr
; 0000 00F8 }
; 0000 00F9 
; 0000 00FA }
_0x33:
_0x32:
	ADIW R28,8
	RET
;
;void main(void)
; 0000 00FD {
_main:
; 0000 00FE // Declare your local variables here
; 0000 00FF 
; 0000 0100 // Input/Output Ports initialization
; 0000 0101 // Port A initialization
; 0000 0102 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0103 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0104 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0105 DDRA=0x00;
	OUT  0x1A,R30
; 0000 0106 
; 0000 0107 // Port B initialization
; 0000 0108 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=In Func0=In
; 0000 0109 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=T State0=T
; 0000 010A PORTB=0x00;
	OUT  0x18,R30
; 0000 010B DDRB=0xFC;
	LDI  R30,LOW(252)
	OUT  0x17,R30
; 0000 010C 
; 0000 010D // Port C initialization
; 0000 010E // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 010F // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0110 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0111 DDRC=0x00;
	OUT  0x14,R30
; 0000 0112 
; 0000 0113 // Port D initialization
; 0000 0114 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0115 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0116 PORTD=0x00;
	OUT  0x12,R30
; 0000 0117 DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0118 
; 0000 0119 // Timer/Counter 0 initialization
; 0000 011A // Clock source: System Clock
; 0000 011B // Clock value: 15.625 kHz
; 0000 011C // Mode: Fast PWM top=FFh
; 0000 011D // OC0 output: Non-Inverted PWM
; 0000 011E TCCR0=0x6B;
	LDI  R30,LOW(107)
	OUT  0x33,R30
; 0000 011F TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0120 OCR0=0x00;
	OUT  0x3C,R30
; 0000 0121 
; 0000 0122 // Timer/Counter 1 initialization
; 0000 0123 // Clock source: System Clock
; 0000 0124 // Clock value: 15.625 kHz
; 0000 0125 // Mode: Fast PWM top=00FFh
; 0000 0126 // OC1A output: Non-Inv.
; 0000 0127 // OC1B output: Non-Inv.
; 0000 0128 // Noise Canceler: Off
; 0000 0129 // Input Capture on Falling Edge
; 0000 012A // Timer1 Overflow Interrupt: Off
; 0000 012B // Input Capture Interrupt: Off
; 0000 012C // Compare A Match Interrupt: Off
; 0000 012D // Compare B Match Interrupt: Off
; 0000 012E TCCR1A=0xA1;
	LDI  R30,LOW(161)
	OUT  0x2F,R30
; 0000 012F TCCR1B=0x0B;
	LDI  R30,LOW(11)
	OUT  0x2E,R30
; 0000 0130 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0131 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0132 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0133 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0134 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0135 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0136 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0137 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0138 
; 0000 0139 // Timer/Counter 2 initialization
; 0000 013A // Clock source: System Clock
; 0000 013B // Clock value: 15.625 kHz
; 0000 013C // Mode: Fast PWM top=FFh
; 0000 013D // OC2 output: Non-Inverted PWM
; 0000 013E ASSR=0x00;
	OUT  0x22,R30
; 0000 013F TCCR2=0x6C;
	LDI  R30,LOW(108)
	OUT  0x25,R30
; 0000 0140 TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 0141 OCR2=0x00;
	OUT  0x23,R30
; 0000 0142 
; 0000 0143 // External Interrupt(s) initialization
; 0000 0144 // INT0: Off
; 0000 0145 // INT1: Off
; 0000 0146 // INT2: Off
; 0000 0147 MCUCR=0x00;
	OUT  0x35,R30
; 0000 0148 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 0149 
; 0000 014A // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 014B TIMSK=0x00;
	OUT  0x39,R30
; 0000 014C 
; 0000 014D // Analog Comparator initialization
; 0000 014E // Analog Comparator: Off
; 0000 014F // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0150 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0151 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0152 
; 0000 0153 // ADC initialization
; 0000 0154 // ADC Clock frequency: 500.000 kHz
; 0000 0155 // ADC Voltage Reference: AVCC pin
; 0000 0156 // ADC Auto Trigger Source: None
; 0000 0157 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 0158 ADCSRA=0x81;
	LDI  R30,LOW(129)
	OUT  0x6,R30
; 0000 0159 
; 0000 015A // I2C Bus initialization
; 0000 015B i2c_init();
	CALL _i2c_init
; 0000 015C 
; 0000 015D // LCD module initialization
; 0000 015E lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 015F 
; 0000 0160 // Watchdog Timer initialization
; 0000 0161 // Watchdog Timer Prescaler: OSC/256k
; 0000 0162 #pragma optsize-
; 0000 0163 WDTCR=0x1C;
	LDI  R30,LOW(28)
	OUT  0x21,R30
; 0000 0164 WDTCR=0x0C;
	LDI  R30,LOW(12)
	OUT  0x21,R30
; 0000 0165 #ifdef _OPTIMIZE_SIZE_
; 0000 0166 #pragma optsize+
; 0000 0167 #endif
; 0000 0168  if(PINC.3==1)
	SBIS 0x13,3
	RJMP _0x36
; 0000 0169 {       #asm ("wdr");
	wdr
; 0000 016A 
; 0000 016B  c=compass_read(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _compass_read
	LDI  R26,LOW(_c)
	LDI  R27,HIGH(_c)
	LDI  R31,0
	CALL __EEPROMWRW
; 0000 016C  delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 016D 
; 0000 016E 
; 0000 016F     #asm ("wdr");
	wdr
; 0000 0170  }
; 0000 0171 while (1)
_0x36:
_0x37:
; 0000 0172       {
; 0000 0173 
; 0000 0174 
; 0000 0175         #asm ("wdr");
	wdr
; 0000 0176      cmp=compass_read(1)-c;
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _compass_read
	MOV  R0,R30
	CLR  R1
	LDI  R26,LOW(_c)
	LDI  R27,HIGH(_c)
	CALL __EEPROMRDW
	MOVW R26,R0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R4,R26
; 0000 0177        if(cmp<0)    cmp=cmp+255;
	CLR  R0
	CP   R4,R0
	CPC  R5,R0
	BRGE _0x3A
	MOVW R30,R4
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	MOVW R4,R30
; 0000 0178        if(cmp>128)  cmp=cmp-255;
_0x3A:
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CP   R30,R4
	CPC  R31,R5
	BRGE _0x3B
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	__SUBWRR 4,5,30,31
; 0000 0179        if(cmp<128)  cmp=cmp;
_0x3B:
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CP   R4,R30
	CPC  R5,R31
	BRGE _0x3C
	MOVW R4,R4
; 0000 017A           #asm ("wdr");
_0x3C:
	wdr
; 0000 017B         if(cmp>=0)
	CLR  R0
	CP   R4,R0
	CPC  R5,R0
	BRLT _0x3D
; 0000 017C         {#asm ("wdr");
	wdr
; 0000 017D         lcd_gotoxy(8,0);
	LDI  R30,LOW(8)
	CALL SUBOPT_0x5
; 0000 017E //        lcd_putchar((cmp/100)%10+'0');
; 0000 017F         lcd_putchar((cmp/10)%10+'0');
	MOVW R26,R4
	CALL SUBOPT_0xA
; 0000 0180         lcd_putchar((cmp/1)%10+'0');
	MOVW R26,R4
	CALL SUBOPT_0xB
; 0000 0181          #asm ("wdr");
	wdr
; 0000 0182         }
; 0000 0183 
; 0000 0184 
; 0000 0185 
; 0000 0186 
; 0000 0187 
; 0000 0188         else
	RJMP _0x3E
_0x3D:
; 0000 0189         {
; 0000 018A         #asm ("wdr");
	wdr
; 0000 018B         lcd_gotoxy(8,0);
	LDI  R30,LOW(8)
	CALL SUBOPT_0x5
; 0000 018C //        lcd_putchar((-cmp/100)%10+'0');
; 0000 018D         lcd_putchar((-cmp/10)%10+'0');
	MOVW R30,R4
	CALL __ANEGW1
	MOVW R26,R30
	CALL SUBOPT_0xA
; 0000 018E         lcd_putchar((-cmp/1)%10+'0');
	MOVW R30,R4
	CALL __ANEGW1
	MOVW R26,R30
	CALL SUBOPT_0xB
; 0000 018F          #asm ("wdr");
	wdr
; 0000 0190         }
_0x3E:
; 0000 0191        if(cmp>-30 && cmp<20)
	LDI  R30,LOW(65506)
	LDI  R31,HIGH(65506)
	CP   R30,R4
	CPC  R31,R5
	BRGE _0x40
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CP   R4,R30
	CPC  R5,R31
	BRLT _0x41
_0x40:
	RJMP _0x3F
_0x41:
; 0000 0192        cmp=-cmp*(3.5);
	MOVW R30,R4
	CALL __ANEGW1
	CALL __CWD1
	CALL __CDF1
	__GETD2N 0x40600000
	CALL __MULF12
	CALL __CFD1
	RJMP _0x7D
; 0000 0193        else  cmp=-cmp*1;
_0x3F:
	MOVW R30,R4
	CALL __ANEGW1
_0x7D:
	MOVW R4,R30
; 0000 0194 
; 0000 0195 
; 0000 0196             #asm ("wdr");
	wdr
; 0000 0197 
; 0000 0198             e=(R-L);
	MOVW R30,R10
	SUB  R30,R8
	SBC  R31,R9
	MOVW R12,R30
; 0000 0199             read_sensor();
	CALL _read_sensor
; 0000 019A 
; 0000 019B              if((kr>600)&&(adc[adc_min]<700))
	CALL SUBOPT_0xF
	CPI  R26,LOW(0x259)
	LDI  R30,HIGH(0x259)
	CPC  R27,R30
	BRLT _0x44
	CALL SUBOPT_0x4
	CALL SUBOPT_0x11
	BRLT _0x45
_0x44:
	RJMP _0x43
_0x45:
; 0000 019C           f=1;
	CALL SUBOPT_0x12
; 0000 019D           else if((kb>600)&&(adc[adc_min]<700))
	RJMP _0x46
_0x43:
	CALL SUBOPT_0xD
	CPI  R26,LOW(0x259)
	LDI  R30,HIGH(0x259)
	CPC  R27,R30
	BRLT _0x48
	CALL SUBOPT_0x4
	CALL SUBOPT_0x11
	BRLT _0x49
_0x48:
	RJMP _0x47
_0x49:
; 0000 019E           f=1;
	CALL SUBOPT_0x12
; 0000 019F           else if((kf>600)&&(adc[adc_min]<700))
	RJMP _0x4A
_0x47:
	CALL SUBOPT_0x10
	CPI  R26,LOW(0x259)
	LDI  R30,HIGH(0x259)
	CPC  R27,R30
	BRLT _0x4C
	CALL SUBOPT_0x4
	CALL SUBOPT_0x11
	BRLT _0x4D
_0x4C:
	RJMP _0x4B
_0x4D:
; 0000 01A0           f=1;
	CALL SUBOPT_0x12
; 0000 01A1           else if((kl>600)&&(adc[adc_min]<700))
	RJMP _0x4E
_0x4B:
	CALL SUBOPT_0xE
	CPI  R26,LOW(0x259)
	LDI  R30,HIGH(0x259)
	CPC  R27,R30
	BRLT _0x50
	CALL SUBOPT_0x4
	CALL SUBOPT_0x11
	BRLT _0x51
_0x50:
	RJMP _0x4F
_0x51:
; 0000 01A2           f=1;
	CALL SUBOPT_0x12
; 0000 01A3           else f=0;
	RJMP _0x52
_0x4F:
	LDI  R30,LOW(0)
	STS  _f,R30
	STS  _f+1,R30
; 0000 01A4                   #asm ("wdr");
_0x52:
_0x4E:
_0x4A:
_0x46:
	wdr
; 0000 01A5           if (f==1)
	LDS  R26,_f
	LDS  R27,_f+1
	SBIW R26,1
	BRNE _0x53
; 0000 01A6           {
; 0000 01A7            if(B<200)                motor(-255-e+cmp,-255+e+cmp,255+e+cmp,255-e+cmp);// 8
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CP   R6,R30
	CPC  R7,R31
	BRGE _0x54
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
	MOVW R30,R12
	CALL SUBOPT_0x15
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	RJMP _0x7E
; 0000 01A8            else          motor(255-e+cmp,255+e+cmp,-255+e+cmp,-255-e+cmp);//0
_0x54:
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	CALL SUBOPT_0x13
	CALL SUBOPT_0x15
	MOVW R30,R12
	CALL SUBOPT_0x14
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
_0x7E:
	SUB  R30,R12
	SBC  R31,R13
	ADD  R30,R4
	ADC  R31,R5
	ST   -Y,R31
	ST   -Y,R30
	CALL _motor
; 0000 01A9           }
; 0000 01AA          else
	RJMP _0x56
_0x53:
; 0000 01AB         {
; 0000 01AC 
; 0000 01AD        if ((adc[adc_min]<700))
	CALL SUBOPT_0x4
	CALL SUBOPT_0x11
	BRLT PC+3
	JMP _0x57
; 0000 01AE 
; 0000 01AF     {
; 0000 01B0 
; 0000 01B1        #asm ("wdr");
	wdr
; 0000 01B2 
; 0000 01B3 
; 0000 01B4          if(adc_min==0)                  motor(255+cmp,255+cmp,-255+cmp,-255+cmp);
	LDS  R30,_adc_min
	LDS  R31,_adc_min+1
	SBIW R30,0
	BRNE _0x58
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
	RJMP _0x7F
; 0000 01B5 
; 0000 01B6 
; 0000 01B7         else if(adc_min==1)                          motor(255+cmp,128+cmp,-255+cmp,-128+cmp);///3
_0x58:
	CALL SUBOPT_0x18
	SBIW R26,1
	BRNE _0x5A
	CALL SUBOPT_0x16
	MOVW R30,R4
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	CALL SUBOPT_0x17
	CALL SUBOPT_0x19
	RJMP _0x80
; 0000 01B8        else if(adc_min==2)                          motor(255+cmp,-255+cmp,-255+cmp,255+cmp);///4
_0x5A:
	CALL SUBOPT_0x18
	SBIW R26,2
	BRNE _0x5C
	CALL SUBOPT_0x16
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	CALL SUBOPT_0x17
	CALL SUBOPT_0x1A
	RJMP _0x80
; 0000 01B9        else if(adc_min==3)                          motor(128+cmp,-255+cmp,-128+cmp,255+cmp);///5
_0x5C:
	CALL SUBOPT_0x18
	SBIW R26,3
	BRNE _0x5E
	MOVW R30,R4
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	CALL SUBOPT_0x17
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
	RJMP _0x80
; 0000 01BA        else if(adc_min==4)                          motor(0+cmp,-255+cmp,0+cmp,255+cmp);///6
_0x5E:
	CALL SUBOPT_0x18
	SBIW R26,4
	BRNE _0x60
	MOVW R30,R4
	ADIW R30,0
	CALL SUBOPT_0x17
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1A
	RJMP _0x80
; 0000 01BB        else if(adc_min==5)                          motor(-128+cmp,-255+cmp,128+cmp,255+cmp);///7
_0x60:
	CALL SUBOPT_0x18
	SBIW R26,5
	BRNE _0x62
	MOVW R30,R4
	SUBI R30,LOW(-65408)
	SBCI R31,HIGH(-65408)
	CALL SUBOPT_0x17
	CALL SUBOPT_0x1C
	RJMP _0x80
; 0000 01BC        else if(adc_min==6)                          motor(-255+cmp,-128+cmp,255+cmp,128+cmp);///9
_0x62:
	CALL SUBOPT_0x18
	SBIW R26,6
	BRNE _0x64
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
	MOVW R30,R4
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	RJMP _0x80
; 0000 01BD        else if(adc_min==7)                          motor(-255+cmp,-128+cmp,255+cmp,128+cmp);///9
_0x64:
	CALL SUBOPT_0x18
	SBIW R26,7
	BRNE _0x66
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
	MOVW R30,R4
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	RJMP _0x80
; 0000 01BE 
; 0000 01BF        else if(adc_min==8)                          motor(-255+cmp,0+cmp,255+cmp,0+cmp);///10
_0x66:
	CALL SUBOPT_0x18
	SBIW R26,8
	BRNE _0x68
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1E
	MOVW R30,R4
	ADIW R30,0
	RJMP _0x80
; 0000 01C0 
; 0000 01C1         else if(adc_min==9)                         motor(-128+cmp,-255+cmp,128+cmp,255+cmp);///7
_0x68:
	CALL SUBOPT_0x18
	SBIW R26,9
	BRNE _0x6A
	MOVW R30,R4
	SUBI R30,LOW(-65408)
	SBCI R31,HIGH(-65408)
	CALL SUBOPT_0x17
	CALL SUBOPT_0x1C
	RJMP _0x80
; 0000 01C2        else if(adc_min==10)                         motor(-255+cmp,-255+cmp,255+cmp,255+cmp);///8
_0x6A:
	CALL SUBOPT_0x18
	SBIW R26,10
	BRNE _0x6C
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x16
	MOVW R30,R4
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	RJMP _0x80
; 0000 01C3        else if(adc_min==11)                         motor(-255+cmp,-128+cmp,255+cmp,128+cmp);////9
_0x6C:
	CALL SUBOPT_0x18
	SBIW R26,11
	BRNE _0x6E
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
	MOVW R30,R4
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	RJMP _0x80
; 0000 01C4        else if(adc_min==12)                         motor(-255+cmp,0+cmp,255+cmp,0+cmp);///10
_0x6E:
	CALL SUBOPT_0x18
	SBIW R26,12
	BRNE _0x70
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1E
	MOVW R30,R4
	ADIW R30,0
	RJMP _0x80
; 0000 01C5        else if(adc_min==13)                         motor(-255+cmp,128+cmp,255+cmp,-128+cmp);///11
_0x70:
	CALL SUBOPT_0x18
	SBIW R26,13
	BRNE _0x72
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	CALL SUBOPT_0x1E
	MOVW R30,R4
	SUBI R30,LOW(-65408)
	SBCI R31,HIGH(-65408)
	RJMP _0x80
; 0000 01C6        else if(adc_min==14)                         motor(-255+cmp,255+cmp,255+cmp,-255+cmp);///12
_0x72:
	CALL SUBOPT_0x18
	SBIW R26,14
	BRNE _0x74
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	CALL SUBOPT_0x1E
	MOVW R30,R4
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	RJMP _0x7F
; 0000 01C7        else if(adc_min==15)                         motor(128+cmp,255+cmp,-128+cmp,-255+cmp);///13
_0x74:
	CALL SUBOPT_0x18
	SBIW R26,15
	BRNE _0x76
	MOVW R30,R4
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	CALL SUBOPT_0x1E
	MOVW R30,R4
	SUBI R30,LOW(-65408)
	SBCI R31,HIGH(-65408)
_0x7F:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
_0x80:
	ST   -Y,R31
	ST   -Y,R30
	CALL _motor
; 0000 01C8        #asm ("wdr");
_0x76:
	wdr
; 0000 01C9 
; 0000 01CA               }
; 0000 01CB 
; 0000 01CC 
; 0000 01CD 
; 0000 01CE 
; 0000 01CF 
; 0000 01D0       else
	RJMP _0x77
_0x57:
; 0000 01D1         {
; 0000 01D2         if(B<200)                             motor(-255+cmp-e,-255+cmp+e,255+cmp+e,255+cmp-e);// 8
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CP   R6,R30
	CPC  R7,R31
	BRGE _0x78
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x1A
	ADD  R30,R12
	ADC  R31,R13
	CALL SUBOPT_0x1A
	SUB  R30,R12
	SBC  R31,R13
	RJMP _0x81
; 0000 01D3         else if(B>300)                        motor(255+cmp-e,255+cmp+e,-255+cmp+e,-255+cmp-e);//0
_0x78:
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	CP   R30,R6
	CPC  R31,R7
	BRGE _0x7A
	MOVW R30,R4
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x17
	ADD  R30,R12
	ADC  R31,R13
	CALL SUBOPT_0x17
	SUB  R30,R12
	SBC  R31,R13
	RJMP _0x81
; 0000 01D4 //        else if(L>320)                        motor(255+cmp,-255+cmp,-255+cmp,255+cmp);///4
; 0000 01D5 //        else if(R>300)                        motor(-255+cmp,255+cmp,255+cmp,-255+cmp);///12
; 0000 01D6         else                                  motor(0+cmp,0+cmp,0+cmp,0+cmp);
_0x7A:
	MOVW R30,R4
	ADIW R30,0
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1B
_0x81:
	ST   -Y,R31
	ST   -Y,R30
	CALL _motor
; 0000 01D7         }
_0x77:
; 0000 01D8         }
_0x56:
; 0000 01D9 
; 0000 01DA       };
	RJMP _0x37
; 0000 01DB }
_0x7C:
	RJMP _0x7C
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G100:
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
__lcd_ready:
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
	RCALL __lcd_delay_G100
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G100
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
__lcd_write_nibble_G100:
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G100
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G100
	RET
__lcd_write_data:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G100
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G100
    sbi   __lcd_port,__lcd_rd     ;RD=1
	JMP  _0x2020001
__lcd_read_nibble_G100:
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G100
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G100
    andi  r30,0xf0
	RET
_lcd_read_byte0_G100:
	CALL __lcd_delay_G100
	RCALL __lcd_read_nibble_G100
    mov   r26,r30
	RCALL __lcd_read_nibble_G100
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
_lcd_gotoxy:
	CALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	CALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x2020002:
	ADIW R28,2
	RET
_lcd_clear:
	CALL __lcd_ready
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R30,LOW(12)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000004
	__lcd_putchar1:
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	ST   -Y,R30
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2000004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
    ld   r26,y
    st   -y,r26
    rcall __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	JMP  _0x2020001
__long_delay_G100:
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
__lcd_init_write_G100:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	CALL __lcd_write_nibble_G100
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x2020001
_lcd_init:
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x20
	RCALL __long_delay_G100
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R30,LOW(40)
	RCALL SUBOPT_0x21
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x21
	LDI  R30,LOW(133)
	RCALL SUBOPT_0x21
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G100
	CPI  R30,LOW(0x5)
	BREQ _0x200000B
	LDI  R30,LOW(0)
	RJMP _0x2020001
_0x200000B:
	CALL __lcd_ready
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x2020001:
	ADIW R28,1
	RET

	.ESEG
_c:
	.BYTE 0x2

	.DSEG
_kr:
	.BYTE 0x2
_kl:
	.BYTE 0x2
_kb:
	.BYTE 0x2
_kf:
	.BYTE 0x2
_f:
	.BYTE 0x2
_adc:
	.BYTE 0x20
_adc_min:
	.BYTE 0x2
_i:
	.BYTE 0x2
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	LDS  R26,_i
	LDS  R27,_i+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __MODW21
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	CALL __DIVW21
	MOVW R26,R30
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDS  R30,_i
	LDS  R31,_i+1
	LDI  R26,LOW(_adc)
	LDI  R27,HIGH(_adc)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x4:
	LDS  R30,_adc_min
	LDS  R31,_adc_min+1
	LDI  R26,LOW(_adc)
	LDI  R27,HIGH(_adc)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDS  R26,_adc_min
	LDS  R27,_adc_min+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:168 WORDS
SUBOPT_0x7:
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8:
	CALL __MODW21
	SUBI R30,-LOW(48)
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xC:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LDS  R26,_kb
	LDS  R27,_kb+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	LDS  R26,_kl
	LDS  R27,_kl+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDS  R26,_kr
	LDS  R27,_kr+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	LDS  R26,_kf
	LDS  R27,_kf+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x11:
	CALL __GETW1P
	CPI  R30,LOW(0x2BC)
	LDI  R26,HIGH(0x2BC)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _f,R30
	STS  _f+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	SUB  R30,R12
	SBC  R31,R13
	ADD  R30,R4
	ADC  R31,R5
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	ADD  R30,R4
	ADC  R31,R5
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	ADD  R30,R4
	ADC  R31,R5
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x16:
	MOVW R30,R4
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x17:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x18:
	LDS  R26,_adc_min
	LDS  R27,_adc_min+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x19:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	SUBI R30,LOW(-65408)
	SBCI R31,HIGH(-65408)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1A:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1B:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	ADIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1C:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	RJMP SUBOPT_0x1A

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1E:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1F:
	MOVW R26,R30
	SUB  R30,R12
	SBC  R31,R13
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R26
	ADD  R30,R12
	ADC  R31,R13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x20:
	CALL __long_delay_G100
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x21:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __long_delay_G100


	.CSEG
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2
_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,2
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,3
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	ld   r23,y+
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ld   r30,y+
	ldi  r23,8
__i2c_write0:
	lsl  r30
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	ret

_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

;END OF CODE MARKER
__END_OF_CODE:
