

" Make this work with $variables
" const RevealExports = styled.div<{ expanded: boolean }>``;
" const RevealExports = styled.div<{ $expanded: boolean }>`
"
syn match styledTypescriptPrefix
      \ "\<styled\>\%((\%('\k\+'\|\"\k\+\"\|\k\+\))\|\.\k\+\)<\%(\[\|\]\|{\|}\||\|&\|:\|;\|,\|?\|'\|\"\|\$\?\k\|\s\|\n\)\+>"
      \ transparent fold extend
      \ nextgroup=styledDefinition
      \ contains=cssTagName,
      \          typescriptBraces,typescriptOpSymbols,typescriptEndColons,
      \          typescriptParens,typescriptStringS,@typescriptType,
      \          typescriptType,foldBraces,
      \          styledTagNameString
      \ containedin=foldBraces

