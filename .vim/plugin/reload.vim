if exists("g:mayhem_loaded_reload")
  finish
endif
let g:mayhem_loaded_reload = 1

" %s/\%^\(\_^\s*".*\_$\)*\_^\s*if \s*exists(\s*\(['"]\)\(\zs\([bwtgls]:\)\=[A-Za-z][A-Za-z0-9_]*\ze\)\2\s*)\s*\n\=\s*finish\s*\n\=\s*endif/\=s:SetReloadName(submatch(0))/n

"
" Reload a plugin after unsetting flag to avoid reloading
"
" Works if the 'if exists(name) finish endif' is
" the first non-commented thing in the file
"
function! s:SetReloadName(name)
  echom a:name
  let s:reloadvar = a:name
  return a:name
endfunc
function! s:UnsetAndReload() abort
  for line in readfile(fnameescape(expand('%')), '', 10)
    echom line
    let result = substitute(line, '\_^\s*if \s*exists(\s*\([''"]\)\zs\([bwtgls]:[A-Za-z][A-Za-z0-9_]*\ze\)\1)', {m -> s:SetReloadName(m[0])}, '')
    echom result
  endfor

  echom 'UnsetAndReload detected reloadvar: '''..s:reloadvar..''''
  if exists(s:reloadvar)
    exec 'let '..s:reloadvar..'=0'
    exec 'unlet '..s:reloadvar
  endif

  so %
endfunc

command! UnsetAndReload call <SID>UnsetAndReload()

