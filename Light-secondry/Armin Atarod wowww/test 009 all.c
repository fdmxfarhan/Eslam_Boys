#include <mega16.h>
#include <stdbool.h>
#include <delay.h>
#include <i2c.h>
#asm
    .equ __lcd_port=0x15;PORTC
#endasm
#include <lcd.h>
#define centered k < 20 && k > -20
#define middled SB < backmax2 && SB > backmax3
#define lefted k > 20
#define righted k < -20
#define fronted SB < backmax3
#define backed SB > backmax2
#define center k,-k,-k,k
#define back -v,-v,v,v
#define forward v,v,-v,-v
#define right v,-v,-v,v
#define left -v,v,v,-v
#define stop 0,0,0,0

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

int i,imin,min;
int SL,SB,SR,k;
int SKF,SKL,SKB,SKR;
int print_lcd = 1;  //0: none   -   1: ir-cmp-sharp   -   2: ir-cmp-kaf
int old_print_lcd = 1;
int cmp;
int v = 255;
int position;
int action;
bool setcmp, setback1,setback2,setback3, setkaf1,setkaf2,setkaf3,setkaf4, setzamin1,setzamin2,setzamin3,setzamin4;
char out=0;
eeprom int c, kafmin1,kafmin2,kafmin3,kafmin4, kafmax1,kafmax2,kafmax3,kafmax4, kafmid1,kafmid2,kafmid3,kafmid4, backmax1,backmax2,backmax3;

