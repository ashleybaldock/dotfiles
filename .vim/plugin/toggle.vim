if exists("g:mayhem_loaded_toggle")
  finish
endif
let g:mayhem_loaded_toggle = 1

"
" See: ../autoload/toggle.vim
"
" Toggle a boolean variable's state, triggering a User autocmd
" with a predictable name that can be listened for
"
command! -nargs=1 -complete=var Toggle call toggle#toggle(<f-args>)

