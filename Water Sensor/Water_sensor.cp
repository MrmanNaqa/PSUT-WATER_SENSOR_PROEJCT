#line 1 "C:/Users/Public/Documents/Mikroelektronika/mikroC PRO for PIC/Examples/Development Systems/EasyPIC v8/Water Sensor/Water_sensor.c"
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for pic/include/stdio.h"
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for pic/include/stdlib.h"







 typedef struct divstruct {
 int quot;
 int rem;
 } div_t;

 typedef struct ldivstruct {
 long quot;
 long rem;
 } ldiv_t;

 typedef struct uldivstruct {
 unsigned long quot;
 unsigned long rem;
 } uldiv_t;

int abs(int a);
float atof(char * s);
int atoi(char * s);
long atol(char * s);
div_t div(int number, int denom);
ldiv_t ldiv(long number, long denom);
uldiv_t uldiv(unsigned long number, unsigned long denom);
long labs(long x);
int max(int a, int b);
int min(int a, int b);
void srand(unsigned x);
int rand();
int xtoi(char * s);
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for pic/include/math.h"





double fabs(double d);
double floor(double x);
double ceil(double x);
double frexp(double value, int * eptr);
double ldexp(double value, int newexp);
double modf(double val, double * iptr);
double sqrt(double x);
double atan(double f);
double asin(double x);
double acos(double x);
double atan2(double y,double x);
double sin(double f);
double cos(double f);
double tan(double x);
double exp(double x);
double log(double x);
double log10(double x);
double pow(double x, double y);
double sinh(double x);
double cosh(double x);
double tanh(double x);
#pragma config WDT = ON
#line 9 "C:/Users/Public/Documents/Mikroelektronika/mikroC PRO for PIC/Examples/Development Systems/EasyPIC v8/Water Sensor/Water_sensor.c"
int i=0;
int l=0;
int t1=0;
int t2=0;
int t3=0;
int t4=0;
char ascii[10]={0};
char x;


int TANK_1_MIN_WATER_LEVEL = 20;
int TANK_2_MIN_WATER_LEVEL = 50;
int TANK_2_MAX_WATER_LEVEL = 80;
int CONTAINER_MAX_DISTANCE = 18;


int TANK_MIN_TEMPERATURE = 20;

unsigned int ms;
unsigned long duration=0;
unsigned int Distance;
unsigned int level1=0;
unsigned int level2=0;
unsigned int temp1=0;
unsigned int sensorValue=0;
unsigned int temprature=0;
void loop();
int temp;

void delay(unsigned int ms1);
int analogRead();
int readUltraSonicSensor(int triggerPin);
int readTemperatureSensor();
void setup();
void myascii(int t1);


void interrupt(void) {

 if (PIR1 & PIE1 & 0x02) {

 PIR1 = PIR1 & 0xFD;


 ms--;


 if (ms == 0) PIE1 = PIE1 & 0xFD;
 }
 }



void delay(unsigned int ms1) {
 ms = ms1;

 PR2 = 125;


 T2CON = 0x02;


 TMR2 = 0;


 PIE1 = PIE1 | 0x02;


 INTCON = INTCON | 0xC0;


 T2CON = T2CON | 0x04;


 while (ms > 0);
}



int analogRead() {

 ADCON0 = 0x40;


 ADCON0 = ADCON0 | 0x00;


 ADCON0 = ADCON0 | 0x01;
 ADCON0 = ADCON0 | 0x04;


 while (ADCON0 & 0x04);


 delay(1);


 return (ADRESH << 8) | ADRESL;
}



int readUltraSonicSensor(int triggerPin) {

 temp = triggerpin;


 TMR1H = 0;
 TMR1L = 0;


 if(temp<16)
 {
 PORTD = PORTD | 0x01;
 delay(10);
 PORTD = PORTD & 0xFE;

 while(!(PORTD & 0x02));

 T1CON = 0x19;

 while (PORTD & 0x02);

 T1CON = 0x18;
 }
 if(temp>15)
 {
 PORTD = PORTD | 0x04;
 delay(10);
 PORTD = PORTD & 0xFB;

 while(!(PORTD & 0x08));

 T1CON = 0x19;

 while (PORTD & 0x08);

 T1CON =0x18;
 }



 duration=((TMR1H<<8)|TMR1L);


 TMR1H = 0;
 TMR1L = 0;


 Distance = ((duration * 34) / (1000) / 2);


 return (((CONTAINER_MAX_DISTANCE - Distance) * 100 )/ 18) ;
}



