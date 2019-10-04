
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16A
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

	#pragma AVRPART ADMIN PART_NAME ATmega16A
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
	.DEF _address=R4
	.DEF _address_msb=R5
	.DEF _cnt0=R6
	.DEF _cnt0_msb=R7
	.DEF _x=R8
	.DEF _x_msb=R9
	.DEF _y=R10
	.DEF _y_msb=R11
	.DEF _width=R12
	.DEF _width_msb=R13

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

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x54,0x0,0x0,0x0

_0x6:
	.DB  0xFF
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  0x04
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
;Date    : 03/09/2017
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega16A
;Program type            : Application
;AVR Core Clock frequency: 8/000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <mega16a.h>
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
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;
;// Declare your global variables here
;
;// Standard Input/Output functions
;#include <stdio.h>
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
	JMP  _0x2080001
; 0000 0037 }
; .FEND
;
;#define I2C_7BIT_DEVICE_ADDRESS 0x54
;#define EEPROM_BUS_ADDRESS (I2C_7BIT_DEVICE_ADDRESS << 1)
;
;unsigned int address=0x54;
;unsigned char read()
; 0000 003E {
_read:
; .FSTART _read
; 0000 003F unsigned char data;
; 0000 0040 i2c_start();
	ST   -Y,R17
;	data -> R17
	CALL _i2c_start
; 0000 0041 i2c_write(EEPROM_BUS_ADDRESS | 0);
	LDI  R26,LOW(168)
	CALL _i2c_write
; 0000 0042 i2c_write(address >> 8);
	MOV  R26,R5
	CALL _i2c_write
; 0000 0043 i2c_write((unsigned char) address);
	MOV  R26,R4
	CALL _i2c_write
; 0000 0044 i2c_start();
	CALL _i2c_start
; 0000 0045 i2c_write(EEPROM_BUS_ADDRESS | 1);
	LDI  R26,LOW(169)
	CALL SUBOPT_0x0
; 0000 0046 data=i2c_read(0);
; 0000 0047 i2c_stop();
; 0000 0048 return data;
	LD   R17,Y+
	RET
; 0000 0049 }
; .FEND
;
;int cnt0=0,x,y,width,height,checksum,signature, sharpback, sharpright, sharpleft,k,cnt1=0,cnt2=0;
;int v=255;

	.DSEG
