;
; L_04.asm
;
; Created: 3/06/2022 11:02:17 a. m.
; Author : jlb
;
.def temporal=r16
.def repeticiones=r17
.def valor_del_contador=r18

;Segmento de código
.cseg
.org 0x00
	;Inicia Stack
	ldi temporal,high(RAMEND)
	out SPH,temporal
	ldi temporal,low(RAMEND)
	out SPL,temporal
	;Inicia pin5 del puertoB
	//sbi DDRB,PB5 ;PB5(SCK) como salida
	ldi r16,0b00100000
	out DDRB,r16
	;Inicia TIMER0
	ldi temporal,1 << CS02 | 1 << CS00 ;Precaler a 1024
	out TCCR0B, temporal	
	;Valores del contador y las repeticiones para
	;obtener un pulso de 200ms			
	;fosc(usando prescaler)= 16,000,000 s/1024 = 15,625 s = 15.625ms
	;Valor del contador = 200ms*15.625ms = 3,125
	;Como el registro es de 8 bits,no puede contar hasta 7,812.5
	;entinces se requieren 3,125/250=12.5 aprox 12 repeticiones
	;de contar 250
			
start:
	in	R16,PINB
	andi r16,0b00011000
	brne start	   	
	sbi PORTB,PB5	;escribe 1 en el pin 5
	rcall delay		;espera 200ms
	cbi PORTB,PB5	;escribe 0 en el pin 5
	rcall delay		;espera 200ms
	rjmp start

//Subrutinas
; Rutina de retardo usando el TIMER0
Delay:
	ldi valor_del_contador,0
	out TCNT0,valor_del_contador ; Inicia contador en 0
	ldi repeticiones,0;
ciclo:
	in valor_del_contador,TCNT0
	cpi valor_del_contador,250
	brne ciclo
	ldi valor_del_contador,0
	out TCNT0,valor_del_contador ; Inicia contador en 0
	inc repeticiones
	cpi repeticiones,12
	brne ciclo
	ret	;Fin de la rutina