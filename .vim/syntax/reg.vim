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

syn keyword ColExprKeyword contained alnum alpha blank cntrl digit graph lower 
syn keyword ColExprKeyword contained lprint punct space upper xdigit return 
syn keyword ColExprKeyword contained tab escape backspace ident keyword fname

syn match SynErr contained /\\%/ contains=NONE
syn match SynErr contained /\\@/ contains=NONE
syn match SynUnknown contained /\\\w/ contains=NONE

" A pattern is one or more branches, separated by "\|"
syn match PatternStart contained /\ze/ contains=NONE
      \ nextgroup=BoP,Branch
syn match BoP contained /^/ contains=NONE
      \ nextgroup=Branch
syn match PatternEnd contained /\ze/ contains=NONE

" A branch is one or more concats, separated by "\&"
syn match Branch contained /\ze/ contains=NONE
      \ nextgroup=Concat
syn match OR contained /\\|/ contains=MatchOr
      \ nextgroup=Branch
syn match AND contained /\\&/ contains=MatchAnd
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
      \ contains=NewLine,MatchOr,MatchAnd,
      \@Atoms,@Looks,SynUnknown,SynErr,@Multis,@Groups

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
      \ contains=@Atoms,@Looks,SynUnknown,SynErr,@Multis,@Groups,MatchOr
      \ nextgroup=SubstReplace
syn region SubstReplace contained keepend oneline
      \ start=+\%([^\\]\z([/|+!@£$%^&:]\)\)\@2<=+
      \ skip=+\\\z1+
      \ matchgroup=SubstDelim end=+\z1+
      \ contains=BackRef
      \ nextgroup=SubstFlag,SubstCount
