.text
.extern	u_strlen
.extern	u_pout
.extern	u_perr
.globl	main

main:
	cmpb	$0x1, %dil
	jle		c_noarg
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	xorq	%rcx, %rcx
	movq	(%rsi, %rcx, 8), %rdi
	movq	%rcx, %r8
	callq	u_pout
	movq	%r8, %rcx
	popq	%rdx
	popq	%rsi
	popq	%rdi
	pushq	%rdi
	pushq	%rsi
	pushq	%rdx
	inc		%rcx
	movq	(%rsi, %rcx, 8), %rdi
	callq	u_pout
	popq	%rdx
	popq	%rsi
	popq	%rdi
	jmp		c_exit

c_noarg:
	leaq	noarg_str, %rdi
	callq	u_perr
	movq	$0x1, %rdi
	xorq	%rax, %rax
	movb	$0x1, %al	# SYS_exit
	syscall

c_exit:
	xorq	%rdi, %rdi
	xorq	%rax, %rax
	movb	$0x1, %al	# SYS_exit
	syscall

.data
noarg_str:	.asciz "bsdsetsid: no command specified"
