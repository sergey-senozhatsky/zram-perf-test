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
 *
 * A trivial bin-mem-hogger app
 */

#include <common_header.h>

#undef APP_NAME
#define APP_NAME "bin-mem-hogger"

static unsigned long long max_mem = 0;
static char *lock_file = NULL;
static char *mem;

static unsigned long long memparse(const char *mem)
{
	char *end;

	unsigned long long ret = strtoull(mem, &end, 10);

	switch (*end) {
		case 'G':
		case 'g':
			ret <<= 10;
		case 'M':
		case 'm':
			ret <<= 10;
		case 'K':
		case 'k':
			ret <<= 10;
		default:
			break;
	}

	return ret;
}

static void print_usage(void)
{
	printf("Usage:\n======\n");
	printf("bin-mem-hogger -m SIZE [-l init lock]\n");
	printf("-m	memory to allocate in MB\n");
	exit(1);
}

static void __repopulate_range(void)
{
	struct timespec tstart = {0}, tend = {0};

	if (!mem)
		return;

	clock_gettime(CLOCK_MONOTONIC, &tstart);
	force_memset(mem, 's', max_mem);
	clock_gettime(CLOCK_MONOTONIC, &tend);

	clock_diff(&tstart, &tend);

	IPRINT("MEMSET (may be SWAPIN) of %p bytes starting from %p <+%4lu.%09lu>\n",
			(void *)max_mem,
			mem,
			tstart.tv_sec,
			tstart.tv_nsec);
	fflush(stdout);
}

static void sighup_handler(int signum)
{
	__repopulate_range();
	exit(0);
}

static void sigusr1_handler(int signum)
{
	__repopulate_range();
}

static int setup_signals(void)
{
	struct sigaction action;

	action.sa_handler = sighup_handler;
	sigemptyset(&action.sa_mask);
	action.sa_flags = 0;

	if (sigaction(SIGHUP, &action, NULL) != 0)
		EPRINT("%s\n", strerror(errno));

	action.sa_handler = sigusr1_handler;
	sigemptyset(&action.sa_mask);
	action.sa_flags = 0;

	if (sigaction(SIGUSR1, &action, NULL) != 0)
		EPRINT("%s\n", strerror(errno));

	return 0;
}

static void run(void)
{
	struct timespec tstart = {0}, tend = {0};
	int ret;

	clock_gettime(CLOCK_MONOTONIC, &tstart);
	mem = malloc(max_mem);
	ret = errno;
	if (!mem) {
		EPRINT("%s\n", strerror(ret));
		exit(ret);
	}

	/* cause page faults */
	force_memset(mem, 'S', max_mem);
	clock_gettime(CLOCK_MONOTONIC, &tend);

	clock_diff(&tstart, &tend);
	IPRINT("Allocated %p bytes at address %p <+%4lu.%09lu>\n",
			(void *)max_mem,
			mem,
			tstart.tv_sec,
			tstart.tv_nsec);
	fflush(stdout);
	if (lock_file)
		unlink(lock_file);

	setup_signals();
	while (1) sleep(10);
	/*
	 * the app must be killed to free the memory.
	 */
}

int main(int argc, char **argv)
{
	int c;

	while ((c = getopt(argc, argv, "hm:l:")) != -1) {
		switch (c) {
			case 'h':
				print_usage();
				break;
			case 'l':
				lock_file = optarg;
				break;
			case 'm':
				max_mem = memparse(optarg);
				break;
			default:
				abort();
		}
	}

	run();
	return EXIT_SUCCESS;
}
