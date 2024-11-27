import sys

with open(sys.argv[1]) as f:
    numbers = [int(s) for s in f.readline()[:-1].split(',')]
    # print(numbers)
    boards = []
    rows = []
    f.readline()
    for l in f:
        l = l[:-1]
        if l == '':
            boards.append(rows)
            rows = []
        else:
            rows.append([(int(s), False) for s in l.split(' ') if s != ''])
    boards.append(rows)
    # print(boards)

def mark(b, n):
    for y in range(len(b)):
        for x in range(len(b[0])):
            if b[y][x][0] == n:
                b[y][x] = (n, True)

def win(b):
    print(b)
    for y in range(len(b)):
        if all(b[y][x][1] for x in range(len(b[0]))):
            return True
    for x in range(len(b[0])):
        if all(b[y][x][1] for y in range(len(b))):
            return True

def unmarked(b):
    s = 0
    for y in range(len(b)):
        for x in range(len(b[0])):
            if not b[y][x][1]:
                s += b[y][x][0]
    return s

def part1():
    last = None
    while True:
        for b in boards:
            if win(b):
                print('first part', last * unmarked(b))
                return
        last = numbers.pop(0)
        for b in boards:
            mark(b, last)
# part1()

def part2():
    global boards
    last = None
    while len(boards) > 1:
        boards = [b for b in boards if not win(b)]
        last = numbers.pop(0)
        for b in boards:
            mark(b, last)
    print(last, unmarked(boards[0]))
    print('second part', last * unmarked(boards[0]))
part2()
