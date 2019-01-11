#!/bin/bash


# Sergey Senozhatsky. sergey.senozhatsky@gmail.com
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

#
# Example:
#
# ZRAM_SIZE=2G ZRAM_COMP_ALG=lz4 LOG_SUFFIX=NEW MEM_HOGGER_SIZE=1G FIO_LOOPS=1 FIO_TEST=compbuf ./zram-fio-test.sh
#

LOG=/tmp/test-fio-zram
MEM_HOGGER_PID=0
EXT_LOG=0
PERF="perf"
FIO="fio"

function reset_zram
{
	echo 1 > /sys/block/zram0/reset
	rmmod zram
	rmmod zsmalloc
}

function create_zram
{
	modprobe zram
	echo "$ZRAM_COMP_ALG" > /sys/block/zram0/comp_algorithm
	cat /sys/block/zram0/comp_algorithm

	echo "$ZRAM_SIZE" > /sys/block/zram0/disksize
	if [ $? != 0 ]; then
		return 1
	fi

	# don't mkfs/mount the device
	return 0
}

function start_single_alloc
{
	touch ./.single_alloc_init
	./bin/bin-mem-hogger -m "$MEM_HOGGER_SIZE" -l ./.single_alloc_init&
	MEM_HOGGER_PID=$!

	while [ -e ./.single_alloc_init ]; do
		echo "Waiting for single-alloc"
		sleep 1s;
	done
}

function exec_mem_hogger
{
	if [ "z$MEM_HOGGER_SIZE" != "z" ]; then
		start_single_alloc
	fi
}

function signal_mem_hogger
{
	if [ "z$MEM_HOGGER_SIZE" != "z" ]; then
		kill -USR1 $MEM_HOGGER_PID
		sleep 2s
	fi
}

function kill_mem_hogger
{
	if [ "z$MEM_HOGGER_SIZE" != "z" ]; then
		kill -TERM $MEM_HOGGER_PID
	fi
}

function main
{
	local i

	if [ "z$LOG_SUFFIX" == "z" ]; then
		LOG_SUFFIX="UNSET"
	fi

	LOG=$LOG-$LOG_SUFFIX

	if [ "z$MEM_HOGGER_SIZE" != "z" ]; then
		EXT_LOG=1
	fi

	if [ "z$EXTENDED_LOG" != "z" ]; then
		EXT_LOG=1
	fi

	if [ "z$ZRAM_SIZE" == "z" ]; then
		ZRAM_SIZE=3G
	fi

	if [ "z$MAX_ITER" == "z" ]; then
		MAX_ITER=10
	fi

	if [ "z$FIO_LOOPS" == "z" ]; then
		FIO_LOOPS=1
	fi

	if [ "z$ZRAM_COMP_ALG" == "z" ]; then
		ZRAM_COMP_ALG=lzo
	fi

	FIO_TEMPLATE=./conf/fio-template-static-buffer
	if [ "z$FIO_TEST" == "zcompbuf" ]; then
		FIO_TEMPLATE=./conf/fio-template-compressed-buffer
	fi

	echo "Using $FIO_TEMPLATE fio template"

	for i in $(seq $MAX_ITER); do
		echo "$i"

		reset_zram
		create_zram
		if [ $? != 0 ]; then
			echo "Unable to create zram device"
			exit 1
		fi

		exec_mem_hogger

		echo "#jobs$i fio"

		echo "#jobs$i fio" >> $LOG

		DISK_SIZE=$(cat /sys/block/zram0/disksize)
		_NRFILES=$(($DISK_SIZE/(512 * 1024)))

		echo "#files $_NRFILES"
##		BLOCK_SIZE=4 SIZE=100% NUMJOBS=$i NRFILES=$_NRFILES FIO_LOOPS=$FIO_LOOPS \

		BLOCK_SIZE=4 SIZE=100% NUMJOBS=$i NRFILES=$i FIO_LOOPS=$FIO_LOOPS \
			$PERF stat -o $LOG-perf-stat $FIO ./$FIO_TEMPLATE >> $LOG

		echo -n "perfstat jobs$i" >> $LOG
		cat $LOG-perf-stat >> $LOG

		cat /sys/block/zram0/debug_stat

		if [ $EXT_LOG -eq 1 ]; then
			echo -n "mm_stat (jobs$i): " >> $LOG-mm_stat
			cat /sys/block/zram0/mm_stat >> $LOG-mm_stat

			echo "buddyinfo (jobs$i): " >> $LOG-buddyinfo
			cat /proc/buddyinfo >> $LOG-buddyinfo
		fi

		kill_mem_hogger
	done

	rm $LOG-perf-stat
	echo -n "Log files created: $LOG "

	if [ $EXT_LOG -eq 1 ]; then
		echo -n " $LOG-mm_stat"
		echo -n " $LOG-buddyinfo"
	fi

	echo
	reset_zram
}

main
