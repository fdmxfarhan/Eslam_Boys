/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 2/16/2018
Author  : 
Company : 
Comments: 


Chip type               : ATmega16A
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <mega16a.h>

#include <delay.h>

// I2C Bus functions
#include <i2c.h>

// Alphanumeric LCD functions
#include <alcd.h>

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
int cmp,c;
#define EEPROM_BUS_ADDRESS 0xc0  
/* read/ a byte from the EEPROM */
unsigned char compass_read(unsigned char address) 
 {
    unsigned char data;
    delay_us(100);
    i2c_start();
    delay_us(100);
    i2c_write(EEPROM_BUS_ADDRESS);
    delay_us(100);
    i2c_write(address);
    delay_us(100);
    i2c_start();
    delay_us(100);
    i2c_write(EEPROM_BUS_ADDRESS | 1);
    delay_us(100);
    data=i2c_read(0);
    delay_us(100);
    i2c_stop();
    delay_us(100);
    return data;
 }
int i,adc[16],adc_min,l,b,r,k,ph[3];
void sensor()
{

    //sensor ir
    
    for(i=0 ; i<16 ; i++){
    PORTB.7=(i/8)%2;   
    PORTB.6=(i/4)%2;
    PORTB.5=(i/2)%2;
    PORTB.4=i%2;
    adc[i]=read_adc(0);
    if(adc[i]<adc[adc_min])
        adc_min=i;
    }             
    lcd_gotoxy(0,0);
    lcd_putchar((adc_min/10)%10+'0');  
    lcd_putchar((adc_min/1)%10+'0');  
    lcd_putchar(':');
    lcd_putchar((adc[adc_min]/1000)%10+'0');  
    lcd_putchar((adc[adc_min]/100)%10+'0');
    lcd_putchar((adc[adc_min]/10)%10+'0');
    lcd_putchar((adc[adc_min]/1)%10+'0');   
    
    //sensor fasele
    
    b=read_adc(1);
    r=read_adc(2);
    l=read_adc(3); 
    lcd_gotoxy(0,1);  
    
    // * left
    lcd_putchar('L');
    lcd_putchar((l/100)%10+'0');  
    lcd_putchar((l/10)%10+'0');
    lcd_putchar((l/1)%10+'0');
    lcd_gotoxy(6,1);
    
    // * back
    lcd_putchar('B');
    lcd_putchar((b/100)%10+'0');  
    lcd_putchar((b/10)%10+'0');
    lcd_putchar((b/1)%10+'0');
    lcd_gotoxy(12,1);
    
    // * right
    lcd_putchar('R');
    lcd_putchar((r/100)%10+'0');  
    lcd_putchar((r/10)%10+'0');
    lcd_putchar((r/1)%10+'0');    
    
    k=l-r;
    
    // ghotbnama
           
    cmp=compass_read(1)-c;
    if(cmp>128) cmp=cmp-255; 
    if(cmp<-128) cmp=cmp+255;
    lcd_gotoxy(8,0);
    if(cmp>=0)
    {
    lcd_putchar('+');
    lcd_putchar((cmp/100)%10+'0');
    lcd_putchar((cmp/10)%10+'0');
    lcd_putchar((cmp/1)%10+'0');
    } 
    else
    {
    lcd_putchar('-');
    lcd_putchar((-cmp/100)%10+'0');
    lcd_putchar((-cmp/10)%10+'0');
    lcd_putchar((-cmp/1)%10+'0');
    }                     
    
    // photosel
          
    ph[0]=read_adc(4); //in front of
    ph[1]=read_adc(6); //left
    ph[2]=read_adc(5); //right   
    if(ph[0]>700){
    lcd_gotoxy(12,0);
    lcd_putchar('P');
    lcd_putchar((ph[0]/100)%10+'0');  
    lcd_putchar((ph[0]/10)%10+'0');
    lcd_putchar((ph[0]/1)%10+'0'); 
    }     
    if(ph[1]>700){
    lcd_gotoxy(12,0);
    lcd_putchar('P');
    lcd_putchar((ph[1]/100)%10+'0');  
    lcd_putchar((ph[1]/10)%10+'0');
    lcd_putchar((ph[1]/1)%10+'0');
    }
    if(ph[2]>700){
    lcd_gotoxy(12,0);
    lcd_putchar('P');
    lcd_putchar((ph[2]/100)%10+'0');  
    lcd_putchar((ph[2]/10)%10+'0');
    lcd_putchar((ph[2]/1)%10+'0');   
    }     
}

