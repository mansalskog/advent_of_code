BEGIN {p=-1}
p>0 && $0>p{n++}
{p=$0}
END {print n}
