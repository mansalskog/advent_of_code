import sys

text = [
    'abcefg',
    'cf',
    'acdeg',
    'acdfg',
    'bcdf',
    'abdfg',
    'abdefg',
    'acf',
    'abcdefg',
    'abcdfg'
]

def subset(s1, s2):
    return set(list(s1)).issubset(list(s2))

def base10(xs):
    return sum(x * 10**k for k, x in enumerate(reversed(xs)))

with open(sys.argv[1]) as f:
    part1 = 0
    part2 = 0
    for line in f:
        line = line[:-1]
        info, data = line.split(' | ')
        info = info.split(' ')
        data = data.split(' ')
    
        number = {}

        one = [w for w in info if len(w) == len(text[1])]
        print(1, one)
        assert len(one) == 1
        number[1] = one[0]

        four = [w for w in info if len(w) == len(text[4])]
        print(4, four)
        assert len(four) == 1
        number[4] = four[0]

        seven = [w for w in info if len(w) == len(text[7])]
        print(7, seven)
        assert len(seven) == 1
        number[7] = seven[0]

        eight = [w for w in info if len(w) == len(text[8])]
        print(8, eight)
        assert len(eight) == 1
        number[8] = eight[0]
        
        three = [w for w in info if 
                len(w) == len(text[3])
                and subset(number[1], w)
                and not subset(w, number[4])]
        print(3, three)
        assert len(three) == 1
        number[3] = three[0]

        zero = [w for w in info if
            len(w) == len(text[0])
            and subset(number[1], w)
            and not subset(number[3], w)]
        print(0, zero)
        assert len(zero) == 1
        number[0] = zero[0]

        nine = [w for w in info if
                len(w) == len(text[9])
                and subset(number[3], w)]
        print(9, nine)
        assert len(nine) == 1
        number[9] = nine[0]

        six = [w for w in info if
                len(w) == len(text[6])
                and not subset(number[4], w)
                and not subset(number[0], w)]
        print(6, six)
        assert len(six) == 1
        number[6] = six[0]

        five = [w for w in info if
                len(w) == len(text[5])
                and subset(w, number[6])]
        print(5, five)
        assert len(five) == 1
        number[5] = five[0]

        two = [w for w in info if
                len(w) == len(text[2])
                and not subset(w, number[5])
                and not subset(w, number[3])]
        print(2, two)
        assert len(two) == 1
        number[2] = two[0]

        flipped = {''.join(sorted(v)): k for k, v in number.items()}
        print(flipped, len(flipped))
        result = [flipped[''.join(sorted(w))] for w in data]
        print(result, base10(result))
        part2 += base10(result)

        for w in data:
            if len(w) in [len(text[k]) for k in [1, 4, 7, 8]]:
                part1 += 1

    print(part1, part2)
