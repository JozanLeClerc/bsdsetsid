.text
.globl main

c_main:
	movq	$0x1, %rdi
	xorq	%rcx, %rcx
	inc		%rcx
	movq	(%rdx, %rcx, 8), %rsi
	movq	$0xa, %rdx
	movb	$0x4, %al
	syscall
	retq

main:
	xorq	%rax, %rax
	callq	c_main
	xorq	%rax, %rax
	xorq	%rdi, %rdi
	movb	$0x1, %al
	syscall

.data
	str: .asciz "a string\n"
