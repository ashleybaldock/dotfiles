" Syntax for vim :messages
"

if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn match vimmsgError '^\(Error\|E\d\+\).*'

syn match vimmsgLineNr '^line\s\+\d\+.*$'

syn match vimmsgWrite '^.*written$'


hi def vimmsgLineNr guibg=NONE guifg=#dddd00
hi def vimmsgError guifg=#dd0000
hi def vimmsgWrite guifg=#00bb33

let b:current_syntax = "vimmessages"

let &cpo = s:cpo_save
unlet s:cpo_save
