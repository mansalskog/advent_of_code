from hashlib import md5

MAX = 100000000

def solve(key):
    pw1 = ""
    pw2 = ["_"] * 8
    for n in range(MAX):
        h = md5((key + str(n)).encode("ascii")).hexdigest()
        if h.startswith("00000"):
            if len(pw1) < 8:
                print("1:", pw1)
                pw1 += h[5]
            if "0" <= h[5] <= "7":
                i = int(h[5])
                if pw2[i] == "_":
                    print("2:", "".join(pw2))
                    pw2[i] = h[6]
                    if "_" not in pw2:
                        break
    return (pw1, "".join(pw2))

print(solve("abc"))
print(solve("abbhdwsy"))
