
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

syn region htmlComment keepend
      \ matchgroup=htmlCommentEnds start=+<!--\%(-\?>\)\@!+
      \ end=+--!\?>+
      \ concealends
      \ contains=htmlCommented,htmlCommentBang,htmlCommentNested,@htmlPreProc,@Spell

" commented-out html
syn region htmlCommented oneline contained
      \ matchgroup=Conceal start=+\%(<!--\)\@4<=\s*\%(<\)\@=+
      \ end=+\%(>\)\@1<=\s*\%(--!\?>\)\@=+
      \ concealends
      \ contains=@Spell

syn region htmlCommentBang oneline contained
      \ matchgroup=CommentBright start=+\%(<!--\)\@4<=\s*!+
      \ end=+-\|$+
      \ contains=@Spell

syn region htmlDoctype keepend
      \ start=+<!DOCTYPE+
      \ end=+>+

syn region htmlH start="<h\z(1\)\>" end="</h\z1\_s*>"me=s-1 contained
      \ contains=htmlTagNoise,@htmlTop
      \ containedin=htmlH1,htmlH2,htmlH3,htmlH4,htmlH5,htmlH6

syn match htmlPropBool +\%(\w\+-\?\)\+\%(=\)\@!=+ contained contains=NONE
      \ skipwhite skipempty nextgroup=htmlPropName,htmlPropBool,htmlTagNoise
syn match htmlPropName +\%(\w\+-\?\)\+\%(="[^"]*"\)\@=+ contained contains=NONE
      \ nextgroup=htmlPropSep skipwhite skipempty
syn match htmlPropSep +=+ contained contains=NONE
      \ nextgroup=htmlPropValue
syn match htmlPropValue +"[^"]*"+ contained
      \ skipwhite skipempty nextgroup=htmlPropName,htmlPropBool,htmlTagNoise

syn match htmlTagNoise +<+ contained contains=NONE
      \ nextgroup=htmlPropName,htmlPropBool skipwhite skipempty
syn match htmlTagNoise +[/>]+ contained contains=NONE


hi def htmlH        guifg=#ff00ff
hi def htmlPropSep  guifg=#880088
hi def htmlTagNoise guifg=#880088
hi def htmlPropName guifg=#cc33ff
hi def link htmlPropValue String

hi link htmlDoctype Commented
hi link htmlComment CommentSubtle
hi link htmlCommented Commented
hi link htmlCommentBang CommentTitle

hi link htmlTag Statement
hi link htmlEndTag Statement
hi link htmlArg Type
hi link htmlTagName Identifier
hi link htmlSpecialTagName Exception
hi link htmlMathTagName Identifier
hi link htmlSvgTagName Conceal
hi link htmlValue String
hi link htmlSpecialChar Special

hi htmlH1  guifg=#ff98d8
hi htmlH2  guifg=#ef9fd8
hi htmlH3  guifg=#efa8e8
hi htmlH4  guifg=#dfafe8
hi htmlH5  guifg=#dfb8f8
hi htmlH6  guifg=#cfbff8
hi link htmlHead  PreProc
hi htmlTitle guifg=#dd00dd
