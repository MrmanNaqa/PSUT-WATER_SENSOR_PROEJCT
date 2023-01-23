
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Water_sensor.c,46 :: 		void interrupt(void) {
;Water_sensor.c,48 :: 		if (PIR1 & PIE1 & 0x02) {
	MOVF       PIE1+0, 0
	ANDWF      PIR1+0, 0
	MOVWF      R1+0
	BTFSS      R1+0, 1
	GOTO       L_interrupt0
;Water_sensor.c,50 :: 		PIR1 = PIR1 & 0xFD;
	MOVLW      253
	ANDWF      PIR1+0, 1
;Water_sensor.c,53 :: 		ms--;
	MOVLW      1
	SUBWF      _ms+0, 1
	BTFSS      STATUS+0, 0
	DECF       _ms+1, 1
;Water_sensor.c,56 :: 		if (ms == 0) PIE1 = PIE1 & 0xFD;
	MOVLW      0
	XORWF      _ms+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt44
	MOVLW      0
	XORWF      _ms+0, 0
L__interrupt44:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt1
	MOVLW      253
	ANDWF      PIE1+0, 1
L_interrupt1:
;Water_sensor.c,57 :: 		}
L_interrupt0:
;Water_sensor.c,58 :: 		}
L_end_interrupt:
L__interrupt43:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_delay:

;Water_sensor.c,62 :: 		void delay(unsigned int ms1) {
;Water_sensor.c,63 :: 		ms = ms1;
	MOVF       FARG_delay_ms1+0, 0
	MOVWF      _ms+0
	MOVF       FARG_delay_ms1+1, 0
	MOVWF      _ms+1
;Water_sensor.c,65 :: 		PR2 = 125;
	MOVLW      125
	MOVWF      PR2+0
;Water_sensor.c,68 :: 		T2CON = 0x02;
	MOVLW      2
	MOVWF      T2CON+0
;Water_sensor.c,71 :: 		TMR2 = 0;
	CLRF       TMR2+0
;Water_sensor.c,74 :: 		PIE1 = PIE1 | 0x02;
	BSF        PIE1+0, 1
;Water_sensor.c,77 :: 		INTCON = INTCON | 0xC0;
	MOVLW      192
	IORWF      INTCON+0, 1
;Water_sensor.c,80 :: 		T2CON = T2CON | 0x04;
	BSF        T2CON+0, 2
;Water_sensor.c,83 :: 		while (ms > 0);
L_delay2:
	MOVF       _ms+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__delay46
	MOVF       _ms+0, 0
	SUBLW      0
L__delay46:
	BTFSC      STATUS+0, 0
	GOTO       L_delay3
	GOTO       L_delay2
L_delay3:
;Water_sensor.c,84 :: 		}
L_end_delay:
	RETURN
; end of _delay

_analogRead:

;Water_sensor.c,88 :: 		int analogRead() {
;Water_sensor.c,90 :: 		ADCON0 = 0x40;
	MOVLW      64
	MOVWF      ADCON0+0
;Water_sensor.c,93 :: 		ADCON0 = ADCON0 | 0x00;
;Water_sensor.c,96 :: 		ADCON0 = ADCON0 | 0x01;  // Enable the ADC (ADON | 1)
	BSF        ADCON0+0, 0
;Water_sensor.c,97 :: 		ADCON0 = ADCON0 | 0x04;  // Start the conversion (GO | 1)
	BSF        ADCON0+0, 2
;Water_sensor.c,100 :: 		while (ADCON0 & 0x04);
L_analogRead4:
	BTFSS      ADCON0+0, 2
	GOTO       L_analogRead5
	GOTO       L_analogRead4
L_analogRead5:
;Water_sensor.c,103 :: 		delay(1);
	MOVLW      1
	MOVWF      FARG_delay_ms1+0
	MOVLW      0
	MOVWF      FARG_delay_ms1+1
	CALL       _delay+0
;Water_sensor.c,106 :: 		return (ADRESH << 8) | ADRESL;
	MOVF       ADRESH+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       ADRESL+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
;Water_sensor.c,107 :: 		}
L_end_analogRead:
	RETURN
