BEGIN {
	mask = ""
	debug = 0
}

$1 == "mask" {
	# print "setting mask", $3
	mask = $3
	mask_xs = 0
	for (i = 1; i <= length(mask); i++) {
		if (substr(mask, i, 1) == "X") {
			mask_xs++
		}
	}
}

$1 ~ /mem\[.+\]/ {
	sub(/mem\[/, "", $1);
	sub(/\]/, "", $1);
	# tmp = frombin(tobin($3 + 0), mask);
	for (x = 0; x < 2 ^ mask_xs; x++) {
		if (debug) {
			print "x", tobin(x)
			print "<", tobin($1)
			print "m", mask
		}
		idx = convert(tobin($1), mask, tobin(x));
		if (debug) {
			print ">", tobin(idx)
			printf("setting mem[%s] = %d\n", idx, $3 + 0)
		}
		mem[idx] = $3 + 0
		indices[idx] = 1
	}
}

END {
	sum = 0
	for (idx in indices) {
		sum += mem[idx];
	}
	printf("sum is %ld\n", sum)
}

function tobin(dec, bin, i) {
	bin = ""
	for (i = 0; i < 36; i++) {
		bin = (int(dec / (2 ^ i)) % 2) "" bin
	}
	return bin
}

function convert(bin, mask, x, dec, i, j) {
	newbin = ""
	j = 0
	for (i = 0; i < 36; i++) {
		if (length(mask) - i > 0 && substr(mask, length(mask) - i, 1) == "1") {
			# set bit to 1
			newbin = "1" newbin # substr(mask, length(mask) - i, 1);
		} else if (length(mask) - i > 0 && substr(mask, length(mask) - i, 1) == "X") {
			# take bit from x
			newbin = substr(x, length(x) - j, 1) newbin;
			j++
		# } else if (length(bin) - i > 0) {
		} else if (length(mask) - i > 0 && substr(mask, length(mask) - i, 1) == "0") {
			# take bit from bin
			if (length(bin) - i > 0) {
				newbin = substr(bin, length(bin) - i, 1) "" newbin;
			}
		}
	}
	return newbin;
}

function frombin(bin, mask, x, dec, i, j) {
	dec = 0
	j = 0
	for (i = 0; i < 36; i++) {
		if (length(mask) - i > 0 && substr(mask, length(mask) - i, 1) == "1") {
			# set bit to 1
			dec += 2 ^ i * 1 # substr(mask, length(mask) - i, 1);
		} else if (length(mask) - i > 0 && substr(mask, length(mask) - i, 1) == "X") {
			# take bit from x
			dec += 2 ^ i * substr(x, length(x) - j, 1);
			j++
		# } else if (length(bin) - i > 0) {
		} else if (length(mask) - i > 0 && substr(mask, length(mask) - i, 1) == "0") {
			# take bit from bin
			if (length(bin) - i > 0) {
				dec += 2 ^ i * substr(bin, length(bin) - i, 1);
			}
		}
	}
	return dec;
}
