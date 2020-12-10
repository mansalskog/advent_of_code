#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <stdarg.h>

#include "intcode.h"

#define MODE_POS 0
#define MODE_IMM 1

#define OP_ADD 1
#define OP_MUL 2
#define OP_INP 3
#define OP_OUT 4
#define OP_JNZ 5
#define OP_JZ 6
#define OP_LT 7
#define OP_EQ 8
#define OP_END 99

int OP_ARGS[] = {
	[OP_ADD] = 3,
	[OP_MUL] = 3,
	[OP_INP] = 1,
	[OP_OUT] = 1,
	[OP_JNZ] = 2,
	[OP_JZ] = 2,
	[OP_LT] = 3,
	[OP_EQ] = 3,
	[OP_END] = 0
};

void debug(int level, const char *msg, ...);
void error(const char *msg, ...);

void p_load(prog_t *p, int argc, const char **argv) {
	if (argc != 2) {
		error("Invalid number of arguments %d, expected 1", argc - 1);
	}
	FILE *f = fopen(argv[1], "r");
	if (!f) {
		error("Couldn't open file");
	}
	int op;
	p->len = 0;
	while (fscanf(f, "%d,", &op) != EOF) {
		if (p->len >= PROG_MAX_LEN) {
			error("Too long program, maximum length is %d", PROG_MAX_LEN);
		}
		p->mem[p->len++] = op;
	}
	p->pc = 0;
}

void p_copy(prog_t *dst, const prog_t *src) {
	memcpy(dst, src, sizeof *dst);
}

int p_run(prog_t *p, queue_t *in, queue_t *out) {
	while (1) {
		int instr = p->mem[p->pc];
		if (instr < 0) {
			error("Instruction cannot be negative: %d", instr);
		}
		int op = instr % 100;
		int mode = instr / 100;
		int *a[3] = {0};
		for (int i = 0; i < OP_ARGS[op]; i++) {
			a[i] = &p->mem[p->pc + 1 + i];
			debug(20, "parameter %d has mode %d", i, mode % 10);
			if (mode % 10 == MODE_POS) {
				a[i] = &p->mem[*a[i]];
			}
			if (i == 3 && mode % 10 == MODE_IMM) {
				error("Output cannot be in immediate mode");
			}
			mode /= 10;
		}
		switch (op % 100) {
		case OP_ADD:
			debug(10, "adding %d + %d", a[0], a[1]);
			*a[2] = *a[0] + *a[1];
			break;
		case OP_MUL:
			debug(10, "multiplying %d * %d", a[0], a[1]);
			*a[2] = *a[0] * *a[1];
			break;
		case OP_INP:
			if (in == NULL) {
				scanf("%d", a[0]);
			} else {
				if (q_empty(in)) {
					return SIG_BLOCK;
				}
				*a[0] = q_remove(in);
			}
			debug(10, "read input %d", *a[0]);
			break;
		case OP_OUT:
			debug(10, "writing output %d", *a[0]);
			if (out == NULL) {
				printf("%d\n", *a[0]);
			} else {
				q_insert(out, *a[0]);
			}
			break;
		case OP_JNZ:
			debug(10, "jumping to %d if %d != 0", *a[1], *a[0]);
			if (*a[0] != 0) {
				p->pc = *a[1] - 1 - OP_ARGS[op];
			}
			break;
		case OP_JZ:
			debug(10, "jumping to %d if %d == 0", *a[1], *a[0]);
			if (*a[0] == 0) {
				p->pc = *a[1] - 1 - OP_ARGS[op];
			}
			break;
		case OP_LT:
			debug(10, "comparing %d < %d", *a[0], *a[1]);
			*a[2] = *a[0] < *a[1];
			break;
		case OP_EQ:
			debug(10, "comparing %d == %d", *a[0], *a[1]);
			*a[2] = *a[0] == *a[1];
			break;
		case OP_END:
			debug(10, "halting");
			return SIG_END;
		default:
			error("Invalid opcode %d", op);
		}
		p->pc += 1 + OP_ARGS[op];
	}
}

int q_empty(queue_t *q) {
	return q->head >= q->tail;
}

void q_insert(queue_t *q, int val) {
	if (q->tail >= QUEUE_MAX_LEN) {
		error("Too long queue, max length is %d", QUEUE_MAX_LEN);
	}
	q->data[q->tail++] = val;
}

int q_remove(queue_t *q) {
	if (q_empty(q)) {
		error("Reading past end of queue");
	}
	return q->data[q->head++];
}

void q_clear(queue_t *q) {
	q->head = q->tail = 0;
}

void debug(int level, const char *msg, ...) {
	va_list args;
	va_start(args, msg);
	if (PROG_DEBUG >= level) {
		vfprintf(stderr, msg, args);
		fputc('\n', stderr);
	}
}

void error(const char *msg, ...) {
	if (errno) {
		perror(msg);
	} else {
		va_list args;
		va_start(args, msg);
		vfprintf(stderr, msg, args);
		fputc('\n', stderr);
	}
	exit(EXIT_FAILURE);
}
