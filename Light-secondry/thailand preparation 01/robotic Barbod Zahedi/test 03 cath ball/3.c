/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 11/17/2017
Author  : 
Company : 
Comments: 


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 1.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega16.h>

#include <delay.h>

// Alphanumeric LCD Module functions
#asm
 .equ __lcd_port=0x15;PORTC
#endasm
#include <lcd.h>

#define ADC_VREF_TYPE 0x40

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
}

// Declare your global variables here
int v=255;
int i,imin,min;
void sensor()
    {
    min=1023;
    for(i=0;i<16;i++)
    {
    PORTB.7=(i/8)%2;
    PORTB.6=(i/4)%2;
    PORTB.5=(i/2)%2;
    PORTB.4=(i/1)%2;
    if(read_adc(0)<min)
    {
     min=read_adc(0);
     imin=i;
    }
    }
    lcd_gotoxy(0,0);
    lcd_putchar((imin/10)%10+'0');
    lcd_putchar((imin)%10+'0');
    lcd_putchar(':');
    lcd_putchar((min/1000)%10+'0');
    lcd_putchar((min/100)%10+'0');
    lcd_putchar((min/10)%10+'0');
    lcd_putchar((min/1)%10+'0');
    }       
void motor(int ml1,int ml2,int mr2,int mr1)
    {
    ///////////////////////ml1
    if(ml1>=0)
        {
        PORTD.3=0;
        OCR2=ml1;
        }
    else
        {
        PORTD.3=1;
        OCR2=ml1+255;
        }
    ///////////////////////ml2
    if(ml2>=0)
        {
        PORTD.2=0;
        OCR1A=ml2;
        }
    else
        {
        PORTD.2=1;
        OCR1A=ml2+255;
        }
    ///////////////////////mr2
    if(mr2>=0)
        {
        PORTD.1=0;
        OCR1B=mr2;
        }
    else
        {
        PORTD.1=1;
        OCR1B=mr2+255;
        }       
    ///////////////////////mr1
    if(mr1>=0)
        {
        PORTD.0=0;
        OCR0=mr1;
        }
    else
        {
        PORTD.0=1;
        OCR0=mr1+255;
        }
    }

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=In Func1=In Func0=In 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0xF8;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTD=0x00;
DDRD=0xFF;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 15.625 kHz
// Mode: Fast PWM top=0xFF
// OC0 output: Non-Inverted PWM
TCCR0=0x6B;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 15.625 kHz
// Mode: Fast PWM top=0x00FF
// OC1A output: Non-Inv.
// OC1B output: Non-Inv.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0xA1;
TCCR1B=0x0B;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: 15.625 kHz
// Mode: Fast PWM top=0xFF
// OC2 output: Non-Inverted PWM
ASSR=0x00;
TCCR2=0x6C;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=0x00;
MCUCSR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// USART initialization
// USART disabled
UCSRB=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 62.500 kHz
// ADC Voltage Reference: AVCC pin
// ADC Auto Trigger Source: ADC Stopped
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x84;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// Alphanumeric LCD initialization
// Connections specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTC Bit 0
// RD - PORTC Bit 1
// EN - PORTC Bit 2
// D4 - PORTC Bit 4
// D5 - PORTC Bit 5
// D6 - PORTC Bit 6
// D7 - PORTC Bit 7
// Characters/line: 16
lcd_init(16);

while (1)
      {
      sensor();
       if(min<=700)
       {
        if(imin==0)        motor(v,v/2,-v,-v/2);//motor(v,v,-v,-v);
        else if(imin==1)   motor(v,0,-v,0);//motor(v,v/2,-v,-v/2);
        else if(imin==2)   motor(v,-v/2,-v,v/2);//motor(v,0,-v,0);
        else if(imin==3)   motor(v,-v,-v,v);//motor(v,-v/2,-v,v/2);
        else if(imin==4)   motor(v/2,-v,-v/2,v);//motor(v,-v,-v,v);
        else if(imin==5)   motor(0,-v,0,v);//motor(v/2,-v,-v/2,v);
        else if(imin==6)   motor(-v/2,-v,v/2,v);//motor(0,-v,0,v);
        else if(imin==7)   motor(-v,-v,v,v);//motor(-v/2,-v,v/2,v);
        else if(imin==8)   motor(-v/2,-v,v/2,v);//motor(-v,-v,v,v);
        else if(imin==9)   motor(-v,-v,v,v);//motor(-v,-v/2,v,v/2);
        else if(imin==10)  motor(-v,-v/2,v,v/2);//motor(-v,0,v,0);
        elce if(imin==11)  motor(-v,0,v,0);//motor(-v,v/2,v,-v/2);
        else if(imin==12)  motor(-v,v/2,v,-v/2);//motor(-v,v,v,-v);
        else if(imin==13)  motor(-v,v,v,-v);//motor(-v/2,v,v/2,-v);
        else if(imin==14)  motor(-v/2,v,v/2,-v);//motor(0,v,0,-v); 
        else if(imin==15)  motor(0,v,0,-v);//motor(v/2,v,-v/2,-v);
       }  
     else motor(0,0,0,0);
     } 
} 
