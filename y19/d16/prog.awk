BEGIN {
	base[1] = 0
	base[2] = 1
	base[3] = 0
	base[4] = -1
	passes = 50
}

{
	for (n = 0; n < length($0); n++)
		input[n + 1] = 0 + substr($0, n + 1, 1)
	for (k = 1; k <= passes; k++) {
		printf("running pass %d of %d\n", k, passes);
		phase(input, output, n)
		phase(output, input, n)
	}
	show(input, 8)
}

function show(input, n,   k) {
	for (k = 1; k <= n; k++)
		printf("%d", input[k])
	printf("\n");
}

function phase(input, output, n,   k) {
	for (k = 1; k <= n; k++) {
		output[k] = sample(input, n, k)
		# printf("setting sample %d to %d\n", k, output[k])
	}
}

function sample(input, n, k,   s, j) {
	s = 0
	for (j = 1; j <= n; j++) {
		i = int(j / k) % 4 + 1
		s += input[j] * base[i]
	}
	return (s >= 0 ? s : -s) % 10
}
