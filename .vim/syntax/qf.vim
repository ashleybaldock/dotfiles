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

syn match qfFileName /^[^│ʅ️⎫⎧⎪⎩╭╰╮╯]*/
      \ nextgroup=qfSeparator1
syn match qfSeparator1 /[│ʅ️⎫⎧⎪⎩╭╰╮╯]/ contained
      \ nextgroup=qfLineNr
syn match qfLineNr /[^│]*/ contained
      \ contains=@qfType
      \ nextgroup=qfSeparator2
syn match qfSeparator2 /│/ contained
      \ nextgroup=qfText
syn match qfText /.*/ contained

syn region qfFirstLine oneline contains=qfFilename
      \ start='^\zs\ze\s*\S\+[⎫╮]'
      \ end='$'
syn region qfMidLine oneline contains=qfSeparator1
      \ start='^\zs\ze\s*⎪'
      \ end='$'
syn region qfLastLine oneline contains=qfSeparator1
      \ start='^\zs\ze\s*\S\+[⎩╰]'
      \ end='$'
syn region qfOnlyLine oneline contains=qfFilename
      \ start='^\zs\ze\s*\S\+ʅ️'
      \ end='$'

syn match qfError  /error/  contained
syn cluster qfLine contains=qfFileName
syn cluster qfType contains=qfError

" syn match qfSameFile /^\([^│]*\).*\n\zs\1\ze/

" The default highlighting.
hi def qfFileName   guifg=#ffcc00
hi def qfLineNr     guifg=ynumbrf
hi def qfFirstLine  guifg=NONE     guisp=#33aa00  gui=none 
hi def qfMidLine    guifg=NONE     guisp=#33aa00  gui=none 
hi def qfLastLine   guifg=NONE     guisp=#33aa00  gui=underline 
hi def qfOnlyLine   guifg=NONE     guisp=#33aa00  gui=underline 
hi def qfSeparator1 guifg=#33aa00
hi def qfSeparator2 guifg=#33aa00
hi def link qfText  Normal

hi def link qfError  Error

" hi def qfSameFile guifg=#880088

let b:current_syntax = "qf"
