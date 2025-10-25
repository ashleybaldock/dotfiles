"
" JavaScript Syntax Extensions
"
" au BufWritePost <buffer> syn on
"
" See Also:
"       $VIMRUNTIME/syntax/javascript.vim


source <script>:p:h/common.vim


hi Noise guifg=#aabcc7
hi jsNoise guifg=#ffaa44

hi jsObjectMethodType guifg=#aaaa55
hi jsObjectKey guifg=#eedd77
hi jsObjectColon guifg=#ffaa44

hi clear jsBraces | hi link jsBraces Operator
hi clear jsObjectBraces | hi link jsObjectBraces jsBraces
hi clear jsFuncBraces | hi link jsFuncBraces jsArrowFunction

hi jsParens guifg=#aaaaaa
hi jsFuncParens guifg=#aaaaaa
hi jsParensIfElse guifg=#aaaaaa

hi jsParen guifg=#88eeff
hi clear jsParenIfElse
hi link jsDestructuringAssignment jsObjectKey
hi jsDestructuringBraces guifg=#44aadd
hi link jsDestructuringBlock jsParen
hi clear jsDestructuringValueAssignment
hi link jsDestructuringProperty jsParen
hi link jsDestructuringProperty jsParen
hi link jsDestructuringPropertyValue jsParen
hi link jsFuncArgs jsParen
 