void sensor()
{
    //read IR
    {
    min = 1023;
    for (i = 0 ; i < 16 ; i++)
    {
        PORTB.7 = (i/8)%2;
        PORTB.6 = (i/4)%2;
        PORTB.5 = (i/2)%2;
        PORTB.4 = (i/1)%2;
        if (read_adc(0) < min)
        {
            min = read_adc(0);
            imin = i;
        }
    }
    }

    //print IR
    if (print_lcd == 1 || print_lcd == 2)
    {
        lcd_gotoxy(0,0);
        lcd_putchar((imin/10)%10 + '0');
        lcd_putchar((imin/1)%10 + '0');
        lcd_putsf(":");
        lcd_putchar((min/100)%10 + '0');
        lcd_putchar((min/10)%10 + '0');
        lcd_putchar((min/1)%10 + '0');
    }

    //read sharp
    {
        SB = read_adc(1);
        SR = read_adc(2);
        SL = read_adc(3);
        k = SL-SR;
    }

    //print sharp
    if (print_lcd == 1)
    {
        lcd_gotoxy(0,1);
        lcd_putsf("L");
        lcd_putchar((SL/100)%10 + '0');
        lcd_putchar((SL/10)%10 + '0');
        lcd_putchar((SL/1)%10 + '0');
        lcd_gotoxy(5,1);
        lcd_putsf("B");
        lcd_putchar((SB/100)%10 + '0');
        lcd_putchar((SB/10)%10 + '0');
        lcd_putchar((SB/1)%10 + '0');
        lcd_gotoxy(10,1);
        lcd_putsf("R");
        lcd_putchar((SR/100)%10 + '0');
        lcd_putchar((SR/10)%10 + '0');
        lcd_putchar((SR/1)%10 + '0');
    }

    //read kaf
    {
        SKF = read_adc(4);
        SKL = read_adc(5);
        SKR = read_adc(6);
        SKB = read_adc(7);
    }

    //print kaf
    if (print_lcd == 2)
    {
        lcd_gotoxy(0,1);
        lcd_putchar((SKL/100)%10 + '0');
        lcd_putchar((SKL/10)%10 + '0');
        lcd_putchar((SKL/1)%10 + '0');
        lcd_gotoxy(4,1);
        lcd_putchar((SKB/100)%10 + '0');
        lcd_putchar((SKB/10)%10 + '0');
        lcd_putchar((SKB/1)%10 + '0');
        lcd_gotoxy(8,1);
        lcd_putchar((SKR/100)%10 + '0');
        lcd_putchar((SKR/10)%10 + '0');
        lcd_putchar((SKR/1)%10 + '0');
        lcd_gotoxy(12,1);
        lcd_putchar((SKF/100)%10 + '0');
        lcd_putchar((SKF/10)%10 + '0');
        lcd_putchar((SKF/1)%10 + '0');
    }

    //read cmp
    {
        #asm("wdr");
        cmp=compass_read(1)-c;

        if(cmp>128)  cmp=cmp-255;
        if(cmp<-128) cmp=cmp+255;
    }

    //print cmp
    if (print_lcd == 1 || print_lcd == 2)
    {
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

    //multiply
    {
        if (cmp > -20 && cmp < 20)
        {
            cmp*=-4;
        }
        else
        {
            cmp*=-2;
        }
    }
}

void motor(int ml1,int ml2,int mr2,int mr1)
    {
    #asm("wdr");
    {
        ml1+=cmp;
        ml2+=cmp;
        mr2+=cmp;
        mr1+=cmp;
    }

    if (SB < 170 && SL > 250)
    {
        ml1 += 30;
        ml2 += 30;
        mr2 += 30;
        mr1 += 30;
    }

    else if (SB < 170 && SR > 250)
    {
        ml1 -= 30;
        ml2 -= 30;
        mr2 -= 30;
        mr1 -= 30;
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

void check()
{
    if(SKB>kafmid3 || SKR>kafmid2 || SKL>kafmid4)
    {
        if(SKR>kafmid2)
        {
            if(SL>400)
            {
                motor(v,-v,-v,v);
                out='L';
            }
            else
            {
                motor(-v,v,v,-v);
                out='R';
            }
        }
        else if(SKL>kafmid4)
        {
            if(SR>400)
            {
                motor(-v,v,v,-v);
                out='R';
            }
            else
            {
                motor(v,-v,-v,v);
                out='L';
            }
        }
        else if(SKB>kafmid3)
        {
            if(SB>200)
            {
                motor(-v,v,v,-v);
                out='B';
            }
        }
    }
    else
    {
        while(out=='R' && min < 800 && imin >= 0 && imin <= 8)
        {
            sensor();
            if(SR>250)   motor(-v,v,v,-v);
            else  motor(0,0,0,0);
        }
        while(out=='L' && min < 800 && imin <= 15 && imin >= 8)
        {
            sensor();
            if(SL>250)   motor(v,-v,-v,v);
            else  motor(0,0,0,0);
        }
        while(out=='B' && min < 800 && imin >= 4 && imin <= 12)
        {
            sensor();
            if(SB>250)   motor(v,v,-v,-v);
            else  motor(0,0,0,0);
        }
        if(SKF>kafmid1 && out==0)
        {
            motor(-v,-v,v,v);
            delay_ms(300);
            out='F';
        }
        while(out=='F' && min < 800 && (imin >=  12|| imin <= 4))
        {
            sensor();
            motor(0,0,0,0);
        }
    }
}

void catch()
{
    //check min
    if (min < 800)
    {
        //center
        if (SB < 170) motor(center);

        //set position
        {
            if ((lefted) && (fronted)) position = 1;
            else if ((centered) && (fronted)) position = 2;
            else if ((righted) && (fronted)) position = 3;
            else if ((lefted) && (middled)) position = 4;
            else if ((centered) && (middled)) position = 5;
            else if ((righted) &&  (middled)) position = 6;
            else if ((lefted) && (backed)) position = 7;
            else if ((centered) && (backed)) position = 8;
            else if ((righted) && (backed)) position = 9;
        }

        //set shift
        {
            if (position == 1)
            {
                #asm("wdr")
                if (imin == 0) action = imin+2;
                else if (imin >= 13 || imin <= 3) action = imin;
                else if (imin >= 4 && imin <= 7) action = imin+2;
                else if (imin >= 8 && imin <= 12) action = imin-2;
            }
            else if (position == 2)
            {
                #asm("wdr")
                if (imin >= 13 || imin <= 3) action = imin;
                else if (imin >= 4 && imin <= 8) action = imin+2;
                else if (imin >= 9 && imin <= 12) action = imin-2;
            }
            else if (position == 3)
            {
                #asm("wdr")
                if (imin >= 13 || imin <= 3) action = imin;
                else if (imin >= 4 && imin <= 8) action = imin+2;
                else if (imin >= 9 && imin <= 12) action = imin-2;
            }
            else if (position == 4)
            {
                #asm("wdr")
                if (imin == 0) action = imin+1;
                else if (imin <= 2) action = imin+2;
                else if (imin >= 3 && imin <= 6) action = imin+2;
                else if (imin == 7) action = imin+1;
                else if (imin >= 8) action = imin-1;
            }
            else if (position == 5)
            {
                #asm("wdr")
                if (imin >= 15 || imin <= 1) action = imin;
                else if (imin >= 2 && imin <= 6) action = imin+2;
                else if (imin >= 7 && imin <= 8) action = imin+1;
                else if (imin == 9) action = imin-1;
                else if (imin >= 10 && imin <= 14) action = imin-2;
            }
            else if (position == 6)
            {
                #asm("wdr")
                if (imin == 0) action = imin-1;
                else if (imin >= 14) action = imin-2;
                else if (imin <= 13 && imin >= 10) action = imin-2;
                else if (imin == 9) action = imin-1;
                else if (imin <= 8) action = imin+1;
            }
            else if (position == 7)
            {
                #asm("wdr")
                if (imin <= 3) action = imin+1;
                else if (imin == 4) action = imin+2;
                else if (imin >= 5 && imin <= 7) action = imin-1;
                else if (imin == 8) action = imin;
                else if (imin >= 9 && imin <= 11) action = imin+1;
                else if (imin >= 12) action = imin-2;
            }
            else if (position == 8)
            {
                #asm("wdr")
                if (imin >= 15 || imin <= 1) action = imin;
                else if (imin >= 2 && imin <= 5) action = imin+2;
                else if (imin >= 11 && imin <= 14) action = imin-2;
                else if (imin >= 6 && imin <= 10) action = 1000;
            }
            else if (position == 9)
            {
                #asm("wdr")
                if (imin == 0) action = 15;
                else if (imin >= 13) action = imin-1;
                else if (imin == 12) action = imin-2;
                else if (imin <= 11 && imin >= 9) action = imin+1;
                else if (imin == 8) action = imin;
                else if (imin >= 5 && imin <= 7) action= imin-1;
                else if (imin <= 4) action = imin+2;
            }
    }

         //command
        switch (action)
        {
            case 0:
                motor(forward);
            break;

            case 1:
                motor(v,v/2,-v,-v/2);
            break;

            case 2:
                motor(v,0,-v,0);
            break;

            case 3:
                motor(v,-v/2,-v,v/2);
            break;

            case 4:
                motor(right);
            break;

            case 5:
                motor(v/2,-v,-v/2,v);
            break;

            case 6:
                motor(0,-v,0,v);
            break;

            case 7:
                motor(-v/2,-v,v/2,v);
            break;

            case 8:
                motor(back);
            break;

            case 9:
                motor(-v,-v/2,v,v/2);
            break;

            case 10:
                motor(-v,0,v,0);
            break;

            case 11:
                motor(-v,v/2,v,-v/2);
            break;

            case 12:
                motor(left);
            break;

            case 13:
                motor(-v/2,v,v/2,-v);
            break;

            case 14:
                motor(0,v,0,-v);
            break;

            case 15:
                motor(v/2,v,-v/2,-v);
            break;

            case 1000:
                motor(0,0,0,0);
            break;

            default:
            break;
        }
    }

    else
    {
        if (SB < backmax1-50) motor(-v+k,-v-k,v-k,v+k);
        else if (SB > backmax1+150) motor(v+k,v-k,-v-k,-v+k);
        else if (k < -20 || k > 20) motor(center);
        else motor(0,0,0,0);
    }
}

void setup()
{
    old_print_lcd = print_lcd;
    print_lcd = 0;
    setcmp = false;
    setkaf1 = false;
    setkaf2 = false;
    setkaf3 = false;
    setkaf4 = false;
    setzamin1 = false;
    setzamin2 = false;
    setzamin3 = false;
    setzamin4 = false;
    setback1 = false;
    setback2 = false;
    setback3 = false;
    lcd_clear();
    lcd_gotoxy(0,0);
    lcd_putsf("setup start...");
    delay_ms(1000);
    while (setcmp == false)
    {
        #asm("wdr")
        sensor();
        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_putsf("set cmp: ");
        lcd_putchar((compass_read(1)/100)%10 + '0');
        lcd_putchar((compass_read(1)/10)%10 + '0');
        lcd_putchar((compass_read(1)/1)%10 + '0');
        if (PINC.3 == 1)
        {
            c = compass_read(1);
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_putsf("cmp set");
            delay_ms(1000);
            setcmp = true;
        }
    }
    while (setkaf1 == false)
    {
        #asm("wdr")
        sensor();
        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_putsf("set SKF: ");
        lcd_putchar((SKF/100)%10 + '0');
        lcd_putchar((SKF/10)%10 + '0');
        lcd_putchar((SKF/1)%10 + '0');
        if (PINC.3 == 1)
        {
            kafmax1 = SKF;
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_putsf("SKF set");
            delay_ms(1000);
            setkaf1 = true;
        }

    }
    while (setkaf2 == false)
    {
        #asm("wdr")
        sensor();
        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_putsf("set SKR: ");
        lcd_putchar((SKR/100)%10 + '0');
        lcd_putchar((SKR/10)%10 + '0');
        lcd_putchar((SKR/1)%10 + '0');
        if (PINC.3 == 1)
        {
            kafmax2 = SKR;
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_putsf("SKR set");
            delay_ms(1000);
            setkaf2 = true;
        }

    }
    while (setkaf3 == false)
    {
        #asm("wdr")
        sensor();
        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_putsf("set SKB: ");
        lcd_putchar((SKB/100)%10 + '0');
        lcd_putchar((SKB/10)%10 + '0');
        lcd_putchar((SKB/1)%10 + '0');
        if (PINC.3 == 1)
        {
            kafmax3 = SKB;
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_putsf("SKB set");
            delay_ms(1000);
            setkaf3 = true;
        }

    }
    while (setkaf4 == false)
    {
        #asm("wdr")
        sensor();
        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_putsf("set SKL: ");
        lcd_putchar((SKL/100)%10 + '0');
        lcd_putchar((SKL/10)%10 + '0');
        lcd_putchar((SKL/1)%10 + '0');
        if (PINC.3 == 1)
        {
            kafmax4 = SKL;
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_putsf("SKL set");
            delay_ms(1000);
            setkaf4 = true;
        }

    }
    while (setzamin1 == false)
    {
        #asm("wdr")
        sensor();
        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_putsf("set zaminF: ");
        lcd_putchar((SKF/100)%10 + '0');
        lcd_putchar((SKF/10)%10 + '0');
        lcd_putchar((SKF/1)%10 + '0');
        if (PINC.3 == 1)
        {
            kafmin1 = SKF;
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_putsf("zaminF set");
            delay_ms(1000);
            setzamin1 = true;
        }

    }
    while (setzamin2 == false)
    {
        #asm("wdr")
        sensor();
        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_putsf("set zaminR: ");
        lcd_putchar((SKR/100)%10 + '0');
        lcd_putchar((SKR/10)%10 + '0');
        lcd_putchar((SKR/1)%10 + '0');
        if (PINC.3 == 1)
        {
            kafmin2 = SKR;
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_putsf("zaminR set");
            delay_ms(1000);
            setzamin2 = true;
        }

    }
    while (setzamin3 == false)
    {
        #asm("wdr")
        sensor();
        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_putsf("set zaminB: ");
        lcd_putchar((SKB/100)%10 + '0');
        lcd_putchar((SKB/10)%10 + '0');
        lcd_putchar((SKB/1)%10 + '0');
        if (PINC.3 == 1)
        {
            kafmin3 = SKB;
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_putsf("zaminB set");
            delay_ms(1000);
            setzamin3 = true;
        }

    }
    while (setzamin4 == false)
    {
        #asm("wdr")
        sensor();
        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_putsf("set zaminL: ");
        lcd_putchar((SKL/100)%10 + '0');
        lcd_putchar((SKL/10)%10 + '0');
        lcd_putchar((SKL/1)%10 + '0');
        if (PINC.3 == 1)
        {
            kafmin4 = SKL;
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_putsf("zaminL set");
            delay_ms(1000);
            setzamin4 = true;
        }

    }
    kafmid1 = (kafmin1 + kafmax1)/2;
    kafmid2 = (kafmin2 + kafmax2)/2;
    kafmid3 = (kafmin3 + kafmax3)/2;
    kafmid4 = (kafmin4 + kafmax4)/2;
    while (setback1 == false)
    {
        #asm("wdr")
        sensor();
        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_putsf("set back1: ");
        lcd_putchar((SB/100)%10 + '0');
        lcd_putchar((SB/10)%10 + '0');
        lcd_putchar((SB/1)%10 + '0');
        if (PINC.3 == 1)
        {
            backmax1 = SB;
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_putsf("back1 set");
            delay_ms(1000);
            setback1 = true;
        }

    }
    while (setback2 == false)
    {
        #asm("wdr")
        sensor();
        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_putsf("set back2: ");
        lcd_putchar((SB/100)%10 + '0');
        lcd_putchar((SB/10)%10 + '0');
        lcd_putchar((SB/1)%10 + '0');
        if (PINC.3 == 1)
        {
            backmax2 = SB;
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_putsf("back2 set");
            delay_ms(1000);
            setback2 = true;
        }

    }
    while (setback3 == false)
    {
        #asm("wdr")
        sensor();
        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_putsf("set back3: ");
        lcd_putchar((SB/100)%10 + '0');
        lcd_putchar((SB/10)%10 + '0');
        lcd_putchar((SB/1)%10 + '0');
        if (PINC.3 == 1)
        {
            backmax3 = SB;
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_putsf("back3 set");
            delay_ms(1000);
            setback3 = true;
        }

    }
    lcd_clear();
    lcd_putsf("setup done");
    delay_ms(1000);
    print_lcd = old_print_lcd;
}

void main(void)
{
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

    while (1)
    {
        #asm("wdr")
        if (PINC.3 == 1)    c=compass_read(1);
        sensor();
        if(SKF>600 && out==0)
            {
            motor(-255,-255,255,255);
            delay_ms(400);
            out='F';
            }
        if(SKB>600 && out==0)
            {
            motor(255,255,-255,-255);
            delay_ms(400);
            out='B';
            }
        if(SKR>600 && out==0)
            {
            motor(255,-255,-255,255);
            delay_ms(400);
            out='R';
            }
        if(SKL>600 && out==0)
            {
            motor(-255,255,255,-255);
            delay_ms(400);
            out='L';
            }

        while(out=='F' && min<800)
            {
            sensor();
            if(imin<12 && imin>4)
                catch();
            else motor(0,0,0,0);
            }
        while(out=='B' && min<800)
            {
            sensor();
            if(!(imin<12 && imin>4))
                catch();
            else motor(0,0,0,0);
            }
        while((out=='R' || SR>300) && min<800)
            {
            sensor();
            if(imin<12 && imin>4)
                catch();
            else motor(0,0,0,0);
            }
        while((out=='L' || SL>300) && min<800)
            {
            sensor();
            if(imin<12 && imin>4)
                catch();
            else motor(0,0,0,0);
            }

        out=0;
        catch();
        out = 0;
    }
}
