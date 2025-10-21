"
" JavaScript Syntax Extensions
"
" au BufWritePost <buffer> syn on
"
" See Also:
"       $VIMRUNTIME/syntax/javascript.vim


source <script>:p:h/common.vim


hi Noise guifg=#aabcc7

hi jsObjectMethodType guifg=#aaaa55
hi jsObjectKey guifg=#eedd77

hi clear jsBraces
hi link jsBraces Operator
hi clear jsObjectBraces
hi link jsObjectBraces jsBraces
hi clear jsFuncBraces
hi link jsFuncBraces jsArrowFunction

hi jsParen guifg=#88eeff
 

