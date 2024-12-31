"
" Syntax rules common to multiple file types
"
" e.g. hiding fold markers
"

syn match Conceal +{{{\d+ conceal contains=NONE containedin=ALL
syn match Conceal +}}}\d+ conceal contains=NONE containedin=ALL
