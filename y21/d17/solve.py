import sys, re, math

with open(sys.argv[1]) as f:
    target = list(map(int, re.findall(r'-?[0-9]+', f.readline())))
    print(target)

debug = False

def simulate(dx, dy):
    pts = []
    x, y = 0, 0
    while True:
        pts.append((x, y))
        if target[0] <= x <= target[1] and target[2] <= y <= target[3]:
            # hit
            hit = True
            break
        elif x > target[1] or y < target[2]:
            # missed
            hit = False
            break
        else:
            x += dx
            y += dy
            if dx > 0:
                dx -= 1
            elif dx < 0:
                dx += 1
            dy -= 1

    ymax = max(p[1] for p in pts)

    if debug:
        print(ymax, hit)
        for y in reversed(range(target[2], ymax + 1)):
            for x in range(0, target[1] + 1):
                if (x, y) == (0, 0):
                    print('S', end='')
                elif (x, y) in pts:
                    print('#', end='')
                elif target[0] <= x <= target[1] and target[2] <= y <= target[3]:
                    print('T', end='')
                else:
                    print(' ', end='')
            print('')

    return hit, ymax


'''
debug = True
simulate(6,3)
simulate(9,0)
simulate(17,-4)
exit()
'''

vels = set()
ymaxmax = -10000
for dx in range(0, 1000):
    for dy in range(-1000, 1000):
        hit, ymax = simulate(dx, dy)
        if hit:
            vels.add((dx, dy))
        if hit and ymax > ymaxmax:
            ymaxmax = ymax
print('ymaxmax =', ymaxmax)
print('count =', len(vels))
