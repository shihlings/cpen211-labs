	MOV R0, #40
	MOV R1, R0, LSL #1
	ADD R2, R0, R1

	CMP R0, R1
	BLT less_than
always:
	CMP R3, R0
	BEQ equal

less_than:
	AND R3, R2, R0
	B always

equal:
	MVN R4, R0
	CMP R4, R0
	BNE not_equal

function:
	MOV R5, #10
	BX R7
	
not_equal:
	MOV R5, X
	LDR R6, [R5]
	ADD R5, R5, R6
	ADD R6, R6, R0
	STR R6, [R5]

	BL function
	MOV R6, halt_func
	BLX R6
garbage:
	.word 0xffff
halt_func:
	MOV R1, #0
	HALT

X:
	.word 0x0002