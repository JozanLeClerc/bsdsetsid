.text
.globl u_write

u_write:
	movq	$0x4, %rax
	syscall
	movq	%rax, %rcx
	jc		u_err
	movq	%rcx, %rax
	retq

u_err:
	movq	$0xffffffffffffffff, %rax
	retq
