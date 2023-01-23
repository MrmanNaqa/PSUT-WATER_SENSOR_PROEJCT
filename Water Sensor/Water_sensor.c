//Embedded Project lab.c

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#pragma config WDT = ON

// Define constants for serial comm
int i=0;
int l=0;
int t1=0;
int t2=0;
int t3=0;
int t4=0;
char ascii[10]={0};
char x;

// Define variables for minimum and maximum water levels
int TANK_1_MIN_WATER_LEVEL = 20;
int TANK_2_MIN_WATER_LEVEL = 50;
int TANK_2_MAX_WATER_LEVEL = 80;
int CONTAINER_MAX_DISTANCE = 18;

// Define variable for minimum temperature
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

 // Set the interrupt service routine
void interrupt(void) {
  // Interrupt related to TIMER 2 for the delay() function
  if (PIR1 & PIE1 & 0x02) {
    // Clear the interrupt flag (TMR2IF & 0)
    PIR1 = PIR1 & 0xFD;

    // Decrement the delay counter
    ms--;

    // If the delay is finished, disable the interrupt (TMR2IE & 0)
    if (ms == 0) PIE1 = PIE1 & 0xFD;
    }
  }



void delay(unsigned int ms1) {
     ms = ms1;
  // Set the timer period
  PR2 = 125;

  // Set the timer prescaler to 1:16, postscaler to 1:1, and timer 2 OFF (T2CKPS1 = 1)
  T2CON = 0x02;

  // Clear the timer value
  TMR2 = 0;

  // Enable timer interrupt, (TMR2IE | 1)
  PIE1 = PIE1 | 0x02;

  // Enable global interrupts (GIE & 1), Enable perifepheral interrupts (PEIE | 1)
  INTCON = INTCON | 0xC0;

  // Start the timer (TMR2ON & 1)
  T2CON = T2CON | 0x04;

  // Wait for the delay to complete
  while (ms > 0);
}



int analogRead() {
  // Initialize ADCON0, and set Clock Conversion to Fosc/16
  ADCON0 = 0x40;

  // Select the analog input channel
   ADCON0 = ADCON0 | 0x00;

  // Start the conversion
  ADCON0 = ADCON0 | 0x01;  // Enable the ADC (ADON | 1)
  ADCON0 = ADCON0 | 0x04;  // Start the conversion (GO | 1)

  // Wait for the conversion to complete
  while (ADCON0 & 0x04);

  // Delay for the ADC HW to reset
  delay(1);

  // Read the result
  return (ADRESH << 8) | ADRESL;
}



int readUltraSonicSensor(int triggerPin) {
  // select which sensor to read from
  temp = triggerpin;

  // Reset the timer
  TMR1H = 0;
  TMR1L = 0;

  // Send a pulse to the trigger pin to start the measurement
  if(temp<16)
  {
    PORTD = PORTD | 0x01;
    delay(10);
    PORTD = PORTD & 0xFE;
  // Wait for ECHO pins to become HIGH then start the timer
  while(!(PORTD & 0x02));
    // Timer on, Prescaler of 1:2, Internal clock
    T1CON = 0x19;
  // Wait for ECHO pins to become LOW then stop the timer
  while (PORTD & 0x02);
    // Stop the timer (T1CON & 0)
    T1CON = 0x18;
  }
  if(temp>15)
  {
    PORTD = PORTD | 0x04; //0000 0010
    delay(10);
    PORTD = PORTD & 0xFB; //1111 1101
  // Wait for ECHO pins to become HIGH then start the timer
  while(!(PORTD & 0x08));
    // Timer on, Prescaler of 1:2, Internal clock
    T1CON = 0x19;
  // Wait for ECHO pins to become LOW then stop the timer
  while (PORTD & 0x08);
    // Stop the timer (T1CON & 0)
    T1CON =0x18;
  }


  // Get the timer value
  duration=((TMR1H<<8)|TMR1L);

  // Reset the timer
  TMR1H = 0;
  TMR1L = 0;

  // Convert the duration to a distance in centimeters
  Distance = ((duration * 34) / (1000) / 2);

  // Return the Ultra sonic reading as a percentage of how much the tank is full where 100% means full and 0% means empty
  return (((CONTAINER_MAX_DISTANCE - Distance) * 100 )/ 18) ;
}



int readTemperatureSensor() {
  // Read the analog value from the sensor
  sensorValue = analogRead();

  // Convert the analog value to a temperature in degrees Celsius
  // Voltage Range on the pin (2000mV -> 5000mV)
  // Sensor Range (0C -> 100C)
  // Stepsize = 3000/1023 and we multiply by the ADC output to get the sensor reading in C
  temprature = ((sensorValue * 3000) / 1023.0);

  return temprature;
}

void USART_send(char x){
    while(!(TXSTA&0x02)); // Wait for previous transmission to complete
        TXREG = x; // Send next character
        //delay(1); *DEBUGGING*
}