;unsigned char a;
;
;int cmp,c;
;#define EEPROM_BUS_ADDRESS 0xc0
;/* read/ a byte from the EEPROM */
;unsigned char compass_read(unsigned char address)
; 0000 0053     {

	.CSEG
_compass_read:
; .FSTART _compass_read
; 0000 0054     unsigned char data;
; 0000 0055     i2c_start();
	ST   -Y,R26
	ST   -Y,R17
;	address -> Y+1
;	data -> R17
	CALL _i2c_start
; 0000 0056     i2c_write(EEPROM_BUS_ADDRESS);
	LDI  R26,LOW(192)
	CALL _i2c_write
; 0000 0057     i2c_write(address);
	LDD  R26,Y+1
	CALL _i2c_write
; 0000 0058     i2c_start();
	CALL _i2c_start
; 0000 0059     i2c_write(EEPROM_BUS_ADDRESS | 1);
	LDI  R26,LOW(193)
	CALL SUBOPT_0x0
; 0000 005A     data=i2c_read(0);
; 0000 005B     i2c_stop();
; 0000 005C     return data;
	LDD  R17,Y+0
	RJMP _0x2080002
; 0000 005D     }
; .FEND
;
;
;
;
;
;void read_cmp()
; 0000 0064     {
_read_cmp:
; .FSTART _read_cmp
; 0000 0065     cmp=compass_read(1)-c;
	CALL SUBOPT_0x1
	LDS  R26,_c
	LDS  R27,_c+1
	SUB  R30,R26
	SBC  R31,R27
	CALL SUBOPT_0x2
; 0000 0066     if(cmp<0)    cmp=cmp;
	LDS  R26,_cmp+1
	TST  R26
	BRPL _0x7
	CALL SUBOPT_0x3
	CALL SUBOPT_0x2
; 0000 0067     if(cmp>128)  cmp=cmp-255;
_0x7:
	CALL SUBOPT_0x4
	CPI  R26,LOW(0x81)
	LDI  R30,HIGH(0x81)
	CPC  R27,R30
	BRLT _0x8
	CALL SUBOPT_0x3
	SUBI R30,LOW(255)
	SBCI R31,HIGH(255)
	CALL SUBOPT_0x2
; 0000 0068     if(cmp<-128) cmp=cmp+255;
_0x8:
	CALL SUBOPT_0x4
	CPI  R26,LOW(0xFF80)
	LDI  R30,HIGH(0xFF80)
	CPC  R27,R30
	BRGE _0x9
	CALL SUBOPT_0x3
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	CALL SUBOPT_0x2
; 0000 0069     if(cmp>=0){
_0x9:
	LDS  R26,_cmp+1
	TST  R26
	BRMI _0xA
; 0000 006A         lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x5
; 0000 006B         lcd_putchar('+');
	LDI  R26,LOW(43)
	CALL SUBOPT_0x6
; 0000 006C         lcd_putchar((cmp/100)%10+'0');
	CALL SUBOPT_0x7
	CALL SUBOPT_0x6
; 0000 006D         lcd_putchar((cmp/10)%10+'0');
	CALL SUBOPT_0x8
	CALL SUBOPT_0x6
; 0000 006E         lcd_putchar((cmp/1)%10+'0');
	RJMP _0x38
; 0000 006F         }
; 0000 0070     else if(cmp<0){
_0xA:
	LDS  R26,_cmp+1
	TST  R26
	BRPL _0xC
; 0000 0071         lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x5
; 0000 0072         lcd_putchar('-');
	LDI  R26,LOW(45)
	CALL SUBOPT_0x9
; 0000 0073         lcd_putchar((-cmp/100)%10+'0');
	CALL SUBOPT_0x7
	CALL SUBOPT_0x9
; 0000 0074         lcd_putchar((-cmp/10)%10+'0');
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 0075         lcd_putchar((-cmp/1)%10+'0');
_0x38:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0xA
; 0000 0076         }
; 0000 0077     cmp*=-2;
_0xC:
	CALL SUBOPT_0x3
	LDI  R26,LOW(65534)
	LDI  R27,HIGH(65534)
	CALL __MULW12
	CALL SUBOPT_0x2
; 0000 0078 
; 0000 0079 
; 0000 007A     sharpback=read_adc(7);
	LDI  R26,LOW(7)
	RCALL _read_adc
	STS  _sharpback,R30
	STS  _sharpback+1,R31
; 0000 007B     lcd_gotoxy(5,1);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x5
; 0000 007C     lcd_putchar((sharpback/100)%10+'0');
	CALL SUBOPT_0xB
	CALL SUBOPT_0x7
	RCALL _lcd_putchar
; 0000 007D     lcd_putchar((sharpback/10)%10+'0');
	CALL SUBOPT_0xB
	CALL SUBOPT_0x8
	RCALL _lcd_putchar
; 0000 007E     lcd_putchar((sharpback/1)%10+'0');
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC
; 0000 007F 
; 0000 0080     sharpleft=read_adc(6);
	LDI  R26,LOW(6)
	RCALL _read_adc
	STS  _sharpleft,R30
	STS  _sharpleft+1,R31
; 0000 0081     lcd_gotoxy(9,1);
	LDI  R30,LOW(9)
	CALL SUBOPT_0x5
; 0000 0082     lcd_putchar((sharpleft/100)%10+'0');
	CALL SUBOPT_0xD
	CALL SUBOPT_0x7
	RCALL _lcd_putchar
; 0000 0083     lcd_putchar((sharpleft/10)%10+'0');
	CALL SUBOPT_0xD
	CALL SUBOPT_0x8
	RCALL _lcd_putchar
; 0000 0084     lcd_putchar((sharpleft/1)%10+'0');
	CALL SUBOPT_0xD
	CALL SUBOPT_0xC
; 0000 0085 
; 0000 0086     sharpright=read_adc(5);
	LDI  R26,LOW(5)
	RCALL _read_adc
	STS  _sharpright,R30
	STS  _sharpright+1,R31
; 0000 0087     lcd_gotoxy(13,1);
	LDI  R30,LOW(13)
	CALL SUBOPT_0x5
; 0000 0088     lcd_putchar((sharpright/100)%10+'0');
	CALL SUBOPT_0xE
	CALL SUBOPT_0x7
	RCALL _lcd_putchar
; 0000 0089     lcd_putchar((sharpright/10)%10+'0');
	CALL SUBOPT_0xE
	CALL SUBOPT_0x8
	RCALL _lcd_putchar
; 0000 008A     lcd_putchar((sharpright/1)%10+'0');
	CALL SUBOPT_0xE
	CALL SUBOPT_0xC
; 0000 008B 
; 0000 008C     k=sharpleft-sharpright;
	CALL SUBOPT_0xE
	LDS  R30,_sharpleft
	LDS  R31,_sharpleft+1
	SUB  R30,R26
	SBC  R31,R27
	STS  _k,R30
	STS  _k+1,R31
; 0000 008D     if(k<60 && k>-60)   k=0;
	LDS  R26,_k
	LDS  R27,_k+1
	SBIW R26,60
	BRGE _0xE
	LDS  R26,_k
	LDS  R27,_k+1
	LDI  R30,LOW(65476)
	LDI  R31,HIGH(65476)
	CP   R30,R26
	CPC  R31,R27
	BRLT _0xF
_0xE:
	RJMP _0xD
_0xF:
	LDI  R30,LOW(0)
	STS  _k,R30
	STS  _k+1,R30
; 0000 008E //    lcd_gotoxy(11,0);
; 0000 008F //    lcd_putchar((k/100)%10+'0');
; 0000 0090 //    lcd_putchar((k/10)%10+'0');
; 0000 0091 //    lcd_putchar((k/1)%10+'0');
; 0000 0092     }
_0xD:
	RET
