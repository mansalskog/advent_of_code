import sys

at_age = [0] * 9

with open(sys.argv[1]) as f:
    # state = [(int(s), 1) for s in f.readline()[:-1].split(',')]
    for a in f.readline()[:-1].split(','):
        at_age[int(a)] += 1

days = 256
for d in range(days + 1):
    print(d, sum(at_age), at_age)
    nxt = [0] * 9
    nxt[0] = at_age[1]
    nxt[1] = at_age[2]
    nxt[2] = at_age[3]
    nxt[3] = at_age[4]
    nxt[4] = at_age[5]
    nxt[5] = at_age[6]
    nxt[6] = at_age[7] + at_age[0]
    nxt[7] = at_age[8]
    nxt[8] = at_age[0]
    at_age = nxt

'''
for days in range(0, 256):
    # print(state)
    new_state = []
    added = 0
    for s in state:
        if s == 0:
            new_state.append(6)
            added += 1
        else:
            new_state.append(s - 1)
    new_state += [8] * added
    state = new_state
    print(days + 1, len(state))
'''
