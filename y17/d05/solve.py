j = []
with open('input.txt') as f:
    for l in f:
        j.append(int(l))
i = n = 0
while 0 <= i < len(j):
    o = j[i]
    j[i] += 1 if j[i] < 3 else -1
    i += o
    n += 1
print(n)
