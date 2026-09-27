if exists("g:mayhem_autoloaded_project") || &cp
  finish
endif
let g:mayhem_autoloaded_project = 1

"
" See: ../plugin/project.vim
"

"
" Get a useful search root folder
"
" Look for:
" - parent git dir
" - marker files (.root etc.)
" - folder patterns
" Falls back to cwd()
" 
function! project#root() abort
  let l:root_dirs = ['.git']
  let l:root_files = ['.vim/vimrc', '.root', '.gitignore']

  for l:item in l:root_dirs
    let l:dirs = finddir(l:item, '.;~', -1)
    if !empty(l:dirs)
      return {'isProject': v:true, 'path': fnamemodify(l:dirs[0] .. '/../', ':p:h')->fnameescape()}
    endif
  endfor

  for l:item in l:root_files
    let l:files = findfile(l:item, '.;~', -1)
    if !empty(l:files)
      return { 'isProject': v:true, 'path': fnamemodify(l:files[-1], ':p:h')->fnameescape()}
    endif
  endfor

  return {'isProject': v:false, 'path': getcwd()}
endfunc
