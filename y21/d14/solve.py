import sys, re
from collections import Counter

maxn = 1000 # int(sys.argv[2]) if len(sys.argv) >= 3 else 1000

with open(sys.argv[1]) as f:
    start = f.readline()[:-1]
    f.readline()
    rules = {}
    for l in f:
        src, dst = l[:-1].split(' -> ')
        rules[src] = dst
        # rules.append((src, dst))

# print(start)
# print(rules)


# rules = dict([(re.escape(src), src[0] + dst + src[1]) for src, dst in rules])
# match = re.compile('|'.join(src for src in rules))

def step(s):
    ns = ''
    for i in range(len(s) - 1):
        src = s[i:i+2] 
        if src in rules:
            ns += src[0] + rules[src]
        else:
            ns += src[0]
    ns += s[-1]
    return ns

s = start
for k in range(min(10, maxn)):
    if maxn <= 5:
        print(k, s)
        x = {}
        for i in range(len(start) - 1):
            x[start[i:i+2]] = x.get(start[i:i+2], 0) + 1
        print(k, x)
    # start = match.sub(lambda m: rules[m.group(0)], start)
    s = step(s)
if maxn <= 5:
    # x = {s[i:i+2]: 1 for i in range(len(s) - 1)}
    print(maxn, x)
# print(n, start)
c = Counter(s).most_common()
# print(c)
print(c[0][1] - c[-1][1])

def more(a):
    na = {}
    for src, amt in a.items():
        if src in rules:
            dst = rules[src]
            na[src[0] + dst] = na.get(src[0] + dst, 0) + amt
            # if src[0] + dst != dst + src[1]:
            na[dst + src[1]] = na.get(dst + src[1], 0) + amt
            # else:
                # na[src[0] + dst] = na.get(src[0] + dst, 0) + amt - 1
        else:
            print('unknown pair')
            na[src] = a[src]
    return na

def count(a):
    res = {}
    for src, amt in a.items():
        res[src[0]] = res.get(src[0], 0) + amt
        res[src[1]] = res.get(src[1], 0) + amt
    res[start[0]] = res.get(start[0], 0) + 1
    res[start[-1]] = res.get(start[-1], 0) + 1
    for c, amt in res.items():
        if amt % 2 != 0:
            # print('what?', c, amt)
            pass
    res = {src: amt // 2 for src, amt in res.items()}
    return res

# print(0, start)
adj = {}
for i in range(len(start) - 1):
    adj[start[i:i+2]] = adj.get(start[i:i+2], 0) + 1
for k in range(min(40, maxn)):
    if maxn <= 5:
        print(k, adj)
    count(adj)
    adj = more(adj)
if maxn <= 5:
    print(k, adj)

c = Counter(count(adj)).most_common()
# print(c)
print(c[0][1] - c[-1][1])
