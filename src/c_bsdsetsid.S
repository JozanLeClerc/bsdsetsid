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
 * 2020-11-20 18:18
 * Joe
 *
 * This is the entrypoint of the program.
 */

.text
.globl	main

main:
	cmpb	$0x1, %dil
	jle		e_noarg
	xor		%rax, %rax
	movb	$0x2, %al
	syscall
	jc		e_fork
	cmp		$0x0, %rax
	je		c_child

c_parent:
	mov		%rax, %rdi
#	xor		%r8, %r8
#	lea		(%r8), %rsi
	mov		$0x0, %rdx
	mov		$0x0, %rcx
	xor		%rax, %rax
	movb	$0x7, %al	/* SYS_wait4 */
	syscall

	xor		%rdi, %rdi
	movb	%al, %dil
	movb	$0x7, %al
	xor		%rax, %rax
	movb	$0x1, %al	/* SYS_exit */
	syscall

c_child:
#	xor		%rax, %rax
#	movb	$0x93, %al	/* SYS_setsid */
#	syscall
#	jc		e_setsid
	xor		%rax, %rax
	push	%rsi
	mov		$0x1, %rcx
	mov		(%rsi, %rcx, 8), %rdi
	lea		0(%rsi, %rcx, 8), %rsi
	movb	$0x3b, %al	/* SYS_execve */
	syscall
	jc		e_execve
	pop		%rsi
	jmp		c_exit

c_exit:
	xor		%rdi, %rdi
	xor		%rax, %rax
	movb	$0x1, %al	/* SYS_exit */
	syscall
