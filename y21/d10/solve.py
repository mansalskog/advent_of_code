import sys

opn = '([{<'
cls = ')]}>'
pts = [3, 57, 1197, 25137]

def score(e):
    t = 0
    for c in e:
        t *= 5
        t += cls.index(c) + 1
    return t

def match(s, e):
    # print('match', s, e)
    if s == '':
        print('completion', e, score(e))
        return score(e), True
    elif s[0] in cls:
        if s[0] == e[0]:
            return match(s[1:], e[1:])
        else:
            print('expected', s[0], 'got', e[0])
            return pts[cls.index(s[0])], False
    elif s[0] in opn:
        i = opn.index(s[0])
        return match(s[1:], cls[i] + e)
    else:
        print('invalid char', s[0])


with open(sys.argv[1]) as f:
    tot = 0
    scores = []
    for l in f:
        val, compl = match(l[:-1], '')
        if compl:
            scores.append(val)
        else:
            tot += val
    print('part 1', tot)
    scores.sort()
    print('part 2', scores[len(scores) // 2])
