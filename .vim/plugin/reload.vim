if exists("g:mayhem_loaded_reload")
  finish
endif
let g:mayhem_loaded_reload = 1

"
" Reload a plugin after unsetting flag to avoid reloading
"
" (This doesn't work on itself at the moment)
"
" Works if the 'if exists(name) finish endif' is
" the first non-commented thing in the file
"
function! s:SetReloadName(name)
  let s:reloadvar = a:name
  return a:name
endfunc
function! s:UnsetAndReload(pluginfile = expand('%')) abort
  for line in readfile(fnameescape(a:pluginfile), '', 10)
    let result = substitute(line, '\_^\s*if \s*exists(\s*\([''"]\)\zs\([bwtgls]:[A-Za-z][A-Za-z0-9_]*\ze\)\1)', {m -> s:SetReloadName(m[0])}, '')
  endfor

  echom 'UnsetAndReload detected reloadvar: '''..s:reloadvar..''''
  if exists(s:reloadvar)
    exec 'let '..s:reloadvar..'=0'
    exec 'unlet '..s:reloadvar
  endif

  so %
endfunc

function! s:UnsetAndReloadComplete(ArgLead, CmdLine, CursorPos)
  return map(globpath('$HOME/.vim/plugin/', a:ArgLead .. "*.vim", 0, 1),
        \ {_, val -> fnamemodify(val, ":t")})
endfunc

command! -bar -nargs=? -complete=customlist,<SID>UnsetAndReloadComplete
      \ UnsetAndReload call <SID>UnsetAndReload(<f-args>)


" %s/\%^\(\_^\s*".*\_$\)*\_^\s*if \s*exists(\s*\(['"]\)\(\zs\([bwtgls]:\)\=[A-Za-z][A-Za-z0-9_]*\ze\)\2\s*)\s*\n\=\s*finish\s*\n\=\s*endif/\=s:SetReloadName(submatch(0))/n

