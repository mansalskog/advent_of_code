#include <stdio.h>

#include "intcode.h"

int main(int argc, const char **argv) {
	prog_t p;
	p_load(&p, argc, argv);
	p_run(&p);
}
