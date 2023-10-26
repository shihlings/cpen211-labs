.globl binary_search
binary_search:
	//startIndex = 0
	mov r3, #0

	//endIndex = length - 1
	mov r4, r2
	ADD r4, r4, #-1

	//middleIndex = endIndex/2
	mov r5, r4, LSR #1

	//keyIndex = -1
	mov r6, #-1

	//NumIters = 1
	mov r7, #1

	//while(keyIndex == -1)
	CMP r6, #-1
	BNE Exit
Loop:	
	//if(startIndex > endIndex)
	CMP r3, r4
	//break
	BGT Exit
	
	//complare numbers[middleIndex] and  key
	LDR r8, [r0, r5, LSL #2]
	CMP r8, r1
	BGT Elseif2
	BEQ Elseif1

	//else startIndex = middleIndex + 1
	ADD r9, r5, #1
	MOV r3, r9
	B Contd
	
	//else if (numbers[middleIndex] == key)
Elseif1:
	//keyIndex = middleIndex
	MOV r6, r5
	B Contd

Elseif2:
	//endIndex = middleIndex -1
	ADD r10, r5, #-1
	MOV r4, r10
	B Contd
	
Contd:	
	//resume loop contents
	//-NumIters
	RSB r8, r7, #0
	//numbers[middleIndex] = -NumIters
	STR r8, [r0, r5, LSL #2]

	//endIndex - startIndex
	SUB r8, r4, r3
	//startIndex + (endIndex - startIndex)/2
	ADD r9, r3, r8, LSR #1
	//middleIndex = startIndex + (endIndex - startIndex)/2
	MOV r5, r9

	//NumIters++
	ADD r7, r7, #1

	//while loop condition check
	CMP r6, #-1
	BNE Exit
	B Loop
Exit:
	//store final value in r0
	mov r0, r6
	//return to original caller
	mov pc, lr
