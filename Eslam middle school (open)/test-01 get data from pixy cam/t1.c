/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 03/09/2017
Author  : 
Company : 
Comments: 


Chip type               : ATmega16A
Program type            : Application
AVR Core Clock frequency: 8/000000 MHz
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

// Standard Input/Output functions
#include <stdio.h>

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

#define I2C_7BIT_DEVICE_ADDRESS 0x54
#define EEPROM_BUS_ADDRESS (I2C_7BIT_DEVICE_ADDRESS << 1)

unsigned int address=0x54;
unsigned char read() 
{
unsigned char data;
i2c_start();
i2c_write(EEPROM_BUS_ADDRESS | 0);
i2c_write(address >> 8);
i2c_write((unsigned char) address);
i2c_start();
i2c_write(EEPROM_BUS_ADDRESS | 1);
data=i2c_read(0);
i2c_stop();
return data;
}

int cnt0=0,x,y,width,height,checksum,signature, sharpback, sharpright, sharpleft,k,cnt1=0,cnt2=0;
int v=255;
unsigned char a;

int cmp,c;
#define EEPROM_BUS_ADDRESS 0xc0  
/* read/ a byte from the EEPROM */
unsigned char compass_read(unsigned char address) 
    {
    unsigned char data;
    i2c_start();
    i2c_write(EEPROM_BUS_ADDRESS);
    i2c_write(address);
    i2c_start();
    i2c_write(EEPROM_BUS_ADDRESS | 1);
    data=i2c_read(0);
    i2c_stop();
    return data;
    }





void read_cmp()
    {
    cmp=compass_read(1)-c;     
    if(cmp<0)    cmp=cmp;
    if(cmp>128)  cmp=cmp-255;    
    if(cmp<-128) cmp=cmp+255;                                        
    if(cmp>=0){ 
        lcd_gotoxy(0,1);
        lcd_putchar('+');
        lcd_putchar((cmp/100)%10+'0');
        lcd_putchar((cmp/10)%10+'0');
        lcd_putchar((cmp/1)%10+'0');
        }
    else if(cmp<0){        
        lcd_gotoxy(0,1);
        lcd_putchar('-');
        lcd_putchar((-cmp/100)%10+'0');
        lcd_putchar((-cmp/10)%10+'0');
        lcd_putchar((-cmp/1)%10+'0');
        } 
    cmp*=-2;    
    
    
    sharpback=read_adc(7);
    lcd_gotoxy(5,1);
    lcd_putchar((sharpback/100)%10+'0');
    lcd_putchar((sharpback/10)%10+'0');
    lcd_putchar((sharpback/1)%10+'0');          
    
    sharpleft=read_adc(6);
    lcd_gotoxy(9,1);
    lcd_putchar((sharpleft/100)%10+'0');
    lcd_putchar((sharpleft/10)%10+'0');
    lcd_putchar((sharpleft/1)%10+'0');          
    
    sharpright=read_adc(5);
    lcd_gotoxy(13,1);
    lcd_putchar((sharpright/100)%10+'0');
    lcd_putchar((sharpright/10)%10+'0');
    lcd_putchar((sharpright/1)%10+'0');          
    
    k=sharpleft-sharpright;               
    if(k<60 && k>-60)   k=0;
//    lcd_gotoxy(11,0);
//    lcd_putchar((k/100)%10+'0');
//    lcd_putchar((k/10)%10+'0');
//    lcd_putchar((k/1)%10+'0');             
    }
    
