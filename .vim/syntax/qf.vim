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

let s:b_l1 = get(g:, 'mayhem_qf_bracket_firstline', '⎫')
let s:b_lm = get(g:, 'mayhem_qf_bracket_midline',   '⎪')
let s:b_le = get(g:, 'mayhem_qf_bracket_lastline',  '⎩')
let s:b_lo = get(g:, 'mayhem_qf_bracket_oneline',   'ʅ️')

" │ʅ️⎫⎧⎪⎩╭╰╮╯

exec 'syn match qfFileName'
      \ '/^[^' .. s:b_l1 .. s:b_lm .. s:b_le .. s:b_lo .. ']*/'
      \ 'nextgroup=qfSeparator1'
exec 'syn match qfSeparator1'
      \ '/[' .. s:b_l1 .. s:b_lm .. s:b_le .. s:b_lo .. ']/'
      \ 'contained nextgroup=qfLineNr'
exec 'syn match qfLineNr'
      \ '/[^' .. s:b_lm .. ']*/'
      \ 'contained contains=@qfType nextgroup=qfSeparator2'
exec 'syn match qfSeparator2'
      \ '/' .. s:b_lm .. '/'
      \ 'contained nextgroup=qfText'

syn match qfText /.*/ contained
exec 'syn region qfFirstLine oneline contains=qfFilename'
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
