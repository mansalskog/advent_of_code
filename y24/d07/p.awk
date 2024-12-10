{
    print NR;
    for (perm=0; perm<lshift(1,2*(NF-2)); perm++) {
        val = evalperm(perm);
        expt = $1 + 0;
        if (val == expt) {
            res += expt;
            break;
        }
    }
}

END {print res}

function evalperm(perm) {
    tot = 0;
    tot = $2;
    # printf("%d", tot);
    for (i=3; i<=NF; i++) {
        op = and(rshift(perm, 2*(i-3)), 3);
        if (op == 0) {
            # printf(" * %d", $i);
            tot = tot * $i;
        } else if (op == 1) {
            # printf(" + %d", $i);
            tot = tot + $i;
        } else if (op == 2) {
            # printf(" || %d", $i);
            tot = tot $i;
        } else if (op == 3) {
            # dummy
            # printf(" + %d", $i);
            tot = tot + $i;
        }
    }
    # printf(" = %d\n", tot);
    return tot;
}
