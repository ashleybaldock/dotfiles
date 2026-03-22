
"
" Syntax highlighting for tsserver errors
"
" :au BufWritePost <buffer> syn on
"
" Related:
"


let s:cpo_save = &cpo
set cpo&vim



syn keyword tssPreDefType null number undefined any unknown
syn keyword tssReadonly readonly
syn match tssHideSpace / / contained contains=NONE conceal
syn match tssNoise /[:;,]/ contained contains=NONE
syn match tssSemi /;/ contained contains=NONE
syn match tssColon /:/ contained contains=NONE
syn match tssUnion / \?| \?/ contained contains=tssHideSpace
syn match tssUnAbrvCount /\d\+/ contained contains=NONE
syn match tssUnAbrvEllip /\%(\.\.\. \| more \.\.\.\)/ conceal cchar=‥ contained contains=NONE
syn region tssUnAbrv contained keepend
      \ start=/\%(\.\.\.\)\@=/ 
      \ end=/ more \.\.\./
      \ contains=tssUnAbrvCount,tssUnAbrvEllip
syn region tssStrLitType contained
      \ matchgroup=Conceal start=+"+
      \ end=+"+
      \ concealends
      \ contains=NONE
syn match tssTupleBracket /[][]/ contained contains=NONE
syn region tssTupleType contained
      \ matchgroup=typescriptBraces start=+\[+
      \ end=+]+
      \ contains=tssUserType,tssGenericType,tssPreDefType,tssStrLitType,tssTupleType,tssObjectType,tssUnion,tssUnAbrv,tssReadonly,tssAbrv
syn match tssTypeBracket /[<>]/ contained contains=NONE

syn match tssUserType /\%(\h\w*\)\+/ contained contains=NONE

syn region tssGenericType contained keepend extend
      \ start=/\%(\h\w*\)\+</
      \ end=/>/
      \ contains=tssUserType,tssGenericType,tssPreDefType,tssStrLitType,tssTypeBracket,tssTupleType,tssObjectType,tssUnion,tssUnAbrv,tssReadonly,tssAbrv

syn region tssObjectType contained
      \ matchgroup=typescriptBraces start=+{+
      \ end=+}+
      \ contains=tssColon,tssSemi,tssNoise,tssPreDefType,tssStrLitType,tssTupleType,tssObjectType,tssUnion,tssUnAbrv,tssReadonly,tssAbrv

" ...of type '...
syn region tssCiteType keepend
      \ matchgroup=Conceal
      \ start=+\%([Tt]ype \)\@5<='+
      \ start=+\%(Did you mean \)\@13<='+
      \ start=+\%(to \)\@13<='+
      \ start=+\%(Overload \d\+ of \d\+, \)\@<='+
      \ end=+'+
      \ concealends
      \ contains=tssUserType,tssGenericType,tssPreDefType,tssStrLitType,tssTypeBracket,tssTupleType,tssObjectType,tssUnion,tssUnAbrv,tssReadonly,tssAbrv

" ...of property '...
syn region tssCiteProp keepend
      \ matchgroup=Conceal
      \ start=+\%([Pp]roperty \)\@9<='+
      \ end=+'+
      \ concealends
      \ contains=tssStrLitType,tssUnion,tssUnAbrv
" ...returned by '...
syn region tssCiteFunc keepend
      \ matchgroup=Conceal
      \ start=+\%(returned by \)\@12<='+
      \ end=+'+
      \ concealends
      \ contains=tssStrLitType,tssUnion,tssUnAbrv,tssAbrv

syn match tssDot /\./ conceal cchar=․ contained contains=NONE
syn match tssAbrv /(\@1<=\zs\.\.\.\ze)/ contained contains=tssDot
syn match tssAbrv /\[\@1<=\zs\.\.\.\ze]/ contained contains=tssDot
syn match tssAbrv /<\@1<=\zs\.\.\.\ze>/ contained contains=tssDot
syn match tssReadonly /'\@<=readonly\ze'/ contains=NONE

hi link tssCiteType typescriptTypeReference
hi link tssUserType typescriptTypeReference

hi link tssTypeBracket typescriptTypeBracket
hi link tssTupleBracket typescriptTupleType
" hi tssCiteProp guifg=#88aaaa
hi link tssCiteProp typescriptProperty
hi link tssPreDefType typescriptPredefinedType
hi link tssStrLitType typescriptStringLiteralType
hi link tssUnion typescriptUnion
hi link tssMember typescriptMember
hi link tssUnAbrv tssCiteType
hi link tssUnAbrvCount Number
hi link tssUnAbrvEllip Conceal
hi link tssAbrv Conceal
hi link tssReadonly typescriptReadonlyArrayKeyword 

hi WinDiag guifg=#bbbb88 guibg=#1f0505

let b:current_syntax = "tsserver"

let &cpo = s:cpo_save
unlet s:cpo_save