int readTemperatureSensor() {

 sensorValue = analogRead();





 temprature = ((sensorValue * 3000) / 1023.0);

 return temprature;
}

void USART_send(char x){
 while(!(TXSTA&0x02));
 TXREG = x;

}




void setup() {

TRISA = 0xFF;
PORTA = 0x00;
TRISA = 0x00;


TRISB = 0x00;



TRISD = 0X0A;


OPTION_REG=0x0F;
#line 223 "C:/Users/Public/Documents/Mikroelektronika/mikroC PRO for PIC/Examples/Development Systems/EasyPIC v8/Water Sensor/Water_sensor.c"
 ADCON1 = 0xC4;
 CCP1CON = 0X00;
 PORTD = PORTD | 0x10;



 TRISC=0x80;

 TXSTA=(1<<5);

 RCSTA=(1<<7) | (1<<4);

 SPBRG = (8000000UL/(long)(64UL*9600))-1;

 delay(300);
}

void myascii(int t1){
 t2=0;
 t3=0;
 t4=0;
 if(t1>>31)
 {

 t1=~t1+1;
 for(t2=t1;t2!=0;t2/=10,t3++);
 ascii[0]=0x2D;
 t3++;
 t4=1;
 }
 else
 for(t2=t1;t2!=0;t2/=10,t3++);
 for(i=t3-1,t2=t1;i>=t4;i--)
 {

 ascii[i]=(t2%10)+0x30;
 t2/=10;
 }

}



void loop() {

 level1 = readUltraSonicSensor(15);
#line 275 "C:/Users/Public/Documents/Mikroelektronika/mikroC PRO for PIC/Examples/Development Systems/EasyPIC v8/Water Sensor/Water_sensor.c"
 level2 = readUltraSonicSensor(16);
#line 284 "C:/Users/Public/Documents/Mikroelektronika/mikroC PRO for PIC/Examples/Development Systems/EasyPIC v8/Water Sensor/Water_sensor.c"
 temp1 = readTemperatureSensor();
#line 316 "C:/Users/Public/Documents/Mikroelektronika/mikroC PRO for PIC/Examples/Development Systems/EasyPIC v8/Water Sensor/Water_sensor.c"
 if ((level2 < TANK_2_MIN_WATER_LEVEL) && (level1 > TANK_1_MIN_WATER_LEVEL))
 {PORTD = PORTD & 0xEF;}


 else if (level2 > TANK_2_MAX_WATER_LEVEL || level1 < TANK_1_MIN_WATER_LEVEL)
 {PORTD = PORTD | 0x10;}



 if (temp1 <= TANK_MIN_TEMPERATURE)

 {PORTD = PORTD | 0x20;}

 else

 {PORTD = PORTD & 0xDF;}


 myascii(level1);


 delay(50);
 USART_send('\n');
 USART_send('l');
 USART_send('e');
 USART_send('v');
 USART_send('e');
 USART_send('l');
 USART_send('1');
 USART_send(':');
 USART_send(' ');
 USART_send(ascii[0]);
 USART_send(ascii[1]);
 delay(50);


 myascii(level2);


 delay(50);
 USART_send('\n');
 USART_send('l');
 USART_send('e');
 USART_send('v');
 USART_send('e');
 USART_send('l');
 USART_send('2');
 USART_send(':');
 USART_send(' ');
 USART_send(ascii[0]);
 USART_send(ascii[1]);
 delay(50);


 myascii(temp1);


 delay(50);
 USART_send('\n');
 USART_send('t');
 USART_send('e');
 USART_send('m');
 USART_send('p');
 USART_send(':');
 USART_send(' ');
 USART_send(ascii[0]);
 USART_send(ascii[1]);
 USART_send('\n');
 delay(50);
#line 392 "C:/Users/Public/Documents/Mikroelektronika/mikroC PRO for PIC/Examples/Development Systems/EasyPIC v8/Water Sensor/Water_sensor.c"
}



int main(void) {

 setup();


 while (1) {
 loop();
 asm{sleep}
 }

 return 0;
}
