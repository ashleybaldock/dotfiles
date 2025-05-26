"
" Syntax rules common to multiple file types
" Some:
" e.g. hiding fold markers
"

syn match ConcealMark +{{{\d\?+ conceal contains=NONE containedin=ALL
syn match ConcealMark +}}}\d\?+ conceal contains=NONE containedin=ALL
syn match ConcealTitle +\%({{{\d\?\)\@4<=.*\s*\%(\*\\\)\?$+
      \ containedin=ConcealRow

syn region ConcealRow contains=ConcealMark,ConcealTitle containedin=cssComment,javaScriptComment

hi def link ConcealTitle PreProc
