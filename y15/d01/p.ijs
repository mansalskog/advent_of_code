9!:3 (4)
read =: 1!:1
print =: (1!:2 & 4) @ (, & LF) @ ":
text =: 1!:1 < 'input'
NB. part 1
delta =: (text = '(') - (text = ')')
floor =: +/ delta
print floor
NB. part 2
NB. index =: ((+/"1 (((#,1:)$(i.@#)){.]) delta) < 0) i. 1
index =: ((+/\ 0,delta) < 0) i. 1
print index
NB. exit ''
