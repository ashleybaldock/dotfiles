if exists("g:mayhem_loaded_titlestring")
  finish
endif
let g:mayhem_loaded_titlestring = 1


" function s:ToFixedWidth(text)
"   a:firstline
"   '<,'>s/\u/\=nr2char(char2nr(submatch(0)) + 0x1D62F)/g
"   '<,'>s/\l/\=nr2char(char2nr(submatch(0)) + 0x1D629)/g
" endfunc


set titlestring=│\ %{SessionName()}\ │\ %t\ │\ %{substitute\(pathshorten\(expand(\"%:p:~:h\"),8),\"/\",\" / \",\"g\"\)}\ / %t

