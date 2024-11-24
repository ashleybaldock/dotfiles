if exists("b:current_syntax")
  finish
endif

"
" au BufWritePost <buffer> syn on
"

let s:cpo_save = &cpo
set cpo&vim

syn match TestTrailing contained /[a-z]\+/
syn match TestL1Lead contained /[a-z]/
      \ nextgroup=TestL1Region
syn match TestL2Lead contained /[a-z]/
      \ nextgroup=TestL2Region
syn match TestL3Lead contained /[a-z]/
      \ nextgroup=TestL3Region

syn keyword TestKeyLead contained leading
syn keyword TestKeyStart contained start
syn keyword TestKeyEnd contained end
syn keyword TestKeyRegion contained region
syn keyword TestKeyTrail contained trailing

syn region TestKey 
      \ matchgroup=TestInd
      \ start="Key)"
      \ end="$"
      \ oneline
      \ transparent
      \ contains=TestKeyLead,TestKeyStart,TestKeyRegion,TestKeyEnd,TestKeyTrail
syn region TestL1 
      \ matchgroup=TestInd
      \ start="1)"
      \ end="$"
      \ oneline transparent skipwhite
      \ contains=TestL1Lead,TestL1Region,TestInd,TestComment
syn region TestL2 
      \ matchgroup=TestInd
      \ start="2)"
      \ end="$"
      \ oneline transparent skipwhite
      \ contains=TestL2Lead,TestL2Region,TestInd,TestComment
syn region TestL3 
      \ matchgroup=TestInd
      \ start="3)"
      \ end="$"
      \ oneline transparent skipwhite
      \ contains=TestL3Lead,TestL3Region,TestInd,TestComment

syn region TestL1Region
      \ matchgroup=TestL1Start start="foo"ms=s-1,rs=s,he=e
      \ matchgroup=TestL1End end="bar"
      \ contains=TestMatchStart,TestMatchEnd
      \ nextgroup=TestTrailing

syn region TestL2Region
      \ matchgroup=TestL2Start start="foo"hs=s+2,rs=e+2 
      \ matchgroup=TestL2End end="bar"me=e-1,he=e-1,re=s-1
      \ contains=TestMatchStart,TestMatchEnd
      \ nextgroup=TestTrailing

syn region TestL3Region
      \ matchgroup=TestL3Start start="foo"hs=s+2,rs=e+2 
      \ matchgroup=TestL3End end="bar"me=e-1,he=e-1,re=s-1
      \ contains=TestRegion,TestMatchStart,TestMatchEnd
      \ nextgroup=TestTrailing

syn match TestMatchStart contained +foo+
syn match TestMatchEnd contained +bar+

syn match TestRegion contained /./

syn match TestComment +//.*$+

hi def TestL1Start guifg=#dd2222
hi def TestL1End guifg=#00dd00
hi def TestL1Region guifg=#2288dd
hi def TestL2Start guifg=#dd2222
hi def TestL2End guifg=#00dd00
hi def TestL2Region guifg=#2288dd

" hi def TestL2Start guibg=#770000
" hi def TestL2End guibg=#007700
" hi def TestL2Region guibg=#000077

hi def TestL3Start guibg=#770000
hi def TestL3End guibg=#007700
hi def TestL3Region guibg=#000077

hi def TestRegion guisp=#ffff00 gui=underline
hi def TestTrailing guifg=#00ffff guisp=#00ffff gui=undercurl
hi def TestLeading guifg=#ff00ff guisp=#ff00ff gui=underline
hi def TestMatchStart guibg=#ff00ff
hi def TestMatchEnd guibg=#00ffff
hi def link TestL1Lead TestLeading
hi def link TestL2Lead TestLeading
hi def link TestL3Lead TestLeading

hi def TestInd guifg=#ffaa22
hi def link TestComment Comment

hi def link TestKeyLead TestLeading 
hi def link TestKeyStart TestL2Start 
hi def link TestKeyEnd TestL2End 
hi def link TestKeyRegion TestL2Region 
hi def link TestKeyTrail TestTrailing 

let b:current_syntax = "vimmessages"

let &cpo = s:cpo_save
unlet s:cpo_save
