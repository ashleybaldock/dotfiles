if exists("g:mayhem_loaded_char")
  finish
endif
let g:mayhem_loaded_char = 1

"
" See: ../autoload/char.vim
"

" s/\zs\(\%#\)\ze/\=ReplaceBaseCharWith(submatch(0))/n
command! -bar -nargs=+ ReplaceBaseCharWith echo char#rebase(<q-args>)

command! -bar -nargs=? GetCharClass echo char#class(<f-args>)

command! -bar -nargs=? GetCharCode echo char#code(<f-args>)

command! -bar -nargs=? GetCharCodeMatch echo char#match(<f-args>)

" xnoremap <unique> <silent><script> <Plug>(mayhem_char_code) <Cmd>call char#code()<CR>

