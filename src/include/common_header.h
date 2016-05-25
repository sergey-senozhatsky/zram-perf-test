/*
 * Sergey Senozhatsky. sergey.senozhatsky@gmail.com
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * A common header
 */

#ifndef _COMMON_HEADER_H
#define _COMMON_HEADER_H

#define _POSIX_C_SOURCE 200112L
#define _GNU_SOURCE 1

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <string.h>
#include <errno.h>
#include <time.h>
#include <poll.h>
#include <getopt.h>

#ifndef APP_NAME
#define APP_NAME " "
#endif

#define APP			"[%d] " APP_NAME ": "
#define ERR			APP" ERROR: "
#define INF			APP" INFO: "

#define __PRINT(e, f, ...)	printf(e f, getpid(), ##__VA_ARGS__)

#define IPRINT(f,...)	__PRINT(INF, f, ##__VA_ARGS__)
#define EPRINT(f,...)	__PRINT(ERR, f, ##__VA_ARGS__)

#define MB(x)			((x) * 1024 * 1024ULL)

static void clock_diff(struct timespec *start, struct timespec *end)
{
	struct timespec temp;

	if ((end->tv_nsec - start->tv_nsec) < 0) {
		temp.tv_sec = end->tv_sec - start->tv_sec - 1;
		temp.tv_nsec = 1000000000 + end->tv_nsec - start->tv_nsec;
	} else {
		temp.tv_sec = end->tv_sec - start->tv_sec;
		temp.tv_nsec = end->tv_nsec - start->tv_nsec;
	}

	start->tv_sec = temp.tv_sec;
	start->tv_nsec = temp.tv_nsec;
}

static void __sleep(unsigned long s, unsigned long ms)
{
	int ret = poll(NULL, 0, s + ms);

	if (ret != 0) {
		EPRINT("SLEEP: %s\n", strerror(ret));
	}
}

/*
 * Not ideal, but good enough. do something stupid, like force
 * EPRINT dereference, so the compiler won't be in position to
 * optimize it out.
 */
static void force_memset(void *mem, int c, unsigned long sz)
{
	volatile int t;

	sz--;
	memset(mem, c, sz);
	((char *)mem)[sz - 1] = 0x00;
	t = ((char *)mem)[sz - 2];

	if (t != c)
		EPRINT("POISON MISMATCH %d != %d\n", t, ((char *)mem)[sz - 2]);
}

#endif
