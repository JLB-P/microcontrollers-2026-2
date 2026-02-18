;
; L_00_CPU.asm
/*
	1.DataSheet
		-AVR CPU Core
			-pipelining
	2.View Help
		-Assembler syntax **Register restriction (0-15 & 16-31)
		-Assembler directives 
		-Expressions 
			-functions
			-operands
			-operators
	3.Environment
		-Solution explorer
	4.Build
		-Segments and %usage
	5.Debug
		-CPU
		-Flash memory map
		-I/O
		-Register address (pag.309)
*/
;
; Created: 2/17/2026 1:43:12 PM
; Author : josel
;

;define code segment starting address
.cseg
.org 0x10
start:
    inc r16
    rjmp start
