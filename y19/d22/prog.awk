BEGIN {
	curr = 1
	# count = 119315717514047
	# count = 10007
	count = 10
	for (k = 1; k <= count; k++) {
		cards[curr, k] = k - 1
	}
}

/deal into new stack/ {
	reverse(curr, curr + 1)
	curr++
}

/deal with increment/ {
	deal(curr, curr + 1, $4)
	curr++
}

/cut/ {
	cut(curr, curr + 1, $2)
	curr++
}

END {
	for (k = 1; k <= count; k++)
		if (cards[curr, k] == 2019)
			print "answer", (k - 1)
	show(curr)
}

function show(src) {
	for (k = 1; k <= count; k++) {
		printf("%d ", cards[src, k])
	}
	printf("\n");
}

function reverse(src, dst,   k) {
	for (k = 1; k <= count; k++) {
		cards[dst, k] = cards[src, count - (k - 1)]
	}
}

function cut(src, dst, N,   k) {
	for (k = 1; k <= count; k++) {
		cards[dst, k] = cards[src, (N + k - 1 + count) % count + 1]
	}
}

function deal(src, dst, N,   k) {
	for (k = 1; k <= count; k++) {
		# cards[dst, (N * (k - 1)) % count + 1] = cards[src, k]
		x = (-N * ((k - 1) % N)) % count
		# printf("%d %d\n", int((k - 1) / N), x)
		cards[dst, k] = cards[src, (int((k - 1) / N) + x + count) % count + 1]
	}
}
