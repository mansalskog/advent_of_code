BEGIN {
	# N = 5
	N = 25
}

{
	if (NR > N) {
		ok = 0
		for (i = 1; i <= N && i <= NR && !ok; i++) {
			# print "trying", nums[i]
			for (j = 1; j <= N && j <= NR && !ok; j++) {
				if (nums[i] + nums[j] == $0) {
					ok = 1
				}
			}
		}
	} else {
		ok = 1
	}
	if (!ok) {
		print "found", $0
		exit
	}
	# print "saving", $0, "at", NR
	nums[(NR - 1) % N + 1] = (0 + $0)
}

END {
}
