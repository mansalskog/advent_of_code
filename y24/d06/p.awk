{
    y = NR;
    W = length($0);
    for (x=1; x<=W; x++) {
        c = substr($0, x, 1);
        if (c == "<" || c == ">" || c == "^" || c == "v") {
            GX = x;
            GY = y;
            T[x,y] = c;
        } else {
            T[x,y] = c;
        }
    }
}

function resetboard() {
    for (x=1; x<=W; x++) {
        for (y=1; y<=H; y++) {
            t[x,y] = T[x,y];
            s[x,y,"^"] = 0;
            s[x,y,">"] = 0;
            s[x,y,"<"] = 0;
            s[x,y,"v"] = 0;
        }
    }
    gx = GX;
    gy = GY;
}

END {
    H = NR;

    resetboard();
    simulate();

    N=0;
    for (ox=1; ox<=W; ox++) {
        for (oy=1; oy<=H; oy++) {
            if (N++ % 100 == 0) {
                printf("%f %%\n", 100 * N / (W*H));
            }
            resetboard();
            if (t[ox,oy] == ".") {
                t[ox,oy] = "O";
                stat = simulate();
                if (stat == 1) {
                    # printtot();
                } else if (stat == -1) {
                    # printf("loop at %d %d\n", ox, oy);
                    # printboard();
                    loops++;
                }
            }
        }
    }

    printf("LOOPS: %d\n", loops);
}

function simulate() {
    while (1) {
        stat = stepsim();
        if (stat == 1 || stat == -1) {
            return stat;
        }
    }
}

function stepsim() {
    c=t[gx,gy];

    if (s[gx,gy,c]) {
        # loop
        return -1;
    }

    s[gx,gy,c] = 1;

    if (c == "^") {
        nx=gx;
        ny=gy-1;
        rg=">";
    } else if (c == "v") {
        nx=gx;
        ny=gy+1;
        rg="<";
    } else if (c == ">") {
        nx=gx+1;
        ny=gy;
        rg="v";
    } else if (c == "<") {
        nx=gx-1;
        ny=gy;
        rg="^";
    }

    # printf("%c %d %d\n", c, nx, ny);

    if (nx <= 0 || nx > W || ny <= 0 || ny > H) {
        # outside
        return 1;
    }

    if (t[nx,ny] == "#" || t[nx,ny] == "O") {
        t[gx,gy] = rg;
    } else if (t[nx,ny] == ".") {
        t[nx,ny] = t[gx,gy];
        t[gx,gy] = ".";
        gx = nx;
        gy = ny;
    } else {
        # fail
    }

    return 0;
}

function printtot() {
    tot=0;
    for (y=1; y<=H; y++) {
        for (x=1; x<=W; x++) {
            if (s[x,y] != 0) {
                tot+=1;
            }
        }
    }
    printf("out after %d\n", tot);
}

function printboard() {
    for (y=1; y<=H; y++) {
        for (x=1; x<=W; x++) {
            printf("%c", t[x,y]);
        }
        print"";
    }
}
