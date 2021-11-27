with open('input.txt') as f:
    n = 0
    for l in f:
        s = {}
        for w in l[:-1].split(' '):
            w = ''.join(sorted(w)) # part 2
            print(w)
            if w in s:
                break
            s[w] = 1
        else:
            n += 1
    print(n)
