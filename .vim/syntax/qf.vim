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

let s:s2l1 = s:b_lm
let s:s2lm = s:b_lm
let s:s2le = s:b_lm
let s:s2lo = s:b_lm

" │ʅ️⎫⎧⎪⎩╭╰╮╯

exec 'syn match qfFileName'
      \ '/[^' .. s:b_l1 .. char#base(s:b_lo) .. ']*/'
      \ 'contained nextgroup=qfSeparator1 skipwhite'

exec 'syn match qfSeparator1'
      \ '/[' .. s:b_l1 .. s:b_lm .. s:b_le .. char#base(s:b_lo) .. ']/'
      \ 'contained nextgroup=qfLineNr skipwhite'

exec 'syn match qfLineNr'
      \ '/[^' .. s:b_lm .. ']*/'
      \ 'contained contains=@qfType nextgroup=qfSeparator2 skipwhite'

exec 'syn match qfSeparator2'
      \ '/' .. s:b_lm .. '/'
      \ 'contained'

exec 'syn region qfFirstLine oneline contains=qfFileName'
      \ 'start=/^\s*\ze\%([^' .. s:b_l1 .. ']*' .. s:b_l1 .. '\)\@>/'
      \ 'end=/' .. s:s2l1 .. '/'
      \ 'nextgroup=qfResult skipwhite'

exec 'syn region qfMidLine oneline contains=qfSeparator1'
      \ 'start=/^\ze\s*' .. s:b_lm .. '/'
      \ 'end=/' .. s:s2lm  .. '/'
      \ 'nextgroup=qfResult skipwhite'

exec 'syn region qfLastLine oneline contains=qfSeparator1'
      \ 'start=/^\ze\s*' .. s:b_le .. '/'
      \ 'end=/' .. s:s2le .. '/'
      \ 'nextgroup=qfResultLast skipwhite'

exec 'syn region qfOnlyLine oneline contains=qfFileName'
      \ 'start=/^\ze\s*\%([^' .. char#base(s:b_lo) .. ']*' .. char#base(s:b_lo) .. '\)\@>/'
      \ 'end=/' .. s:s2lo .. '/'
      \ 'nextgroup=qfResultLast skipwhite'

syn match qfResult     /.*/ contained nextgroup=qfMidLine,qfLastLine skipnl
syn match qfResultLast /.*/ contained nextgroup=qfFirstLine,qfOnlyLine skipnl

syn match qfError  /error/  contained
syn cluster qfLine contains=qfFileName
syn cluster qfType contains=qfError

" syn match qfSameFile /^\([^│]*\).*\n\zs\1\ze/

" The default highlighting.
hi clear qfFileName | hi def qfFileName   guifg=#ffcc00
hi def qfLineNr     guifg=ynumbrf  guisp=#33aa00  gui=underline 
hi def qfFirstLine  guifg=NONE     guisp=#33aa00  gui=none 
hi def qfMidLine    guifg=NONE     guisp=#33aa00  gui=none 
hi def qfLastLine   guifg=NONE     guisp=#33aa00  gui=underdashed 
hi def qfOnlyLine   guifg=NONE     guisp=#33aa00  gui=underdotted 
hi def qfSeparator1 guifg=#33aa00
hi def qfSeparator2 guifg=#33aa33
hi def qfResult     guifg=ywnormf  guibg=#ff00ff
hi def qfResultLast guifg=ywnormf  guisp=#33aa00  gui=underline 

hi def link qfError  Error

" hi def qfSameFile guifg=#880088

let b:current_syntax = "qf"
