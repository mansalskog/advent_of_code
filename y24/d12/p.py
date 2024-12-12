import sys

def printmap(points, W, H):
    for y in range(0, H):
        for x in range(0, W):
            print(points[(x,y)], end="")
        print()

def search(points, x0, y0, visited):
    deltas = [(1,0), (0,1), (-1,0), (0,-1)]
    frontier = [(x0,y0)]
    # visited = set()
    # visited_from = dict()
    area = 0
    perimiter = 0
    color = points[(x0,y0)]
    full_deltas = [(1,0),(1,1),(0,1),(-1,1),(-1,0),(-1,-1),(0,-1),(1,-1)]
    corners = 0
    while len(frontier) > 0:
        (x, y) = frontier.pop(0)
        if (x,y) in visited:
            continue
        visited.add((x,y))
        loc = points.get((x,y), "")
        if loc != color:
            raise "ERROR"
        connected = 0
        full_conn = [False] * 8
        for (dx,dy) in deltas:
            dst = points.get((x+dx,y+dy), "")
            if dst == color:
                connected += 1
                frontier.append((x+dx,y+dy))
        for (i,(dx,dy)) in enumerate(full_deltas):
            dst = points.get((x+dx,y+dy), "")
            if dst == color:
                full_conn[i] = True
        area += 1
        perimiter += 4 - connected
        corners += count_corners(full_conn)
    return (area, perimiter, corners)

def count_corners(conn):
    corners = 0
    for i in range(0,8,2):
        s = conn[i] + conn[i+1] + conn[(i+2)%8]
        if s == 0:
            corners += 1
        elif s == 2:
            # beautifully silly hack, just hope we don't have too much float rounding errors
            # (but that should not be possible with this little data)
            corners += 1/3
        elif s == 1 and conn[i+1]:
            corners += 1
    return corners

points = {}
with open(sys.argv[1]) as f:
    for y, l in enumerate(f):
        for x, c in enumerate(l):
            if c == "\n":
                continue
            points[(x,y)] = c
W = 1 + max(x for (x,y) in points)
H = 1 + max(y for (x,y) in points)


printmap(points, W, H)
visited = set()
total = 0
total2 = 0
for (x,y) in points:
    (a, p, c) = search(points, x, y, visited)
    if a != 0:
        print((x,y), points[(x,y)], "has price", a * c, "=", a, "*", c)
    total += a * p
    total2 += a * c
print(total, round(total2))