; end of _analogRead

_readUltraSonicSensor:

;Water_sensor.c,111 :: 		int readUltraSonicSensor(int triggerPin) {
;Water_sensor.c,113 :: 		temp = triggerpin;
	MOVF       FARG_readUltraSonicSensor_triggerPin+0, 0
	MOVWF      _temp+0
	MOVF       FARG_readUltraSonicSensor_triggerPin+1, 0
	MOVWF      _temp+1
;Water_sensor.c,116 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;Water_sensor.c,117 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;Water_sensor.c,120 :: 		if(temp<16)
	MOVLW      128
	XORWF      FARG_readUltraSonicSensor_triggerPin+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__readUltraSonicSensor49
	MOVLW      16
	SUBWF      FARG_readUltraSonicSensor_triggerPin+0, 0
L__readUltraSonicSensor49:
	BTFSC      STATUS+0, 0
	GOTO       L_readUltraSonicSensor6
;Water_sensor.c,122 :: 		PORTD = PORTD | 0x01;
	BSF        PORTD+0, 0
;Water_sensor.c,123 :: 		delay(10);
	MOVLW      10
	MOVWF      FARG_delay_ms1+0
	MOVLW      0
	MOVWF      FARG_delay_ms1+1
	CALL       _delay+0
;Water_sensor.c,124 :: 		PORTD = PORTD & 0xFE;
	MOVLW      254
	ANDWF      PORTD+0, 1
;Water_sensor.c,126 :: 		while(!(PORTD & 0x02));
L_readUltraSonicSensor7:
	BTFSC      PORTD+0, 1
	GOTO       L_readUltraSonicSensor8
	GOTO       L_readUltraSonicSensor7
L_readUltraSonicSensor8:
;Water_sensor.c,128 :: 		T1CON = 0x19;
	MOVLW      25
	MOVWF      T1CON+0
;Water_sensor.c,130 :: 		while (PORTD & 0x02);
L_readUltraSonicSensor9:
	BTFSS      PORTD+0, 1
	GOTO       L_readUltraSonicSensor10
	GOTO       L_readUltraSonicSensor9
L_readUltraSonicSensor10:
;Water_sensor.c,132 :: 		T1CON = 0x18;
	MOVLW      24
	MOVWF      T1CON+0
;Water_sensor.c,133 :: 		}
L_readUltraSonicSensor6:
;Water_sensor.c,134 :: 		if(temp>15)
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _temp+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__readUltraSonicSensor50
	MOVF       _temp+0, 0
	SUBLW      15
L__readUltraSonicSensor50:
	BTFSC      STATUS+0, 0
	GOTO       L_readUltraSonicSensor11
;Water_sensor.c,136 :: 		PORTD = PORTD | 0x04; //0000 0010
	BSF        PORTD+0, 2
;Water_sensor.c,137 :: 		delay(10);
	MOVLW      10
	MOVWF      FARG_delay_ms1+0
	MOVLW      0
	MOVWF      FARG_delay_ms1+1
	CALL       _delay+0
;Water_sensor.c,138 :: 		PORTD = PORTD & 0xFB; //1111 1101
	MOVLW      251
	ANDWF      PORTD+0, 1
;Water_sensor.c,140 :: 		while(!(PORTD & 0x08));
L_readUltraSonicSensor12:
	BTFSC      PORTD+0, 3
	GOTO       L_readUltraSonicSensor13
	GOTO       L_readUltraSonicSensor12
L_readUltraSonicSensor13:
;Water_sensor.c,142 :: 		T1CON = 0x19;
	MOVLW      25
	MOVWF      T1CON+0
;Water_sensor.c,144 :: 		while (PORTD & 0x08);
L_readUltraSonicSensor14:
	BTFSS      PORTD+0, 3
	GOTO       L_readUltraSonicSensor15
	GOTO       L_readUltraSonicSensor14
