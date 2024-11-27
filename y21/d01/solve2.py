with open('input.txt') as f:
    l = list(map(int, f))

n = 0
p = None
for i in range(len(l)-2):
    s = sum(l[i:i+3])
    if p and s > p:
        n += 1
    p = s
print(n)
