"
" Formatting for custom qf display
"
" ! Replaces runtime syntax file
"
" au BufWritePost <buffer> syn on
"
" See Also: $VIMRUNTIME/syntax/qf.vim
"           ../plugin/quickfix.vim
"           ../ftplugin/qf.vim
"
" Quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

let s:s1_1 = get(g:, 'mayhem_qf_sep1_firstline', '⎫')
let s:s1_m = get(g:, 'mayhem_qf_sep1_midline',   '⎪')
let s:s1_e = get(g:, 'mayhem_qf_sep1_lastline',  '⎩')
let s:s1_o = get(g:, 'mayhem_qf_sep1_oneline',   'ʅ️')

let s:b_s1_1 = char#base(s:s1_1)
let s:b_s1_m = char#base(s:s1_m)
let s:b_s1_e = char#base(s:s1_e)
let s:b_s1_o = char#base(s:s1_o)

let s:s2_1 = get(g:, 'mayhem_qf_sep2_firstline', '|̅')
let s:s2_m = get(g:, 'mayhem_qf_sep2_midline',   '|')
let s:s2_e = get(g:, 'mayhem_qf_sep2_lastline',  '|̲')
let s:s2_o = get(g:, 'mayhem_qf_sep2_oneline',   '_')

let s:b_s2_1 = char#base(s:s2_1)
let s:b_s2_m = char#base(s:s2_m)
let s:b_s2_e = char#base(s:s2_e)
let s:b_s2_o = char#base(s:s2_o)


syn match qfResult     /.*/ contained nextgroup=qfFirstLine,qfMidLine skipnl
syn match qfResultLast /.*/ contained nextgroup=qfLastLine,qfOnlyLine skipnl

syn match qfError  /error/  contained
syn cluster qfType contains=qfError


exec 'syn match qfFileName'
      \ '/\S\{-}\ze\%(' .. s:s1_1 .. '\|' .. s:s1_m .. '\)\@>/'
      \ 'contained contains=@qfFileType nextgroup=qfSep1 skipwhite'

exec 'syn match qfSep1'
      \ '/' .. s:s1_1 .. '\|' .. s:s1_m .. '/'
      \ 'contained nextgroup=qfLineNr skipwhite'

exec 'syn match qfLineNr'
      \ '/\S\{-}\ze\s\%(' .. s:s2_1 .. '\|' .. s:s2_m .. '\)/'
      \ 'contained contains=@qfType nextgroup=qfSep2 skipwhite'

exec 'syn match qfSep2 contained contains=NONE'
      \ '/' .. s:s2_1 .. '\|' .. s:s2_m .. '/'

exec 'syn match qfSep1Last contained contains=NONE'
      \ '/' .. s:s1_e .. '\|' .. s:s1_o .. '/'
      \ 'nextgroup=qfLineNrLast skipwhite'

exec 'syn match qfLineNrLast'
      \ '/\S\{-}\ze\s\%(' .. s:s2_e .. '\|' .. s:s2_o .. '\)/'
      \ 'contained contains=@qfType nextgroup=qfSep2Last skipwhite'

exec 'syn match qfSep2Last contained contains=NONE'
      \ '/' .. s:s2_e .. '\|' .. s:s2_o .. '/'
      \ 'nextgroup=qfResultLast skipwhite'

exec 'syn region qfFirstLine oneline contains=qfFileName'
      \ 'start=/^\s*\ze.\{-}' .. s:s1_1 .. '/'
      \ 'matchgroup=qfSep2 end=/\ze' .. s:s2_1 .. '/'
      \ 'nextgroup=qfResult skipwhite keepend'

exec 'syn region qfOnlyLine oneline contains=qfFileName'
      \ 'start=/^\s*\ze.\{-}' .. s:s1_o .. '/'
      \ 'matchgroup=qfSep2 end=/' .. s:s2_o .. '/'
      \ 'nextgroup=qfResultLast skipwhite keepend'

exec 'syn region qfMidLine oneline contains=qfSep1'
      \ 'start=/^\s*\ze' .. s:s1_m .. '/'
      \ 'matchgroup=qfSep2 end=/' .. s:s2_m  .. '/'
      \ 'nextgroup=qfResult skipwhite keepend'

exec 'syn region qfLastLine oneline contains=qfSep1Last'
      \ 'start=/^\s*\ze' .. s:s1_e .. '/'
      \ 'matchgroup=qfSep2 end=/' .. s:s2_e .. '/'
      \ 'nextgroup=qfResultLast skipwhite keepend'

" exec 'syn match qfFirstLine /^.*\%(' .. s:s1_1 .. '\).*$/ contains=qfFileName nextgroup=qfResult skipwhite'

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
hi qfLineNr     guifg=ynumabf  guibg=ynumabb guisp=ynumbrf  gui=italic 
hi qfLineNrLast guifg=ynumabf  guibg=ynumabb guisp=#33aa00  gui=italic 
hi qfFirstLine  guifg=NONE     guisp=#115511  gui=none 
hi qfMidLine    guifg=NONE     guisp=#115511  gui=none 
hi qfLastLine   guifg=NONE     guisp=#115511  gui=underline 
hi qfOnlyLine   guifg=NONE     guisp=#115511  gui=underline 
hi qfSep1       guifg=#33aa00
hi qfSep1Last   guifg=#33aa00
hi qfSep2       guifg=#33aa00
hi qfSep2Last   guifg=#33aa00
hi qfResult     guifg=ywnormf
hi qfResultLast guifg=ywnormf

hi def link qfError  Error

" hi def qfSameFile guifg=#880088

let b:current_syntax = "qf"
