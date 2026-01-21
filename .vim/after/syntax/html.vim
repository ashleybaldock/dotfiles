
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

hi htmlH1  guifg=#ffafff guisp=#ff00ff gui=underline
hi htmlH2  guifg=#efbfff guisp=#fa08fa gui=underline
hi htmlH3  guifg=#dfcff8 guisp=#ee10ee gui=underline
hi htmlH4  guifg=#c8bff8 guisp=#ea18ea gui=underdashed
hi htmlH5  guifg=#bfcfef guisp=#dd20dd gui=underdotted
hi htmlH6  guifg=#a8dfef guisp=#cc28cc gui=underdotted
hi link htmlHead  PreProc
hi link htmlTitle Title
