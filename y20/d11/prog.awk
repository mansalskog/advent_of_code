{
	W = length($0);
	for (x = 1; x <= W; x++)
		m[x,NR,1] = substr($0,x,1);
}

END {
	H = NR;
	for (g = 1; step(g); g++) {
		# show(g);
	}
	print "g", g, "total", total(g);
}

function show(g) {
	for (y = 1; y <= H; y++) {
		for (x = 1; x <= W; x++) {
			printf("%s", m[x,y,g]);
		}
		print "";
	}
	print "---";
	return tot;
}

function total(g,   tot) {
	tot = 0;
	for (y = 1; y <= H; y++) {
		for (x = 1; x <= W; x++) {
			if (m[x,y,g] == "#") tot++;
		}
	}
	return tot;
}

function step(g,   x,y,occ,chng) {
	chng = 0;
	for (y = 1; y <= H; y++) {
		for (x = 1; x <= W; x++) {
			# occ = near(x,y,g);
			occ = visible(x,y,g);
			if (m[x,y,g] == "L" && occ == 0) {
				m[x,y,g+1] = "#";
				chng++;
			} else if (m[x,y,g] == "#" && occ >= 5) { # >= 4) {
				m[x,y,g+1] = "L";
				chng++;
			} else {
				m[x,y,g+1] = m[x,y,g];
			}
		}
	}
	return chng > 0;
}

function near(x,y,g,   dx,dy,occ) {
	occ = 0;
	for (dy = -1; dy <= 1; dy++) {
		for (dx = -1; dx <= 1; dx++) {
			if (dx == 0 && dy == 0) continue;
			if (x + dx < 1 || x + dx > W) continue;
			if (y + dy < 1 || y + dy > H) continue;
			if (m[x+dx,y+dy,g] == "#") occ++;
		}
	}
	return occ;
}

function visible(x,y,g,  dx,dy,i) {
	if (m[x,y,g] == ".") return 0;
	occ = 0;
	for (dx = -1; dx <= 1; dx++) {
		for (dy = -1; dy <= 1; dy++) {
			if (dx == 0 && dy == 0) continue;
			for (i = 1; ; i++) {
				if (x + i*dx < 1 || x + i*dx > W) break;
				if (y + i*dy < 1 || y + i*dy > H) break;
				if (m[x + i*dx,y + i*dy,g] == "L") break;
				if (m[x + i*dx,y + i*dy,g] == "#") { occ++; break; }
			}
		}
	}
	return occ;
}
