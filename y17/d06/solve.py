import numpy as np
with open('input.txt') as f:
    b = list(map(int, f.readline().split('\t')))
    # b = [0,2,7,0]
    s = {}
    p = False
    k = 0
    while True:
        # print(b)
        if str(b) in s:
            if not p:
                print("part 1", k)
                p = str(b)
                k = 0
            elif str(b) == p:
                print("part 2", k)
                break
        s[str(b)] = 1
        k += 1
        i = np.argmax(b)
        n = b[i]
        b[i] = 0
        while n > 0:
            i += 1
            b[i % len(b)] += 1
            n -= 1
