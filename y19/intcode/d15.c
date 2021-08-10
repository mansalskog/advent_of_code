#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "intcode.h"

#define W 80
#define H 50

#define NORTH 1
#define SOUTH 2
#define WEST 3
#define EAST 4

int next_dir(screen_t *s, int dir, int x, int y, int r) {
	if (rand() % 10 == 0) return dir;
	switch (dir) {
	case NORTH: return WEST;
	case WEST: return SOUTH;
	case SOUTH: return EAST;
	case EAST: return NORTH;
	}
}

int main(int argc, const char **argv) {
	prog_t p;
	p_load(&p, argc, argv);

	screen_t *s = s_create(W, H, ' ');

	int x = W / 2;
	int y = H / 2;
	int dir = 1;

	int step = 0;
	int sig = SIG_BLOCK;
	while (sig != SIG_END) {
		queue_t in = {0};
		q_insert(&in, dir);
		queue_t out = {0};
		sig = p_run(&p, &in, &out);
		int r = q_remove(&out);
		int nx = x;
		int ny = y;
		switch (dir) {
		case EAST: nx = x + 1; break;
		case NORTH: ny = y - 1; break;
		case WEST: nx = x - 1; break;
		case SOUTH: ny = y + 1; break;
		}
		switch (r) {
		case 0:
			s_put(s, nx, ny, '#');
			break;
		case 1:
			s_put(s, nx, ny, '.');
			x = nx;
			y = ny;
			break;
		case 2:
			printf("a winner is you\n");
			return 0;
		}
		dir = next_dir(s, dir, x, y, r);
		s_show(s);
		getchar();
	}

	s_free(s);
}
