
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8/000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
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

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
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
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
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
	.DEF _i=R4
	.DEF _i_msb=R5
	.DEF _imin=R6
	.DEF _imin_msb=R7
	.DEF _min=R8
	.DEF _min_msb=R9
	.DEF _SL=R10
	.DEF _SL_msb=R11
	.DEF _SB=R12
	.DEF _SB_msb=R13

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
	.DB  0x1
_0x7:
	.DB  0x1
_0x8:
	.DB  0xFF
_0x0:
	.DB  0x3A,0x0,0x4C,0x0,0x42,0x0,0x52,0x0
	.DB  0x73,0x65,0x74,0x75,0x70,0x20,0x73,0x74
	.DB  0x61,0x72,0x74,0x2E,0x2E,0x2E,0x0,0x73
	.DB  0x65,0x74,0x20,0x63,0x6D,0x70,0x3A,0x20
	.DB  0x0,0x63,0x6D,0x70,0x20,0x73,0x65,0x74
	.DB  0x0,0x73,0x65,0x74,0x20,0x53,0x4B,0x46
	.DB  0x3A,0x20,0x0,0x53,0x4B,0x46,0x20,0x73
	.DB  0x65,0x74,0x0,0x73,0x65,0x74,0x20,0x53
	.DB  0x4B,0x52,0x3A,0x20,0x0,0x53,0x4B,0x52
	.DB  0x20,0x73,0x65,0x74,0x0,0x73,0x65,0x74
	.DB  0x20,0x53,0x4B,0x42,0x3A,0x20,0x0,0x53
	.DB  0x4B,0x42,0x20,0x73,0x65,0x74,0x0,0x73
	.DB  0x65,0x74,0x20,0x53,0x4B,0x4C,0x3A,0x20
	.DB  0x0,0x53,0x4B,0x4C,0x20,0x73,0x65,0x74
	.DB  0x0,0x73,0x65,0x74,0x20,0x7A,0x61,0x6D
	.DB  0x69,0x6E,0x46,0x3A,0x20,0x0,0x7A,0x61
	.DB  0x6D,0x69,0x6E,0x46,0x20,0x73,0x65,0x74
	.DB  0x0,0x73,0x65,0x74,0x20,0x7A,0x61,0x6D
	.DB  0x69,0x6E,0x52,0x3A,0x20,0x0,0x7A,0x61
	.DB  0x6D,0x69,0x6E,0x52,0x20,0x73,0x65,0x74
	.DB  0x0,0x73,0x65,0x74,0x20,0x7A,0x61,0x6D
	.DB  0x69,0x6E,0x42,0x3A,0x20,0x0,0x7A,0x61
	.DB  0x6D,0x69,0x6E,0x42,0x20,0x73,0x65,0x74
	.DB  0x0,0x73,0x65,0x74,0x20,0x7A,0x61,0x6D
	.DB  0x69,0x6E,0x4C,0x3A,0x20,0x0,0x7A,0x61
	.DB  0x6D,0x69,0x6E,0x4C,0x20,0x73,0x65,0x74
	.DB  0x0,0x73,0x65,0x74,0x20,0x62,0x61,0x63
	.DB  0x6B,0x31,0x3A,0x20,0x0,0x62,0x61,0x63
	.DB  0x6B,0x31,0x20,0x73,0x65,0x74,0x0,0x73
	.DB  0x65,0x74,0x20,0x62,0x61,0x63,0x6B,0x32
	.DB  0x3A,0x20,0x0,0x62,0x61,0x63,0x6B,0x32
	.DB  0x20,0x73,0x65,0x74,0x0,0x73,0x65,0x74
	.DB  0x20,0x62,0x61,0x63,0x6B,0x33,0x3A,0x20
	.DB  0x0,0x62,0x61,0x63,0x6B,0x33,0x20,0x73
	.DB  0x65,0x74,0x0,0x73,0x65,0x74,0x75,0x70
	.DB  0x20,0x64,0x6F,0x6E,0x65,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  _print_lcd
	.DW  _0x6*2

	.DW  0x01
	.DW  _old_print_lcd
	.DW  _0x7*2

	.DW  0x01
	.DW  _v
	.DW  _0x8*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

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
;#include <stdbool.h>
;#include <delay.h>
;#include <i2c.h>
;#asm
    .equ __lcd_port=0x15;PORTC
