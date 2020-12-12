#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "intcode.h"

#define WIDTH 60
#define HEIGHT 25

int find_x(screen_t *s, char c) {
	for (int y = 0; y < HEIGHT; y++) {
		for (int x = 0; x < WIDTH; x++) {
			if (s_get(s, x, y) == c) return x;
		}
	}
	return -1;
}

int main(int argc, const char **argv) {
	prog_t p;
	p_load(&p, argc, argv);

	screen_t *s = s_create(WIDTH, HEIGHT, ' ');
	int score = 0;

	int sig = SIG_BLOCK;
	p.mem[0] = 2; // part 2
	while (sig != SIG_END) {
		int dir = 0;
		int pad_x = find_x(s, '=');
		int ball_x = find_x(s, '0');
		if (pad_x < ball_x) {
			dir = 1;
		} else if (pad_x > ball_x) {
			dir = -1;
		}
		queue_t in = {0};
		q_insert(&in, dir);
		queue_t out = {0};
		sig = p_run(&p, &in, &out);
		while (!q_empty(&out)) {
			int x = q_remove(&out);
			int y = q_remove(&out);
			int t = q_remove(&out);
			if (x == -1 && y == 0) {
				score = t;
			} else {
				switch (t) {
				case 0:	s_put(s, x, y, ' '); break;
				case 1:	s_put(s, x, y, '%'); break;
				case 2:	s_put(s, x, y, '#'); break;
				case 3:	s_put(s, x, y, '='); break;
				case 4:	s_put(s, x, y, '0'); break;
				}
			}
		}
		printf("score: %d\n", score);
		s_show(s);
	}
	int blocks = 0;
	for (int y = 0; y < HEIGHT; y++) {
		for (int x = 0; x < WIDTH; x++) {
			if (s_get(s, x, y) == '#') blocks++;
		}
	}
	// printf("blocks %d\n", blocks); // part 1
	s_free(s);
}
