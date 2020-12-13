BEGIN {
	FS = ","
}

NR == 1 {
	start = $1
}

NR == 2 {
	min_d = 1e9;
	min_id = -1;
	for (i = 1; i <= NF; i++) {
		if ($i == "x") continue;
		nums[++count] = $i + 0;
		depart = int(1 + start / $i) * $i - start;
		printf("%d ", $i)
		if (depart < min_d) {
			min_d = depart
			min_id = $i
		}
	}
	print ""
	print min_id, min_d, min_d * min_id;
	ok = 0;
	for (t = 2622062845747423; !ok; t++) {
		# print "testing", t
		ok = 1;
		for (i = 1; i <= NF; i++) {
			if ($i == "x") continue;
			if (t % $i != ((- i + 1) + $i) % $i) {
				# printf("failed at %g %g %g\n", i, $i, (t + i - 1) % $i);
				ok = 0;
				break;
			}
		}
	}
	print "found", t-1
	exit
}

function lcm(   i, min, max, min_i) {
	for (i = 1; i <= count; i++) {
		tmp[i] = nums[i];
	}
	while (1) {
		min = 1e10;
		max = 0;
		min_i = -1;
		for (i = 1; i <= count; i++) {
			if (tmp[i] <= min) {
				min = tmp[i];
				min_i = i;
			}
			if (tmp[i] >= max) {
				max = tmp[i];
			}
		}
		if (min == max) return min;
		tmp[min_i] += nums[min_i];
	}
}

END {

}
