
#pragma used+
sfrb TWBR=0;
sfrb TWSR=1;
sfrb TWAR=2;
sfrb TWDR=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      
sfrb ADCSRA=6;
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb UBRRL=9;
sfrb UCSRB=0xa;
sfrb UCSRA=0xb;
sfrb UDR=0xc;
sfrb SPCR=0xd;
sfrb SPSR=0xe;
sfrb SPDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb PINC=0x13;
sfrb DDRC=0x14;
sfrb PORTC=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb PINA=0x19;
sfrb DDRA=0x1a;
sfrb PORTA=0x1b;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEARL=0x1e;
sfrb EEARH=0x1f;
sfrw EEAR=0x1e;   
sfrb UBRRH=0x20;
sfrb UCSRC=0X20;
sfrb WDTCR=0x21;
sfrb ASSR=0x22;
sfrb OCR2=0x23;
sfrb TCNT2=0x24;
sfrb TCCR2=0x25;
sfrb ICR1L=0x26;
sfrb ICR1H=0x27;
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;  
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;  
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb SFIOR=0x30;
sfrb OSCCAL=0x31;
sfrb OCDR=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUCSR=0x34;
sfrb MCUCR=0x35;
sfrb TWCR=0x36;
sfrb SPMCR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb GIFR=0x3a;
sfrb GICR=0x3b;
sfrb OCR0=0X3c;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-

#asm
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
#endasm

#asm
   .equ __i2c_port=0x18 ;PORTB
   .equ __sda_bit=0
   .equ __scl_bit=1
#endasm

#pragma used+
void i2c_init(void);
unsigned char i2c_start(void);
void i2c_stop(void);
unsigned char i2c_read(unsigned char ack);
unsigned char i2c_write(unsigned char data);
#pragma used-

#asm
   .equ __lcd_port=0x15 ;PORTC
#endasm

#pragma used+

void _lcd_ready(void);
void _lcd_write_data(unsigned char data);

void lcd_write_byte(unsigned char addr, unsigned char data);

unsigned char lcd_read_byte(unsigned char addr);

void lcd_gotoxy(unsigned char x, unsigned char y);

void lcd_clear(void);
void lcd_putchar(char c);

void lcd_puts(char *str);

void lcd_putsf(char flash *str);

unsigned char lcd_init(unsigned char lcd_columns);

#pragma used-
#pragma library lcd.lib

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (0x40 & 0xff);

delay_us(10);

ADCSRA|=0x40;

while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
}

int i,adc[16],adc_min;

void sensor()
{
for(i=0;i<16;i++)
{
PORTB.4=(i/1)%2;
PORTB.5=(i/2)%2;
PORTB.6=(i/4)%2;
PORTB.7=(i/8)%2;
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

}

void motor(int ml1,int ml2,int mr2,int mr1)
{
if (ml1>255) ml1=255;
if (ml1<-255) ml1=-255;

if (ml2>255) ml2=255;
if (ml2<-255) ml2=-255;

if (mr2>255) mr2=255;
if (mr2<-255) mr2=-255;

if (mr1>255) mr1=255;
if (mr1<-255) mr1=-255;

if(mr1>0)
{
PORTD.0=0;
OCR0=mr1;
}
else if(mr1<=0)
{
PORTD.0=1;
OCR0=mr1+255;
}

if(mr2>0)
{
PORTD.1=0;
OCR1B=mr2;
}
else if(mr2<=0)
{
PORTD.1=1;
OCR1B=mr2+255;
}

if(ml2>0)
{
PORTD.2=0;
OCR1A=ml2;
}
else if(ml2<=0)
{
PORTD.2=1;
OCR1A=ml2+255;
}

if(ml1>0)
{
PORTD.3=0;
OCR2=ml1;
}
else if(ml1<=0)
{
PORTD.3=1;
OCR2=ml1+255;
}

}

void main(void)
{

PORTA=0x00;
DDRA=0x00;

PORTB=0x00;
DDRB=0xFC;

PORTC=0x00;
DDRC=0x08;

PORTD=0x00;
DDRD=0xFF;

TCCR0=0x6B;
TCNT0=0x00;
OCR0=0x00;

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

ASSR=0x00;
TCCR2=0x6C;
TCNT2=0x00;
OCR2=0x00;

MCUCR=0x00;
MCUCSR=0x00;

TIMSK=0x00;

ACSR=0x80;
SFIOR=0x00;

ADMUX=0x40 & 0xff;
ADCSRA=0x84;

i2c_init();

lcd_init(16);

while (1)
{

sensor();

if(adc[adc_min]<700)
{
if(adc_min==0)              motor(255,255,-255,-255);        
else if(adc_min==1)         motor(255,128,-255,-128);       
else if(adc_min==2)         motor(255,0,-255,0);
else if(adc_min==3)         motor(255,-128,-255,128);
else if(adc_min==4)         motor(255,-255,-255,255);
else if(adc_min==5)         motor(128,-255,-128,255);
else if(adc_min==6)         motor(0,-255,0,255);
else if(adc_min==7)         motor(-128,-255,128,255);

else if(adc_min==8)         motor(-255,-255,255,255);

else if(adc_min==9)         motor(-255,-128,255,128);
else if(adc_min==10)         motor(-255,0,255,0);
else if(adc_min==11)         motor(-255,128,255,-128);
else if(adc_min==12)         motor(-255,255,255,-255);
else if(adc_min==13)         motor(-128,255,128,-255);
else if(adc_min==14)         motor(0,255,0,-255);
else if(adc_min==15)         motor(128,255,-128,-255);
}

else  motor(0,0,0,0);

};
}
