BEGIN {	x = y = 0; wx = 10; wy = 1; PI = atan2(0, -1); }

{
	c = substr($0, 1, 1);
	d = substr($0, 2) + 0;
	if (c == "E") wx += d;
	else if (c == "N") wy += d;
	else if (c == "W") wx -= d;
	else if (c == "S") wy -= d;
	else if (c == "L") while ( (d -= 90) >= 0 ) { tmp = wx; wx = -wy; wy = tmp; }
	else if (c == "R") while ( (d -= 90) >= 0 ) { tmp = -wx; wx = wy; wy = tmp; }
	else if (c == "F") {
		x += d * wx;
		y += d * wy;
	}
	printf("%s, %d %d, %d %d\n", $0, x, y, wx, wy);
}

END { print "distance", abs(x) + abs(y); }

function abs(x) { return x > 0 ? x : -x; }
