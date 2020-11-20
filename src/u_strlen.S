.text
.globl	u_strlen

u_strlen:
	mov		%rdi, %rcx

u_loop:
	cmpb	$0x0, (%rcx)
	je		u_ret
	inc		%rcx
	jmp		u_loop

u_ret:
	sub		%rdi, %rcx
	mov		%rcx, %rax
	ret
