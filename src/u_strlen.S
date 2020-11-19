.text
.globl	u_strlen

u_strlen:
	movq	%rdi, %rcx

u_loop:
	cmpb	$0x0, (%rcx)
	je		u_ret
	inc		%rcx
	jmp		u_loop

u_ret:
	sub		%rdi, %rcx
	movq	%rcx, %rax
	retq
