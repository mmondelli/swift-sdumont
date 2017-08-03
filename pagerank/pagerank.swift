type file; 

#USE: swift pagerank.swift -word=Brazil

string w = arg("word");

file text[] <filesys_mapper; location="./raw.en3", prefix="english">;
file select[] <simple_mapper; location="./select", prefix="select", suffix=".txt">;
file count[] <simple_mapper; location="./count", prefix="count_word", suffix=".txt">;
file group <"group.txt">;
file sort <"sort.txt">;

app (file o) select_word (file i, string word)
{
	grep "-o" "-w" word filename(i) stdout=filename(o);
}

app (file o) count_word (file i)
{
	wc "-w" filename(i) stdout=filename(o);
}

app (file o) group_count (file i[])
{
	cat filenames(i) stdout=filename(o);
}

app (file o) sort (file i)
{
	sort "-n" filename(i) stdout=filename(o);
}

foreach t,i in text
{
	select[i] = select_word(t, w);
	count[i] = count_word(select[i]);
	
}

group = group_count(count);
sort = sort(group);

