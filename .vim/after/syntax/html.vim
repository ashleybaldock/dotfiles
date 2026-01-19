
"
" HTML/SVG/XML etc. Syntax Extensions
"
"
" au BufWritePost <buffer> syn on
"
"
" See Also:
"       $VIMRUNTIME/syntax/css.vim
"       $VIMRUNTIME/syntax/html.vim
"   ../../demo/css-regex-tests.css

" TODO
"

syn match xmlnsConceal +xmlns="http://www.w3.org/1999/xhtml"+ contains=NONE contained containedin=htmlTag conceal cchar=􀇺
syn match xmlnsConceal +xmlns="http://www.w3.org/2000/svg"+ contains=NONE contained containedin=htmlTag conceal cchar=􀇺

hi link htmlTag Statement
hi link htmlEndTag Statement
hi link htmlArg Type
hi link htmlTagName Identifier
hi link htmlSpecialTagName Exception
hi link htmlMathTagName Identifier
hi link htmlSvgTagName Conceal
hi link htmlValue String
hi link htmlSpecialChar Special

hi htmlH1  guifg=#dd00dd
hi htmlH2  guifg=#cc00cc
hi htmlH3  guifg=#aa00aa
hi htmlH4  guifg=#ee00ee
hi htmlH5  guifg=#dd88dd
hi htmlH6  guifg=#dd66dd
hi link htmlHead  PreProc
hi link htmlTitle Title
