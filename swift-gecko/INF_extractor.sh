#!/bin/bash

db=$1
runId=$2

if [ $# != 2 ]; then
	echo "***ERROR*** Use: $0 database script_run_id"
	exit -1
fi

SQLITE_CMD="sqlite3 $db"

for i in $(ls *.fragsF.INF)
do
  id=$(echo "select f.file_id from file f natural join staged_out s where f.name like '$i' and s.app_exec_id like '%$runId%';" | $SQLITE_CMD)
  while read line
  do
    token1=$(echo $line | awk -F ":" '{print $1}' | awk '{$1=$1}1')
    token2=$(echo $line | awk -F ":" '{print $2}' | awk '{$1=$1}1')
    if [ "$token1" = "SeqX filename" ]; then
      echo "INSERT INTO file_annot_text VALUES ('$id', 'seqx_filename', '$token2');" | $SQLITE_CMD
    fi
    if [ "$token1" = "SeqX filename" ]; then
      echo "INSERT INTO file_annot_text VALUES ('$id', 'seqx_filename', '$token2');" | $SQLITE_CMD
    fi
    if [ "$token1" = "SeqY filename" ]; then
      echo "INSERT INTO file_annot_text VALUES ('$id', 'seqy_filename', '$token2');" | $SQLITE_CMD
    fi
    if [ "$token1" = "SeqX name" ]; then
      echo "INSERT INTO file_annot_text VALUES ('$id', 'seqx_name', '$token2');" | $SQLITE_CMD
    fi
    if [ "$token1" = "SeqY name" ]; then
      echo "INSERT INTO file_annot_text VALUES ('$id', 'seqy_name', '$token2');" | $SQLITE_CMD
    fi
    if [ "$token1" = "SeqX length" ]; then
      echo "INSERT INTO file_annot_numeric VALUES ('$id', 'seqx_length', $token2);" | $SQLITE_CMD
    fi
    if [ "$token1" = "SeqY length" ]; then
      echo "INSERT INTO file_annot_numeric VALUES ('$id', 'seqy_length', $token2);" | $SQLITE_CMD
    fi
    if [ "$token1" = "Min.fragment.length" ]; then
      echo "INSERT INTO file_annot_numeric VALUES ('$id', 'min_fragment_length', $token2);" | $SQLITE_CMD
    fi
    if [ "$token1" = "Min.Identity" ]; then
      echo "INSERT INTO file_annot_numeric VALUES ('$id', 'min_identity', $token2);" | $SQLITE_CMD
    fi
    if [ "$token1" = "Tot Hits (seeds)" ]; then
      echo "INSERT INTO file_annot_numeric VALUES ('$id', 'tot_hits_seeds', $token2);" | $SQLITE_CMD
    fi
    if [ "$token1" = "Tot Hits (seeds) used" ]; then
      echo "INSERT INTO file_annot_numeric VALUES ('$id', 'tot_hits_seeds_used', $token2);" | $SQLITE_CMD
    fi
    if [ "$token1" = "Total fragments" ]; then
      echo "INSERT INTO file_annot_numeric VALUES ('$id', 'total_fragments', $token2);" | $SQLITE_CMD
    fi
  done < $i
done
