
"
" HTML/SVG/XML etc. Syntax Extensions
"
"
" au BufWritePost <buffer> syn on
"
"
" See Also:
"       $VIMRUNTIME/syntax/css.vim
"   ../../demo/css-regex-tests.css

" TODO
"

syn match xmlnsConceal +xmlns="http://www.w3.org/1999/xhtml"+ contains=NONE contained containedin=htmlTag conceal cchar=􀇺
syn match xmlnsConceal +xmlns="http://www.w3.org/2000/svg"+ contains=NONE contained containedin=htmlTag conceal cchar=􀇺

