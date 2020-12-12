BEGIN {
}

{ ops[NR] = $1; vals[NR] = $2 }

END {
	changed = 1
	while (!done) {
		print "trying", changed
		if (ops[changed] == "nop") {
			print "from nop to jmp"
			ops[changed] = "jmp"
		} else if (ops[changed] == "jmp") {
			print "from jmp to nop"
			ops[changed] = "nop"
		}
		pc = 1
		acc = 0
		while (1) {
			if (pc > NR) {
				done = 1
				break
			}
			if (pc in ex) {
				print "looped at", pc, "restart"
				# restart
				for (i in ex)
					delete ex[i]
				# change back
				if (ops[changed] == "nop") {
					ops[changed] = "jmp"
				} else if (ops[changed] == "jmp") {
					ops[changed] = "nop"
				}
				changed++
				break
			}
			ex[pc] = 1
			if (ops[pc] == "acc") {
				acc += vals[pc]
			} else if (ops[pc] == "jmp") {
				pc += vals[pc] - 1
			} else if (ops[pc] == "nop") {

			}
			pc += 1
		}
	}
	print "program:"
	for (i = 1; i <= NR; i++)
		print ops[i], vals[i]
	print "acc:", acc, "changed:", changed
}
