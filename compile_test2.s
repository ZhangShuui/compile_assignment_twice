	.text
	.section	.rodata
_str:
	.ascii	"%d\012\000"			@ "%d\n\0"

factorial:	@ int factorial(int k) --> k!
	str	fp, [sp, #-4]				
	sub sp, sp, #4
	mov	fp, sp
	sub	sp, sp, #20					@ 开辟栈帧
	str	r0, [fp, #-16]				@ 提前将参数k保存在栈中
	mov	r3, #1						@ int m=1，保存在r3寄存器
	mov r4, #1						@ int i=1，保存在r4寄存器
	b	.L1
.L0:
	mul	r3, r3, r4					@ m*=i
	add	r4, r4, #1					@ i++
.L1:
	cmp	r4, r0						@ m <= n，则跳回
	ble	.L0
	mov	r0, r3						@ 保存返回值到r0
	add	sp, fp, #0
	ldr	fp, [sp], #4
	bx	lr
	
C: @ int C(int m,int n) --> C^m_n
	push {fp, lr}
	add	fp, sp, #12
	sub	sp, sp, #8
	str	r0, [fp, #-16]				@ 提前将m，n的值保存在栈中
	str	r1, [fp, #-20]
	ldr	r0, [fp, #-16]
	bl	factorial					@ 计算m!
	mov	r5, r0						@ 使用r5保存中间值，因为factorial函数没使用
	ldr	r0, [fp, #-20]
	bl	factorial					@ 计算n!
	mov	r6, r0						@ 使用r6保存中间值，因为factorial函数没使用
	ldr	r2, [fp, #-16]
	ldr	r3, [fp, #-20]				
	sub	r3, r2, r3
	mov	r0, r3
	bl	factorial					@ 计算(m-n)!
	mov	r3, r0
	mul	r3, r3, r6
	mov	r1, r3
	mov	r0, r5
	bl	__aeabi_idiv				@ 调用除法函数，计算m!/(m-n)!/n!
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
