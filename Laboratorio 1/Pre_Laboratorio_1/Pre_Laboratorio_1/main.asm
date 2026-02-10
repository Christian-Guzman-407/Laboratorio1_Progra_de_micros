; PreLab01.asm
;
; Created: 1/02/2026 06:22:56 p. m.
; Author : Christian Guzmán
;
/**************/
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
	//LDI		R16, 0X00
	//STS		UCSR0B, R16

	LDI		R17, 0X00 ; contador 1
	// Declarar el PORTC como entrada
	LDI		R31, 0x00
	OUT		DDRC, R31

	// Pull-ups
	LDI		R31, 0X3
	OUT		PORTC, R31

	//ldi		r29, 0xff
	//out		portb, r31

	// Declarar el PORTB como salida
	LDI		R30, 0xFF
	OUT		DDRB, R30

	// Encender todos los leds
	LDI		R29, 0X00
	OUT		PORTB, R29
	
	RJMP	basico

basico:
	// Verifico si el boton aumentar está pulsado
	SBIS	PINC, PC0
	CALL	aumentar

	// Verifico si el boton decrementar está pulsado
	SBIS	PINC, PC1
	CALL	decrementar
	
	RJMP	basico

aumentar:
	CALL	delay ; Llamo un delay para evitar el anti-rebote
	INC		R17 ; Incrementa 1 a R17
	ANDI	R17, 0X0F ; Esto sirve para que el contador se reinicie cuando llegue a su valor máximo
	OUT		PORTB, R17 ; Despliega el valor de R17 al PORTB
	RJMP	basico

decrementar:
	CALL	delay ; Llamo un delay para evitar el anti-rebote
	DEC		R17 ; Decrementa 1 a R17
	ANDI	R17, 0X0F
	OUT		PORTB, R17
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