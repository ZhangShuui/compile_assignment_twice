	.text
	.section	.rodata
_str:
	.ascii	"%d\012\000"	@ "%d\n\0"

factorial:	@ int factorial(int k) --> k!
	str	fp, [sp, #-4]
	sub sp, sp, #4
	mov	fp, sp
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
	
C: @ int C(int m,int n) --> C^m_n
	push {fp, lr}
	add	fp, sp, #12
	sub	sp, sp, #8
	str	r0, [fp, #-16]
	str	r1, [fp, #-20]
	ldr	r0, [fp, #-16]
	bl	factorial		@ 计算m！
	mov	r5, r0
	ldr	r0, [fp, #-20]
	bl	factorial		@ 计算n！
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
	bl	__aeabi_idiv	@ 调用已有函数，计算m!/(m-n)!/n!
	sub	sp, fp, #12
	pop	{fp, pc}

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
	.section	.note.GNU-stack,"",%progbits		@ 保护代码，禁止生成可执行堆栈
