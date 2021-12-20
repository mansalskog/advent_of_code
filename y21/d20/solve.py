import sys

def near(img, x0, y0, default):
    return [img.get((x, y), default) for x, y in [
            (x0 - 1, y0 - 1),
            (x0 + 0, y0 - 1),
            (x0 + 1, y0 - 1),
            (x0 - 1, y0 + 0),
            (x0 + 0, y0 + 0),
            (x0 + 1, y0 + 0),
            (x0 - 1, y0 + 1),
            (x0 + 0, y0 + 1),
            (x0 + 1, y0 + 1),
        ]]

def enhance(img, algo, default):
    newimg = {}
    xs = {k[0] for k in img}
    ys = {k[1] for k in img}
    for y in range(min(ys) - 1, max(ys) + 2):
        for x in range(min(xs) - 1, max(xs) + 2):
            n = near(img, x, y, default)
            k = int(''.join('1' if d == '#' else '0' for d in n), base=2)
            newimg[x, y] = algo[k]
    return newimg

def display(img):
    xs = {k[0] for k in img}
    ys = {k[1] for k in img}
    print('---')
    for y in range(min(ys), max(ys) + 1):
        for x in range(min(xs), max(xs) + 1):
            print(img.get((x, y), '.'), end='')
        print('')
    print('---')

with open(sys.argv[1]) as f:
    algo = f.readline()
    f.readline()
    img = {}
    for y, l in enumerate(f):
        for x, c in enumerate(l[:-1]):
            img[x, y] = c

m = 50 # 2
for i in range(m):
    default = '.' if algo[0] == '.' or i % 2 == 0 else '#'
    img = enhance(img, algo, default)
print(sum(img[x, y] == '#' for (x, y) in img))
