#!/bin/sh

function transp() {
    awk '{l[NR]=$0} END {for(x=1;x<=length(l[1]);x++){for(y=1;y<=NR;y++){printf("%c",substr(l[y],x,1))} printf("\n")}}' "$1"
}
function diags1() {
    awk '{l[NR]=$0} END {W=length(l[1]);for(w=1;w<=W;w++){for(y=1;y<=w;y++){printf("%c",substr(l[y],w-y+1,1))} printf("\n")}}' "$1"
}
function diags2() {
    awk '{l[NR]=$0} END {W=length(l[1]);for(w=1;w<=W;w++){for(y=1;y<=w;y++){printf("%c",substr(l[W-y+1],w-y+1,1))} printf("\n")}}' "$1"
}
function diags3() {
    awk '{l[NR]=$0} END {W=length(l[1]);for(w=1;w<=W;w++){for(y=1;y<=w;y++){printf("%c",substr(l[W-y+1],W-(w-y)+1,1))} printf("\n")}}' "$1"
}
function diags4() {
    awk '{l[NR]=$0} END {W=length(l[1]);for(w=1;w<=W;w++){for(y=1;y<=w;y++){printf("%c",substr(l[y],W-(w-y)+1,1))} printf("\n")}}' "$1"
}
function count() {
    "$1" "$2" | grep -c XMAS
    "$1" "$2" | grep -c SAMX
}
function countall() {
    count cat "$1"
    count transp "$1"
    count diags1 "$1"
    count diags2 "$1"
    count diags3 "$1"
    count diags4 "$1"
}

countall input | awk '{tot+=$0} END {print tot}'
