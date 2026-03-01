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

let s:s1l1 = char#base(get(g:, 'mayhem_qf_sep1_firstline', '⎫'))
let s:s1lm = char#base(get(g:, 'mayhem_qf_sep1_midline',   '⎪'))
let s:s1le = char#base(get(g:, 'mayhem_qf_sep1_lastline',  '⎩'))
let s:s1lo = char#base(get(g:, 'mayhem_qf_sep1_oneline',   'ʅ️'))

let s:s2l1 = char#base(get(g:, 'mayhem_qf_sep2_firstline', ':️'))
let s:s2lm = char#base(get(g:, 'mayhem_qf_sep2_midline',   '·️'))
let s:s2le = char#base(get(g:, 'mayhem_qf_sep2_lastline',  '_'))
let s:s2lo = char#base(get(g:, 'mayhem_qf_sep2_oneline',   '_'))

" │ʅ️⎫⎧⎪⎩╭╰╮╯

exec 'syn match qfFileName'
      \ '/[^' .. s:s1l1 .. s:s1lo .. ']*/'
      \ 'contained contains=@qfFileType nextgroup=qfSep1 skipwhite'

exec 'syn match qfSep1'
      \ '/[' .. s:s1l1 .. s:s1lm ']/'
      \ 'contained nextgroup=qfLineNr skipwhite'

exec 'syn match qfSep1Last'
      \ '/[' .. s:s1le .. s:s1lo .. ']/'
      \ 'contained nextgroup=qfLineNrLast skipwhite'

exec 'syn match qfLineNr'
      \ '/[^' .. s:s1lm .. ']*/'
      \ 'contained contains=@qfType nextgroup=qfSep2 skipwhite'

exec 'syn match qfLineNrLast'
      \ '/[^' .. s:s1lm .. ']*/'
      \ 'contained contains=@qfType nextgroup=qfSep2Last skipwhite'

exec 'syn match qfSep2'
      \ '/' .. s:s2l1 .. s:s2lm .. '/'
      \ 'contained'

exec 'syn match qfSep2Last'
      \ '/' .. s:s2le .. s:s2lo .. '/'
      \ 'contained'

exec 'syn region qfFirstLine oneline contains=qfFileName'
      \ 'start=/^\s*\ze\%([^' .. s:s1l1 .. ']*' .. s:s1l1 .. '\)\@>/'
      \ 'end=/' .. s:s2l1 .. '/'
      \ 'nextgroup=qfResult skipwhite'

exec 'syn region qfMidLine oneline contains=qfSep1Last'
      \ 'start=/^\ze\s*' .. s:s1lm .. '/'
      \ 'end=/' .. s:s2lm  .. '/'
      \ 'nextgroup=qfResult skipwhite'

exec 'syn region qfLastLine oneline contains=qfSep1Last'
      \ 'start=/^\ze\s*' .. s:s1le .. '/'
      \ 'end=/' .. s:s2le .. '/'
      \ 'nextgroup=qfResultLast skipwhite'

exec 'syn region qfOnlyLine oneline contains=qfFileName'
      \ 'start=/^\ze\s*\%([^' .. s:s1lo .. ']*' .. s:s1lo .. '\)\@>/'
      \ 'end=/' .. s:s2lo .. '/'
      \ 'nextgroup=qfResultLast skipwhite'

syn match qfResult     /.*/ contained nextgroup=qfMidLine,qfLastLine skipnl
syn match qfResultLast /.*/ contained nextgroup=qfFirstLine,qfOnlyLine skipnl

syn match qfError  /error/  contained
syn cluster qfLine contains=qfFileName
syn cluster qfType contains=qfError

syn match qfFtJS /\S*\.[a-z]\?js\>/ contained contains=NONE
syn match qfFtJSX /\S*\.jsx\>/ contained contains=NONE
syn match qfFtTS /\S*\.[a-z]\?ts\>/ contained contains=NONE
syn match qfFtTSX /\S*\.tsx\>/ contained contains=NONE
syn match qfFtCSS /\S*\.css\>/ contained contains=NONE
syn match qfFtJSON /\S*\.json\>/ contained contains=NONE
syn match qfFtHTML /\S*\.html\>/ contained contains=NONE
syn match qfFtSVG /\S*\.svg\>/ contained contains=NONE
syn match qfFtSVG /\S*\.svg\>/ contained contains=NONE
syn match qfFtPY /\S*\.py\>/ contained contains=NONE
syn match qfFtVIM /\S*\.vim\>/ contained contains=NONE
syn match qfFtSH /\S*\.sh\>/ contained contains=NONE
syn match qfFtTXT /\S*\.txt\>/ contained contains=NONE
syn match qfFtMD /\S*\.md\>/ contained contains=NONE

hi def qfFtJS guibg=#330033
hi def qfFtJSX guibg=#330033
hi def qfFtTS guibg=#330033
hi def qfFtTSX guibg=#330033
hi def qfFtCSS guibg=#330033
hi def qfFtJSON guibg=#443300
hi def qfFtHTML guibg=#220066
hi def qfFtSVG guibg=#330033
hi def qfFtPY guibg=#330033
hi def qfFtVIM guibg=#112200
hi def qfFtSH guibg=#330033
hi def qfFtTXT guibg=#330033
hi def qfFtMD guibg=#330033

syn cluster qfFileType contains=
      \qfFtJS,qfFtJSX,qfFtTS,qfFtTSX,qfFtCSS,qfFtJSON,qfFtHTML,qfFtSVG,
      \qfFtSVG,qfFtPY,qfFtVIM,qfFtSH,qfFtTXT,qfFtMD

" syn match qfSameFile /^\([^│]*\).*\n\zs\1\ze/

" The default highlighting.
hi qfFileName   guifg=#ffcc00
hi qfLineNr     guifg=ynumabf  guibg=ynumabb guisp=ynumbrf  gui=underdashed 
hi qfFirstLine  guifg=NONE     guisp=#33aa00  gui=none 
hi qfMidLine    guifg=NONE     guisp=#33aa00  gui=none 
hi qfLastLine   guifg=NONE     guisp=#33aa00  gui=underdashed 
hi qfOnlyLine   guifg=NONE     guisp=#00aaaa  gui=underdashed 
hi qfSeparator1 guifg=#33aa00
hi qfSeparator2 guifg=#33aa33
hi qfResult     guifg=ywnormf  guibg=#ff00ff
hi qfResultLast guifg=ywnormf  guisp=#33aa00  gui=underline 

hi def link qfError  Error

" hi def qfSameFile guifg=#880088

let b:current_syntax = "qf"
