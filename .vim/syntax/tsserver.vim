
"
" Syntax for tsserver errors
"
" :au BufWritePost <buffer> syn on
"
" Related:
"


let s:cpo_save = &cpo
set cpo&vim


syn match tssUnion / | / contained contains=NONE
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
syn region tssObjectType contained
      \ matchgroup=typescriptBraces start=+{+
      \ end=+}+
      \ contains=tssStrLitType,tssArrayType,tssObjectType,tssUnion,tssUnAbrv,tssReadonly,tssAbrv
" ...of type '...
syn region tssCiteType keepend
      \ start=+\%([Tt]ype \)\@5<='+
      \ end=+'+
      \ contains=tssStrLitType,tssArrayType,tssObjectType,tssUnion,tssUnAbrv,tssReadonly,tssAbrv

" ...of property '...
syn region tssCiteProp keepend
      \ start=+\%([Pp]roperty \)\@5<='+
      \ end=+'+
      \ contains=tssStrLitType,tssUnion,tssUnAbrv

syn match tssAbrv /\[\.\.\.]/ contained contains=NONE

hi tssCiteType guifg=#88aaaa
hi tssCiteProp guifg=#88aaaa
hi link tssStrLitType typescriptStringLiteralType
hi link tssUnion typescriptUnion
hi link tssUnAbrv tssCiteType
hi link tssUnAbrvCount Number
hi link tssUnAbrvEllip Conceal
hi link tssAbrv Conceal
hi link tssReadonly typescriptReadonlyArrayKeyword 

let b:current_syntax = "tsserver"

let &cpo = s:cpo_save
unlet s:cpo_save

