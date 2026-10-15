if exists("g:mayhem_loaded_format")
  finish
endif
let g:mayhem_loaded_format = 1

"
" Related:
"   $VIMHOME/autoload/format.vim
"   $VIMHOME/vimrc
"

command! -bar -range=% -nargs=? FormatBuffer call format#buffer(<q-args>)

nnoremap <unique> <silent><script> <Plug>(mayhem_format_buffer) <Cmd>%call format#buffer()<CR>

