type file;

file hello <"hello.txt">;

app (file o) echo (string s) 
{ 
   echo s stdout=filename(o); 
}

hello = echo("hi");
