
"
" Syntax for tsserver errors
"
" :au BufWritePost <buffer> syn on
"
" Related:
"


let s:cpo_save = &cpo
set cpo&vim


syn match tssHideSpace / / contained contains=NONE conceal
syn match tssNoise /[:;,]/ contained contains=NONE
syn match tssSemi /;/ contained contains=NONE
syn match tssColon /:/ contained contains=NONE
syn match tssUnion / \?| \?/ contained contains=tssHideSpace
syn match tssReadonly /[Rr]eadonly/ contained contains=NONE
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
syn region tssArrayType contained
      \ matchgroup=typescriptBraces start=+\[+
      \ end=+]+
      \ contains=tssStrLitType,tssArrayType,tssObjectType,tssUnion,tssUnAbrv,tssReadonly,tssAbrv
syn match tssTypeBracket /\[]/ contained contains=NONE

syn region tssObjectType contained
      \ matchgroup=typescriptBraces start=+{+
      \ end=+}+
      \ contains=tssColon,tssSemi,tssNoise,tssPreDefType,tssStrLitType,tssArrayType,tssObjectType,tssUnion,tssUnAbrv,tssReadonly,tssAbrv
" ...of type '...
syn region tssCiteType keepend
      \ matchgroup=Conceal
      \ start=+\%([Tt]ype \)\@5<='+
      \ start=+\%(Did you mean \)\@13<='+
      \ start=+\%(to \)\@13<='+
      \ end=+'+
      \ concealends
      \ contains=tssPreDefType,tssStrLitType,tssTypeBracket,tssArrayType,tssObjectType,tssUnion,tssUnAbrv,tssReadonly,tssAbrv

" ...of property '...
syn region tssCiteProp keepend
      \ matchgroup=Conceal
      \ start=+\%([Pp]roperty \)\@9<='+
      \ end=+'+
      \ concealends
      \ contains=tssStrLitType,tssUnion,tssUnAbrv

syn match tssAbrv /\[\.\.\.]/ contained contains=NONE
syn match tssReadonly /'readonly'/ contains=NONE

hi link tssCiteType typescriptTypeReference

hi link tssTypeBracket typescriptTypeBracket
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

let b:current_syntax = "tsserver"

let &cpo = s:cpo_save
unlet s:cpo_save