void motor(int ML1,int ML2,int MR2,int MR1)
{   
    cmp=-cmp; 
    
    // ghotbnama ba motor
     
    ML1+=(cmp*2);
    ML2+=(cmp*2);
    MR2+=(cmp*2);
    MR1+=(cmp*2);
                 
    if(ML1>255) ML1=255; 
    if(ML2>255) ML2=255;
    if(MR2>255) MR2=255;
    if(MR1>255) MR1=255; 
    
    if(ML1<-255) ML1=-255; 
    if(ML2<-255) ML2=-255;
    if(MR2<-255) MR2=-255;
    if(MR1<-255) MR1=-255;
    
    //motor
    
    // * motor left 1
    if(ML1>=0)
    {
    PORTD.3=0;
    OCR2=ML1;
    }
    else
    {
    PORTD.3=1;
    OCR2=ML1+255;
    }  
    
    // * motor left 2
    if(ML2>=0)
    {
    PORTD.2=0;
    OCR1A=ML2;
    }
    else
    {
    PORTD.2=1;
    OCR1A=ML2+255;
    }
    
    // * motor right 2
    if(MR2>=0)
    {
    PORTD.1=0;
    OCR1B=MR2;
    }
    else
    {
    PORTD.1=1;
    OCR1B=MR2+255;
    }   
    
    // * motor right 1
    if(MR1>=0)
    {
    PORTD.0=0;
    OCR0=MR1;
    }
    else
    {
    PORTD.0=1;
    OCR0=MR1+255;
    }
}

void catch(){
    if(adc[adc_min]<800){
     if(adc_min==0)         motor(255,255,-255,-255);
     else if(adc_min==1)    motor(255,-100,-255,100);//motor(255,128,-255,-128);
     else if(adc_min==2)    motor(255,-255,-255,255);//motor(255,0,-255,0);
     else if(adc_min==3)    motor(100,-255,-100,255);//motor(255,-128,-255,128);
     else if(adc_min==4)    motor(0,-255,0,255);//motor(255,-255,-255,255);
     else if(adc_min==5)    motor(-100,-255,100,255);//motor(128,-255,-128,255);
     else if(adc_min==6)    motor(-255,-255,255,255);//motor(0,-255,0,255);    
     else if(adc_min==7)    motor(-255,-100,255,100);//motor(-128,-255,128,255); 
       
     else if(adc_min==8)    motor(-255,0,255,0);//motor(-255,-255,255,255);   
       
     else if(adc_min==9)    motor(-100,-255,100,255);//motor(-255,-128,255,128);
     else if(adc_min==10)   motor(-255,-255,255,255); //motor(-255,0,255,0);
     else if(adc_min==11)   motor(-255,-100,255,100);//motor(-255,128,255,-128);
     else if(adc_min==12)   motor(-255,0,255,0);//motor(-255,255,255,-255); 
     else if(adc_min==13)   motor(-255,100,255,-100);//motor(-128,255,128,-255);
     else if(adc_min==14)   motor(-255,255,255,-255);//motor(0,255,0,-255);
     else if(adc_min==15)   motor(-100,255,100,-255);//motor(128,255,-128,-255);
     }
    else 
    {
       k*=2;
        if(b<200) motor(-255+k,-255-k,255-k,255+k);
        else motor(0,0,0,0);
    }
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
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (1<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=0 Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 125.000 kHz
// Mode: Fast PWM top=0xFF
// OC0 output: Non-Inverted PWM
// Timer Period: 2.048 ms
// Output Pulse(s):
// OC0 Period: 2.048 ms Width: 0 us
TCCR0=(1<<WGM00) | (1<<COM01) | (0<<COM00) | (1<<WGM01) | (0<<CS02) | (1<<CS01) | (1<<CS00);
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 125.000 kHz
// Mode: Fast PWM top=0x00FF
// OC1A output: Non-Inverted PWM
// OC1B output: Non-Inverted PWM
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 2.048 ms
// Output Pulse(s):
// OC1A Period: 2.048 ms Width: 0 us// OC1B Period: 2.048 ms Width: 0 us
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
// Clock value: 125.000 kHz
// Mode: Fast PWM top=0xFF
// OC2 output: Non-Inverted PWM
// Timer Period: 2.048 ms
// Output Pulse(s):
// OC2 Period: 2.048 ms Width: 0 us
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
// ADC Clock frequency: 1000.000 kHz
// ADC Voltage Reference: AVCC pin
// ADC Auto Trigger Source: ADC Stopped
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Bit-Banged I2C Bus initialization
// I2C Port: PORTB
// I2C SDA bit: 1
// I2C SCL bit: 0
// Bit Rate: 100 kHz
// Note: I2C settings are specified in the
// Project|Configure|C Compiler|Libraries|I2C menu.
i2c_init();

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
      // Place your code here   
      
      sensor();
      if(ph[0]>700){
      if(adc_min>=4 && adc_min<=12) catch();
      else    motor(0,0,0,0);
      }      
      else if(ph[1]>700){
      if(adc_min>7 && adc_min<=15 && adc_min==0) catch();
      else    motor(0,0,0,0);
      }
      else if(ph[2]>700){
      if(adc_min<9) catch();
      else    motor(0,0,0,0);
      }
      else if(b>300) 
        {
        if(b>450)  motor(150,150,-150,-150);
        else if(!(adc_min>=4 && adc_min<13)) catch();
        else    motor(0,0,0,0);
        }
      else if(r>300) 
        {
        if(r>450)  motor(-150,150,150,-150);
        else if(adc_min>7 && adc_min<=15 && adc_min==0) catch();
        else    motor(0,0,0,0);
        }
      else if(l>300) 
        {
        if(l>450)  motor(150,-150,-150,150);
        else if(adc_min<9) catch();
        else    motor(0,0,0,0);
        }          
      else catch(); 
      }
}
