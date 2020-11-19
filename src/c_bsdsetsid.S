.text
.extern	u_strlen
.extern	u_pout
.extern	u_perr
.globl	main

main:
	xorq	%rcx, %rcx
	callq	c_push
	movq	(%rsi, %rcx, 8), %rdi
	callq	u_pout
	callq	c_pop
	inc		%rcx
	callq	c_push
	movq	(%rsi, %rcx, 8), %rdi
	callq	u_pout
	callq	c_pop
	xorq	%rdi, %rdi
	xorq	%rax, %rax
	movb	$0x1, %al	# SYS_exit
	syscall

c_push:
	movq	%rdx, %r8
	movq	%rsi, %r9
	movq	%rdi, %r10
	retq

c_pop:
	movq	%r8, %rdi
	movq	%r9, %rsi
	movq	%r10, %rdx
	retq

.data
nl: .asciz "\n"
asd: .asciz "hey\n"
