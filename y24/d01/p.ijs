9!:3 (4)
text =: 1!:1 < 'test'
nums =: ". > cut;._2 text
fst =: 0 { |: nums
snd =: 1 { |: nums
fst_sort =: (/: fst) C. fst
snd_sort =: (/: snd) C. snd
total =: +/ | fst_sort - snd_sort
NB. this language has no fucking sensible way to print stuff
fst_sqr =: ((#fst),#fst) $ fst
snd_sqr =: ((#snd),#snd) $ snd
comp =: fst_sqr = |: snd_sqr
score =: +/ fst * +/ comp
