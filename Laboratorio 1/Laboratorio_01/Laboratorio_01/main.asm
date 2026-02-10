;
; Laboratorio_01.asm
;
; Created: 7/02/2026 07:25:15 p. m.
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

// R17 va a ser el contador
start:

	LDI		R17, 0x00 ; contador 1
	LDI		R18, 0x00 ; contador 2

	LDI		R31, 0b0011_1111
	OUT		DDRD, R31
	// Declarar el PORTB como salida de PB0 a PB3 y entradas PB4 y PB5
	LDI		R30, 0b0000_1111
	OUT		DDRB, R30

	LDI		R29, 0b0000_1111
	OUT		DDRC, R29

	//LDI		R16, 0x00
	//STS		UCSR0B, R16

	// Pull-ups
	LDI		R31, 0b1100_0000
	OUT		PORTD, R31
	//LDI		R30, 0b0000_0000
	//OUT		PORTB, R30
	LDI		R29, 0b0011_0000
	OUT		PORTC, R29

	// Apagar todos los leds
	//LDI		R30, 0b1111_0000
	//OUT		PORTB, R30
	//OUT		PORTC, R30
	
	RJMP	basico

basico:
	//OUT		PORTB, R17
	//OUT		PORTD, R18
	
	// Verifico si el boton aumentar 1 está pulsado
	SBIS	PINC, PC4
	CALL	aumentar_1

	// Verifico si el boton decrementar 1 está pulsado
	SBIS	PINC, PC5
	CALL	decrementar_1
	
	// Verifico si el boton aumentar 2 está pulsado
	SBIS	PIND, PD6
	CALL	aumentar_2

	// Verifico si el boton decrementar 2 está pulsado
	SBIS	PIND, PD7
	CALL	decrementar_2

	RJMP	basico

aumentar_1:
	CALL	delay ; Llamo un delay para evitar el anti-rebote
	INC		R17 ; Incrementa 1 a R17
	ANDI	R17, 0X0F ; Esto sirve para que el contador se reinicie cuando llegue a su valor máximo
	OUT		PORTB, R17 ; Despliega el valor de R17 al PORTB
	RJMP	basico
	
decrementar_1:
	CALL	delay ; Llamo un delay para evitar el anti-rebote
	DEC		R17 ; Decrementa 1 a R17
	ANDI	R17, 0X0F
	OUT		PORTB, R17
	RJMP	basico

aumentar_2:
	CALL	delay ; Llamo un delay para evitar el anti-rebote
	INC		R18 ; Incrementa 1 a R18
	ANDI	R18, 0x0F ; Esto sirve para que el contador se reinicie cuando llegue a su valor máximo
	MOV		R20, R18
	LSL		R20
	LSL		R20
	OUT		PORTD, R20 ; Despliega el valor de R18 al PORTC
	SBI		PORTD, PD7
	SBI		PORTD, PD6
	RJMP	basico
	
decrementar_2:
	CALL	delay ; Llamo un delay para evitar el anti-rebote
	DEC		R18 ; Decrementa 1 a R18
	ANDI	R18, 0x0F
	MOV		R20, R18
	LSL		R20
	LSL		R20
	OUT		PORTD, R20
	SBI		PORTD, PD7
	SBI		PORTD,PD6
	RJMP	basico

// Delay para un anti-rebote
delay:
	LDI		R21, 0X00
	LDI		R22, 0X00
	LDI		R23, 0X00
bucle:
	INC		R21
	CPI		R21, 0X00
	BRNE	bucle
	INC		R22
	CPI		R22, 0X00
	BRNE	bucle
	INC		R23
	CPI		R23, 0X13
	BRNE	bucle
	RET