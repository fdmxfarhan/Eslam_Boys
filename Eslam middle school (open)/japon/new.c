/*****************************************************
This program was produced by the
CodeWizardAVR V2.04.4a Advanced
Automatic Program Generator
� Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 06/03/2017
Author  : NeVaDa
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

// I2C Bus functions
#asm
   .equ __i2c_port=0x18 ;PORTB
   .equ __sda_bit=0
   .equ __scl_bit=1
#endasm
#include <i2c.h>

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x15 ;PORTC
#endasm
#include <lcd.h>

#define ADC_VREF_TYPE 0x40

///////////////////////////cmp
eeprom int c;
int cmp;

#define
 EEPROM_BUS_ADDRESS 0xc0
unsigned char compass_read(unsigned char address) {
unsigned char data;
i2c_start();
i2c_write(EEPROM_BUS_ADDRESS);
i2c_write(address);
i2c_start();
i2c_write(EEPROM_BUS_ADDRESS |1);
data=i2c_read(0);
i2c_stop();
return data;
}
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

 int B,L,R; 
 int e,s;
 int kr,kl,kb,kf; 
 int f;
//////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////sensor read
 int adc[16],adc_min;
 int i=0;
void read_sensor()
{
   #asm ("wdr");


for(i=0;i<16;i++)
{
 

PORTB.4=(i/1)%2;
PORTB.5=(i/2)%2;
PORTB.6=(i/4)%2;
PORTB.7=(i/8)%2;


adc[i]=read_adc(0);

if(adc[adc_min]>adc[i])
adc_min=i;

}




   #asm ("wdr");

lcd_gotoxy(0,0);
lcd_putchar((adc_min/10)%10+'0');
lcd_putchar((adc_min/1)%10+'0');
lcd_putchar(':');

   #asm ("wdr");

lcd_putchar((adc[adc_min]/1000)%10+'0');
lcd_putchar((adc[adc_min]/100)%10+'0');
lcd_putchar((adc[adc_min]/10)%10+'0');
lcd_putchar((adc[adc_min]/1)%10+'0');
   #asm ("wdr");

B=read_adc(7);
lcd_gotoxy(3,1);
lcd_putchar((B/100)%10+'0');
lcd_putchar((B/10)%10+'0');
  #asm ("wdr");

L=read_adc(6);
lcd_gotoxy(0,1);
lcd_putchar((L/100)%10+'0');
lcd_putchar((L/10)%10+'0');
  #asm ("wdr");

R=read_adc(5);
lcd_gotoxy(6,1);
lcd_putchar((R/100)%10+'0');
lcd_putchar((R/10)%10+'0');


     #asm ("wdr");
////////////////////////////////front 
   #asm ("wdr");
kb=read_adc(4);
lcd_gotoxy(9,1);
lcd_putchar((kf/100)%10+'0');
lcd_putchar((kf/10)%10+'0');
 #asm ("wdr");
 ////////////////////////////////////left
     #asm ("wdr");
kl=read_adc(3);
lcd_gotoxy(12,1);
lcd_putchar((kl/100)%10+'0');
lcd_putchar((kl/10)%10+'0');

     #asm ("wdr");
     
 /////////////////////////////////////right    
          #asm ("wdr");
kr=read_adc(2);
lcd_gotoxy(14,0);
lcd_putchar((kr/100)%10+'0');
lcd_putchar((kr/10)%10+'0');

     #asm ("wdr");
     
     
     
 ////////////////////////////////////back    
          #asm ("wdr");
kf=read_adc(1);
lcd_gotoxy(11,0);
lcd_putchar((kb/100)%10+'0');
lcd_putchar((kb/10)%10+'0');

     #asm ("wdr");



 
 }

void motor(int ML1,int ML2,int MR2,int MR1)
{ #asm ("wdr");
if(MR1>255)   MR1=255;
if(MR1<-255)  MR1=-255;
if(MR2>255)   MR2=255;
if(MR2<-255)  MR2=-255;
if(ML2>255)   ML2=255;
if(ML2<-255)  ML2=-255;
if(ML1>255)   ML1=255;
if(ML1<-255)  ML1=-255;

  #asm ("wdr");
 
///////////////////////////////////////////////////////////////////////MR1

if (MR1>0)
{#asm ("wdr");
PORTD.0=0;
OCR0=MR1;
#asm ("wdr");}
else if(MR1<=0)
{  #asm ("wdr");
PORTD.0=1;
OCR0=255+MR1;
#asm ("wdr");
}
/////////////////////////////////////////////////////////////////////////MR2
if (MR2>0)
{   #asm ("wdr");
PORTD.1=0;
OCR1B=MR2;
#asm ("wdr");
}
else if(MR2<=0)
{ #asm ("wdr");
PORTD.1=1;
OCR1B=255+MR2;
#asm ("wdr");
}
////////////////////////////////////////////////////////////////////////ML2
if (ML2>0)
{ #asm ("wdr");
PORTD.2=0;
OCR1A=ML2;
#asm ("wdr");
}
else if(ML2<=0)
{     #asm ("wdr");
PORTD.2=1;
OCR1A=255+ML2;
#asm ("wdr");
}
///////////////////////////////////////////////////////////////////////ML1
if(ML1>0)
{#asm ("wdr");
PORTD.3=0;
OCR2=ML1;
#asm ("wdr");
}
else if(ML1<=0)
{  #asm ("wdr");
PORTD.3=1;
OCR2=255+ML1;
#asm ("wdr");
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
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=In Func0=In 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=T State0=T 
PORTB=0x00;
DDRB=0xFC;

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
// Mode: Fast PWM top=FFh
// OC0 output: Non-Inverted PWM
TCCR0=0x6B;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 15.625 kHz
// Mode: Fast PWM top=00FFh
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
// Mode: Fast PWM top=FFh
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

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 125.000 kHz
// ADC Voltage Reference: AVCC pin
// ADC Auto Trigger Source: None
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x83;

// I2C Bus initialization
i2c_init();

// LCD module initialization
lcd_init(16);

// Watchdog Timer initialization
// Watchdog Timer Prescaler: OSC/256k
#pragma optsize-
WDTCR=0x1C;
WDTCR=0x0C;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif
if(PINC.3==1)
{       #asm ("wdr");

 c=compass_read(1);    
 delay_ms(1000);
    
    
    #asm ("wdr");
 }
while (1)
      { 
                s=L+R; 

      
      
        #asm ("wdr");
     cmp=compass_read(1)-c; 
       if(cmp<0)    cmp=cmp+255;
       if(cmp>128)  cmp=cmp-255;
       if(cmp<128)  cmp=cmp;
          #asm ("wdr");
        if(cmp>=0)
        {#asm ("wdr");
        lcd_gotoxy(8,0);
//        lcd_putchar((cmp/100)%10+'0');
        lcd_putchar((cmp/10)%10+'0');
        lcd_putchar((cmp/1)%10+'0');
         #asm ("wdr");
        }
       
       
       
       
       
        else
        { 
        #asm ("wdr");
        lcd_gotoxy(8,0);
//        lcd_putchar((-cmp/100)%10+'0');
        lcd_putchar((-cmp/10)%10+'0');
        lcd_putchar((-cmp/1)%10+'0');
         #asm ("wdr");
        }                 
       if(cmp>-30 && cmp<30)
       cmp=-cmp*2;
       else  cmp=-cmp*1; 
                        
                #asm ("wdr");

             read_sensor();
        e=(R-L); 
        
                   #asm ("wdr");

        
         /////////////////////////////////////out kaf
        if((kr>600)&&(adc[adc_min]<600))
          f=1;  
         else  if((kb>600)&&(adc[adc_min]<600))
          f=1; 
          else if((kf>650)&&(adc[adc_min]<600))
          f=1; 
           else if((kl>570)&&(adc[adc_min]<600))
          f=1; 
     
          else f=0;
                  #asm ("wdr");   
                  
                  
           if (f==1)
          {
           if(B<200)                motor(-255-e+cmp,-255+e+cmp,255+e+cmp,255-e+cmp);// 8
           else          motor(255-e+cmp,255+e+cmp,-255+e+cmp,-255-e+cmp);//0
          }
          else 
          {
      if(adc[adc_min]<700 && f==0)
        {
    
       #asm ("wdr"); 

       if(adc_min==0)             motor(255+cmp,255+cmp,-255+cmp,-255+cmp); 
       
       else if(adc_min==1)                          motor(255+cmp,128+cmp,-255+cmp,-128+cmp);///3  
       else if(adc_min==2)                          motor(255+cmp,-255+cmp,-255+cmp,255+cmp);///4
       else if(adc_min==3)                          motor(128+cmp,-255+cmp,-128+cmp,255+cmp);///5
       else if(adc_min==4)                          motor(0+cmp,-255+cmp,0+cmp,255+cmp);///6
       else if(adc_min==5)                          motor(-128+cmp,-255+cmp,128+cmp,255+cmp);///7 
       else if(adc_min==6)                          motor(-255+cmp,-255+cmp,255+cmp,255+cmp);///8
       else if(adc_min==7)                          motor(-255+cmp,-128+cmp,255+cmp,128+cmp);///9 
        
       
       
        else if(adc_min==8)                       motor(-255+cmp,0+cmp,255+cmp,0+cmp);///10 

       
        else if(adc_min==9)                         motor(-128+cmp,-255+cmp,128+cmp,255+cmp);///7
       else if(adc_min==10)                         motor(-255+cmp,-255+cmp,255+cmp,255+cmp);///8
       else if(adc_min==11)                         motor(-255+cmp,-128+cmp,255+cmp,128+cmp);////9
       else if(adc_min==12)                         motor(-255+cmp,0+cmp,255+cmp,0+cmp);///10
       else if(adc_min==13)                         motor(-255+cmp,128+cmp,255+cmp,-128+cmp);///11
       else if(adc_min==14)                         motor(-255+cmp,255+cmp,255+cmp,-255+cmp);///12
       else if(adc_min==15)                         motor(128+cmp,255+cmp,-128+cmp,-255+cmp);///13         motor(128,255,-128,-255);
       #asm ("wdr");
        }   
        
        
          else 
        {  
        #asm ("wdr");
        if(B<150)                motor(-255-e+cmp,-255+e+cmp,255+e+cmp,255-e+cmp);// 8
        else if(B>350)          motor(255-e+cmp,255+e+cmp,-255+e+cmp,-255-e+cmp);//0
//       else if(L>200)          motor(255+cmp,-255+cmp,-255+cmp,255+cmp);///4
//       else if(R>250)           motor(-255+cmp,255+cmp,255+cmp,-255+cmp);///12
        else                     motor(0+cmp,0+cmp,0+cmp,0+cmp);
         #asm ("wdr");
                   
        }         

      }
    }
}
