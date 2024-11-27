import sys, re

def sign(p):
    return 1 if p >= 0 else -1

p = {}
with open(sys.argv[1]) as f:
    for l in f:
        s1,s2 = l.split(' -> ')
        x1,y1 = map(int, s1.split(','))
        x2,y2 = map(int, s2.split(','))
        # print(x1,y1,x2,y2)
        if x1 == x2 or y1 == y2:
            for x in range(min(x1,x2), max(x1,x2)+1):
                for y in range(min(y1,y2), max(y1,y2)+1):
                    p[x,y] = p.get((x,y), 0) + 1
        else:
            if True:
                for x in range(min(x1,x2), max(x1,x2)+1):
                    if sign(x2-x1) * sign(y2-y1) > 0:
                        y = min(y1,y2) + (x-min(x1,x2))
                    else:
                        y = max(y1,y2) - (x-min(x1,x2))
                    p[x,y] = p.get((x,y), 0) + 1

xs = [k[0] for k in p.keys()]
ys = [k[1] for k in p.keys()]
n = 0
for y in range(min(ys), max(ys)+1):
    for x in range(min(xs), max(xs)+1):
        # print(p.get((x,y), '.'), end='')
        if (x,y) in p and p[x,y] >= 2:
            n += 1
    # print('')
print(n)
