#!/bin/sh

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
# ./fio-perf-o-meter.sh test-fio-zram-old test-fio-zram-patch1 test-fio-zram-patch2 ...
#

NUM_LOG_FILES=0
LOG_FILE_IDX=0

#
# The test-fio-zram-FOO files contain tons of info, which you can
# discover on your own, here we will squeeze only a small subset.
#

function parse_old_log
{
	cat $1 \
		| egrep "#jobs|READ|WRITE" \
		| awk '{printf "%-15s %15s\n", $1, $3}' \
		| sed s/aggrb=// \
		| sed s/,// >> $2
	cat $1 \
		| egrep "perfstat|stalled-cycles-frontend|stalled-cycles-backend|instructions|branches|branch-misses" \
		| sed s/\#// \
		| awk '{if ($1 != "perfstat") {printf "%-25s %17s (%8s)\n", $2, $1, $3} else {printf "%-25s %17s %8s\n", $2, $1, ""}}' >> $2
	cat $1 \
		| grep "seconds" \
		| awk '{printf "%-22s %9s\n", "seconds elapsed", $1}' >> $2
#	cat $1 \
#		| grep "mm_stat" >> $2
}

function parse_new_log
{
	cat $1 \
		| egrep "#jobs|READ|WRITE" \
		| awk '{printf " %-15s\n", $3}' \
		| sed s/aggrb=// \
		| sed s/\#jobs[0-9]*// \
		| sed s/,// >> $2
	cat $1 \
		| egrep "perfstat|stalled-cycles-frontend|stalled-cycles-backend|instructions|branches|branch-misses" \
		| sed s/\#// \
		| sed s/perfstat.*// \
		| awk '{if ($3 != "") { printf "%17s (%8s)\n", $1, $3} else {printf "%17s %8s\n", $1, $3} }' >> $2
	cat $1 \
		| grep "seconds" \
		| awk '{printf "%9s\n", $1}' >> $2
#	cat $1 \
#		| grep "mm_stat" >> $2
}

function paste_logs
{
	local CMD_LINE=""

	while [ $LOG_FILE_IDX -lt $NUM_LOG_FILES ]; do
		CMD_LINE=$CMD_LINE" $LOG_FILE_IDX"
		let LOG_FILE_IDX=$LOG_FILE_IDX+1
	done

	paste $CMD_LINE
}

function cleanup
{
	let LOG_FILE_IDX=0
	while [ $LOG_FILE_IDX -lt $NUM_LOG_FILES ]; do
		rm ./$LOG_FILE_IDX
		let LOG_FILE_IDX=$LOG_FILE_IDX+1
	done
}

for FILE in "$@"; do
	echo "Processing $FILE"
	if [ $NUM_LOG_FILES -eq 0 ]; then
		parse_old_log $FILE $NUM_LOG_FILES
	else
		parse_new_log $FILE $NUM_LOG_FILES
	fi
	let NUM_LOG_FILES=$NUM_LOG_FILES+1
done

paste_logs
cleanup
