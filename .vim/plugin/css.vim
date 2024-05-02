if exists("g:mayhem_loaded_css")
  finish
endif
let g:mayhem_loaded_css = 1


" Change hex color codes to uppercase
command! UppercaseHex :%s/\<\(#\x\{8}\|#\x\{6}\|#\x\{4}\|#\x\{3}\)\>/\U&/g
" command! UppercaseHex :%s/\<\(#[0-9a-fA-F]\{8}\|#[0-9a-fA-F]\{6}\|#[0-9a-fA-F]\{4}\|#[0-9a-fA-F]\{3}\)\>/\U&/g
" Change hex color codes to lowercase
command! LowercaseHex :%s/\<\(#\x\{8}\|#\x\{6}\|#\x\{4}\|#\x\{3}\)\>/\L&/g
" Expand short hex codes (#F0E ▬▶︎ #FF00EE, #FB3A ▬▶︎ #FFBB33AA)
command! ExpandHex :%s/\<#\(\x\)\(\x\)\(\x\)\>/#\1\1\2\2\3\3/g

"       #rrggbb[aa] ▬▶︎ rgb(r g b [/ aa])
"                                                           TODO
command! HexToRgb <Nop>
"  rgb(r g b [/ a]) ▬▶︎ #rrggbb[aa] 
"                                                           TODO
command! RgbToHex <Nop>
"       #rrggbb[aa] ▬▶︎ hsl(h s l [/ a])
"                                                           TODO
command! HexToHsl <Nop>
"  hsl(h s l [/ a]) ▬▶︎ #rrggbb[aa] 
"                                                           TODO
command! HslToHex <Nop>
"
"                                                           TODO
command! RgbToHsl <Nop>
"                                                           TODO
command! HslToRgb <Nop>

" Get color's complement (h+180deg)
"                                                           TODO
command! Complement <Nop>


" Edge cases and formats etc.
"           #xyz[f] | #xxyyzz[ff]  ▬▶︎  rgb(r g b)
"      #xyz[0-e] | #xxyyzz[00-ef]  ▬▶︎  rgb(r g b / a)
"
"   (legacy) rgb(R,G,B) | (legacy) rgba(R,G,B,1) |
" rgb(R G B) | rgb(R G B / 1) | rgb(R G B / 100%)  ▬▶︎ #xxyyzz
"
"   (legacy) rgba(R,G,B,A) |
" rgb(R G B / [0-0.999])| rgb(R G B / [0-99.99%])  ▬▶︎ #xxyyzzaa

