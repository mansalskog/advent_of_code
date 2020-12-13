#include <stdio.h>

const int C = 9;
long long n[C] = {13, 41, 997, 23, 19, 29, 619, 37, 17};
long long a[C] = {0, 3, 13, 21, 32, 42, 44, 50, 61};

// long long n[C] = {1789, 37, 47, 1889};

/*
const int C = 4;
long long n[C] = {67,7,59,61};
long long a[C] = {0,1,3,4};
*/

long long N[C];
long long M[C];

long long eeuc(long long a, long long b) {
	printf("euclidean %lld, %lld\n", a, b);
	long long old_r = a;
	long long r = b;
	long long old_s = 1;
	long long s = 0;
	long long old_t = 0;
	long long t = 1;
	while (r != 0) {
		long long quot = old_r / r;
		long long tmp = old_r;
		old_r = r;
		r = tmp - quot * r;
		tmp = old_s;
		old_s = s;
		s = tmp - quot * s;
		tmp = old_t;
		old_t = t;
		t = tmp - quot * t;
	}
	// gcd = old_r
	// ma = old_s
	// mb = old_t
	printf("gcd = %lld, ma = %lld, mb = %lld\n", old_r, old_s, old_t);
	return old_s;
}

void solve() {
	for (int i = 0; i < C; i++) {
		N[i] = 1;
		for (int j = 0; j < C; j++) {
			if (i != j) {
				N[i] *= n[j];
			}
		}
		M[i] = eeuc(N[i], n[i]);
	}
	long long x = 0;
	// long long lcm = 2147483647; // 2622062845747423LL;
	long long lcm = 1;
	for (int i = 0; i < C; i++) {
		x += a[i] * M[i] * N[i];
		lcm *= n[i];
	}
	printf("x = %lld\n", x);
	x = (x % lcm + lcm) % lcm;
	printf("lcm = %lld, x = %lld\n", lcm, x);
}

int main() {
	for (int i = 0; i < C; i++) {
		a[i] = (n[i] - a[i]) % n[i];
		printf("x = %lld mod %lld\n", a[i], n[i]);
	}
	solve();
}
