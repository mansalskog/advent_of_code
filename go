#!/bin/sh
# Usage: go [day] [year]
# Note: this is compatible with /bin/sh,
# except for some reason read -r does not work

base=$(cd "$(dirname "$0")" && pwd)
tmp=$("$base/getday" "$@")
day=$(echo "$tmp" | cut -d' ' -f1)
year=$(echo "$tmp" | cut -d' ' -f2)
dir=$(echo "$tmp" | cut -d' ' -f3)

# Create directory or fail if it is a file
mkdir -p "$dir" || exit 1

if [ -e "$dir/input" ]; then
    echo "Input file $dir/input exists, skipping donwload"
else
	echo "Downloading personal input"
	cookie=$(cat cookie)
	curl "https://adventofcode.com/20$year/day/$day/input" -b "$cookie" --compressed -o "$dir/input"
fi

if [ -e "$dir/test" ]; then
	echo "Test file $dir/test exists, skipping download"
else
	echo "Downloading instructions and extracting test data"
	# assume data lies in the first <pre> element, within a <code>
	curl "https://adventofcode.com/20$year/day/$day" |\
	   	awk '/<pre>/{p=1} /<\/pre>/{nextfile} p{sub(/<pre><code>/,"");print}' >"$dir/test"
fi
