#ifndef INTCODE_H
#define INTCODE_H

#define PROG_MAX_LEN 100000
#define QUEUE_MAX_LEN 100000

#define SIG_END 0
#define SIG_BLOCK 1

typedef long long ic_t;

typedef struct prog {
	ic_t mem[PROG_MAX_LEN];
	size_t len;
	size_t pc;
	size_t base;
	int debug;
} prog_t;

typedef struct queue {
	ic_t data[QUEUE_MAX_LEN];
	size_t head;
	size_t tail;
} queue_t;

typedef struct screen {
	char *tile;
	int width;
	int height;
} screen_t;

void p_load(prog_t *p, int argc, const char **argv);
void p_copy(prog_t *dst, const prog_t *src);
int p_run(prog_t *p, queue_t *in, queue_t *out);

int q_empty(queue_t *q); // check status
void q_insert(queue_t *q, ic_t val); // to back
ic_t q_remove(queue_t *q); // from front
void q_clear(queue_t *q); // delete all items

screen_t *s_create(int w, int h, char fill);
void s_free(screen_t *s);
void s_show(screen_t *s);
void s_put(screen_t *s, int x, int y, char c);
char s_get(screen_t *s, int x, int y);

#endif
