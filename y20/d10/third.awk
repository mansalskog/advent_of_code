{
	nums[$0] = 1
}

END {
	max = 0
	for (n in nums) {
		n += 0
		if (n > max) max = n
	}
	cache[max] = 1
	print "possible paths", paths(0)
}

function paths(from,   c) {
	if (from in cache) return cache[from]
	c = 0
	if ((from + 1) in nums) c += paths(from + 1)
	if ((from + 2) in nums) c += paths(from + 2)
	if ((from + 3) in nums) c += paths(from + 3)
	cache[from] = c
	return c
}
