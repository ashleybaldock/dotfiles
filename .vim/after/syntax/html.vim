
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

syn match xmlnsXhtmlConceal +xmlns="\zshttp://www.w3.org/1999/\zexhtml"+ contained containedin=@htmlTag

syn match xmlnsSvgConceal +xmlns="\zshttp://www.w3.org/2000/\zesvg"+ contained containedin=@htmlTag

