	.globl binary_search
binary_search:
	mov r3, #0			// start_index
	sub r4, r2, #1			// end_index
	mov r5, r4, lsr #1		// middle_index
	mov r6, #-1			// key_index
	mov r7, #1			// num_iters

loop:
	cmp r6, #-1
	bne exit 		// Exit loop when key_index is found

	ldr r8, [r0, r5, lsl #2] // numbers[middle_index]

	cmp r3, r4 		// First if
	ble else_if_1
	b exit

else_if_1:	
	cmp r8, r1
	bne else_if_2
	mov r6, r5
	b end_of_cycle

else_if_2:
	cmp r8, r1
	ble else
	sub r4, r5, #1
	b end_of_cycle

else:
	add r3, r5, #1

end_of_cycle:
	rsb r9, r7, #0
	str r9, [r0, r5, lsl #2]
	sub r10, r4, r3
	add r5, r3, r10, lsr #1
	add r7, r7, #1
	b loop

exit:	
	mov r0, r6
	mov pc,lr
