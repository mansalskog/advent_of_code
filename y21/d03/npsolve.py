import sys
import numpy as np

def common(a):
    return np.sum(a, 0) >= a.shape[0] / 2

def compl(a):
    return [1] * len(a) - a

def decimal(a):
    return sum(x * 2**k for k,x in enumerate(reversed(a)))

b = []
with open(sys.argv[1]) as f:
    for l in f:
        b.append(list(map(int, l[:-1])))
b = np.array(b)

g = decimal(common(b))
e = 2**b.shape[1] - 1 - g
print(g * e)

ox = b.copy()
k = 0
while ox.shape[0] > 1:
    c = common(ox)
    ox = np.take(ox, [j for j,r in enumerate(ox) if r[k] == c[k]], 0)
    k += 1
ox = decimal(ox[0])

co = b.copy()
k = 0
while co.shape[0] > 1:
    c = compl(common(co))
    co = np.take(co, [j for j,r in enumerate(co) if r[k] == c[k]], 0)
    k += 1
co = decimal(co[0])
print(ox * co)