; 0000 0007 #endasm
;#include <lcd.h>
;#define centered k < 20 && k > -20
;#define middled SB < backmax2 && SB > backmax3
;#define lefted k > 20
;#define righted k < -20
;#define fronted SB < backmax3
;#define backed SB > backmax2
;#define center k,-k,-k,k
;#define back -v,-v,v,v
;#define forward v,v,-v,-v
;#define right v,-v,-v,v
;#define left -v,v,v,-v
;#define stop 0,0,0,0
;
;#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))
;unsigned int read_adc(unsigned char adc_input)
; 0000 0018 {

	.CSEG
_read_adc:
; .FSTART _read_adc
; 0000 0019 ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0000 001A // Delay needed for the stabilization of the ADC input voltage
; 0000 001B delay_us(10);
	__DELAY_USB 27
; 0000 001C // Start the AD conversion
; 0000 001D ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 001E // Wait for the AD conversion to complete
; 0000 001F while ((ADCSRA & (1<<ADIF))==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 0020 ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 0021 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	ADIW R28,1
	RET
; 0000 0022 }
; .FEND
;#define EEPROM_BUS_ADDRESS 0xc0
;unsigned char compass_read(unsigned char address)
; 0000 0025  {
_compass_read:
; .FSTART _compass_read
; 0000 0026     unsigned char data;
; 0000 0027     delay_us(100);
	ST   -Y,R26
	ST   -Y,R17
;	address -> Y+1
;	data -> R17
	CALL SUBOPT_0x0
; 0000 0028     i2c_start();
	CALL _i2c_start
; 0000 0029     delay_us(100);
	CALL SUBOPT_0x0
; 0000 002A     i2c_write(EEPROM_BUS_ADDRESS);
	LDI  R26,LOW(192)
	CALL SUBOPT_0x1
; 0000 002B     delay_us(100);
; 0000 002C     i2c_write(address);
	LDD  R26,Y+1
	CALL SUBOPT_0x1
; 0000 002D     delay_us(100);
; 0000 002E     i2c_start();
	CALL _i2c_start
; 0000 002F     delay_us(100);
	CALL SUBOPT_0x0
; 0000 0030     i2c_write(EEPROM_BUS_ADDRESS | 1);
	LDI  R26,LOW(193)
	CALL SUBOPT_0x1
; 0000 0031     delay_us(100);
; 0000 0032     data=i2c_read(0);
	LDI  R26,LOW(0)
	CALL _i2c_read
	MOV  R17,R30
; 0000 0033     delay_us(100);
	CALL SUBOPT_0x0
; 0000 0034     i2c_stop();
	CALL _i2c_stop
; 0000 0035     delay_us(100);
	CALL SUBOPT_0x0
; 0000 0036     return data;
	MOV  R30,R17
	LDD  R17,Y+0
	ADIW R28,2
	RET
; 0000 0037  }
; .FEND
;
;int i,imin,min;
;int SL,SB,SR,k;
;int SKF,SKL,SKB,SKR;
;int print_lcd = 1;  //0: none   -   1: ir-cmp-sharp   -   2: ir-cmp-kaf

	.DSEG
;int old_print_lcd = 1;
;int cmp;
;int v = 255;
;int position;
;int action;
;bool setcmp, setback1,setback2,setback3, setkaf1,setkaf2,setkaf3,setkaf4, setzamin1,setzamin2,setzamin3,setzamin4;
;char out=0;
;eeprom int c, kafmin1,kafmin2,kafmin3,kafmin4, kafmax1,kafmax2,kafmax3,kafmax4, kafmid1,kafmid2,kafmid3,kafmid4, backmax ...
;
;void sensor()
; 0000 0047 {

	.CSEG
_sensor:
; .FSTART _sensor
; 0000 0048     //read IR
; 0000 0049     {
; 0000 004A     min = 1023;
	LDI  R30,LOW(1023)
	LDI  R31,HIGH(1023)
	MOVW R8,R30
; 0000 004B     for (i = 0 ; i < 16 ; i++)
	CLR  R4
	CLR  R5
_0xA:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CP   R4,R30
	CPC  R5,R31
	BRGE _0xB
; 0000 004C     {
; 0000 004D         PORTB.7 = (i/8)%2;
	MOVW R26,R4
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL SUBOPT_0x2
	BRNE _0xC
	CBI  0x18,7
	RJMP _0xD
_0xC:
	SBI  0x18,7
_0xD:
; 0000 004E         PORTB.6 = (i/4)%2;
	MOVW R26,R4
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x2
	BRNE _0xE
	CBI  0x18,6
	RJMP _0xF
_0xE:
	SBI  0x18,6
_0xF:
; 0000 004F         PORTB.5 = (i/2)%2;
	MOVW R26,R4
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x2
	BRNE _0x10
	CBI  0x18,5
	RJMP _0x11
_0x10:
	SBI  0x18,5
_0x11:
; 0000 0050         PORTB.4 = (i/1)%2;
	MOVW R30,R4
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __MANDW12
	CPI  R30,0
	BRNE _0x12
	CBI  0x18,4
	RJMP _0x13
_0x12:
	SBI  0x18,4
_0x13:
; 0000 0051         if (read_adc(0) < min)
	LDI  R26,LOW(0)
	RCALL _read_adc
	CP   R30,R8
	CPC  R31,R9
	BRSH _0x14
; 0000 0052         {
; 0000 0053             min = read_adc(0);
	LDI  R26,LOW(0)
	RCALL _read_adc
	MOVW R8,R30
; 0000 0054             imin = i;
	MOVW R6,R4
; 0000 0055         }
; 0000 0056     }
_0x14:
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
	RJMP _0xA
_0xB:
; 0000 0057     }
; 0000 0058 
; 0000 0059     //print IR
; 0000 005A     if (print_lcd == 1 || print_lcd == 2)
	CALL SUBOPT_0x3
	SBIW R26,1
	BREQ _0x16
	CALL SUBOPT_0x3
	SBIW R26,2
	BRNE _0x15
_0x16:
; 0000 005B     {
; 0000 005C         lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 005D         lcd_putchar((imin/10)%10 + '0');
	MOVW R26,R6
	CALL SUBOPT_0x4
; 0000 005E         lcd_putchar((imin/1)%10 + '0');
	MOVW R26,R6
	CALL SUBOPT_0x5
; 0000 005F         lcd_putsf(":");
	__POINTW2FN _0x0,0
	CALL _lcd_putsf
; 0000 0060         lcd_putchar((min/100)%10 + '0');
	MOVW R26,R8
	CALL SUBOPT_0x6
; 0000 0061         lcd_putchar((min/10)%10 + '0');
	MOVW R26,R8
	CALL SUBOPT_0x4
; 0000 0062         lcd_putchar((min/1)%10 + '0');
	MOVW R26,R8
	CALL SUBOPT_0x5
; 0000 0063     }
; 0000 0064 
; 0000 0065     //read sharp
; 0000 0066     {
_0x15:
; 0000 0067         SB = read_adc(1);
	LDI  R26,LOW(1)
	RCALL _read_adc
	MOVW R12,R30
; 0000 0068         SR = read_adc(2);
	LDI  R26,LOW(2)
	RCALL _read_adc
	STS  _SR,R30
	STS  _SR+1,R31
; 0000 0069         SL = read_adc(3);
	LDI  R26,LOW(3)
	RCALL _read_adc
	MOVW R10,R30
; 0000 006A         k = SL-SR;
	CALL SUBOPT_0x7
	MOVW R30,R10
	SUB  R30,R26
	SBC  R31,R27
	STS  _k,R30
	STS  _k+1,R31
; 0000 006B     }
; 0000 006C 
; 0000 006D     //print sharp
; 0000 006E     if (print_lcd == 1)
	CALL SUBOPT_0x3
	SBIW R26,1
	BRNE _0x18
; 0000 006F     {
; 0000 0070         lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x8
; 0000 0071         lcd_putsf("L");
	__POINTW2FN _0x0,2
	CALL _lcd_putsf
; 0000 0072         lcd_putchar((SL/100)%10 + '0');
	MOVW R26,R10
	CALL SUBOPT_0x6
; 0000 0073         lcd_putchar((SL/10)%10 + '0');
	MOVW R26,R10
	CALL SUBOPT_0x4
; 0000 0074         lcd_putchar((SL/1)%10 + '0');
	MOVW R26,R10
	CALL SUBOPT_0x5
; 0000 0075         lcd_gotoxy(5,1);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x8
; 0000 0076         lcd_putsf("B");
	__POINTW2FN _0x0,4
	CALL _lcd_putsf
; 0000 0077         lcd_putchar((SB/100)%10 + '0');
	MOVW R26,R12
	CALL SUBOPT_0x6
; 0000 0078         lcd_putchar((SB/10)%10 + '0');
	MOVW R26,R12
	CALL SUBOPT_0x4
; 0000 0079         lcd_putchar((SB/1)%10 + '0');
	MOVW R26,R12
	CALL SUBOPT_0x5
; 0000 007A         lcd_gotoxy(10,1);
	LDI  R30,LOW(10)
	CALL SUBOPT_0x8
; 0000 007B         lcd_putsf("R");
	__POINTW2FN _0x0,6
	CALL _lcd_putsf
; 0000 007C         lcd_putchar((SR/100)%10 + '0');
	CALL SUBOPT_0x7
	CALL SUBOPT_0x6
; 0000 007D         lcd_putchar((SR/10)%10 + '0');
	CALL SUBOPT_0x7
	CALL SUBOPT_0x4
; 0000 007E         lcd_putchar((SR/1)%10 + '0');
	CALL SUBOPT_0x7
	CALL SUBOPT_0x5
; 0000 007F     }
; 0000 0080 
; 0000 0081     //read kaf
; 0000 0082     {
_0x18:
; 0000 0083         SKF = read_adc(4);
	LDI  R26,LOW(4)
	RCALL _read_adc
	STS  _SKF,R30
	STS  _SKF+1,R31
; 0000 0084         SKL = read_adc(5);
	LDI  R26,LOW(5)
	RCALL _read_adc
	STS  _SKL,R30
	STS  _SKL+1,R31
; 0000 0085         SKR = read_adc(6);
	LDI  R26,LOW(6)
	RCALL _read_adc
	STS  _SKR,R30
	STS  _SKR+1,R31
; 0000 0086         SKB = read_adc(7);
	LDI  R26,LOW(7)
	RCALL _read_adc
	STS  _SKB,R30
	STS  _SKB+1,R31
; 0000 0087     }
; 0000 0088 
; 0000 0089     //print kaf
; 0000 008A     if (print_lcd == 2)
	CALL SUBOPT_0x3
	SBIW R26,2
	BRNE _0x19
; 0000 008B     {
; 0000 008C         lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x8
; 0000 008D         lcd_putchar((SKL/100)%10 + '0');
	CALL SUBOPT_0x9
	CALL SUBOPT_0x6
; 0000 008E         lcd_putchar((SKL/10)%10 + '0');
	CALL SUBOPT_0x9
	CALL SUBOPT_0x4
; 0000 008F         lcd_putchar((SKL/1)%10 + '0');
	CALL SUBOPT_0x9
	CALL SUBOPT_0x5
; 0000 0090         lcd_gotoxy(4,1);
	LDI  R30,LOW(4)
	CALL SUBOPT_0x8
; 0000 0091         lcd_putchar((SKB/100)%10 + '0');
	CALL SUBOPT_0xA
	CALL SUBOPT_0x6
; 0000 0092         lcd_putchar((SKB/10)%10 + '0');
	CALL SUBOPT_0xA
	CALL SUBOPT_0x4
; 0000 0093         lcd_putchar((SKB/1)%10 + '0');
	CALL SUBOPT_0xA
	CALL SUBOPT_0x5
; 0000 0094         lcd_gotoxy(8,1);
	LDI  R30,LOW(8)
	CALL SUBOPT_0x8
; 0000 0095         lcd_putchar((SKR/100)%10 + '0');
	CALL SUBOPT_0xB
	CALL SUBOPT_0x6
; 0000 0096         lcd_putchar((SKR/10)%10 + '0');
	CALL SUBOPT_0xB
	CALL SUBOPT_0x4
; 0000 0097         lcd_putchar((SKR/1)%10 + '0');
	CALL SUBOPT_0xB
	CALL SUBOPT_0x5
; 0000 0098         lcd_gotoxy(12,1);
	LDI  R30,LOW(12)
	CALL SUBOPT_0x8
; 0000 0099         lcd_putchar((SKF/100)%10 + '0');
	CALL SUBOPT_0xC
	CALL SUBOPT_0x6
; 0000 009A         lcd_putchar((SKF/10)%10 + '0');
	CALL SUBOPT_0xC
	CALL SUBOPT_0x4
; 0000 009B         lcd_putchar((SKF/1)%10 + '0');
	CALL SUBOPT_0xC
	CALL SUBOPT_0x5
; 0000 009C     }
; 0000 009D 
; 0000 009E     //read cmp
; 0000 009F     {
_0x19:
; 0000 00A0         #asm("wdr");
	wdr
; 0000 00A1         cmp=compass_read(1)-c;
	LDI  R26,LOW(1)
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
; 0000 00A2 
; 0000 00A3         if(cmp>128)  cmp=cmp-255;
	CALL SUBOPT_0xD
	CPI  R26,LOW(0x81)
	LDI  R30,HIGH(0x81)
	CPC  R27,R30
	BRLT _0x1A
	CALL SUBOPT_0xE
	SUBI R30,LOW(255)
	SBCI R31,HIGH(255)
	CALL SUBOPT_0xF
; 0000 00A4         if(cmp<-128) cmp=cmp+255;
_0x1A:
	CALL SUBOPT_0xD
	CPI  R26,LOW(0xFF80)
	LDI  R30,HIGH(0xFF80)
	CPC  R27,R30
	BRGE _0x1B
	CALL SUBOPT_0xE
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	CALL SUBOPT_0xF
; 0000 00A5     }
_0x1B:
; 0000 00A6 
; 0000 00A7     //print cmp
; 0000 00A8     if (print_lcd == 1 || print_lcd == 2)
	CALL SUBOPT_0x3
	SBIW R26,1
	BREQ _0x1D
	CALL SUBOPT_0x3
	SBIW R26,2
	BRNE _0x1C
_0x1D:
; 0000 00A9     {
; 0000 00AA         lcd_gotoxy(11,0);
	LDI  R30,LOW(11)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 00AB         if(cmp>=0)
	LDS  R26,_cmp+1
	TST  R26
	BRMI _0x1F
; 0000 00AC         {
; 0000 00AD             lcd_putchar('+');
	LDI  R26,LOW(43)
	CALL _lcd_putchar
; 0000 00AE             lcd_putchar((cmp/100)%10+'0');
	CALL SUBOPT_0xD
	CALL SUBOPT_0x6
; 0000 00AF             lcd_putchar((cmp/10)%10+'0');
	CALL SUBOPT_0xD
	CALL SUBOPT_0x4
; 0000 00B0             lcd_putchar((cmp/1)%10+'0');
	CALL SUBOPT_0xD
	RJMP _0x1BB
; 0000 00B1         }
; 0000 00B2         else
_0x1F:
; 0000 00B3         {
; 0000 00B4             lcd_putchar('-');
	LDI  R26,LOW(45)
	CALL _lcd_putchar
; 0000 00B5             lcd_putchar((-cmp/100)%10+'0');
	CALL SUBOPT_0x10
	CALL SUBOPT_0x6
; 0000 00B6             lcd_putchar((-cmp/10)%10+'0');
	CALL SUBOPT_0x10
	CALL SUBOPT_0x4
; 0000 00B7             lcd_putchar((-cmp/1)%10+'0');
	CALL SUBOPT_0x10
_0x1BB:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	CALL _lcd_putchar
; 0000 00B8         }
; 0000 00B9     }
; 0000 00BA 
; 0000 00BB     //multiply
; 0000 00BC     {
_0x1C:
; 0000 00BD         if (cmp > -20 && cmp < 20)
	CALL SUBOPT_0xD
	CALL SUBOPT_0x11
	BRGE _0x22
	CALL SUBOPT_0xD
	SBIW R26,20
	BRLT _0x23
_0x22:
	RJMP _0x21
_0x23:
; 0000 00BE         {
; 0000 00BF             cmp*=-4;
	CALL SUBOPT_0xE
	LDI  R26,LOW(65532)
	LDI  R27,HIGH(65532)
	RJMP _0x1BC
; 0000 00C0         }
; 0000 00C1         else
_0x21:
; 0000 00C2         {
; 0000 00C3             cmp*=-2;
	CALL SUBOPT_0xE
	LDI  R26,LOW(65534)
	LDI  R27,HIGH(65534)
_0x1BC:
	CALL __MULW12
	CALL SUBOPT_0xF
; 0000 00C4         }
; 0000 00C5     }
; 0000 00C6 }
	RET
; .FEND
;
;void motor(int ml1,int ml2,int mr2,int mr1)
; 0000 00C9     {
_motor:
; .FSTART _motor
; 0000 00CA     #asm("wdr");
	ST   -Y,R27
	ST   -Y,R26
;	ml1 -> Y+6
;	ml2 -> Y+4
;	mr2 -> Y+2
;	mr1 -> Y+0
	wdr
; 0000 00CB     {
; 0000 00CC         ml1+=cmp;
	CALL SUBOPT_0xE
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 00CD         ml2+=cmp;
	CALL SUBOPT_0xE
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 00CE         mr2+=cmp;
	CALL SUBOPT_0xE
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00CF         mr1+=cmp;
	CALL SUBOPT_0xE
	LD   R26,Y
	LDD  R27,Y+1
	ADD  R30,R26
	ADC  R31,R27
	ST   Y,R30
	STD  Y+1,R31
; 0000 00D0     }
; 0000 00D1 
; 0000 00D2     if (SB < 170 && SL > 250)
	CALL SUBOPT_0x12
	BRGE _0x26
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CP   R30,R10
	CPC  R31,R11
	BRLT _0x27
_0x26:
	RJMP _0x25
_0x27:
; 0000 00D3     {
; 0000 00D4         ml1 += 30;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,30
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 00D5         ml2 += 30;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,30
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 00D6         mr2 += 30;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ADIW R30,30
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00D7         mr1 += 30;
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,30
	RJMP _0x1BD
; 0000 00D8     }
; 0000 00D9 
; 0000 00DA     else if (SB < 170 && SR > 250)
_0x25:
	CALL SUBOPT_0x12
	BRGE _0x2A
	CALL SUBOPT_0x7
	CPI  R26,LOW(0xFB)
	LDI  R30,HIGH(0xFB)
	CPC  R27,R30
	BRGE _0x2B
_0x2A:
	RJMP _0x29
_0x2B:
; 0000 00DB     {
; 0000 00DC         ml1 -= 30;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SBIW R30,30
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 00DD         ml2 -= 30;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,30
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 00DE         mr2 -= 30;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,30
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00DF         mr1 -= 30;
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,30
_0x1BD:
	ST   Y,R30
	STD  Y+1,R31
; 0000 00E0     }
; 0000 00E1 
; 0000 00E2     {
_0x29:
; 0000 00E3         if(ml1>255) ml1=255;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x2C
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 00E4         if(ml2>255) ml2=255;
_0x2C:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x2D
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 00E5         if(mr2>255) mr2=255;
_0x2D:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x2E
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00E6         if(mr1>255) mr1=255;
_0x2E:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x2F
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	ST   Y,R30
	STD  Y+1,R31
; 0000 00E7 
; 0000 00E8         if(ml1<-255) ml1=-255;
_0x2F:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x30
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 00E9         if(ml2<-255) ml2=-255;
_0x30:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x31
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 00EA         if(mr2<-255) mr2=-255;
_0x31:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x32
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00EB         if(mr1<-255) mr1=-255;
_0x32:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x33
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	ST   Y,R30
	STD  Y+1,R31
; 0000 00EC     }
_0x33:
; 0000 00ED     //////////////mr1
; 0000 00EE     {
; 0000 00EF     if(mr1>=0)
	LDD  R26,Y+1
	TST  R26
	BRMI _0x34
; 0000 00F0     {
; 0000 00F1         #asm("wdr");
	wdr
; 0000 00F2         PORTD.0=0;
	CBI  0x12,0
; 0000 00F3         OCR0=mr1;
	LD   R30,Y
	RJMP _0x1BE
; 0000 00F4     }
; 0000 00F5     else
_0x34:
; 0000 00F6     {
; 0000 00F7         #asm("wdr");
	wdr
; 0000 00F8         PORTD.0=1;
	SBI  0x12,0
; 0000 00F9         OCR0=mr1+255;
	LD   R30,Y
	SUBI R30,-LOW(255)
_0x1BE:
	OUT  0x3C,R30
; 0000 00FA     }
; 0000 00FB     }
; 0000 00FC     //////////////mr2
; 0000 00FD     {
; 0000 00FE     if(mr2>=0)
	LDD  R26,Y+3
	TST  R26
	BRMI _0x3A
; 0000 00FF     {
; 0000 0100         #asm("wdr");
	wdr
; 0000 0101         PORTD.1=0;
	CBI  0x12,1
; 0000 0102         OCR1B=mr2;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	RJMP _0x1BF
; 0000 0103     }
; 0000 0104     else
_0x3A:
; 0000 0105     {
; 0000 0106         #asm("wdr");
	wdr
; 0000 0107         PORTD.1=1;
	SBI  0x12,1
; 0000 0108         OCR1B=mr2+255;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
_0x1BF:
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 0109     }
; 0000 010A     }
; 0000 010B     //////////////mL2
; 0000 010C     {
; 0000 010D     if(ml2>=0)
	LDD  R26,Y+5
	TST  R26
	BRMI _0x40
; 0000 010E     {
; 0000 010F         #asm("wdr");
	wdr
; 0000 0110         PORTD.2=0;
	CBI  0x12,2
; 0000 0111         OCR1A=ml2;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RJMP _0x1C0
; 0000 0112     }
; 0000 0113     else
_0x40:
; 0000 0114     {
; 0000 0115         #asm("wdr");
	wdr
; 0000 0116         PORTD.2=1;
	SBI  0x12,2
; 0000 0117         OCR1A=ml2+255;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
_0x1C0:
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 0118     }
; 0000 0119         }
; 0000 011A     //////////////ml1
; 0000 011B     {
; 0000 011C     if(ml1>=0)
	LDD  R26,Y+7
	TST  R26
	BRMI _0x46
; 0000 011D     {
; 0000 011E         #asm("wdr");
	wdr
; 0000 011F         PORTD.3=0;
	CBI  0x12,3
; 0000 0120         OCR2=ml1;
	LDD  R30,Y+6
	RJMP _0x1C1
; 0000 0121     }
; 0000 0122     else
_0x46:
; 0000 0123     {
; 0000 0124         #asm("wdr");
	wdr
; 0000 0125         PORTD.3=1;
	SBI  0x12,3
; 0000 0126         OCR2=ml1+255;
	LDD  R30,Y+6
	SUBI R30,-LOW(255)
_0x1C1:
	OUT  0x23,R30
; 0000 0127     }
; 0000 0128     }
; 0000 0129 }
	ADIW R28,8
	RET
; .FEND
;
;void check()
; 0000 012C {
; 0000 012D     if(SKB>kafmid3 || SKR>kafmid2 || SKL>kafmid4)
; 0000 012E     {
; 0000 012F         if(SKR>kafmid2)
; 0000 0130         {
; 0000 0131             if(SL>400)
; 0000 0132             {
; 0000 0133                 motor(v,-v,-v,v);
; 0000 0134                 out='L';
; 0000 0135             }
; 0000 0136             else
; 0000 0137             {
; 0000 0138                 motor(-v,v,v,-v);
; 0000 0139                 out='R';
; 0000 013A             }
; 0000 013B         }
; 0000 013C         else if(SKL>kafmid4)
; 0000 013D         {
; 0000 013E             if(SR>400)
; 0000 013F             {
; 0000 0140                 motor(-v,v,v,-v);
; 0000 0141                 out='R';
; 0000 0142             }
; 0000 0143             else
; 0000 0144             {
; 0000 0145                 motor(v,-v,-v,v);
; 0000 0146                 out='L';
; 0000 0147             }
; 0000 0148         }
; 0000 0149         else if(SKB>kafmid3)
; 0000 014A         {
; 0000 014B             if(SB>200)
; 0000 014C             {
; 0000 014D                 motor(-v,v,v,-v);
; 0000 014E                 out='B';
; 0000 014F             }
; 0000 0150         }
; 0000 0151     }
; 0000 0152     else
; 0000 0153     {
; 0000 0154         while(out=='R' && min < 800 && imin >= 0 && imin <= 8)
; 0000 0155         {
; 0000 0156             sensor();
; 0000 0157             if(SR>250)   motor(-v,v,v,-v);
; 0000 0158             else  motor(0,0,0,0);
; 0000 0159         }
; 0000 015A         while(out=='L' && min < 800 && imin <= 15 && imin >= 8)
; 0000 015B         {
; 0000 015C             sensor();
; 0000 015D             if(SL>250)   motor(v,-v,-v,v);
; 0000 015E             else  motor(0,0,0,0);
; 0000 015F         }
; 0000 0160         while(out=='B' && min < 800 && imin >= 4 && imin <= 12)
; 0000 0161         {
; 0000 0162             sensor();
; 0000 0163             if(SB>250)   motor(v,v,-v,-v);
; 0000 0164             else  motor(0,0,0,0);
; 0000 0165         }
; 0000 0166         if(SKF>kafmid1 && out==0)
; 0000 0167         {
; 0000 0168             motor(-v,-v,v,v);
; 0000 0169             delay_ms(300);
; 0000 016A             out='F';
; 0000 016B         }
; 0000 016C         while(out=='F' && min < 800 && (imin >=  12|| imin <= 4))
; 0000 016D         {
; 0000 016E             sensor();
; 0000 016F             motor(0,0,0,0);
; 0000 0170         }
; 0000 0171     }
; 0000 0172 }
;
;void catch()
; 0000 0175 {
_catch:
; .FSTART _catch
; 0000 0176     //check min
; 0000 0177     if (min < 800)
	CALL SUBOPT_0x13
	BRLT PC+2
	RJMP _0x79
; 0000 0178     {
; 0000 0179         //center
; 0000 017A         if (SB < 170) motor(center);
	CALL SUBOPT_0x12
	BRGE _0x7A
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
	RCALL _motor
; 0000 017B 
; 0000 017C         //set position
; 0000 017D         {
_0x7A:
; 0000 017E             if ((lefted) && (fronted)) position = 1;
	CALL SUBOPT_0x17
	SBIW R26,21
	BRLT _0x7C
	CALL SUBOPT_0x18
	BRLT _0x7D
_0x7C:
	RJMP _0x7B
_0x7D:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x1C7
; 0000 017F             else if ((centered) && (fronted)) position = 2;
_0x7B:
	CALL SUBOPT_0x17
	SBIW R26,20
	BRGE _0x80
	CALL SUBOPT_0x19
	BRLT _0x81
_0x80:
	RJMP _0x82
_0x81:
	CALL SUBOPT_0x18
	BRLT _0x83
_0x82:
	RJMP _0x7F
_0x83:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x1C7
; 0000 0180             else if ((righted) && (fronted)) position = 3;
_0x7F:
	CALL SUBOPT_0x1A
	BRGE _0x86
	CALL SUBOPT_0x18
	BRLT _0x87
_0x86:
	RJMP _0x85
_0x87:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP _0x1C7
; 0000 0181             else if ((lefted) && (middled)) position = 4;
_0x85:
	CALL SUBOPT_0x17
	SBIW R26,21
	BRLT _0x8A
	CALL SUBOPT_0x1B
	BRGE _0x8B
	CALL SUBOPT_0x1C
	BRLT _0x8C
_0x8B:
	RJMP _0x8A
_0x8C:
	RJMP _0x8D
_0x8A:
	RJMP _0x89
_0x8D:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RJMP _0x1C7
; 0000 0182             else if ((centered) && (middled)) position = 5;
_0x89:
	CALL SUBOPT_0x17
	SBIW R26,20
	BRGE _0x90
	CALL SUBOPT_0x19
	BRLT _0x91
_0x90:
	RJMP _0x92
_0x91:
	CALL SUBOPT_0x1B
	BRGE _0x93
	CALL SUBOPT_0x1C
	BRLT _0x94
_0x93:
	RJMP _0x92
_0x94:
	RJMP _0x95
_0x92:
	RJMP _0x8F
_0x95:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RJMP _0x1C7
; 0000 0183             else if ((righted) &&  (middled)) position = 6;
_0x8F:
	CALL SUBOPT_0x1A
	BRGE _0x98
	CALL SUBOPT_0x1B
	BRGE _0x99
	CALL SUBOPT_0x1C
	BRLT _0x9A
_0x99:
	RJMP _0x98
_0x9A:
	RJMP _0x9B
_0x98:
	RJMP _0x97
_0x9B:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RJMP _0x1C7
; 0000 0184             else if ((lefted) && (backed)) position = 7;
_0x97:
	CALL SUBOPT_0x17
	SBIW R26,21
	BRLT _0x9E
	CALL SUBOPT_0x1D
	BRLT _0x9F
_0x9E:
	RJMP _0x9D
_0x9F:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	RJMP _0x1C7
; 0000 0185             else if ((centered) && (backed)) position = 8;
_0x9D:
	CALL SUBOPT_0x17
	SBIW R26,20
	BRGE _0xA2
	CALL SUBOPT_0x19
	BRLT _0xA3
_0xA2:
	RJMP _0xA4
_0xA3:
	CALL SUBOPT_0x1D
	BRLT _0xA5
_0xA4:
	RJMP _0xA1
_0xA5:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RJMP _0x1C7
; 0000 0186             else if ((righted) && (backed)) position = 9;
_0xA1:
	CALL SUBOPT_0x1A
	BRGE _0xA8
	CALL SUBOPT_0x1D
	BRLT _0xA9
_0xA8:
	RJMP _0xA7
_0xA9:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
_0x1C7:
	STS  _position,R30
	STS  _position+1,R31
; 0000 0187         }
_0xA7:
; 0000 0188 
; 0000 0189         //set shift
; 0000 018A         {
; 0000 018B             if (position == 1)
	CALL SUBOPT_0x1E
	SBIW R26,1
	BRNE _0xAA
; 0000 018C             {
; 0000 018D                 #asm("wdr")
	wdr
; 0000 018E                 if (imin == 0) action = imin+2;
	MOV  R0,R6
	OR   R0,R7
	BRNE _0xAB
	MOVW R30,R6
	ADIW R30,2
	RJMP _0x1C8
; 0000 018F                 else if (imin >= 13 || imin <= 3) action = imin;
_0xAB:
	CALL SUBOPT_0x1F
	BRGE _0xAE
	CALL SUBOPT_0x20
	BRLT _0xAD
_0xAE:
	CALL SUBOPT_0x21
; 0000 0190                 else if (imin >= 4 && imin <= 7) action = imin+2;
	RJMP _0xB0
_0xAD:
	CALL SUBOPT_0x22
	BRLT _0xB2
	CALL SUBOPT_0x23
	BRGE _0xB3
_0xB2:
	RJMP _0xB1
_0xB3:
	MOVW R30,R6
	ADIW R30,2
	RJMP _0x1C8
; 0000 0191                 else if (imin >= 8 && imin <= 12) action = imin-2;
_0xB1:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R6,R30
	CPC  R7,R31
	BRLT _0xB6
	CALL SUBOPT_0x24
	BRGE _0xB7
_0xB6:
	RJMP _0xB5
_0xB7:
	MOVW R30,R6
	SBIW R30,2
_0x1C8:
	STS  _action,R30
	STS  _action+1,R31
; 0000 0192             }
_0xB5:
_0xB0:
; 0000 0193             else if (position == 2)
	RJMP _0xB8
_0xAA:
	CALL SUBOPT_0x1E
	SBIW R26,2
	BRNE _0xB9
; 0000 0194             {
; 0000 0195                 #asm("wdr")
	wdr
; 0000 0196                 if (imin >= 13 || imin <= 3) action = imin;
	CALL SUBOPT_0x1F
	BRGE _0xBB
	CALL SUBOPT_0x20
	BRLT _0xBA
_0xBB:
	CALL SUBOPT_0x21
; 0000 0197                 else if (imin >= 4 && imin <= 8) action = imin+2;
	RJMP _0xBD
_0xBA:
	CALL SUBOPT_0x22
	BRLT _0xBF
	CALL SUBOPT_0x25
	BRGE _0xC0
_0xBF:
	RJMP _0xBE
_0xC0:
	MOVW R30,R6
	ADIW R30,2
	RJMP _0x1C9
; 0000 0198                 else if (imin >= 9 && imin <= 12) action = imin-2;
_0xBE:
	CALL SUBOPT_0x26
	BRLT _0xC3
	CALL SUBOPT_0x24
	BRGE _0xC4
_0xC3:
	RJMP _0xC2
_0xC4:
	MOVW R30,R6
	SBIW R30,2
_0x1C9:
	STS  _action,R30
	STS  _action+1,R31
; 0000 0199             }
_0xC2:
_0xBD:
; 0000 019A             else if (position == 3)
	RJMP _0xC5
_0xB9:
	CALL SUBOPT_0x1E
	SBIW R26,3
	BRNE _0xC6
; 0000 019B             {
; 0000 019C                 #asm("wdr")
	wdr
; 0000 019D                 if (imin >= 13 || imin <= 3) action = imin;
	CALL SUBOPT_0x1F
	BRGE _0xC8
	CALL SUBOPT_0x20
	BRLT _0xC7
_0xC8:
	CALL SUBOPT_0x21
; 0000 019E                 else if (imin >= 4 && imin <= 8) action = imin+2;
	RJMP _0xCA
_0xC7:
	CALL SUBOPT_0x22
	BRLT _0xCC
	CALL SUBOPT_0x25
	BRGE _0xCD
_0xCC:
	RJMP _0xCB
_0xCD:
	MOVW R30,R6
	ADIW R30,2
	RJMP _0x1CA
; 0000 019F                 else if (imin >= 9 && imin <= 12) action = imin-2;
_0xCB:
	CALL SUBOPT_0x26
	BRLT _0xD0
	CALL SUBOPT_0x24
	BRGE _0xD1
_0xD0:
	RJMP _0xCF
_0xD1:
	MOVW R30,R6
	SBIW R30,2
_0x1CA:
	STS  _action,R30
	STS  _action+1,R31
; 0000 01A0             }
_0xCF:
_0xCA:
; 0000 01A1             else if (position == 4)
	RJMP _0xD2
_0xC6:
	CALL SUBOPT_0x1E
	SBIW R26,4
	BRNE _0xD3
; 0000 01A2             {
; 0000 01A3                 #asm("wdr")
	wdr
; 0000 01A4                 if (imin == 0) action = imin+1;
	MOV  R0,R6
	OR   R0,R7
	BRNE _0xD4
	MOVW R30,R6
	ADIW R30,1
	RJMP _0x1CB
; 0000 01A5                 else if (imin <= 2) action = imin+2;
_0xD4:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R6
	CPC  R31,R7
	BRLT _0xD6
	MOVW R30,R6
	ADIW R30,2
	RJMP _0x1CB
; 0000 01A6                 else if (imin >= 3 && imin <= 6) action = imin+2;
_0xD6:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R6,R30
	CPC  R7,R31
	BRLT _0xD9
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R30,R6
	CPC  R31,R7
	BRGE _0xDA
_0xD9:
	RJMP _0xD8
_0xDA:
	MOVW R30,R6
	ADIW R30,2
	RJMP _0x1CB
; 0000 01A7                 else if (imin == 7) action = imin+1;
_0xD8:
	CALL SUBOPT_0x23
	BRNE _0xDC
	MOVW R30,R6
	ADIW R30,1
	RJMP _0x1CB
; 0000 01A8                 else if (imin >= 8) action = imin-1;
_0xDC:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R6,R30
	CPC  R7,R31
	BRLT _0xDE
	MOVW R30,R6
	SBIW R30,1
_0x1CB:
	STS  _action,R30
	STS  _action+1,R31
; 0000 01A9             }
_0xDE:
; 0000 01AA             else if (position == 5)
	RJMP _0xDF
_0xD3:
	CALL SUBOPT_0x1E
	SBIW R26,5
	BREQ PC+2
	RJMP _0xE0
; 0000 01AB             {
; 0000 01AC                 #asm("wdr")
	wdr
; 0000 01AD                 if (imin >= 15 || imin <= 1) action = imin;
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CP   R6,R30
	CPC  R7,R31
	BRGE _0xE2
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R6
	CPC  R31,R7
	BRLT _0xE1
_0xE2:
	CALL SUBOPT_0x21
; 0000 01AE                 else if (imin >= 2 && imin <= 6) action = imin+2;
	RJMP _0xE4
_0xE1:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R6,R30
	CPC  R7,R31
	BRLT _0xE6
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R30,R6
	CPC  R31,R7
	BRGE _0xE7
_0xE6:
	RJMP _0xE5
_0xE7:
	MOVW R30,R6
	ADIW R30,2
	RJMP _0x1CC
; 0000 01AF                 else if (imin >= 7 && imin <= 8) action = imin+1;
_0xE5:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CP   R6,R30
	CPC  R7,R31
	BRLT _0xEA
	CALL SUBOPT_0x25
	BRGE _0xEB
_0xEA:
	RJMP _0xE9
_0xEB:
	MOVW R30,R6
	ADIW R30,1
	RJMP _0x1CC
; 0000 01B0                 else if (imin == 9) action = imin-1;
_0xE9:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0xED
	MOVW R30,R6
	SBIW R30,1
	RJMP _0x1CC
; 0000 01B1                 else if (imin >= 10 && imin <= 14) action = imin-2;
_0xED:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R6,R30
	CPC  R7,R31
	BRLT _0xF0
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CP   R30,R6
	CPC  R31,R7
	BRGE _0xF1
_0xF0:
	RJMP _0xEF
_0xF1:
	MOVW R30,R6
	SBIW R30,2
_0x1CC:
	STS  _action,R30
	STS  _action+1,R31
; 0000 01B2             }
_0xEF:
_0xE4:
; 0000 01B3             else if (position == 6)
	RJMP _0xF2
_0xE0:
	CALL SUBOPT_0x1E
	SBIW R26,6
	BRNE _0xF3
; 0000 01B4             {
; 0000 01B5                 #asm("wdr")
	wdr
; 0000 01B6                 if (imin == 0) action = imin-1;
	MOV  R0,R6
	OR   R0,R7
	BRNE _0xF4
	MOVW R30,R6
	SBIW R30,1
	RJMP _0x1CD
; 0000 01B7                 else if (imin >= 14) action = imin-2;
_0xF4:
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CP   R6,R30
	CPC  R7,R31
	BRLT _0xF6
	MOVW R30,R6
	SBIW R30,2
	RJMP _0x1CD
; 0000 01B8                 else if (imin <= 13 && imin >= 10) action = imin-2;
_0xF6:
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	CP   R30,R6
	CPC  R31,R7
	BRLT _0xF9
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R6,R30
	CPC  R7,R31
	BRGE _0xFA
_0xF9:
	RJMP _0xF8
_0xFA:
	MOVW R30,R6
	SBIW R30,2
	RJMP _0x1CD
; 0000 01B9                 else if (imin == 9) action = imin-1;
_0xF8:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0xFC
	MOVW R30,R6
	SBIW R30,1
	RJMP _0x1CD
; 0000 01BA                 else if (imin <= 8) action = imin+1;
_0xFC:
	CALL SUBOPT_0x25
	BRLT _0xFE
	MOVW R30,R6
	ADIW R30,1
_0x1CD:
	STS  _action,R30
	STS  _action+1,R31
; 0000 01BB             }
_0xFE:
; 0000 01BC             else if (position == 7)
	RJMP _0xFF
_0xF3:
	CALL SUBOPT_0x1E
	SBIW R26,7
	BRNE _0x100
; 0000 01BD             {
; 0000 01BE                 #asm("wdr")
	wdr
; 0000 01BF                 if (imin <= 3) action = imin+1;
	CALL SUBOPT_0x20
	BRLT _0x101
	MOVW R30,R6
	ADIW R30,1
	RJMP _0x1CE
; 0000 01C0                 else if (imin == 4) action = imin+2;
_0x101:
	CALL SUBOPT_0x27
	BRNE _0x103
	MOVW R30,R6
	ADIW R30,2
	RJMP _0x1CE
; 0000 01C1                 else if (imin >= 5 && imin <= 7) action = imin-1;
_0x103:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R6,R30
	CPC  R7,R31
	BRLT _0x106
	CALL SUBOPT_0x23
	BRGE _0x107
_0x106:
	RJMP _0x105
_0x107:
	MOVW R30,R6
	SBIW R30,1
	RJMP _0x1CE
; 0000 01C2                 else if (imin == 8) action = imin;
_0x105:
	CALL SUBOPT_0x25
	BRNE _0x109
	CALL SUBOPT_0x21
; 0000 01C3                 else if (imin >= 9 && imin <= 11) action = imin+1;
	RJMP _0x10A
_0x109:
	CALL SUBOPT_0x26
	BRLT _0x10C
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CP   R30,R6
	CPC  R31,R7
	BRGE _0x10D
_0x10C:
	RJMP _0x10B
_0x10D:
	MOVW R30,R6
	ADIW R30,1
	RJMP _0x1CE
; 0000 01C4                 else if (imin >= 12) action = imin-2;
_0x10B:
	CALL SUBOPT_0x28
	BRLT _0x10F
	MOVW R30,R6
	SBIW R30,2
_0x1CE:
	STS  _action,R30
	STS  _action+1,R31
; 0000 01C5             }
_0x10F:
_0x10A:
; 0000 01C6             else if (position == 8)
	RJMP _0x110
_0x100:
	CALL SUBOPT_0x1E
	SBIW R26,8
	BRNE _0x111
; 0000 01C7             {
; 0000 01C8                 #asm("wdr")
	wdr
; 0000 01C9                 if (imin >= 15 || imin <= 1) action = imin;
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CP   R6,R30
	CPC  R7,R31
	BRGE _0x113
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R6
	CPC  R31,R7
	BRLT _0x112
_0x113:
	CALL SUBOPT_0x21
; 0000 01CA                 else if (imin >= 2 && imin <= 5) action = imin+2;
	RJMP _0x115
_0x112:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R6,R30
	CPC  R7,R31
	BRLT _0x117
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R6
	CPC  R31,R7
	BRGE _0x118
_0x117:
	RJMP _0x116
_0x118:
	MOVW R30,R6
	ADIW R30,2
	RJMP _0x1CF
; 0000 01CB                 else if (imin >= 11 && imin <= 14) action = imin-2;
_0x116:
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CP   R6,R30
	CPC  R7,R31
	BRLT _0x11B
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CP   R30,R6
	CPC  R31,R7
	BRGE _0x11C
_0x11B:
	RJMP _0x11A
_0x11C:
	MOVW R30,R6
	SBIW R30,2
	RJMP _0x1CF
; 0000 01CC                 else if (imin >= 6 && imin <= 10) action = 1000;
_0x11A:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R6,R30
	CPC  R7,R31
	BRLT _0x11F
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R30,R6
	CPC  R31,R7
	BRGE _0x120
_0x11F:
	RJMP _0x11E
_0x120:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
_0x1CF:
	STS  _action,R30
	STS  _action+1,R31
; 0000 01CD             }
_0x11E:
_0x115:
; 0000 01CE             else if (position == 9)
	RJMP _0x121
_0x111:
	CALL SUBOPT_0x1E
	SBIW R26,9
	BRNE _0x122
; 0000 01CF             {
; 0000 01D0                 #asm("wdr")
	wdr
; 0000 01D1                 if (imin == 0) action = 15;
	MOV  R0,R6
	OR   R0,R7
	BRNE _0x123
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	RJMP _0x1D0
; 0000 01D2                 else if (imin >= 13) action = imin-1;
_0x123:
	CALL SUBOPT_0x1F
	BRLT _0x125
	MOVW R30,R6
	SBIW R30,1
	RJMP _0x1D0
; 0000 01D3                 else if (imin == 12) action = imin-2;
_0x125:
	CALL SUBOPT_0x24
	BRNE _0x127
	MOVW R30,R6
	SBIW R30,2
	RJMP _0x1D0
; 0000 01D4                 else if (imin <= 11 && imin >= 9) action = imin+1;
_0x127:
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CP   R30,R6
	CPC  R31,R7
	BRLT _0x12A
	CALL SUBOPT_0x26
	BRGE _0x12B
_0x12A:
	RJMP _0x129
_0x12B:
	MOVW R30,R6
	ADIW R30,1
	RJMP _0x1D0
; 0000 01D5                 else if (imin == 8) action = imin;
_0x129:
	CALL SUBOPT_0x25
	BRNE _0x12D
	CALL SUBOPT_0x21
; 0000 01D6                 else if (imin >= 5 && imin <= 7) action= imin-1;
	RJMP _0x12E
_0x12D:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R6,R30
	CPC  R7,R31
	BRLT _0x130
	CALL SUBOPT_0x23
	BRGE _0x131
_0x130:
	RJMP _0x12F
_0x131:
	MOVW R30,R6
	SBIW R30,1
	RJMP _0x1D0
; 0000 01D7                 else if (imin <= 4) action = imin+2;
_0x12F:
	CALL SUBOPT_0x27
	BRLT _0x133
	MOVW R30,R6
	ADIW R30,2
_0x1D0:
	STS  _action,R30
	STS  _action+1,R31
; 0000 01D8             }
_0x133:
_0x12E:
; 0000 01D9     }
_0x122:
_0x121:
_0x110:
_0xFF:
_0xF2:
_0xDF:
_0xD2:
_0xC5:
_0xB8:
; 0000 01DA 
; 0000 01DB          //command
; 0000 01DC         switch (action)
	LDS  R30,_action
	LDS  R31,_action+1
; 0000 01DD         {
; 0000 01DE             case 0:
	SBIW R30,0
	BRNE _0x137
; 0000 01DF                 motor(forward);
	CALL SUBOPT_0x29
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2B
	MOVW R26,R30
	CALL _motor
; 0000 01E0             break;
	RJMP _0x136
; 0000 01E1 
; 0000 01E2             case 1:
_0x137:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x138
; 0000 01E3                 motor(v,v/2,-v,-v/2);
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2D
	MOVW R26,R30
	CALL _motor
; 0000 01E4             break;
	RJMP _0x136
; 0000 01E5 
; 0000 01E6             case 2:
_0x138:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x139
; 0000 01E7                 motor(v,0,-v,0);
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2F
; 0000 01E8             break;
	RJMP _0x136
; 0000 01E9 
; 0000 01EA             case 3:
_0x139:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x13A
; 0000 01EB                 motor(v,-v/2,-v,v/2);
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2B
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x2C
	MOVW R26,R30
	CALL _motor
; 0000 01EC             break;
	RJMP _0x136
; 0000 01ED 
; 0000 01EE             case 4:
_0x13A:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x13B
; 0000 01EF                 motor(right);
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x30
; 0000 01F0             break;
	RJMP _0x136
; 0000 01F1 
; 0000 01F2             case 5:
_0x13B:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x13C
; 0000 01F3                 motor(v/2,-v,-v/2,v);
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x30
; 0000 01F4             break;
	RJMP _0x136
; 0000 01F5 
; 0000 01F6             case 6:
_0x13C:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x13D
; 0000 01F7                 motor(0,-v,0,v);
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x31
	CALL SUBOPT_0x30
; 0000 01F8             break;
	RJMP _0x136
; 0000 01F9 
; 0000 01FA             case 7:
_0x13D:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x13E
; 0000 01FB                 motor(-v/2,-v,v/2,v);
	CALL SUBOPT_0x2A
	MOVW R22,R30
	CALL SUBOPT_0x2D
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R23
	ST   -Y,R22
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x30
; 0000 01FC             break;
	RJMP _0x136
; 0000 01FD 
; 0000 01FE             case 8:
_0x13E:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x13F
; 0000 01FF                 motor(back);
	CALL SUBOPT_0x2A
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
	CALL _motor
; 0000 0200             break;
	RJMP _0x136
; 0000 0201 
; 0000 0202             case 9:
_0x13F:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x140
; 0000 0203                 motor(-v,-v/2,v,v/2);
	CALL SUBOPT_0x2A
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x32
	CALL SUBOPT_0x2C
	MOVW R26,R30
	CALL _motor
; 0000 0204             break;
	RJMP _0x136
; 0000 0205 
; 0000 0206             case 10:
_0x140:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x141
; 0000 0207                 motor(-v,0,v,0);
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x31
	CALL SUBOPT_0x32
	LDI  R26,LOW(0)
	LDI  R27,0
	CALL _motor
; 0000 0208             break;
	RJMP _0x136
; 0000 0209 
; 0000 020A             case 11:
_0x141:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x142
; 0000 020B                 motor(-v,v/2,v,-v/2);
	CALL SUBOPT_0x2A
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x32
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2D
	MOVW R26,R30
	CALL _motor
; 0000 020C             break;
	RJMP _0x136
; 0000 020D 
; 0000 020E             case 12:
_0x142:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x143
; 0000 020F                 motor(left);
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x32
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2A
	MOVW R26,R30
	CALL _motor
; 0000 0210             break;
	RJMP _0x136
; 0000 0211 
; 0000 0212             case 13:
_0x143:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x144
; 0000 0213                 motor(-v/2,v,v/2,-v);
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x32
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2B
	MOVW R26,R30
	CALL _motor
; 0000 0214             break;
	RJMP _0x136
; 0000 0215 
; 0000 0216             case 14:
_0x144:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x145
; 0000 0217                 motor(0,v,0,-v);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0x32
	CALL SUBOPT_0x2E
	MOVW R26,R30
	CALL _motor
; 0000 0218             break;
	RJMP _0x136
; 0000 0219 
; 0000 021A             case 15:
_0x145:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x146
; 0000 021B                 motor(v/2,v,-v/2,-v);
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x32
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2B
	MOVW R26,R30
	CALL _motor
; 0000 021C             break;
	RJMP _0x136
; 0000 021D 
; 0000 021E             case 1000:
_0x146:
	CPI  R30,LOW(0x3E8)
	LDI  R26,HIGH(0x3E8)
	CPC  R31,R26
	BRNE _0x148
; 0000 021F                 motor(0,0,0,0);
	CALL SUBOPT_0x34
	CALL SUBOPT_0x31
	CALL SUBOPT_0x2F
; 0000 0220             break;
; 0000 0221 
; 0000 0222             default:
_0x148:
; 0000 0223             break;
; 0000 0224         }
_0x136:
; 0000 0225     }
; 0000 0226 
; 0000 0227     else
	RJMP _0x149
_0x79:
; 0000 0228     {
; 0000 0229         if (SB < backmax1-50) motor(-v+k,-v-k,v-k,v+k);
	LDI  R26,LOW(_backmax1)
	LDI  R27,HIGH(_backmax1)
	CALL __EEPROMRDW
	SBIW R30,50
	CP   R12,R30
	CPC  R13,R31
	BRGE _0x14A
	CALL SUBOPT_0x2A
	MOVW R0,R30
	CALL SUBOPT_0x17
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R0
	CALL SUBOPT_0x35
	CALL SUBOPT_0x17
	CALL SUBOPT_0x36
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x14
	CALL SUBOPT_0x33
	ADD  R26,R30
	ADC  R27,R31
	RJMP _0x1D1
; 0000 022A         else if (SB > backmax1+150) motor(v+k,v-k,-v-k,-v+k);
_0x14A:
	LDI  R26,LOW(_backmax1)
	LDI  R27,HIGH(_backmax1)
	CALL __EEPROMRDW
	SUBI R30,LOW(-150)
	SBCI R31,HIGH(-150)
	CP   R30,R12
	CPC  R31,R13
	BRGE _0x14C
	CALL SUBOPT_0x14
	CALL SUBOPT_0x33
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x16
	CALL SUBOPT_0x36
	CALL SUBOPT_0x2B
	MOVW R26,R30
	CALL SUBOPT_0x35
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x17
	ADD  R26,R30
	ADC  R27,R31
	RJMP _0x1D1
; 0000 022B         else if (k < -20 || k > 20) motor(center);
_0x14C:
	CALL SUBOPT_0x1A
	BRLT _0x14F
	CALL SUBOPT_0x17
	SBIW R26,21
	BRLT _0x14E
_0x14F:
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
	RJMP _0x1D1
; 0000 022C         else motor(0,0,0,0);
_0x14E:
	CALL SUBOPT_0x34
	CALL SUBOPT_0x31
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	LDI  R27,0
_0x1D1:
	CALL _motor
; 0000 022D     }
_0x149:
; 0000 022E }
	RET
; .FEND
;
;void setup()
; 0000 0231 {
; 0000 0232     old_print_lcd = print_lcd;
; 0000 0233     print_lcd = 0;
; 0000 0234     setcmp = false;
; 0000 0235     setkaf1 = false;
; 0000 0236     setkaf2 = false;
; 0000 0237     setkaf3 = false;
; 0000 0238     setkaf4 = false;
; 0000 0239     setzamin1 = false;
; 0000 023A     setzamin2 = false;
; 0000 023B     setzamin3 = false;
; 0000 023C     setzamin4 = false;
; 0000 023D     setback1 = false;
; 0000 023E     setback2 = false;
; 0000 023F     setback3 = false;
; 0000 0240     lcd_clear();
; 0000 0241     lcd_gotoxy(0,0);
; 0000 0242     lcd_putsf("setup start...");
; 0000 0243     delay_ms(1000);
; 0000 0244     while (setcmp == false)
; 0000 0245     {
; 0000 0246         #asm("wdr")
; 0000 0247         sensor();
; 0000 0248         lcd_clear();
; 0000 0249         lcd_gotoxy(0,0);
; 0000 024A         lcd_putsf("set cmp: ");
; 0000 024B         lcd_putchar((compass_read(1)/100)%10 + '0');
; 0000 024C         lcd_putchar((compass_read(1)/10)%10 + '0');
; 0000 024D         lcd_putchar((compass_read(1)/1)%10 + '0');
; 0000 024E         if (PINC.3 == 1)
; 0000 024F         {
; 0000 0250             c = compass_read(1);
; 0000 0251             lcd_clear();
; 0000 0252             lcd_gotoxy(0,0);
; 0000 0253             lcd_putsf("cmp set");
; 0000 0254             delay_ms(1000);
; 0000 0255             setcmp = true;
; 0000 0256         }
; 0000 0257     }
; 0000 0258     while (setkaf1 == false)
; 0000 0259     {
; 0000 025A         #asm("wdr")
; 0000 025B         sensor();
; 0000 025C         lcd_clear();
; 0000 025D         lcd_gotoxy(0,0);
; 0000 025E         lcd_putsf("set SKF: ");
; 0000 025F         lcd_putchar((SKF/100)%10 + '0');
; 0000 0260         lcd_putchar((SKF/10)%10 + '0');
; 0000 0261         lcd_putchar((SKF/1)%10 + '0');
; 0000 0262         if (PINC.3 == 1)
; 0000 0263         {
; 0000 0264             kafmax1 = SKF;
; 0000 0265             lcd_clear();
; 0000 0266             lcd_gotoxy(0,0);
; 0000 0267             lcd_putsf("SKF set");
; 0000 0268             delay_ms(1000);
; 0000 0269             setkaf1 = true;
; 0000 026A         }
; 0000 026B 
; 0000 026C     }
; 0000 026D     while (setkaf2 == false)
; 0000 026E     {
; 0000 026F         #asm("wdr")
; 0000 0270         sensor();
; 0000 0271         lcd_clear();
; 0000 0272         lcd_gotoxy(0,0);
; 0000 0273         lcd_putsf("set SKR: ");
; 0000 0274         lcd_putchar((SKR/100)%10 + '0');
; 0000 0275         lcd_putchar((SKR/10)%10 + '0');
; 0000 0276         lcd_putchar((SKR/1)%10 + '0');
; 0000 0277         if (PINC.3 == 1)
; 0000 0278         {
; 0000 0279             kafmax2 = SKR;
; 0000 027A             lcd_clear();
; 0000 027B             lcd_gotoxy(0,0);
; 0000 027C             lcd_putsf("SKR set");
; 0000 027D             delay_ms(1000);
; 0000 027E             setkaf2 = true;
; 0000 027F         }
; 0000 0280 
; 0000 0281     }
; 0000 0282     while (setkaf3 == false)
; 0000 0283     {
; 0000 0284         #asm("wdr")
; 0000 0285         sensor();
; 0000 0286         lcd_clear();
; 0000 0287         lcd_gotoxy(0,0);
; 0000 0288         lcd_putsf("set SKB: ");
; 0000 0289         lcd_putchar((SKB/100)%10 + '0');
; 0000 028A         lcd_putchar((SKB/10)%10 + '0');
; 0000 028B         lcd_putchar((SKB/1)%10 + '0');
; 0000 028C         if (PINC.3 == 1)
; 0000 028D         {
; 0000 028E             kafmax3 = SKB;
; 0000 028F             lcd_clear();
; 0000 0290             lcd_gotoxy(0,0);
; 0000 0291             lcd_putsf("SKB set");
; 0000 0292             delay_ms(1000);
; 0000 0293             setkaf3 = true;
; 0000 0294         }
; 0000 0295 
; 0000 0296     }
; 0000 0297     while (setkaf4 == false)
; 0000 0298     {
; 0000 0299         #asm("wdr")
; 0000 029A         sensor();
; 0000 029B         lcd_clear();
; 0000 029C         lcd_gotoxy(0,0);
; 0000 029D         lcd_putsf("set SKL: ");
; 0000 029E         lcd_putchar((SKL/100)%10 + '0');
; 0000 029F         lcd_putchar((SKL/10)%10 + '0');
; 0000 02A0         lcd_putchar((SKL/1)%10 + '0');
; 0000 02A1         if (PINC.3 == 1)
; 0000 02A2         {
; 0000 02A3             kafmax4 = SKL;
; 0000 02A4             lcd_clear();
; 0000 02A5             lcd_gotoxy(0,0);
; 0000 02A6             lcd_putsf("SKL set");
; 0000 02A7             delay_ms(1000);
; 0000 02A8             setkaf4 = true;
; 0000 02A9         }
; 0000 02AA 
; 0000 02AB     }
; 0000 02AC     while (setzamin1 == false)
; 0000 02AD     {
; 0000 02AE         #asm("wdr")
; 0000 02AF         sensor();
; 0000 02B0         lcd_clear();
; 0000 02B1         lcd_gotoxy(0,0);
; 0000 02B2         lcd_putsf("set zaminF: ");
; 0000 02B3         lcd_putchar((SKF/100)%10 + '0');
; 0000 02B4         lcd_putchar((SKF/10)%10 + '0');
; 0000 02B5         lcd_putchar((SKF/1)%10 + '0');
; 0000 02B6         if (PINC.3 == 1)
; 0000 02B7         {
; 0000 02B8             kafmin1 = SKF;
; 0000 02B9             lcd_clear();
; 0000 02BA             lcd_gotoxy(0,0);
; 0000 02BB             lcd_putsf("zaminF set");
; 0000 02BC             delay_ms(1000);
; 0000 02BD             setzamin1 = true;
; 0000 02BE         }
; 0000 02BF 
; 0000 02C0     }
; 0000 02C1     while (setzamin2 == false)
; 0000 02C2     {
; 0000 02C3         #asm("wdr")
; 0000 02C4         sensor();
; 0000 02C5         lcd_clear();
; 0000 02C6         lcd_gotoxy(0,0);
; 0000 02C7         lcd_putsf("set zaminR: ");
; 0000 02C8         lcd_putchar((SKR/100)%10 + '0');
; 0000 02C9         lcd_putchar((SKR/10)%10 + '0');
; 0000 02CA         lcd_putchar((SKR/1)%10 + '0');
; 0000 02CB         if (PINC.3 == 1)
; 0000 02CC         {
; 0000 02CD             kafmin2 = SKR;
; 0000 02CE             lcd_clear();
; 0000 02CF             lcd_gotoxy(0,0);
; 0000 02D0             lcd_putsf("zaminR set");
; 0000 02D1             delay_ms(1000);
; 0000 02D2             setzamin2 = true;
; 0000 02D3         }
; 0000 02D4 
; 0000 02D5     }
; 0000 02D6     while (setzamin3 == false)
; 0000 02D7     {
; 0000 02D8         #asm("wdr")
; 0000 02D9         sensor();
; 0000 02DA         lcd_clear();
; 0000 02DB         lcd_gotoxy(0,0);
; 0000 02DC         lcd_putsf("set zaminB: ");
; 0000 02DD         lcd_putchar((SKB/100)%10 + '0');
; 0000 02DE         lcd_putchar((SKB/10)%10 + '0');
; 0000 02DF         lcd_putchar((SKB/1)%10 + '0');
; 0000 02E0         if (PINC.3 == 1)
; 0000 02E1         {
; 0000 02E2             kafmin3 = SKB;
; 0000 02E3             lcd_clear();
; 0000 02E4             lcd_gotoxy(0,0);
; 0000 02E5             lcd_putsf("zaminB set");
; 0000 02E6             delay_ms(1000);
; 0000 02E7             setzamin3 = true;
; 0000 02E8         }
; 0000 02E9 
; 0000 02EA     }
; 0000 02EB     while (setzamin4 == false)
; 0000 02EC     {
; 0000 02ED         #asm("wdr")
; 0000 02EE         sensor();
; 0000 02EF         lcd_clear();
; 0000 02F0         lcd_gotoxy(0,0);
; 0000 02F1         lcd_putsf("set zaminL: ");
; 0000 02F2         lcd_putchar((SKL/100)%10 + '0');
; 0000 02F3         lcd_putchar((SKL/10)%10 + '0');
; 0000 02F4         lcd_putchar((SKL/1)%10 + '0');
; 0000 02F5         if (PINC.3 == 1)
; 0000 02F6         {
; 0000 02F7             kafmin4 = SKL;
; 0000 02F8             lcd_clear();
; 0000 02F9             lcd_gotoxy(0,0);
; 0000 02FA             lcd_putsf("zaminL set");
; 0000 02FB             delay_ms(1000);
; 0000 02FC             setzamin4 = true;
; 0000 02FD         }
; 0000 02FE 
; 0000 02FF     }
; 0000 0300     kafmid1 = (kafmin1 + kafmax1)/2;
; 0000 0301     kafmid2 = (kafmin2 + kafmax2)/2;
; 0000 0302     kafmid3 = (kafmin3 + kafmax3)/2;
; 0000 0303     kafmid4 = (kafmin4 + kafmax4)/2;
; 0000 0304     while (setback1 == false)
; 0000 0305     {
; 0000 0306         #asm("wdr")
; 0000 0307         sensor();
; 0000 0308         lcd_clear();
; 0000 0309         lcd_gotoxy(0,0);
; 0000 030A         lcd_putsf("set back1: ");
; 0000 030B         lcd_putchar((SB/100)%10 + '0');
; 0000 030C         lcd_putchar((SB/10)%10 + '0');
; 0000 030D         lcd_putchar((SB/1)%10 + '0');
; 0000 030E         if (PINC.3 == 1)
; 0000 030F         {
; 0000 0310             backmax1 = SB;
; 0000 0311             lcd_clear();
; 0000 0312             lcd_gotoxy(0,0);
; 0000 0313             lcd_putsf("back1 set");
; 0000 0314             delay_ms(1000);
; 0000 0315             setback1 = true;
; 0000 0316         }
; 0000 0317 
; 0000 0318     }
; 0000 0319     while (setback2 == false)
; 0000 031A     {
; 0000 031B         #asm("wdr")
; 0000 031C         sensor();
; 0000 031D         lcd_clear();
; 0000 031E         lcd_gotoxy(0,0);
; 0000 031F         lcd_putsf("set back2: ");
; 0000 0320         lcd_putchar((SB/100)%10 + '0');
; 0000 0321         lcd_putchar((SB/10)%10 + '0');
; 0000 0322         lcd_putchar((SB/1)%10 + '0');
; 0000 0323         if (PINC.3 == 1)
; 0000 0324         {
; 0000 0325             backmax2 = SB;
; 0000 0326             lcd_clear();
; 0000 0327             lcd_gotoxy(0,0);
; 0000 0328             lcd_putsf("back2 set");
; 0000 0329             delay_ms(1000);
; 0000 032A             setback2 = true;
; 0000 032B         }
; 0000 032C 
; 0000 032D     }
; 0000 032E     while (setback3 == false)
; 0000 032F     {
; 0000 0330         #asm("wdr")
; 0000 0331         sensor();
; 0000 0332         lcd_clear();
; 0000 0333         lcd_gotoxy(0,0);
; 0000 0334         lcd_putsf("set back3: ");
; 0000 0335         lcd_putchar((SB/100)%10 + '0');
; 0000 0336         lcd_putchar((SB/10)%10 + '0');
; 0000 0337         lcd_putchar((SB/1)%10 + '0');
; 0000 0338         if (PINC.3 == 1)
; 0000 0339         {
; 0000 033A             backmax3 = SB;
; 0000 033B             lcd_clear();
; 0000 033C             lcd_gotoxy(0,0);
; 0000 033D             lcd_putsf("back3 set");
; 0000 033E             delay_ms(1000);
; 0000 033F             setback3 = true;
; 0000 0340         }
; 0000 0341 
; 0000 0342     }
; 0000 0343     lcd_clear();
; 0000 0344     lcd_putsf("setup done");
; 0000 0345     delay_ms(1000);
; 0000 0346     print_lcd = old_print_lcd;
; 0000 0347 }
;
;void main(void)
; 0000 034A {
_main:
; .FSTART _main
; 0000 034B {
; 0000 034C // Declare your local variables here
; 0000 034D 
; 0000 034E // Input/Output Ports initialization
; 0000 034F // Port A initialization
; 0000 0350 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0351 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0352 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0353 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0354 
; 0000 0355 // Port B initialization
; 0000 0356 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=In Bit1=In Bit0=In
; 0000 0357 DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(248)
	OUT  0x17,R30
; 0000 0358 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=T Bit1=T Bit0=T
; 0000 0359 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 035A 
; 0000 035B // Port C initialization
; 0000 035C // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 035D DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 035E // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 035F PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 0360 
; 0000 0361 // Port D initialization
; 0000 0362 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0363 DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0364 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0365 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0366 
; 0000 0367 // Timer/Counter 0 initialization
; 0000 0368 // Clock source: System Clock
; 0000 0369 // Clock value: 31.250 kHz
; 0000 036A // Mode: Fast PWM top=0xFF
; 0000 036B // OC0 output: Non-Inverted PWM
; 0000 036C // Timer Period: 8.192 ms
; 0000 036D // Output Pulse(s):
; 0000 036E // OC0 Period: 8.192 ms Width: 0 us
; 0000 036F TCCR0=(1<<WGM00) | (1<<COM01) | (0<<COM00) | (1<<WGM01) | (1<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(108)
	OUT  0x33,R30
; 0000 0370 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0371 OCR0=0x00;
	OUT  0x3C,R30
; 0000 0372 
; 0000 0373 // Timer/Counter 1 initialization
; 0000 0374 // Clock source: System Clock
; 0000 0375 // Clock value: 31.250 kHz
; 0000 0376 // Mode: Fast PWM top=0x00FF
; 0000 0377 // OC1A output: Non-Inverted PWM
; 0000 0378 // OC1B output: Non-Inverted PWM
; 0000 0379 // Noise Canceler: Off
; 0000 037A // Input Capture on Falling Edge
; 0000 037B // Timer Period: 8.192 ms
; 0000 037C // Output Pulse(s):
; 0000 037D // OC1A Period: 8.192 ms Width: 0 us// OC1B Period: 8.192 ms Width: 0 us
; 0000 037E // Timer1 Overflow Interrupt: Off
; 0000 037F // Input Capture Interrupt: Off
; 0000 0380 // Compare A Match Interrupt: Off
; 0000 0381 // Compare B Match Interrupt: Off
; 0000 0382 TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (1<<WGM10);
	LDI  R30,LOW(161)
	OUT  0x2F,R30
; 0000 0383 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (1<<CS12) | (0<<CS11) | (0<<CS10);
	LDI  R30,LOW(12)
	OUT  0x2E,R30
; 0000 0384 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0385 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0386 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0387 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0388 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0389 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 038A OCR1BH=0x00;
	OUT  0x29,R30
; 0000 038B OCR1BL=0x00;
	OUT  0x28,R30
; 0000 038C 
; 0000 038D // Timer/Counter 2 initialization
; 0000 038E // Clock source: System Clock
; 0000 038F // Clock value: 31.250 kHz
; 0000 0390 // Mode: Fast PWM top=0xFF
; 0000 0391 // OC2 output: Non-Inverted PWM
; 0000 0392 // Timer Period: 8.192 ms
; 0000 0393 // Output Pulse(s):
; 0000 0394 // OC2 Period: 8.192 ms Width: 0 us
; 0000 0395 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0396 TCCR2=(1<<PWM2) | (1<<COM21) | (0<<COM20) | (1<<CTC2) | (1<<CS22) | (1<<CS21) | (0<<CS20);
	LDI  R30,LOW(110)
	OUT  0x25,R30
; 0000 0397 TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 0398 OCR2=0x00;
	OUT  0x23,R30
; 0000 0399 
; 0000 039A // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 039B TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 039C 
; 0000 039D // External Interrupt(s) initialization
; 0000 039E // INT0: Off
; 0000 039F // INT1: Off
; 0000 03A0 // INT2: Off
; 0000 03A1 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 03A2 MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 03A3 
; 0000 03A4 // USART initialization
; 0000 03A5 // USART disabled
; 0000 03A6 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 03A7 
; 0000 03A8 // Analog Comparator initialization
; 0000 03A9 // Analog Comparator: Off
; 0000 03AA // The Analog Comparator's positive input is
; 0000 03AB // connected to the AIN0 pin
; 0000 03AC // The Analog Comparator's negative input is
; 0000 03AD // connected to the AIN1 pin
; 0000 03AE ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 03AF 
; 0000 03B0 // ADC initialization
; 0000 03B1 // ADC Clock frequency: 62.500 kHz
; 0000 03B2 // ADC Voltage Reference: AVCC pin
; 0000 03B3 // ADC Auto Trigger Source: ADC Stopped
; 0000 03B4 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 03B5 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 03B6 SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 03B7 
; 0000 03B8 // SPI initialization
; 0000 03B9 // SPI disabled
; 0000 03BA SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 03BB 
; 0000 03BC // TWI initialization
; 0000 03BD // TWI disabled
; 0000 03BE TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 03BF 
; 0000 03C0 // Bit-Banged I2C Bus initialization
; 0000 03C1 // I2C Port: PORTB
; 0000 03C2 // I2C SDA bit: 1
; 0000 03C3 // I2C SCL bit: 0
; 0000 03C4 // Bit Rate: 100 kHz
; 0000 03C5 // Note: I2C settings are specified in the
; 0000 03C6 // Project|Configure|C Compiler|Libraries|I2C menu.
; 0000 03C7 i2c_init();
	CALL _i2c_init
; 0000 03C8 
; 0000 03C9 // Alphanumeric LCD initialization
; 0000 03CA // Connections are specified in the
; 0000 03CB // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 03CC // RS - PORTC Bit 0
; 0000 03CD // RD - PORTC Bit 1
; 0000 03CE // EN - PORTC Bit 2
; 0000 03CF // D4 - PORTC Bit 4
; 0000 03D0 // D5 - PORTC Bit 5
; 0000 03D1 // D6 - PORTC Bit 6
; 0000 03D2 // D7 - PORTC Bit 7
; 0000 03D3 // Characters/line: 16
; 0000 03D4 lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 03D5 
; 0000 03D6 // Watchdog Timer initialization
; 0000 03D7 // Watchdog Timer Prescaler: OSC/256k
; 0000 03D8 WDTCR=(0<<WDTOE) | (1<<WDE) | (1<<WDP2) | (0<<WDP1) | (0<<WDP0);
	LDI  R30,LOW(12)
	OUT  0x21,R30
; 0000 03D9 }
; 0000 03DA 
; 0000 03DB     delay_ms(3000);
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	CALL _delay_ms
; 0000 03DC 
; 0000 03DD     while (1)
_0x182:
; 0000 03DE     {
; 0000 03DF         #asm("wdr")
	wdr
; 0000 03E0         if (PINC.3 == 1)    c=compass_read(1);
	SBIS 0x13,3
	RJMP _0x185
	LDI  R26,LOW(1)
	CALL _compass_read
	LDI  R26,LOW(_c)
	LDI  R27,HIGH(_c)
	LDI  R31,0
	CALL __EEPROMWRW
; 0000 03E1         sensor();
_0x185:
	CALL _sensor
; 0000 03E2         if(SKF>600 && out==0)
	CALL SUBOPT_0xC
	CPI  R26,LOW(0x259)
	LDI  R30,HIGH(0x259)
	CPC  R27,R30
	BRLT _0x187
	LDS  R26,_out
	CPI  R26,LOW(0x0)
	BREQ _0x188
_0x187:
	RJMP _0x186
_0x188:
; 0000 03E3             {
; 0000 03E4             motor(-255,-255,255,255);
	CALL SUBOPT_0x37
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
	CALL SUBOPT_0x39
; 0000 03E5             delay_ms(400);
; 0000 03E6             out='F';
	LDI  R30,LOW(70)
	STS  _out,R30
; 0000 03E7             }
; 0000 03E8         if(SKB>600 && out==0)
_0x186:
	CALL SUBOPT_0xA
	CPI  R26,LOW(0x259)
	LDI  R30,HIGH(0x259)
	CPC  R27,R30
	BRLT _0x18A
	LDS  R26,_out
	CPI  R26,LOW(0x0)
	BREQ _0x18B
_0x18A:
	RJMP _0x189
_0x18B:
; 0000 03E9             {
; 0000 03EA             motor(255,255,-255,-255);
	CALL SUBOPT_0x38
	CALL SUBOPT_0x38
	CALL SUBOPT_0x37
	CALL SUBOPT_0x3A
; 0000 03EB             delay_ms(400);
; 0000 03EC             out='B';
	LDI  R30,LOW(66)
	STS  _out,R30
; 0000 03ED             }
; 0000 03EE         if(SKR>600 && out==0)
_0x189:
	CALL SUBOPT_0xB
	CPI  R26,LOW(0x259)
	LDI  R30,HIGH(0x259)
	CPC  R27,R30
	BRLT _0x18D
	LDS  R26,_out
	CPI  R26,LOW(0x0)
	BREQ _0x18E
_0x18D:
	RJMP _0x18C
_0x18E:
; 0000 03EF             {
; 0000 03F0             motor(255,-255,-255,255);
	CALL SUBOPT_0x38
	CALL SUBOPT_0x37
	CALL SUBOPT_0x37
	CALL SUBOPT_0x39
; 0000 03F1             delay_ms(400);
; 0000 03F2             out='R';
	LDI  R30,LOW(82)
	STS  _out,R30
; 0000 03F3             }
; 0000 03F4         if(SKL>600 && out==0)
_0x18C:
	CALL SUBOPT_0x9
	CPI  R26,LOW(0x259)
	LDI  R30,HIGH(0x259)
	CPC  R27,R30
	BRLT _0x190
	LDS  R26,_out
	CPI  R26,LOW(0x0)
	BREQ _0x191
_0x190:
	RJMP _0x18F
_0x191:
; 0000 03F5             {
; 0000 03F6             motor(-255,255,255,-255);
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
	CALL SUBOPT_0x38
	CALL SUBOPT_0x3A
; 0000 03F7             delay_ms(400);
; 0000 03F8             out='L';
	LDI  R30,LOW(76)
	STS  _out,R30
; 0000 03F9             }
; 0000 03FA 
; 0000 03FB         while(out=='F' && min<800)
_0x18F:
_0x192:
	LDS  R26,_out
	CPI  R26,LOW(0x46)
	BRNE _0x195
	CALL SUBOPT_0x13
	BRLT _0x196
_0x195:
	RJMP _0x194
_0x196:
; 0000 03FC             {
; 0000 03FD             sensor();
	CALL SUBOPT_0x3B
; 0000 03FE             if(imin<12 && imin>4)
	BRGE _0x198
	CALL SUBOPT_0x27
	BRLT _0x199
_0x198:
	RJMP _0x197
_0x199:
; 0000 03FF                 catch();
	CALL _catch
; 0000 0400             else motor(0,0,0,0);
	RJMP _0x19A
_0x197:
	CALL SUBOPT_0x34
	CALL SUBOPT_0x31
	CALL SUBOPT_0x2F
; 0000 0401             }
_0x19A:
	RJMP _0x192
_0x194:
; 0000 0402         while(out=='B' && min<800)
_0x19B:
	LDS  R26,_out
	CPI  R26,LOW(0x42)
	BRNE _0x19E
	CALL SUBOPT_0x13
	BRLT _0x19F
_0x19E:
	RJMP _0x19D
_0x19F:
; 0000 0403             {
; 0000 0404             sensor();
	CALL SUBOPT_0x3B
; 0000 0405             if(!(imin<12 && imin>4))
	BRGE _0x1A1
	CALL SUBOPT_0x27
	BRLT _0x1A0
_0x1A1:
; 0000 0406                 catch();
	CALL _catch
; 0000 0407             else motor(0,0,0,0);
	RJMP _0x1A3
_0x1A0:
	CALL SUBOPT_0x34
	CALL SUBOPT_0x31
	CALL SUBOPT_0x2F
; 0000 0408             }
_0x1A3:
	RJMP _0x19B
_0x19D:
; 0000 0409         while((out=='R' || SR>300) && min<800)
_0x1A4:
	LDS  R26,_out
	CPI  R26,LOW(0x52)
	BREQ _0x1A7
	CALL SUBOPT_0x7
	CPI  R26,LOW(0x12D)
	LDI  R30,HIGH(0x12D)
	CPC  R27,R30
	BRLT _0x1A9
_0x1A7:
	CALL SUBOPT_0x13
	BRLT _0x1AA
_0x1A9:
	RJMP _0x1A6
_0x1AA:
; 0000 040A             {
; 0000 040B             sensor();
	CALL SUBOPT_0x3B
; 0000 040C             if(imin<12 && imin>4)
	BRGE _0x1AC
	CALL SUBOPT_0x27
	BRLT _0x1AD
_0x1AC:
	RJMP _0x1AB
_0x1AD:
; 0000 040D                 catch();
	CALL _catch
; 0000 040E             else motor(0,0,0,0);
	RJMP _0x1AE
_0x1AB:
	CALL SUBOPT_0x34
	CALL SUBOPT_0x31
	CALL SUBOPT_0x2F
; 0000 040F             }
_0x1AE:
	RJMP _0x1A4
_0x1A6:
; 0000 0410         while((out=='L' || SL>300) && min<800)
_0x1AF:
	LDS  R26,_out
	CPI  R26,LOW(0x4C)
	BREQ _0x1B2
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	CP   R30,R10
	CPC  R31,R11
	BRGE _0x1B4
_0x1B2:
	CALL SUBOPT_0x13
	BRLT _0x1B5
_0x1B4:
	RJMP _0x1B1
_0x1B5:
; 0000 0411             {
; 0000 0412             sensor();
	CALL SUBOPT_0x3B
; 0000 0413             if(imin<12 && imin>4)
	BRGE _0x1B7
	CALL SUBOPT_0x27
	BRLT _0x1B8
_0x1B7:
	RJMP _0x1B6
_0x1B8:
; 0000 0414                 catch();
	CALL _catch
; 0000 0415             else motor(0,0,0,0);
	RJMP _0x1B9
_0x1B6:
	CALL SUBOPT_0x34
	CALL SUBOPT_0x31
	CALL SUBOPT_0x2F
; 0000 0416             }
_0x1B9:
	RJMP _0x1AF
_0x1B1:
; 0000 0417 
; 0000 0418         out=0;
	LDI  R30,LOW(0)
	STS  _out,R30
; 0000 0419         catch();
	CALL _catch
; 0000 041A         out = 0;
	LDI  R30,LOW(0)
	STS  _out,R30
; 0000 041B     }
	RJMP _0x182
; 0000 041C }
_0x1BA:
	RJMP _0x1BA
; .FEND
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G100:
; .FSTART __lcd_delay_G100
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
; .FEND
__lcd_ready:
; .FSTART __lcd_ready
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
; .FEND
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G100
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G100
	RET
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
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
; .FEND
__lcd_read_nibble_G100:
; .FSTART __lcd_read_nibble_G100
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G100
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G100
    andi  r30,0xf0
	RET
; .FEND
_lcd_read_byte0_G100:
; .FSTART _lcd_read_byte0_G100
	CALL __lcd_delay_G100
	RCALL __lcd_read_nibble_G100
    mov   r26,r30
	RCALL __lcd_read_nibble_G100
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	CALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	CALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	CALL __lcd_ready
	LDI  R26,LOW(2)
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R26,LOW(12)
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R26,LOW(1)
	CALL __lcd_write_data
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
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
	LDS  R26,__lcd_y
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2000004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
	LD   R26,Y
	CALL __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	JMP  _0x2020001
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	ST   -Y,R27
	ST   -Y,R26
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
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
__long_delay_G100:
; .FSTART __long_delay_G100
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
; .FEND
__lcd_init_write_G100:
; .FSTART __lcd_init_write_G100
	ST   -Y,R26
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
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	RCALL SUBOPT_0x3C
	RCALL SUBOPT_0x3C
	RCALL SUBOPT_0x3C
	RCALL __long_delay_G100
	LDI  R26,LOW(32)
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R26,LOW(40)
	RCALL SUBOPT_0x3D
	LDI  R26,LOW(4)
	RCALL SUBOPT_0x3D
	LDI  R26,LOW(133)
	RCALL SUBOPT_0x3D
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
	LDI  R26,LOW(6)
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x2020001:
	ADIW R28,1
	RET
; .FEND

	.DSEG
_SR:
	.BYTE 0x2
_k:
	.BYTE 0x2
_SKF:
	.BYTE 0x2
_SKL:
	.BYTE 0x2
_SKB:
	.BYTE 0x2
_SKR:
	.BYTE 0x2
_print_lcd:
	.BYTE 0x2
_old_print_lcd:
	.BYTE 0x2
_cmp:
	.BYTE 0x2
_v:
	.BYTE 0x2
_position:
	.BYTE 0x2
_action:
	.BYTE 0x2
_setcmp:
	.BYTE 0x1
_setback1:
	.BYTE 0x1
_setback2:
	.BYTE 0x1
_setback3:
	.BYTE 0x1
_setkaf1:
	.BYTE 0x1
_setkaf2:
	.BYTE 0x1
_setkaf3:
	.BYTE 0x1
_setkaf4:
	.BYTE 0x1
_setzamin1:
	.BYTE 0x1
_setzamin2:
	.BYTE 0x1
_setzamin3:
	.BYTE 0x1
_setzamin4:
	.BYTE 0x1
_out:
	.BYTE 0x1

	.ESEG
_c:
	.BYTE 0x2
_kafmin1:
	.BYTE 0x2
_kafmin2:
	.BYTE 0x2
_kafmin3:
	.BYTE 0x2
_kafmin4:
	.BYTE 0x2
_kafmax1:
	.BYTE 0x2
_kafmax2:
	.BYTE 0x2
_kafmax3:
	.BYTE 0x2
_kafmax4:
	.BYTE 0x2
_kafmid1:
	.BYTE 0x2
_kafmid2:
	.BYTE 0x2
_kafmid3:
	.BYTE 0x2
_kafmid4:
	.BYTE 0x2
_backmax1:
	.BYTE 0x2
_backmax2:
	.BYTE 0x2
_backmax3:
	.BYTE 0x2

	.DSEG
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	CALL _i2c_write
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2:
	CALL __DIVW21
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __MANDW12
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3:
	LDS  R26,_print_lcd
	LDS  R27,_print_lcd+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:107 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:105 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	MOVW R26,R30
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7:
	LDS  R26,_SR
	LDS  R27,_SR+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8:
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	LDS  R26,_SKL
	LDS  R27,_SKL+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	LDS  R26,_SKB
	LDS  R27,_SKB+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	LDS  R26,_SKR
	LDS  R27,_SKR+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	LDS  R26,_SKF
	LDS  R27,_SKF+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xD:
	LDS  R26,_cmp
	LDS  R27,_cmp+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xE:
	LDS  R30,_cmp
	LDS  R31,_cmp+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	STS  _cmp,R30
	STS  _cmp+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	RCALL SUBOPT_0xE
	CALL __ANEGW1
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(65516)
	LDI  R31,HIGH(65516)
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(170)
	LDI  R31,HIGH(170)
	CP   R12,R30
	CPC  R13,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(800)
	LDI  R31,HIGH(800)
	CP   R8,R30
	CPC  R9,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x14:
	LDS  R30,_k
	LDS  R31,_k+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x15:
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x14
	CALL __ANEGW1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x16:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R26,_k
	LDS  R27,_k+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x17:
	LDS  R26,_k
	LDS  R27,_k+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x18:
	LDI  R26,LOW(_backmax3)
	LDI  R27,HIGH(_backmax3)
	CALL __EEPROMRDW
	CP   R12,R30
	CPC  R13,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	RCALL SUBOPT_0x17
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1A:
	RCALL SUBOPT_0x17
	CPI  R26,LOW(0xFFEC)
	LDI  R30,HIGH(0xFFEC)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1B:
	LDI  R26,LOW(_backmax2)
	LDI  R27,HIGH(_backmax2)
	CALL __EEPROMRDW
	CP   R12,R30
	CPC  R13,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1C:
	LDI  R26,LOW(_backmax3)
	LDI  R27,HIGH(_backmax3)
	CALL __EEPROMRDW
	CP   R30,R12
	CPC  R31,R13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1D:
	LDI  R26,LOW(_backmax2)
	LDI  R27,HIGH(_backmax2)
	CALL __EEPROMRDW
	CP   R30,R12
	CPC  R31,R13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1E:
	LDS  R26,_position
	LDS  R27,_position+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1F:
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	CP   R6,R30
	CPC  R7,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x20:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R6
	CPC  R31,R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x21:
	__PUTWMRN _action,0,6,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R6,R30
	CPC  R7,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CP   R30,R6
	CPC  R31,R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x24:
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CP   R30,R6
	CPC  R31,R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x25:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R30,R6
	CPC  R31,R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x26:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CP   R6,R30
	CPC  R7,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x27:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R6
	CPC  R31,R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x28:
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CP   R6,R30
	CPC  R7,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:53 WORDS
SUBOPT_0x29:
	LDS  R30,_v
	LDS  R31,_v+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:105 WORDS
SUBOPT_0x2A:
	LDS  R30,_v
	LDS  R31,_v+1
	CALL __ANEGW1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2B:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x2A

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x2C:
	LDS  R26,_v
	LDS  R27,_v+1
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x2D:
	MOVW R26,R30
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2E:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP SUBOPT_0x2B

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x2F:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	LDI  R27,0
	JMP  _motor

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x30:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R26,_v
	LDS  R27,_v+1
	JMP  _motor

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x31:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x32:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x29

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x33:
	LDS  R26,_v
	LDS  R27,_v+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x34:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	RCALL SUBOPT_0x14
	SUB  R26,R30
	SBC  R27,R31
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	LDS  R30,_v
	LDS  R31,_v+1
	SUB  R30,R26
	SBC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x37:
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x38:
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x39:
	LDI  R26,LOW(255)
	LDI  R27,0
	CALL _motor
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3A:
	LDI  R26,LOW(65281)
	LDI  R27,HIGH(65281)
	CALL _motor
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3B:
	CALL _sensor
	RJMP SUBOPT_0x28

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3C:
	CALL __long_delay_G100
	LDI  R26,LOW(48)
	JMP  __lcd_init_write_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3D:
	CALL __lcd_write_data
	JMP  __long_delay_G100


	.CSEG
	.equ __sda_bit=1
	.equ __scl_bit=0
	.equ __i2c_port=0x18 ;PORTB
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
	mov  r23,r26
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
	ldi  r23,8
__i2c_write0:
	lsl  r26
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
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
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

__MANDW12:
	CLT
	SBRS R31,7
	RJMP __MANDW121
	RCALL __ANEGW1
	SET
__MANDW121:
	AND  R30,R26
	AND  R31,R27
	BRTC __MANDW122
	RCALL __ANEGW1
__MANDW122:
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
