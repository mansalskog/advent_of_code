#include <stdio.h>

#include "intcode.h"

int main(int argc, const char **argv) {
	prog_t orig;
	p_load(&orig, argc, argv);

	prog_t p;
	p_copy(&p, &orig);
	p.mem[1] = 12;
	p.mem[2] = 2;
	p_run(&p, NULL, NULL);
	printf("%d\n", p.mem[0]);

	for (int noun = 0; noun <= 99; noun++) {
		for (int verb = 0; verb <= 99; verb++) {
			p_copy(&p, &orig);
			p.mem[1] = noun;
			p.mem[2] = verb;
			p_run(&p, NULL, NULL);
			if (p.mem[0] == 19690720) {
				printf("%d\n", 100 * noun + verb);
				goto done;
			}
		}
	}
done:
	;
}
