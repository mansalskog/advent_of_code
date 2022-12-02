moves=$(sed 's/[AX]/1/g;s/[BY]/2/g;s/[CZ]/3/g')
movePts=$(echo "$moves" | awk '{t+=$2} END {print +t}')
winPts=$(echo "$moves" | awk '
$2==1 && $1==3 {p+=6}
$2==2 && $1==1 {p+=6}
$2==3 && $1==2 {p+=6}
$1 == $2 {p+=3}
END {print +p}')
echo $(($movePts + $winPts))

myMovePts=$(echo "$moves" | awk '
$2==1 {t += +substr("312", $1, 1)}
$2==2 {t += $1}
$2==3 {t += +substr("231", $1, 1)}
END {print t}')
myWinPts=$(echo "$moves" | awk '
$2==1 {p += 0}
$2==2 {p += 3}
$2==3 {p += 6}
END {print p}
')
echo $myMovePts
echo $myWinPts
echo $(($myMovePts + $myWinPts))
