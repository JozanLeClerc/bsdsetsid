.text
.extern	u_strlen
.extern	u_pout
.extern	u_perr
.globl	main

main:
	cmpb	$0x1, %dil
	jle		c_noarg
	push	%rdi
	push	%rsi
	push	%rdx
	xor		%rcx, %rcx
	mov		(%rsi, %rcx, 8), %rdi
	mov		%rcx, %r8
	call	u_pout
	mov		%r8, %rcx
	pop		%rdx
	pop		%rsi
	pop		%rdi
	push	%rdi
	push	%rsi
	push	%rdx
	inc		%rcx
	mov		(%rsi, %rcx, 8), %rdi
	call	u_pout
	pop		%rdx
	pop		%rsi
	pop		%rdi
	jmp		c_exit

c_noarg:
	lea		noarg_str, %rdi
	call	u_perr
	mov		$0x1, %rdi
	xor		%rax, %rax
	movb	$0x1, %al	# SYS_exit
	syscall

c_exit:
	xor		%rdi, %rdi
	xor		%rax, %rax
	movb	$0x1, %al	# SYS_exit
	syscall

.data
noarg_str:	.asciz "bsdsetsid: no command specified"
