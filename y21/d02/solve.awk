/forward/ {h += $2; d += a * $2}
/down/ {#d += $2;
	a += $2}
/up/ {#d -= $2;
   	a -= $2}
# {print d, h, a}
END {print d * h}
