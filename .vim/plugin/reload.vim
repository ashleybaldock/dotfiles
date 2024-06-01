if exists("g:mayhem_loaded_reload")
  finish
endif
let g:mayhem_loaded_reload = 1

"
" Reload a plugin after unsetting flag to avoid reloading
"
" Works if the 'if exists(name) finish endif' is
" the first non-commented thing in the file
"
function! s:SetReloadName(name)
  let s:reloadvar = a:name
endfunc
function! s:UnsetAndReload()
  let scratch = bufnr('mayhem_scratch_reload', 1)

  exec '0read '..fnameescape(expand('%'))

  let s:reloadvar = v:none
  %s/\%^\(\_^\s*".*\_$\)*\_^\s*if \s*exists(\s*\(['"]\)\(\zs\([bwtgls]:\)\=[A-Za-z][A-Za-z0-9_]*\ze\)\2\s*)\s*\n\=\s*finish\s*\n\=\s*endif/\=s:SetReloadName(submatch(0))/n
  nohlsearch
  
  if exists(s:reloadvar)
    exec 'unlet '..s:reloadvar
  endif

  exec 'bdelete! '..scratch
  so %
endfunc
command! UnsetAndReload call <SID>UnsetAndReload()

