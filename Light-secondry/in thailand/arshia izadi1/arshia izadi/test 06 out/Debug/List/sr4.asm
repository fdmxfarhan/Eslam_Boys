
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
	.DEF _SR=R4
	.DEF _SR_msb=R5
	.DEF _SB=R6
	.DEF _SB_msb=R7
	.DEF _SL=R8
	.DEF _SL_msb=R9
	.DEF _f=R10
	.DEF _f_msb=R11
	.DEF _v=R12
	.DEF _v_msb=R13

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

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0xFF,0x0

_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x0C
	.DW  __REG_VARS*2

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
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 27/11/2017
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 8/000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
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
;#include <i2c.h>
;
;// Alphanumeric LCD functions
;#asm
    .equ __lcd_port = 0x15;PORTC
; 0000 0022 #endasm
;
;#include <lcd.h>
;
;// Declare your global variables here
;
;// Voltage Reference: AVCC pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 002D {

	.CSEG
_read_adc:
; .FSTART _read_adc
; 0000 002E ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0000 002F // Delay needed for the stabilization of the ADC input voltage
; 0000 0030 delay_us(10);
	__DELAY_USB 27
; 0000 0031 // Start the AD conversion
; 0000 0032 ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 0033 // Wait for the AD conversion to complete
; 0000 0034 while ((ADCSRA & (1<<ADIF))==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 0035 ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 0036 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	ADIW R28,1
	RET
; 0000 0037 }
; .FEND
;
;
;
;eeprom int cmp,c,CF,CB;
;#define EEPROM_BUS_ADDRESS 0xc0
;/* read/ a byte from the EEPROM */
;unsigned char compass_read(unsigned char address)
; 0000 003F  {
_compass_read:
; .FSTART _compass_read
; 0000 0040     unsigned char data;
; 0000 0041     delay_us(100);
	ST   -Y,R26
	ST   -Y,R17
;	address -> Y+1
;	data -> R17
	CALL SUBOPT_0x0
; 0000 0042     i2c_start();
	CALL _i2c_start
; 0000 0043     delay_us(100);
	CALL SUBOPT_0x0
; 0000 0044     i2c_write(EEPROM_BUS_ADDRESS);
	LDI  R26,LOW(192)
	CALL SUBOPT_0x1
; 0000 0045     delay_us(100);
; 0000 0046     i2c_write(address);
	LDD  R26,Y+1
	CALL SUBOPT_0x1
; 0000 0047     delay_us(100);
; 0000 0048     i2c_start();
	CALL _i2c_start
; 0000 0049     delay_us(100);
	CALL SUBOPT_0x0
; 0000 004A     i2c_write(EEPROM_BUS_ADDRESS | 1);
	LDI  R26,LOW(193)
	CALL SUBOPT_0x1
; 0000 004B     delay_us(100);
; 0000 004C     data=i2c_read(0);
	LDI  R26,LOW(0)
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
	ADIW R28,2
	RET
; 0000 0051  }
; .FEND
;
;
;int SR,SB,SL,f;
;int v=255;
;int imin;
;int i;
;int min;
;int k,SK;
;char kaf=0;
; void motor(int ml1,int ml2,int mr2,int mr1)
; 0000 005C     {
_motor:
; .FSTART _motor
; 0000 005D     ml1+=cmp;
	ST   -Y,R27
	ST   -Y,R26
;	ml1 -> Y+6
;	ml2 -> Y+4
;	mr2 -> Y+2
;	mr1 -> Y+0
	CALL SUBOPT_0x2
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 005E     ml2+=cmp;
	CALL SUBOPT_0x2
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 005F     mr2+=cmp;
	CALL SUBOPT_0x2
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 0060     mr1+=cmp;
	CALL SUBOPT_0x2
	LD   R26,Y
	LDD  R27,Y+1
	ADD  R30,R26
	ADC  R31,R27
	ST   Y,R30
	STD  Y+1,R31
; 0000 0061     if(ml1>255) ml1=255;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x6
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 0062     if(ml2>255) ml2=255;
_0x6:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x7
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 0063     if(mr2>255) mr2=255;
_0x7:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x8
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 0064     if(mr1>255) mr1=255;
_0x8:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x9
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	ST   Y,R30
	STD  Y+1,R31
; 0000 0065 
; 0000 0066     if(ml1<-255) ml1=-255;
_0x9:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0xA
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 0067     if(ml2<-255) ml2=-255;
_0xA:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0xB
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 0068     if(mr2<-255) mr2=-255;
_0xB:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0xC
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 0069     if(mr1<-255) mr1=-255;
_0xC:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0xD
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	ST   Y,R30
	STD  Y+1,R31
; 0000 006A     //////////////mr1
; 0000 006B     if(mr1>=0)
_0xD:
	LDD  R26,Y+1
	TST  R26
	BRMI _0xE
; 0000 006C         {
; 0000 006D         PORTD.0=0;
	CBI  0x12,0
; 0000 006E         OCR0=mr1;
	LD   R30,Y
	RJMP _0xA4
; 0000 006F         }
; 0000 0070     else
_0xE:
; 0000 0071         {
; 0000 0072         PORTD.0=1;
	SBI  0x12,0
; 0000 0073         OCR0=mr1+255;
	LD   R30,Y
	SUBI R30,-LOW(255)
_0xA4:
	OUT  0x3C,R30
; 0000 0074         }
; 0000 0075     //////////////mr2
; 0000 0076     if(mr2>=0)
	LDD  R26,Y+3
	TST  R26
	BRMI _0x14
; 0000 0077         {
; 0000 0078         PORTD.1=0;
	CBI  0x12,1
; 0000 0079         OCR1B=mr2;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	RJMP _0xA5
; 0000 007A         }
; 0000 007B     else
_0x14:
; 0000 007C         {
; 0000 007D         PORTD.1=1;
	SBI  0x12,1
; 0000 007E         OCR1B=mr2+255;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
_0xA5:
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 007F         }
; 0000 0080     //////////////mL2
; 0000 0081     if(ml2>=0)
	LDD  R26,Y+5
	TST  R26
	BRMI _0x1A
; 0000 0082         {
; 0000 0083         PORTD.2=0;
	CBI  0x12,2
; 0000 0084         OCR1A=ml2;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RJMP _0xA6
; 0000 0085         }
; 0000 0086     else
_0x1A:
; 0000 0087         {
; 0000 0088         PORTD.2=1;
	SBI  0x12,2
; 0000 0089         OCR1A=ml2+255;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
_0xA6:
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 008A         }
; 0000 008B     //////////////ml1
; 0000 008C     if(ml1>=0)
	LDD  R26,Y+7
	TST  R26
	BRMI _0x20
; 0000 008D         {
; 0000 008E         PORTD.3=0;
	CBI  0x12,3
; 0000 008F         OCR2=ml1;
	LDD  R30,Y+6
	RJMP _0xA7
; 0000 0090         }
; 0000 0091     else
_0x20:
; 0000 0092         {
; 0000 0093         PORTD.3=1;
	SBI  0x12,3
; 0000 0094         OCR2=ml1+255;
	LDD  R30,Y+6
	SUBI R30,-LOW(255)
_0xA7:
	OUT  0x23,R30
; 0000 0095         }
; 0000 0096 
; 0000 0097     }
	ADIW R28,8
	RET
