.data
str:
	.asciz "a string\n"

.text
.globl _start

_start:
	jmp		c_main

c_main:
	movq	$0x1, %rdi
	leaq	str, %rsi
	movq	$0x9, %rdx
	movq	$0x4, %rax
	syscall
	xorq	%rdi, %rdi
	movq	$0x1, %rax
	syscall
