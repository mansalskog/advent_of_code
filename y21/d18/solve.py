import sys, re, math

def reducepair(p0):
    # iterate from left to right
    flat = []
    def flatten(p, d):
        if len(p) == 1:
            flat.append((p, d))
        elif len(p) == 2:
            if len(p[0]) == 1 and len(p[1]) == 1:
                flat.append((p, d))
            else:
                flatten(p[0], d + 1)
                flatten(p[1], d + 1)
    flatten(p0, 0)
    # print('before:', p0)
    # print('flat:', flat)
    e = next((i for i, f in enumerate(flat) if len(f[0]) == 2 and f[1] >= 4), None)
    if e is not None:
        # print('exploding', flat[e], 'at', e)
        if e - 1 >= 0:
            if len(flat[e - 1][0]) == 2:
                flat[e - 1][0][1][0] += flat[e][0][0][0]
            else:
                flat[e - 1][0][0] += flat[e][0][0][0]
        if e + 1 < len(flat):
            if len(flat[e + 1][0]) == 2:
                flat[e + 1][0][0][0] += flat[e][0][1][0]
            else:
                flat[e + 1][0][0] += flat[e][0][1][0]
        flat[e][0].pop()
        flat[e][0][0] = 0
        # print('result:', p0)
        return True
    s = next((i for i, f in enumerate(flat) if
        (len(f[0]) == 1 and f[0][0] >= 10) or
        (len(f[0]) == 2 and (f[0][0][0] >= 10 or f[0][1][0] >= 10))), None)
    if s is not None:
        # print('splitting', flat[s], 'at', s)
        if len(flat[s][0]) == 2:
            if flat[s][0][0][0] >= 10:
                target = flat[s][0][0]
            else:
                target = flat[s][0][1]
        else:
            target = flat[s][0]
        half = target[0] / 2.0
        target[0] = [math.floor(half)]
        target.append([math.ceil(half)])
        # print('result:', p0)
        return True
    return False

def magnitude(p):
    if len(p) == 2:
        return 3 * magnitude(p[0]) + 2 * magnitude(p[1])
    else:
        return p[0]

def readpair(s):
    if s[0] == '[':
        l, s = readpair(s[1:])
        r, s = readpair(s[1:])
        s = s[1:]
        # print('got pair of', l, r, 'rest', s)
        return ([l, r], s)
    else:
        m = re.match(r'(\d+)(.*)', s)
        n = int(m.group(1))
        s = m.group(2)
        # print('got number', n, 'rest', s)
        return ([n], s)

with open(sys.argv[1]) as f:
    ls = [l[:-1] for l in f]
    ps = [readpair(l)[0] for l in ls]

result = ps[0]
for p in ps[1:]:
    result = [result, p]
    while reducepair(result):
        pass
    # print('reduced to', result)
print(magnitude(result))

length = len(ps)
maxmag = 0
for i in range(length):
    for j in range(length):
        result = [readpair(ls[i])[0], readpair(ls[j])[0]]
        while reducepair(result):
            pass
        mag = magnitude(result)
        if mag > maxmag:
            maxmag = mag
print(maxmag)
