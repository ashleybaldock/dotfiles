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

" A pattern is one or more branches, separated by "\|"
syn match PatternStart contained /\ze/ contains=NONE
      \ nextgroup=BoL,Branch
syn match PatternEnd contained /\ze/ contains=NONE

" A branch is one or more concats, separated by "\&"
syn match Branch contained /\ze/ contains=NONE
      \ nextgroup=Concat
syn match OR contained /\\|/ contains=NONE
      \ nextgroup=Branch
syn match AND contained /\\&/ contains=NONE
      \ nextgroup=Concat
" A concat is one or more pieces, concatenated
syn match Concat contained /\ze/ contains=NONE
      \ nextgroup=OR,AND,Piece
" A piece is an atom, possibly followed by a multi
syn match Piece contained /\ze/ contains=NONE
      \ nextgroup=Atom
syn match Atom contained // contains=@Atoms
      \ nextgroup=@Multi,Piece

syn region BareRegex oneline
      \ matchgroup=BareEnds start=+^\s*[/?]*+
      \ skip=+$\s*\\+
      \ matchgroup=BareEnds end=+/\?$+
      \ contains=NewLine,MatchOr,
      \@Atoms,@Looks,Escaped,SynErr,@Multis,@Groups

"{{{1 :substitute
syn region Substitute keepend transparent
      \ start=+\ze:\?\%(%\|'<,'>\)\?s\%[ubstitute]\z([/|+!@£$%^&:]\)+
      \ skip=+\\\%(_[$^]\|\z1\)+
      \ end=+\%([^\\]\)\@<=[^\\]\z1[cegiInp#lr]*\%(\s*\d\+\)\?\%(\s\|$\)+
      \ nextgroup=SubstColon,SubstRange,SubstCmd
syn match SubstColon +:+ contained contains=NONE
      \ nextgroup=SubstRange,SubstCmd
syn match SubstRange /%\|'<,'>/ contained contains=NONE
      \ nextgroup=SubstCmd
syn match SubstCmd /s\%[ubstitute]\ze[/|+!@£$%^&:]/ contained contains=NONE
      \ nextgroup=SubstPattern
syn region SubstPattern contained keepend oneline
      \ matchgroup=SubstDelim start=+\\\@1<!\z([/|+!@£$%^&:]\)+
      \ skip=+\\\%(_[$^]\|\z1\)+
      \ end=+\z1+
      \ contains=@Atoms,@Looks,Escaped,SynErr,@Multis,@Groups,MatchOr
      \ nextgroup=SubstReplace
syn region SubstReplace contained keepend oneline
      \ start=+\%([^\\]\z([/|+!@£$%^&:]\)\)\@2<=+
      \ skip=+\\\z1+
      \ matchgroup=SubstDelim end=+\z1+
      \ contains=BackRef,Escaped
      \ nextgroup=SubstFlag,SubstCount
syn match SubstFlag /[cegiInp#lr]/ contained contains=NONE
      \ nextgroup=SubstFlag,SubstCount
syn match SubstCount /\s*\zs\d\+/ contained contains=NONE
"}}}1

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

syn match Engine /\\%#=[0-2]/ contains=NONE
syn match Magic /\\m/ contains=NONE
syn match NoMagic /\\M/ contains=NONE
syn match VeryMagic /\\v/ contains=NONE
syn match VeryNoMagic /\\V/ contains=NONE

syn match BackRef /\\[0-9]/ contained

syn match Multi contained /\*/ contains=NONE
syn match Multi contained /\\+/ contains=NONE
syn match Multi contained /\\=/ contains=NONE
syn match Multi contained /\\?/ contains=NONE
syn match Multi contained /\\{-\?\d*,\?\d*}/ contains=NONE

syn match Escaped contained +\\[.*/\\[$^]+ contains=NONE

syn match LkBehind contained /\\@\d*<=/ contains=NONE
syn match NLkBehind contained /\\@\d*<!/ contains=NONE
syn match LkAhead contained /\\@=>/ contains=NONE
syn match LkHere contained /\\@=/ contains=NONE
syn match NLkHere contained /\\@!/ contains=NONE

syn match SoM contained +\\zs+ contains=NONE
syn match EoM contained +\\ze+ contains=NONE

syn match BoL contained +\\_^+ contains=NONE
syn match BoL contained +\^\zs\_^+ contains=NONE
syn match BoL contained +\(\\[(|n]\)\@2<=\^+ contains=NONE
syn match BoL contained +\(\\%(\)\@3<=\^+ contains=NONE

syn match EoL excludenl contained +\\_\$+ contains=NONE
syn match EoL excludenl contained +\$\ze\_$+ contains=NONE

syn match BoF contained /\\%^/ contains=NONE
syn match EoF contained /\\%$/ contains=NONE
syn match BdVis contained /\\%V/ contains=NONE
syn match BdCur contained /\\%#/ contains=NONE
syn match BdMark contained /\\%[<>]\?'[A-Za-z0-9]/ contains=BdBefore,BdAfter,BdAt
syn match BdLine contained /\\%[<>]\?\%(\d\+\|\.\)l/ contains=BdBefore,BdAfter,BdAt
syn match BdCol  contained /\\%[<>]\?\%(\d\+\|\.\)c/ contains=BdBefore,BdAfter,BdAt
syn match BdVCol contained /\\%[<>]\?\%(\d\+\|\.\)v/ contains=BdBefore,BdAfter,BdAt

syn match BdAt contained /[^<>]\@1<=\%(\d\+\|\.\|'[A-Za-z0-9]\)\?/ contains=NONE
syn match BdBefore contained      /<\%(\d\+\|\.\|'[A-Za-z0-9]\)\?/ contains=NONE
syn match BdAfter contained       />\%(\d\+\|\.\|'[A-Za-z0-9]\)\?/ contains=NONE

syn match BEoW contained +\\[<>]+ contains=NONE

syn match NewLine /\\n/ contained

syn match Wildcard contained +\%(\\_\)\?\.+ contains=NONE

syn region CharClass contained
      \ matchgroup=ChClEnds start=+\(\\_\)\?\[+
      \ skip=+\\]+
      \ end=+]+
      \ contains=ChClRange
syn region NCharClass contained
      \ matchgroup=NChClEnds start=+\(\\_\)\?\[^+
      \ skip=+\\]+
      \ end=+]+
      \ contains=NChClRange

syn match ChClRange contained /[^[-]-[^]-]/ contains=ChClRgSep
syn match ChClRangeSep contained /[^[-]\@1<=-\ze[^]-]/ contains=NONE
syn match NChClRange contained /[^[-]-[^]-]/ contains=NChClRgSep
syn match NChClRangeSep contained /[^[-]\@1<=-\ze[^]-]/ contains=NONE

syn cluster Flags contains=Engine,Magic,NoMagic,VeryMagic,VeryNoMagic
syn cluster Bounds contains=
      \Boundary,BoL,EoL,BoF,EoF,BEoW,SoM,EoM,
      \BdVis,BdCur,BdMark,BdLine,BdCol,BdVCol
syn cluster Atoms contains=Atom,Wildcard,Escaped,@Bounds,CharClass,NCharClass,NewLine,BackRef
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

hi def CapGrp       guifg=#bbeeee guibg=#662200 guisp=#cc8800 gui=underline
hi def CapGrpEnds   guifg=#ffaa33 guibg=#662200
hi def BackRef      guifg=#ffaa33 guibg=#662200
hi def NCapGrp      guifg=#bbeeee
hi def NCapGrpEnds  guifg=#f6ccf6 guibg=#662266
hi def MatchOr      guifg=#ffff30                             gui=bold
hi def NewLine      guifg=#ffdd33 guibg=#8833dd
hi def BareEnds     guifg=#22ffff
hi def Substitute   guifg=#22ff22
hi def SubstDelim   guifg=#ffff30                             gui=bold
hi def SubstReplace guifg=#eeddee
hi def link SubstFlags Error
hi def SubstFlag    guifg=#ff4499 guibg=bg
hi def link SubstCount SubstDelim

hi def SubstRange   guifg=#44dd88
hi def SubstRgComma guifg=#44dd88
hi def SubstCmd     guifg=#4fff29
hi def link SubstColon SubstCmd
hi def SubstPattern guifg=#bbeeee
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
hi def Boundary     guifg=#c248fe
hi def link BoL Boundary
hi def link EoL Boundary
hi def link BoF Boundary
hi def link EoF Boundary
hi def link BEoW Boundary
hi def link SoM Boundary
hi def link EoM Boundary
hi def link Visual Boundary
hi def link Cursor Boundary
hi def link BdMark Boundary
hi def link BdLine Boundary
hi def link BdCol Boundary
hi def link BdVcol Boundary
hi def BdBefore guifg=#bb1111
hi def BdAfter guifg=#228822
hi def BdAt guifg=#999922
hi def Mark guifg=#229999
hi def CharClass    guifg=#88aaff
hi def ChClRange    guifg=#88aaff guibg=#001965 guisp=#5583ff gui=underline
hi def ChClEnds     guifg=#5583ff guibg=#001965
hi def NCharClass   guifg=#fea6a6
" hi def NChClEnds    guifg=#ff3f3f guibg=#300000
" hi def NChClRange   guifg=#fea6a6 guibg=#300000 guisp=#ff3f3f gui=underline
hi def NChClEnds    guifg=#ff3f3f guibg=NONE               gui=nocombine
hi def NChClRange   guifg=#fea6a6 guibg=NONE guisp=#ff3f3f gui=underline

let b:current_syntax = "reg"

let &cpo = s:cpo_save
unlet s:cpo_save
