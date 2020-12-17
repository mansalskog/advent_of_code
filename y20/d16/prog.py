import re

rejected = 0
def check_ticket(t):
    for f in t:
        possible = 0
        for n in fields:
            if (fields[n][0] <= f and f <= fields[n][1]) or (fields[n][2] <= f and f <= fields[n][3]):
                possible += 1
        if possible == 0:
            global rejected
            rejected += f
            return False
    return True # all fields have > 0 possible

fields = {}
tickets = []

with open("input", "r") as f:
    section = 1
    for l in f.readlines():
        l = l[:-1]
        if l == "":
            continue
        elif l == "your ticket:":
            section = 2
            continue
        elif l == "nearby tickets:":
            section = 3
            continue
        if section == 1:
            tmp = re.compile(": | or |-").split(l)
            fields[tmp[0]] = list(map(int, tmp[1:]))
            # print(tmp[0], fields[tmp[0]])
        elif section == 2:
            my_ticket = list(map(int, l.split(",")))
            # print("my ticket", my_ticket)
        elif section == 3:
            tickets.append(list(map(int, l.split(","))))
            # print("now reading", tickets[-1])

tickets = list(filter(check_ticket, tickets))
print("rejected total", rejected)

possible = {}
for n in fields:
    possible[n] = set()
    for idx in range(20):
        possible[n].add(idx)

for t in tickets:
    for idx in range(len(t)):
        for n in fields:
            f = t[idx]
            if not ((fields[n][0] <= f and f <= fields[n][1]) or (fields[n][2] <= f and f <= fields[n][3])):
                possible[n].remove(idx)

names = ["???"] * 20
while possible:
    for n in possible:
        if len(possible[n]) == 1:
            (idx,) = possible[n]
            # print("identified", n, "as", idx)
            names[idx] = n
            del possible[n]
            for m in possible:
                possible[m].remove(idx)
            break

answer = 1
for idx in range(20):
    if names[idx].startswith("departure"):
        # print("adding", names[idx], my_ticket[idx])
        answer *= my_ticket[idx]
print("answer is", answer)
