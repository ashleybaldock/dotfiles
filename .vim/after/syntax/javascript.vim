"
" JavaScript Syntax Extensions
"
" :au BufWritePost <buffer> syn on
"
" Related:
"       $VIMRUNTIME/syntax/javascript.vim


source <script>:p:h/common.vim

syn keyword jsUserKw contained name namespace include exclude version description 
syn keyword jsUserKw contained downloadURL supportURL homepageURL
syn keyword jsUserKw contained grant author icon require resource 
syn keyword jsUserKw contained noframes unwrap
syn match jsUserKw contained /\%(exclude-\)\?match/ contains=NONE
syn match jsUserKw contained /run-at/ contains=NONE
syn match jsUserKw contained /inject-into/ contains=NONE
syn match jsUserKw contained /top-level-await/ contains=NONE
" syn match jsUserKw /grant/ contained contains=NONE extend
"       \ nextgroup=jsUserGrant,jsUserNone skipwhite 

syn keyword jsUserNone contained none
syn match jsUserGrant contained /GM[._]\%(info\|[gs]etValues\?\|deleteValues\?\|listValues\|\%(add\|remove\)ValueChangeListener\|getResource\%(Text\|URL\)\|add\%(Element\|Style\)\|openInTab\|\%(un\)\?registerMenuCommand\|notification\|setClipboard\|xmlhttpRequest\|download\)/ contains=NONE
syn match jsUserGrant contained /window\.\%(close\|focus\)/ contains=NONE

syn match jsUserPre3 +/+ contained conceal cchar=  contains=NONE
syn match jsUserPre2 +/+ contained conceal cchar=⸱ contains=NONE
      \ nextgroup=jsUserKey skipwhite
syn match jsUserPre +^/\ze/ +    contained conceal cchar=⎟ nextgroup=jsUserPre2
syn match jsUserPre +^/\ze/ ==+  contained conceal cchar=Ⳡ nextgroup=jsUserPre3
syn match jsUserPre +^/\ze/ ==/+ contained conceal cchar=⎠ nextgroup=jsUserPre3

syn match jsURL +https\?://\w*:\d*\%(/\w\+\)/*\S*+ contained contains=NONE

syn match jsUserValue /\S.*\ze$/ contained
      \ contains=jsURL
syn match jsUserKey +\%(// \)\@3<=@\S\++ contained
      \ contains=jsUserKw
      \ nextgroup=jsUserValue skipwhite
syn match jsUserKey +\%(// \)\@3<=@grant+ contained
      \ contains=jsUserKw
      \ nextgroup=jsUserGrant skipwhite
syn region jsUserMeta contained extend keepend
      \ containedin=jsComment
      \ start=+// ==UserScript==+
      \ end=+// ==/UserScript==+
      \ contains=jsUserPre

" hi jsUserMeta                 guifg=#aa99aa
hi link jsUserMeta CommentNoise
hi jsUserKey                  guifg=#663366
hi jsUserKw                   guifg=#cc66cc
hi jsUserValue                guifg=#cccc99
hi jsUserGrant                guifg=#99cc99 gui=italic
hi jsUserNone                 guifg=#cc9999 gui=italic
hi link jsURL Hyperlink

hi Noise                      guifg=#aabcc7
hi jsNoise                    guifg=#ffaa44

hi jsObjectMethodType         guifg=#aaaa55
hi jsObjectKey                guifg=#eedd77
hi jsObjectColon              guifg=#ffaa44

hi link javascriptRegexpString  Regexp
hi link javascriptNumber        Number
hi link javascriptNull          Constant

hi c jsBraces | hi link jsBraces Operator
hi c jsObjectBraces | hi link jsObjectBraces jsBraces
hi c jsFuncBraces | hi link jsFuncBraces jsArrowFunction

hi jsParens                   guifg=#aaaaaa
hi jsFuncParens               guifg=#aaaaaa
hi jsParensIfElse             guifg=#aaaaaa

hi jsParen                    guifg=#88eeff
hi clear jsParenIfElse
hi link jsDestructuringAssignment jsObjectKey
hi jsDestructuringBraces      guifg=#44aadd
hi link jsDestructuringBlock jsParen
hi clear jsDestructuringValueAssignment
hi link jsDestructuringProperty jsParen
hi link jsDestructuringProperty jsParen
hi link jsDestructuringPropertyValue jsParen
hi link jsFuncArgs jsParen
 

