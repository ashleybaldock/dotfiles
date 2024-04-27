if exists("g:mayhem_loaded_css")
  finish
endif
let g:mayhem_loaded_css = 1


" Change hex color codes to uppercase
command! UppercaseHex :%s/\<\(#[0-9a-fA-F]\{8}\|#[0-9a-fA-F]\{6}\|#[0-9a-fA-F]\{4}\|#[0-9a-fA-F]\{3}\)\>/\U&/g
" Change hex color codes to lowercase
command! LowercaseHex :%s/\<\(#[0-9a-fA-F]\{8}\|#[0-9a-fA-F]\{6}\|#[0-9a-fA-F]\{3}\)\>/\L&/g
" Expand short hex codes (#F0E ▬▶︎ #FF00EE, #FB3A ▬▶︎ #FFBB33AA)
command! ExpandHex :%s/\<#\([0-9a-fA-F]\)\([0-9a-fA-F]\)\([0-9a-fA-F]\)\>/#\1\1\2\2\3\3/g