void setup() {
// PORTA is INPUT
TRISA = 0xFF;
PORTA = 0x00;
TRISA = 0x00;

// PORTB is OUTPUT *DEBUGGING*
TRISB = 0x00;


// PORTD IO
TRISD = 0X0A;

// Configure WDT prescaler to 1:128 for 2.3 seconds sleep period
OPTION_REG=0x0F;

// Assigned Pins:
  // UltraSonic Sensors:
    // PORT D : 0000 1010
    // TRIGGER_1_PIN  (RD0) - OUTPUT
    // ECHO_1_PIN  (RD1) - INPUT
    // TRIGGER_2_PIN 16 (RD2) - OUTPUT
    // ECHO_2_PIN  (RD3) - INPUT
  // Temprature Sensors:
    // TEMP_1_PIN  (RA0) - INPUT
  // Pump Pins:
    // PUMP_PIN  (RD4) - OUTPUT
  // BUZZER Pins:
    // BUZZER_PIN  (RD5) - OUTPUT
  // Serial Pins:
    // TX_PIN (RC6) - OUTPUT
    // RX_PIN (RC7) - INPUT

  //Analog Config
    // Set all channels to Analog, 500 KHz, right justified**
    ADCON1 = 0xC4;
    CCP1CON = 0X00;
    PORTD = PORTD | 0x10;

  // Initialize UART communication
    // Configure Rx pin as input and Tx as output
    TRISC=0x80;
    // Asynchronous mode, 8-bit data & enable transmitter
    TXSTA=(1<<5);
    // Enable Serial Port and 8-bit continuous receive
    RCSTA=(1<<7) | (1<<4);
    // baud rate @8Mhz Clock
    SPBRG = (8000000UL/(long)(64UL*9600))-1;
    // Delay for the bluetooth signal to stabalize
    delay(300);
}

void myascii(int t1){
     t2=0;
     t3=0;
     t4=0;
     if(t1>>31)
     {
     // CONVERTING 2's complement value to normal value
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
  // Read the water level in tank 1
  level1 =  readUltraSonicSensor(15);

/* *DEBUGGING*
  PORTD = PORTD | 0x40;
  delay(500);
*/
  // Read the water level in tank 2
  level2 =  readUltraSonicSensor(16);

/* *DEBUGGING*
  PORTD = PORTD & 0xBF;
  PORTD = PORTD | 0x80;
  delay(500);
*/

  // Read the temperature in tank 1
  temp1 = readTemperatureSensor();

/* *DEBUGGING*
   if (level2 > 20)
   PORTB = PORTB | 0x01;
   else
   PORTB = PORTB & 0xFE;
   if (level2 > 40)
   PORTB = PORTB | 0x02;
   else
   PORTB = PORTB & 0xFD;
   if (level2 > 60)
   PORTB = PORTB | 0x04;
   else
   PORTB = PORTB & 0xFB;

   if (level1 > 20)
   PORTB = PORTB | 0x10;
   else
   PORTB = PORTB & 0xEF;
   if (level1 > 40)
   PORTB = PORTB | 0x20;
   else
   PORTB = PORTB & 0xDF;
   if (level1 > 60)
   PORTB = PORTB | 0x40;
   else
   PORTB = PORTB & 0xBF;
*/


  // If the water level in tank 2 is less than 50% and the water level in tank 1 is more than 20%
  if ((level2 < TANK_2_MIN_WATER_LEVEL) && (level1 > TANK_1_MIN_WATER_LEVEL))
    {PORTD = PORTD & 0xEF;}   // Turn on the pump

  // If the water level in tank 2 is more than 90%
  else if (level2 > TANK_2_MAX_WATER_LEVEL || level1 < TANK_1_MIN_WATER_LEVEL)
    {PORTD = PORTD | 0x10;}  // Turn off the pump


  // If the temperature in either tank is equal to or lower than 0
  if (temp1 <= TANK_MIN_TEMPERATURE)
    // Turn on the buzzer
    {PORTD = PORTD | 0x20;}

  else
    // Turn off the buzzer
    {PORTD = PORTD & 0xDF;}

  // Convert Ultra Sonic reading in tank1 to ascii
  myascii(level1);

  // Send level1 readings to the serial communication pins for the bluetooth transmitter
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

  // Convert Ultra Sonic reading in tank2 to ascii
  myascii(level2);

  // Send level2 readings to the serial communication pins for the bluetooth transmitter
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

  // Convert temprature sensor reading to ascii
  myascii(temp1);

  // Send temprature readings to the serial communication pins for the bluetooth transmitter
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


/* *DEBUGGING*
  PORTD = PORTD | 0xC0;
  delay(500);
  PORTD = PORTD & 0x3F;
*/
}



int main(void) {
  // Initialize the microcontroller
  setup();

  // Run the main loop
  while (1) {
    loop();
    asm{sleep}
  }

  return 0;
}