;
; L_02.asm
;
; 
/*
	1.SRAM memory
	-Data memory map (pag. 18)
		- 32 address General Purpose Registers
		- 64 I/O registers (pag.309)
		- 1024 internal data 
		- Addressing modes: 
			-Direct
			-Indirect with displacement
			-Indirect
			-Indirect with pre-decrement
			-Indirect with post-increment
	2. Variables declaration		
	3. addressing modes
		-Data Direct Addressing (lds Rd,K and lds K,Rr)
		-I/O Direct Addressing
		-Data indirect addressing (X=r27:r26,Y=r29:r28 or Z=r31:r30 as pointers)
*/
; Author : jlb
;

;Inicio de variables
.dseg
.org 0x0100
mi_variable:		.byte	1 
mi_otra_variable:	.byte	3 
mi_variable_2:		.byte	1

; Inicia segmento de programa
.cseg
.org 0x0
constante_1:			.db	0x15,6 
constante_2:			.db "ABCDEF"
constante_3:			.dw	0x1234
constante_4:			.dw	0x55
constante_5:			.dw 0x6677

;init stack
	ldi r16,high(RAMEND)
	out SPH,r16
	ldi r16,low(RAMEND)
	out SPL,r16		;I/O Direct Addressing
;main program
start:
	;Data direct addressing
	ldi r16,0x25
	sts mi_variable,r16 
	lds r17,mi_variable
	ldi r17,0x69
	sts mi_otra_variable,r17
	ldi r16,0x55
	sts mi_variable_2,r16

	;Data indirect addressing
	ldi XH,high(mi_variable)
	ldi XL,low(mi_variable)
	ld r18,X
	ldi r18,0x77
	st X,r18

	;Data indirect with + and - and cseg acces
	ldi ZH,high(constante_5<<1)	;multiply by 2
	ldi ZL,low(constante_5<<1)	;multiply by 2
	lpm r18,Z+
	lpm r18,Z
    rjmp start
;Subrutinas
