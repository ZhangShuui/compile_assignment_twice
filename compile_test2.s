	.arch armv7-a
	.text
.section	.rodata
_str:
	.ascii	"%d\012\000"

factorial:
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	sub	sp, sp, #20
	str	r0, [fp, #-16]
	mov	r3, #1
	str	r3, [fp, #-12]
	str	r3, [fp, #-8]
	b	.L1
.L0:
	ldr	r3, [fp, #-12]
	ldr	r2, [fp, #-8]
	mul	r3, r2, r3
	str	r3, [fp, #-12]
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
.L1:
	ldr	r2, [fp, #-8]
	ldr	r3, [fp, #-16]
	cmp	r2, r3
	ble	.L0
	ldr	r3, [fp, #-12]
	mov	r0, r3
	add	sp, fp, #0
	ldr	fp, [sp], #4
	bx	lr
	
C:
	push	{r4, r5, fp, lr}
	add	fp, sp, #12
	sub	sp, sp, #8
	str	r0, [fp, #-16]
	str	r1, [fp, #-20]
	ldr	r0, [fp, #-16]
	bl	factorial
	mov	r5, r0
	ldr	r0, [fp, #-20]
	bl	factorial
	mov	r4, r0
	ldr	r2, [fp, #-16]
	ldr	r3, [fp, #-20]
	sub	r3, r2, r3
	mov	r0, r3
	bl	factorial
	mov	r3, r0
	mul	r3, r3, r4
	mov	r1, r3
	mov	r0, r5
	bl	__aeabi_idiv
	mov	r3, r0
	mov	r0, r3
	sub	sp, fp, #12
	pop	{r4, r5, fp, pc}

	.global	main
	.type	main, %function
main:
	push	{fp, lr}
	add	fp, sp, #4
	mov	r1, #2
	mov	r0, #10
	bl	C
	mov	r1, r0
	ldr r0, _bridge
	bl	printf
	mov	r0, #0
	pop	{fp, pc}
_bridge:
	.word	_str
	.section	.note.GNU-stack,"",%progbits