syn match SubstFlag /[cegiInp#lr]/ contained contains=NONE
      \ nextgroup=SubstFlag,SubstCount
syn match SubstCount /\s*\zs\d\+/ contained contains=NONE
"}}}1

syn region CapGrp contained oneline
      \ matchgroup=CapGrpEnds start=+\\(+
      \ end=+\\)+
      \ containedin=PreEscaped
      \ contains=CapGrpOr,@Atoms,@Looks,SynUnknown,SynErr,@Multis,@Groups
syn match CapGrpOr /\\|/ contained contains=NONE

syn region NCapGrp contained oneline
      \ matchgroup=NCapGrpEnds start=+\\%(+
      \ end=+\\)+ 
      \ containedin=PreEscaped
      \ contains=NCapGrpOr,@Atoms,@Looks,SynUnknown,SynErr,@Multis,@Groups
syn match NCapGrpOr /\\|/ contained contains=NONE

syn match BackRef /\\[0-9]/ contained

syn match Engine /\\%#=[0-2]/ contains=NONE
syn match Magic /\\m/ contains=NONE
syn match NoMagic /\\M/ contains=NONE
syn match VeryMagic /\\v/ contains=NONE
syn match VeryNoMagic /\\V/ contains=NONE

syn match Greedy contained /\*/ contains=NONE
syn match Greedy contained /\\[+=?]/ contains=NONE
syn match Greedy contained /\\{\d*,\?\d*\\\?}/ contains=NONE
syn match Lazy contained /\\{-\d*,\?\d*\\\?}/ contains=NONE

syn match Literal contained +\\[.*/\\[$^etrb]+ contains=NONE

syn match LkBehind contained /\\@\d*<=/ contains=LkCount,LkWhere
syn match NLkBehind contained /\\@\d*<!/ contains=LkCount,LkWhere
syn match LkAhead contained /\\@=>/ contains=LkWhere
syn match LkHere contained /\\@=/ contains=LkWhere
syn match NLkHere contained /\\@!/ contains=LkWhere
syn match LkCount contained /\d\+/ contains=NONE
syn match LkWhere contained />\|=\|!\|<=\|<!/ contains=NONE

syn match SoM contained +\\zs+ contains=NONE
syn match EoM contained +\\ze+ contains=NONE

syn match BoL contained +\\_^+ contains=NONE
syn match BoL contained +\^\zs\_^+ contains=NONE
syn match BoL contained +\(\\[(|n]\)\@2<=\^+ contains=NONE
syn match BoL contained +\(\\%(\)\@3<=\^+ contains=NONE

syn match EoL excludenl contained +\\_\$+ contains=NONE
syn match EoL excludenl contained +\$\ze\_$+ contains=NONE
syn match EoL contained +\\n+ contains=NONE

syn match BoF contained +\\%^+ contains=NONE
syn match EoF contained +\\%$+ contains=NONE
syn match BdVis contained +\\%V+ contains=NONE
syn match BdCur contained +\\%#+ contains=NONE
syn match BdMark contained /\\%[<>]\?'[A-Za-z0-9]/ contains=BdBefore,BdAfter,BdAt
syn match BdLine contained /\\%[<>]\?\%(\d\+\|\.\)l/ contains=BdBefore,BdAfter,BdAt
syn match BdCol  contained /\\%[<>]\?\%(\d\+\|\.\)c/ contains=BdBefore,BdAfter,BdAt
syn match BdVCol contained /\\%[<>]\?\%(\d\+\|\.\)v/ contains=BdBefore,BdAfter,BdAt

syn match BdAt contained /[^<>]\@1<=\%(\d\+\|\.\|'[A-Za-z0-9]\)\?/ contains=NONE
syn match BdBefore contained      /<\%(\d\+\|\.\|'[A-Za-z0-9]\)\?/ contains=NONE
syn match BdAfter contained       />\%(\d\+\|\.\|'[A-Za-z0-9]\)\?/ contains=NONE

syn match BEoW contained +\\[<>]+ contains=NONE

syn match Wildcard contained +\%(\\_\)\?\.+ contains=NONE

syn match LastSub contained +\~+ contains=NONE

syn match CharClass contained +\%(\\_\?\)[ikfpIKFPsdxowhalu]+ contains=NONE
syn match NCharClass contained +\%(\\_\?\)[SDXOWHALU]+ contains=NONE

syn region Collection contained
      \ matchgroup=ColEnds start=+\(\\_\)\?\[+
      \ skip=+\\]+
      \ end=+]+
      \ contains=ColRange,SWColExpr,ColExpr
syn match ColRange contained /[^[-]-[^]-]/ contains=ColRangeSep
syn match ColRangeSep contained /[^[-]\@1<=-\ze[^]-]/ contains=NONE
syn region ColExpr contained 
      \ matchgroup=ColExprEnds start=+\[:+
      \ end=+:]\|[^a-z]+
      \ contains=ColExprKeyword,SWColExprKw

syn region NCollection contained
      \ matchgroup=NColEnds start=+\(\\_\)\?\[^+
      \ skip=+\\]+
      \ end=+]+
      \ contains=NColRange,SWColExpr,NColExpr
syn match NColRange contained /[^[-]-[^]-]/ contains=NColRangeSep
syn match NColRangeSep contained /[^[-]\@1<=-\ze[^]-]/ contains=NONE
syn region NColExpr contained 
      \ matchgroup=NColExprEnds start=+\[:+
      \ end=+:]\|[^a-z]+
      \ contains=ColExprKeyword,SWColExprKw
syn match SWColExpr contained /:\w\+:/ contains=ColExprKeyword
syn match SWColExprKw contained /\w\+/

syn cluster Flags contains=Engine,Magic,NoMagic,VeryMagic,VeryNoMagic
syn cluster Bounds contains=
      \Boundary,BoL,EoL,BoF,EoF,BEoW,SoM,EoM,
      \BdVis,BdCur,BdMark,BdLine,BdCol,BdVCol
syn cluster Atoms contains=Atom,LastSub,Wildcard,Literal,@Bounds,CharClass,NCharClass,Collection,NCollection,NewLine,BackRef
syn cluster Multis contains=Greedy,Lazy
syn cluster Looks contains=LkBehind,NLkBehind,LkAhead,LkHere,NLkHere
syn cluster Groups contains=CapGrp,NCapGrp

syn match MatchOr /\\|/ contained contains=NONE
syn match MatchAnd /\\&/ contained contains=NONE

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
hi def SubstPattern guifg=#eeffff
" hi def BackRef      guifg=#00ffff guibg=#3300aa guisp=#00ffff gui=underdashed

hi def CapGrp       guifg=#ffffee
hi def CapGrpEnds   guifg=#ffaa33 guibg=#662200
hi def CapGrpOr     guifg=#ffaa33 guibg=#662200
hi def BackRef      guifg=#ffaa33 guibg=#662200
hi def NCapGrp      guifg=#ffeeff
hi def NCapGrpEnds  guifg=#f6aaf6 guibg=#551855
hi def NCapGrpOr    guifg=#f6aaf6 guibg=#551855
hi def MatchOr      guifg=#ffff30                             gui=bold
hi def MatchAnd     guifg=#ffff30                             gui=bold
hi def NewLine      guifg=#ffdd33 guibg=#8833dd
hi def Look         guifg=#ff33bb
hi def link LkBehind Look
hi def link NLkBehind Look
hi def link LkAhead Look
hi def link LkHere Look
hi def link NLkHere Look
hi def LkCount      guifg=#ccaaff gui=italic
hi def LkWhere      guifg=#ccaaff gui=italic

hi def SynErr       guifg=#ffffff guibg=#ff0000
hi def SynUnknown                               guisp=#ffff66 gui=undercurl 
hi def link SynWarn SynUnknown
hi def link SWColExpr SynWarn
hi def link SWColExprKw SynWarn
hi def Greedy       guifg=#00ffff
hi def Lazy         guifg=#ff00ff
hi def Escaped      guifg=#12cd4d
hi def Literal      guifg=#88eead
hi def Atom         guifg=#9999ff
hi def Boundary     guifg=#c248fe
hi def link BoP Boundary
hi def link BoL Boundary
hi def link EoL Boundary
hi def link EoP Boundary
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
hi def BdBefore     guifg=#bb1111
hi def BdAfter      guifg=#228822
hi def BdAt         guifg=#999922
hi def Mark         guifg=#229999
hi def CharClass    guifg=#7799ff
hi def ColRange     guifg=#88aaff guibg=NONE guisp=#5583ff gui=underline
hi def ColRangeSep  guifg=#7799ff guibg=NONE guisp=#5583ff gui=underline
hi def ColEnds      guifg=#5583ff guibg=NONE
hi def link Collection CharClass
hi def link ColRangeSep ColEnds
hi def ColExprEnds  guifg=#88aaff
hi def link ColExpr ColRange
hi def NCharClass   guifg=#fe7676
hi def NColRange    guifg=#fe7676 guibg=NONE guisp=#ff3f3f gui=underline
hi def NColRangeSep guifg=#fea6a6 guibg=NONE guisp=#ff3f3f gui=underline
hi def NColEnds     guifg=#ff3f3f guibg=NONE
hi def link NCollection NCharClass
hi def link NColRangeSep NColEnds
hi def NColExprEnds guifg=#fea6a6
hi def link NColExpr NColRange

hi def link Wildcard CharClass
hi def link LastSub CharClass

let b:current_syntax = "reg"

let &cpo = s:cpo_save
unlet s:cpo_save
