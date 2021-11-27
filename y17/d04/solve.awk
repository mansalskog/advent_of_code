{
	n++;
	delete w;
	for (i = 1; i <= NF; i++) {
		print $i | grep -o
		print s
		if ($i in w) {
			n--;
			break;
		}
		w[$i] = 1;	
	}
}
END { print n }
