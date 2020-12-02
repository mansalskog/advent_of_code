{
        split($1, l, "-");
        sub(/:/, "", $2); # remove colon
        c = gsub($2, "&", $3); # count number of $2 in $3
        if (c >= l[1] && c <= l[2])
               ok1++;
        s1 = substr($3, l[1], 1);
        s2 = substr($3, l[2], 1);
        if (s1 == $2 && s2 != $2)
                ok2++;
        if (s1 != $2 && s2 == $2)
                ok2++;
}
END { print ok1, ok2 }
