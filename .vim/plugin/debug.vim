if exists("g:mayhem_loaded_debug")
  finish
endif
let g:mayhem_loaded_debug = 1

"
" See Also:
"    ./debug.winfo.vim
"    ./debug.cursor.vim
"




function s:FormatInfo()
  setlocal filetype=javascript buftype=nowrite nobuflisted
  file notarealfile.js
  setlocal nomodified
  Prettier
  " call CocAction('format')
  setlocal nomodified nomodifiable
  0file
endfunc
command! FormatInfo call <SID>FormatInfo()


