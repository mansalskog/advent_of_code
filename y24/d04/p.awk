{
    y = NR;
    w = length($0);
    for (x = 1; x <= w; x++) {
        a[x,y] = substr($0, x, 1);
    }
}

END {
    count = 0;
    count2 = 0;
    for (y = 1; y <= NR; y++) {
        for (x = 1; x <= w; x++) {
            if (a[x,y] == "X") {
                count += check(x, y,  1,  0);
                count += check(x, y,  1,  1);
                count += check(x, y,  0,  1);
                count += check(x, y, -1,  1);
                count += check(x, y, -1,  0);
                count += check(x, y, -1, -1);
                count += check(x, y,  0, -1);
                count += check(x, y,  1, -1);
            }
            if (a[x,y] == "A") {
                count2 += check2(x, y);
            }
        }
    }
    print count;
    print count2;
}

function check(x, y, dx, dy) {
    if (a[x+1*dx,y+1*dy] != "M") return 0;
    if (a[x+2*dx,y+2*dy] != "A") return 0;
    if (a[x+3*dx,y+3*dy] != "S") return 0;
    return 1;
}

function check2(x, y) {
    diag1 = (a[x+1,y+1] == "S" && a[x-1,y-1] == "M") || (a[x+1,y+1] == "M" && a[x-1,y-1] == "S");
    diag2 = (a[x+1,y-1] == "S" && a[x-1,y+1] == "M") || (a[x+1,y-1] == "M" && a[x-1,y+1] == "S");
    return diag1 && diag2;
}
