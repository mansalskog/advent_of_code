!ins {
	j = 1;
	for (i = 2; i < length($0); i += 4) {
		n = substr($0, i, 1);
		if (n ~ /[0-9]/) {
			ins = 1;
			next;
		} else if (n != " ") {
			c[j] = c[j] n;
		}
		j += 1;
	}
}

ins && !part2 {
	for (k = 1; k <= $2; k++) {
		m = substr(c[$4], 1, 1);
		c[$4] = substr(c[$4], 2);
		c[$6] = m c[$6];
	}
}

ins && part2 {
	m = substr(c[$4], 1, $2);
	c[$4] = substr(c[$4], $2 + 1);
	c[$6] = m c[$6];
}

ENDFILE {
	for (j in c) {
		printf("%c", substr(c[j], 1, 1));
	}
	print "";
	if (!part2) {
		/* restart with new move code, pretty hacky */
		ARGC++;
		ARGV[2] = ARGV[1];
		part2 = 1;
		ins = 0;
		delete c;
	}
}
