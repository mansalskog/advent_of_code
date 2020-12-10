{
	a[NR] = $0 + 0
}

END {
	N = NR + 1
	a[N] = 0
	i = N
	used[i] = 1
	while (1) {
		printf("at %d\n", a[i])
		n = 0
		for (j = 1; j <= N; j++) {
			if (j in used) continue
			if (a[i] <= a[j] && a[j] <= a[i] + 3)
				if (n == 0 || a[j] < a[n])
					n = j
		}
		if (n == 0) {
			print "done"
			break
		}
		printf("going to %d\n", a[n])
		if (a[n] - a[i] == 1) ones++
		if (a[n] - a[i] == 3) threes++
		i = n
		used[i] = 1
	}
	threes++ # last step
	printf("result %d %d %d\n", ones, threes, ones * threes);
}
