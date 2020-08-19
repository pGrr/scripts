#!/usr/bin/python3
import argparse
import os
import sys
import shutil
from typing import List

STYLE = os.path.dirname(sys.argv[0]) + os.path.sep + "include.html"
VALID_EXTENSIONS_PDF = [".pdf"]
VALID_EXTENSIONS_HTML = [".html", ".jpg", ".jpeg", ".gif", ".png", ".apng", ".svg", ".bmp"]

def parse() -> argparse.Namespace:
    """
    Parse command line arguments, checks they are correct and provides help
    """
    parser = argparse.ArgumentParser(
        description="""
        Given a root directory containing markdown files organized in an hierarchial way 
        - i.e. with subdirectories - this script converts them recursively using pandoc.

        Currently 2 output formats are available: html and pdf.

        1. The given source folder is recursively copied into the output folder and then 
        recursively scanned for markdown files.

        2. Each found markdown file will be converted to the specified format in its current 
        directory inside the output directory (the original files are not modified in any way).

        3. Output folder is cleaned: 
            - old pdf or html directories will be deleted. 
            - any non-output file will be removed. 
                - On html conversions, only html and image files will be kept. 
                - On pdf conversion only pdf will be kept.
            - Any empty directory will be deleted.
        
        By default output html files are styled using pandoc.css, but you can apply a custom css 
        style by pasting your css into include.html's <style> tags.
        Pdfs are compiled using xelatex and thus have the classic Latex's style.

        Source and output folders can be specified. If not: 
        - the default source folder will be the current working directory. 
        - the default output folder will be a directory named as the output type (e.g. pdf or html) placed inside the source folder    
        """,
        formatter_class=argparse.RawTextHelpFormatter)
    parser.add_argument(
        "TYPE", 
        help="""
        The output file type
        """, 
        choices=['pdf', 'html'],
        type=str)
    parser.add_argument(
        "-s",
        "--source-root",
        help="""
        The source directory - Default is the current working directory
        """,
        type=str)
    parser.add_argument(
        "-o", 
        "--output-root", 
        help="""
        The output directory - Default is a directory named as the output type (e.g. "pdf" or "html") placed inside the source folder. 
        """, 
        type=str)
    return parser.parse_args()

def copy_tree(in_root: str, out_root: str):
    """
    Copies recursively in_root into out_root.
    If in_root exists, it asks for confirmation and then deletes it before copying.
    """
    if os.path.exists(out_root):
        while True:
            print("The directory " + out_root + " already exists. All its' content will be lost! Are you sure you wish to continue? (y/n)")
            choice = input()
            print()
            if choice == 'n':
                print("Ok, bye!")
                sys.exit(0)
            elif choice == 'y':
                print("Removing tree starting at " + out_root + " ...")
                shutil.rmtree(out_root)
                break
    print("Copying tree starting at " + in_root + " into " + out_root +  " ...")
    shutil.copytree(in_root, out_root)
    print("Done.", end="\n\n")

def call_pandoc(input: str, output: str, conversion_to: str) -> int:
    """
    Calls the appropriate pandoc command for the chosen output type
    """
    if conversion_to == 'html':
        return os.system('pandoc -f markdown+pandoc_title_block -t html5 --webtex -s --toc -H ' + STYLE + ' -o ' + output + ' ' + input)
    elif conversion_to == 'pdf':
        return os.system('pandoc --pdf-engine=xelatex -o ' + output + ' ' + input)

def recursive_conversion(tree_root: str, conversion_to: str):
    """
    Recursively convert all markdown files starting from the given root directory
    """
    for root, dirs, files in os.walk(tree_root):
        for filename in files:
            if os.path.splitext(filename)[1] == ".md":
                input_path = os.path.join(root, filename)
                output_path = os.path.splitext(input_path)[0] + "." + conversion_to
                print("Creating " + output_path + " ... ")
                exit_status = call_pandoc(input_path, output_path, conversion_to)
                if exit_status != 0:
                    print("\nPANDOC ERROR: execution aborted.\n")
                    sys.exit(1)
    print("Conversion finished successfully.", end="\n\n")

def recursively_remove_files(extensions: List[str], tree_root:str, neg: bool):
    """
    Recursively removes files starting from the given tree_root. 
    if neg == False (default) it deletes files that match any of the extensions
    if neg == True it preserves only files that match any of the extensions, removing any other
    """
    for root, dirs, files in os.walk(tree_root):
        for filename in files:
            file_ext = os.path.splitext(filename)[1]
            if not neg and any(ext == file_ext for ext in extensions) \
                or neg and all(ext != file_ext for ext in extensions):
                    rmvfile = os.path.join(root, filename)
                    print("Removing " + rmvfile + " ...")
                    os.remove(os.path.join(root, filename))
    print("Done.", end="\n\n")

def recursively_remove_empty_dirs(tree_root: str):
    """
    Removes all empty directories recursively, starting from the given tree_root
    """
    print("Recursively removing all empty directories...")
    for root, dirs, files in os.walk(tree_root, topdown=False):
        if len(dirs) == 0 and len(files) == 0:
            print("Removing " + root + " ...")
            os.rmdir(root)
    print("Done.", end="\n\n")

def main():
    """
    Main is called oly when the script is executed, not when imported as a module.
    """
    args = parse()
    in_root = args.source_root if args.source_root is not None else "."
    out_root = args.output_root if args.output_root is not None else in_root + os.path.sep + args.TYPE
    copy_tree(in_root, out_root)
    print("Removing any old \"html\" or \"pdf\" directory inside the output directory...")
    try:
        shutil.rmtree(os.path.join(out_root + os.path.sep + "pdf"))
        print("\"pdf\" folder removed.")
    except:
        print("\"pdf\" folder not found.")
    try:
        shutil.rmtree(os.path.join(out_root + os.path.sep + "html"))
        print("\"html\" folder removed.")
    except:
        print("\"html\" folder not found.")
    print("Done.", end="\n\n")
    recursive_conversion(out_root, args.TYPE)
    print("Cleaning files...")
    if args.TYPE == "html":
        recursively_remove_files(VALID_EXTENSIONS_HTML, out_root, True) # remove all NOT valid html files
    elif args.TYPE == "pdf":
        recursively_remove_files(VALID_EXTENSIONS_PDF, out_root, True) # remove all NOT valid pdf files
    recursively_remove_empty_dirs(out_root)
    print("All done. Bye!", end="\n\n")

# execute the main only when the script is executed, not when it's imported as a module
if __name__ == "__main__":
    main()
