	.text
	.section	.rodata
_str:
	.ascii	"%d\012\000"	@ "%d\n\0"
	.align	2
	.global	fibo
fibo:	@ function int fibo(int)
	push	{fp, lr}
	add	fp, sp, #8
	sub	sp, sp, #12
	str	r0, [fp, #-16]
	ldr	r3, [fp, #-16]		@ 一定要将其单独存在r3中,不可直接比较,否则会陷入死循环
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
	bl	fibo		@ 第一次递归，为了防止寄存器调用冲突，使用已经提前保存了数值的寄存器r
	mov	r4, r0
	ldr	r3, [fp, #-16]
	sub	r3, r3, #2
	mov	r0, r3
	bl	fibo		@ 第二次递归，同上
	mov	r3, r0
	add	r3, r4, r3
.L3:
	mov	r0, r3
	sub	sp, fp, #8
	pop	{fp, pc}

	.align	2
	.global	main
main:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #8
	mov	r0, #5		@ fibo函数，使用参数常数5
	bl	fibo
	mov r1, r0
	ldr r0, _bridge			@ 将字符串常量地址作为第一个参数，fibo函数返回值保存在r1中，作为第二个参数
	bl	printf
	mov	r0, #0
	sub	sp, fp, #4
	pop	{fp, pc}

_bridge:
	.word	_str
	.section	.note.GNU-stack,"",%progbits		@ 保护代码，禁止生成可执行堆栈
