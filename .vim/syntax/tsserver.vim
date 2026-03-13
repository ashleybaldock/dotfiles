if exists("g:mayhem_loaded_tsserver")
  finish
endif
let g:mayhem_loaded_tsserver = 1

"
" Syntax for tsserver errors
"
" :au BufWritePost <buffer> syn on
"
" Related:
"


let s:cpo_save = &cpo
set cpo&vim


syn region tsErrString
      \ start=+\z("\)+
      \ end=+\z1+
syn region tsErrCiteType
      \ start=+\z('\)+
      \ end=+\z1+

hi tsErrCiteType guifg=#88aaaa
hi link tsErrString String

let b:current_syntax = "tsserver"

let &cpo = s:cpo_save
unlet s:cpo_save

