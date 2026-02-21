;
; L_01.asm

;init code segment
.cseg
.org 0x00
;define alias for GPIO
.def temp = r16
.def counter = r17
.def multiplier = r18

;main program
	;init stack
	ldi temp,high(RAMEND) ;gets high byte
	out SPH,Temp
	ldi temp,low(RAMEND) ;gets low byte
	out SPL,temp

	;define GPIO direction(pag.85)
	;a)
	;write to bit (using 1<<PBx)
	ldi temp,0b1111_1010
	out DDRB,Temp
	ldi temp,(1<<PB0)
	out DDRB,Temp

	;b)
	;write to bit (using sbi)
	ldi temp,0b1111_1010
	out DDRB,Temp
	cbi DDRB,PB3 ;Bit 3 --> input
	sbi DDRB,PB0 ;Bit 0 -> output
	;1. requires 2 click's
	sbi PORTB,PB3 ;Activate pullup (pag.84)
start:
	ldi counter,20  ;freq1
	rcall on_off	;branch on_off

;verifies if sw is open/closed
verify_sw:
	in temp,PINB
	andi temp,0b00001000
	cpi temp,0x08
	breq start		

	ldi counter,255 ;freq2
	rcall on_off	
    rjmp verify_sw
	
;Subroutines
;****************************************
on_off:
	sbi PORTB,PB0 
	rcall delay 
	cbi PORTB,PB0 
	rcall delay 
	ret
	
;****************************************
delay:
		mov multiplier,counter
c2:		ldi temp,167
c1:		dec temp
		brne c1
		dec multiplier 
		brne c2
		ret