; .FEND
;
;
;
;void sensor()
; 0000 009C     {
_sensor:
; .FSTART _sensor
; 0000 009D     min=1023;
	LDI  R30,LOW(1023)
	LDI  R31,HIGH(1023)
	STS  _min,R30
	STS  _min+1,R31
; 0000 009E     for(i=0;i<16;i++)
	LDI  R30,LOW(0)
	STS  _i,R30
	STS  _i+1,R30
_0x27:
	CALL SUBOPT_0x3
	SBIW R26,16
	BRLT PC+2
	RJMP _0x28
; 0000 009F         {
; 0000 00A0         PORTB.7=(i/8)%2;
	CALL SUBOPT_0x3
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL SUBOPT_0x4
	BRNE _0x29
	CBI  0x18,7
	RJMP _0x2A
_0x29:
	SBI  0x18,7
_0x2A:
; 0000 00A1         PORTB.6=(i/4)%2;
	CALL SUBOPT_0x3
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x4
	BRNE _0x2B
	CBI  0x18,6
	RJMP _0x2C
_0x2B:
	SBI  0x18,6
_0x2C:
; 0000 00A2         PORTB.5=(i/2)%2;
	CALL SUBOPT_0x3
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x4
	BRNE _0x2D
	CBI  0x18,5
	RJMP _0x2E
_0x2D:
	SBI  0x18,5
_0x2E:
; 0000 00A3         PORTB.4=(i/1)%2;
	LDS  R30,_i
	LDS  R31,_i+1
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __MANDW12
	CPI  R30,0
	BRNE _0x2F
	CBI  0x18,4
	RJMP _0x30
_0x2F:
	SBI  0x18,4
_0x30:
; 0000 00A4         if(read_adc(0)<min)
	LDI  R26,LOW(0)
	RCALL _read_adc
	MOVW R26,R30
	LDS  R30,_min
	LDS  R31,_min+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x31
; 0000 00A5             {
; 0000 00A6             min=read_adc(0);
	LDI  R26,LOW(0)
	RCALL _read_adc
	STS  _min,R30
	STS  _min+1,R31
; 0000 00A7             imin=i;
	LDS  R30,_i
	LDS  R31,_i+1
	STS  _imin,R30
	STS  _imin+1,R31
; 0000 00A8             }
; 0000 00A9         }
_0x31:
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RJMP _0x27
_0x28:
; 0000 00AA     lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 00AB     lcd_putchar((imin/10)%10+'0');
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
; 0000 00AC     lcd_putchar((imin/1)%10+'0');
	CALL SUBOPT_0x5
	CALL SUBOPT_0x7
; 0000 00AD     lcd_putchar(':');
	LDI  R26,LOW(58)
	CALL _lcd_putchar
; 0000 00AE     lcd_putchar((min/1000)%10+'0');
	CALL SUBOPT_0x8
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL SUBOPT_0x6
; 0000 00AF     lcd_putchar((min/100)%10+'0');
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 00B0     lcd_putchar((min/10)%10+'0');
	CALL SUBOPT_0x8
	CALL SUBOPT_0xA
; 0000 00B1     lcd_putchar((min/1)%10+'0');
	CALL SUBOPT_0x8
	CALL SUBOPT_0xB
; 0000 00B2 
; 0000 00B3 
; 0000 00B4     SB=read_adc(1);
	LDI  R26,LOW(1)
	RCALL _read_adc
	MOVW R6,R30
; 0000 00B5     SR=read_adc(2);
	LDI  R26,LOW(2)
	RCALL _read_adc
	MOVW R4,R30
; 0000 00B6     SL=read_adc(3);
	LDI  R26,LOW(3)
	RCALL _read_adc
	MOVW R8,R30
; 0000 00B7     SK=read_adc(7);
	LDI  R26,LOW(7)
	RCALL _read_adc
	STS  _SK,R30
	STS  _SK+1,R31
; 0000 00B8 
; 0000 00B9     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0xC
; 0000 00BA     lcd_putchar((SL/100)%10+'0');
	MOVW R26,R8
	CALL SUBOPT_0x9
; 0000 00BB     lcd_putchar((SL/10)%10+'0');
	MOVW R26,R8
	CALL SUBOPT_0xA
; 0000 00BC     lcd_putchar((SL/1)%10+'0');
	MOVW R26,R8
	CALL SUBOPT_0xB
; 0000 00BD     lcd_gotoxy(4,1);
	LDI  R30,LOW(4)
	CALL SUBOPT_0xC
; 0000 00BE     lcd_putchar((SB/100)%10+'0');
	MOVW R26,R6
	CALL SUBOPT_0x9
; 0000 00BF     lcd_putchar((SB/10)%10+'0');
	MOVW R26,R6
	CALL SUBOPT_0xA
; 0000 00C0     lcd_putchar((SB/1)%10+'0');
	MOVW R26,R6
	CALL SUBOPT_0xB
; 0000 00C1     lcd_gotoxy(8,1);
	LDI  R30,LOW(8)
	CALL SUBOPT_0xC
; 0000 00C2     lcd_putchar((SR/100)%10+'0');
	MOVW R26,R4
	CALL SUBOPT_0x9
; 0000 00C3     lcd_putchar((SR/10)%10+'0');
	MOVW R26,R4
	CALL SUBOPT_0xA
; 0000 00C4     lcd_putchar((SR/1)%10+'0');
	MOVW R26,R4
	CALL SUBOPT_0xB
; 0000 00C5     lcd_gotoxy(12,1);
	LDI  R30,LOW(12)
	CALL SUBOPT_0xC
; 0000 00C6     lcd_putchar((SK/100)%10+'0');
	CALL SUBOPT_0xD
	CALL SUBOPT_0x9
; 0000 00C7     lcd_putchar((SK/10)%10+'0');
	CALL SUBOPT_0xD
	CALL SUBOPT_0xA
; 0000 00C8     lcd_putchar((SK/1)%10+'0');
	CALL SUBOPT_0xD
	CALL SUBOPT_0xB
; 0000 00C9 
; 0000 00CA 
; 0000 00CB     k=SL-SR;
	MOVW R30,R8
	SUB  R30,R4
	SBC  R31,R5
	STS  _k,R30
	STS  _k+1,R31
; 0000 00CC     cmp=compass_read(1)-c;
	LDI  R26,LOW(1)
	RCALL _compass_read
	MOV  R0,R30
	CLR  R1
	LDI  R26,LOW(_c)
	LDI  R27,HIGH(_c)
	CALL __EEPROMRDW
	MOVW R26,R30
	MOVW R30,R0
	SUB  R30,R26
	SBC  R31,R27
	CALL SUBOPT_0xE
; 0000 00CD     if(cmp>128)  cmp=cmp-255;
	CALL SUBOPT_0x2
	CPI  R30,LOW(0x81)
	LDI  R26,HIGH(0x81)
	CPC  R31,R26
	BRLT _0x32
	CALL SUBOPT_0x2
	SUBI R30,LOW(255)
	SBCI R31,HIGH(255)
	CALL SUBOPT_0xE
; 0000 00CE     if(cmp<-128) cmp=cmp+255;
_0x32:
	CALL SUBOPT_0x2
	CPI  R30,LOW(0xFF80)
	LDI  R26,HIGH(0xFF80)
	CPC  R31,R26
	BRGE _0x33
	CALL SUBOPT_0x2
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	CALL SUBOPT_0xE
; 0000 00CF     lcd_gotoxy(8,0);
_0x33:
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 00D0     if(cmp>=0)
	LDI  R26,LOW(_cmp+1)
	LDI  R27,HIGH(_cmp+1)
	CALL __EEPROMRDB
	TST  R30
	BRMI _0x34
; 0000 00D1         {
; 0000 00D2         lcd_putchar('+');
	LDI  R26,LOW(43)
	CALL _lcd_putchar
; 0000 00D3         lcd_putchar((cmp/100)%10+'0');
	CALL SUBOPT_0x2
	MOVW R26,R30
	CALL SUBOPT_0x9
; 0000 00D4         lcd_putchar((cmp/10)%10+'0');
	CALL SUBOPT_0x2
	MOVW R26,R30
	CALL SUBOPT_0xA
; 0000 00D5         lcd_putchar((cmp/1)%10+'0');
	CALL SUBOPT_0x2
	RJMP _0xA8
; 0000 00D6         }
; 0000 00D7     else
_0x34:
; 0000 00D8         {
; 0000 00D9         lcd_putchar('-');
	LDI  R26,LOW(45)
	CALL _lcd_putchar
; 0000 00DA         lcd_putchar((-cmp/100)%10+'0');
	CALL SUBOPT_0x2
	CALL __ANEGW1
	MOVW R26,R30
	CALL SUBOPT_0x9
; 0000 00DB         lcd_putchar((-cmp/10)%10+'0');
	CALL SUBOPT_0x2
	CALL __ANEGW1
	MOVW R26,R30
	CALL SUBOPT_0xA
; 0000 00DC         lcd_putchar((-cmp/1)%10+'0');
	CALL SUBOPT_0x2
	CALL __ANEGW1
_0xA8:
	MOVW R26,R30
	CALL SUBOPT_0xB
; 0000 00DD         }
; 0000 00DE     cmp*=-1;
	CALL SUBOPT_0x2
	LDI  R26,LOW(65535)
	LDI  R27,HIGH(65535)
	CALL __MULW12
	CALL SUBOPT_0xE
; 0000 00DF     }
	RET
