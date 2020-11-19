.text
.extern	u_strlen
.globl	u_pout
.globl	u_perr

u_pout:
	movq	$0x1, %r11	# stdout
	jmp		u_print

u_perr:
	movq	$0x2, %r11	# stderr
	jmp		u_print

u_print:
	callq	u_strlen
	movq	%rax, %rdx
	movq	%rdi, %rsi
	movq	%r11, %rdi
	movq	$0x4, %rax	# SYS_write
	syscall
	leaq	nl, %rsi
	movq	$0x1, %rdx
	movq	$0x4, %rax	# SYS_write
	syscall
	retq

.data
nl: .asciz "\n"
