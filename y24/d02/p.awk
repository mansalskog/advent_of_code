{
    for (skip = 0; skip <= NF; skip++) {
        delete a;
        j = 1;
        for (i = 1; i <= NF; i++) {
            if (skip != i) {
                a[j++] = 0 + $i;
            }
        }
        if (issafe(j-1)) {
            total++;
            printf("safe if skip = %d: ", skip);
            print;
            next;
        }
    }
    printf("unsafe: ");
    print;
}

END {print total}

function issafe(len) {
    incr = 1;
    decr = 1;
    # printf("%d ", a[1]);
    for (i = 2; i <= len; i++) {
        diff = a[i] - a[i-1];
        # printf("(%d) %d ", diff, a[i]);
        incr = incr && 1 <= diff && diff <= 3;
        decr = decr && -3 <= diff && diff <= -1;
        if (!(incr || decr)) break;
    }
    # printf("\n");
    return incr || decr;
}
