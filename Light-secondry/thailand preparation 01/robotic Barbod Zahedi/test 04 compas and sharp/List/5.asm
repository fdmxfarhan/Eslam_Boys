
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega16
;Program type             : Application
;Clock frequency          : 8.000000 MHz
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
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

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
	.DEF _c=R6
	.DEF _v=R8
	.DEF _i=R10
	.DEF _imin=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

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

_0x65:
	.DB  0xFF,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x08
	.DW  _0x65*2

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
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
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

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 11/27/2017
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
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
   .equ __sda_bit=1
   .equ __scl_bit=0
; 0000 0021 #endasm
;#include <i2c.h>
;
;// Alphanumeric LCD Module functions
;#asm
 .equ __lcd_port=0x15;PORTC
; 0000 0027 #endasm
;#include <lcd.h>
;
;#define ADC_VREF_TYPE 0x40
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 002E {

	.CSEG
_read_adc:
; 0000 002F ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0000 0030 // Delay needed for the stabilization of the ADC input voltage
; 0000 0031 delay_us(10);
	__DELAY_USB 27
; 0000 0032 // Start the AD conversion
; 0000 0033 ADCSRA|=0x40;
	SBI  0x6,6
; 0000 0034 // Wait for the AD conversion to complete
; 0000 0035 while ((ADCSRA & 0x10)==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 0036 ADCSRA|=0x10;
	SBI  0x6,4
; 0000 0037 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	JMP  _0x2020001
; 0000 0038 }
;
;// Declare your global variables here
;int cmp,c;
;#define EEPROM_BUS_ADDRESS 0xc0
;/* read/ a byte from the EEPROM */
;unsigned char compass_read(unsigned char address)
; 0000 003F  {
_compass_read:
; 0000 0040     unsigned char data;
; 0000 0041     delay_us(100);
	ST   -Y,R17
;	address -> Y+1
;	data -> R17
	CALL SUBOPT_0x0
; 0000 0042     i2c_start();
	CALL _i2c_start
; 0000 0043     delay_us(100);
	CALL SUBOPT_0x0
; 0000 0044     i2c_write(EEPROM_BUS_ADDRESS);
	LDI  R30,LOW(192)
	CALL SUBOPT_0x1
; 0000 0045     delay_us(100);
; 0000 0046     i2c_write(address);
	LDD  R30,Y+1
	CALL SUBOPT_0x1
; 0000 0047     delay_us(100);
; 0000 0048     i2c_start();
	CALL _i2c_start
; 0000 0049     delay_us(100);
	CALL SUBOPT_0x0
; 0000 004A     i2c_write(EEPROM_BUS_ADDRESS | 1);
	LDI  R30,LOW(193)
	CALL SUBOPT_0x1
; 0000 004B     delay_us(100);
; 0000 004C     data=i2c_read(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _i2c_read
	MOV  R17,R30
; 0000 004D     delay_us(100);
	CALL SUBOPT_0x0
; 0000 004E     i2c_stop();
	CALL _i2c_stop
; 0000 004F     delay_us(100);
	CALL SUBOPT_0x0
; 0000 0050     return data;
	MOV  R30,R17
	LDD  R17,Y+0
	JMP  _0x2020002
; 0000 0051  }
; int v=255;
;int i,imin,min,k;
;int SR,SB,SL;
;void sensor()
; 0000 0056     {
_sensor:
; 0000 0057     min=1023;
	LDI  R30,LOW(1023)
	LDI  R31,HIGH(1023)
	STS  _min,R30
	STS  _min+1,R31
; 0000 0058     for(i=0;i<16;i++)
	CLR  R10
	CLR  R11
_0x7:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CP   R10,R30
	CPC  R11,R31
	BRGE _0x8
; 0000 0059     {
; 0000 005A     PORTB.7=(i/8)%2;
	MOVW R26,R10
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL SUBOPT_0x2
	BRNE _0x9
	CBI  0x18,7
	RJMP _0xA
_0x9:
	SBI  0x18,7
_0xA:
; 0000 005B     PORTB.6=(i/4)%2;
	MOVW R26,R10
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x2
	BRNE _0xB
	CBI  0x18,6
	RJMP _0xC
_0xB:
	SBI  0x18,6
_0xC:
; 0000 005C     PORTB.5=(i/2)%2;
	MOVW R26,R10
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x2
	BRNE _0xD
	CBI  0x18,5
	RJMP _0xE
_0xD:
	SBI  0x18,5
_0xE:
; 0000 005D     PORTB.4=(i/1)%2;
	MOVW R26,R10
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __MODW21
	CPI  R30,0
	BRNE _0xF
	CBI  0x18,4
	RJMP _0x10
_0xF:
	SBI  0x18,4
_0x10:
; 0000 005E     if(read_adc(0)<min)
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _read_adc
	MOVW R26,R30
	LDS  R30,_min
	LDS  R31,_min+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x11
; 0000 005F     {
; 0000 0060      min=read_adc(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _read_adc
	STS  _min,R30
	STS  _min+1,R31
; 0000 0061      imin=i;
	MOVW R12,R10
; 0000 0062     }
; 0000 0063     }
_0x11:
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	RJMP _0x7
_0x8:
; 0000 0064     lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0065     lcd_putchar((imin/10)%10+'0');
	MOVW R26,R12
	CALL SUBOPT_0x3
; 0000 0066     lcd_putchar((imin)%10+'0');
	MOVW R26,R12
	CALL SUBOPT_0x4
; 0000 0067     lcd_putchar(':');
	LDI  R30,LOW(58)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0068     lcd_putchar((min/1000)%10+'0');
	CALL SUBOPT_0x5
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL SUBOPT_0x6
; 0000 0069     lcd_putchar((min/100)%10+'0');
	CALL SUBOPT_0x5
	CALL SUBOPT_0x7
; 0000 006A     lcd_putchar((min/10)%10+'0');
	CALL SUBOPT_0x5
	CALL SUBOPT_0x3
; 0000 006B     lcd_putchar((min/1)%10+'0');
	CALL SUBOPT_0x5
	CALL SUBOPT_0x4
; 0000 006C 
; 0000 006D 
; 0000 006E 
; 0000 006F     SB=read_adc(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _read_adc
	STS  _SB,R30
	STS  _SB+1,R31
; 0000 0070     SR=read_adc(2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _read_adc
	STS  _SR,R30
	STS  _SR+1,R31
; 0000 0071     SL=read_adc(3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _read_adc
	STS  _SL,R30
	STS  _SL+1,R31
; 0000 0072     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x8
; 0000 0073     lcd_putchar('L');
	LDI  R30,LOW(76)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0074     lcd_putchar((SL/100)%10+'0');
	CALL SUBOPT_0x9
	CALL SUBOPT_0x7
; 0000 0075     lcd_putchar((SL/10)%10+'0');
	CALL SUBOPT_0x9
	CALL SUBOPT_0x3
; 0000 0076     lcd_putchar((SL/1)%10+'0');
	CALL SUBOPT_0x9
	CALL SUBOPT_0x4
; 0000 0077 
; 0000 0078     lcd_gotoxy (5,1);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x8
; 0000 0079     lcd_putchar('B');
	LDI  R30,LOW(66)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 007A     lcd_putchar((SB/100)%10+'0');
	CALL SUBOPT_0xA
	CALL SUBOPT_0x7
; 0000 007B     lcd_putchar((SB/10)%10+'0');
	CALL SUBOPT_0xA
	CALL SUBOPT_0x3
; 0000 007C     lcd_putchar((SB/1)%10+'0');
	CALL SUBOPT_0xA
	CALL SUBOPT_0x4
; 0000 007D 
; 0000 007E     lcd_gotoxy(10,1);
	LDI  R30,LOW(10)
	CALL SUBOPT_0x8
; 0000 007F     lcd_putchar('R');
	LDI  R30,LOW(82)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0080     lcd_putchar((SR/100)%10+'0');
	CALL SUBOPT_0xB
	CALL SUBOPT_0x7
; 0000 0081     lcd_putchar((SR/10)%10+'0');
	CALL SUBOPT_0xB
	CALL SUBOPT_0x3
; 0000 0082     lcd_putchar((SR/1)%10+'0');
	CALL SUBOPT_0xB
	CALL SUBOPT_0x4
; 0000 0083 
; 0000 0084     k=SL-SR;
	CALL SUBOPT_0xB
	LDS  R30,_SL
	LDS  R31,_SL+1
	SUB  R30,R26
	SBC  R31,R27
	STS  _k,R30
	STS  _k+1,R31
; 0000 0085     cmp=compass_read(1)-c;
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _compass_read
	LDI  R31,0
	SUB  R30,R6
	SBC  R31,R7
	MOVW R4,R30
; 0000 0086       if(cmp>128)      cmp-=255;
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CP   R30,R4
	CPC  R31,R5
	BRGE _0x12
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	__SUBWRR 4,5,30,31
; 0000 0087       if(cmp<-128)     cmp+=128;
_0x12:
	LDI  R30,LOW(65408)
	LDI  R31,HIGH(65408)
	CP   R4,R30
	CPC  R5,R31
	BRGE _0x13
	MOVW R30,R4
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	MOVW R4,R30
; 0000 0088       lcd_gotoxy(8,0);
_0x13:
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0089       if(cmp>=0)
	CLR  R0
	CP   R4,R0
	CPC  R5,R0
	BRLT _0x14
; 0000 008A       {
; 0000 008B       lcd_putchar('+');
	LDI  R30,LOW(43)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 008C       lcd_putchar((cmp/100)%10+'0');
	MOVW R26,R4
	CALL SUBOPT_0x7
; 0000 008D       lcd_putchar((cmp/10)%10+'0');
	MOVW R26,R4
	CALL SUBOPT_0x3
; 0000 008E       lcd_putchar((cmp/1)%10+'0');
	MOVW R26,R4
	RJMP _0x5D
; 0000 008F       }
; 0000 0090       else
_0x14:
; 0000 0091       {
; 0000 0092       lcd_putchar('-');
	LDI  R30,LOW(45)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0093       lcd_putchar((-cmp/100)%10+'0');
	CALL SUBOPT_0xC
	CALL SUBOPT_0x7
; 0000 0094       lcd_putchar((-cmp/10)%10+'0');
	CALL SUBOPT_0xC
	CALL SUBOPT_0x3
; 0000 0095       lcd_putchar((-cmp/1)%10+'0');
	CALL SUBOPT_0xC
_0x5D:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0096       }
; 0000 0097     cmp*=-2;
	MOVW R30,R4
	LDI  R26,LOW(65534)
	LDI  R27,HIGH(65534)
	CALL __MULW12
	MOVW R4,R30
; 0000 0098     }
	RET
;void motor(int ml1,int ml2,int mr2,int mr1)
; 0000 009A     {
_motor:
; 0000 009B     ml1+=cmp;
;	ml1 -> Y+6
;	ml2 -> Y+4
;	mr2 -> Y+2
;	mr1 -> Y+0
	MOVW R30,R4
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 009C     ml2+=cmp;
	MOVW R30,R4
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 009D 
; 0000 009E     mr1+=cmp;
	MOVW R30,R4
	LD   R26,Y
	LDD  R27,Y+1
	ADD  R30,R26
	ADC  R31,R27
	ST   Y,R30
	STD  Y+1,R31
; 0000 009F     mr2+=cmp;
	MOVW R30,R4
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00A0 
; 0000 00A1     if(ml1>255)   ml1=255;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x16
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 00A2     if(ml1<-255)  ml1=-255;
_0x16:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x17
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 00A3     if(ml2>255)   ml2=255;
_0x17:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x18
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 00A4     if(ml2<-255)  ml2=-255;
_0x18:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x19
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 00A5     if(mr2>255)   mr2=255;
_0x19:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x1A
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00A6     if(mr2<-255)  mr2=-255;
_0x1A:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x1B
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00A7     if(mr1>255)   mr1=255;
_0x1B:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x1C
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	ST   Y,R30
	STD  Y+1,R31
; 0000 00A8     if(mr1<-255)  mr1=-255;
_0x1C:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x1D
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	ST   Y,R30
	STD  Y+1,R31
; 0000 00A9 
; 0000 00AA     ///////////////////////ml1
; 0000 00AB     if(ml1>=0)
_0x1D:
	LDD  R26,Y+7
	TST  R26
	BRMI _0x1E
; 0000 00AC         {
; 0000 00AD         PORTD.3=0;
	CBI  0x12,3
; 0000 00AE         OCR2=ml1;
	LDD  R30,Y+6
	RJMP _0x5E
; 0000 00AF         }
; 0000 00B0     else
_0x1E:
; 0000 00B1         {
; 0000 00B2         PORTD.3=1;
	SBI  0x12,3
; 0000 00B3         OCR2=ml1+255;
	LDD  R30,Y+6
	SUBI R30,-LOW(255)
_0x5E:
	OUT  0x23,R30
; 0000 00B4         }
; 0000 00B5     ///////////////////////ml2
; 0000 00B6     if(ml2>=0)
	LDD  R26,Y+5
	TST  R26
	BRMI _0x24
; 0000 00B7         {
; 0000 00B8         PORTD.2=0;
	CBI  0x12,2
; 0000 00B9         OCR1A=ml2;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RJMP _0x5F
; 0000 00BA         }
; 0000 00BB     else
_0x24:
; 0000 00BC         {
; 0000 00BD         PORTD.2=1;
	SBI  0x12,2
; 0000 00BE         OCR1A=ml2+255;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
_0x5F:
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 00BF         }
; 0000 00C0     ///////////////////////mr2
; 0000 00C1     if(mr2>=0)
	LDD  R26,Y+3
	TST  R26
	BRMI _0x2A
; 0000 00C2         {
; 0000 00C3         PORTD.1=0;
	CBI  0x12,1
; 0000 00C4         OCR1B=mr2;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	RJMP _0x60
; 0000 00C5         }
; 0000 00C6     else
_0x2A:
; 0000 00C7         {
; 0000 00C8         PORTD.1=1;
	SBI  0x12,1
; 0000 00C9         OCR1B=mr2+255;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
_0x60:
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 00CA         }
; 0000 00CB     ///////////////////////mr1
; 0000 00CC     if(mr1>=0)
	LDD  R26,Y+1
	TST  R26
	BRMI _0x30
; 0000 00CD         {
; 0000 00CE         PORTD.0=0;
	CBI  0x12,0
; 0000 00CF         OCR0=mr1;
	LD   R30,Y
	RJMP _0x61
; 0000 00D0         }
; 0000 00D1     else
_0x30:
; 0000 00D2         {
; 0000 00D3         PORTD.0=1;
	SBI  0x12,0
; 0000 00D4         OCR0=mr1+255;
	LD   R30,Y
	SUBI R30,-LOW(255)
_0x61:
	OUT  0x3C,R30
; 0000 00D5         }
; 0000 00D6     }
	ADIW R28,8
	RET
;
;void main(void)
; 0000 00D9 {
_main:
; 0000 00DA // Declare your local variables here
; 0000 00DB 
; 0000 00DC // Input/Output Ports initialization
; 0000 00DD // Port A initialization
; 0000 00DE // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00DF // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00E0 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 00E1 DDRA=0x00;
	OUT  0x1A,R30
; 0000 00E2 
; 0000 00E3 // Port B initialization
; 0000 00E4 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=In Func1=In Func0=In
; 0000 00E5 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=T State1=T State0=T
; 0000 00E6 PORTB=0x00;
	OUT  0x18,R30
; 0000 00E7 DDRB=0xF8;
	LDI  R30,LOW(248)
	OUT  0x17,R30
; 0000 00E8 
; 0000 00E9 // Port C initialization
; 0000 00EA // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00EB // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00EC PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 00ED DDRC=0x00;
	OUT  0x14,R30
; 0000 00EE 
; 0000 00EF // Port D initialization
; 0000 00F0 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 00F1 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 00F2 PORTD=0x00;
	OUT  0x12,R30
; 0000 00F3 DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 00F4 
; 0000 00F5 // Timer/Counter 0 initialization
; 0000 00F6 // Clock source: System Clock
; 0000 00F7 // Clock value: 125.000 kHz
; 0000 00F8 // Mode: Fast PWM top=0xFF
; 0000 00F9 // OC0 output: Non-Inverted PWM
; 0000 00FA TCCR0=0x6B;
	LDI  R30,LOW(107)
	OUT  0x33,R30
; 0000 00FB TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 00FC OCR0=0x00;
	OUT  0x3C,R30
; 0000 00FD 
; 0000 00FE // Timer/Counter 1 initialization
; 0000 00FF // Clock source: System Clock
; 0000 0100 // Clock value: 125.000 kHz
; 0000 0101 // Mode: Fast PWM top=0x00FF
; 0000 0102 // OC1A output: Non-Inv.
; 0000 0103 // OC1B output: Non-Inv.
; 0000 0104 // Noise Canceler: Off
; 0000 0105 // Input Capture on Falling Edge
; 0000 0106 // Timer1 Overflow Interrupt: Off
; 0000 0107 // Input Capture Interrupt: Off
; 0000 0108 // Compare A Match Interrupt: Off
; 0000 0109 // Compare B Match Interrupt: Off
; 0000 010A TCCR1A=0xA1;
	LDI  R30,LOW(161)
	OUT  0x2F,R30
; 0000 010B TCCR1B=0x0B;
	LDI  R30,LOW(11)
	OUT  0x2E,R30
; 0000 010C TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 010D TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 010E ICR1H=0x00;
	OUT  0x27,R30
; 0000 010F ICR1L=0x00;
	OUT  0x26,R30
; 0000 0110 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0111 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0112 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0113 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0114 
; 0000 0115 // Timer/Counter 2 initialization
; 0000 0116 // Clock source: System Clock
; 0000 0117 // Clock value: 125.000 kHz
; 0000 0118 // Mode: Fast PWM top=0xFF
; 0000 0119 // OC2 output: Non-Inverted PWM
; 0000 011A ASSR=0x00;
	OUT  0x22,R30
; 0000 011B TCCR2=0x6C;
	LDI  R30,LOW(108)
	OUT  0x25,R30
; 0000 011C TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 011D OCR2=0x00;
	OUT  0x23,R30
; 0000 011E 
; 0000 011F // External Interrupt(s) initialization
; 0000 0120 // INT0: Off
; 0000 0121 // INT1: Off
; 0000 0122 // INT2: Off
; 0000 0123 MCUCR=0x00;
	OUT  0x35,R30
; 0000 0124 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 0125 
; 0000 0126 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0127 TIMSK=0x00;
	OUT  0x39,R30
; 0000 0128 
; 0000 0129 // USART initialization
; 0000 012A // USART disabled
; 0000 012B UCSRB=0x00;
	OUT  0xA,R30
; 0000 012C 
; 0000 012D // Analog Comparator initialization
; 0000 012E // Analog Comparator: Off
; 0000 012F // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0130 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0131 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0132 
; 0000 0133 // ADC initialization
; 0000 0134 // ADC Clock frequency: 62.500 kHz
; 0000 0135 // ADC Voltage Reference: AVCC pin
; 0000 0136 // ADC Auto Trigger Source: ADC Stopped
; 0000 0137 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 0138 ADCSRA=0x87;
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 0139 
; 0000 013A // SPI initialization
; 0000 013B // SPI disabled
; 0000 013C SPCR=0x00;
	LDI  R30,LOW(0)
	OUT  0xD,R30
; 0000 013D 
; 0000 013E // TWI initialization
; 0000 013F // TWI disabled
; 0000 0140 TWCR=0x00;
	OUT  0x36,R30
; 0000 0141 
; 0000 0142 // I2C Bus initialization
; 0000 0143 i2c_init();
	CALL _i2c_init
; 0000 0144 
; 0000 0145 // Alphanumeric LCD initialization
; 0000 0146 // Connections specified in the
; 0000 0147 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0148 // RS - PORTC Bit 0
; 0000 0149 // RD - PORTC Bit 1
; 0000 014A // EN - PORTC Bit 2
; 0000 014B // D4 - PORTC Bit 4
; 0000 014C // D5 - PORTC Bit 5
; 0000 014D // D6 - PORTC Bit 6
; 0000 014E // D7 - PORTC Bit 7
; 0000 014F // Characters/line: 16
; 0000 0150 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 0151 c=compass_read(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _compass_read
	MOV  R6,R30
	CLR  R7
; 0000 0152 delay_ms(3000);
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0153 
; 0000 0154 while (1)
_0x36:
; 0000 0155       {
; 0000 0156       sensor();
	RCALL _sensor
; 0000 0157       if(min<700)
	CALL SUBOPT_0x5
	CPI  R26,LOW(0x2BC)
	LDI  R30,HIGH(0x2BC)
	CPC  R27,R30
	BRLT PC+3
	JMP _0x39
; 0000 0158       {
; 0000 0159       if(imin==0)           motor(255,255,-255,-255);
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x3A
	CALL SUBOPT_0xD
	CALL SUBOPT_0xD
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	RJMP _0x62
; 0000 015A 
; 0000 015B       else if(imin==1)     motor(255,-128,-255,128);                ////motor(255,128,-255,-128);
_0x3A:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x3C
	CALL SUBOPT_0xD
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	RJMP _0x63
; 0000 015C       else if(imin==2)     motor(255,-255,-255,255);                ////motor(255,0,-255,0);
_0x3C:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x3E
	CALL SUBOPT_0xD
	CALL SUBOPT_0xF
	CALL SUBOPT_0xF
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	RJMP _0x63
; 0000 015D       else if(imin==3)     motor(128,-255,-128,255);                ////motor(255,-128,-255,128);
_0x3E:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x40
	CALL SUBOPT_0x10
	CALL SUBOPT_0xF
	CALL SUBOPT_0xE
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	RJMP _0x63
; 0000 015E       else if(imin==4)     motor(0,-255,0,255);                     ////motor(255,-255,-255,255);
_0x40:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x42
	CALL SUBOPT_0x11
	CALL SUBOPT_0xF
	CALL SUBOPT_0x11
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	RJMP _0x63
; 0000 015F       else if(imin==5)     motor(-128,-255,128,255);                ////motor(128,-255,-128,255);
_0x42:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x44
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	RJMP _0x63
; 0000 0160       else if(imin==6)     motor(-255,-255,255,255);                ////motor(0,-255,0,255);
_0x44:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x46
	CALL SUBOPT_0xF
	CALL SUBOPT_0xF
	CALL SUBOPT_0xD
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	RJMP _0x63
; 0000 0161       else if(imin==7)     motor(-255,-128,255,128);                ////motor(-128,-255,128,255);
_0x46:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x48
	CALL SUBOPT_0xF
	CALL SUBOPT_0xE
	CALL SUBOPT_0xD
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	RJMP _0x63
; 0000 0162 
; 0000 0163       else if(imin==8)     motor(-255,0,255,0);                     ////motor(-255,-255,255,255);
_0x48:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x4A
	CALL SUBOPT_0xF
	CALL SUBOPT_0x11
	CALL SUBOPT_0xD
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x63
; 0000 0164 
; 0000 0165       else if(imin==9)      motor(-128,-255,128,255);                ////motor(-255,-128,255,128);
_0x4A:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x4C
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	RJMP _0x63
; 0000 0166       else if(imin==10)     motor(-255,-255,255,255);                ////motor(-255,0,255,0);
_0x4C:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x4E
	CALL SUBOPT_0xF
	CALL SUBOPT_0xF
	CALL SUBOPT_0xD
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	RJMP _0x63
; 0000 0167       else if(imin==11)     motor(-255,-128,255,128);                ////motor(-255,128,255,-128);
_0x4E:
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x50
	CALL SUBOPT_0xF
	CALL SUBOPT_0xE
	CALL SUBOPT_0xD
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	RJMP _0x63
; 0000 0168       else if(imin==12)     motor(-255,0,255,0);                     ////motor(-255,255,255,-255);
_0x50:
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x52
	CALL SUBOPT_0xF
	CALL SUBOPT_0x11
	CALL SUBOPT_0xD
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x63
; 0000 0169       else if(imin==13)     motor(-255,128,255,-128);                ////motor(-128,255,128,-255);
_0x52:
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x54
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
	CALL SUBOPT_0xD
	LDI  R30,LOW(65408)
	LDI  R31,HIGH(65408)
	RJMP _0x63
; 0000 016A       else if(imin==14)     motor(-255,255,255,-255);                ////motor(0,255,0,-255);
_0x54:
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x56
	CALL SUBOPT_0xF
	CALL SUBOPT_0xD
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	RJMP _0x62
; 0000 016B       else if(imin==15)     motor(-128,255,128,-255);                ////motor(128,255,-128,-255);
_0x56:
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x58
	CALL SUBOPT_0xE
	CALL SUBOPT_0xD
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
_0x62:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
_0x63:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _motor
; 0000 016C       }
_0x58:
; 0000 016D       else
	RJMP _0x59
_0x39:
; 0000 016E       {
; 0000 016F       k*=2;
	CALL SUBOPT_0x12
	LSL  R30
	ROL  R31
	STS  _k,R30
	STS  _k+1,R31
; 0000 0170       if(SB<200) motor(-v+k,-v-k,v-k,v+k);
	CALL SUBOPT_0xA
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRGE _0x5A
	MOVW R30,R8
	CALL __ANEGW1
	MOVW R0,R30
	LDS  R26,_k
	LDS  R27,_k+1
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R0
	CALL SUBOPT_0x12
	SUB  R26,R30
	SBC  R27,R31
	ST   -Y,R27
	ST   -Y,R26
	LDS  R26,_k
	LDS  R27,_k+1
	MOVW R30,R8
	SUB  R30,R26
	SBC  R31,R27
	CALL SUBOPT_0x13
	ADD  R30,R8
	ADC  R31,R9
	RJMP _0x64
; 0000 0171       else motor(k,-k,-k,k);
_0x5A:
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
	CALL __ANEGW1
	CALL SUBOPT_0x13
	CALL __ANEGW1
	CALL SUBOPT_0x13
_0x64:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _motor
; 0000 0172       }
_0x59:
; 0000 0173 
; 0000 0174       }
	RJMP _0x36
; 0000 0175 }
_0x5C:
	RJMP _0x5C
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
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x14
	RCALL __long_delay_G100
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R30,LOW(40)
	RCALL SUBOPT_0x15
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x15
	LDI  R30,LOW(133)
	RCALL SUBOPT_0x15
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

	.DSEG
_min:
	.BYTE 0x2
_k:
	.BYTE 0x2
_SR:
	.BYTE 0x2
_SB:
	.BYTE 0x2
_SL:
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
;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x0:
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	ST   -Y,R30
	CALL _i2c_write
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2:
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __MODW21
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	LDS  R26,_min
	LDS  R27,_min+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x6:
	CALL __DIVW21
	MOVW R26,R30
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDS  R26,_SL
	LDS  R27,_SL+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	LDS  R26,_SB
	LDS  R27,_SB+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	LDS  R26,_SR
	LDS  R27,_SR+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	MOVW R30,R4
	CALL __ANEGW1
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(65408)
	LDI  R31,HIGH(65408)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x12:
	LDS  R30,_k
	LDS  R31,_k+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	CALL __long_delay_G100
	LDI  R30,LOW(48)
	ST   -Y,R30
	RJMP __lcd_init_write_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15:
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
	ldi  r22,13
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,27
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
	rjmp __i2c_delay1

_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
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

;END OF CODE MARKER
__END_OF_CODE:
