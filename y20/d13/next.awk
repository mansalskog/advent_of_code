BEGIN { FS = "," }

NR == 2 {
	for (i = 1; i <= NF; i++) {
		if ($i == "x") continue;
		n[++cnt] = $i + 0;
		# print $i, "at", i - 1
		a[cnt] = ((- i + 1) % n[cnt] + n[cnt]) % n[cnt];
		printf("x = %d mod %d\n", a[cnt], n[cnt])
	}
	solvenew()
}

function solvenew() {
	x = 0;
	mul = 1;
	for (i = 1; i <= cnt; i++) {
		while (x % n[i] != a[i])
			x += mul;
		mul *= n[i];
	}
	printf("x = %d\n", x);
}

function solve() {
	for (i = 1; i <= cnt; i++) {
		N[i] = 1;
		for (j = 1; j <= cnt; j++) {
			if (j != i)
				N[i] *= n[j];
		}
		eeuc(N[i], n[i]);
		M[i] = ma;
	}
	x = 0;
	lcm = 1;
	for (i = 1; i <= cnt; i++) {
		x += a[i] * M[i] * N[i];
		lcm *= n[i];
	}
	x = (x % lcm + lcm) % lcm;
	printf("lcm = %d, x = %d\n", lcm, x)
}

function badsolve() {
	for (i = cnt; i > 1; i--) {
		eeuc(a[i-1], a[i])
		a[i-1] = a[i-1] * m2 * n[i] + a[i] * m1 * n[i-1];
		n[i-1] = n[i-1] * n[i];
		printf("new: x = %d mod %d\n", a[i-1], n[i-1]);
	}
}

function eeuc(a, b) {
	print "euclidean", a, b
	old_r = a
	r = b
	old_s = 1
	s = 0
	old_t = 0
	t = 1
	while (r != 0) {
		quot = int(old_r / r)
		tmp = old_r
		old_r = r
		r = tmp - quot * r
		tmp = old_s
		old_s = s
		s = tmp - quot * s
		tmp = old_t
		old_t = t
		t = tmp - quot * t
	}
	gcd = old_r
	ma = old_s
	mb = old_t
	printf("gcd = %d, ma = %d, mb = %d\n", gcd, ma, mb);
}
