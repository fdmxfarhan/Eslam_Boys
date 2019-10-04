#include <mega16.h>
#include <delay.h>
#include <i2c.h>

#asm
    .equ __lcd_port=0x15;PORTC
#endasm
#include <lcd.h>
#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))
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


int SR,SB,SL,SKF,SKL,SKR,SKB;
int cmp;
eeprom int c;
int v=255;      
int k;




#define I2C_7BIT_DEVICE_ADDRESS 0x54
#define EEPROM_BUS_ADDRES (I2C_7BIT_DEVICE_ADDRESS << 1)

unsigned char addres=0x54;
/* read a byte from the EEPROM */
unsigned char read() 
{
unsigned char data;
i2c_start();
i2c_write(EEPROM_BUS_ADDRES | 0);
/*send MSB of address */
i2c_write(addres >> 8);
/* send LSB of address */
i2c_write((unsigned char) addres);
i2c_start();
i2c_write(EEPROM_BUS_ADDRES | 1);
data=i2c_read(0);
i2c_stop();
return data;
}

#define EEPROM_BUS_ADDRESS 0xc0  
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

int x, y, w, h, ch, sn;
char a,out=0 ;

void read_pixy()
      {
      a=read();   
      //b=getchar();
      if(a==0xaa)
        {       
        a=read();
        if(a==0x55){
        read(); 
        ch = read();
        ch+= read() * 255;
        sn = read(); 
        sn += read() * 255;
        x = read();
        x+=read()*255;
        y = read();
        y += read() * 255;
        w = read();
        w += read() * 255;
        h = read();    
        h += read() * 255;      
        }}                   
      lcd_gotoxy(0,0); 
      lcd_putsf("X=");
      lcd_putchar((x/100)%10+'0');
      lcd_putchar((x/10)%10+'0');
      lcd_putchar((x/1)%10+'0');
                          
      lcd_gotoxy(6,0); 
      lcd_putsf("Y=");
      lcd_putchar((y/100)%10+'0');
      lcd_putchar((y/10)%10+'0');
      lcd_putchar((y/1)%10+'0');
      }

void sensor()
    {
    #asm("wdr");         
      
    {        
    #asm("wdr"); 
    SB=read_adc(1);
    SR=read_adc(2);
    SL=read_adc(3);
    SKF=read_adc(4);
    SKR=read_adc(5);
    SKL=read_adc(7);
    SKB=read_adc(6);   
    }
    
    {       
    #asm("wdr");
    lcd_gotoxy(12,1);
    //lcd_putchar('K');
    lcd_putchar((SKL/100)%10+'0');
    lcd_putchar((SKL/10)%10+'0');
    lcd_putchar((SKL/1)%10+'0');
    lcd_gotoxy(8,1);
    //lcd_putchar('B');
    lcd_putchar((SKB/100)%10+'0');
    lcd_putchar((SKB/10)%10+'0');
    lcd_putchar((SKB/1)%10+'0');
    lcd_gotoxy(4,1);
    //lcd_putchar('R');
    lcd_putchar((SKR/100)%10+'0');
    lcd_putchar((SKR/10)%10+'0');
    lcd_putchar((SKR/1)%10+'0');    
    
    lcd_gotoxy(0,1);
    lcd_putchar((SKF/100)%10+'0');
    lcd_putchar((SKF/10)%10+'0');
    lcd_putchar((SKF/1)%10+'0');    
    
//    lcd_gotoxy(0,1);
//    //lcd_putchar('K');
//    lcd_putchar((SL/100)%10+'0');
//    lcd_putchar((SL/10)%10+'0');
//    lcd_putchar((SL/1)%10+'0');
//    lcd_gotoxy(4,1);
//    //lcd_putchar('B');
//    lcd_putchar((SB/100)%10+'0');
//    lcd_putchar((SB/10)%10+'0');
//    lcd_putchar((SB/1)%10+'0');
//    lcd_gotoxy(8,1);
//    //lcd_putchar('R');
//    lcd_putchar((SR/100)%10+'0');
//    lcd_putchar((SR/10)%10+'0');
//    lcd_putchar((SR/1)%10+'0');
    }
    
    k=SL-SR;  
    
    
    {    
    #asm("wdr");
    cmp=compass_read(1)-c;  
    
    if (SL < SR && k>50)
        {
        cmp = SR/32;  
        v = 200;
        }
    else if (SR <= SL && k<-50) 
        {
        cmp = SL/10;
        v = 200;
        }
    
    
    if(cmp>128)  cmp=cmp-255;    
    if(cmp<-128) cmp=cmp+255;
    if (SB < 150 && SR > 250 && SR < 150)
        {
        cmp = cmp+((SR*3)/20);
        }
    else if (SB < 150 && SL > 250 && SL < 150)
        {
        cmp = cmp+((SL*3)/20);
        }
        lcd_gotoxy(11,0);
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
        }
    
    
    if (cmp > -15 && cmp < 15)
    {
        cmp*=-3;
    }
    else
    {
        cmp*=-2;
    }      
    }

