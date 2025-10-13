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

syn region BareRegex oneline
      \ matchgroup=BareEnds start=+^\s*[/?]*+
      \ skip=+$\s*\\+
      \ matchgroup=BareEnds end=+/\?$+
      \ contains=CharClass,NotCharClass,Atom,Escaped,Multi,CaptureGrp,NonCapGrp,NewLine

syn region SubstCmd
      \ matchgroup=SubstEnds start=+:\?\%(%\|<,>,\)\?s\z([/|+!@£$%^&:]\)+
      \ skip=+\\\z1+
      \ end=+\z1+
      \ contains=CharClass,NotCharClass,Atom,Escaped,Multi,CaptureGrp,NonCapGrp,NewLine

syn region CaptureGrp contained oneline
      \ matchgroup=CaptureEnds start=+\\(+
      \ end=+\\)+
      \ containedin=PreEscaped
      \ contains=CharClass,NotCharClass,Atom,Escaped,Multi,CaptureGrp,NonCapGrp,MatchOr

syn region NonCapGrp contained oneline
      \ matchgroup=CaptureEnds start=+\\%(+
      \ end=+\\)+ 
      \ containedin=PreEscaped
      \ contains=@Atoms,Escaped,@Multis,@Groups,MatchOr

syn match Multi contained /\*/ contains=NONE
syn match Multi contained /\\+/ contains=NONE
syn match Multi contained /\\=/ contains=NONE
syn match Multi contained /\\?/ contains=NONE
syn match Multi contained /\\{-\?\d*,\?\d*}/ contains=NONE

syn match Escaped contained +\\\*+ contains=NONE
syn match Escaped contained +\\\/+ contains=NONE

syn match Atom contained +\.+ contains=NONE
syn match Atom contained +\\ze+ contains=NONE
syn match Atom contained +\\zs+ contains=NONE

syn match BoL contained +\\_^+ contains=NONE
syn match BoL contained +^\zs\^+ contains=NONE
syn match BoL contained +\(\\[(|n]\)\@2<=\^+ contains=NONE
syn match BoL contained +\(\\%(\)\@3<=\^+ contains=NONE

syn match EoL contained +\\_$+ contains=NONE
syn match EoL contained +\$\ze$+ contains=NONE

syn match BEoW contained +\\[<>]+ contains=NONE

syn match Wildcard contained +\(\\_\)\?\.+ contains=NONE

syn region CharClass contained
      \ matchgroup=ChClEnds start=+\(\\_\)\?\[+
      \ skip=+\\]+
      \ end=+]+
      \ contains=ChRg
syn region NotCharClass contained
      \ matchgroup=NotChClEnds start=+\(\\_\)\?\[^+
      \ skip=+\\]+
      \ end=+]+
      \ contains=NotChRg

syn match ChRg contained /.-[^]]/ contains=NONE
syn match NotChRg contained /.-[^]]/ contains=NONE

syn cluster Atoms contains=Atom,CharClass
syn cluster Multis contains=Multi
syn cluster Groups contains=CaptureGrp,NonCapGrp

" syn region Multi contained oneline
"       \ start=+\\{+

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

hi def CaptureGrp   guifg=#eebbee guisp=#ee55ee gui=underdashed
hi def NonCapGrp    guifg=#eebbee               gui=underdotted
hi def CaptureEnds  guifg=#ffaa22 guibg=#003333
hi def MatchOr      guifg=#ffaa22 guibg=#003333
hi def NewLine      guifg=#ffdd33 guibg=#8833dd
hi def BareEnds     guifg=#22ffff
hi def SubstCmd     guifg=#22ff22
hi def SubstEnds    guifg=#ffff44 guibg=#003333
hi def Multi        guifg=#ff9999 gui=nocombine
hi def Escaped      guifg=#12cd4d
hi def Atom         guifg=#9999ff
hi def CharClass    guifg=#88aaff
hi def ChRg         guifg=#88aaff guibg=#001965 guisp=#5583ff gui=underline
hi def ChClEnds     guifg=#5583ff guibg=#001965
hi def NotCharClass guifg=#fea6a6
hi def NotChClEnds  guifg=#ff3f3f guibg=#300000
hi def NotChRg      guifg=#fea6a6 guibg=#300000 guisp=#ff3f3f gui=underline

let b:current_syntax = "reg"

let &cpo = s:cpo_save
unlet s:cpo_save

