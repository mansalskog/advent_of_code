9!:3 (4) NB. display operators as trees
9!:11 (10) NB. print fixed width numbers of 10 digits
read =: 1!:1
print =: (1!:2 & 4) @ (, & LF) @ ":
text =: 1!:1 < 'input'
dx =: (text = '>') - text = '<'
dy =: (text = '^') - text = 'v'
x =: +/\ dx
y =: +/\ dy
pts =: ~. (0 0) , |: (2,#x)$x,y
print #pts NB. add one for (0,0)
sx =: +/\ ((#dx)$0 1) # dx
sy =: +/\ ((#dx)$0 1) # dy
spts =: |: (2,#sx)$sx,sy
rx =: +/\ ((#dx)$1 0) # dx
ry =: +/\ ((#dx)$1 0) # dy
rpts =: |: (2,#rx)$rx,ry
print # ~. (0 0) , spts , rpts
exit''
