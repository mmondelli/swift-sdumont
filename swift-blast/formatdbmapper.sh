#!/bin/bash
while [ $# -gt 0 ]; do
    case $1 in
	-n)          n=$2;;
	*) echo "$0: bad mapper args" 1>&2
	    exit 1;;
    esac
    shift 2
done

for i in $(seq 1 $n)
do
    printf "[%d].phr frag%03d.phr\n" $i $i;
    printf "[%d].pin frag%03d.pin\n" $i $i;
    printf "[%d].psq frag%03d.psq\n" $i $i;
done

	
