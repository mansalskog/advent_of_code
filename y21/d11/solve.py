import sys

def near(x, y, d):
    return [p for p in [
        (x + 1, y),
        (x + 1, y + 1),
        (x + 1, y - 1),
        (x - 1, y),
        (x - 1, y + 1),
        (x - 1, y - 1),
        (x, y + 1),
        (x, y - 1)] if p in d]

def step(d):
    new_d = {}
    for (x, y) in d:
        new_d[x, y] = d[x, y] + 1
    changed = True
    flashed = set()
    while changed:
        changed = False
        for (x, y) in new_d:
            if new_d[x, y] > 9 and (x, y) not in flashed:
                # print('flash', x, y)
                changed = True
                flashed.add((x, y))
                for (z, w) in near(x, y, new_d):
                    new_d[z, w] += 1
    for (x, y) in flashed:
        new_d[x, y] = 0
    return new_d, len(flashed)

def show(d):
    xs = [k[0] for k in d]
    ys = [k[1] for k in d]
    print('-----')
    for y in range(min(ys), max(ys) + 1):
        for x in range(min(xs), max(xs) + 1):
            print(d[x, y], end = '')
        print('')
    print('-----')


data = {}
with open(sys.argv[1]) as f:
    for y, l in enumerate(f):
        for x, c in enumerate(l[:-1]):
            data[x, y] = int(c)

tot = 0
n = 0
while True:
    # show(data)
    data, f = step(data)
    if n < 100:
        tot += f
    elif n == 100:
        print('total to 100 is', tot)
    n += 1
    if f == len(data):
        print('sync at', n)
        break