L_readUltraSonicSensor15:
;Water_sensor.c,146 :: 		T1CON =0x18;
	MOVLW      24
	MOVWF      T1CON+0
;Water_sensor.c,147 :: 		}
L_readUltraSonicSensor11:
;Water_sensor.c,151 :: 		duration=((TMR1H<<8)|TMR1L);
	CLRF       _duration+3
	MOVF       TMR1H+1, 0
	MOVWF      _duration+2
	MOVF       TMR1H+0, 0
	MOVWF      _duration+1
	CLRF       _duration+0
	MOVF       TMR1L+0, 0
	IORWF      _duration+0, 1
	MOVLW      0
	IORWF      _duration+1, 1
	MOVLW      0
	MOVWF      _duration+2
	MOVWF      _duration+3
;Water_sensor.c,154 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;Water_sensor.c,155 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;Water_sensor.c,158 :: 		Distance = ((duration * 34) / (1000) / 2);
	MOVF       _duration+0, 0
	MOVWF      R0+0
	MOVF       _duration+1, 0
	MOVWF      R0+1
	MOVF       _duration+2, 0
	MOVWF      R0+2
	MOVF       _duration+3, 0
	MOVWF      R0+3
	MOVLW      34
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Mul_32x32_U+0
	MOVLW      232
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Div_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      R4+0
	MOVF       R0+1, 0
	MOVWF      R4+1
	MOVF       R0+2, 0
	MOVWF      R4+2
	MOVF       R0+3, 0
	MOVWF      R4+3
	RRF        R4+3, 1
	RRF        R4+2, 1
	RRF        R4+1, 1
	RRF        R4+0, 1
	BCF        R4+3, 7
	MOVF       R4+0, 0
	MOVWF      _Distance+0
	MOVF       R4+1, 0
	MOVWF      _Distance+1
;Water_sensor.c,161 :: 		return (((CONTAINER_MAX_DISTANCE - Distance) * 100 )/ 18) ;
	MOVF       R4+0, 0
	SUBWF      _CONTAINER_MAX_DISTANCE+0, 0
	MOVWF      R0+0
	MOVF       R4+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      _CONTAINER_MAX_DISTANCE+1, 0
	MOVWF      R0+1
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVLW      18
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
;Water_sensor.c,162 :: 		}
L_end_readUltraSonicSensor:
	RETURN
; end of _readUltraSonicSensor

_readTemperatureSensor:

;Water_sensor.c,166 :: 		int readTemperatureSensor() {
;Water_sensor.c,168 :: 		sensorValue = analogRead();
	CALL       _analogRead+0
	MOVF       R0+0, 0
	MOVWF      _sensorValue+0
	MOVF       R0+1, 0
	MOVWF      _sensorValue+1
;Water_sensor.c,174 :: 		temprature = ((sensorValue * 3000) / 1023.0);
	MOVLW      184
	MOVWF      R4+0
	MOVLW      11
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	CALL       _word2double+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      192
	MOVWF      R4+1
	MOVLW      127
	MOVWF      R4+2
	MOVLW      136
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	CALL       _double2word+0
	MOVF       R0+0, 0
	MOVWF      _temprature+0
	MOVF       R0+1, 0
	MOVWF      _temprature+1
;Water_sensor.c,176 :: 		return temprature;
;Water_sensor.c,177 :: 		}
L_end_readTemperatureSensor:
	RETURN
; end of _readTemperatureSensor

_USART_send:

;Water_sensor.c,179 :: 		void USART_send(char x){
;Water_sensor.c,180 :: 		while(!(TXSTA&0x02)); // Wait for previous transmission to complete
L_USART_send16:
	BTFSC      TXSTA+0, 1
	GOTO       L_USART_send17
	GOTO       L_USART_send16
L_USART_send17:
;Water_sensor.c,181 :: 		TXREG = x; // Send next character
	MOVF       FARG_USART_send_x+0, 0
	MOVWF      TXREG+0
;Water_sensor.c,183 :: 		}
L_end_USART_send:
	RETURN
