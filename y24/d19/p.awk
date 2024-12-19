NR == 1 {
	n = split($0, a, ", ");
	re = "^(";
	sep = 0;
	for (i = 1; i <= n; i++) {
		if (subs && substr(subs, i, 1) != "1") continue;
		if (sep) {
			re = re "|";
			sep = 0;
		}
		re = re "(" a[i] ")";
		sep = 1;
	}
	re = re ")+$";
	# print re;
	# print subs;
} 

($0 ~ re) { ok++ };

END { print ok; }
