
Sergey Senozhatsky


# zram-perf-test
zram performance testing toolset

LOG_SUFFIX=
	The suffix the test result file must contain:
	/tmp/test-fio-zram-$LOG_SUFFIX

USE_MEM_HOGGER=
	Start a memory hogger app in the backgroud

EXTENDED_LOG=
	Record an extended stats (mm_stat, buddyinfo, etc.)

ZRAM_SIZE=
	The size of the zram device (e.g. 3G, 512M)

MAX_ITER=
	The number of fio iterations. On each iteration the
	test increases the number of fio jobs, files to create,
	etc.

FIO_LOOPS=
	The number of loop fio must execute for every test.

FIO_TEST=
	Specifies the fio template file to be used.
	E.g.
		FIO_TEST=compbuf -- will switch to conf/fio-template-compressed-buffer
				    file
	Otherwise, the conf/fio-template-static-buffer file will be used.

	The main difference between those two templates is that 'static-buffer'
	sets a `buffer_pattern=0xbadc0ffee' fio option, while `compressed-buffer'
	replaces this option with `buffer_compress_percentage=11'. See fio documentation
	for more details.


EXAMPLE
----------------------------------------------------------------------------------------------------

== Run the test:

ZRAM_SIZE=1G LOG_SUFFIX=-old-lzo ./zram-fio-test.sh

== Update zram, etc. Run the test:

ZRAM_SIZE=1G LOG_SUFFIX=-crypto-lzo ./zram-fio-test.sh

== Compare the perf logs (can be 2+ files)

./fio-perf-o-meter.sh /tmp/test-fio-zram--old-lzo /tmp/test-fio-zram--crypto-lzo
