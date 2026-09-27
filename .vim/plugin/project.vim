if exists("g:mayhem_loaded_project")
  finish
endif
let g:mayhem_loaded_project = 1

"
" Related:
"   $VIMHOME/autoload/project.vim
"

command! -bar HasProjectRoot echo project#root()->get('isProject')
command! -bar ProjectRoot echo project#root()->get('path')
command! -bar CdProjectRoot exec 'cd' project#root()->get('path')

