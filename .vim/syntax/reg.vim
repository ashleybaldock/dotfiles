if exists("b:current_syntax")
  finish
endif

"
" Syntax etc. for 'reg'ular exes
"
" Useful for quote blocks in md files
"
" au BufWritePost <buffer> syn on
"

let s:cpo_save = &cpo
set cpo&vim

syn region SubstCmd
      \ matchgroup=SubstEnds start=+:\?\%(%\|<,>,\)\?s\z([/|+!@£$%^&:]\)+
      \ end=+\z1+
      \ contains=CaptureGrp,NonCapGrp,NewLine

syn region CaptureGrp contained oneline
      \ matchgroup=CaptureEnds start=+\\(+
      \ end=+\\)+
      \ containedin=PreEscaped
      \ contains=CaptureGrp,NonCapGrp,MatchOr

syn region NonCapGrp contained oneline
      \ matchgroup=CaptureEnds start=+\\%(+
      \ end=+\\)+ 
      \ containedin=PreEscaped
      \ contains=CaptureGrp,NonCapGrp,MatchOr

syn match MatchOr /\\|/ contained
syn match NewLine /\\n/ contained

"hi def  guifg=#eebbee
"hi def  guifg=#ff9999
"hi def  guifg=#00ff99
"hi def  guifg=#9999ff
"hi def  guifg=#99ffbb
"hi def  guifg=#ffff99
"hi def  guifg=#88eeee
"hi def  guifg=#12cd4d
"hi def  guifg=#88eead
"hi def  guifg=#00ff00
"hi def  guifg=#ffaa00
"hi def  guifg=#ff0000

hi def CaptureGrp    guifg=#eebbee guisp=#ee55ee gui=underdashed
hi def NonCapGrp     guifg=#eebbee               gui=underdotted
hi def CaptureEnds   guifg=#ffaa22 guibg=#003333
hi def MatchOr       guifg=#ffaa22 guibg=#003333
hi def NewLine       guifg=#ffdd33 guibg=#8833dd
hi def SubstCmd      guifg=#00ff00 guibg=#003333
hi def SubstEnds     guifg=#ffff44 guibg=#003333

let b:current_syntax = "reg"

let &cpo = s:cpo_save
unlet s:cpo_save

