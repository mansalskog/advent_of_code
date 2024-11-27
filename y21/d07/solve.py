import sys

def tri(n):
    return n * (n + 1) // 2

with open(sys.argv[1]) as f:
    xs = [int(s) for s in f.readline()[:-1].split(',')]

print(min(
    sum(abs(x - x0) for x in xs)
    for x0 in range(min(xs), max(xs))))

print(min(
    sum(tri(abs(x - x0)) for x in xs)
    for x0 in range(min(xs), max(xs))))
