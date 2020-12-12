BEGIN {
}

{
	nums[NR] = (0 + $0)
	print nums[NR]
}

END {
	# X = 127;
	X = 20874512;
	for (start = 1; start <= NR; start++) {
		for (end = start; end <= NR; end++) {
			sum = 0
			for (i = start; i <= end; i++) {
				sum += nums[i]
			}
			# print start, end, sum
			if (sum == X) {
				print "found it"
				smallest = 1000000000
				largest = 0
				for (i = start; i <= end; i++) {
					if (nums[i] < smallest)
						smallest = nums[i]
					if (nums[i] > largest)
						largest = nums[i]
				}
				print smallest, largest, smallest + largest
				exit
			}
			if (sum > X) {
				break
			}
		}
	}
}
