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
 * bsdsetsid: src/c_fork.c
 * Fri Nov 27 01:48:00 CET 2020
 * Joe
 *
 * The program's main fork(2).
 */

#include <sys/types.h>
#include <sys/wait.h>
#include <sys/time.h>
#include <sys/resource.h>

#include <errno.h>
#include <limits.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#include "c_bsdsetsid.h"
#include "c_fork.h"

static char
c_get_path
(const char		arg[],
 const char*	envp[],
 ptr_t			path)
{
	char** env_path;
	char tmp[PATH_MAX];
	char* tmptr;
	ptr_t tok;

	if (strchr(arg, '/') != NULL) {
		path = (ptr_t)arg;
		return (0);
	}
	env_path = (char**)envp;
	while (env_path != NULL && strncmp(*env_path, "PATH=", 5) != 0) {
		env_path++;
	}
	if (env_path == NULL) {
		path = NULL;
		return (1);
	}
	strlcpy(tmp, *env_path, PATH_MAX);
	tmptr = strchr(tmp, '=');
	tmptr += 1;
	if (*tmp == 0x00) {
		path = NULL;
		return (1);
	}
	tok = strtok(tmptr, ":");
	if (tok == NULL) {
		path = NULL;
		return (1);
	}
	while (tok != NULL) {
		sprintf(path, "%s/%s", tok, arg);
		if (access(path, F_OK) != -1) {
			break;
		}
		tok = strtok(NULL, ":");
	}
	if (tok == NULL) {
		path = NULL;
		return (2);
	}
	return (0);
}

static void
c_fork_child
(const char*	argv[],
 const char*	envp[],
 bool_t			wopt)
{
	union ret_u u;
	ptr_t path;
	char mem[PATH_MAX];

	u.pid = setsid();
	if (u.pid == -1) {
		dprintf(
			STDERR_FILENO,
			"%s: setsid: %s\n",
			C_PROGNAME,
			strerror(errno)
			);
		exit(EXIT_FAILURE);
	}
	path = mem;
	u.ret = c_get_path(argv[1 + wopt], envp, path);
	if (u.ret == 1) {
		dprintf(
			STDERR_FILENO,
			"%s: PATH not set\n",
			C_PROGNAME
			);
		exit(EXIT_FAILURE);
	}
	else if (u.ret == 2) {
		dprintf(
			STDERR_FILENO,
			"%s: command not found: %s\n",
			C_PROGNAME,
			argv[1 + wopt]
			);
		exit(EXIT_FAILURE);
	}
	u.ret = execve(
		path,
		(char* const*)argv + (1 + wopt),
		(char* const*)envp
		);
	if (u.ret == -1) {
		dprintf(
			STDERR_FILENO,
			"%s: execve: %s: %s\n",
			C_PROGNAME,
			argv[1 + wopt],
			strerror(errno)
			);
		exit(EXIT_FAILURE);
	}
}

static void
c_fork_parent
(bool_t	wopt,
 pid_t	pid)
{
	union ret_u u;
	int status;

	if (wopt == TRUE) {
		u.pid = wait4(pid, &status, 0, NULL);
		if (u.pid < 0) {
			dprintf(
				STDERR_FILENO,
				"%s: wait4: %s\n",
				C_PROGNAME,
				strerror(errno)
				);
		}
		exit(WEXITSTATUS(status));
	}
	exit(EXIT_SUCCESS);
}

static void
c_fork_error(void)
{
	dprintf(
		STDERR_FILENO,
		"%s: fork: %s\n",
		C_PROGNAME,
		strerror(errno)
		);
	exit(EXIT_FAILURE);
}

void
c_fork
(const char*	argv[],
 const char*	envp[],
 bool_t			wopt)
{
	pid_t pid;

	pid = fork();
	if (pid == -1) {
		c_fork_error();
	}
	else if (pid == 0) {
		c_fork_child(argv, envp, wopt);
	}
	else {
		c_fork_parent(wopt, pid);
	}
}
