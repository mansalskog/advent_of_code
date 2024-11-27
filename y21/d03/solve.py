import sys
b = {}
n = 0
ox = []
co = []
with open(sys.argv[1]) as f:
    for l in f:
        c = list(l[:-1])
        for k,x in enumerate(c):
            if x == '1':
                b[k] = b.get(k, 0) + 1
        ox.append(list(map(int, c)))
        co.append(list(map(int, c)))
        n += 1
        m = len(c)

gamma = [b[k] >= n / 2 for k in sorted(b.keys())]
gamma = sum(x * (2**k) for k,x in enumerate(reversed(gamma)))
eps = [b[k] < n / 2 for k in sorted(b.keys())]
eps = sum(x * (2**k) for k,x in enumerate(reversed(eps)))
print(gamma * eps)

k = 0
while len(ox) > 1:
    s = [0] * len(ox[0])
    for l in ox:
        for j,x in enumerate(l):
            s[j] += x
    if s[k] >= len(ox) / 2:
        # most common 1
        ox = [l for l in ox if l[k] == 1]
    else:
        # most common 0
        ox = [l for l in ox if l[k] == 0]
    k += 1

k = 0
while len(co) > 1:
    s = [0] * len(co[0])
    for l in co:
        for j,x in enumerate(l):
            s[j] += x
    if s[k] >= len(co) / 2:
        co = [l for l in co if l[k] == 0]
    else:
        co = [l for l in co if l[k] == 1]
    k += 1

ox1 = ox[0]
co1 = co[0]
ox1 = sum(int(x) * (2**k) for k,x in enumerate(reversed(ox1)))
co1 = sum(int(x) * (2**k) for k,x in enumerate(reversed(co1)))
print(ox1 * co1)
