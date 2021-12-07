import sys

with open(sys.argv[1]) as f:
    xs = [int(s) for s in f.readline()[:-1].split(',')]

def tri(n):
    # return sum(range(n+1))
    return n * (n + 1) // 2

min_c = float('inf')
min_x0 = None
for x0 in range(min(xs), max(xs)):
    c = 0
    for x in xs:
        # c += abs(x - x0)
        c += tri(abs(x - x0))
    if c < min_c:
        min_c = c
        min_x0 = x0
print(min_c, 'at', min_x0)
