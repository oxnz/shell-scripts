#!/bin/sh
#
# Author: oxnz
# Goal: replace '\n' -> '\r\n'
# there are several way to achieve the goal:
# unix2dos:
# 	1. sed -i 's/$/\r/' file
# 	2. sed -i 's/$\x0d/' file
# 	3. perl -i -p -e 's/\n/\r\n/' file
# dos2unix
#	1. sed -i "s/\r//" $1
#	2. cat $1 | col -b > newfile
#	3. cat file | tr -d "\r" > newfile
#	4. cat file | tr -d "\015" > newfile

SRCFILE=''
DSTFILE=''
OPTION='unix2dos'

function usage() {
	printf "Usage: $0 <srcfile> [dstfile]\n"
	echo "-h --help print this message and exit"
}

function convert() {
	local opt=$1
	local sfile=$2
	local dfile=$3

# debug info:
#	echo "opt=$opt, sfile=$sfile, dfile=$dfile"

	if [ -n "$dfile" ]; then
		if ! [ -e "$sfile" ]; then
			echo "[$sfile] does not exist"
			exit 1
		fi
		if ! [ -r "$sfile" ]; then
			echo "can't read: [$sfile]"
			exit 2
		fi
		cp $sfile $dfile
		if [ "$?" -ne 0 ]; then
			echo "can't write: [$dfile]"
			exit 3
		fi
	else # dfile is ''
		dfile=$sfile
	fi
# debug info:
#	echo "opt=$opt, sfile=$sfile, dfile=$dfile"
	if [ "$opt" == "dos2unix" ]; then
		perl -i -p -e 's/\r\n/\n/' "$dfile"
	else
		perl -i -p -e 's/\n/\r\n/' "$dfile"
	fi
# debug option:
#	xxd "$dfile"
}

if [ $# -eq 0 ]; then
	usage
	exit 0
elif [ $# -eq 1 ]; then
	case $1 in
		-[hH]|-help|--help)
			usage
			exit 0
			;;
		-*)
			echo "unknown option: $1"
			exit 1
			;;
		*)
			SRCFILE="$1"
			;;
	esac
elif [ $# -eq 2 ]; then
	SRCFILE="$1"
	DSTFILE="$2"
else
	echo "too many arguments"
	exit 1
fi

if [ "$0" == "dos2unix" ]; then
	OPTION="dos2unix"
fi

convert $OPTION $SRCFILE $DSTFILE
