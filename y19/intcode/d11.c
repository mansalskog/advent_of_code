#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "intcode.h"

#define WIDTH 90
#define HEIGHT 30

int main(int argc, const char **argv) {
	prog_t p = {0};
	p_load(&p, argc, argv);
	queue_t in = {0};
	queue_t out = {0};
	int x = WIDTH / 2;
	int y = HEIGHT / 2;
	int dir = 1;
	screen_t *s = s_create(WIDTH, HEIGHT, ' ');
	s_put(s, x, y, '#'); // part 2
	char visited[WIDTH * HEIGHT] = {0};
	int status = SIG_BLOCK;
	while (status != SIG_END) {
		q_insert(&in, s_get(s, x, y) == '#');
		status = p_run(&p, &in, &out);
		s_put(s, x, y, q_remove(&out) ? '#' : ' ');
		visited[x + y * WIDTH] = 1;
		dir = ((dir + (q_remove(&out) ? -1 : 1)) % 4 + 4) % 4;
		switch (dir) {
		case 0:	x++; break;
		case 1:	y--; break;
		case 2:	x--; break;
		case 3:	y++; break;
		}
	}
	int count = 0;
	for (int y = 0; y < HEIGHT; y++) {
		for (int x = 0; x < WIDTH; x++) {
			if (visited[x + y * WIDTH]) count++;
		}
	}
	// printf("painted %d\n", count); // part 1
	s_show(s);
	s_free(s);
}
