
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

syn match htmlHTag +<h1\>\s*\|</h1\_s*>+ contained
      \ containedin=htmlH1,htmlH2,htmlH3,htmlH4,htmlH5,htmlH6
      \ contains=htmlTagNoise
      \ nextgroup=htmlPropName,htmlPropBool,htmlTagNoise skipwhite skipempty

syn match htmlPropBool +\%(\w\+-\?\)\+\%(=\)\@!=+ contained contains=NONE
      \ nextgroup=htmlPropName,htmlPropBool,htmlTagNoise skipwhite skipempty
syn match htmlPropName +\%(\w\+-\?\)\+\%(="[^"]*"\)\@=+ contained contains=NONE
      \ nextgroup=htmlPropSep
syn match htmlPropSep +=+ contained contains=NONE nextgroup=htmlPropValue
syn match htmlPropValue +"[^"]*"+ contained nextgroup=htmlPropName,htmlPropBool,htmlTagNoise skipwhite skipempty

syn match htmlTagNoise +[</>]+ contained contains=NONE


hi def htmlHTag     guifg=#ff00ff
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

hi htmlH1  guifg=#ff98d8 guisp=#ff22ff gui=underline
hi htmlH2  guifg=#ef9fd8 guisp=#ff11ff gui=underdashed
hi htmlH3  guifg=#efa8e8 guisp=#ff00ff gui=underdotted
hi htmlH4  guifg=#dfafe8 guisp=#dd22dd gui=underdotted
hi htmlH5  guifg=#dfb8f8 guisp=#dd11dd gui=underdotted
hi htmlH6  guifg=#cfbff8 guisp=#dd00dd gui=underdotted
hi link htmlHead  PreProc
hi htmlTitle guifg=#ff44ff guisp=#dd00dd gui=underline
