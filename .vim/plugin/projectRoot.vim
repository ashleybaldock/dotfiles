" Search across files
" Get a useful search root folder
" - parent git dir
" - folder patterns
:function! ProjectRoot()
  let l:root_dirs = ['.git']
  let l:root_files = ['.root', '.gitignore']
  for l:item in l:root_dirs
    let l:dirs = finddir(l:item, '.;~', -1)
    if !empty(l:dirs)
      return fnameescape(fnamemodify(l:dirs[-1].'/../', ':p:h'))
    endif
  endfor
  for l:item in l:root_files
    let l:files = findfile(l:item, '.;~', -1)
    if !empty(l:files)
      return fnameescape(fnamemodify(l:files[-1], ':p:h'))
    endif
  endfor
  return getcwd()
:endfunc

:command! -bar ProjectRoot :echo ProjectRoot()
:command! -bar CdProjectRoot :exec 'cd' ProjectRoot()

