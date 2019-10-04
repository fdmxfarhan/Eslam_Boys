/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 17/11/2017
Author  : 
Company : 
Comments: 


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 1/000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <mega16.h>

#include <delay.h>

// Alphanumeric LCD functions
#asm
    .equ __lcd_port = 0x15;PORTC
#endasm

#include <lcd.h>

// Declare your global variables here

// Voltage Reference: AVCC pin
#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | ADC_VREF_TYPE;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=(1<<ADSC);
// Wait for the AD conversion to complete
while ((ADCSRA & (1<<ADIF))==0);
ADCSRA|=(1<<ADIF);
return ADCW;
}


 void motor(int ml1,int ml2,int mr2,int mr1)
    {
    //////////////mr1
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
    //////////////mr2
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
    //////////////mL2
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
    //////////////ml1
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
    
    }
int sh; 
int v=255;      
int imin;
int i;
int min;

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
    lcd_putchar((imin/1)%10+'0');
    lcd_putchar(':');
    lcd_putchar((min/1000)%10+'0');
    lcd_putchar((min/100)%10+'0'); 
    lcd_putchar((min/10)%10+'0');
    lcd_putchar((min/1)%10+'0');
    }
void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=In Bit1=In Bit0=In 
DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 15/625 kHz
// Mode: Fast PWM top=0xFF
// OC0 output: Non-Inverted PWM
// Timer Period: 16/384 ms
// Output Pulse(s):
// OC0 Period: 16/384 ms Width: 0 us
TCCR0=(1<<WGM00) | (1<<COM01) | (0<<COM00) | (1<<WGM01) | (0<<CS02) | (1<<CS01) | (1<<CS00);
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 15/625 kHz
// Mode: Fast PWM top=0x00FF
// OC1A output: Non-Inverted PWM
// OC1B output: Non-Inverted PWM
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer xPeriod: 16/384 ms
// Output Pulse(s):
// OC1A Period: 16/384 ms Width: 0 us// OC1B Period: 16/384 ms Width: 0 us
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (1<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (0<<CS12) | (1<<CS11) | (1<<CS10);
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
// Clock value: 15/625 kHz
// Mode: Fast PWM top=0xFF
// OC2 output: Non-Inverted PWM
// Timer Period: 16/384 ms
// Output Pulse(s):
// OC2 Period: 16/384 ms Width: 0 us
ASSR=0<<AS2;
TCCR2=(1<<PWM2) | (1<<COM21) | (0<<COM20) | (1<<CTC2) | (1<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);

// USART initialization
// USART disabled
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);

// ADC initialization
// ADC Clock frequency: 62/500 kHz
// ADC Voltage Reference: AVCC pin
// ADC Auto Trigger Source: ADC Stopped
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Alphanumeric LCD initialization
// Connections are specified in the
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

      if(min<=800) 
          {  
          while (SR>250 && imin>0 && imin<=8 && min<800)
          {
          sensor();
          if(SR>400  motor(-v,v,v,-v);  
          else motor(0,0,0,0);
          }
          
          if(imin==0)          motor(v,v,-v,-v); 
          else if (imin==1     motor(v,-v/2,-v,v/2);    //motor(v,v/2,-v,-v/2);
          else if (imin==2)    motor(v,-v,-v,v);        //motor(v,0,-v,0);
          else if (imin==3)    motor(v/2,-v,v/2,v);     //motor(v,v/2,-v,-v/2);
          else if (imin==4)    motor(0,-v,0,v);         //motor(v,-v,-v,v);
          else if (imin==5)    motor(-v/2,-v/2,v/2,v);  // motor(v/2,-v,v/2,v);
          else if (imin==6)    motor(-v,-v,v,v);        //motor(0,-v,0,v);
          else if (imin==7)    motor(-v,-v/2,v,v/2);    // motor(-v/2,-v/2,v/2,v);
          
          else if (imin==8)   motor(0,-v,0,v);          // motor(-v,-v,v,v);
          
          else if (imin==9)    motor(-v/2,-v/2,v/2,v);  //motor(-v,-v/2,v,v/2);
          else if (imin==10)   motor(-v,-v,v,v);        //motor(-v,-v/2,v,v/2);   
          else if (imin==11)   motor(-v,-v/2,v,v/2);    //motor(-v,v/2,v,-v/2);
          else if (imin==12)   motor(-v,0,v,0);         //motor(-v,v,v,-v); 
          else if (imin==13)   motor(-v,v/2,v,-v/2);    //motor(-v/2,v,v/2,-v);
          else if (imin==14)   motor(-v,v,v,-v);        // motor(0,v,0,-v);
          else if (imin==15)   motor(-v/2,v,v/2,-v);    // motor(v/2,v,-v/2,-v);
          }
      else  motor(0,0,0,0);
      
      }
}