; .FEND
;
;void motor(int ML1,int ML2,int MR2,int MR1)
; 0000 0095     {
; 0000 0096     if(MR1>255)   MR1=255;
;	ML1 -> Y+6
;	ML2 -> Y+4
;	MR2 -> Y+2
;	MR1 -> Y+0
; 0000 0097     if(MR1<-255)  MR1=-255;
; 0000 0098     if(MR2>255)   MR2=255;
; 0000 0099     if(MR2<-255)  MR2=-255;
; 0000 009A     if(ML2>255)   ML2=255;
; 0000 009B     if(ML2<-255)  ML2=-255;
; 0000 009C     if(ML1>255)   ML1=255;
; 0000 009D     if(ML1<-255)  ML1=-255;
; 0000 009E 
; 0000 009F     ///////////////////////////////////////////////////////////////////////MR1
; 0000 00A0 
; 0000 00A1     if (MR1>0)
; 0000 00A2     {
; 0000 00A3     PORTD.6=0;
; 0000 00A4     OCR0=MR1;
; 0000 00A5     }
; 0000 00A6     else if(MR1<=0)
; 0000 00A7     {
; 0000 00A8     PORTD.6=1;
; 0000 00A9     OCR0=255+MR1;
; 0000 00AA     }
; 0000 00AB     /////////////////////////////////////////////////////////////////////////MR2
; 0000 00AC     if (MR2>0)
; 0000 00AD     {
; 0000 00AE     PORTD.1=0;
; 0000 00AF     OCR1B=MR2;
; 0000 00B0     }
; 0000 00B1     else if(MR2<=0)
; 0000 00B2     {
; 0000 00B3     PORTD.1=1;
; 0000 00B4     OCR1B=255+MR2;
; 0000 00B5     }
; 0000 00B6     ////////////////////////////////////////////////////////////////////////ML2
; 0000 00B7     if (ML2>0)
; 0000 00B8     {
; 0000 00B9     PORTD.2=0;
; 0000 00BA     OCR1A=ML2;
; 0000 00BB     }
; 0000 00BC     else if(ML2<=0)
; 0000 00BD     {
; 0000 00BE     PORTD.2=1;
; 0000 00BF     OCR1A=255+ML2;
; 0000 00C0     }
; 0000 00C1     ///////////////////////////////////////////////////////////////////////ML1
; 0000 00C2     if(ML1>0)
; 0000 00C3     {
; 0000 00C4     PORTD.3=0;
; 0000 00C5     OCR2=ML1;
; 0000 00C6     }
; 0000 00C7     else if(ML1<=0)
; 0000 00C8     {
; 0000 00C9     PORTD.3=1;
; 0000 00CA     OCR2=255+ML1;
; 0000 00CB     }
; 0000 00CC     }
;
;
;
;void main(void)
; 0000 00D1 {
_main:
; .FSTART _main
; 0000 00D2 // Declare your local variables here
; 0000 00D3 
; 0000 00D4 // Input/Output Ports initialization
; 0000 00D5 // Port A initialization
; 0000 00D6 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00D7 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 00D8 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00D9 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 00DA 
; 0000 00DB // Port B initialization
; 0000 00DC // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 00DD DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 00DE // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 00DF PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00E0 
; 0000 00E1 // Port C initialization
; 0000 00E2 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=In Bit1=In Bit0=In
; 0000 00E3 DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (1<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(8)
	OUT  0x14,R30
; 0000 00E4 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=0 Bit2=T Bit1=T Bit0=T
; 0000 00E5 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 00E6 
; 0000 00E7 // Port D initialization
; 0000 00E8 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 00E9 DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 00EA // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 00EB PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 00EC 
; 0000 00ED // Timer/Counter 0 initialization
; 0000 00EE // Clock source: System Clock
; 0000 00EF // Clock value: 125/000 kHz
; 0000 00F0 // Mode: Fast PWM top=0xFF
; 0000 00F1 // OC0 output: Non-Inverted PWM
; 0000 00F2 // Timer Period: 2/048 ms
; 0000 00F3 // Output Pulse(s):
; 0000 00F4 // OC0 Period: 2/048 ms Width: 0 us
; 0000 00F5 TCCR0=(1<<WGM00) | (1<<COM01) | (0<<COM00) | (1<<WGM01) | (0<<CS02) | (1<<CS01) | (1<<CS00);
	LDI  R30,LOW(107)
	OUT  0x33,R30
; 0000 00F6 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 00F7 OCR0=0x00;
	OUT  0x3C,R30
; 0000 00F8 
; 0000 00F9 // Timer/Counter 1 initialization
; 0000 00FA // Clock source: System Clock
; 0000 00FB // Clock value: 125/000 kHz
; 0000 00FC // Mode: Fast PWM top=0x00FF
; 0000 00FD // OC1A output: Non-Inverted PWM
; 0000 00FE // OC1B output: Non-Inverted PWM
; 0000 00FF // Noise Canceler: Off
; 0000 0100 // Input Capture on Falling Edge
; 0000 0101 // Timer Period: 2/048 ms
; 0000 0102 // Output Pulse(s):
; 0000 0103 // OC1A Period: 2/048 ms Width: 0 us// OC1B Period: 2/048 ms Width: 0 us
; 0000 0104 // Timer1 Overflow Interrupt: Off
; 0000 0105 // Input Capture Interrupt: Off
; 0000 0106 // Compare A Match Interrupt: Off
; 0000 0107 // Compare B Match Interrupt: Off
; 0000 0108 TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (1<<WGM10);
	LDI  R30,LOW(161)
	OUT  0x2F,R30
; 0000 0109 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (0<<CS12) | (1<<CS11) | (1<<CS10);
	LDI  R30,LOW(11)
	OUT  0x2E,R30
; 0000 010A TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 010B TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 010C ICR1H=0x00;
	OUT  0x27,R30
; 0000 010D ICR1L=0x00;
	OUT  0x26,R30
; 0000 010E OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 010F OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0110 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0111 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0112 
; 0000 0113 // Timer/Counter 2 initialization
; 0000 0114 // Clock source: System Clock
; 0000 0115 // Clock value: 125/000 kHz
; 0000 0116 // Mode: Fast PWM top=0xFF
; 0000 0117 // OC2 output: Non-Inverted PWM
; 0000 0118 // Timer Period: 2/048 ms
; 0000 0119 // Output Pulse(s):
; 0000 011A // OC2 Period: 2/048 ms Width: 0 us
; 0000 011B ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 011C TCCR2=(1<<PWM2) | (1<<COM21) | (0<<COM20) | (1<<CTC2) | (1<<CS22) | (0<<CS21) | (0<<CS20);
	LDI  R30,LOW(108)
	OUT  0x25,R30
; 0000 011D TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 011E OCR2=0x00;
	OUT  0x23,R30
; 0000 011F 
; 0000 0120 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0121 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 0122 
; 0000 0123 // External Interrupt(s) initialization
; 0000 0124 // INT0: Off
; 0000 0125 // INT1: Off
; 0000 0126 // INT2: Off
; 0000 0127 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 0128 MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 0129 
; 0000 012A // USART initialization
; 0000 012B // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 012C // USART Receiver: On
; 0000 012D // USART Transmitter: Off
; 0000 012E // USART Mode: Asynchronous
; 0000 012F // USART Baud Rate: 9600
; 0000 0130 UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	OUT  0xB,R30
; 0000 0131 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(16)
	OUT  0xA,R30
; 0000 0132 UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0133 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0134 UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 0135 
; 0000 0136 // Analog Comparator initialization
; 0000 0137 // Analog Comparator: Off
; 0000 0138 // The Analog Comparator's positive input is
; 0000 0139 // connected to the AIN0 pin
; 0000 013A // The Analog Comparator's negative input is
; 0000 013B // connected to the AIN1 pin
; 0000 013C ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 013D 
; 0000 013E // ADC initialization
; 0000 013F // ADC Clock frequency: 125/000 kHz
; 0000 0140 // ADC Voltage Reference: AVCC pin
; 0000 0141 // ADC Auto Trigger Source: ADC Stopped
; 0000 0142 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 0143 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (0<<ADPS0);
	LDI  R30,LOW(134)
	OUT  0x6,R30
; 0000 0144 SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0145 
; 0000 0146 // SPI initialization
; 0000 0147 // SPI disabled
; 0000 0148 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 0149 
; 0000 014A // TWI initialization
; 0000 014B // TWI disabled
; 0000 014C TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 014D 
; 0000 014E // Bit-Banged I2C Bus initialization
; 0000 014F // I2C Port: PORTB
; 0000 0150 // I2C SDA bit: 1
; 0000 0151 // I2C SCL bit: 0
; 0000 0152 // Bit Rate: 100 kHz
; 0000 0153 // Note: I2C settings are specified in the
; 0000 0154 // Project|Configure|C Compiler|Libraries|I2C menu.
; 0000 0155 i2c_init();
	CALL _i2c_init
; 0000 0156 
; 0000 0157 // Alphanumeric LCD initialization
; 0000 0158 // Connections are specified in the
; 0000 0159 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 015A // RS - PORTC Bit 0
; 0000 015B // RD - PORTC Bit 1
; 0000 015C // EN - PORTC Bit 2
; 0000 015D // D4 - PORTC Bit 4
; 0000 015E // D5 - PORTC Bit 5
; 0000 015F // D6 - PORTC Bit 6
; 0000 0160 // D7 - PORTC Bit 7
; 0000 0161 // Characters/line: 16
; 0000 0162 lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0163 
; 0000 0164 c=compass_read(1);
	CALL SUBOPT_0x1
	STS  _c,R30
	STS  _c+1,R31
; 0000 0165 delay_ms(3000);
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	CALL _delay_ms
; 0000 0166 c=compass_read(1);
	CALL SUBOPT_0x1
	STS  _c,R30
	STS  _c+1,R31
; 0000 0167 cnt1=0;
	LDI  R30,LOW(0)
	STS  _cnt1,R30
	STS  _cnt1+1,R30
; 0000 0168 cmp=0;
	STS  _cmp,R30
	STS  _cmp+1,R30
; 0000 0169 
; 0000 016A while (1)
_0x34:
; 0000 016B       {
; 0000 016C       // Place `your code here
; 0000 016D       read_cmp();
	RCALL _read_cmp
; 0000 016E       a=read();
	RCALL _read
	STS  _a,R30
; 0000 016F       lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0000 0170       lcd_putchar((a/100)%10+'0');
	LDS  R26,_a
	LDI  R27,0
	CALL SUBOPT_0x7
	RCALL _lcd_putchar
; 0000 0171       lcd_putchar((a/10)%10+'0');
	LDS  R26,_a
	LDI  R27,0
	CALL SUBOPT_0x8
	RCALL _lcd_putchar
; 0000 0172       lcd_putchar((a/1)%10+'0');
	LDS  R26,_a
	LDI  R27,0
	CALL SUBOPT_0xC
; 0000 0173 
; 0000 0174 
; 0000 0175       }}/*read_cmp();
; 0000 0176       a=read();
; 0000 0177       if(a==0xaa)
; 0000 0178         {
; 0000 0179         a=read();
; 0000 017A         if(a==0x55){
; 0000 017B         read();
; 0000 017C         checksum = read();
; 0000 017D         checksum += read() * 255;
; 0000 017E         signature = read();
; 0000 017F         signature += read() * 255;
; 0000 0180         x = read();
; 0000 0181         x+=read()*255;
; 0000 0182         y = read();
; 0000 0183         y += read() * 255;
; 0000 0184         width = read();
; 0000 0185         width += read() * 255;
; 0000 0186         height = read();
; 0000 0187         height += read() * 255;
; 0000 0188         cnt0=0;
; 0000 0189         }}
; 0000 018A       lcd_gotoxy(0,0);
; 0000 018B       lcd_putchar(signature%10+'0');
; 0000 018C 
; 0000 018D       lcd_gotoxy(2,0);
; 0000 018E       lcd_putchar((x/100)%10+'0');
; 0000 018F       lcd_putchar((x/10)%10+'0');
; 0000 0190       lcd_putchar((x/1)%10+'0');
; 0000 0191 
; 0000 0192       lcd_gotoxy(6,0);
; 0000 0193       lcd_putchar((y/100)%10+'0');
; 0000 0194       lcd_putchar((y/10)%10+'0');
; 0000 0195       lcd_putchar((y/1)%10+'0');
; 0000 0196 
; 0000 0197       if(a!=0)
; 0000 0198         {
; 0000 0199         cnt2=0;
; 0000 019A         while(sharpright>300 && cnt2<100)
; 0000 019B             {
; 0000 019C             cnt2++;
; 0000 019D             read_cmp();
; 0000 019E             a=read();
; 0000 019F             if(a==0xaa)
; 0000 01A0                 {
; 0000 01A1                 a=read();
; 0000 01A2                 if(a==0x55){
; 0000 01A3                 read();
; 0000 01A4                 checksum = read();
; 0000 01A5                 checksum += read() * 255;
; 0000 01A6                 signature = read();
; 0000 01A7                 signature += read() * 255;
; 0000 01A8                 x = read();
; 0000 01A9                 x+=read()*255;
; 0000 01AA                 y = read();
; 0000 01AB                 y += read() * 255;
; 0000 01AC                 width = read();
; 0000 01AD                 width += read() * 255;
; 0000 01AE                 height = read();
; 0000 01AF                 height += read() * 255;
; 0000 01B0                 cnt0=0;
; 0000 01B1                 }}
; 0000 01B2             lcd_gotoxy(0,0);
; 0000 01B3             lcd_putchar(signature%10+'0');
; 0000 01B4 
; 0000 01B5             lcd_gotoxy(2,0);
; 0000 01B6             lcd_putchar((x/100)%10+'0');
; 0000 01B7             lcd_putchar((x/10)%10+'0');
; 0000 01B8             lcd_putchar((x/1)%10+'0');
; 0000 01B9 
; 0000 01BA             lcd_gotoxy(6,0);
; 0000 01BB             lcd_putchar((y/100)%10+'0');
; 0000 01BC             lcd_putchar((y/10)%10+'0');
; 0000 01BD             lcd_putchar((y/1)%10+'0');
; 0000 01BE             if(sharpright>400)                      motor(-v/2 + cmp,v/2 + cmp,v/2 + cmp,-v/2 + cmp);
; 0000 01BF             else if(a!=0)
; 0000 01C0                 {
; 0000 01C1                 if(x > 0 && x <= 60)                motor(0 + cmp,v + cmp,0 + cmp,-v + cmp);//motor(-v + cmp,v + cmp,v + ...
; 0000 01C2                 else if(x > 60 && x <= 120)         motor(0 + cmp,v + cmp,0 + cmp,-v + cmp);
; 0000 01C3                 else if(x > 120 && x <= 180)        motor(v + cmp,v + cmp,-v + cmp,-v + cmp);
; 0000 01C4                 else motor(0,0,0,0);
; 0000 01C5                 }
; 0000 01C6             else motor(0,0,0,0);
; 0000 01C7             }
; 0000 01C8 
; 0000 01C9         cnt2=0;
; 0000 01CA         while(sharpleft>300 && cnt2<100)
; 0000 01CB             {
; 0000 01CC             cnt2++;
; 0000 01CD             read_cmp();
; 0000 01CE             a=read();
; 0000 01CF             if(a==0xaa)
; 0000 01D0                 {
; 0000 01D1                 a=read();
; 0000 01D2                 if(a==0x55){
; 0000 01D3                 read();
; 0000 01D4                 checksum = read();
; 0000 01D5                 checksum += read() * 255;
; 0000 01D6                 signature = read();
; 0000 01D7                 signature += read() * 255;
; 0000 01D8                 x = read();
; 0000 01D9                 x+=read()*255;
; 0000 01DA                 y = read();
; 0000 01DB                 y += read() * 255;
; 0000 01DC                 width = read();
; 0000 01DD                 width += read() * 255;
; 0000 01DE                 height = read();
; 0000 01DF                 height += read() * 255;
; 0000 01E0                 cnt0=0;
; 0000 01E1                 }}
; 0000 01E2             lcd_gotoxy(0,0);
; 0000 01E3             lcd_putchar(signature%10+'0');
; 0000 01E4 
; 0000 01E5             lcd_gotoxy(2,0);
; 0000 01E6             lcd_putchar((x/100)%10+'0');
; 0000 01E7             lcd_putchar((x/10)%10+'0');
; 0000 01E8             lcd_putchar((x/1)%10+'0');
; 0000 01E9 
; 0000 01EA             lcd_gotoxy(6,0);
; 0000 01EB             lcd_putchar((y/100)%10+'0');
; 0000 01EC             lcd_putchar((y/10)%10+'0');
; 0000 01ED             lcd_putchar((y/1)%10+'0');
; 0000 01EE             if(sharpleft>400)                      motor(v/2 + cmp,-v/2 + cmp,-v/2 + cmp,v/2 + cmp);
; 0000 01EF             else if(a!=0)
; 0000 01F0                 {
; 0000 01F1                 if(x > 120 && x <= 180)             motor(v + cmp,v + cmp,-v + cmp,-v + cmp);
; 0000 01F2                 else if(x > 180 && x <= 240)        motor(v + cmp,0 + cmp,-v + cmp,0 + cmp);
; 0000 01F3                 else if(x > 240)                    motor(v + cmp,0 + cmp,-v + cmp,0 + cmp);
; 0000 01F4                 else motor(0,0,0,0);
; 0000 01F5                 }
; 0000 01F6             else motor(0,0,0,0);
; 0000 01F7             }
; 0000 01F8 
; 0000 01F9         if(x > 0 && x <= 60)                motor(0 + cmp,v + cmp,0 + cmp,-v + cmp);//motor(-v + cmp,v + cmp,v + cmp,-v  ...
; 0000 01FA         else if(x > 60 && x <= 120)         motor(0 + cmp,v + cmp,0 + cmp,-v + cmp);
; 0000 01FB         else if(x > 120 && x <= 180)        motor(v + cmp,v + cmp,-v + cmp,-v + cmp);
; 0000 01FC         else if(x > 180 && x <= 240)        motor(v + cmp,0 + cmp,-v + cmp,0 + cmp);
; 0000 01FD         else if(x > 240)                    motor(v + cmp,0 + cmp,-v + cmp,0 + cmp);//motor(v + cmp,-v + cmp,-v + cmp,v  ...
; 0000 01FE         else                                motor(0 + cmp,0 + cmp,0 + cmp,0 + cmp);
; 0000 01FF         }
; 0000 0200       else  //     motor(cmp,cmp,cmp,cmp);
; 0000 0201         {
; 0000 0202         //read_cmp();
; 0000 0203         //k*=2;
; 0000 0204         if (sharpback < 300)  motor(k-128 + cmp,-k-128 + cmp,-k+128 + cmp,k+128 + cmp);
; 0000 0205         else                  motor(k+cmp, -k+cmp, -k+cmp, k+cmp);
; 0000 0206         }
; 0000 0207 
; 0000 0208       }
; 0000 0209 }
	RJMP _0x34
_0x37:
	RJMP _0x37
; .FEND
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

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x15,R30
	__DELAY_USB 13
	SBI  0x15,2
	__DELAY_USB 13
	CBI  0x15,2
	__DELAY_USB 13
	RJMP _0x2080001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x2080001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x2080002:
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0xF
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0xF
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2080001
_0x2000004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x15,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x15,0
	RJMP _0x2080001
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x14
	ORI  R30,LOW(0xF0)
	OUT  0x14,R30
	SBI  0x14,2
	SBI  0x14,0
	SBI  0x14,1
	CBI  0x15,2
	CBI  0x15,0
	CBI  0x15,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x10
	CALL SUBOPT_0x10
	CALL SUBOPT_0x10
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2080001:
	ADIW R28,1
	RET
; .FEND
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

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_sharpback:
	.BYTE 0x2
_sharpright:
	.BYTE 0x2
_sharpleft:
	.BYTE 0x2
_k:
	.BYTE 0x2
_cnt1:
	.BYTE 0x2
_a:
	.BYTE 0x1
_cmp:
	.BYTE 0x2
_c:
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
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	CALL _i2c_write
	LDI  R26,LOW(0)
	CALL _i2c_read
	MOV  R17,R30
	CALL _i2c_stop
	MOV  R30,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(1)
	CALL _compass_read
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	STS  _cmp,R30
	STS  _cmp+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3:
	LDS  R30,_cmp
	LDS  R31,_cmp+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	LDS  R26,_cmp
	LDS  R27,_cmp+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	CALL _lcd_putchar
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x9:
	CALL _lcd_putchar
	RCALL SUBOPT_0x3
	CALL __ANEGW1
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xA:
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LDS  R26,_sharpback
	LDS  R27,_sharpback+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LDS  R26,_sharpleft
	LDS  R27,_sharpleft+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	LDS  R26,_sharpright
	LDS  R27,_sharpright+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x10:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET


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
