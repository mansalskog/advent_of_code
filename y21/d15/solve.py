import sys


def near(p, pts):
    x, y = p
    n = [(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)]
    return [r for r in n if r in pts]


def bfs(pts, start, end):
    q = [start]
    before = {}
    before[start] = None
    cost = {}
    cost[start] = 0
    while q:
        p = q.pop(0)
        for r in near(p, pts):
            newcost = cost[p] + pts[r]
            if r not in cost or newcost < cost[r]:
                cost[r] = newcost
                before[r] = p
                q.append(r)
    
    path = []
    p = end
    while p:
        path.insert(0, p)
        p = before[p]
    printpath(pts, path)

    return cost[end]


def printpath(pts, path):
    w = max(p[0] for p in pts) + 1
    h = max(p[1] for p in pts) + 1
    for y in range(h):
        for x in range(w):
            if (x, y) in path:
                print('#', end='')
            else:
                print(pts[x, y], end='')
        print('')


def increase(pts):
    newpts = {}
    w = max(p[0] for p in pts) + 1
    h = max(p[1] for p in pts) + 1
    for (x, y) in pts:
        for j in range(5):
            for k in range(5):
                v = pts[x, y]
                for _ in range(j + k):
                    v += 1
                    if v > 9:
                        v = 1
                newpts[x + j * w, y + k * h] = v
    return newpts


pts = {}
with open(sys.argv[1]) as f:
    for y, l in enumerate(f):
        for x, c in enumerate(l[:-1]): 
            pts[x, y] = int(c)

xm = max(p[0] for p in pts)
ym = max(p[1] for p in pts)
print(bfs(pts, (0, 0), (xm, ym)))

pts = increase(pts)
xm = max(p[0] for p in pts)
ym = max(p[1] for p in pts)
print(bfs(pts, (0, 0), (xm, ym)))
