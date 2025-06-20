if exists("g:mayhem_loaded_project_root")
  finish
endif
let g:mayhem_loaded_project_root = 1


" Search across files

"
" Get a useful search root folder
"
" Look for:
" - parent git dir
" - marker files (.root etc.)
" - folder patterns
" Falls back to cwd()
" 
function! ProjectRoot() abort
  let l:root_dirs = ['.git']
  let l:root_files = ['.vim/vimrc', '.root', '.gitignore']
  for l:item in l:root_dirs
    let l:dirs = finddir(l:item, '.;~', -1)
    if !empty(l:dirs)
      return {'isProject': v:true, 'path': fnameescape(fnamemodify(l:dirs[0].'/../', ':p:h'))}
    endif
  endfor
  for l:item in l:root_files
    let l:files = findfile(l:item, '.;~', -1)
    if !empty(l:files)
      return { 'isProject': v:true, 'path': fnameescape(fnamemodify(l:files[-1], ':p:h'))}
    endif
  endfor
  return {'isProject': v:false, 'path': getcwd()}
endfunc

command! -bar HasProjectRoot echo get(ProjectRoot(), 'isProject')
command! -bar ProjectRoot echo get(ProjectRoot(), 'path')
command! -bar CdProjectRoot exec 'cd' get(ProjectRoot(), 'path')

