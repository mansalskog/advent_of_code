import sys

data = {}
with open(sys.argv[1]) as f:
    for y, l in enumerate(f):
        for x, c in enumerate(l[:-1]):
            data[x, y] = int(c)

def near(x, y):
    return [p for p in [(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)] if p in data]

def basin(x0, y0):
    prev = {}
    prev[x0, y0] = 'nothing'
    front = [(x0, y0)]
    while front:
        (x, y) = front.pop(0)
        nxt = [p for p in near(x, y) if data[p] != 9 and data[p] > data[x, y]]
        # print((x, y), nxt)
        for p in nxt:
            prev[p] = (x, y)
        front += nxt
    return [data[x, y] for (x, y) in prev.keys()]

risklevel = 0
basin_sizes = []
for (x0, y0) in data:
    if all([data[x, y] > data[x0, y0] for (x, y) in near(x0, y0)]):
        risklevel += 1 + data[x0, y0]
        # print('basin', basin(x0, y0))
        basin_sizes.append(len(basin(x0, y0)))
print(risklevel)
basin_sizes.sort(reverse=True)
print(basin_sizes[0] * basin_sizes[1] * basin_sizes[2])
