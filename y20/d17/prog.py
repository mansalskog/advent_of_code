import sys

if len(sys.argv) < 2:
    print("No file!")
    exit()

nodes = {}

def show():
    global nodes
    keys = nodes.keys()
    min_x = min(map(lambda k: k[0], keys))
    max_x = max(map(lambda k: k[0], keys))
    min_y = min(map(lambda k: k[1], keys))
    max_y = max(map(lambda k: k[1], keys))
    min_z = min(map(lambda k: k[2], keys))
    max_z = max(map(lambda k: k[2], keys))
    min_w = min(map(lambda k: k[3], keys))
    max_w = max(map(lambda k: k[3], keys))
    for w in range(min_w, max_w + 1):
        for z in range(min_z, max_z + 1):
            print("z =", z, ", w =", w)
            for y in range(min_y, max_y + 1):
                for x in range(min_x, max_x + 1):
                    if (x, y, z, w) in nodes:
                        sys.stdout.write("#")
                    else:
                        sys.stdout.write(".")
                print("")

def nearby(ox, oy, oz, ow):
    global nodes
    active = 0
    for w in range(ow - 1, ow + 2):
        for z in range(oz - 1, oz + 2):
            for y in range(oy - 1, oy + 2):
                for x in range(ox - 1, ox + 2):
                    if x == ox and y == oy and z == oz and w == ow:
                        continue
                    if (x, y, z, w) in nodes:
                        active += 1
    return active

def update():
    global nodes
    new_nodes = {}
    keys = nodes.keys()
    min_x = min(map(lambda k: k[0], keys)) - 1
    max_x = max(map(lambda k: k[0], keys)) + 1
    min_y = min(map(lambda k: k[1], keys)) - 1
    max_y = max(map(lambda k: k[1], keys)) + 1
    min_z = min(map(lambda k: k[2], keys)) - 1
    max_z = max(map(lambda k: k[2], keys)) + 1
    min_w = min(map(lambda k: k[3], keys)) - 1
    max_w = max(map(lambda k: k[3], keys)) + 1
    for w in range(min_w, max_w + 1):
        for z in range(min_z, max_z + 1):
            for y in range(min_y, max_y + 1):
                for x in range(min_x, max_x + 1):
                    active = nearby(x, y, z, w)
                    if (x, y, z, w) in nodes:
                        if active == 2 or active == 3:
                            new_nodes[(x, y, z, w)] = 1
                    else:
                        if active == 3:
                            new_nodes[(x, y, z, w)] = 1
    nodes = new_nodes

with open(sys.argv[1], "r") as f:
    y = 0
    for l in f.readlines():
        l = l[:-1]
        if l == "":
            continue
        for x in range(0, len(l)):
            if l[x] == "#":
                nodes[(x, y, 0, 0)] = 1
        y += 1

# show()
for n in range(6):
    update()
    # show()

count = 0
for pos in nodes:
    count += 1
print("active:", count)