void motor(int ml1,int ml2,int mr2,int mr1)
    {
    sensor();
    #asm("wdr");               
    {
    ml1+=cmp;
    ml2+=cmp;
    mr2+=cmp;
    mr1+=cmp;  
    }
    {
    if(ml1>255) ml1=255;
    if(ml2>255) ml2=255;
    if(mr2>255) mr2=255;
    if(mr1>255) mr1=255;
    
    if(ml1<-255) ml1=-255;
    if(ml2<-255) ml2=-255;
    if(mr2<-255) mr2=-255;
    if(mr1<-255) mr1=-255;      
    }
    //////////////mr1  
    {
    if(mr1>=0)
        {  
        #asm("wdr");
        PORTD.0=0;
        OCR0=mr1;
        }
    else
        {  
        #asm("wdr");
        PORTD.0=1;
        OCR0=mr1+255;
        }                            
        }
    //////////////mr2    
    {
    if(mr2>=0)
        {   
        #asm("wdr");
        PORTD.1=0;
        OCR1B=mr2;
        }
    else
        {     
        #asm("wdr");
        PORTD.1=1;
        OCR1B=mr2+255;
        }    
        }
    //////////////mL2  
    {
    if(ml2>=0)
        {  
        #asm("wdr");
        PORTD.2=0;
        OCR1A=ml2;
        }
    else
        {      
        #asm("wdr");
        PORTD.2=1;
        OCR1A=ml2+255;
        }      
        }
    //////////////ml1
    {
    if(ml1>=0)
        {        
        #asm("wdr");
        PORTD.3=0;
        OCR2=ml1;
        }
    else
        {    
        #asm("wdr");
        PORTD.3=1;
        OCR2=ml1+255;
        }                                    
        }
    
    }      
//int fl1=0,fl2=0; 
void catch()
    {  
    if(a!=0)
        { 
        if (SB < 160)               motor(k,-k,-k,k);
        if(x<=30)                   motor(-v,v,v,-v);
        else if(x>30 && x<=100)     motor(0,v,0,-v);
        else if(x>100 && x<=200)    motor(v,v,-v,-v);
        else if(x>200 && x<=270)    motor(v,0,-v,0);
        else if(x>270)              motor(v,-v,-v,v);
           
        }
    else 
    { 
        k*=2;
        if(SB < 200) motor(-v+k,-v-k,v-k,v+k);    
        else if (SB > 400) motor (v+k,v-k,-v-k,-v+k);
        else motor(0,0,0,0);
    } 
    }

void main(void)
{
#asm("wdr");
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
// Clock value: 31.250 kHz
// Mode: Fast PWM top=0xFF
// OC0 output: Non-Inverted PWM
// Timer Period: 8.192 ms
// Output Pulse(s):
// OC0 Period: 8.192 ms Width: 0 us
TCCR0=(1<<WGM00) | (1<<COM01) | (0<<COM00) | (1<<WGM01) | (1<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 31.250 kHz
// Mode: Fast PWM top=0x00FF
// OC1A output: Non-Inverted PWM
// OC1B output: Non-Inverted PWM
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 8.192 ms
// Output Pulse(s):
// OC1A Period: 8.192 ms Width: 0 us// OC1B Period: 8.192 ms Width: 0 us
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (1<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (1<<CS12) | (0<<CS11) | (0<<CS10);
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
// Clock value: 31.250 kHz
// Mode: Fast PWM top=0xFF
// OC2 output: Non-Inverted PWM
// Timer Period: 8.192 ms
// Output Pulse(s):
// OC2 Period: 8.192 ms Width: 0 us
ASSR=0<<AS2;
TCCR2=(1<<PWM2) | (1<<COM21) | (0<<COM20) | (1<<CTC2) | (1<<CS22) | (1<<CS21) | (0<<CS20);
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
// ADC Clock frequency: 62.500 kHz
// ADC Voltage Reference: AVCC pin
// ADC Auto Trigger Source: ADC Stopped
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
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

// Watchdog Timer initialization
// Watchdog Timer Prescaler: OSC/256k
WDTCR=(0<<WDTOE) | (1<<WDE) | (1<<WDP2) | (0<<WDP1) | (0<<WDP0);

}

delay_ms(3000);
c = compass_read(1);
v=255;
while (1)                                                                                                                        
      {   
      #asm("wdr");
      sensor();    
      read_pixy();
      if(SKB>600 || SKR>600 || SKL>600)
        {
        if(SKR>600)
            {
            if(SL>500) {motor(v,-v,-v,v);out='L';}
            else       {motor(-v,v,v,-v);out='R';}
            
            }                 
        else if(SKL>600)
            {
            if(SR>500) {motor(-v,v,v,-v);out='R';}
            else       {motor(v,-v,-v,v);out='L';}
            
            }                 
                         
        
        } 
      else 
        {
        while(out=='R' && a!=0)
            {
            sensor();
            read_pixy();
            if(SR>300)   motor(-v,v,v,-v);
            else  motor(0,0,0,0);
            }     
        while(out=='L' && a!=0)
            {
            sensor();
            read_pixy();
            if(SL>300)   motor(v,-v,-v,v);
            else  motor(0,0,0,0);
            }     
        if(SKF>600 && out==0)
            {
            motor(-v,-v,v,v);
            delay_ms(300);
            out='F';
            }
        while(out=='F' && a!=0)
            {
            sensor();
            read_pixy();
            motor(0,0,0,0);
            }     
        
        catch(); 
        out=0;
        }
      }               
}