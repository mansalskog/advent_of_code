BEGIN {	x = y = a = 0; PI = atan2(0, -1); }

{
	c = substr($0, 1, 1);
	d = substr($0, 2) + 0;
	if (c == "E") b = 0;
	else if (c == "N") b = PI / 2;
	else if (c == "W") b = PI;
	else if (c == "S") b = 3 * PI / 2;
	else if (c == "L") { a += d / 180 * PI; d = 0; }
	else if (c == "R") { a -= d / 180 * PI; d = 0; }
	else if (c == "F") b = a;
	x += int(d * cos(b));
	y += int(d * sin(b));
	print x, y, a;
}

END { print "distance", abs(x) + abs(y); }

function abs(x) { return x > 0 ? x : -x; }
