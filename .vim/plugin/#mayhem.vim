if exists("g:mayhem_loaded__mayhem_before_plugin")
  finish
endif
let g:mayhem_loaded__mayhem_before_plugin = 1

"
" Before Plugins Load:
"
" Set up commands that need to exist before anything else
"
" See Also:
"     ../autoload/mayhem.vim
"     ./commands.vim
"

command! -nargs=1 -bar DoUserAutocmd call mayhem#doUserAutocmd(<q-args>)
