BEGIN {
}

{	
	k = 1;
	row = col = 0;
	for (i = 7; i > 0; i--) {
		if (substr($0,i,1) == "B") {
			row += k;
		}
		k *= 2;
	}
	k = 1;
	for (i = 10; i > 7; i--) {
		if (substr($0,i,1) == "R") {
			col += k;
		}
		k *= 2;
	}
	id = 8 * row + col;
	if (id > maxid)
		maxid = id;
	exist[id] = 1;
	print row, col, id;
}

END {
	for (i = 0; i <= maxid; i++) {
		if (!(exist[i]))
			print "does not exist", i
	}
		
	print "max id", maxid
}
