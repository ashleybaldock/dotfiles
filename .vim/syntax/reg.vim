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

syn match SynErr contained /\\%/ contains=NONE
syn match SynErr contained /\\@/ contains=NONE

syn region BareRegex oneline
      \ matchgroup=BareEnds start=+^\s*[/?]*+
      \ skip=+$\s*\\+
      \ matchgroup=BareEnds end=+/\?$+
      \ contains=NewLine,MatchOr,
      \@Atoms,@Looks,Escaped,SynErr,@Multis,@Groups

      " \ end=+\z1.*\zs\z1+
syn region Substitute keepend transparent
      \ start=+\ze:\?\%(%\|'<,'>\)\?s\%[ubstitute]\z([/|+!@£$%^&:]\)+
      \ skip=+\\\z1+
      \ end=+\%([^\\]\)\@<=[^\\]\z1[cegiInp#lr]*\%(\s*\d\+\)\?\%(\s\|$\)+
      \ nextgroup=SubstColon,SubstRange,SubstCmd

syn match SubstColon +:+ contained contains=NONE nextgroup=SubstRange,SubstCmd
syn match SubstRange /%\|'<,'>/ contained contains=NONE nextgroup=SubstCmd
syn match SubstCmd /\<s\%[ubstitute]\>/ contained contains=NONE nextgroup=SubstPat
" syn match SubDelim1 +[/|+!@£$%^&:]+ contained contains=NONE
" nextgroup=SubstPat
syn region SubstPat contained keepend oneline
      \ matchgroup=SubstEnds start=+\\\@1<!\z([/|+!@£$%^&:]\)+
      \ skip=+\\\z1+
      \ end=+\z1+
      \ contains=@Atoms,@Looks,Escaped,SynErr,@Multis,@Groups,MatchOr
      \ nextgroup=SubstRep

syn region SubstRep contained keepend oneline
      \ start=+\%([^\\]\z([/|+!@£$%^&:]\)\)\@2<=+
      \ skip=+\\\z1+
      \ matchgroup=SubstEnds end=+\z1+
      \ contains=BackRef,Escaped
      \ nextgroup=SubstFlag,SubstCount

syn match SubstFlag /[cegiInp#lr]/ contained contains=NONE
      \ nextgroup=SubstFlag,SubstCount
syn match SubstCount /\s*\zs\d\+/ contained contains=NONE

syn region CapGrp contained oneline
      \ matchgroup=CapGrpEnds start=+\\(+
      \ end=+\\)+
      \ containedin=PreEscaped
      \ contains=@Atoms,@Looks,Escaped,SynErr,@Multis,@Groups,MatchOr

syn region NCapGrp contained oneline
      \ matchgroup=NCapGrpEnds start=+\\%(+
      \ end=+\\)+ 
      \ containedin=PreEscaped
      \ contains=@Atoms,@Looks,Escaped,SynErr,@Multis,@Groups,MatchOr

syn match BackRef /\\[0-9]/ contained

syn match Multi contained /\*/ contains=NONE
syn match Multi contained /\\+/ contains=NONE
syn match Multi contained /\\=/ contains=NONE
syn match Multi contained /\\?/ contains=NONE
syn match Multi contained /\\{-\?\d*,\?\d*}/ contains=NONE

syn match Escaped contained +\\\*+ contains=NONE
syn match Escaped contained +\\\/+ contains=NONE
syn match Escaped contained +\\\\+ contains=NONE
syn match Escaped contained +\\\[+ contains=NONE

syn match LkBehind contained /\\@\d*<=/ contains=NONE
syn match NLkBehind contained /\\@\d*<!/ contains=NONE
syn match LkAhead contained /\\@=>/ contains=NONE
syn match LkHere contained /\\@=/ contains=NONE
syn match NLkHere contained /\\@!/ contains=NONE

syn match Atom contained +\.+ contains=NONE
syn match Atom contained +\\ze+ contains=NONE
syn match Atom contained +\\zs+ contains=NONE

syn match BoL contained +\\_^+ contains=NONE
syn match BoL contained +^\zs\^+ contains=NONE
syn match BoL contained +\(\\[(|n]\)\@2<=\^+ contains=NONE
syn match BoL contained +\(\\%(\)\@3<=\^+ contains=NONE

syn match EoL excludenl contained +\\_$+ contains=NONE
syn match EoL excludenl contained +\$\ze$+ contains=NONE

syn match BEoW contained +\\[<>]+ contains=NONE

syn match NewLine /\\n/ contained

syn match Wildcard contained +\(\\_\)\?\.+ contains=NONE

syn region CharClass contained
      \ matchgroup=ChClEnds start=+\(\\_\)\?\[+
      \ skip=+\\]+
      \ end=+]+
      \ contains=ChRg
syn region NCharClass contained
      \ matchgroup=NChClEnds start=+\(\\_\)\?\[^+
      \ skip=+\\]+
      \ end=+]+
      \ contains=NChRg

syn match ChRg contained /.-[^]]/ contains=NONE
syn match NChRg contained /.-[^]]/ contains=NONE

syn cluster Atoms contains=Atom,CharClass,NCharClass,NewLine,BackRef
syn cluster Multis contains=Multi
syn cluster Looks contains=LkBehind,NLkBehind,LkAhead,LkHere,NLkHere
syn cluster Groups contains=CapGrp,NCapGrp

" syn region Multi contained oneline
"       \ start=+\\{+

syn match MatchOr /\\|/ contained contains=NONE

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

hi def CapGrp       guifg=#bbeeee               guisp=#cc8800 gui=underline
hi def CapGrpEnds   guifg=#ffaa33 guibg=#662200
hi def BackRef      guifg=#ffaa33 guibg=#662200
hi def NCapGrp      guifg=#bbeeee
hi def NCapGrpEnds  guifg=#eebbee guibg=#663366
hi def MatchOr      guifg=#ffff30                             gui=bold
hi def NewLine      guifg=#ffdd33 guibg=#8833dd
hi def BareEnds     guifg=#22ffff
hi def Substitute   guifg=#22ff22
hi def SubstEnds    guifg=#ffff30 gui=bold
hi def SubstRep     guifg=#eeddee
hi def link SubstFlags Error
hi def SubstFlag    guifg=#ff4499 guibg=bg
hi def link SubstCount SubstEnds

hi def SubstRange     guifg=#8888dd
hi def SubstCmd         guifg=#4fff29
hi def link SubstColon SubstCmd
hi def SubstPat       guifg=#bbeeee
" hi def BackRef      guifg=#00ffff guibg=#3300aa guisp=#00ffff gui=underdashed

hi def Look         guifg=#88eeee
hi def link LkBehind Look
hi def link NLkBehind Look
hi def link LkAhead Look
hi def link LkHere Look
hi def link NLkHere Look

hi def SynErr       guifg=#ffffff guibg=#ff0000
hi def Multi        guifg=#ff9999 gui=nocombine
hi def Escaped      guifg=#12cd4d
hi def Atom         guifg=#9999ff
hi def CharClass    guifg=#88aaff
hi def ChRg         guifg=#88aaff guibg=#001965 guisp=#5583ff gui=underline
hi def ChClEnds     guifg=#5583ff guibg=#001965
hi def NCharClass   guifg=#fea6a6
hi def NChClEnds    guifg=#ff3f3f guibg=#300000
hi def NChRg        guifg=#fea6a6 guibg=#300000 guisp=#ff3f3f gui=underline

let b:current_syntax = "reg"

let &cpo = s:cpo_save
unlet s:cpo_save