void motor(int ML1,int ML2,int MR2,int MR1)
    {
    if(MR1>255)   MR1=255;
    if(MR1<-255)  MR1=-255;
    if(MR2>255)   MR2=255;
    if(MR2<-255)  MR2=-255;
    if(ML2>255)   ML2=255;
    if(ML2<-255)  ML2=-255;
    if(ML1>255)   ML1=255;
    if(ML1<-255)  ML1=-255;
     
    ///////////////////////////////////////////////////////////////////////MR1

    if (MR1>0)
    {
    PORTD.6=0;
    OCR0=MR1;
    }
    else if(MR1<=0)
    {
    PORTD.6=1;
    OCR0=255+MR1;
    }
    /////////////////////////////////////////////////////////////////////////MR2
    if (MR2>0)
    {
    PORTD.1=0;
    OCR1B=MR2;
    }
    else if(MR2<=0)
    {
    PORTD.1=1;
    OCR1B=255+MR2;
    }
    ////////////////////////////////////////////////////////////////////////ML2
    if (ML2>0)
    {
    PORTD.2=0;
    OCR1A=ML2;
    }
    else if(ML2<=0)
    {
    PORTD.2=1;
    OCR1A=255+ML2;
    }
    ///////////////////////////////////////////////////////////////////////ML1
    if(ML1>0)
    {
    PORTD.3=0;
    OCR2=ML1;
    }
    else if(ML1<=0)
    {
    PORTD.3=1;
    OCR2=255+ML1;
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
// Clock value: 125/000 kHz
// Mode: Fast PWM top=0xFF
// OC0 output: Non-Inverted PWM
// Timer Period: 2/048 ms
// Output Pulse(s):
// OC0 Period: 2/048 ms Width: 0 us
TCCR0=(1<<WGM00) | (1<<COM01) | (0<<COM00) | (1<<WGM01) | (0<<CS02) | (1<<CS01) | (1<<CS00);
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 125/000 kHz
// Mode: Fast PWM top=0x00FF
// OC1A output: Non-Inverted PWM
// OC1B output: Non-Inverted PWM
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 2/048 ms
// Output Pulse(s):
// OC1A Period: 2/048 ms Width: 0 us// OC1B Period: 2/048 ms Width: 0 us
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
// Clock value: 125/000 kHz
// Mode: Fast PWM top=0xFF
// OC2 output: Non-Inverted PWM
// Timer Period: 2/048 ms
// Output Pulse(s):
// OC2 Period: 2/048 ms Width: 0 us
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
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: Off
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x33;

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);

// ADC initialization
// ADC Clock frequency: 125/000 kHz
// ADC Voltage Reference: AVCC pin
// ADC Auto Trigger Source: ADC Stopped
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (0<<ADPS0);
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

c=compass_read(1);                  
delay_ms(3000);
c=compass_read(1);
cnt1=0;
cmp=0;
    
while (1)
      {
      // Place `your code here    
      read_cmp();
      a=read();
      lcd_gotoxy(0,0);
      lcd_putchar((a/100)%10+'0');
      lcd_putchar((a/10)%10+'0');
      lcd_putchar((a/1)%10+'0');
      
      
      }}/*read_cmp();
      a=read();
      if(a==0xaa)
        {       
        a=read();
        if(a==0x55){
        read(); 
        checksum = read();
        checksum += read() * 255;
        signature = read(); 
        signature += read() * 255;
        x = read();
        x+=read()*255;
        y = read();
        y += read() * 255;
        width = read();
        width += read() * 255;
        height = read();    
        height += read() * 255;      
        cnt0=0;
        }}       
      lcd_gotoxy(0,0);
      lcd_putchar(signature%10+'0');
      
      lcd_gotoxy(2,0);
      lcd_putchar((x/100)%10+'0');
      lcd_putchar((x/10)%10+'0');
      lcd_putchar((x/1)%10+'0');
                      
      lcd_gotoxy(6,0);
      lcd_putchar((y/100)%10+'0');
      lcd_putchar((y/10)%10+'0');
      lcd_putchar((y/1)%10+'0');
      
      if(a!=0)
        {          
        cnt2=0;
        while(sharpright>300 && cnt2<100)
            {               
            cnt2++;
            read_cmp();
            a=read();
            if(a==0xaa)
                {       
                a=read();
                if(a==0x55){
                read(); 
                checksum = read();
                checksum += read() * 255;
                signature = read(); 
                signature += read() * 255;
                x = read();
                x+=read()*255;
                y = read();
                y += read() * 255;
                width = read();
                width += read() * 255;
                height = read();    
                height += read() * 255;      
                cnt0=0;
                }}       
            lcd_gotoxy(0,0);
            lcd_putchar(signature%10+'0');
                          
            lcd_gotoxy(2,0);
            lcd_putchar((x/100)%10+'0');
            lcd_putchar((x/10)%10+'0');
            lcd_putchar((x/1)%10+'0');
                                          
            lcd_gotoxy(6,0);
            lcd_putchar((y/100)%10+'0');
            lcd_putchar((y/10)%10+'0');
            lcd_putchar((y/1)%10+'0');
            if(sharpright>400)                      motor(-v/2 + cmp,v/2 + cmp,v/2 + cmp,-v/2 + cmp); 
            else if(a!=0)
                {
                if(x > 0 && x <= 60)                motor(0 + cmp,v + cmp,0 + cmp,-v + cmp);//motor(-v + cmp,v + cmp,v + cmp,-v + cmp);
                else if(x > 60 && x <= 120)         motor(0 + cmp,v + cmp,0 + cmp,-v + cmp); 
                else if(x > 120 && x <= 180)        motor(v + cmp,v + cmp,-v + cmp,-v + cmp);
                else motor(0,0,0,0);
                }
            else motor(0,0,0,0);
            }

        cnt2=0;
        while(sharpleft>300 && cnt2<100)
            {                           
            cnt2++;
            read_cmp();
            a=read();
            if(a==0xaa)
                {       
                a=read();
                if(a==0x55){
                read(); 
                checksum = read();
                checksum += read() * 255;
                signature = read(); 
                signature += read() * 255;
                x = read();
                x+=read()*255;
                y = read();
                y += read() * 255;
                width = read();
                width += read() * 255;
                height = read();    
                height += read() * 255;      
                cnt0=0;
                }}       
            lcd_gotoxy(0,0);
            lcd_putchar(signature%10+'0');
                  
            lcd_gotoxy(2,0);
            lcd_putchar((x/100)%10+'0');
            lcd_putchar((x/10)%10+'0');
            lcd_putchar((x/1)%10+'0');
                                  
            lcd_gotoxy(6,0);
            lcd_putchar((y/100)%10+'0');
            lcd_putchar((y/10)%10+'0');
            lcd_putchar((y/1)%10+'0'); 
            if(sharpleft>400)                      motor(v/2 + cmp,-v/2 + cmp,-v/2 + cmp,v/2 + cmp); 
            else if(a!=0)
                {
                if(x > 120 && x <= 180)             motor(v + cmp,v + cmp,-v + cmp,-v + cmp);                                                                                                        
                else if(x > 180 && x <= 240)        motor(v + cmp,0 + cmp,-v + cmp,0 + cmp);                
                else if(x > 240)                    motor(v + cmp,0 + cmp,-v + cmp,0 + cmp);        
                else motor(0,0,0,0);
                }
            else motor(0,0,0,0);
            }

        if(x > 0 && x <= 60)                motor(0 + cmp,v + cmp,0 + cmp,-v + cmp);//motor(-v + cmp,v + cmp,v + cmp,-v + cmp);
        else if(x > 60 && x <= 120)         motor(0 + cmp,v + cmp,0 + cmp,-v + cmp);
        else if(x > 120 && x <= 180)        motor(v + cmp,v + cmp,-v + cmp,-v + cmp);                                                                                                        
        else if(x > 180 && x <= 240)        motor(v + cmp,0 + cmp,-v + cmp,0 + cmp);
        else if(x > 240)                    motor(v + cmp,0 + cmp,-v + cmp,0 + cmp);//motor(v + cmp,-v + cmp,-v + cmp,v + cmp);        
        else                                motor(0 + cmp,0 + cmp,0 + cmp,0 + cmp);
        }
      else  //     motor(cmp,cmp,cmp,cmp);
        { 
        //read_cmp();          
        //k*=2;
        if (sharpback < 300)  motor(k-128 + cmp,-k-128 + cmp,-k+128 + cmp,k+128 + cmp);
        else                  motor(k+cmp, -k+cmp, -k+cmp, k+cmp);
        }    
                      
      }
}
