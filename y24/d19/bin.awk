{
	for (i = 1; i < +$0; i++) {
		printbits(i);
	}
}

function printbits(x) {
	s = "";
	while (x >= 1) {
		s = (x % 2) s;
		x = int(x / 2);
	}
	print s;
}
