import sys
with open(sys.argv[1]) as f:
    parents = {}
    weights = {}
    for l in f:
        parent, r = l[:-1].split(' (')
        l = r.split(') -> ')
        if len(l) == 1:
            weight = r.split(')')[0]
            children = []
        else:
            weight, r = l
            children = r.split(', ')
        print(parent, weight, children)
        weights[parent] = weight
        for c in children:
            parents[c] = parent
    curr = list(parents.keys())[0]
    while curr in parents:
        curr = parents[curr]
    print(curr)
