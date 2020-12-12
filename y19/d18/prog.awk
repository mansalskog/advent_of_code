{
	width = length($0)
	for (x = 1; x <= width; x++) {
		tile[x, NR] = substr($0, x, 1)
		if (tile[x, NR] == "@") {
			ox = x
			oy = NR
		} else if (tile[x, NR] ~ /[a-z]/) {
			numkeys++
		}
	}
}

END {
	height = NR
	tile[ox, oy] = "."
	search(ox SUBSEP oy SUBSEP "")
}

# dist[pos,keys] - the distance from start to pos, holding keys
function search(start,   prev) {
	head = tail = 1
	queue[1] = start
	dist[start] = 0
	while (head <= tail) {
		prev = queue[head++]
		split(prev, tmp, SUBSEP)
		x = tmp[1]
		y = tmp[2]
		keys = tmp[3]
		# print "at", x, y, "with", keys
		# show(x, y, keys)
		if (length(keys) == numkeys) {
			print "DONE at", x, y, "with", keys, "distance", dist[prev]
			exit
		}
		check((x + 1), y, keys, prev)
		check((x - 1), y, keys, prev)
		check(x, (y - 1), keys, prev)
		check(x, (y + 1), keys, prev)

	}
}

function check(x, y, keys, prev,   add) {
	if ((x, y, keys) in dist) {
		# already been at x, y with keys
		return
	}
	if (tile[x, y] ~ /[.@]/) {
		add = 1
	} else if (tile[x, y] ~ /[A-Z]/) {
		# print "at door", tile[x, y]
		if (index(keys, tolower(tile[x, y])) != 0) {
			add = 1
		}
	} else if (tile[x, y] ~ /[a-z]/) {
		# print "found key", tile[x, y]
		keys = insert(keys, tile[x, y])
		add = 1
	}
	if (add) {
		dist[x, y, keys] = dist[prev] + 1
		queue[++tail] = x SUBSEP y SUBSEP keys
	}
}

function insert(keys, key,   i) {
	for (i = 1; i <= length(keys); i++) {
		if (substr(keys, i, 1) == key) {
			return keys
		} else if (substr(keys, i, 1) > key) {
			break
		}
	}
	return substr(keys, 1, i - 1) key substr(keys, i)
}

function show(x, y, keys,   i, j) {
	for (j = 1; j <= height; j++) {
		for (i = 1; i <= width; i++) {
			if (i == x && j == y) {
				printf("@")
			} else if (index(keys, tile[i, j]) > 0 || index(keys, tolower(tile[i, j])) > 0) {
				printf(".")
			} else {
				printf("%s", tile[i, j])
			}
		}
		printf("\n")
	}
}
