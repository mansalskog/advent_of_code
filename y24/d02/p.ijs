9!:3 (4)
text =: 1!:1 < 'input'
mat =: |: ". ;._2 text
diffs =: (}: mat) - }. mat
NB. is there no good way to represent arrays of different lengths?
NB. just assume there are no zeros in the input and ignore all zeros produced by reading empty string as number
zeros =: 0 = }. mat
decr =: zeros +. ((1 <: diffs) *. (diffs <: 3))
incr =: zeros +. ((_3 <: diffs) *. (diffs <: _1))
safe =: +/ ((*./ decr) +. (*./ incr))
NB. safe2 =: +/ ((
