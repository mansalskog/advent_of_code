import sys

def bits(bs, f, t):
    x = 0
    # tst = []
    for i in range(f, t):
        y = bool(bs[i // 8] & (1 << (7 - i % 8)))
        x <<= 1
        x += y
        # tst.append(0 + y)
    # print(''.join(map(str, tst)))
    return x

def packet(bs, k):
    i = k
    ver = bits(bs, i, i + 3)
    typ = bits(bs, i + 3, i + 6)
    i += 6
    # print('version:', ver, 'type:', typ)
    if typ == 4:
        lit = 0
        while True:
            lit <<= 4
            lit += bits(bs, i + 1, i + 5)
            i += 5
            if bits(bs, i - 5, i - 4) == 0:
                break
        print('literal:', lit)
        return i, ver, lit
    else:
        lentyp = bits(bs, i, i + 1)
        i += 1
        vsum = ver
        value = None
        if lentyp == 0:
            length = bits(bs, i, i + 15)
            i += 15
            # print('length type:', lentyp, 'length:', length)
            k = i
            while i - k < length:
                i, vsn, v = packet(bs, i)
                vsum += vsn
                print('value is now:', value, 'and:', v)
                if value is None:
                    value = v
                elif typ == 0:
                    value += v
                elif typ == 1:
                    value *= v
                elif typ == 2:
                    value = min(value, v)
                elif typ == 3:
                    value = max(value, v)
                elif typ == 5:
                    value = int(value > v)
                elif typ == 6:
                    value = int(value < v)
                elif typ == 7:
                    value = int(value == v)
        else:
            length = bits(bs, i, i + 11)
            i += 11
            # print('length type:', lentyp, 'length:', length)
            for n in range(length):
                i, vsn, v = packet(bs, i)
                vsum += vsn
                if value is None:
                    value = v
                elif typ == 0:
                    value += v
                elif typ == 1:
                    value *= v
                elif typ == 2:
                    value = min(value, v)
                elif typ == 3:
                    value = max(value, v)
                elif typ == 5:
                    value = int(value > v)
                elif typ == 6:
                    value = int(value < v)
                elif typ == 7:
                    value = int(value == v)
        return i, vsum, value


with open(sys.argv[1]) as f:
    for l in f:
        bs = bytes.fromhex(l[:-1])
        i, vsum, value = packet(bs, 0)
        print('version number sum:', vsum)
        print('final value:', value)
