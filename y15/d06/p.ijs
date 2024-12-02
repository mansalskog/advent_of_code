9!:3 (4)
read =: 1!:1
print =: (1!:2 & 4) @ (, & LF) @ ":
text =: 1!:1 < 'input'
words =: cut;._2 text


NB. lines =: < ;._2 text
NB. lines =: 7 {. lines
NB. off =: *./"1 'turn off'="1 (8{. >)"0 lines
NB. on =: *./"1 'turn on'="1 (7{. >)"0 lines
NB. toggle =: *./"1 'toggle'="1 (6{. >)"0 lines
NB. idx =: ([ # i.@#)
