if exists("b:current_syntax")
  finish
endif

"
" au BufWritePost <buffer> syn on
"

let s:cpo_save = &cpo
set cpo&vim

syn match TestSpc contained +\s*+
syn match TestTrail contained /[a-z]\+/
syn match TestL1Lead contained /[a-z]/
      \ nextgroup=TestL1Region
syn match TestL2Lead contained /[a-z]/
      \ nextgroup=TestL2Region
syn match TestL3Lead contained /[a-z]/
      \ nextgroup=TestL3Region
syn match TestL4Lead contained /[a-z]/
      \ nextgroup=cssFunctionNameVar

syn keyword TestKeyLead contained leading
syn keyword TestKeyStart contained start
syn keyword TestKeyEnd contained end
syn keyword TestKeyRegion contained region
syn keyword TestKeyTrail contained trailing

syn keyword TestKeyMatchStart contained start
syn keyword TestKeyMatchEnd contained end

syn region TestKey 
      \ matchgroup=TestInd
      \ start="Key)"
      \ end="$"
      \ oneline
      \ transparent
      \ contains=TestKeyLead,TestKeyStart,TestKeyRegion,TestKeyEnd,TestKeyTrail
syn region TestKeyMatch
      \ matchgroup=TestInd
      \ start="Match)"
      \ end="$"
      \ oneline
      \ transparent
      \ contains=TestKeyMatchStart,TestKeyMatchEnd
syn region TestKeyContained
      \ matchgroup=TestInd
      \ start="Contained)"
      \ end="$"
      \ oneline
      \ transparent
      \ contains=TestContainedFoo,TestContainedSome,TestContainedBar
syn region TestL1 
      \ matchgroup=TestInd
      \ start="1)"
      \ end="$"
      \ oneline keepend
      \ contains=TestL1Lead,TestL1Region,TestInd,TestComment,TestSpc
syn region TestL2 
      \ matchgroup=TestInd
      \ start="2)"
      \ end="$"
      \ oneline keepend
      \ contains=TestL2Lead,TestL2Region,TestInd,TestComment,TestSpc
syn region TestL3 
      \ matchgroup=TestInd
      \ start="3)"
      \ end="$"
      \ oneline keepend
      \ contains=TestL3Lead,TestL3Region,TestInd,TestComment,TestSpc
syn region TestL4 oneline keepend
      \ matchgroup=TestInd start="4)"
      \ end="$"
      \ contains=cssCustomProp,cssFunctionNameVar,TestVarRegion,TestInd,TestComment,TestColon

syn region TestL1Region
      \ matchgroup=TestL1Start start="foo"
      \ matchgroup=TestL1End end="bar"
      \ contains=TestContainedFoo,TestContainedBar,TestContainedSome,TestMatchStart,TestMatchEnd
      \ nextgroup=TestTrail
      \ contained
" ms=s-1,rs=s,hs=s+2

syn region TestL2Region
      \ matchgroup=TestL2Start start="foo"hs=s+2,rs=e+2 
      \ matchgroup=TestL2End end="bar"me=e-1,he=e-1,re=s-1
      \ contains=TestContainedFoo,TestContainedBar,TestContainedSome,TestMatchStart,TestMatchEnd
      \ nextgroup=TestTrail
      \ contained

syn region TestL3Region
      \ matchgroup=TestL3Start start="foo\@3<="rs=s-1,ms=s-1
      \ matchgroup=TestL3End end="bar"
      \ contains=TestContainedFoo,TestContainedBar,TestContainedSome,TestMatchStart,TestMatchEnd
      \ nextgroup=TestTrail
      \ contained

      " \ matchgroup=TestStart start="\<var\ze("hs=s,rs=e,ms=s
      " \ matchgroup=TestVarParen end=")"me=e,he=e,re=s
syn region TestVarRegion
      \ matchgroup=Conceal start="(" end=")"
      \ contains=cssCustomPropRef,cssFunctionNameVar,TestComma
      \ nextgroup=TestTrail
      \ contained

syn keyword cssFunctionNameVar contained conceal cchar=𐐏 var nextgroup=TestVarRegion
syn match cssCustomPropDashes /--/ contained contains=NONE transparent conceal cchar=╌
syn match cssCustomProp contained "--\%([a-zA-Z0-9-_]\|[^\x00-\x7F]\)*\Z" contains=cssCustomPropDashes
syn match cssCustomPropRefDashes /--/ contained contains=NONE transparent conceal
syn match cssCustomPropRef contained "--\%([a-zA-Z0-9-_]\|[^\x00-\x7F]\)*\Z" contains=cssCustomPropRefDashes
hi def link cssCustomPropRef cssCustomProp
" syn match TestVarParen /var\@<=(/ contained
" syn match TestVarParen /(/ contained
syn match TestComma /,/ contained
syn match TestColon /:/ contained

syn match TestRegion contained /./

syn match TestComment +//.*$+

syn match TestContainedFoo /foo/ contained
syn match TestContainedSome /some/ contained
syn match TestContainedBar /bar/ contained

hi def TestStart guifg=#dd2222
hi def TestEnd guifg=#00dd00
hi def TestVarParen guifg=#dddd22
hi def TestComma guifg=#dddd22
hi def TestRegion guifg=#2288dd
hi def link TestL1Start TestStart
hi def link TestL1End TestEnd
hi def link TestL1Region TestRegion
hi def link TestL2Start TestStart
hi def link TestL2End TestEnd
hi def link TestL2Region TestRegion
hi def link TestL3Start TestStart
hi def link TestL3End TestEnd
hi def link TestL3Region TestRegion
hi def link TestVarRegion TestRegion

hi def TestString guifg=#999999
hi def link TestL1 TestString
hi def link TestL2 TestString
hi def link TestL3 TestString
hi def TestRegion guisp=#ffff00 gui=underline
hi def TestTrail guifg=#00ffff guisp=#00ffff gui=underdashed
hi def TestLead guifg=#ff00ff guisp=#ff00ff gui=underdashed
hi def TestMatchStart guisp=#ff00ff gui=underline
hi def TestMatchEnd guisp=#00ffff gui=underline
hi def link TestL1Lead TestLead
hi def link TestL2Lead TestLead
hi def link TestL3Lead TestLead
hi def TestContainedMatch guibg=#ccff99 guifg=#330000
hi def link TestContainedBar TestContainedMatch
hi def link TestContainedSome TestContainedMatch
hi def link TestContainedFoo TestContainedMatch

hi def TestInd guifg=#ffaa22
hi def link TestComment Comment

hi def link TestKeyLead TestLead 
hi def link TestKeyStart TestL2Start 
hi def link TestKeyEnd TestL2End 
hi def link TestKeyRegion TestL2Region 
hi def link TestKeyTrail TestTrail 
hi def link TestKeyMatchStart TestMatchStart 
hi def link TestKeyMatchEnd TestMatchEnd 

let b:current_syntax = "vimmessages"

let &cpo = s:cpo_save
unlet s:cpo_save

call clearmatches()
silent call matchadd('TestMatchStart', 'abc\zsfoo')
silent call matchadd('TestMatchEnd', 'string\zsbar')

call prop_clear(1, line('$'))
silent call prop_type_delete('testloc')
silent call prop_type_add('testloc', {'highlight':'TestInd'})
call prop_add(11, 0, {
      \ 'type': 'testloc',
      \ 'text': '−️₃️₂️₁️|₁️₂️₃️+️',
      \ 'text_align': 'below',
      \ 'text_padding_left': 2,
      \ })
