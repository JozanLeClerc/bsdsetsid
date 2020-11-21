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
 * bsdsetsid: src/e_err.S
 * 2020-11-20 19:10
 * Joe
 *
 * General error handling happen here.
 */

.text
.extern	strerror
.globl	e_execve
.globl	e_fork
.globl	e_noarg
.globl	e_setsid

e_noarg:
	lea		e_noarg_str, %rdi
	call	u_perr
	mov		$0x1, %rdi
	jmp		e_exit

e_fork:
	push	%rax
	lea		e_fork_str, %rdi
	call	u_perr
	pop		%rax
	mov		%rax, %rdi
	call	strerror
	mov		%rax, %rdi
	call	u_perr
	mov		$0x2, %rdi
	jmp		e_exit

e_setsid:
	push	%rax
	lea		e_setsid_str, %rdi
	call	u_perr
	pop		%rax
	mov		%rax, %rdi
	call	strerror
	mov		%rax, %rdi
	call	u_perr
	lea		nl, %rdi
	call	u_perr
	mov		$0x3, %rdi
	jmp		e_exit

e_execve:
	push	%rax
	lea		e_execve_str, %rdi
	call	u_perr
	pop		%rax
	mov		%rax, %rdi
	call	strerror
	mov		%rax, %rdi
	call	u_perr
	lea		nl, %rdi
	call	u_perr
	mov		$0x4, %rdi
	jmp		e_exit

e_exit:
	xor		%rax, %rax
	movb	$0x1, %al	/* SYS_exit */
	syscall

.data
nl:				.asciz "\n"
e_setsid_str:	.asciz "bsdsetsid: setsid: "
e_execve_str:	.asciz "bsdsetsid: execve: "
e_fork_str:		.asciz "bsdsetsid: fork: "
e_noarg_str:	.asciz "bsdsetsid: no command specified\n"
