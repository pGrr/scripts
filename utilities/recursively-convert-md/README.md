# recursively-convert-md

## A python script to recursively convert markdown files into html or pdf preserving the directory tree

Given a root directory containing markdown files organized in an hierarchial way - i.e. with subdirectories - this script converts them recursively using __[pandoc](https://pandoc.org/)__. 

Currently __2 output formats are available: html and pdf__.

1. The given source folder is recursively copied into the output folder and then recursively scanned for markdown files. 
2. Each found markdown file will be converted to the specified format in its' current directory inside the output directory (__the original files are not modified in any way__). 
3. Output folder is cleaned:
    * old `pdf` or `html` directories will be deleted. 
    * any non-output file will be removed
        * on html conversions, only html and image files will be kept (images are preserved in order to not break html links)
        * on pdf conversion only pdf will be kept
    * any empty directory will be deleted 

By default output html files are styled using __[pandoc.css](https://gist.github.com/killercup/5917178)__, but you can __apply a custom css style__ by pasting your css into `include.html`'s `<style>` tags. 

Pdfs are compiled using `xelatex` and thus have the classic `Latex`'s style.

__Source and output folders can be specified__. 

If not: 

* the default source folder will be the current working directory
* the default output folder will be a directory named as the output type (e.g. `pdf` or `html`) placed inside the source folder

### Positional arguments:

* `{pdf,html}`            
  * The output file type

### Optional arguments:

* `-h, --help`
  * show this help message and exit
* `-s SOURCE_ROOT, --source-root SOURCE_ROOT`
  * The source directory - i.e. the root directory from which to start recursive search of markdown files.
  * Default is the current working directory
* `-o OUTPUT_ROOT, --output-root OUTPUT_ROOT`
  * The output directory - i.e. the root directory that will contain a copy of the source folder containing only the markdown files converted (and eventually image files). 
  * Default is a directory named as the output type (e.g. `pdf` or `html`) placed inside the source folder.

## Usage examples

* `./recursively_convert_md html` 
  * will copy the current directory `.` into a newly created directory `./html`. Then will search it recursively converting all markdown files inside  current directory to html. Then all "old" files (except for images) will be deleted and all empty directories too.
* `./recursively_convert_md -o ../mydir html`
  * same as above but will use the specified output folder instead of the default one
* `./recursively_convert_md -s ../mysourcedir -o ../example/myoutdir pdf`
  * same as above but will use both the specified source and output directories, also this time the output files will be pdf

## Dependencies

You must have [pandoc](https://pandoc.org/installing.html) and [xelatex](https://en.wikipedia.org/wiki/XeTeX) (for pdfs) installed.

On ubuntu you can install them with the following commands:
* `sudo apt install pandoc`
* `sudo apt install texlive-xetex`
