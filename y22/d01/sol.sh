sums=$(cat input.txt | awk '{t += $0} /^$/ {print t; t = 0}' | sort -nr)
echo "$sums" | head -1
echo "$sums" | head -3 | awk '{t += $0} END {print t}'
