	.arch armv7-a
	.text
	.section	.rodata
_L0:
	.ascii	"%d\000"
	.align	2
	.global	fibo
fibo:
	push	{r4, fp, lr}
	add	fp, sp, #8
	sub	sp, sp, #12
	str	r0, [fp, #-16]
	ldr	r3, [fp, #-16]		@一定要将其单独存在r3中,不可直接比较,否则会陷入死循环
	cmp	r3, #1
	beq	.L1
	ldr	r3, [fp, #-16]
	cmp	r3, #0
	bne	.L2
.L1:
	mov	r3, #1
	b	.L3
.L2:
	ldr	r3, [fp, #-16]
	sub	r3, r3, #1
	mov	r0, r3
	bl	fibo
	mov	r4, r0
	ldr	r3, [fp, #-16]
	sub	r3, r3, #2
	mov	r0, r3
	bl	fibo
	mov	r3, r0
	add	r3, r4, r3
.L3:
	mov	r0, r3
	sub	sp, fp, #8
	pop	{r4, fp, pc}

	.align	2
	.global	main
main:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #8
	mov	r0, #5
	bl	fibo
	mov r1, r0
	ldr r0, _bridge
	bl	printf
	mov	r0, #0
	sub	sp, fp, #4
	pop	{fp, pc}

_bridge:
	.word	_L0
	.section	.note.GNU-stack,"",%progbits
