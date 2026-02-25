;
; L_03.asm
;
; Created: 16/02/2016 07:50:17 p. m.
/*
	-Uso de la Memoria EEPROM
Conectar 8 LEDs en el puerto D (0=Enciende)
Conectar 4 Switches en el puerto B (Cerrado=0)
El programa lee la combinación de bits del puerto B,
esta combinación es la dirección en EEPROM.
Con esa dirección obtiene el dato almacenado en EEPROM,
el dato en EEPROM es desplegado en LED´s del puerto D
*/
; Author : 
;

.eseg //Datos en EEPROM
.org 0x00
dato0: .db 0b00000000 //0x00
.org 0x01
dato1: .db 0b00000001 //0x01
.org 0x02
dato2: .db 0b00000011 //0x03
.org 0x03
dato3: .db 0b00000111 //0x07
.org 0x04
dato4: .db 0b00001111 //0x0F
.org 0x05
dato5: .db 0b00011111 //0x1f
.org 0x06
dato6: .db 0b00111111 //0x3f
.org 0x07
dato7: .db 0b01111111 //0x7f
.org 0x08
dato8: .db 0b11111111 //0xFF
.org 0x09
dato9: .db 0b11111110 //0xfe
.org 0x0A
dato10: .db 0b11111100 //0xfc
.org 0x0B
dato11: .db 0b11111000 //0xf8
.org 0x0C
dato12: .db 0b11110000 //0xf0
.org 0x0D
dato13: .db 0b11100000 //0xe0
.org 0x0E
dato14: .db 0b11000000 //0xc0
.org 0x0F
dato15: .db 0b10000000 //0x80


.def temp = r16
.def entrada = r17
.def salida = r18

.cseg
.org 0x00
//Inicia Stack
	ldi r16,high(RAMEND)
	out SPH,r16
	ldi r16,low(RAMEND)
	out SPL,r16	
//Inicia Puertos
clr temp
out DDRB, temp //Puerto B como entrada
ldi temp, 0xFF
out PORTB, temp //Activa resistencias Rp
out DDRD, temp //Puerto D como salida

//Solo se usaran 16 direcciones por lo que no se requiere la parte alta de la dirección (00XXh)
//Escribimos 0x00 en la parte alta del registro de direcciones (EEARH)
ldi temp, 0x00
out EEARH, temp 

//Inicio
start:
	in entrada, PINB //Lee entrada
	andi entrada, 0b00001111 //Descarta b7-b4
	//Carga la dirección ingresada por el puerto B,
	//en la parte baja del registro de dirección de la EEPROM
	out EEARL, entrada

	//Habilita la lectura en la EEPROM con el registro EECR (EEPROM Control Register, pag.20)
	sbi EECR, EERE

	//Lee el valor de EEPROM Data Register (EEDR) en la dirección dada (EEARL)
	in temp, EEDR
	//Muestra en el puerto D el valor el valor de la EEPROM, de acuerdo a la dirección
	out PORTD, temp
    rjmp start //(continua al infinito...y...más allá)