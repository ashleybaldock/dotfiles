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

let s:s1l1 = get(g:, 'mayhem_qf_sep1_firstline', '⎫')
let s:s1lm = get(g:, 'mayhem_qf_sep1_midline',   '⎪')
let s:s1le = get(g:, 'mayhem_qf_sep1_lastline',  '⎩')
let s:s1lo = get(g:, 'mayhem_qf_sep1_oneline',   'ʅ️')

let s:b_s1l1 = char#base(s:s1l1)
let s:b_s1lm = char#base(s:s1lm)
let s:b_s1le = char#base(s:s1le)
let s:b_s1lo = char#base(s:s1lo)

let s:s2l1 = get(g:, 'mayhem_qf_sep2_firstline', ':️')
let s:s2lm = get(g:, 'mayhem_qf_sep2_midline',   '·️')
let s:s2le = get(g:, 'mayhem_qf_sep2_lastline',  '_')
let s:s2lo = get(g:, 'mayhem_qf_sep2_oneline',   '_')

let s:b_s2l1 = char#base(s:s2l1)
let s:b_s2lm = char#base(s:s2lm)
let s:b_s2le = char#base(s:s2le)
let s:b_s2lo = char#base(s:s2lo)


syn match qfResult     /.*/ contained nextgroup=qfFirstLine,qfMidLine skipnl
syn match qfResultLast /.*/ contained nextgroup=qfLastLine,qfOnlyLine skipnl

syn match qfError  /error/  contained
syn cluster qfType contains=qfError


exec 'syn match qfFileName'
      \ '/\S{-}\ze\%(' .. s:s1l1 .. '\|' .. s:s1lm .. '\)\@=/'
      \ 'contained contains=@qfFileType nextgroup=qfSep1 skipwhite'

exec 'syn match qfSep1'
      \ '/' .. s:s2l1 .. '\|' .. s:s2lm .. '/'
      \ 'contained nextgroup=qfLineNr skipwhite'

      " \ '/\%(\%(' .. s:s2l1 .. '\)\@!\|\%(' .. s:s2lm .. '\)\@!\)*/'
exec 'syn match qfLineNr'
      \ '/\S{-}\ze\%(' .. s:s2l1 .. '\|' .. s:s2lm .. '\)\@=/'
      \ 'contained contains=@qfType nextgroup=qfSep2 skipwhite'

exec 'syn match qfSep2'
      \ '/' .. s:s2l1 .. '\|' .. s:s2lm .. '/'
      \ 'contained'

exec 'syn match qfSep1Last'
      \ '/[' .. s:s1le .. s:s1lo .. ']/'
      \ 'contained nextgroup=qfLineNrLast skipwhite'

exec 'syn match qfLineNrLast'
      \ '/\S{-}\ze\%(' .. s:s2le .. '\|' .. s:s2lo .. '\)/'
      \ 'contained contains=@qfType nextgroup=qfSep2Last skipwhite'

exec 'syn match qfSep2Last'
      \ '/' .. s:s2le .. '\|' .. s:s2lo .. '/'
      \ 'contained'

exec 'syn region qfMidLine oneline contains=qfSep1'
      \ 'start=/^\s*\ze' .. s:s1lm .. '/'
      \ 'end=/' .. s:s2lm  .. '/'
      \ 'nextgroup=qfResult skipwhite'

exec 'syn match qfFirstLine /^\s*.{-}\s*\%(' .. s:s1l1 .. '\)\s*.{-}*' .. s:s2l1 .. '/ contains=qfFileName nextgroup=qfResult skipwhite'
" exec 'syn region qfFirstLine oneline contains=qfFileName'
"       \ 'start=/^.{-}\%(' .. s:s1l1 .. '\)\@>/'
"       \ 'end=/' .. s:s2l1 .. '/'
"       \ 'nextgroup=qfResult skipwhite'

exec 'syn region qfLastLine oneline contains=qfSep1Last'
      \ 'start=/^\ze' .. s:s1le .. '/'
      \ 'end=/' .. s:s2le .. '/'
      \ 'nextgroup=qfResultLast skipwhite'

exec 'syn region qfOnlyLine oneline contains=qfFileName'
      \ 'start=/^\s*\ze.\{-}' .. s:s1lo .. '/'
      \ 'end=/' .. s:s2lo .. '/'
      \ 'nextgroup=qfResultLast skipwhite'

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
hi qfLineNrLast guifg=ynumabf  guibg=ynumabb guisp=#33aa00  gui=underdashed 
hi qfFirstLine  guifg=NONE     guisp=#33aa00  gui=none 
hi qfMidLine    guifg=NONE     guisp=#33aa00  gui=none 
hi qfLastLine   guifg=NONE     guisp=#33aa00  gui=underdashed 
hi qfOnlyLine   guifg=NONE     guisp=#33aa00  gui=underdashed 
hi qfSep1       guifg=#33aa00
hi qfSep1Last   guifg=#33aa00
hi qfSep2       guifg=#33aa33
hi qfSep2Last   guifg=#33aa33
hi qfResult     guifg=ywnormf  guibg=#330033
hi qfResultLast guifg=ywnormf  guisp=#33aa00  gui=underline 

hi def link qfError  Error

" hi def qfSameFile guifg=#880088

let b:current_syntax = "qf"
