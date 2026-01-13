"
" Formatting for custom qf display
"
" ! Replaces runtime syntax file
"
" au BufWritePost <buffer> syn on
"
" See Also: $VIMRUNTIME/syntax/qf.vim
"           ../ftplugin/qf.vim
"
" Quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

syn match qfFileName /^[^│]*/
      \ nextgroup=qfSeparator1
syn match qfSeparator1 /│/ contained
      \ nextgroup=qfLineNr
syn match qfLineNr /[^│]*/ contained
      \ contains=@qfType
      \ nextgroup=qfSeparator2
syn match qfSeparator2 /│/ contained
      \ nextgroup=qfText
syn match qfText /.*/ contained

syn match qfError  /error/  contained
syn cluster qfType contains=qfError

" syn match qfSameFile /^\([^│]*\).*\n\zs\1\ze/

" The default highlighting.
hi def link qfFileName  Directory
hi def link qfLineNr  LineNr
hi def link qfSeparator1 Delimiter
hi def link qfSeparator2 Delimiter
hi def link qfText  Normal

hi def link qfError  Error

" hi def qfSameFile guifg=#880088

let b:current_syntax = "qf"
