9!:3 (4) NB. display operators as trees
9!:11 (10) NB. print fixed width numbers of 10 digits
strsplit =: #@[ }.each [ (E. <;.1 ]) ,
read =: 1!:1
print =: (1!:2 & 4) @ (, & LF) @ ":
text =: 1!:1 < 'input'
values =: , "2 (".@>) "0 'x' strsplit "1 > LF strsplit text
NB. testing data
NB. values =: _10 {. }: values
NB. values =: 2 3$2 3 4 1 1 10
areas =: values * 0 1 |. values
smallest =: <./ "1 areas
total =: (+/ +/ 2 * areas) + (+/ smallest)
print total
faces =: 2 * (values + 0 1 |. values)
volumes =: */ "1 values
total =: (+/ <./ "1 faces) + (+/ volumes)
print total
exit''