; end of _USART_send

_setup:

;Water_sensor.c,188 :: 		void setup() {
;Water_sensor.c,190 :: 		TRISA = 0xFF;
	MOVLW      255
	MOVWF      TRISA+0
;Water_sensor.c,191 :: 		PORTA = 0x00;
	CLRF       PORTA+0
;Water_sensor.c,192 :: 		TRISA = 0x00;
	CLRF       TRISA+0
;Water_sensor.c,195 :: 		TRISB = 0x00;
	CLRF       TRISB+0
;Water_sensor.c,199 :: 		TRISD = 0X0A;
	MOVLW      10
	MOVWF      TRISD+0
;Water_sensor.c,202 :: 		OPTION_REG=0x0F;
	MOVLW      15
	MOVWF      OPTION_REG+0
;Water_sensor.c,223 :: 		ADCON1 = 0xC4;
	MOVLW      196
	MOVWF      ADCON1+0
;Water_sensor.c,224 :: 		CCP1CON = 0X00;
	CLRF       CCP1CON+0
;Water_sensor.c,225 :: 		PORTD = PORTD | 0x10;
	BSF        PORTD+0, 4
;Water_sensor.c,229 :: 		TRISC=0x80;
	MOVLW      128
	MOVWF      TRISC+0
;Water_sensor.c,231 :: 		TXSTA=(1<<5);
	MOVLW      32
	MOVWF      TXSTA+0
;Water_sensor.c,233 :: 		RCSTA=(1<<7) | (1<<4);
	MOVLW      144
	MOVWF      RCSTA+0
;Water_sensor.c,235 :: 		SPBRG = (8000000UL/(long)(64UL*9600))-1;
	MOVLW      12
	MOVWF      SPBRG+0
;Water_sensor.c,237 :: 		delay(300);
	MOVLW      44
	MOVWF      FARG_delay_ms1+0
	MOVLW      1
	MOVWF      FARG_delay_ms1+1
	CALL       _delay+0
;Water_sensor.c,238 :: 		}
L_end_setup:
	RETURN
; end of _setup

_myascii:

;Water_sensor.c,240 :: 		void myascii(int t1){
;Water_sensor.c,241 :: 		t2=0;
	CLRF       _t2+0
	CLRF       _t2+1
;Water_sensor.c,242 :: 		t3=0;
	CLRF       _t3+0
	CLRF       _t3+1
;Water_sensor.c,243 :: 		t4=0;
	CLRF       _t4+0
	CLRF       _t4+1
;Water_sensor.c,244 :: 		if(t1>>31)
	MOVLW      0
	BTFSC      FARG_myascii_t1+1, 7
	MOVLW      255
	MOVWF      R0+0
	MOVWF      R0+1
	MOVF       R0+0, 0
	IORWF      R0+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_myascii18
;Water_sensor.c,247 :: 		t1=~t1+1;
	COMF       FARG_myascii_t1+0, 0
	MOVWF      R0+0
	COMF       FARG_myascii_t1+1, 0
	MOVWF      R0+1
	INCF       R0+0, 1
	BTFSC      STATUS+0, 2
	INCF       R0+1, 1
	MOVF       R0+0, 0
	MOVWF      FARG_myascii_t1+0
	MOVF       R0+1, 0
	MOVWF      FARG_myascii_t1+1
;Water_sensor.c,248 :: 		for(t2=t1;t2!=0;t2/=10,t3++);
	MOVF       R0+0, 0
	MOVWF      _t2+0
	MOVF       R0+1, 0
	MOVWF      _t2+1
L_myascii19:
	MOVLW      0
	XORWF      _t2+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__myascii55
	MOVLW      0
	XORWF      _t2+0, 0
L__myascii55:
	BTFSC      STATUS+0, 2
	GOTO       L_myascii20
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _t2+0, 0
	MOVWF      R0+0
	MOVF       _t2+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	MOVWF      _t2+0
	MOVF       R0+1, 0
	MOVWF      _t2+1
	INCF       _t3+0, 1
	BTFSC      STATUS+0, 2
	INCF       _t3+1, 1
	GOTO       L_myascii19
L_myascii20:
;Water_sensor.c,249 :: 		ascii[0]=0x2D;
	MOVLW      45
	MOVWF      _ascii+0
;Water_sensor.c,250 :: 		t3++;
	INCF       _t3+0, 1
	BTFSC      STATUS+0, 2
	INCF       _t3+1, 1
;Water_sensor.c,251 :: 		t4=1;
	MOVLW      1
	MOVWF      _t4+0
	MOVLW      0
	MOVWF      _t4+1
;Water_sensor.c,252 :: 		}
	GOTO       L_myascii22
