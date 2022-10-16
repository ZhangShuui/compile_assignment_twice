	.text
	.section	.rodata
_str:
	.ascii	"%d\012\000"	@ "%d\n\0"
	.align	2
	.global	fibo
fibo:	@ function int fibo(int )
	push	{fp, lr}
	add	fp, sp, #8
	sub	sp, sp, #12
	str	r0, [fp, #-16]		@ 保存参数n值
	ldr	r3, [fp, #-16]		@ 将r0值转移到r3中，再进行比较
	cmp	r3, #1				@ 将n与1进行比较
	beq	.L1					@ 如果等于1，则进入if语句块
	cmp	r3, #0				@ 再和0比较
	bne	.L2					@ 如果等于0，则进入if语句块，不等于0则跳出
.L1:						@ if语句块
	mov	r3, #1				@ 返回值为1
	b	.L3					@ 进入return部分
.L2:		
	sub	r0, r3, #1
	bl	fibo				@ fibo(n-1):第一次递归
	mov	r4, r0				@ 保存第一次结果到r4
	ldr	r3, [fp, #-16]		@ 加载提前保存的参数n
	sub	r3, r3, #2			
	mov	r0, r3
	bl	fibo				@ fibo(n-2):第二次递归，为了防止寄存器调用冲突，使用已经提前保存的数值
	add	r3, r4, r3			@ 计算两者和
.L3:
	mov	r0, r3				@返回值存入r0
	sub	sp, fp, #8
	pop	{fp, pc}

	.align	2
	.global	main
main:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #8
	mov	r0, #5				@ fibo函数，使用参数常数5
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
