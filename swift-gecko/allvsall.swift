type file;

string length = arg("l", "100");
string similarity = arg("s", "65");
string wl = arg("wl", "12");
string fixedl = arg("fl", "1");

file fasta[] <filesys_mapper;suffix=".fasta">;
file fastarc[] <simple_mapper;prefix="g", suffix=".fastarc", padding=1>;
file wordsUnsort[] <simple_mapper;prefix="g", suffix=".wu", padding=1>;
file wordsSorted[] <simple_mapper;prefix="g", suffix=".ws", padding=1>;
file wordsUnsortrc[] <simple_mapper;prefix="g", suffix="-rc.wu", padding=1>;
file wordsSortedrc[] <simple_mapper;prefix="g", suffix="-rc.ws", padding=1>;

file d2hP[] <simple_mapper;prefix="g", suffix=".d2hP", padding=1>;
file d2hW[] <simple_mapper;prefix="g", suffix=".d2hW", padding=1>;

file d2hPrc[] <simple_mapper;prefix="g", suffix="-rc.d2hP", padding=1>;
file d2hWrc[] <simple_mapper;prefix="g", suffix="-rc.d2hW", padding=1>;

file hits[][] <simple_mapper;prefix="g", suffix=".hits", padding=1>;
file hitSorted[][] <simple_mapper;prefix="g", suffix=".s", padding=1>;
file hitFiltered[][] <simple_mapper;prefix="g", suffix=".f", padding=1>;

file frags[][] <simple_mapper;prefix="g", suffix=".frags", padding=1>;
file inf[][] <simple_mapper;prefix="g", suffix=".frags.INF", padding=1>;
file mat[][] <simple_mapper;prefix="g", suffix=".frags.MAT", padding=1>;

file fragsF[][] <simple_mapper;prefix="g", suffix=".fragsF", padding=1>;
file infF[][] <simple_mapper;prefix="g", suffix=".fragsF.INF", padding=1>;
file matF[][] <simple_mapper;prefix="g", suffix=".fragsF.MAT", padding=1>;

file csv[][] <simple_mapper;prefix="g", suffix=".csv", padding=1>;


app (file o) reverseComplement (file i)
{
	reverseComplement filename(i) filename(o);
}

app (file o) words (file i)
{
	words filename(i) filename(o);
}

app (file o) sortWords (file i)
{
	sortWords "10000000" "32" filename(i) filename(o);
}

app (file o, file q) w2hd (file i, string s)
{
	w2hd filename(i) s;
}

app (file o) hits (string a, string b, file i1, file i2, file i3, file i4, string wl)
{
	hits a b filename(o) "1000" wl;
}

app (file o) sortHits (file i)
{	
	sortHits "10000000" "32" filename(i) filename(o);
}

app (file o) filterHits (file i, string wl)
{
	filterHits filename(i) filename(o) wl;
}

app (file o1, file o2, file o3) fragHits (file f1, file f2, file f3, string l, string s, string wl, string fl, string op)
{
	FragHits filename(f1) filename(f2) filename(f3) filename(o1) l s wl fl op; 
}

app (file o1, file o2, file o3) combineFrags (file i1, file i2, file i3, file i4, file i5, file i6)
{	
	combineFrags filename(i1) filename(i2) filename(o1);
}

#file csv <simple_mapper;prefix=strcat(g1, g2), suffix=".csv">;
#file temp <"temp.csv">;

app (file o) csvGenerator (file i1, file i2)
{
	csvGenerator filename(i1) filename(i2) filename(o);
}

#(csv) = csvGenerator(c1, c2);

foreach f,i in fasta
{
	fastarc[i] = reverseComplement(fasta[i]);
	wordsUnsort[i] = words(fasta[i]);
	wordsSorted[i] = sortWords(wordsUnsort[i]);

	wordsUnsortrc[i] = words(fastarc[i]);
	wordsSortedrc[i] = sortWords(wordsUnsortrc[i]);

	(d2hP[i], d2hW[i]) = w2hd(wordsSorted[i], strcat("g", i));
	
	(d2hPrc[i], d2hWrc[i]) = w2hd(wordsSortedrc[i], strcat("g", i, "-rc"));

	tracef("Fasta [%d]: %s", i, filename(f));
}

foreach f, i in fasta 
{
	foreach g, j in fasta
	{
		if(i < j) {
		  hits[i][j] = hits(strcat("g", i), strcat("g", j), d2hW[i], d2hW[j], d2hP[i], d2hP[j], wl);
		  hitSorted[i][j] = sortHits(hits[i][j]);
		  hitFiltered[i][j] = filterHits(hitSorted[i][j], wl);
		  (frags[i][j], inf[i][j], mat[i][j]) = fragHits(fasta[i], fasta[j], hitFiltered[i][j], length, similarity, wl, fixedl, "f");
	
		  hits[j][i] = hits(strcat("g", i), strcat("g", j, "-rc"), d2hWrc[j], d2hW[i], d2hPrc[j], d2hP[i], wl);
		  hitSorted[j][i] = sortHits(hits[j][i]);
		  hitFiltered[j][i] = filterHits(hitSorted[j][i], wl);
		  (frags[j][i], inf[j][i], mat[j][i]) = fragHits(fasta[i], fastarc[j], hitFiltered[j][i], length, similarity, wl, fixedl, "r");
	

	(fragsF[i][j], infF[i][j], matF[i][j]) = combineFrags(frags[i][j], frags[j][i], inf[i][j], inf[j][i], mat[i][j], mat[j][i]);
	
	csv[i][j] = csvGenerator(fragsF[i][j], infF[i][j]);
		}	
	}
}

