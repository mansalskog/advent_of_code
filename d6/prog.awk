BEGIN {
	RS = ""
}

{
	m = 0
	for (j = 1; j <= NF; j++) {
		for (i = 1; i <= length($j); i++) {
			l = substr($j,i,1)
			q[l]++
		}
		m++
	}
	n++
	for (l in q) {
		if (q[l] == m)
			g[n]++
		delete q[l]
	}
	printf("%d group said yes to: %d\n", n, g[n])
}

END {
	for (i in q)
		print "fail", i
	for (n in g)
		sum += g[n]
    print "done", sum
}
