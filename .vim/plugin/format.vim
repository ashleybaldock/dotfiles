if exists("g:mayhem_loaded_format")
  finish
endif
let g:mayhem_loaded_format = 1

"
" See: ../autoload/format.vim
"

command! -bar -range=% -nargs=? FormatBuffer call format#buffer(<q-args>)

xnoremap <unique> <silent><script> <Plug>(mayhem_format_buffer) <Cmd>call format#buffer()<CR>


" let a = ['d', "t", `w`, 'l', ["qs", 'vq"', '"qv'], '0', '''6''', '2', "hello ""world"""]]
