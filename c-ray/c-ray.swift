type scene;
type image;
type scene_template;
type movie;

int threads;
int steps;
string resolution;
int delay;
int quality;

threads = toInt(arg("threads","1"));
resolution = arg("resolution","800x600");
steps = toInt(arg("steps","10"));
delay = toInt(arg("delay", "0"));
quality = toInt(arg("quality", "75"));

scene_template template <"tscene">;

app (scene out) generate (scene_template t, int i, int total)
{
	genscenes i total filename(t) stdout=filename(out);
}

app (image o) render (scene i, string r, int t)
{
	"c-ray-mt" "-s" r "-t" t stdin=filename(i) stdout=filename(o);
}

app (movie o) convert (image i[], int d, int q)
{
	convert "-delay" d "-quality" q filenames(i) filename(o);
}

scene scene_files[] <simple_mapper; location=".", prefix="scene.", suffix=".data">;

image image_files[] <simple_mapper; location=".", prefix="scene.", suffix=".ppm">;

movie output_movie <"output.ppm">;

foreach i in [0:steps]{
	scene_files[i] = generate(template, i, steps);
	image_files[i] = render(scene_files[i], resolution, threads);
}

output_movie = convert(image_files, delay, quality);
	


 