L_myascii18:
;Water_sensor.c,254 :: 		for(t2=t1;t2!=0;t2/=10,t3++);
	MOVF       FARG_myascii_t1+0, 0
	MOVWF      _t2+0
	MOVF       FARG_myascii_t1+1, 0
	MOVWF      _t2+1
L_myascii23:
	MOVLW      0
	XORWF      _t2+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__myascii56
	MOVLW      0
	XORWF      _t2+0, 0
L__myascii56:
	BTFSC      STATUS+0, 2
	GOTO       L_myascii24
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _t2+0, 0
	MOVWF      R0+0
	MOVF       _t2+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	MOVWF      _t2+0
	MOVF       R0+1, 0
	MOVWF      _t2+1
	INCF       _t3+0, 1
	BTFSC      STATUS+0, 2
	INCF       _t3+1, 1
	GOTO       L_myascii23
L_myascii24:
L_myascii22:
;Water_sensor.c,255 :: 		for(i=t3-1,t2=t1;i>=t4;i--)
	MOVLW      1
	SUBWF      _t3+0, 0
	MOVWF      _i+0
	MOVLW      0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      _t3+1, 0
	MOVWF      _i+1
	MOVF       FARG_myascii_t1+0, 0
	MOVWF      _t2+0
	MOVF       FARG_myascii_t1+1, 0
	MOVWF      _t2+1
L_myascii26:
	MOVLW      128
	XORWF      _i+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORWF      _t4+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__myascii57
	MOVF       _t4+0, 0
	SUBWF      _i+0, 0
L__myascii57:
	BTFSS      STATUS+0, 0
	GOTO       L_myascii27
;Water_sensor.c,258 :: 		ascii[i]=(t2%10)+0x30;
	MOVF       _i+0, 0
	ADDLW      _ascii+0
	MOVWF      FLOC__myascii+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _t2+0, 0
	MOVWF      R0+0
	MOVF       _t2+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVLW      48
	ADDWF      R0+0, 1
	MOVF       FLOC__myascii+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;Water_sensor.c,259 :: 		t2/=10;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _t2+0, 0
	MOVWF      R0+0
	MOVF       _t2+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	MOVWF      _t2+0
	MOVF       R0+1, 0
	MOVWF      _t2+1
;Water_sensor.c,255 :: 		for(i=t3-1,t2=t1;i>=t4;i--)
	MOVLW      1
	SUBWF      _i+0, 1
	BTFSS      STATUS+0, 0
	DECF       _i+1, 1
;Water_sensor.c,260 :: 		}
	GOTO       L_myascii26
L_myascii27:
;Water_sensor.c,262 :: 		}
L_end_myascii:
	RETURN
; end of _myascii

_loop:

