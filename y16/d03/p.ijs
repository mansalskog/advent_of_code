print =: (1!:2 & 4) @ (, & LF) @ ":
text =: 1!:1 < 'input'
nums =: _1".(-.LF E.text)#text
tris =: |: (((#nums) % 3) , 3)$nums
s1 =: (0&{ < (1&{ + 2&{))
s2 =: (1&{ < (2&{ + 0&{))
s3 =: (2&{ < (0&{ + 1&{))
valid =: s1 *. s2 *. s3
print +/ valid tris
tris2 =: |: (|. $tris) $ ,tris
print +/ valid tris2
exit''
