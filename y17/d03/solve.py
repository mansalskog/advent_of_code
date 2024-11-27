from math import pi, sin, cos

values = {}
values[0,0] = 1

def dist(n):
    x = xmin = xmax = 0
    y = ymin = ymax = 0
    a = 0
    for k in range(n-1):
        print(f'{n} steps taken, at {x}, {y}')
        x += [1, 0, -1, 0][a % 4]
        y += [0, 1, 0, -1][a % 4]
        if x > xmax or x < xmin or y > ymax or y < ymin:
            a += 1
        xmin = min(x, xmin)
        xmax = max(x, xmax)
        ymin = min(y, ymin)
        ymax = max(y, ymax)
        if (x,y) not in values:
            values[x,y] = sum(values.get((z,w), 0) for z in [x-1,x,x+1] for w in [y-1,y,y+1])
            if values[x,y] > 289326:
                print('part two', values[x,y])
                exit()
    return abs(x) + abs(y)

assert dist(1) == 0
assert dist(12) == 3
assert dist(23) == 2
assert dist(1024) == 31
print(dist(289326))

