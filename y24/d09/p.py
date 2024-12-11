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

def compress_whole(file):
    to_move_fnum = max(fnum for fnum in file)
    while to_move_fnum > 0:
        print(to_move_fnum)
        file_start = file.index(to_move_fnum)
        file_end = last_index(file, to_move_fnum)
        file_len = file_end - file_start + 1
        for dest in range(0, file_start):
            if all(fnum == -1 for fnum in file[dest:(dest+file_len)]):
                # print("moving file", to_move_fnum, "from", file_start, "to", dest)
                file[file_start:file_end+1] = [-1] * file_len
                file[dest:(dest+file_len)] = [to_move_fnum] * file_len
                break
        to_move_fnum -= 1
        # print(file)

def last_index(l, e):
    return len(l) - 1 - l[::-1].index(e)

def checksum(file):
    return sum(idx * pos if idx != -1 else 0 for (pos,idx) in enumerate(file))

dm_text = input()
dm = list(map(int, dm_text))
# file = makefile(dm)
# compress(file)
# print(checksum(file))

file = makefile(dm)
compress_whole(file)
print(checksum(file))
