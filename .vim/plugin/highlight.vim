if exists("g:mayhem_loaded_highlight")
  finish
endif
let g:mayhem_loaded_highlight = 1

"
" See Also: ../autoload/hi.vim
"

command! -bar HiHi call hi#hi()

nnoremap <silent><script> <Plug>(mayhem_hihi) <Cmd>call hi#hi()<CR>

nnoremap <silent><script> <Plug>(mayhem_nohihi) <Cmd>call hi#nohi()<CR>
