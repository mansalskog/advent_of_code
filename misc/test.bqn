#!bqn

# Decode binary string
str←"01001110 01100101 01110010 01100100 00100001 "
words←⍉5‿9⥊str
bits←¯1↓words-'0'
ans←@++˝bits×2⋆⌽↕≠bits
•Out ans

# Split string on spaces using recursive fn
test←"hej san svej san"
Split←{
  𝕊𝕩: ""𝕊𝕩 ;
  𝕨𝕊⟨⟩: ⟨𝕨⟩ ;
  𝕨𝕊𝕩: ' '=⊑𝕩? ⟨𝕨⟩∾ ""𝕊 1↓𝕩 ;
  𝕨𝕊𝕩: (𝕨∾⊑𝕩) 𝕊 1↓𝕩
}
•Show Split test
