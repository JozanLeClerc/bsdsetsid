.text
.extern	u_strlen
.globl	u_pout
.globl	u_perr

u_pout:
	mov		$0x1, %r11	# stdout
	jmp		u_print

u_perr:
	mov	$0x2, %r11	# stderr
	jmp		u_print

u_print:
	call	u_strlen
	mov		%rax, %rdx
	mov		%rdi, %rsi
	mov		%r11, %rdi
	mov		$0x4, %rax	# SYS_write
	syscall
	lea		nl, %rsi
	mov		$0x1, %rdx
	mov		$0x4, %rax	# SYS_write
	syscall
	ret

.data
nl: .asciz "\n"
