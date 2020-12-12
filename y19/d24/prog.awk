{
	y = NR-1
	width = length($0)
	for (x = 0; x < width; x++) {
		tile[0,x,y] = (substr($0,x+1,1) == "#")
	}
}

END {
	height = NR
	for (k = 0; k < 400; k++) {
		rat[k] = rating(k)
		for (j = 0; j < k; j++) {
			if (rat[j] == rat[k]) {
				print "found repeat with rating",rat[k],":"
				show(k)
				exit
			}
		}
		step(k)
	}
}

function rating(k, x, y, tot) {
	tot = 0
	for (y = 0; y < height; y++) {
		for (x = 0; x < width; x++) {
			if (tile[k,x,y]) {
				tot += 2 ^ (width * y + x)
			}
		}
	}
	return tot
}

function step(k, x, y, near) {
	for (y = 0; y < height; y++) {
		for (x = 0; x < width; x++) {
			near = (x>0 && tile[k,x-1,y]) \
			+ (x<width-1 && tile[k,x+1,y]) \
			+ (y>0 && tile[k,x,y-1]) \
			+ (y<height-1 && tile[k,x,y+1])
			if (tile[k,x,y] && near != 1) {
				tile[k+1,x,y] = 0
			} else if (!tile[k,x,y] && (near == 1 || near == 2)) {
				tile[k+1,x,y] = 1
			} else {
				tile[k+1,x,y] = tile[k,x,y]
			}
		}
	}
}

function show(k, x, y) {
	for (y = 0; y < height; y++) {
		for (x = 0; x < width; x++) {
			printf("%s", tile[k,x,y] ? "#" : ".")
		}
		print ""
	}
	print ""
}
