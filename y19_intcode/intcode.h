#ifndef INTCODE_H
#define INTCODE_H

#define PROG_DEBUG 1
#define PROG_MAX_LEN 10000

typedef struct prog {
	int mem[PROG_MAX_LEN];
	int len;
	int pc;
} prog_t;

void p_load(prog_t *p, int argc, const char **argv);
void p_copy(prog_t *dst, const prog_t *src);
void p_run(prog_t *p);

#endif
