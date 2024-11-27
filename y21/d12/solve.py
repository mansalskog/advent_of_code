import sys

links = set()
with open(sys.argv[1]) as f:
    for l in f:
        links.add(tuple(l[:-1].split('-')))
# print(links)

def dfs(curr, visited, twice):
    # print('at', curr, 'after', visited)
    if curr == 'end':
        return [['end']]
    else:
        paths = []
        new_vis = visited.copy()
        new_vis[curr] = new_vis.get(curr, 0) + 1
        for frm, to in links:
            # part 1
            # max_vis = 3
            # part 2
            max_vis = max(v for k, v in new_vis.items() if k.islower()) if new_vis else -1
            if frm == curr:
                # print('trying', frm, '-', to)
                if to.isupper() or to not in new_vis or (max_vis <= 1 and to not in ['start', 'end']):
                    new_paths = dfs(to, new_vis, twice)
                    # print(new_paths)
                    paths += [[curr] + p for p in new_paths]
            elif to == curr:
                # print('trying', to, '-', frm)
                if frm.isupper() or frm not in new_vis or (max_vis <= 1 and frm not in ['start', 'end']):
                    new_paths = dfs(frm, new_vis, twice)
                    # print(new_paths)
                    paths += [[curr] + p for p in new_paths]
        return paths

paths = dfs('start', {}, None)
print('\n'.join('-'.join(p) for p in paths))
print(len(paths))
