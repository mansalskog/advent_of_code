def evolveArr(arr):
    nextArr = []
    for e in arr:
        s = str(e)
        if e == 0:
            nextArr.append(1)
        elif len(s) % 2 == 0:
            e1 = int(s[0:len(s) // 2])
            e2 = int(s[len(s) // 2:])
            nextArr.append(e1)
            nextArr.append(e2)
        else:
            nextArr.append(e * 2024)
    return nextArr

def evolve(counts):
    nextCounts = {}
    for e,c in counts.items():
        s = str(e)
        if e == 0:
            nextCounts[1] = nextCounts.get(1, 0) + c
        elif len(s) % 2 == 0:
            e1 = int(s[0:len(s) // 2])
            e2 = int(s[len(s) // 2:])
            nextCounts[e1] = nextCounts.get(e1, 0) + c
            nextCounts[e2] = nextCounts.get(e2, 0) + c
        else:
            nextCounts[e * 2024] = nextCounts.get(e * 2024, 0) + c
    return nextCounts

arr = list(map(int, input().split(" ")))
counts = {e: 1 for e in arr}
for i in range(0,25):
    # print(counts.keys())
    counts = evolve(counts)
print(sum(counts.values()))
for i in range(0,50):
    counts = evolve(counts)
print(sum(counts.values()))
