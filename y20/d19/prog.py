import sys, re

rules = {}
def expand(i):
    if i not in rules:
        if text[i].startswith('"'):
            rules[i] = text[i][1:-1] # remove quotes
            return rules[i]
        else:
            if "|" in text[i]:
                parts = text[i].split(" | ")
            else:
                parts = [text[i]]
            rules[i] = "|".join(map(sequence, parts))
    # print("rule", i, "is", rules[i])
    return rules[i]

def sequence(seq):
    rules = []
    for i in seq.split(" "):
        rules.append("(" + expand(int(i)) + ")")
    return "".join(rules)

text = {}
data = []
with open(sys.argv[1], "r") as f:
    reading_data = False
    for l in f.readlines():
        l = l[:-1] # remove newline char
        if l == "":
            reading_data = True
        elif reading_data:
            data.append(l)
        else:
            [i, t] = l.split(": ")
            text[int(i)] = t

for i in text:
    expand(i)

# part 1
count = 0
for d in data:
    if re.match("^" + rules[0] + "$", d):
        count += 1
    # print(d, m)
print(count)

# part 2
count = 0
for d in data:
    # valid = not not re.match("^" + rules[0] + "$", d)
    m = False
    for n1 in range(1, 20):
        for n2 in range(1, 20):
            r8 = "^(" + rules[42] + "){" + str(n1) + "}"
            r11 = "(" + rules[42] + "){" + str(n2) + "}(" + rules[31] + "){" + str(n2) + "}"
            # print(r8, r11)
            if re.match("^" + r8 + r11 + "$", d):
                count += 1
                m = True
                break
        if m:
            break
print(count)
