.data
str:
	.asciz "a string\n"

.text
.extern u_write
.globl _start

_start:
	movq	$0x1, %rdi
	leaq	str, %rsi
	movq	$0x9, %rdx
	callq	u_write
	movq	$0x1, %rax
	xorq	%rdi, %rdi
	syscall
