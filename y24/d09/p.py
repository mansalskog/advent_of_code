def makefile(dm):
    return [block for (idx,size) in enumerate(dm) for block in ([idx // 2] * size if idx % 2 == 0 else [-1] * size)]


def compress(file):
    to_move = len(file) - 1
    while to_move > 0:
        val = file[to_move]
        if val == -1:
            to_move -= 1
            continue

        idx = file.index(-1)
        if idx >= to_move:
            break
        # print("putting", file[to_move], "at", idx)
        file[idx] = val
        file[to_move] = -1
        # print(file)
        to_move -= 1

def checksum(file):
    return sum(idx * pos if idx != -1 else 0 for (pos,idx) in enumerate(file))

dm_text = input()
dm = list(map(int, dm_text))
# print(dm)
file = makefile(dm)
# print(file)
compress(file)
print(checksum(file))
