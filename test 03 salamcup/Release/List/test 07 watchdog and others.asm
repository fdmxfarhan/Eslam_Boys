
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
;global 'const' stored in FLASH: Yes
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
	.DEF _SR=R4
	.DEF _SB=R6
	.DEF _SL=R8
	.DEF _SKF=R10
	.DEF _SKL=R12

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

_0x6:
	.DB  0x96
_0x7:
	.DB  0x54
_0x41:
	.DB  0x96
_0x0:
	.DB  0x58,0x3D,0x0,0x59,0x3D,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  _v
	.DW  _0x6*2

	.DW  0x01
	.DW  _addres
	.DW  _0x7*2

	.DW  0x01
	.DW  _vs
	.DW  _0x41*2

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
;#include <delay.h>
;#include <i2c.h>
;
;#asm
    .equ __lcd_port=0x15;PORTC
; 0000 0007 #endasm
;#include <lcd.h>
;#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))
;unsigned int read_adc(unsigned char adc_input)
; 0000 000B {

	.CSEG
_read_adc:
; 0000 000C ADMUX=adc_input | ADC_VREF_TYPE;
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0000 000D // Delay needed for the stabilization of the ADC input voltage
; 0000 000E delay_us(10);
	__DELAY_USB 27
; 0000 000F // Start the AD conversion
; 0000 0010 ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 0011 // Wait for the AD conversion to complete
; 0000 0012 while ((ADCSRA & (1<<ADIF))==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 0013 ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 0014 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	ADIW R28,1
	RET
; 0000 0015 }
;
;
;int SR,SB,SL,SKF,SKL,SKR,SKB;
;int cmp;
;eeprom int c;
;int v=150;

	.DSEG
;int k;
;#define I2C_7BIT_DEVICE_ADDRESS 0x54
;#define EEPROM_BUS_ADDRES (I2C_7BIT_DEVICE_ADDRESS << 1)
;
;unsigned char addres=0x54;
;/* read a byte from the EEPROM */
;unsigned char read()
; 0000 0023 {

	.CSEG
_read:
; 0000 0024 unsigned char data;
; 0000 0025 i2c_start();
	ST   -Y,R17
;	data -> R17
	CALL _i2c_start
; 0000 0026 i2c_write(EEPROM_BUS_ADDRES | 0);
	LDI  R30,LOW(168)
	ST   -Y,R30
	CALL _i2c_write
; 0000 0027 /*send MSB of address */
; 0000 0028 i2c_write(addres >> 8);
	LDS  R30,_addres
	LDI  R31,0
	CALL __ASRW8
	ST   -Y,R30
	CALL _i2c_write
; 0000 0029 /* send LSB of address */
; 0000 002A i2c_write((unsigned char) addres);
	LDS  R30,_addres
	ST   -Y,R30
	CALL _i2c_write
; 0000 002B i2c_start();
	CALL _i2c_start
; 0000 002C i2c_write(EEPROM_BUS_ADDRES | 1);
	LDI  R30,LOW(169)
	ST   -Y,R30
	CALL _i2c_write
; 0000 002D data=i2c_read(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _i2c_read
	MOV  R17,R30
; 0000 002E i2c_stop();
	CALL _i2c_stop
; 0000 002F return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 0030 }
;#define EEPROM_BUS_ADDRESS 0xc0
;unsigned char compass_read(unsigned char address)
; 0000 0033  {
_compass_read:
; 0000 0034     unsigned char data;
; 0000 0035     delay_us(100);
	ST   -Y,R17
;	address -> Y+1
;	data -> R17
	CALL SUBOPT_0x0
; 0000 0036     i2c_start();
	CALL _i2c_start
; 0000 0037     delay_us(100);
	CALL SUBOPT_0x0
; 0000 0038     i2c_write(EEPROM_BUS_ADDRESS);
	LDI  R30,LOW(192)
	CALL SUBOPT_0x1
; 0000 0039     delay_us(100);
; 0000 003A     i2c_write(address);
	LDD  R30,Y+1
	CALL SUBOPT_0x1
; 0000 003B     delay_us(100);
; 0000 003C     i2c_start();
	CALL _i2c_start
; 0000 003D     delay_us(100);
	CALL SUBOPT_0x0
; 0000 003E     i2c_write(EEPROM_BUS_ADDRESS | 1);
	LDI  R30,LOW(193)
	CALL SUBOPT_0x1
; 0000 003F     delay_us(100);
; 0000 0040     data=i2c_read(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _i2c_read
	MOV  R17,R30
; 0000 0041     delay_us(100);
	CALL SUBOPT_0x0
; 0000 0042     i2c_stop();
	CALL _i2c_stop
; 0000 0043     delay_us(100);
	CALL SUBOPT_0x0
; 0000 0044     return data;
	MOV  R30,R17
	LDD  R17,Y+0
	ADIW R28,2
	RET
; 0000 0045  }
;
;int x, y, w, h, ch, sn;
;char a,out=0 ;
;
;void read_pixy()
; 0000 004B       {
_read_pixy:
; 0000 004C       a=read();
	CALL SUBOPT_0x2
; 0000 004D       //b=getchar();
; 0000 004E       if(a==0xaa)
	CPI  R26,LOW(0xAA)
	BREQ PC+3
	JMP _0x8
; 0000 004F         {
; 0000 0050         a=read();
	CALL SUBOPT_0x2
; 0000 0051         if(a==0x55){
	CPI  R26,LOW(0x55)
	BREQ PC+3
	JMP _0x9
; 0000 0052         read();
	RCALL _read
; 0000 0053         ch = read();
	CALL SUBOPT_0x3
	STS  _ch,R30
	STS  _ch+1,R31
; 0000 0054         ch+= read() * 255;
	CALL SUBOPT_0x4
	LDS  R26,_ch
	LDS  R27,_ch+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _ch,R30
	STS  _ch+1,R31
; 0000 0055         sn = read();
	CALL SUBOPT_0x3
	STS  _sn,R30
	STS  _sn+1,R31
; 0000 0056         sn += read() * 255;
	CALL SUBOPT_0x4
	LDS  R26,_sn
	LDS  R27,_sn+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _sn,R30
	STS  _sn+1,R31
; 0000 0057         x = read();
	CALL SUBOPT_0x3
	STS  _x,R30
	STS  _x+1,R31
; 0000 0058         x+=read()*255;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
	ADD  R30,R26
	ADC  R31,R27
	STS  _x,R30
	STS  _x+1,R31
; 0000 0059         y = read();
	CALL SUBOPT_0x3
	STS  _y,R30
	STS  _y+1,R31
; 0000 005A         y += read() * 255;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x6
	ADD  R30,R26
	ADC  R31,R27
	STS  _y,R30
	STS  _y+1,R31
; 0000 005B         w = read();
	CALL SUBOPT_0x3
	STS  _w,R30
	STS  _w+1,R31
; 0000 005C         w += read() * 255;
	CALL SUBOPT_0x4
	LDS  R26,_w
	LDS  R27,_w+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _w,R30
	STS  _w+1,R31
; 0000 005D         h = read();
	CALL SUBOPT_0x3
	STS  _h,R30
	STS  _h+1,R31
; 0000 005E         h += read() * 255;
	CALL SUBOPT_0x4
	LDS  R26,_h
	LDS  R27,_h+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _h,R30
	STS  _h+1,R31
; 0000 005F         }}
_0x9:
; 0000 0060       lcd_gotoxy(0,0);
_0x8:
	LDI  R30,LOW(0)
	CALL SUBOPT_0x7
; 0000 0061       lcd_putsf("X=");
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0062       lcd_putchar((x/100)%10+'0');
	CALL SUBOPT_0x5
	CALL SUBOPT_0x8
; 0000 0063       lcd_putchar((x/10)%10+'0');
	CALL SUBOPT_0x5
	CALL SUBOPT_0x9
; 0000 0064       lcd_putchar((x/1)%10+'0');
	CALL SUBOPT_0x5
	CALL SUBOPT_0xA
; 0000 0065 
; 0000 0066       lcd_gotoxy(6,0);
	LDI  R30,LOW(6)
	CALL SUBOPT_0x7
; 0000 0067       lcd_putsf("Y=");
	__POINTW1FN _0x0,3
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0068       lcd_putchar((y/100)%10+'0');
	CALL SUBOPT_0x6
	CALL SUBOPT_0x8
; 0000 0069       lcd_putchar((y/10)%10+'0');
	CALL SUBOPT_0x6
	CALL SUBOPT_0x9
; 0000 006A       lcd_putchar((y/1)%10+'0');
	CALL SUBOPT_0x6
	CALL SUBOPT_0xA
; 0000 006B 
; 0000 006C 
; 0000 006D       }
	RET
;
;void sensor()
; 0000 0070     {
_sensor:
; 0000 0071     #asm("wdr");
	wdr
; 0000 0072     if(PINC.3==1) c = compass_read(1);
	SBIS 0x13,3
	RJMP _0xA
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _compass_read
	LDI  R26,LOW(_c)
	LDI  R27,HIGH(_c)
	LDI  R31,0
	CALL __EEPROMWRW
; 0000 0073     {
_0xA:
; 0000 0074     #asm("wdr");
	wdr
; 0000 0075     SB=read_adc(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _read_adc
	MOVW R6,R30
; 0000 0076     SR=read_adc(2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _read_adc
	MOVW R4,R30
; 0000 0077     SL=read_adc(3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _read_adc
	MOVW R8,R30
; 0000 0078     SKF=read_adc(4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL _read_adc
	MOVW R10,R30
; 0000 0079     SKR=read_adc(5);
	LDI  R30,LOW(5)
	ST   -Y,R30
	RCALL _read_adc
	STS  _SKR,R30
	STS  _SKR+1,R31
; 0000 007A     SKL=read_adc(7);
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _read_adc
	MOVW R12,R30
; 0000 007B     SKB=read_adc(6);
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL _read_adc
	STS  _SKB,R30
	STS  _SKB+1,R31
; 0000 007C     }
; 0000 007D 
; 0000 007E     {
; 0000 007F     #asm("wdr");
	wdr
; 0000 0080     lcd_gotoxy(12,1);
	LDI  R30,LOW(12)
	CALL SUBOPT_0xB
; 0000 0081     lcd_putchar((SKL/100)%10+'0');
	MOVW R26,R12
	CALL SUBOPT_0x8
; 0000 0082     lcd_putchar((SKL/10)%10+'0');
	MOVW R26,R12
	CALL SUBOPT_0x9
; 0000 0083     lcd_putchar((SKL/1)%10+'0');
	MOVW R26,R12
	CALL SUBOPT_0xA
; 0000 0084 
; 0000 0085     lcd_gotoxy(8,1);
	LDI  R30,LOW(8)
	CALL SUBOPT_0xB
; 0000 0086     lcd_putchar((SKB/100)%10+'0');
	CALL SUBOPT_0xC
	CALL SUBOPT_0x8
; 0000 0087     lcd_putchar((SKB/10)%10+'0');
	CALL SUBOPT_0xC
	CALL SUBOPT_0x9
; 0000 0088     lcd_putchar((SKB/1)%10+'0');
	CALL SUBOPT_0xC
	CALL SUBOPT_0xA
; 0000 0089 
; 0000 008A     lcd_gotoxy(4,1);
	LDI  R30,LOW(4)
	CALL SUBOPT_0xB
; 0000 008B     lcd_putchar((SKR/100)%10+'0');
	CALL SUBOPT_0xD
	CALL SUBOPT_0x8
; 0000 008C     lcd_putchar((SKR/10)%10+'0');
	CALL SUBOPT_0xD
	CALL SUBOPT_0x9
; 0000 008D     lcd_putchar((SKR/1)%10+'0');
	CALL SUBOPT_0xD
	CALL SUBOPT_0xA
; 0000 008E 
; 0000 008F     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0xB
; 0000 0090     lcd_putchar((SKF/100)%10+'0');
	MOVW R26,R10
	CALL SUBOPT_0x8
; 0000 0091     lcd_putchar((SKF/10)%10+'0');
	MOVW R26,R10
	CALL SUBOPT_0x9
; 0000 0092     lcd_putchar((SKF/1)%10+'0');
	MOVW R26,R10
	CALL SUBOPT_0xA
; 0000 0093 
; 0000 0094 //    lcd_gotoxy(0,1);
; 0000 0095 //    lcd_putchar((SL/100)%10+'0');
; 0000 0096 //    lcd_putchar((SL/10)%10+'0');
; 0000 0097 //    lcd_putchar((SL/1)%10+'0');
; 0000 0098 //    lcd_gotoxy(4,1);
; 0000 0099 //    lcd_putchar((SB/100)%10+'0');
; 0000 009A //    lcd_putchar((SB/10)%10+'0');
; 0000 009B //    lcd_putchar((SB/1)%10+'0');
; 0000 009C //    lcd_gotoxy(8,1);
; 0000 009D //    lcd_putchar((SR/100)%10+'0');
; 0000 009E //    lcd_putchar((SR/10)%10+'0');
; 0000 009F //    lcd_putchar((SR/1)%10+'0');
; 0000 00A0     }
; 0000 00A1     k=SL-SR;
	MOVW R30,R8
	SUB  R30,R4
	SBC  R31,R5
	STS  _k,R30
	STS  _k+1,R31
; 0000 00A2     {
; 0000 00A3     #asm("wdr");
	wdr
; 0000 00A4     cmp=compass_read(1)-c;
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _compass_read
	MOV  R0,R30
	CLR  R1
	LDI  R26,LOW(_c)
	LDI  R27,HIGH(_c)
	CALL __EEPROMRDW
	MOVW R26,R0
	SUB  R26,R30
	SBC  R27,R31
	STS  _cmp,R26
	STS  _cmp+1,R27
; 0000 00A5 
; 0000 00A6     if (SL < SR && k>50)
	__CPWRR 8,9,4,5
	BRGE _0xC
	CALL SUBOPT_0xE
	SBIW R26,51
	BRGE _0xD
_0xC:
	RJMP _0xB
_0xD:
; 0000 00A7         {
; 0000 00A8         cmp = SR/32;
	MOVW R26,R4
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	RJMP _0x132
; 0000 00A9         v = 200;
; 0000 00AA         }
; 0000 00AB     else if (SR <= SL && k<-50)
_0xB:
	__CPWRR 8,9,4,5
	BRLT _0x10
	CALL SUBOPT_0xE
	CPI  R26,LOW(0xFFCE)
	LDI  R30,HIGH(0xFFCE)
	CPC  R27,R30
	BRLT _0x11
_0x10:
	RJMP _0xF
_0x11:
; 0000 00AC         {
; 0000 00AD         cmp = SL/10;
	MOVW R26,R8
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
_0x132:
	CALL __DIVW21
	CALL SUBOPT_0xF
; 0000 00AE         v = 200;
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	STS  _v,R30
	STS  _v+1,R31
; 0000 00AF         }
; 0000 00B0     if(cmp>128)  cmp=cmp-255;
_0xF:
	CALL SUBOPT_0x10
	CPI  R26,LOW(0x81)
	LDI  R30,HIGH(0x81)
	CPC  R27,R30
	BRLT _0x12
	CALL SUBOPT_0x11
	SUBI R30,LOW(255)
	SBCI R31,HIGH(255)
	CALL SUBOPT_0xF
; 0000 00B1     if(cmp<-128) cmp=cmp+255;
_0x12:
	CALL SUBOPT_0x10
	CPI  R26,LOW(0xFF80)
	LDI  R30,HIGH(0xFF80)
	CPC  R27,R30
	BRGE _0x13
	CALL SUBOPT_0x11
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	CALL SUBOPT_0xF
; 0000 00B2     if (SB < 150 && SR > 250 && SR < 150)
_0x13:
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	CP   R6,R30
	CPC  R7,R31
	BRGE _0x15
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CP   R30,R4
	CPC  R31,R5
	BRGE _0x15
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	CP   R4,R30
	CPC  R5,R31
	BRLT _0x16
_0x15:
	RJMP _0x14
_0x16:
; 0000 00B3         {
; 0000 00B4         cmp = cmp+((SR*3)/20);
	MOVW R30,R4
	RJMP _0x133
; 0000 00B5         }
; 0000 00B6     else if (SB < 150 && SL > 250 && SL < 150)
_0x14:
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	CP   R6,R30
	CPC  R7,R31
	BRGE _0x19
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CP   R30,R8
	CPC  R31,R9
	BRGE _0x19
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	CP   R8,R30
	CPC  R9,R31
	BRLT _0x1A
_0x19:
	RJMP _0x18
_0x1A:
; 0000 00B7         {
; 0000 00B8         cmp = cmp+((SL*3)/20);
	MOVW R30,R8
_0x133:
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MULW12
	MOVW R26,R30
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL __DIVW21
	CALL SUBOPT_0x10
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0xF
; 0000 00B9         }
; 0000 00BA         lcd_gotoxy(11,0);
_0x18:
	LDI  R30,LOW(11)
	CALL SUBOPT_0x7
; 0000 00BB     if(cmp>=0)
	LDS  R26,_cmp+1
	TST  R26
	BRMI _0x1B
; 0000 00BC         {
; 0000 00BD         lcd_putchar('+');
	LDI  R30,LOW(43)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 00BE         lcd_putchar((cmp/100)%10+'0');
	CALL SUBOPT_0x10
	CALL SUBOPT_0x8
; 0000 00BF         lcd_putchar((cmp/10)%10+'0');
	CALL SUBOPT_0x10
	CALL SUBOPT_0x9
; 0000 00C0         lcd_putchar((cmp/1)%10+'0');
	CALL SUBOPT_0x10
	RJMP _0x134
; 0000 00C1         }
; 0000 00C2     else
_0x1B:
; 0000 00C3         {
; 0000 00C4         lcd_putchar('-');
	LDI  R30,LOW(45)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 00C5         lcd_putchar((-cmp/100)%10+'0');
	CALL SUBOPT_0x12
	CALL SUBOPT_0x8
; 0000 00C6         lcd_putchar((-cmp/10)%10+'0');
	CALL SUBOPT_0x12
	CALL SUBOPT_0x9
; 0000 00C7         lcd_putchar((-cmp/1)%10+'0');
	CALL SUBOPT_0x12
_0x134:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 00C8         }
; 0000 00C9         }
; 0000 00CA     if (cmp > -15 && cmp < 15)    cmp*=-3;
	CALL SUBOPT_0x10
	LDI  R30,LOW(65521)
	LDI  R31,HIGH(65521)
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x1E
	CALL SUBOPT_0x10
	SBIW R26,15
	BRLT _0x1F
_0x1E:
	RJMP _0x1D
_0x1F:
	CALL SUBOPT_0x11
	LDI  R26,LOW(65533)
	LDI  R27,HIGH(65533)
	RJMP _0x135
; 0000 00CB     else  cmp*=-2;
_0x1D:
	CALL SUBOPT_0x11
	LDI  R26,LOW(65534)
	LDI  R27,HIGH(65534)
_0x135:
	CALL __MULW12
	CALL SUBOPT_0xF
; 0000 00CC     }
	RET
;
;void motor(int ml1,int ml2,int mr2,int mr1)
; 0000 00CF     {
_motor:
; 0000 00D0     sensor();
;	ml1 -> Y+6
;	ml2 -> Y+4
;	mr2 -> Y+2
;	mr1 -> Y+0
	RCALL _sensor
; 0000 00D1     #asm("wdr");
	wdr
; 0000 00D2     {
; 0000 00D3     ml1+=cmp;
	CALL SUBOPT_0x11
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 00D4     ml2+=cmp;
	CALL SUBOPT_0x11
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 00D5     mr2+=cmp;
	CALL SUBOPT_0x11
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00D6     mr1+=cmp;
	CALL SUBOPT_0x11
	LD   R26,Y
	LDD  R27,Y+1
	ADD  R30,R26
	ADC  R31,R27
	ST   Y,R30
	STD  Y+1,R31
; 0000 00D7     }
; 0000 00D8     {
; 0000 00D9     if(ml1>255) ml1=255;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x21
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 00DA     if(ml2>255) ml2=255;
_0x21:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x22
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 00DB     if(mr2>255) mr2=255;
_0x22:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x23
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00DC     if(mr1>255) mr1=255;
_0x23:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x24
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	ST   Y,R30
	STD  Y+1,R31
; 0000 00DD 
; 0000 00DE     if(ml1<-255) ml1=-255;
_0x24:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x25
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 00DF     if(ml2<-255) ml2=-255;
_0x25:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x26
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 00E0     if(mr2<-255) mr2=-255;
_0x26:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x27
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00E1     if(mr1<-255) mr1=-255;
_0x27:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x28
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	ST   Y,R30
	STD  Y+1,R31
; 0000 00E2     }
_0x28:
; 0000 00E3     //////////////mr1
; 0000 00E4     {
; 0000 00E5     if(mr1>=0)
	LDD  R26,Y+1
	TST  R26
	BRMI _0x29
; 0000 00E6         {
; 0000 00E7         #asm("wdr");
	wdr
; 0000 00E8         PORTD.0=0;
	CBI  0x12,0
; 0000 00E9         OCR0=mr1;
	LD   R30,Y
	RJMP _0x136
; 0000 00EA         }
; 0000 00EB     else
_0x29:
; 0000 00EC         {
; 0000 00ED         #asm("wdr");
	wdr
; 0000 00EE         PORTD.0=1;
	SBI  0x12,0
; 0000 00EF         OCR0=mr1+255;
	LD   R30,Y
	SUBI R30,-LOW(255)
_0x136:
	OUT  0x3C,R30
; 0000 00F0         }
; 0000 00F1         }
; 0000 00F2     //////////////mr2
; 0000 00F3     {
; 0000 00F4     if(mr2>=0)
	LDD  R26,Y+3
	TST  R26
	BRMI _0x2F
; 0000 00F5         {
; 0000 00F6         #asm("wdr");
	wdr
; 0000 00F7         PORTD.1=0;
	CBI  0x12,1
; 0000 00F8         OCR1B=mr2;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	RJMP _0x137
; 0000 00F9         }
; 0000 00FA     else
_0x2F:
; 0000 00FB         {
; 0000 00FC         #asm("wdr");
	wdr
; 0000 00FD         PORTD.1=1;
	SBI  0x12,1
; 0000 00FE         OCR1B=mr2+255;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
_0x137:
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 00FF         }
; 0000 0100         }
; 0000 0101     //////////////mL2
; 0000 0102     {
; 0000 0103     if(ml2>=0)
	LDD  R26,Y+5
	TST  R26
	BRMI _0x35
; 0000 0104         {
; 0000 0105         #asm("wdr");
	wdr
; 0000 0106         PORTD.2=0;
	CBI  0x12,2
; 0000 0107         OCR1A=ml2;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RJMP _0x138
; 0000 0108         }
; 0000 0109     else
_0x35:
; 0000 010A         {
; 0000 010B         #asm("wdr");
	wdr
; 0000 010C         PORTD.2=1;
	SBI  0x12,2
; 0000 010D         OCR1A=ml2+255;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
_0x138:
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 010E         }
; 0000 010F         }
; 0000 0110     //////////////ml1
; 0000 0111     {
; 0000 0112     if(ml1>=0)
	LDD  R26,Y+7
	TST  R26
	BRMI _0x3B
; 0000 0113         {
; 0000 0114         #asm("wdr");
	wdr
; 0000 0115         PORTD.3=0;
	CBI  0x12,3
; 0000 0116         OCR2=ml1;
	LDD  R30,Y+6
	RJMP _0x139
; 0000 0117         }
; 0000 0118     else
_0x3B:
; 0000 0119         {
; 0000 011A         #asm("wdr");
	wdr
; 0000 011B         PORTD.3=1;
	SBI  0x12,3
; 0000 011C         OCR2=ml1+255;
	LDD  R30,Y+6
	SUBI R30,-LOW(255)
_0x139:
	OUT  0x23,R30
; 0000 011D         }
; 0000 011E         }
; 0000 011F 
; 0000 0120     }
	ADIW R28,8
	RET
;int vs=150;

	.DSEG
;void move(int d)
; 0000 0123     {

	.CSEG
_move:
; 0000 0124     if (d==0)       motor(v,v,-v,-v);
;	d -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,0
	BRNE _0x42
	CALL SUBOPT_0x13
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	CALL SUBOPT_0x14
	RJMP _0x13A
; 0000 0125     else if (d==1)  motor(vs,vs/2,-vs,-vs/2);
_0x42:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,1
	BRNE _0x44
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
	RJMP _0x13B
; 0000 0126     else if (d==2)  motor(vs,0,-vs,0);
_0x44:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,2
	BRNE _0x46
	CALL SUBOPT_0x1B
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0x19
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x13B
; 0000 0127     else if (d==3)  motor(vs,-vs/2,-vs,vs/2);
_0x46:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,3
	BRNE _0x48
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1C
	RJMP _0x13B
; 0000 0128     else if (d==4)  motor(vs,-vs,-vs,vs);
_0x48:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,4
	BRNE _0x4A
	CALL SUBOPT_0x16
	CALL SUBOPT_0x19
	CALL SUBOPT_0x16
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
	RJMP _0x13B
; 0000 0129     else if (d==5)  motor(v/2,-v,-v/2,v);
_0x4A:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,5
	BRNE _0x4C
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x15
	CALL SUBOPT_0x1F
	MOVW R26,R30
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1E
	RJMP _0x13B
; 0000 012A     else if (d==6)  motor(0,-v,0,v);
_0x4C:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,6
	BRNE _0x4E
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x15
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0x1E
	RJMP _0x13B
; 0000 012B     else if (d==7)  motor(-v/2,-v,v/2,v);
_0x4E:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,7
	BRNE _0x50
	CALL SUBOPT_0x1F
	MOVW R22,R30
	MOVW R26,R30
	CALL SUBOPT_0x18
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R23
	ST   -Y,R22
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
	RJMP _0x13B
; 0000 012C     else if (d==8)  motor(-v,-v,v,v);
_0x50:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,8
	BRNE _0x52
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
	CALL SUBOPT_0x14
	RJMP _0x13B
; 0000 012D     else if (d==9)  motor(-v,-v/2,v,v/2);
_0x52:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,9
	BRNE _0x54
	CALL SUBOPT_0x20
	MOVW R26,R30
	CALL SUBOPT_0x18
	CALL SUBOPT_0x21
	CALL SUBOPT_0x1D
	RJMP _0x13B
; 0000 012E     else if (d==10) motor(-v,0,v,0);
_0x54:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,10
	BRNE _0x56
	CALL SUBOPT_0x20
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0x21
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x13B
; 0000 012F     else if (d==11) motor(-v,v/2,v,-v/2);
_0x56:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,11
	BRNE _0x58
	CALL SUBOPT_0x20
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x21
	CALL SUBOPT_0x1F
	MOVW R26,R30
	CALL SUBOPT_0x18
	RJMP _0x13B
; 0000 0130     else if (d==12) motor(-vs,vs,vs,-vs);
_0x58:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,12
	BRNE _0x5A
	CALL SUBOPT_0x16
	CALL SUBOPT_0x15
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x16
	RJMP _0x13C
; 0000 0131     else if (d==13) motor(-vs/2,vs,vs/2,-vs);
_0x5A:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,13
	BRNE _0x5C
	CALL SUBOPT_0x1A
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
	RJMP _0x13D
; 0000 0132     else if (d==14) motor(0,vs,0,-vs);
_0x5C:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,14
	BRNE _0x5E
	CALL SUBOPT_0x22
	CALL SUBOPT_0x1B
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x13C
; 0000 0133     else if (d==15) motor(vs/2,vs,-vs/2,-vs);
_0x5E:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,15
	BRNE _0x60
	CALL SUBOPT_0x1C
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x16
	CALL __ANEGW1
	MOVW R26,R30
_0x13D:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
_0x13C:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x16
_0x13A:
	CALL __ANEGW1
_0x13B:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _motor
; 0000 0134     }
_0x60:
	JMP  _0x2020002
;
;//int fl1=0,fl2=0;
;int imin;
;void catch()
; 0000 0139     {
_catch:
; 0000 013A 
; 0000 013B     if(a!=0)
	LDS  R30,_a
	CPI  R30,0
	BRNE PC+3
	JMP _0x61
; 0000 013C         {
; 0000 013D         if(y<=60)
	CALL SUBOPT_0x6
	SBIW R26,61
	BRGE _0x62
; 0000 013E             {
; 0000 013F             if(x>30 && x<=70)           {move(2);imin=2;} //3
	CALL SUBOPT_0x5
	SBIW R26,31
	BRLT _0x64
	CALL SUBOPT_0x23
	BRLT _0x65
_0x64:
	RJMP _0x63
_0x65:
	CALL SUBOPT_0x24
	RJMP _0x13E
; 0000 0140             else if(x>70 && x<=110)     {move(2);imin=2;}
_0x63:
	CALL SUBOPT_0x23
	BRLT _0x68
	CALL SUBOPT_0x25
	BRLT _0x69
_0x68:
	RJMP _0x67
_0x69:
	CALL SUBOPT_0x24
	RJMP _0x13E
; 0000 0141             else if(x>110 && x<=150)    {move(0);imin=0;}
_0x67:
	CALL SUBOPT_0x25
	BRLT _0x6C
	CALL SUBOPT_0x26
	BRLT _0x6D
_0x6C:
	RJMP _0x6B
_0x6D:
	CALL SUBOPT_0x22
	CALL SUBOPT_0x27
; 0000 0142             else if(x>150 && x<=190)    {move(14);imin=14;}
	RJMP _0x6E
_0x6B:
	CALL SUBOPT_0x26
	BRLT _0x70
	CALL SUBOPT_0x28
	BRLT _0x71
_0x70:
	RJMP _0x6F
_0x71:
	RJMP _0x13F
; 0000 0143             else if(x>190 && x<=230)    {move(14);imin=14;}  //13
_0x6F:
	CALL SUBOPT_0x28
	BRLT _0x74
	CALL SUBOPT_0x29
	BRLT _0x75
_0x74:
	RJMP _0x73
_0x75:
_0x13F:
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CALL SUBOPT_0x2A
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
_0x13E:
	STS  _imin,R30
	STS  _imin+1,R31
; 0000 0144             }
_0x73:
_0x6E:
; 0000 0145         else if(y>60 && y<=120)
	RJMP _0x76
_0x62:
	CALL SUBOPT_0x6
	SBIW R26,61
	BRLT _0x78
	CALL SUBOPT_0x6
	CPI  R26,LOW(0x79)
	LDI  R30,HIGH(0x79)
	CPC  R27,R30
	BRLT _0x79
_0x78:
	RJMP _0x77
_0x79:
; 0000 0146             {
; 0000 0147             if(x>30 && x<=70)           {move(6);imin=4;}
	CALL SUBOPT_0x5
	SBIW R26,31
	BRLT _0x7B
	CALL SUBOPT_0x23
	BRLT _0x7C
_0x7B:
	RJMP _0x7A
_0x7C:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL SUBOPT_0x2A
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RJMP _0x140
; 0000 0148             else if(x>70 && x<=90)     {move(7);imin=4;}
_0x7A:
	CALL SUBOPT_0x23
	BRLT _0x7F
	CALL SUBOPT_0x5
	CPI  R26,LOW(0x5B)
	LDI  R30,HIGH(0x5B)
	CPC  R27,R30
	BRLT _0x80
_0x7F:
	RJMP _0x7E
_0x80:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0x2A
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RJMP _0x140
; 0000 0149             else if(x>90 && x<=170)    {move(0);imin=0;}
_0x7E:
	CALL SUBOPT_0x5
	CPI  R26,LOW(0x5B)
	LDI  R30,HIGH(0x5B)
	CPC  R27,R30
	BRLT _0x83
	CALL SUBOPT_0x5
	CPI  R26,LOW(0xAB)
	LDI  R30,HIGH(0xAB)
	CPC  R27,R30
	BRLT _0x84
_0x83:
	RJMP _0x82
_0x84:
	CALL SUBOPT_0x22
	CALL SUBOPT_0x27
; 0000 014A             else if(x>170 && x<=190)    {move(9);imin=12;}
	RJMP _0x85
_0x82:
	CALL SUBOPT_0x5
	CPI  R26,LOW(0xAB)
	LDI  R30,HIGH(0xAB)
	CPC  R27,R30
	BRLT _0x87
	CALL SUBOPT_0x28
	BRLT _0x88
_0x87:
	RJMP _0x86
_0x88:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	RJMP _0x141
; 0000 014B             else if(x>190 && x<=230)    {move(10);imin=12;}
_0x86:
	CALL SUBOPT_0x28
	BRLT _0x8B
	CALL SUBOPT_0x29
	BRLT _0x8C
_0x8B:
	RJMP _0x8A
_0x8C:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
_0x141:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _move
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
_0x140:
	STS  _imin,R30
	STS  _imin+1,R31
; 0000 014C             }
_0x8A:
_0x85:
; 0000 014D         else if(y>120 && y<=180)
	RJMP _0x8D
_0x77:
	CALL SUBOPT_0x6
	CPI  R26,LOW(0x79)
	LDI  R30,HIGH(0x79)
	CPC  R27,R30
	BRLT _0x8F
	CALL SUBOPT_0x6
	CPI  R26,LOW(0xB5)
	LDI  R30,HIGH(0xB5)
	CPC  R27,R30
	BRLT _0x90
_0x8F:
	RJMP _0x8E
_0x90:
; 0000 014E             {
; 0000 014F             if(x>30 && x<=70)           {move(8);imin=6;}
	CALL SUBOPT_0x5
	SBIW R26,31
	BRLT _0x92
	CALL SUBOPT_0x23
	BRLT _0x93
_0x92:
	RJMP _0x91
_0x93:
	CALL SUBOPT_0x2B
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RJMP _0x142
; 0000 0150             else if(x>70 && x<=110)     {move(8);imin=6;}
_0x91:
	CALL SUBOPT_0x23
	BRLT _0x96
	CALL SUBOPT_0x25
	BRLT _0x97
_0x96:
	RJMP _0x95
_0x97:
	CALL SUBOPT_0x2B
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RJMP _0x142
; 0000 0151             else if(x>110 && x<=150)    {move(4);imin=8;}
_0x95:
	CALL SUBOPT_0x25
	BRLT _0x9A
	CALL SUBOPT_0x26
	BRLT _0x9B
_0x9A:
	RJMP _0x99
_0x9B:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x2A
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RJMP _0x142
; 0000 0152             else if(x>150 && x<=190)    {move(8);imin=10;}
_0x99:
	CALL SUBOPT_0x26
	BRLT _0x9E
	CALL SUBOPT_0x28
	BRLT _0x9F
_0x9E:
	RJMP _0x9D
_0x9F:
	RJMP _0x143
; 0000 0153             else if(x>190 && x<=230)    {move(8);imin=10;}
_0x9D:
	CALL SUBOPT_0x28
	BRLT _0xA2
	CALL SUBOPT_0x29
	BRLT _0xA3
_0xA2:
	RJMP _0xA1
_0xA3:
_0x143:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL SUBOPT_0x2A
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
_0x142:
	STS  _imin,R30
	STS  _imin+1,R31
; 0000 0154             }
_0xA1:
; 0000 0155         else if(y>180)
	RJMP _0xA4
_0x8E:
	CALL SUBOPT_0x6
	CPI  R26,LOW(0xB5)
	LDI  R30,HIGH(0xB5)
	CPC  R27,R30
	BRGE PC+3
	JMP _0xA5
; 0000 0156             {
; 0000 0157             if(x>30 && x<=70)           {move(8);imin=6;}
	CALL SUBOPT_0x5
	SBIW R26,31
	BRLT _0xA7
	CALL SUBOPT_0x23
	BRLT _0xA8
_0xA7:
	RJMP _0xA6
_0xA8:
	CALL SUBOPT_0x2B
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RJMP _0x144
; 0000 0158             else if(x>70 && x<=110)     {move(8);imin=6;}
_0xA6:
	CALL SUBOPT_0x23
	BRLT _0xAB
	CALL SUBOPT_0x25
	BRLT _0xAC
_0xAB:
	RJMP _0xAA
_0xAC:
	CALL SUBOPT_0x2B
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RJMP _0x144
; 0000 0159             else if(x>110 && x<=150)    {move(4);imin=8;}
_0xAA:
	CALL SUBOPT_0x25
	BRLT _0xAF
	CALL SUBOPT_0x26
	BRLT _0xB0
_0xAF:
	RJMP _0xAE
_0xB0:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x2A
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RJMP _0x144
; 0000 015A             else if(x>150 && x<=190)    {move(8);imin=10;}
_0xAE:
	CALL SUBOPT_0x26
	BRLT _0xB3
	CALL SUBOPT_0x28
	BRLT _0xB4
_0xB3:
	RJMP _0xB2
_0xB4:
	RJMP _0x145
; 0000 015B             else if(x>190 && x<=230)    {move(8);imin=10;}
_0xB2:
	CALL SUBOPT_0x28
	BRLT _0xB7
	CALL SUBOPT_0x29
	BRLT _0xB8
_0xB7:
	RJMP _0xB6
_0xB8:
_0x145:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL SUBOPT_0x2A
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
_0x144:
	STS  _imin,R30
	STS  _imin+1,R31
; 0000 015C             }
_0xB6:
; 0000 015D 
; 0000 015E //        lcd_gotoxy(0,1);
; 0000 015F //        lcd_putchar((imin/10)%10+'0');
; 0000 0160 //        lcd_putchar((imin/1)%10+'0');
; 0000 0161 
; 0000 0162 
; 0000 0163 
; 0000 0164 //        if (SB < 160)               motor(k,-k,-k,k);
; 0000 0165 //        if(x<=30)                   motor(-v,v,v,-v);
; 0000 0166 //        else if(x>30 && x<=100)     motor(0,v,0,-v);
; 0000 0167 //        else if(x>100 && x<=200)    motor(v,v,-v,-v);
; 0000 0168 //        else if(x>200 && x<=270)    motor(v,0,-v,0);
; 0000 0169 //        else if(x>270)              motor(v,-v,-v,v);
; 0000 016A //
; 0000 016B         }
_0xA5:
_0xA4:
_0x8D:
_0x76:
; 0000 016C     else  //motor(0,0,0,0);
	RJMP _0xB9
_0x61:
; 0000 016D     {
; 0000 016E         k*=2;
	CALL SUBOPT_0x2C
	LSL  R30
	ROL  R31
	STS  _k,R30
	STS  _k+1,R31
; 0000 016F         if(SB < 200) motor(-v+k,-v-k,v-k,v+k);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CP   R6,R30
	CPC  R7,R31
	BRGE _0xBA
	CALL SUBOPT_0x1F
	MOVW R0,R30
	CALL SUBOPT_0xE
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R0
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2E
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x2F
	RJMP _0x146
; 0000 0170         else if (SB > 400) motor (v+k,v-k,-v-k,-v+k);
_0xBA:
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	CP   R30,R6
	CPC  R31,R7
	BRGE _0xBC
	CALL SUBOPT_0x2F
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x1E
	CALL __ANEGW1
	MOVW R26,R30
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x1F
	CALL SUBOPT_0xE
	ADD  R30,R26
	ADC  R31,R27
	RJMP _0x146
; 0000 0171         else motor(0,0,0,0);
_0xBC:
	CALL SUBOPT_0x22
	CALL SUBOPT_0x22
	CALL SUBOPT_0x22
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x146:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _motor
; 0000 0172     }
_0xB9:
; 0000 0173     }
	RET
;void out_kaf()
; 0000 0175     {
; 0000 0176     while(out=='R' && a!=0 && x<170)
; 0000 0177         {
; 0000 0178         sensor();
; 0000 0179         read_pixy();
; 0000 017A         if(SKR>400 || SKL>600 || SKF>600 || SKB>600)   motor(-v,v,v,-v);
; 0000 017B         else  motor(0,0,0,0);
; 0000 017C         PORTD.6=1;
; 0000 017D         }
; 0000 017E     while(out=='L' && a!=0 && x>140)
; 0000 017F         {
; 0000 0180         sensor();
; 0000 0181         read_pixy();
; 0000 0182         if(SKR>500 || SKL>600 || SKF>600 || SKB>600)   motor(v,-v,-v,v);
; 0000 0183         else  motor(0,0,0,0);
; 0000 0184         PORTD.6=1;
; 0000 0185         }
; 0000 0186     while(out=='B' && a!=0 && y>100)
; 0000 0187         {
; 0000 0188         sensor();
; 0000 0189         read_pixy();
; 0000 018A         if(SKR>500 || SKL>600 || SKF>600 || SKB>600)   motor(v,v,-v,-v);
; 0000 018B         else  motor(0,0,0,0);
; 0000 018C         PORTD.6=1;
; 0000 018D         }
; 0000 018E     while(out=='F' && a!=0 && y<100)
; 0000 018F         {
; 0000 0190         sensor();
; 0000 0191         read_pixy();
; 0000 0192         if(SKR>500 || SKL>600 || SKF>600 || SKB>600)   motor(-v,-v,v,v);
; 0000 0193         else  motor(0,0,0,0);
; 0000 0194         PORTD.6=1;
; 0000 0195         }
; 0000 0196     out=0;
; 0000 0197     }
;int f=0;
;void out_sharp()
; 0000 019A     {
_out_sharp:
; 0000 019B     if(SKF>600 && f==0)
	CALL SUBOPT_0x30
	BRGE _0xEB
	LDS  R26,_f
	LDS  R27,_f+1
	SBIW R26,0
	BREQ _0xEC
_0xEB:
	RJMP _0xEA
_0xEC:
; 0000 019C         {
; 0000 019D         motor(-v,-v,v,v);
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
	CALL SUBOPT_0x13
	RCALL _motor
; 0000 019E         delay_ms(300);
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 019F         f=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _f,R30
	STS  _f+1,R31
; 0000 01A0         }
; 0000 01A1     while(SR>300 && a!=0 && x<170)
_0xEA:
_0xED:
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	CP   R30,R4
	CPC  R31,R5
	BRGE _0xF0
	LDS  R26,_a
	CPI  R26,LOW(0x0)
	BREQ _0xF0
	CALL SUBOPT_0x5
	CPI  R26,LOW(0xAA)
	LDI  R30,HIGH(0xAA)
	CPC  R27,R30
	BRLT _0xF1
_0xF0:
	RJMP _0xEF
_0xF1:
; 0000 01A2         {
; 0000 01A3         sensor();
	CALL SUBOPT_0x31
; 0000 01A4         read_pixy();
; 0000 01A5         if(SR>450)   motor(-v,v,v,-v);
	CP   R30,R4
	CPC  R31,R5
	BRGE _0xF2
	CALL SUBOPT_0x20
	CALL SUBOPT_0x13
	CALL SUBOPT_0x13
	CALL SUBOPT_0x1F
	RJMP _0x14B
; 0000 01A6         else  motor(0,0,0,0);
_0xF2:
	CALL SUBOPT_0x22
	CALL SUBOPT_0x22
	CALL SUBOPT_0x22
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x14B:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _motor
; 0000 01A7         PORTD.6=1;
	SBI  0x12,6
; 0000 01A8         }
	RJMP _0xED
_0xEF:
; 0000 01A9     while(SL>300 && a!=0 && x>140)
_0xF6:
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	CP   R30,R8
	CPC  R31,R9
	BRGE _0xF9
	LDS  R26,_a
	CPI  R26,LOW(0x0)
	BREQ _0xF9
	CALL SUBOPT_0x5
	CPI  R26,LOW(0x8D)
	LDI  R30,HIGH(0x8D)
	CPC  R27,R30
	BRGE _0xFA
_0xF9:
	RJMP _0xF8
_0xFA:
; 0000 01AA         {
; 0000 01AB         sensor();
	CALL SUBOPT_0x31
; 0000 01AC         read_pixy();
; 0000 01AD         if(SL>450)   motor(v,-v,-v,v);
	CP   R30,R8
	CPC  R31,R9
	BRGE _0xFB
	CALL SUBOPT_0x13
	CALL SUBOPT_0x20
	CALL SUBOPT_0x20
	CALL SUBOPT_0x14
	RJMP _0x14C
; 0000 01AE         else  motor(0,0,0,0);
_0xFB:
	CALL SUBOPT_0x22
	CALL SUBOPT_0x22
	CALL SUBOPT_0x22
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x14C:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _motor
; 0000 01AF         PORTD.6=1;
	SBI  0x12,6
; 0000 01B0         }
	RJMP _0xF6
_0xF8:
; 0000 01B1     while(SB>300 && a!=0 && y>100)
_0xFF:
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	CP   R30,R6
	CPC  R31,R7
	BRGE _0x102
	LDS  R26,_a
	CPI  R26,LOW(0x0)
	BREQ _0x102
	CALL SUBOPT_0x6
	CPI  R26,LOW(0x65)
	LDI  R30,HIGH(0x65)
	CPC  R27,R30
	BRGE _0x103
_0x102:
	RJMP _0x101
_0x103:
; 0000 01B2         {
; 0000 01B3         sensor();
	CALL SUBOPT_0x31
; 0000 01B4         read_pixy();
; 0000 01B5         if(SB>450)   motor(v,v,-v,-v);
	CP   R30,R6
	CPC  R31,R7
	BRGE _0x104
	CALL SUBOPT_0x13
	CALL SUBOPT_0x13
	CALL SUBOPT_0x20
	CALL SUBOPT_0x1F
	RJMP _0x14D
; 0000 01B6         else  motor(0,0,0,0);
_0x104:
	CALL SUBOPT_0x22
	CALL SUBOPT_0x22
	CALL SUBOPT_0x22
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x14D:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _motor
; 0000 01B7         PORTD.6=1;
	SBI  0x12,6
; 0000 01B8         }
	RJMP _0xFF
_0x101:
; 0000 01B9     while(f==1 && a!=0 && y<100)
_0x108:
	LDS  R26,_f
	LDS  R27,_f+1
	SBIW R26,1
	BRNE _0x10B
	LDS  R26,_a
	CPI  R26,LOW(0x0)
	BREQ _0x10B
	CALL SUBOPT_0x6
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRLT _0x10C
_0x10B:
	RJMP _0x10A
_0x10C:
; 0000 01BA         {
; 0000 01BB         sensor();
	CALL _sensor
; 0000 01BC         read_pixy();
	CALL _read_pixy
; 0000 01BD         if(SKF>600 || SKB>600)   motor(-v,-v,v,v);
	CALL SUBOPT_0x30
	BRLT _0x10E
	CALL SUBOPT_0x32
	BRLT _0x10D
_0x10E:
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
	CALL SUBOPT_0x14
	RJMP _0x14E
; 0000 01BE         else  motor(0,0,0,0);
_0x10D:
	CALL SUBOPT_0x22
	CALL SUBOPT_0x22
	CALL SUBOPT_0x22
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x14E:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _motor
; 0000 01BF         PORTD.6=1;
	SBI  0x12,6
; 0000 01C0         }
	RJMP _0x108
_0x10A:
; 0000 01C1     f=0;
	LDI  R30,LOW(0)
	STS  _f,R30
	STS  _f+1,R30
; 0000 01C2     }
	RET
;void main(void)
; 0000 01C4 {
_main:
; 0000 01C5 #asm("wdr");
	wdr
; 0000 01C6 {
; 0000 01C7 // Declare your local variables here
; 0000 01C8 
; 0000 01C9 // Input/Output Ports initialization
; 0000 01CA // Port A initialization
; 0000 01CB // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 01CC DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 01CD // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 01CE PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 01CF 
; 0000 01D0 // Port B initialization
; 0000 01D1 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=In Bit1=In Bit0=In
; 0000 01D2 DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(248)
	OUT  0x17,R30
; 0000 01D3 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=T Bit1=T Bit0=T
; 0000 01D4 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 01D5 
; 0000 01D6 // Port C initialization
; 0000 01D7 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 01D8 DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 01D9 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 01DA PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 01DB 
; 0000 01DC // Port D initialization
; 0000 01DD // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 01DE DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 01DF // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 01E0 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 01E1 
; 0000 01E2 // Timer/Counter 0 initialization
; 0000 01E3 // Clock source: System Clock
; 0000 01E4 // Clock value: 31.250 kHz
; 0000 01E5 // Mode: Fast PWM top=0xFF
; 0000 01E6 // OC0 output: Non-Inverted PWM
; 0000 01E7 // Timer Period: 8.192 ms
; 0000 01E8 // Output Pulse(s):
; 0000 01E9 // OC0 Period: 8.192 ms Width: 0 us
; 0000 01EA TCCR0=(1<<WGM00) | (1<<COM01) | (0<<COM00) | (1<<WGM01) | (1<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(108)
	OUT  0x33,R30
; 0000 01EB TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 01EC OCR0=0x00;
	OUT  0x3C,R30
; 0000 01ED 
; 0000 01EE // Timer/Counter 1 initialization
; 0000 01EF // Clock source: System Clock
; 0000 01F0 // Clock value: 31.250 kHz
; 0000 01F1 // Mode: Fast PWM top=0x00FF
; 0000 01F2 // OC1A output: Non-Inverted PWM
; 0000 01F3 // OC1B output: Non-Inverted PWM
; 0000 01F4 // Noise Canceler: Off
; 0000 01F5 // Input Capture on Falling Edge
; 0000 01F6 // Timer Period: 8.192 ms
; 0000 01F7 // Output Pulse(s):
; 0000 01F8 // OC1A Period: 8.192 ms Width: 0 us// OC1B Period: 8.192 ms Width: 0 us
; 0000 01F9 // Timer1 Overflow Interrupt: Off
; 0000 01FA // Input Capture Interrupt: Off
; 0000 01FB // Compare A Match Interrupt: Off
; 0000 01FC // Compare B Match Interrupt: Off
; 0000 01FD TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (1<<WGM10);
	LDI  R30,LOW(161)
	OUT  0x2F,R30
; 0000 01FE TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (1<<CS12) | (0<<CS11) | (0<<CS10);
	LDI  R30,LOW(12)
	OUT  0x2E,R30
; 0000 01FF TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0200 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0201 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0202 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0203 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0204 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0205 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0206 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0207 
; 0000 0208 // Timer/Counter 2 initialization
; 0000 0209 // Clock source: System Clock
; 0000 020A // Clock value: 31.250 kHz
; 0000 020B // Mode: Fast PWM top=0xFF
; 0000 020C // OC2 output: Non-Inverted PWM
; 0000 020D // Timer Period: 8.192 ms
; 0000 020E // Output Pulse(s):
; 0000 020F // OC2 Period: 8.192 ms Width: 0 us
; 0000 0210 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0211 TCCR2=(1<<PWM2) | (1<<COM21) | (0<<COM20) | (1<<CTC2) | (1<<CS22) | (1<<CS21) | (0<<CS20);
	LDI  R30,LOW(110)
	OUT  0x25,R30
; 0000 0212 TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 0213 OCR2=0x00;
	OUT  0x23,R30
; 0000 0214 
; 0000 0215 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0216 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 0217 
; 0000 0218 // External Interrupt(s) initialization
; 0000 0219 // INT0: Off
; 0000 021A // INT1: Off
; 0000 021B // INT2: Off
; 0000 021C MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 021D MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 021E 
; 0000 021F // USART initialization
; 0000 0220 // USART disabled
; 0000 0221 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 0222 
; 0000 0223 // Analog Comparator initialization
; 0000 0224 // Analog Comparator: Off
; 0000 0225 // The Analog Comparator's positive input is
; 0000 0226 // connected to the AIN0 pin
; 0000 0227 // The Analog Comparator's negative input is
; 0000 0228 // connected to the AIN1 pin
; 0000 0229 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 022A 
; 0000 022B // ADC initialization
; 0000 022C // ADC Clock frequency: 62.500 kHz
; 0000 022D // ADC Voltage Reference: AVCC pin
; 0000 022E // ADC Auto Trigger Source: ADC Stopped
; 0000 022F ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 0230 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 0231 SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0232 
; 0000 0233 // SPI initialization
; 0000 0234 // SPI disabled
; 0000 0235 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 0236 
; 0000 0237 // TWI initialization
; 0000 0238 // TWI disabled
; 0000 0239 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 023A 
; 0000 023B // Bit-Banged I2C Bus initialization
; 0000 023C // I2C Port: PORTB
; 0000 023D // I2C SDA bit: 1
; 0000 023E // I2C SCL bit: 0
; 0000 023F // Bit Rate: 100 kHz
; 0000 0240 // Note: I2C settings are specified in the
; 0000 0241 // Project|Configure|C Compiler|Libraries|I2C menu.
; 0000 0242 i2c_init();
	CALL _i2c_init
; 0000 0243 
; 0000 0244 // Alphanumeric LCD initialization
; 0000 0245 // Connections are specified in the
; 0000 0246 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0247 // RS - PORTC Bit 0
; 0000 0248 // RD - PORTC Bit 1
; 0000 0249 // EN - PORTC Bit 2
; 0000 024A // D4 - PORTC Bit 4
; 0000 024B // D5 - PORTC Bit 5
; 0000 024C // D6 - PORTC Bit 6
; 0000 024D // D7 - PORTC Bit 7
; 0000 024E // Characters/line: 16
; 0000 024F lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 0250 
; 0000 0251 // Watchdog Timer initialization
; 0000 0252 // Watchdog Timer Prescaler: OSC/256k
; 0000 0253 WDTCR=(0<<WDTOE) | (1<<WDE) | (1<<WDP2) | (0<<WDP1) | (0<<WDP0);
	LDI  R30,LOW(12)
	OUT  0x21,R30
; 0000 0254 
; 0000 0255 }
; 0000 0256 v=255;
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STS  _v,R30
	STS  _v+1,R31
; 0000 0257 while (1)
_0x113:
; 0000 0258       {
; 0000 0259       #asm("wdr");
	wdr
; 0000 025A       sensor();
	CALL _sensor
; 0000 025B       read_pixy();
	CALL _read_pixy
; 0000 025C       //x-=30;
; 0000 025D       if (SKR>400 || SKL>600 || SKF>600 || SKB>600)
	CALL SUBOPT_0xD
	CPI  R26,LOW(0x191)
	LDI  R30,HIGH(0x191)
	CPC  R27,R30
	BRGE _0x117
	LDI  R30,LOW(600)
	LDI  R31,HIGH(600)
	CP   R30,R12
	CPC  R31,R13
	BRLT _0x117
	CALL SUBOPT_0x30
	BRLT _0x117
	CALL SUBOPT_0x32
	BRGE _0x117
	RJMP _0x116
_0x117:
; 0000 025E         {
; 0000 025F         if(SKR>400)
	CALL SUBOPT_0xD
	CPI  R26,LOW(0x191)
	LDI  R30,HIGH(0x191)
	CPC  R27,R30
	BRLT _0x119
; 0000 0260             {
; 0000 0261             if(SL>400) {motor(v,-v,-v,v);out='L';}
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	CP   R30,R8
	CPC  R31,R9
	BRGE _0x11A
	CALL SUBOPT_0x13
	CALL SUBOPT_0x20
	CALL SUBOPT_0x20
	CALL SUBOPT_0x13
	CALL _motor
	LDI  R30,LOW(76)
	RJMP _0x14F
; 0000 0262             else       {motor(-v,v,v,-v);out='R';}
_0x11A:
	CALL SUBOPT_0x20
	CALL SUBOPT_0x13
	CALL SUBOPT_0x13
	CALL SUBOPT_0x20
	CALL _motor
	LDI  R30,LOW(82)
_0x14F:
	STS  _out,R30
; 0000 0263             delay_ms(200);
	RJMP _0x150
; 0000 0264             }
; 0000 0265         else if(SKL>600)
_0x119:
	LDI  R30,LOW(600)
	LDI  R31,HIGH(600)
	CP   R30,R12
	CPC  R31,R13
	BRGE _0x11D
; 0000 0266             {
; 0000 0267             if(SR>400) {motor(-v,v,v,-v);out='R';}
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	CP   R30,R4
	CPC  R31,R5
	BRGE _0x11E
	CALL SUBOPT_0x20
	CALL SUBOPT_0x13
	CALL SUBOPT_0x13
	CALL SUBOPT_0x20
	CALL _motor
	LDI  R30,LOW(82)
	RJMP _0x151
; 0000 0268             else       {motor(v,-v,-v,v);out='L';}
_0x11E:
	CALL SUBOPT_0x13
	CALL SUBOPT_0x20
	CALL SUBOPT_0x20
	CALL SUBOPT_0x13
	CALL _motor
	LDI  R30,LOW(76)
_0x151:
	STS  _out,R30
; 0000 0269             delay_ms(200);
	RJMP _0x150
; 0000 026A             }
; 0000 026B         else if(SKF>600)
_0x11D:
	CALL SUBOPT_0x30
	BRGE _0x121
; 0000 026C             {
; 0000 026D             if(SKB>600);
	CALL SUBOPT_0x32
	BRGE _0x123
; 0000 026E             else if(SB>400) {motor(v,v,-v,-v);out='B';}
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	CP   R30,R6
	CPC  R31,R7
	BRGE _0x124
	CALL SUBOPT_0x13
	CALL SUBOPT_0x13
	CALL SUBOPT_0x20
	CALL SUBOPT_0x20
	CALL _motor
	LDI  R30,LOW(66)
	RJMP _0x152
; 0000 026F             else {motor(-v,-v,v,v);out='F';}
_0x124:
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
	CALL SUBOPT_0x13
	CALL _motor
	LDI  R30,LOW(70)
_0x152:
	STS  _out,R30
_0x123:
; 0000 0270             delay_ms(200);
	RJMP _0x150
; 0000 0271             }
; 0000 0272         else if(SKB>600)
_0x121:
	CALL SUBOPT_0x32
	BRLT _0x127
; 0000 0273             {
; 0000 0274             if(SKF>600);
	CALL SUBOPT_0x30
	BRLT _0x129
; 0000 0275             else if(SB>250) {motor(v,v,-v,-v);out='B';}
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CP   R30,R6
	CPC  R31,R7
	BRGE _0x12A
	CALL SUBOPT_0x13
	CALL SUBOPT_0x13
	CALL SUBOPT_0x20
	CALL SUBOPT_0x20
	CALL _motor
	LDI  R30,LOW(66)
	RJMP _0x153
; 0000 0276             else {motor(-v,-v,v,v);out='F';}
_0x12A:
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
	CALL SUBOPT_0x13
	CALL _motor
	LDI  R30,LOW(70)
_0x153:
	STS  _out,R30
_0x129:
; 0000 0277             delay_ms(200);
_0x150:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0278             }
; 0000 0279         PORTD.6=1;
_0x127:
	SBI  0x12,6
; 0000 027A         }
; 0000 027B       else
	RJMP _0x12E
_0x116:
; 0000 027C         {
; 0000 027D         //out_kaf();
; 0000 027E         out_sharp();
	RCALL _out_sharp
; 0000 027F         catch();
	RCALL _catch
; 0000 0280         PORTD.6=0;
	CBI  0x12,6
; 0000 0281         }
_0x12E:
; 0000 0282       }
	RJMP _0x113
; 0000 0283 }
_0x131:
	RJMP _0x131
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
_lcd_putsf:
	ST   -Y,R17
_0x2000008:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	LDD  R17,Y+0
	ADIW R28,3
	RET
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
	RCALL SUBOPT_0x33
	RCALL SUBOPT_0x33
	RCALL SUBOPT_0x33
	RCALL __long_delay_G100
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R30,LOW(40)
	RCALL SUBOPT_0x34
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x34
	LDI  R30,LOW(133)
	RCALL SUBOPT_0x34
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
_SKR:
	.BYTE 0x2
_SKB:
	.BYTE 0x2
_cmp:
	.BYTE 0x2

	.ESEG
_c:
	.BYTE 0x2

	.DSEG
_v:
	.BYTE 0x2
_k:
	.BYTE 0x2
_addres:
	.BYTE 0x1
_x:
	.BYTE 0x2
_y:
	.BYTE 0x2
_w:
	.BYTE 0x2
_h:
	.BYTE 0x2
_ch:
	.BYTE 0x2
_sn:
	.BYTE 0x2
_a:
	.BYTE 0x1
_out:
	.BYTE 0x1
_vs:
	.BYTE 0x2
_imin:
	.BYTE 0x2
_f:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	CALL _read
	STS  _a,R30
	LDS  R26,_a
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x3:
	CALL _read
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x4:
	CALL _read
	LDI  R26,LOW(255)
	MUL  R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 46 TIMES, CODE SIZE REDUCTION:87 WORDS
SUBOPT_0x5:
	LDS  R26,_x
	LDS  R27,_x+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x6:
	LDS  R26,_y
	LDS  R27,_y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:74 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:74 WORDS
SUBOPT_0x9:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xB:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xC:
	LDS  R26,_SKB
	LDS  R27,_SKB+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	LDS  R26,_SKR
	LDS  R27,_SKR+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xE:
	LDS  R26,_k
	LDS  R27,_k+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF:
	STS  _cmp,R30
	STS  _cmp+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x10:
	LDS  R26,_cmp
	LDS  R27,_cmp+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x11:
	LDS  R30,_cmp
	LDS  R31,_cmp+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	RCALL SUBOPT_0x11
	CALL __ANEGW1
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 30 TIMES, CODE SIZE REDUCTION:113 WORDS
SUBOPT_0x13:
	LDS  R30,_v
	LDS  R31,_v+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 44 TIMES, CODE SIZE REDUCTION:83 WORDS
SUBOPT_0x14:
	LDS  R30,_v
	LDS  R31,_v+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 33 TIMES, CODE SIZE REDUCTION:61 WORDS
SUBOPT_0x15:
	CALL __ANEGW1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x16:
	LDS  R30,_vs
	LDS  R31,_vs+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R26,_vs
	LDS  R27,_vs+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x19:
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x16
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1A:
	RCALL SUBOPT_0x16
	CALL __ANEGW1
	MOVW R26,R30
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1B:
	RCALL SUBOPT_0x16
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	LDS  R26,_vs
	LDS  R27,_vs+1
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1D:
	LDS  R26,_v
	LDS  R27,_v+1
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1E:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1F:
	RCALL SUBOPT_0x14
	CALL __ANEGW1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 24 TIMES, CODE SIZE REDUCTION:43 WORDS
SUBOPT_0x20:
	RCALL SUBOPT_0x14
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x21:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x13

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x23:
	RCALL SUBOPT_0x5
	CPI  R26,LOW(0x47)
	LDI  R30,HIGH(0x47)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x24:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	CALL _move
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x25:
	RCALL SUBOPT_0x5
	CPI  R26,LOW(0x6F)
	LDI  R30,HIGH(0x6F)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x26:
	RCALL SUBOPT_0x5
	CPI  R26,LOW(0x97)
	LDI  R30,HIGH(0x97)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x27:
	CALL _move
	LDI  R30,LOW(0)
	STS  _imin,R30
	STS  _imin+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x28:
	RCALL SUBOPT_0x5
	CPI  R26,LOW(0xBF)
	LDI  R30,HIGH(0xBF)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x29:
	RCALL SUBOPT_0x5
	CPI  R26,LOW(0xE7)
	LDI  R30,HIGH(0xE7)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x2A:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _move

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2B:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RJMP SUBOPT_0x2A

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2C:
	LDS  R30,_k
	LDS  R31,_k+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	RCALL SUBOPT_0x2C
	SUB  R26,R30
	SBC  R27,R31
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2E:
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x14
	SUB  R30,R26
	SBC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2F:
	RCALL SUBOPT_0x2C
	LDS  R26,_v
	LDS  R27,_v+1
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x30:
	LDI  R30,LOW(600)
	LDI  R31,HIGH(600)
	CP   R30,R10
	CPC  R31,R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x31:
	CALL _sensor
	CALL _read_pixy
	LDI  R30,LOW(450)
	LDI  R31,HIGH(450)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x32:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x259)
	LDI  R30,HIGH(0x259)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x33:
	CALL __long_delay_G100
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x34:
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

__ASRW8:
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
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

;END OF CODE MARKER
__END_OF_CODE:
