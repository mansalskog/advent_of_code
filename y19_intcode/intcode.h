#ifndef INTCODE_H
#define INTCODE_H

#define PROG_DEBUG 0
#define PROG_MAX_LEN 10000
#define QUEUE_MAX_LEN 10000

#define SIG_END 0
#define SIG_BLOCK 1

typedef struct prog {
	int mem[PROG_MAX_LEN];
	int len;
	int pc;
} prog_t;

typedef struct queue {
	int data[QUEUE_MAX_LEN];
	int head;
	int tail;
} queue_t;

void p_load(prog_t *p, int argc, const char **argv);
void p_copy(prog_t *dst, const prog_t *src);
int p_run(prog_t *p, queue_t *in, queue_t *out);

int q_empty(queue_t *q); // check status
void q_insert(queue_t *q, int val); // to back
int q_remove(queue_t *q); // from front
void q_clear(queue_t *q); // delete all items


#endif
