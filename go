#!/bin/sh

day=$(date +"%d")
year=$(date +"%y")
dir="y$year/d$day"

if [ -e "$dir" ]; then
    echo "Directory $dir exists, skipping input download"
else
	mkdir "$dir"
	echo "Copying template"
	cp "y$year/templ.awk" "$dir/prog.awk"
	open -a aquamacs "$dir/prog.awk"
	echo "Downloading personal input"
	cookie=$(cat cookie)
	curl "https://adventofcode.com/20$year/day/$day/input" -b "$cookie" --compressed -o "$dir/input"
fi

read -n 1 -p "Download instructions and test data?" ans
echo # add newline
if (echo $ans | grep -q "[yY]"); then
	echo "Downloading instructions"
	curl "https://adventofcode.com/20$year/day/$day" -o "$dir/site.html"
	echo "Extracting test data" # assume data lies in the first <pre> element
	awk '/<pre>/{p=1} /<\/pre>/{nextfile} p{sub(/<pre><code>/,"");print}' "$dir/site.html" >"$dir/test"
else
	echo "Skipping instruction download"
fi
