{
    y = NR;
    for (x = 1; x <= length($0); x++) {
        f = substr($0, x, 1);
        if (f != ".") {
            ++An;
            Ax[An] = x;
            Ay[An] = y;
            Af[An] = f;
        }
    }
    W = length($0);
    H = y;
}

END {
    for (i = 1; i <= An; i++) {
        # printf("%d %d %c\n", Ax[i], Ay[i], Af[i]);
    }
    for (y = 1; y <= H; y++) {
        # printf("%d / %d\n", y, H);
        for (x = 1; x <= W; x++) {
            if (isnode(x, y)) {
                total++;
                printf("#");
            } else {
                printf(".");
            }
        }
        print "";
    }
    print total;
}

function isnode(x, y) {
    for (i = 1; i <= An; i++) {
        for (j = 1; j <= An; j++) {
            if (i == j) continue;
            if (Af[i] != Af[j]) continue;
            dxI = Ax[i] - x;
            dyI = Ay[i] - y;
            dxJ = Ax[j] - x;
            dyJ = Ay[j] - y;
            # if (dxI == dxJ * 2 && dyI == dyJ * 2) return 1;
            # if (dxI == 0 || dyI == 0 || dxJ == 0 || dyJ == 0) continue;
            for (n = 0; n <= 50; n++) {
                for (m = 1; m <= 50; m++) {
                    if (dxI * n == dxJ * m && dyI * n == dyJ * m) {
                        return 1;
                    }
                }
            }
        }
    }
    return 0;
}
