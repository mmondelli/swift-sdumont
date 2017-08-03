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
    printf "[%d] frag%03d.html\n" $i $i;
done

	
