BEGIN { FS = "," }

{
	start_cnt = NF
	for (i = 1; i <= start_cnt; i++) {
		starting[i] = $i;
	}
}

END {
	curr = 0
	turn = 1
	while (turn <= 30000000) {
		if (turn <= start_cnt) {
			# print "starting number"
			curr = starting[turn]
		} else if (count[curr] > 1) {
			# print "last has been said", count[curr], "times, last at", spoken[curr], "before at", before[curr]
			curr = spoken[curr] - before[curr]
		} else {
			# print "last has been said", count[curr]
			curr = 0
		}
		if (turn % 1000000 == 0)
			print "said", curr, "at turn", turn
		count[curr]++
		before[curr] = spoken[curr]
		spoken[curr] = turn
		turn++
	}
	print curr, turn
}