; .FEND
;
;void catch_r()
; 0000 00E2     {
_catch_r:
; .FSTART _catch_r
; 0000 00E3           if (imin==9)    motor(-v,-v,v,v);        //motor(-v,-v/2,v,v/2);
	CALL SUBOPT_0xF
	SBIW R26,9
	BRNE _0x36
	CALL SUBOPT_0x10
	RJMP _0xA9
; 0000 00E4           else if (imin==10)   motor(-v,-v,v,v);        //motor(-v,-v/2,v,v/2);
_0x36:
	CALL SUBOPT_0xF
	SBIW R26,10
	BRNE _0x38
	CALL SUBOPT_0x10
	RJMP _0xA9
; 0000 00E5           else if (imin==11)   motor(-v,-v/2,v,v/2);    //motor(-v,v/2,v,-v/2);
_0x38:
	CALL SUBOPT_0xF
	SBIW R26,11
	BRNE _0x3A
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
	RJMP _0xAA
; 0000 00E6           else if (imin==12)   motor(-v,0,v,0);         //motor(-v,v,v,-v);
_0x3A:
	CALL SUBOPT_0xF
	SBIW R26,12
	BRNE _0x3C
	CALL SUBOPT_0x11
	CALL SUBOPT_0x13
	LDI  R26,LOW(0)
	LDI  R27,0
	RJMP _0xA9
; 0000 00E7           else if (imin==13)   motor(-v,v/2,v,-v/2);    //motor(-v/2,v,v/2,-v);
_0x3C:
	CALL SUBOPT_0xF
	SBIW R26,13
	BRNE _0x3E
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	RJMP _0xAA
; 0000 00E8           else if (imin==14)   motor(-v/2,v,v/2,-v);    // motor(0,v,0,-v);
_0x3E:
	CALL SUBOPT_0xF
	SBIW R26,14
	BRNE _0x40
	CALL SUBOPT_0x14
	CALL SUBOPT_0x12
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R22
	RJMP _0xA9
; 0000 00E9           else if (imin==15)   motor(0,v,0,-v);         // motor(v/2,v,-v/2,-v);
_0x40:
	CALL SUBOPT_0xF
	SBIW R26,15
	BRNE _0x42
	CALL SUBOPT_0x13
	CALL SUBOPT_0x16
	MOVW R30,R12
	CALL __ANEGW1
_0xAA:
	MOVW R26,R30
_0xA9:
	RCALL _motor
; 0000 00EA     }
_0x42:
	RET
