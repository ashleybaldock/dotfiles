
syn region cssUrlSvgDQ
      \ start=^"data:image/svg+xml,^
      \ end=+"+
      \ contained
      \ containedin=cssStringQ,cssStringQQ
      \ contains=cssUrlHeader,cssPerEnc,cssUrlSvgTag,cssUrlSvgTagBracket,cssUrlSvgEndTag
syn region cssUrlSvgPQ
      \ concealends
      \ cchar=<
      \ start=^\zs%22\zedata:image/svg+xml,^
      \ cchar=>
      \ end=+%22+
      \ contained
      \ containedin=cssStringQ,cssStringQQ
      \ contains=cssUrlHeader,cssPerEnc,cssUrlSvgTag,cssUrlSvgTagBracket,cssUrlSvgEndTag
syn region cssUrlSvgSQ
      \ start=^\zs'\zedata:image/svg+xml,^
      \ end=+'+
      \ contained
      \ containedin=cssStringQ,cssStringQQ
      \ contains=cssUrlHeader,cssPerEnc,cssUrlSvgTag,cssUrlSvgTagBracket,cssUrlSvgEndTag

syn region cssUrlHeader
      \ start=+\zedata:+
      \ end=+,+
      \ keepend
      \ contained
      \ contains=cssUrlScheme,cssUrlMediaType,cssUrlBase64,cssUrlSeps

syn match cssUrlScheme +data:+ contained contains=NONE
syn match cssUrlMediaType /data:\zs[^,]\+\ze\(;base64,\|,\)/ contained contains=NONE
syn match cssUrlBase64 /;\zsbase64\ze,/ contained contains=NONE
syn match cssUrlSeps /[:;,]/ contained display contains=NONE

hi def cssUrlHeader guifg=#999900
hi def cssUrlScheme guifg=#0044cc
hi def cssUrlMediaType guifg=#0066aa
hi def cssUrlBase64 guifg=#aa0033
hi def cssUrlSeps guifg=#ddcc44

hi def cssLineContinues guifg=#0022aa
hi def cssUrlSvgTag guifg=#1199ff
hi def cssUrlSvgEndTag guifg=#1199ff

hi def link cssUrlSvgTagName Function

hi def link cssUrlSvgAttrib Type
hi def link cssUrlSvgValueDQ cssUrlSvgValue
hi def link cssUrlSvgValueEQ cssUrlSvgValue
hi def link cssUrlSvgValueSQ cssUrlSvgValue
hi def link cssUrlSvgValue String 

hi def link cssPer22 cssPerEnc
hi def link cssPer23 cssPerEnc
hi def link cssPer3C cssPerEnc
hi def link cssPer3E cssPerEnc
hi def link cssPerEnc Conceal


syn region cssUrlSvgTag
      \ start=+\zs%3[cC]\ze[a-zA-Z]\++
      \ end=+%3[eE]+
      \ matchgroup=NONE
      \ contained
      \ keepend
      \ contains=cssUrlSvgTag,cssUrlSvgTagName,cssUrlSvgAttrib,cssUrlSvgValue,cssUrlSvgEndTag

syn region cssUrlSvgEndTag
      \ start=+\zs%3[cC]\ze/[a-zA-Z]\++
      \ end=+%3[eE]+
      \ matchgroup=NONE
      \ contained
      \ keepend

" syn match cssUrlSvgTagName
"     \ /\(%3[cC]\/\|%3[cC]\)\zs[a-zA-Z:_][-.0-9a-zA-Z:_]*\ze\(\s\|%3[eE]\)/
"     \ contains=NONE
"     \ contained

syn match cssUrlSvgAttrib
    \ +\s\zs\<[a-zA-Z:_][-.0-9a-zA-Z:_]*\>\ze=%22+
    \ contains=NONE
    \ contained
    \ containedin=cssUrlSvg

syn region cssUrlSvgValueDQ
      \ matchgroup=cssUrlSvgValueEnd
      \ start=+=\zs"+
      \ end=+"+
      \ contained keepend
syn region cssUrlSvgValueEQ
      \ matchgroup=cssUrlSvgValueEnd
      \ start=+=\zs%22+
      \ end=+%22+
      \ contained keepend
syn region cssUrlSvgValueSQ
      \ matchgroup=cssUrlSvgValueEnd
      \ start=+='+
      \ end=+'+
      \ contained keepend


syn match cssLineContinues /\\$/
      \ contained contains=NONE
      \ containedin=cssStringQ,cssStringQQ,cssUrlSvgTag
      \ conceal cchar=╲

syn match cssPer22 /%22/
      \ contained contains=NONE
      \ containedin=cssStringQ,cssStringQQ,cssUrlSvgTag
      \ conceal cchar="
syn match cssPer23 /%23/
      \ contained contains=NONE
      \ containedin=cssStringQ,cssStringQQ,cssUrlSvgTag
      \ conceal cchar=#
syn match cssPer3C /%3[cC]/
      \ contained contains=NONE
      \ containedin=cssUrlSvgTag,cssUrlSvgEndTag
      \ conceal cchar=<
syn match cssPer3E /%3[eE]/
      \ contained contains=NONE
      \ containedin=cssUrlSvgTag,cssUrlSvgEndTag
      \ conceal cchar=>


