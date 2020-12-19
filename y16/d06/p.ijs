print =: (1!:2 & 4) @ (, & LF) @ ":
text =: 1!:1 < 'input'
cols =: ] ]\~ [: - [
nolf =: -. (LF = ]) # ]
chars =: (text i. LF) cols nolf text
count =: +/ @ (({|:) =/ (~. @ ({|:)))

common =: ((] = >./) @ count) # (~. @ ({|:))
message1 =: , (common & chars)"0 (i. 1 { $chars)
print message1

uncommon =: ((] = <./) @ count) # (~. @ ({|:))
message2 =: , (uncommon & chars)"0 (i. 1 { $chars)
print message2
