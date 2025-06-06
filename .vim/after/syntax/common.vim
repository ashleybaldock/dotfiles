"
" Syntax rules common to multiple file types
"  e.g. hiding fold markers
"
" au BufWritePost <buffer> syn on
"

" syn match ConcealMark +{{{\d\?+ conceal contains=NONE containedin=ALL
" syn match ConcealMark +}}}\d\?+ conceal contains=NONE containedin=ALL
" syn match ConcealTitle +\%({{{\d\?\)\@4<=.*\s*\%(\*\\\)\?$+
"       \ containedin=ConcealRow

syn match FoldMarkName +\%({{{\d\)\@4<=.*\ze\%(-->\|\*\/\|$\)+ contained
      \ contains=NONE
syn match FoldMarkLevel +\%({{{\)\@3<=\d\?+ conceal
      \ contained contains=NONE
      \ nextgroup=FoldMarkName
syn match FoldMarkLevel +\%(}}}\)\@3<=\d\?+ conceal
      \ contained contains=NONE
syn match FoldMark +{{{+ conceal
      \ contained contains=NONE
      \ nextgroup=FoldMarkLevel,FoldMarkName
      \ containedin=cssComment,javaScriptComment,htmlComment,Comment
syn match FoldEndMark +}}}+ conceal
      \ contained contains=NONE
      \ nextgroup=FoldMarkLevel
      \ containedin=cssComment,javaScriptComment,htmlComment,Comment

hi def link FoldMark Conceal
hi def link FoldEndMark Conceal
hi def link FoldMarkLevel Function
hi def link FoldMarkName PreProc
