#!/bin/bash

db=$1
app=$2

if [ $# != 2 ]; then
	echo "***ERROR*** Use: $0 database app_name"
	exit -1
fi

SQLITE_CMD="sqlite3 -noheader -separator , -batch $db"

for i in $($SQLITE_CMD "select f.file_id from file f natural join staged_in s where f.name like '%fragsF.INF%';")
do
  echo "$i"
done


