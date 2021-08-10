from hashlib import md5

MAX = 100000000

def solve(key):
    for n in range(MAX):
        h = md5((key + str(n)).encode("ascii"))
        if h.hexdigest().startswith("000000"):
            return n
    return None

# print(solve("abcdef"))
# print(solve("pqrstuv"))
print(solve("yzbqklnj"))
