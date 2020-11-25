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
 * bsdsetsid: src/c_bsdsetsid.c
Wed Nov 25 23:03:04 CET 2020
 * Joe
 *
 * This is the entrypoint of the program.
 */

#include <errno.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#include "c_bsdsetsid.h"

static char
c_args
(int			argc,
 const char*	argv[],
 const char*	envp[],
 bool_t*		wopt)
{
	(void)envp;
	if (argc == 1) {
		dprintf(
			STDERR_FILENO,
			"%s: %s\n",
			C_PROGNAME,
			C_ERR_NOARG
			);
		return (1);
	}
	if (strncmp(argv[1], C_W_OPT, 3) == 0) {
		*wopt = TRUE;
		if (argc == 2) {
			dprintf(
				STDERR_FILENO,
				"%s: %s\n",
				C_PROGNAME,
				C_ERR_NOARG
				);
			return (1);
		}
	}
	return (0);
}

int
main
(int			argc,
 const char*	argv[],
 const char*	envp[])
{
	int sets_ret;
	int exec_ret;
	pid_t pid;
	bool_t wopt;

	wopt = FALSE;
	if (c_args(argc, argv, envp, &wopt) != 0) {
		return (EXIT_FAILURE);
	}
	pid = fork();
	if (pid == -1) {
		dprintf(
			STDERR_FILENO,
			"%s: fork: %s\n",
			C_PROGNAME,
			strerror(errno)
			);
		return (EXIT_FAILURE);
	}
	else if (pid == 0) {
		sets_ret = setsid();
		if (sets_ret == -1) {
			dprintf(
				STDERR_FILENO,
				"%s: setsid: %s\n",
				C_PROGNAME,
				strerror(errno)
				);
			return (EXIT_FAILURE);
		}
		exec_ret = execve(
			argv[1 + wopt],
			(char* const*)argv + (1 + wopt),
			(char* const*)envp
			);
		if (exec_ret == -1) {
			dprintf(
				STDERR_FILENO,
				"%s: execve: %s\n",
				C_PROGNAME,
				strerror(errno)
				);
			return (EXIT_FAILURE);
		}
	}
	else {
		return (EXIT_SUCCESS);
	}
	return (EXIT_SUCCESS);
}
