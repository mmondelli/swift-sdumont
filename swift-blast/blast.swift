type fastaseq;
type headerfile;
type indexfile;
type seqfile;
type database 
{
  headerfile phr;
  indexfile pin;
  seqfile psq;
}
type query;
type output;
string num_partitions=arg("n", "8");
string program_name=arg("p", "blastp");
fastaseq dbin <single_file_mapper;file=arg("d", "database")>;
query query_file <single_file_mapper;file=arg("i", "sequence.seq")>;
string expectation_value=arg("e", "0.1"); 
output blast_output_file <single_file_mapper;file=arg("o", 
						       "output.html")>;
string filter_query_sequence=arg("F", "F");
fastaseq partition[] <ext;exec="splitmapper.sh",n=num_partitions>;

app (fastaseq out[]) split_database (fastaseq d, string n)
{
  fastasplitn filename(d) n;
}

app (database out) formatdb (fastaseq i)
{
  formatdb "-i" filename(i);
}

app (output o) blastapp(query i, fastaseq d, string p, string e, string f,
			database db)
{
  blastall "-p" p "-i" filename(i) "-d" filename(d) "-o" filename(o) 
           "-e" e "-T" "-F" f;
}

app (output o) blastmerge(output o_frags[])
{
  blastmerge filename(o) filenames(o_frags);
}

partition=split_database(dbin, num_partitions);

database formatdbout[] <ext; exec="formatdbmapper.sh",n=num_partitions>;
output out[] <ext; exec="outputmapper.sh",n=num_partitions>;

foreach part,i in partition {
  formatdbout[i] = formatdb(part);
  out[i]=blastapp(query_file, part, program_name, expectation_value, 
		  filter_query_sequence, formatdbout[i]);
}

blast_output_file=blastmerge(out);
