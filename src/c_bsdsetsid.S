.text
.extern u_strlen
.globl main

main:
	xorq	%rcx, %rcx
	movq	(%rsi, %rcx, 8), %rsi
	movq	%rsi, %rdi
	callq	u_strlen
	movq	$0x1, %rdi
	movq	%rax, %rdx
	xorq	%rax, %rax
	movb	$0x4, %al
	syscall
	movq	$0x1, %rdi
	leaq	nl, %rsi
	movq	$0x1, %rdx
	xorq	%rax, %rax
	movq	$0x4, %rax
	syscall
	xorq	%rax, %rax
	xorq	%rax, %rax
	xorq	%rdi, %rdi
	movb	$0x1, %al
	syscall

.data
	nl: .asciz "\n"
