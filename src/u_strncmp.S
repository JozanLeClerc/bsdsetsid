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
 * bsdsetsid: src/u_strncmp.S
 * 2020-11-21 14:02
 * Joe
 *
 * General error handling happen here.
 */

.text
.globl	u_strncmp

u_strncmp:
	xor		%rcx, %rcx
	dec		%rdx
.u.loop:
	xor		%r8, %r8
	xor		%r9, %r9
	movb	(%rdi, %rcx), %r8b
	movb	(%rsi, %rcx), %r9b
	cmpb	%r8b, %r9b
	jne		.u.retdiff
	cmp		%rdx, %rcx
	jge		.u.retdiff
	cmpb	$0x0, (%rdi, %rcx)
	jne		.u.inc
	cmpb	$0x0, (%rsi, %rcx)
	je		.u.retzer
.u.inc:
	inc		%rcx
	jmp		.u.loop
.u.retdiff:
	xor		%r8, %r8
	xor		%r9, %r9
	movb	(%rdi, %rcx), %r8b
	movb	(%rsi, %rcx), %r9b
	sub		%r9, %r8
	xor		%rax, %rax
	movl	%r8d, %eax
	ret
.u.retzer:
	xor		%rax, %rax
	ret
