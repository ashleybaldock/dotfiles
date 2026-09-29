if exists("g:mayhem_loaded_synfo")
  finish
endif
let g:mayhem_loaded_synfo = 1

"
" Related:
"   $VIMHOME/autoload/synfo.vim
"   $VIMHOME/notes/synfo-ui.md
"

command! -bar SynFo <Cmd>call synfo#popup()<CR>


nnoremap <silent><script> <Plug>(mayhem_synfo_popup) <Cmd>call synfo#popup(winnr())<CR>

nnoremap <silent><script> <Plug>(mayhem_synfo_on) <Cmd>call synfo#on(winnr())<CR>

nnoremap <silent><script> <Plug>(mayhem_synfo_off) <Cmd>call synfo#off(winnr())<CR>

nnoremap <silent><script> <Plug>(mayhem_synfo_toggle) <Cmd>call synfo#toggle(winnr())<CR>

nnoremap <silent><script> <Plug>(mayhem_synfo_alloff) <Cmd>call synfo#alloff()<CR>
