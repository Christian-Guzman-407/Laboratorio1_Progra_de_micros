;
; Post_Laboratorio_01.asm
;
; Created: 8/02/2026 12:21:20 p. m.
; Author : Christian
;
// Encabezado (Definición de Registros, Variables y Constantes)
.include "M328PDEF.inc"     // Include definitions specific to ATMega328P
.dseg
.org    SRAM_START
//variable_name:     .byte   1   // Memory alocation for variable_name:     .byte   (byte size)

.cseg
.org 0x0000
 /**************/
// Configuración de la pila
LDI     R16, LOW(RAMEND)
OUT     SPL, R16
LDI     R16, HIGH(RAMEND)
OUT     SPH, R16
/**************/

/**************/
// Configuración del oscilador a 1MHz
LDI		R25, (1 << CLKPCE)
STS		CLKPR, R25
LDI		R25, 0b0000_0100
STS		CLKPR, R25
/*************/

// R17 va a ser el contador
start:

	LDI		R16, 0x00
	STS		UCSR0B, R16

	LDI		R17, 0x00 ; contador 1
	LDI		R18, 0x00 ; contador 2
	LDI		R19, 0x00 ; resultado

	LDI		R31, 0b0111_1101
	OUT		DDRD, R31
	// Declarar el PORTB y PORTC como salida de PB0 a PB3 y entradas PB4 y PB5
	LDI		R30, 0b0000_1111
	OUT		DDRB, R30
	OUT		DDRC, R30


	// Pull-ups
	LDI		R31, 0b1000_0010
	OUT		PORTD, R31
	LDI		R30, 0b0011_0000
	OUT		PORTB, R30
	OUT		PORTC, R30

	// Apagar todos los leds
	//OUT		PORTB, R18
	//OUT		PORTC, R17
	//OUT		PORTD, R19
	
	RJMP	basico

basico:
	//OUT		PORTB, R17
	//OUT		PORTD, R18
	//OUT		PORTC, R19
	
	// Verifico si el boton aumentar 1 está pulsado
	SBIS	PINC, PC4
	CALL	aumentar_1

	// Verifico si el boton decrementar 1 está pulsado
	SBIS	PINC, PC5
	CALL	decrementar_1
	
	// Verifico si el boton aumentar 2 está pulsado
	SBIS	PIND, PD1
	CALL	aumentar_2

	// Verifico si el boton decrementar 2 está pulsado
	SBIS	PINB, PB4
	CALL	decrementar_2

	// Verico si el boton resultado está pulsado
	SBIS	PIND, PD7
	CALL	resultado

	RJMP	basico

aumentar_1:
	CALL	delay ; Llamo un delay para evitar el anti-rebote
	INC		R17 ; Incrementa 1 a R17
	ANDI	R17, 0X0F ; Esto sirve para que el contador se reinicie cuando llegue a su valor máximo
	OUT		PORTC, R17 ; Despliega el valor de R17 al PORTB
	SBI		PORTC, PC4
	SBI		PORTC, PC5
	RJMP	basico
	
decrementar_1:
	CALL	delay ; Llamo un delay para evitar el anti-rebote
	DEC		R17 ; Decrementa 1 a R17
	ANDI	R17, 0X0F
	OUT		PORTC, R17
	SBI		PORTC, PC4
	SBI		PORTC, PC5
	RJMP	basico

aumentar_2:
	CALL	delay ; Llamo un delay para evitar el anti-rebote
	INC		R18 ; Incrementa 1 a R18
	ANDI	R18, 0x0F ; Esto sirve para que el contador se reinicie cuando llegue a su valor máximo
	OUT		PORTB, R18 ; Despliega el valor de R18 al PORTD
	SBI		PORTB, PB4
	SBI		PORTB, PB5
	RJMP	basico
	
decrementar_2:
	CALL	delay ; Llamo un delay para evitar el anti-rebote
	DEC		R18 ; Decrementa 1 a R18
	ANDI	R18, 0x0F
	OUT		PORTB, R18
	SBI		PORTB, PB4
	SBI		PORTB, PB5
	RJMP	basico

resultado:
	CALL	delay
	MOV		R19, R17 ; contador 1
	MOV		R24, R18 ; contador 2
	ADD		R24, R19
	//ANDI	R24, 0xFF
	//BRCS	carry
	LSL		R24
	LSL		R24
	OUT		PORTD, R24
	SBI		PORTD, PD7
	RJMP	basico

//carry:
//	LDI		R26, 0x10
//	OR		R26, R18
//	OUT		PORTD, R26
//	RJMP	resultado

// Delay para un anti-rebote
delay:
	LDI		R21, 0X00
	LDI		R22, 0X00
	//LDI		R23, 0X00
bucle:
	INC		R21
	CPI		R21, 0X00
	BRNE	bucle
	INC		R22
	CPI		R22, 0X00
	BRNE	bucle
	//INC		R23
	//CPI		R23, 0X13
	//BRNE	bucle
	RET