;Water_sensor.c,266 :: 		void loop() {
;Water_sensor.c,268 :: 		level1 =  readUltraSonicSensor(15);
	MOVLW      15
	MOVWF      FARG_readUltraSonicSensor_triggerPin+0
	MOVLW      0
	MOVWF      FARG_readUltraSonicSensor_triggerPin+1
	CALL       _readUltraSonicSensor+0
	MOVF       R0+0, 0
	MOVWF      _level1+0
	MOVF       R0+1, 0
	MOVWF      _level1+1
;Water_sensor.c,275 :: 		level2 =  readUltraSonicSensor(16);
	MOVLW      16
	MOVWF      FARG_readUltraSonicSensor_triggerPin+0
	MOVLW      0
	MOVWF      FARG_readUltraSonicSensor_triggerPin+1
	CALL       _readUltraSonicSensor+0
	MOVF       R0+0, 0
	MOVWF      _level2+0
	MOVF       R0+1, 0
	MOVWF      _level2+1
;Water_sensor.c,284 :: 		temp1 = readTemperatureSensor();
	CALL       _readTemperatureSensor+0
	MOVF       R0+0, 0
	MOVWF      _temp1+0
	MOVF       R0+1, 0
	MOVWF      _temp1+1
;Water_sensor.c,316 :: 		if ((level2 < TANK_2_MIN_WATER_LEVEL) && (level1 > TANK_1_MIN_WATER_LEVEL))
	MOVF       _TANK_2_MIN_WATER_LEVEL+1, 0
	SUBWF      _level2+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__loop59
	MOVF       _TANK_2_MIN_WATER_LEVEL+0, 0
	SUBWF      _level2+0, 0
L__loop59:
	BTFSC      STATUS+0, 0
	GOTO       L_loop31
	MOVF       _level1+1, 0
	SUBWF      _TANK_1_MIN_WATER_LEVEL+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__loop60
	MOVF       _level1+0, 0
	SUBWF      _TANK_1_MIN_WATER_LEVEL+0, 0
L__loop60:
	BTFSC      STATUS+0, 0
	GOTO       L_loop31
L__loop41:
;Water_sensor.c,317 :: 		{PORTD = PORTD & 0xEF;}   // Turn on the pump
	MOVLW      239
	ANDWF      PORTD+0, 1
	GOTO       L_loop32
L_loop31:
;Water_sensor.c,320 :: 		else if (level2 > TANK_2_MAX_WATER_LEVEL || level1 < TANK_1_MIN_WATER_LEVEL)
	MOVF       _level2+1, 0
	SUBWF      _TANK_2_MAX_WATER_LEVEL+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__loop61
	MOVF       _level2+0, 0
	SUBWF      _TANK_2_MAX_WATER_LEVEL+0, 0
L__loop61:
	BTFSS      STATUS+0, 0
	GOTO       L__loop40
	MOVF       _TANK_1_MIN_WATER_LEVEL+1, 0
	SUBWF      _level1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__loop62
	MOVF       _TANK_1_MIN_WATER_LEVEL+0, 0
	SUBWF      _level1+0, 0
L__loop62:
	BTFSS      STATUS+0, 0
	GOTO       L__loop40
	GOTO       L_loop35
L__loop40:
;Water_sensor.c,321 :: 		{PORTD = PORTD | 0x10;}  // Turn off the pump
	BSF        PORTD+0, 4
L_loop35:
L_loop32:
;Water_sensor.c,325 :: 		if (temp1 <= TANK_MIN_TEMPERATURE)
	MOVF       _temp1+1, 0
	SUBWF      _TANK_MIN_TEMPERATURE+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__loop63
	MOVF       _temp1+0, 0
	SUBWF      _TANK_MIN_TEMPERATURE+0, 0
L__loop63:
	BTFSS      STATUS+0, 0
	GOTO       L_loop36
;Water_sensor.c,327 :: 		{PORTD = PORTD | 0x20;}
	BSF        PORTD+0, 5
	GOTO       L_loop37
L_loop36:
;Water_sensor.c,331 :: 		{PORTD = PORTD & 0xDF;}
	MOVLW      223
	ANDWF      PORTD+0, 1
L_loop37:
;Water_sensor.c,334 :: 		myascii(level1);
	MOVF       _level1+0, 0
	MOVWF      FARG_myascii_t1+0
	MOVF       _level1+1, 0
	MOVWF      FARG_myascii_t1+1
	CALL       _myascii+0
;Water_sensor.c,337 :: 		delay(50);
	MOVLW      50
	MOVWF      FARG_delay_ms1+0
	MOVLW      0
	MOVWF      FARG_delay_ms1+1
	CALL       _delay+0
;Water_sensor.c,338 :: 		USART_send('\n');
	MOVLW      10
	MOVWF      FARG_USART_send_x+0
	CALL       _USART_send+0
;Water_sensor.c,339 :: 		USART_send('l');
	MOVLW      108
	MOVWF      FARG_USART_send_x+0
	CALL       _USART_send+0
;Water_sensor.c,340 :: 		USART_send('e');
	MOVLW      101
	MOVWF      FARG_USART_send_x+0
	CALL       _USART_send+0
;Water_sensor.c,341 :: 		USART_send('v');
	MOVLW      118
	MOVWF      FARG_USART_send_x+0
	CALL       _USART_send+0
;Water_sensor.c,342 :: 		USART_send('e');
	MOVLW      101
	MOVWF      FARG_USART_send_x+0
	CALL       _USART_send+0
;Water_sensor.c,343 :: 		USART_send('l');
	MOVLW      108
	MOVWF      FARG_USART_send_x+0
	CALL       _USART_send+0
;Water_sensor.c,344 :: 		USART_send('1');
	MOVLW      49
	MOVWF      FARG_USART_send_x+0
	CALL       _USART_send+0
;Water_sensor.c,345 :: 		USART_send(':');
	MOVLW      58
	MOVWF      FARG_USART_send_x+0
	CALL       _USART_send+0
;Water_sensor.c,346 :: 		USART_send(' ');
	MOVLW      32
	MOVWF      FARG_USART_send_x+0
	CALL       _USART_send+0
;Water_sensor.c,347 :: 		USART_send(ascii[0]);
	MOVF       _ascii+0, 0
	MOVWF      FARG_USART_send_x+0
	CALL       _USART_send+0
;Water_sensor.c,348 :: 		USART_send(ascii[1]);
	MOVF       _ascii+1, 0
	MOVWF      FARG_USART_send_x+0
	CALL       _USART_send+0
;Water_sensor.c,349 :: 		delay(50);
	MOVLW      50
	MOVWF      FARG_delay_ms1+0
	MOVLW      0
	MOVWF      FARG_delay_ms1+1
	CALL       _delay+0
;Water_sensor.c,352 :: 		myascii(level2);
	MOVF       _level2+0, 0
	MOVWF      FARG_myascii_t1+0
	MOVF       _level2+1, 0
	MOVWF      FARG_myascii_t1+1
	CALL       _myascii+0
;Water_sensor.c,355 :: 		delay(50);
	MOVLW      50
	MOVWF      FARG_delay_ms1+0
	MOVLW      0
	MOVWF      FARG_delay_ms1+1
	CALL       _delay+0
;Water_sensor.c,356 :: 		USART_send('\n');
	MOVLW      10
	MOVWF      FARG_USART_send_x+0
	CALL       _USART_send+0
;Water_sensor.c,357 :: 		USART_send('l');
	MOVLW      108
	MOVWF      FARG_USART_send_x+0
	CALL       _USART_send+0
;Water_sensor.c,358 :: 		USART_send('e');
	MOVLW      101
	MOVWF      FARG_USART_send_x+0
	CALL       _USART_send+0
;Water_sensor.c,359 :: 		USART_send('v');
	MOVLW      118
	MOVWF      FARG_USART_send_x+0
	CALL       _USART_send+0
;Water_sensor.c,360 :: 		USART_send('e');
	MOVLW      101
	MOVWF      FARG_USART_send_x+0
	CALL       _USART_send+0
;Water_sensor.c,361 :: 		USART_send('l');
	MOVLW      108
	MOVWF      FARG_USART_send_x+0
	CALL       _USART_send+0
;Water_sensor.c,362 :: 		USART_send('2');
	MOVLW      50
	MOVWF      FARG_USART_send_x+0
	CALL       _USART_send+0
;Water_sensor.c,363 :: 		USART_send(':');
	MOVLW      58
	MOVWF      FARG_USART_send_x+0
	CALL       _USART_send+0
;Water_sensor.c,364 :: 		USART_send(' ');
	MOVLW      32
	MOVWF      FARG_USART_send_x+0
	CALL       _USART_send+0
;Water_sensor.c,365 :: 		USART_send(ascii[0]);
	MOVF       _ascii+0, 0
	MOVWF      FARG_USART_send_x+0
	CALL       _USART_send+0
;Water_sensor.c,366 :: 		USART_send(ascii[1]);
	MOVF       _ascii+1, 0
	MOVWF      FARG_USART_send_x+0
	CALL       _USART_send+0
;Water_sensor.c,367 :: 		delay(50);
	MOVLW      50
	MOVWF      FARG_delay_ms1+0
	MOVLW      0
	MOVWF      FARG_delay_ms1+1
	CALL       _delay+0
;Water_sensor.c,370 :: 		myascii(temp1);
	MOVF       _temp1+0, 0
	MOVWF      FARG_myascii_t1+0
	MOVF       _temp1+1, 0
	MOVWF      FARG_myascii_t1+1
	CALL       _myascii+0
;Water_sensor.c,373 :: 		delay(50);
	MOVLW      50
	MOVWF      FARG_delay_ms1+0
	MOVLW      0
	MOVWF      FARG_delay_ms1+1
	CALL       _delay+0
;Water_sensor.c,374 :: 		USART_send('\n');
	MOVLW      10
	MOVWF      FARG_USART_send_x+0
	CALL       _USART_send+0
;Water_sensor.c,375 :: 		USART_send('t');
	MOVLW      116
	MOVWF      FARG_USART_send_x+0
	CALL       _USART_send+0
;Water_sensor.c,376 :: 		USART_send('e');
	MOVLW      101
	MOVWF      FARG_USART_send_x+0
	CALL       _USART_send+0
;Water_sensor.c,377 :: 		USART_send('m');
	MOVLW      109
	MOVWF      FARG_USART_send_x+0
	CALL       _USART_send+0
;Water_sensor.c,378 :: 		USART_send('p');
	MOVLW      112
	MOVWF      FARG_USART_send_x+0
	CALL       _USART_send+0
;Water_sensor.c,379 :: 		USART_send(':');
	MOVLW      58
	MOVWF      FARG_USART_send_x+0
	CALL       _USART_send+0
;Water_sensor.c,380 :: 		USART_send(' ');
	MOVLW      32
	MOVWF      FARG_USART_send_x+0
	CALL       _USART_send+0
;Water_sensor.c,381 :: 		USART_send(ascii[0]);
	MOVF       _ascii+0, 0
	MOVWF      FARG_USART_send_x+0
	CALL       _USART_send+0
;Water_sensor.c,382 :: 		USART_send(ascii[1]);
	MOVF       _ascii+1, 0
	MOVWF      FARG_USART_send_x+0
	CALL       _USART_send+0
;Water_sensor.c,383 :: 		USART_send('\n');
	MOVLW      10
	MOVWF      FARG_USART_send_x+0
	CALL       _USART_send+0
;Water_sensor.c,384 :: 		delay(50);
	MOVLW      50
	MOVWF      FARG_delay_ms1+0
	MOVLW      0
	MOVWF      FARG_delay_ms1+1
	CALL       _delay+0
;Water_sensor.c,392 :: 		}
L_end_loop:
	RETURN
; end of _loop

_main:

;Water_sensor.c,396 :: 		int main(void) {
;Water_sensor.c,398 :: 		setup();
	CALL       _setup+0
;Water_sensor.c,401 :: 		while (1) {
L_main38:
;Water_sensor.c,402 :: 		loop();
	CALL       _loop+0
;Water_sensor.c,403 :: 		asm{sleep}
	SLEEP
;Water_sensor.c,404 :: 		}
	GOTO       L_main38
;Water_sensor.c,407 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
