if exists("g:mayhem_loaded_fold")
  finish
endif
let g:mayhem_loaded_fold = 1


"
" Get a list of fold locations to make signs for
"
function! FoldSigns()
endfunc

"
" Custom folding
"
function! FoldLevel()
endfunc

function! FoldTextMarker()
  let line = getline(v:foldstart)
  let sub = substitute(trim(line), '<!--\|-->\|/\*\|\*/\|{{{\d\=', '', 'g') 
  let folded = str2nr(v:foldend) - str2nr(v:foldstart)
  return '╴' ..  substitute(v:folddashes, '-', '❰', 'g') .. ' ' ..  sub .. ' ❱╶ ─ ╴❰ ' .. folded .. ' lines folded ❱' 
endfun

" gitgutter#fold#is_changed()
function! FoldTextIndent()
  let line = getline(v:foldstart)
  let sub = substitute(line, '<!--\|-->\|/\*\|\*/\|{{{\d\=', '', 'g') 
  let folded = str2nr(v:foldend) - str2nr(v:foldstart)
  return sub[:30] .. ' //════════❰ ' .. folded .. ' lines folded ❱'
endfun


" vim:set foldmethod=manual