; .FEND
;void catch_l()
; 0000 00EC     {
_catch_l:
; .FSTART _catch_l
; 0000 00ED           if (imin==1)    motor(v,0,-v,0);         //motor(v,v/2,-v,-v/2);
	CALL SUBOPT_0xF
	SBIW R26,1
	BRNE _0x43
	ST   -Y,R13
	ST   -Y,R12
	CALL SUBOPT_0x16
	CALL SUBOPT_0x11
	LDI  R26,LOW(0)
	LDI  R27,0
	RJMP _0xAB
; 0000 00EE           else if (imin==2)    motor(v,v/2,-v,-v/2);    //motor(v,0,-v,0);
_0x43:
	CALL SUBOPT_0xF
	SBIW R26,2
	BRNE _0x45
	CALL SUBOPT_0x17
	CALL SUBOPT_0x18
	MOVW R26,R30
	RJMP _0xAB
; 0000 00EF           else if (imin==3)    motor(v/2,-v,v/2,v);     //motor(v,v/2,-v,-v/2);
_0x45:
	CALL SUBOPT_0xF
	SBIW R26,3
	BRNE _0x47
	CALL SUBOPT_0x19
	MOVW R26,R30
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x11
	MOVW R30,R26
	ST   -Y,R31
	ST   -Y,R30
	RJMP _0xAC
; 0000 00F0           else if (imin==4)    motor(0,-v,0,v);         //motor(v,-v,-v,v);
_0x47:
	CALL SUBOPT_0xF
	SBIW R26,4
	BRNE _0x49
	CALL SUBOPT_0x16
	CALL SUBOPT_0x11
	CALL SUBOPT_0x16
	RJMP _0xAC
; 0000 00F1           else if (imin==5)    motor(-v/2,-v/2,v/2,v);  // motor(v/2,-v,v/2,v);
_0x49:
	CALL SUBOPT_0xF
	SBIW R26,5
	BRNE _0x4B
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x19
	ST   -Y,R31
	ST   -Y,R30
	RJMP _0xAC
; 0000 00F2           else if (imin==6)    motor(-v,-v,v,v);        //motor(0,-v,0,v);
_0x4B:
	CALL SUBOPT_0xF
	SBIW R26,6
	BREQ _0xAD
; 0000 00F3           else if (imin==7)    motor(-v,-v,v,v);        // motor(-v/2,-v/2,v/2,v);
	CALL SUBOPT_0xF
	SBIW R26,7
	BRNE _0x4F
_0xAD:
	MOVW R30,R12
	CALL __ANEGW1
	CALL SUBOPT_0x1A
	ST   -Y,R13
	ST   -Y,R12
_0xAC:
	MOVW R26,R12
_0xAB:
	RCALL _motor
; 0000 00F4 
; 0000 00F5     }
_0x4F:
	RET
