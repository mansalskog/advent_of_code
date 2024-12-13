#!bqn

# Decode binary string
ToInt←{
digits←𝕩-'0'
+´digits×10⋆⌽↕≠digits
}

IsDigit←{
  ('0'≤𝕩)×𝕩≤'9'
}

NotEmpty←{𝕩≡""? ⟨⟩ ; ⟨𝕩⟩}
SplitDigits←{
  𝕊𝕩: ""𝕊𝕩 ;
  𝕨𝕊⟨⟩: NotEmpty 𝕨 ;
  𝕨𝕊𝕩: ¬IsDigit⊑𝕩? (NotEmpty 𝕨)∾ ""𝕊 1↓𝕩 ;
  𝕨𝕊𝕩: (𝕨∾⊑𝕩) 𝕊 1↓𝕩
}

IsInt←0.001≥|∘-⟜(⌊0.5⊸+)

# Split string on spaces using recursive fn
Split←{
  𝕊𝕩: ""𝕊𝕩 ;
  𝕨𝕊⟨⟩: ⟨𝕨⟩ ;
  𝕨𝕊𝕩: ' '=⊑𝕩? ⟨𝕨⟩ ∾ ""𝕊 1↓𝕩 ;
  𝕨𝕊𝕩: (𝕨∾⊑𝕩) 𝕊 1↓𝕩
}

# Ugly 2x2 matrix math
Det←{⟨a,b,c,d⟩:(a×d)-b×c}
Inv←{⟨a,b,c,d⟩:⟨d,-b,-c,a⟩÷Det⟨a,b,c,d⟩}
Mul←{⟨a,b,c,d⟩𝕊⟨x,y⟩:⟨(a×x)+b×y,(c×x)+d×y⟩}

part2←0
Solve←{
  ⟨⟨ax,ay⟩,⟨bx,by⟩,⟨gx,gy⟩⟩←ToInt¨¨ 𝕩
  inv←(Inv ⟨ax,bx,ay,by⟩)
  {part2?⟨gx,gy⟩+↩10000000000000; 0}
  ⟨an,bn⟩←inv Mul⟨gx,gy⟩
  { ⌈´IsInt⟨an,bn⟩ ? bn+3×an ; 0}
}


Process←{
  𝕊⟨⟩: ⟨⟩ ;
  𝕊𝕩: (Process 4↓𝕩) ∾ Solve 3↑𝕩
}

ls←•FLines "input"
•Show +´ Process SplitDigits¨ ls
