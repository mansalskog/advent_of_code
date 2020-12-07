BEGIN {
}

{
	for (i = 5; i <= NF-3; i += 4) {
		if ($i ~ /^[0-9]+$/) {
			printf("saving %s: %d %s\n", $1 " " $2, $i, $(i+1) " " $(i+2))
			contain[$1 " " $2, $(i+1) " " $(i+2)] = $i
		} else {
			printf("skipping %s", $i $(i+1) $(i+2))
		}
	}
}

END {
	len = front = 1
	queue[len] = "shiny gold"
	while (front <= len) {
		name = queue[front++]
		eventually[name] = 1
		printf("searching %s\n", name)
		for (cn in contain) {
			split(cn,nn,SUBSEP)
			# printf("testing %s\n", nn[1], nn[2])
			if (nn[2] == name) {
				printf("found %s: %s \n", nn[1], nn[2])
				queue[++len] = nn[1]
			}
		}
	}
	tot = 0
	for (n in eventually) {
		if (n != "shiny gold")
			tot++
	}
	printf("total %d\n", tot)
}
