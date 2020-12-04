BEGIN { RS = "" }

{
	for (i = 1; i <= NF; i++) {
		split($i, x, ":")
		# print "adding field", x[1], x[2]
		fs[x[1]] = x[2];
	}

	ok = 1
	if (!("byr" in fs \
	      && "iyr" in fs \
	      && "eyr" in fs \
	      && "hgt" in fs \
	      && "hcl" in fs \
	      && "ecl" in fs \
	      && "pid" in fs))
		ok = 0
	if (!(1920 <= fs["byr"] && fs["byr"] <= 2002 && length(fs["byr"]) == 4))
		ok = 0
	if (!(2010 <= fs["iyr"] && fs["iyr"] <= 2020 && length(fs["iyr"]) == 4))
		ok = 0
	if (!(2020 <= fs["eyr"] && fs["eyr"] <= 2030 && length(fs["eyr"]) == 4))
		ok = 0
	if (!((fs["hgt"] ~ /^[0-9]+cm$/ && 150 <= (fs["hgt"]+0) && (fs["hgt"]+0) <= 193) ||
	      (fs["hgt"] ~ /^[0-9]+in$/ && 59 <= (fs["hgt"]+0) && (fs["hgt"]+0) <= 76)))
		ok = 0
	if (!(fs["hcl"] ~ /^[#][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9]$/))
		ok = 0
	if (!(fs["ecl"] ~ /^(amb|blu|brn|gry|grn|hzl|oth)$/))
		ok = 0
	if (!(fs["pid"] ~ /^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$/))
		ok = 0
	if (ok)
		good++;
	for (n in fs)
		delete fs[n];
}

END { print good, "out of", NR }
