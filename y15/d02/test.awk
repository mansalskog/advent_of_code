BEGIN { FS = "x" }

{
	w = $1
	h = $2
	l = $3
	smallest = w * h
	if (h * l < smallest) smallest = h * l
	if (l * w < smallest) smallest = l * w
	total += 2 * w * h + 2 * h * l + 2 * l * w + smallest
	print "adding", 2 * w * h + 2 * h * l + 2 * l * w + smallest
}

END { print "total", total }