; .FEND
;
;
;
;void main(void)
; 0000 00FA {
_main:
; .FSTART _main
; 0000 00FB // Declare your local variables here
; 0000 00FC 
; 0000 00FD // Input/Output Ports initialization
; 0000 00FE // Port A initialization
; 0000 00FF // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0100 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0101 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0102 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0103 
; 0000 0104 // Port B initialization
; 0000 0105 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=In Bit1=In Bit0=In
; 0000 0106 DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(248)
	OUT  0x17,R30
; 0000 0107 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=T Bit1=T Bit0=T
; 0000 0108 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0109 
; 0000 010A // Port C initialization
; 0000 010B // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 010C DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 010D // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 010E PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 010F 
; 0000 0110 // Port D initialization
; 0000 0111 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0112 DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0113 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0114 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0115 
; 0000 0116 // Timer/Counter 0 initialization
; 0000 0117 // Clock source: System Clock
; 0000 0118 // Clock value: 125/000 kHz
; 0000 0119 // Mode: Fast PWM top=0xFF
; 0000 011A // OC0 output: Non-Inverted PWM
; 0000 011B // Timer Period: 2/048 ms
; 0000 011C // Output Pulse(s):
; 0000 011D // OC0 Period: 2/048 ms Width: 0 us
; 0000 011E TCCR0=(1<<WGM00) | (1<<COM01) | (0<<COM00) | (1<<WGM01) | (0<<CS02) | (1<<CS01) | (1<<CS00);
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
; 0000 0124 // Clock value: 125/000 kHz
; 0000 0125 // Mode: Fast PWM top=0x00FF
; 0000 0126 // OC1A output: Non-Inverted PWM
; 0000 0127 // OC1B output: Non-Inverted PWM
; 0000 0128 // Noise Canceler: Off
; 0000 0129 // Input Capture on Falling Edge
; 0000 012A // Timer Period: 2/048 ms
; 0000 012B // Output Pulse(s):
; 0000 012C // OC1A Period: 2/048 ms Width: 0 us// OC1B Period: 2/048 ms Width: 0 us
; 0000 012D // Timer1 Overflow Interrupt: Off
; 0000 012E // Input Capture Interrupt: Off
; 0000 012F // Compare A Match Interrupt: Off
; 0000 0130 // Compare B Match Interrupt: Off
; 0000 0131 TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (1<<WGM10);
	LDI  R30,LOW(161)
	OUT  0x2F,R30
; 0000 0132 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (0<<CS12) | (1<<CS11) | (1<<CS10);
	LDI  R30,LOW(11)
	OUT  0x2E,R30
; 0000 0133 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0134 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0135 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0136 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0137 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0138 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0139 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 013A OCR1BL=0x00;
	OUT  0x28,R30
; 0000 013B 
; 0000 013C // Timer/Counter 2 initialization
; 0000 013D // Clock source: System Clock
; 0000 013E // Clock value: 125/000 kHz
; 0000 013F // Mode: Fast PWM top=0xFF
; 0000 0140 // OC2 output: Non-Inverted PWM
; 0000 0141 // Timer Period: 2/048 ms
; 0000 0142 // Output Pulse(s):
; 0000 0143 // OC2 Period: 2/048 ms Width: 0 us
; 0000 0144 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0145 TCCR2=(1<<PWM2) | (1<<COM21) | (0<<COM20) | (1<<CTC2) | (1<<CS22) | (0<<CS21) | (0<<CS20);
	LDI  R30,LOW(108)
	OUT  0x25,R30
; 0000 0146 TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 0147 OCR2=0x00;
	OUT  0x23,R30
; 0000 0148 
; 0000 0149 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 014A TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 014B 
; 0000 014C // External Interrupt(s) initialization
; 0000 014D // INT0: Off
; 0000 014E // INT1: Off
; 0000 014F // INT2: Off
; 0000 0150 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 0151 MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 0152 
; 0000 0153 // USART initialization
; 0000 0154 // USART disabled
; 0000 0155 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 0156 
; 0000 0157 // Analog Comparator initialization
; 0000 0158 // Analog Comparator: Off
; 0000 0159 // The Analog Comparator's positive input is
; 0000 015A // connected to the AIN0 pin
; 0000 015B // The Analog Comparator's negative input is
; 0000 015C // connected to the AIN1 pin
; 0000 015D ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 015E 
; 0000 015F // ADC initialization
; 0000 0160 // ADC Clock frequency: 62/500 kHz
; 0000 0161 // ADC Voltage Reference: AVCC pin
; 0000 0162 // ADC Auto Trigger Source: ADC Stopped
; 0000 0163 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 0164 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 0165 SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0166 
; 0000 0167 // SPI initialization
; 0000 0168 // SPI disabled
; 0000 0169 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 016A 
; 0000 016B // TWI initialization
; 0000 016C // TWI disabled
; 0000 016D TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 016E 
; 0000 016F // Bit-Banged I2C Bus initialization
; 0000 0170 // I2C Port: PORTB
; 0000 0171 // I2C SDA bit: 1
; 0000 0172 // I2C SCL bit: 0
; 0000 0173 // Bit Rate: 100 kHz
; 0000 0174 // Note: I2C settings are specified in the
; 0000 0175 // Project|Configure|C Compiler|Libraries|I2C menu.
; 0000 0176 i2c_init();
	CALL _i2c_init
; 0000 0177 
; 0000 0178 // Alphanumeric LCD initialization
; 0000 0179 // Connections are specified in the
; 0000 017A // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 017B // RS - PORTC Bit 0
; 0000 017C // RD - PORTC Bit 1
; 0000 017D // EN - PORTC Bit 2
; 0000 017E // D4 - PORTC Bit 4
; 0000 017F // D5 - PORTC Bit 5
; 0000 0180 // D6 - PORTC Bit 6
; 0000 0181 // D7 - PORTC Bit 7
; 0000 0182 // Characters/line: 16
; 0000 0183 lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 0184 
; 0000 0185 delay_ms(3000);
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	CALL _delay_ms
; 0000 0186 CB=compass_read(1);
	LDI  R26,LOW(1)
	RCALL _compass_read
	LDI  R26,LOW(_CB)
	LDI  R27,HIGH(_CB)
	LDI  R31,0
	CALL __EEPROMWRW
; 0000 0187 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 0188 while (1)
_0x50:
; 0000 0189       {
; 0000 018A       if(PINC.3==1)      CF=compass_read(1);
	SBIS 0x13,3
	RJMP _0x53
	CALL SUBOPT_0x1B
; 0000 018B 
; 0000 018C       c=CF;
_0x53:
	LDI  R26,LOW(_CF)
	LDI  R27,HIGH(_CF)
	CALL __EEPROMRDW
	LDI  R26,LOW(_c)
	LDI  R27,HIGH(_c)
	CALL __EEPROMWRW
; 0000 018D       sensor();
	CALL SUBOPT_0x1C
; 0000 018E         if(SK>600 && SB<150)
	BRLT _0x55
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	CP   R6,R30
	CPC  R7,R31
	BRLT _0x56
_0x55:
	RJMP _0x54
_0x56:
; 0000 018F             {
; 0000 0190             f=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
; 0000 0191             motor(-v,-v,v,v);
	CALL SUBOPT_0x10
	RCALL _motor
; 0000 0192             delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 0193             }
; 0000 0194           while(f==1 &&(imin<4 || imin>12) && SB < 200)
_0x54:
_0x57:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0x5A
	CALL SUBOPT_0xF
	SBIW R26,4
	BRLT _0x5B
	CALL SUBOPT_0xF
	SBIW R26,13
	BRLT _0x5A
_0x5B:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CP   R6,R30
	CPC  R7,R31
	BRLT _0x5D
_0x5A:
	RJMP _0x59
_0x5D:
; 0000 0195           {
; 0000 0196           if(PINC.3==1)      CF=compass_read(1);
	SBIS 0x13,3
	RJMP _0x5E
	CALL SUBOPT_0x1B
; 0000 0197           sensor();
_0x5E:
	CALL SUBOPT_0x1C
; 0000 0198           if(SK>600 && SB < 200)    motor(-v,-v,v,v);
	BRLT _0x60
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CP   R6,R30
	CPC  R7,R31
	BRLT _0x61
_0x60:
	RJMP _0x5F
_0x61:
	CALL SUBOPT_0x10
	RJMP _0xAE
; 0000 0199           else          motor(0,0,0,0);
_0x5F:
	CALL SUBOPT_0x16
	CALL SUBOPT_0x16
	CALL SUBOPT_0x16
	LDI  R26,LOW(0)
	LDI  R27,0
_0xAE:
	RCALL _motor
; 0000 019A           }
	RJMP _0x57
_0x59:
; 0000 019B           f=0;
	CLR  R10
	CLR  R11
; 0000 019C           while(SB>150 && imin>=4 && imin<=12)
_0x63:
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	CP   R30,R6
	CPC  R31,R7
	BRGE _0x66
	CALL SUBOPT_0xF
	SBIW R26,4
	BRLT _0x66
	CALL SUBOPT_0xF
	SBIW R26,13
	BRLT _0x67
_0x66:
	RJMP _0x65
_0x67:
; 0000 019D           {
; 0000 019E           sensor();
	CALL SUBOPT_0x1D
; 0000 019F           if(SB>250)motor (v,v,-v,-v);
	CP   R30,R6
	CPC  R31,R7
	BRGE _0x68
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x11
	MOVW R30,R12
	CALL __ANEGW1
	MOVW R26,R30
	RJMP _0xAF
; 0000 01A0           else motor(0,0,0,0);
_0x68:
	CALL SUBOPT_0x16
	CALL SUBOPT_0x16
	CALL SUBOPT_0x16
	LDI  R26,LOW(0)
	LDI  R27,0
_0xAF:
	RCALL _motor
; 0000 01A1 
; 0000 01A2           }
	RJMP _0x63
_0x65:
; 0000 01A3           while(SR>150 /*&& imin>=0 && imin <=8*/ )//&& min<800 )
_0x6A:
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	CP   R30,R4
	CPC  R31,R5
	BRGE _0x6C
; 0000 01A4           {
; 0000 01A5           if(PINC.3==1)      CF=compass_read(1);
	SBIS 0x13,3
	RJMP _0x6D
	CALL SUBOPT_0x1B
; 0000 01A6           sensor();
_0x6D:
	CALL SUBOPT_0x1D
; 0000 01A7           if(SR>250)motor(-v,v,v,-v);
	CP   R30,R4
	CPC  R31,R5
	BRGE _0x6E
	CALL SUBOPT_0x11
	CALL SUBOPT_0x1E
	MOVW R26,R30
	RJMP _0xB0
; 0000 01A8           else if(!(imin>=0 && imin <=8))    catch_r();
_0x6E:
	LDS  R26,_imin+1
	TST  R26
	BRMI _0x71
	CALL SUBOPT_0xF
	SBIW R26,9
	BRLT _0x70
_0x71:
	RCALL _catch_r
; 0000 01A9           else motor(0,0,0,0);
	RJMP _0x73
_0x70:
	CALL SUBOPT_0x16
	CALL SUBOPT_0x16
	CALL SUBOPT_0x16
	LDI  R26,LOW(0)
	LDI  R27,0
_0xB0:
	RCALL _motor
; 0000 01AA           }
_0x73:
	RJMP _0x6A
_0x6C:
; 0000 01AB           while(SL>150 && (imin>=8 || imin==0))// && min<800)
_0x74:
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	CP   R30,R8
	CPC  R31,R9
	BRGE _0x77
	CALL SUBOPT_0xF
	SBIW R26,8
	BRGE _0x78
	CALL SUBOPT_0xF
	SBIW R26,0
	BRNE _0x77
_0x78:
	RJMP _0x7A
_0x77:
	RJMP _0x76
_0x7A:
; 0000 01AC           {
; 0000 01AD           if(PINC.3==1)      CF=compass_read(1);
	SBIS 0x13,3
	RJMP _0x7B
	CALL SUBOPT_0x1B
; 0000 01AE           sensor();
_0x7B:
	CALL SUBOPT_0x1D
; 0000 01AF           if(SL>250)motor (v,-v,-v,v);
	CP   R30,R8
	CPC  R31,R9
	BRGE _0x7C
	ST   -Y,R13
	ST   -Y,R12
	CALL SUBOPT_0x11
	CALL SUBOPT_0x11
	MOVW R26,R12
	RJMP _0xB1
; 0000 01B0           else if(imin>=0 && imin <=8)    catch_l();
_0x7C:
	LDS  R26,_imin+1
	TST  R26
	BRMI _0x7F
	CALL SUBOPT_0xF
	SBIW R26,9
	BRLT _0x80
_0x7F:
	RJMP _0x7E
_0x80:
	RCALL _catch_l
; 0000 01B1           else motor(0,0,0,0);
	RJMP _0x81
_0x7E:
	CALL SUBOPT_0x16
	CALL SUBOPT_0x16
	CALL SUBOPT_0x16
	LDI  R26,LOW(0)
	LDI  R27,0
_0xB1:
	RCALL _motor
; 0000 01B2           }
_0x81:
	RJMP _0x74
_0x76:
; 0000 01B3 
; 0000 01B4       if(min<=900)
	CALL SUBOPT_0x8
	CPI  R26,LOW(0x385)
	LDI  R30,HIGH(0x385)
	CPC  R27,R30
	BRLT PC+2
	RJMP _0x82
; 0000 01B5         {
; 0000 01B6 
; 0000 01B7           if(imin==0)          motor(v,v,-v,-v);
	LDS  R30,_imin
	LDS  R31,_imin+1
	SBIW R30,0
	BRNE _0x83
	CALL SUBOPT_0x1E
	MOVW R30,R12
	CALL __ANEGW1
	RJMP _0xB2
; 0000 01B8           else if (imin==1)    motor(v,0,-v,0);         //motor(v,v/2,-v,-v/2);
_0x83:
	CALL SUBOPT_0xF
	SBIW R26,1
	BRNE _0x85
	ST   -Y,R13
	ST   -Y,R12
	CALL SUBOPT_0x16
	CALL SUBOPT_0x11
	LDI  R26,LOW(0)
	LDI  R27,0
	RJMP _0xB3
; 0000 01B9           else if (imin==2)    motor(v,v/2,-v,-v/2);    //motor(v,0,-v,0);
_0x85:
	CALL SUBOPT_0xF
	SBIW R26,2
	BRNE _0x87
	CALL SUBOPT_0x17
	CALL SUBOPT_0x18
	RJMP _0xB4
; 0000 01BA           else if (imin==3)    motor(v/2,-v,v/2,v);     //motor(v,v/2,-v,-v/2);
_0x87:
	CALL SUBOPT_0xF
	SBIW R26,3
	BRNE _0x89
	CALL SUBOPT_0x19
	MOVW R26,R30
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x11
	MOVW R30,R26
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R12
	RJMP _0xB3
; 0000 01BB           else if (imin==4)    motor(0,-v,0,v);         //motor(v,-v,-v,v);
_0x89:
	CALL SUBOPT_0xF
	SBIW R26,4
	BRNE _0x8B
	CALL SUBOPT_0x16
	CALL SUBOPT_0x11
	CALL SUBOPT_0x16
	MOVW R26,R12
	RJMP _0xB3
; 0000 01BC           else if (imin==5)    motor(-v/2,-v/2,v/2,v);  // motor(v/2,-v,v/2,v);
_0x8B:
	CALL SUBOPT_0xF
	SBIW R26,5
	BRNE _0x8D
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x19
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R12
	RJMP _0xB3
; 0000 01BD           else if (imin==6)    motor(-v,-v,v,v);        //motor(0,-v,0,v);
_0x8D:
	CALL SUBOPT_0xF
	SBIW R26,6
	BRNE _0x8F
	CALL SUBOPT_0x10
	RJMP _0xB3
; 0000 01BE           else if (imin==7)    motor(-v,-v/2,v,v/2);    // motor(-v/2,-v/2,v/2,v);
_0x8F:
	CALL SUBOPT_0xF
	SBIW R26,7
	BRNE _0x91
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
	RJMP _0xB4
; 0000 01BF 
; 0000 01C0           else if (imin==8)    motor(0,-v,0,v);         // motor(-v,-v,v,v);
_0x91:
	CALL SUBOPT_0xF
	SBIW R26,8
	BRNE _0x93
	CALL SUBOPT_0x16
	CALL SUBOPT_0x11
	CALL SUBOPT_0x16
	MOVW R26,R12
	RJMP _0xB3
; 0000 01C1 
; 0000 01C2           else if (imin==9)    motor(-v/2,-v/2,v/2,v);  //motor(-v,-v/2,v,v/2);
_0x93:
	CALL SUBOPT_0xF
	SBIW R26,9
	BRNE _0x95
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x19
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R12
	RJMP _0xB3
; 0000 01C3           else if (imin==10)   motor(-v,-v,v,v);        //motor(-v,-v/2,v,v/2);
_0x95:
	CALL SUBOPT_0xF
	SBIW R26,10
	BRNE _0x97
	CALL SUBOPT_0x10
	RJMP _0xB3
; 0000 01C4           else if (imin==11)   motor(-v,-v/2,v,v/2);    //motor(-v,v/2,v,-v/2);
_0x97:
	CALL SUBOPT_0xF
	SBIW R26,11
	BRNE _0x99
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
	RJMP _0xB4
; 0000 01C5           else if (imin==12)   motor(-v,0,v,0);         //motor(-v,v,v,-v);
_0x99:
	CALL SUBOPT_0xF
	SBIW R26,12
	BRNE _0x9B
	CALL SUBOPT_0x11
	CALL SUBOPT_0x13
	LDI  R26,LOW(0)
	LDI  R27,0
	RJMP _0xB3
; 0000 01C6           else if (imin==13)   motor(-v,v/2,v,-v/2);    //motor(-v/2,v,v/2,-v);
_0x9B:
	CALL SUBOPT_0xF
	SBIW R26,13
	BRNE _0x9D
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	RJMP _0xB4
; 0000 01C7           else if (imin==14)   motor(-v/2,v,v/2,-v);    // motor(0,v,0,-v);
_0x9D:
	CALL SUBOPT_0xF
	SBIW R26,14
	BRNE _0x9F
	CALL SUBOPT_0x14
	CALL SUBOPT_0x12
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R22
	RJMP _0xB3
; 0000 01C8           else if (imin==15)   motor(0,v,0,-v);         // motor(v/2,v,-v/2,-v);
_0x9F:
	CALL SUBOPT_0xF
	SBIW R26,15
	BRNE _0xA1
	CALL SUBOPT_0x13
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0xB2:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R12
	CALL __ANEGW1
_0xB4:
	MOVW R26,R30
_0xB3:
	RCALL _motor
; 0000 01C9           }
_0xA1:
; 0000 01CA       else
	RJMP _0xA2
_0x82:
; 0000 01CB         {
; 0000 01CC         motor(0,0,0,0);
	CALL SUBOPT_0x16
	CALL SUBOPT_0x16
	CALL SUBOPT_0x16
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _motor
; 0000 01CD 
; 0000 01CE         }
_0xA2:
; 0000 01CF 
; 0000 01D0       }
	RJMP _0x50
; 0000 01D1 }
_0xA3:
	RJMP _0xA3
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
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x1F
	RCALL __long_delay_G100
	LDI  R26,LOW(32)
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R26,LOW(40)
	RCALL SUBOPT_0x20
	LDI  R26,LOW(4)
	RCALL SUBOPT_0x20
	LDI  R26,LOW(133)
	RCALL SUBOPT_0x20
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

	.ESEG
