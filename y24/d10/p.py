import sys

def printmap(points, W, H):
    for y in range(0, H):
        for x in range(0, W):
            print(points[(x,y)], end="")
        print()

def search(points, x0, y0):
    deltas = [(1,0), (-1,0), (0,1), (0,-1)]
    frontier = [(x0,y0)]
    visited = set()
    visited_from = dict()
    ends = 0
    while len(frontier) > 0:
        (x, y) = frontier.pop(0)
        # if (x,y) in visited:
            # continue
        # visited.add((x,y))
        loc = points.get((x,y), ".")
        if loc == "9":
            ends += 1
            continue
        if loc == ".":
            continue
        for (dx,dy) in deltas:
            dst = points.get((x+dx,y+dy), ".")
            if dst == ".":
                continue
            if int(loc) + 1 == int(dst):
                vf = visited_from.get((x+dx,y+dy), set())
                if not (x,y) in vf:
                    vf.add((x,y))
                    frontier.append((x+dx,y+dy))
    return ends


points = {}
with open(sys.argv[1]) as f:
    for y, l in enumerate(f):
        for x, c in enumerate(l):
            if c == "\n":
                continue
            points[(x,y)] = c
W = max(x for (x,y) in points)
H = max(y for (x,y) in points)


printmap(points, W, H)
score = 0
for (x,y) in points:
    if points[(x,y)] == "0":
        s = search(points, x, y)
        print((x,y), "has score", s)
        score += s
print("answer", score)
