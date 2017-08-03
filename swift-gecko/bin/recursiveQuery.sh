#!/bin/bash

db=$1
i=$2
app=$3

if [ $# != 3 ]; then
	echo "***ERROR*** Use: $0 database file_id app"
	exit -1
fi

SQLITE_CMD="sqlite3 -noheader -separator , -batch $db"

$SQLITE_CMD "WITH RECURSIVE anc(ancestor,descendant) AS (SELECT parent AS ancestor, child AS descendant FROM provenance_graph_edge 
WHERE  child='$i' UNION SELECT provenance_graph_edge.parent AS ancestor, anc.descendant AS descendant FROM anc, provenance_graph_edge WHERE  anc.ancestor=provenance_graph_edge.child) SELECT sum(real_secs) as cpu_time, (SELECT sum(value) FROM file_annot_numeric WHERE file_id='$i' and key like 'seq%length') as fasta_length,	(SELECT value FROM file_annot_numeric WHERE file_id='$i' and key like 'min_fragment_length') as min_fragment_length, (SELECT value FROM file_annot_numeric WHERE file_id='$i' and key like 'min_identity') as min_identity,         script_run_args.value as word_length, (SELECT value FROM file_annot_numeric WHERE file_id='$i' and key like 'tot_hits_seeds') as tot_hits_seeds,	(SELECT value FROM file_annot_numeric WHERE file_id='$i' and key like 'tot_hits_seeds_used') as tot_hits_seeds_used, (SELECT value FROM file_annot_numeric WHERE file_id='$i' and key like 'total_fragments') as total_fragmets FROM anc, resource_usage, script_run_args, app_exec WHERE ancestor like '%$app%' and ancestor=resource_usage.app_exec_id and ancestor=app_exec.app_exec_id and script_run_args.script_run_id = app_exec.script_run_id and script_run_args.arg like 'wl';" 
