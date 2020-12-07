BEGIN {
}

{
	for (i = 5; i <= NF-3; i += 4) {
		if ($i ~ /^[0-9]+$/) {
			# printf("saving %s: %d %s\n", $1 " " $2, $i, $(i+1) " " $(i+2))
			contain[$1 " " $2, $(i+1) " " $(i+2)] = $i
		} else {
			printf("skipping %s", $i $(i+1) $(i+2))
		}
	}
}

END {
	printf("total %d\n", find("shiny gold", 1) - 1)
}

function find(name, amt, num) {
	num = amt
	printf("searching %s\n", name)
	for (n in contain) {
		split(n,nn,SUBSEP)
		if (nn[1] == name) {
			printf("found %s %s %d\n", nn[1], nn[2], contain[n] * amt)
			num += find(nn[2], contain[n] * amt)
		}
	}
	return num
}

END {
	exit
	len = front = 1
	queue[len] = "shiny gold"
	count["shiny gold"] = 1
	while (front <= len) {
		name = queue[front++]
		printf("searching %s\n", name)
		for (n in contain) {
			split(n,nn,SUBSEP)
			# printf("testing %s\n", nn[1], nn[2])
			if (nn[1] == name) {
				count[nn[2]] += count[name] * contain[n]
				queue[++len] = nn[2]
				printf("found %s: %s %d \n", nn[1], nn[2], count[nn[2]])
			}
		}
	}
	tot = 0
	for (n in count) {
		if (n != "shiny gold")
			tot += count[n]
	}
	printf("total %d\n", tot)
}