_cmp:
	.BYTE 0x2
_c:
	.BYTE 0x2
_CF:
	.BYTE 0x2
_CB:
	.BYTE 0x2

	.DSEG
_imin:
	.BYTE 0x2
_i:
	.BYTE 0x2
_min:
	.BYTE 0x2
_k:
	.BYTE 0x2
_SK:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	CALL _i2c_write
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(_cmp)
	LDI  R27,HIGH(_cmp)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDS  R26,_i
	LDS  R27,_i+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4:
	CALL __DIVW21
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __MANDW12
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDS  R26,_imin
	LDS  R27,_imin+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:132 WORDS
SUBOPT_0x6:
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x7:
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	LDS  R26,_min
	LDS  R27,_min+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	LDS  R26,_SK
	LDS  R27,_SK+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	LDI  R26,LOW(_cmp)
	LDI  R27,HIGH(_cmp)
	CALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 37 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0xF:
	LDS  R26,_imin
	LDS  R27,_imin+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x10:
	MOVW R30,R12
	CALL __ANEGW1
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R13
	ST   -Y,R12
	MOVW R26,R12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:48 WORDS
SUBOPT_0x11:
	MOVW R30,R12
	CALL __ANEGW1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x12:
	MOVW R26,R30
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R13
	ST   -Y,R12
	MOVW R26,R12
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R13
	ST   -Y,R12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	MOVW R30,R12
	CALL __ANEGW1
	MOVW R22,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x15:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R12
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R13
	ST   -Y,R12
	MOVW R26,R22
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 24 TIMES, CODE SIZE REDUCTION:43 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x17:
	ST   -Y,R13
	ST   -Y,R12
	MOVW R26,R12
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x18:
	MOVW R30,R12
	CALL __ANEGW1
	MOVW R26,R30
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x19:
	MOVW R26,R12
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1B:
	LDI  R26,LOW(1)
	CALL _compass_read
	LDI  R26,LOW(_CF)
	LDI  R27,HIGH(_CF)
	LDI  R31,0
	CALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1C:
	CALL _sensor
	RCALL SUBOPT_0xD
	CPI  R26,LOW(0x259)
	LDI  R30,HIGH(0x259)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	CALL _sensor
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	ST   -Y,R13
	ST   -Y,R12
	ST   -Y,R13
	ST   -Y,R12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1F:
	CALL __long_delay_G100
	LDI  R26,LOW(48)
	JMP  __lcd_init_write_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
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
