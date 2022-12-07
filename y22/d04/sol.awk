{
    split($0, a, /[-,]/);
    for (i = 1; i <= 4; i++) a[i] = +a[i];
    if ((a[1] <= a[3] && a[4] <= a[2]) || (a[3] <= a[1] && a[2] <= a[4])) {
        c += 1;
    }
    if (inc(a[3], a[1], a[2]) || inc(a[4], a[1], a[2]) || inc(a[1], a[3], a[4]) || inc(a[2], a[3], a[4])) {
        o += 1;
    }
}

function inc(x, y, z) {
    return y <= x && x <= z;
}

END {print c, o}
