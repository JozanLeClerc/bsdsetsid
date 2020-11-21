/*
 * ========================
 * =====    ===============
 * ======  ================
 * ======  ================
 * ======  ====   ====   ==
 * ======  ===     ==  =  =
 * ======  ===  =  ==     =
 * =  ===  ===  =  ==  ====
 * =  ===  ===  =  ==  =  =
 * ==     =====   ====   ==
 * ========================
 *
 * SPDX-License-Identifier: BSD-3-Clause
 *
 * Copyright (c) 2020 Joe
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the organization nor the
 *    names of its contributors may be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY JOE ''AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL JOE BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * bsdsetsid: src/c_bsdsetsid.S
 * 2020-11-21 18:47
 * Joe
 *
 * This is the entrypoint of the program.
 */

.data
status:		.space 4, 0x0
ref_w_opt:	.asciz "-w"

.text
.globl	main

c_parent_old:
	mov		%rax, %rdi
	lea		status, %rsi
	xor		%rdx, %rdx
	xor		%rcx, %rcx
	xor		%rax, %rax
	movb	$0x7, %al	/* SYS_wait4 */
	syscall
	movq	(%rsi), %rax
	and		$0xff00, %rax
	shr		$0x8, %rax
	push	%rax
	jmp		u_hexdec
c_parent_next:
	pop		%rdi
	movb	$0x7, %al
	xor		%rax, %rax
	movb	$0x1, %al	/* SYS_exit */
	syscall

c_w_opt:
	mov		$0x1, %r15
	pop		%rdi
	mov		%rdi, %r8
	push	%rdi
	cmp		$0x2, %r8
	jle		e_noarg
	jmp		.c.main_next

main:
	cmpb	$0x1, %dil
	jle		e_noarg
	xor		%r15, %r15
	push	%rdx
	push	%rsi
	push	%rdi
	lea		ref_w_opt, %rdi
	mov		$0x3, %rdx
	call	u_strncmp
	cmp		$0x0, %rax
	je		c_w_opt
.c.main_next:
	xor		%rax, %rax
	movb	$0x2, %al	/* SYS_fork */
	syscall
	test	%rax, %rax
	js		e_fork
	jz		c_child

c_parent:
	jmp		c_exit

c_child:
	xor		%rax, %rax
	movb	$0x93, %al	/* SYS_setsid */
	syscall
	test	%rax, %rax
	js		e_setsid
	xor		%rax, %rax
	pop		%rdi
	pop		%rsi
	pop		%rdx
	mov		$0x1, %rcx
	mov		(%rsi, %rcx, 8), %rdi
	lea		0(%rsi, %rcx, 8), %rsi
	movb	$0x3b, %al	/* SYS_execve */
	syscall
	jc		e_execve

c_exit:
	xor		%rdi, %rdi
	xor		%rax, %rax
	movb	$0x1, %al	/* SYS_exit */
	syscall
