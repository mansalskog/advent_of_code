import sys

def fold_x(pix, x0):
    new = {}
    for x, y in pix:
        xm = x0 + (x0 - x)
        if (x, y) in pix:
            new[min(x, xm), y] = pix[x, y]
        elif (xm, y) in pix:
            new[min(x, xm), y] = pix[xm, y]
    return new

def fold_y(pix, y0):
    new = {}
    for x, y in pix:
        ym = y0 + (y0 - y)
        if (x, y) in pix:
            new[x, min(y, ym)] = pix[x, y]
        elif (xm, y) in pix:
            new[x, min(y, ym)] = pix[x, ym]
    return new

def show(pix):
    xs = [k[0] for k in pix]
    ys = [k[1] for k in pix]
    for y in range(min(ys), max(ys) + 1):
        for x in range(min(xs), max(xs) + 1):
            print('#' if pix.get((x, y)) else ' ', end='')
        print('')
    print('---')

def count(pix):
    xs = [k[0] for k in pix]
    ys = [k[1] for k in pix]
    n = 0
    for y in range(min(ys), max(ys) + 1):
        for x in range(min(xs), max(xs) + 1):
            n += int((x, y) in pix)
    return n

pix = {}
with open(sys.argv[1]) as f:
    for l in f:
        if l == '\n':
            break
        x, y = (int(s) for s in l.split(','))
        pix[x, y] = True

    for k, l in enumerate(f):
        inst, v = l.split('=')
        if inst[-1] == 'x':
            pix = fold_x(pix, int(v))
        elif inst[-1] == 'y':
            pix = fold_y(pix, int(v))
        if k == 0:
            print(len(pix))
    show(pix)
