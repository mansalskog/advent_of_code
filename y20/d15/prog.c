#include <stdio.h>

#define MAX_NUMBER 100000000

int starting[] = {5, 1, 9, 18, 13, 8, 0};
int start_cnt = 7;

int count[MAX_NUMBER] = {0};
int spoken[MAX_NUMBER] = {0};
int before[MAX_NUMBER] = {0};

int main() {
	int curr = 0;
	int turn = 1;
	while (turn <= 30000000) {
		if (turn <= start_cnt) {
			// print "starting number"
			curr = starting[turn - 1];
		} else if (count[curr] > 1) {
			// print "last has been said", count[curr], "times, last at", spoken[curr], "before at", before[curr]
			curr = spoken[curr] - before[curr];
		} else {
			// print "last has been said", count[curr]
			curr = 0;
		}
		if (curr + 1 >= MAX_NUMBER || curr < 0) {
			printf("Too big number %d!\n", curr);
			return 1;
		}
		// if (turn % 1000000 == 0)
		// print "said", curr, "at turn", turn
		count[curr] = count[curr] + 1;
		before[curr] = spoken[curr];
		spoken[curr] = turn;
		turn++;
	}
	printf("%d %d\n", curr, turn);
}
