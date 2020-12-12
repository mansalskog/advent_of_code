y % (DY ? DY : 1) == 0 {
        # print substr($0, 1, x + 1);
        if (substr($0, x + 1, 1) == "#")
                trees++;
        x = (x + DX) % length($0);
        y++;
        next
}
{ y++ }
END { print trees }
