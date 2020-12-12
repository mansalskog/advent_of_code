#include <stdio.h>

#include "intcode.h"

int run_with(const prog_t *orig, const int *a) {
	int sig = 0;
	for (int j = 0; j < 5; j++) {
		queue_t in = {0};
		q_insert(&in, a[j]);
		q_insert(&in, sig);
		queue_t out = {0};
		prog_t p;
		p_copy(&p, orig);
		p_run(&p, &in, &out);
		sig = q_remove(&out);
	}
	return sig;
}

void first_part(int argc, const char **argv) {
	prog_t orig;
	p_load(&orig, argc, argv);

	int c[5] = {0};
	int a[5] = {0, 1, 2, 3, 4};

	int max_p = 0;
	int power = run_with(&orig, a);
	if (power > max_p) {
		max_p = power;
	}

	int i = 0;
	while (i < 5) {
		if (c[i] < i) {
			int tmp = a[i];
			if (i % 2 == 0) {
				a[i] = a[0];
				a[0] = tmp;
			} else {
				a[i] = a[c[i]];
				a[c[i]] = tmp;
			}

			power = run_with(&orig, a);
			if (power > max_p) {
				max_p = power;
			}

			c[i]++;
			i = 0;
		} else {
			c[i] = 0;
			i++;
		}
	}

	printf("%d\n", max_p);
}

int run_loop(const prog_t *orig, const int *a) {
	prog_t p[5];
	queue_t in[5] = {0};
	// queue_t out[5] = {0};
	for (int j = 0; j < 5; j++) {
		p_copy(&p[j], orig);
		q_insert(&in[j], a[j]);
	}
	q_insert(&in[0], 0); // signal

	int done[5] = {0};
	int j = 0;
	while (done[0] + done[1] + done[2] + done[3] + done[4] < 5) {
		if (!done[j]) {
			int status = p_run(&p[j], &in[j], &in[(j + 1) % 5]);
			if (status == SIG_END) {
				done[j] = 1;
			}
		}
		j = (j + 1) % 5;
	}
	return q_remove(&in[0]);
}

void second_part(int argc, const char **argv) {
		prog_t orig;
	p_load(&orig, argc, argv);

	int c[5] = {0};
	int a[5] = {5, 6, 7, 8, 9};

	int max_p = 0;
	int power = run_loop(&orig, a);
	if (power > max_p) {
		max_p = power;
	}

	int i = 0;
	while (i < 5) {
		if (c[i] < i) {
			int tmp = a[i];
			if (i % 2 == 0) {
				a[i] = a[0];
				a[0] = tmp;
			} else {
				a[i] = a[c[i]];
				a[c[i]] = tmp;
			}

			power = run_loop(&orig, a);
			if (power > max_p) {
				max_p = power;
			}

			c[i]++;
			i = 0;
		} else {
			c[i] = 0;
			i++;
		}
	}

	printf("%d\n", max_p);
}

int main(int argc, const char **argv) {
	// first_part(argc, argv);
	second_part(argc, argv);
}
