if exists("g:mayhem_loaded_colcol")
  finish
endif
let g:mayhem_loaded_colcol = 1

"
" See: ../autoload/colcol.vim
"

" Add a horizontal row guide at cursor position
" TODO
" Clear guides at the cursor position (horizontal first, then vertical)
" TODO
" command! AddColumnGuide :silent exec 'setlocal colorcolumn+=' .. virtcol('.')
" command! RemoveColumnGuide :silent exec 'setlocal colorcolumn+=' .. virtcol('.')

nnoremap <silent><script> <Plug>(mayhem_colcol_add)
    \ <Cmd>call colcol#add()<CR>
nnoremap <silent><script> <Plug>(mayhem_colcol_delete)
    \ <Cmd>call colcol#delete()<CR>
nnoremap <silent><script> <Plug>(mayhem_colcol_clear)
    \ <Cmd>call colcol#clear()<CR>
nnoremap <silent><script> <Plug>(mayhem_colcol_next)
    \ <Cmd>call colcol#next()<CR>
nnoremap <silent><script> <Plug>(mayhem_colcol_prev)
    \ <Cmd>call colcol#prev()<CR>
nnoremap <silent><script> <Plug>(mayhem_colcol_cursor_next)
    \ <Cmd>call colcol#cursorNext()<CR>
nnoremap <silent><script> <Plug>(mayhem_colcol_cursor_prev)
    \ <Cmd>call colcol#cursorPrev()<CR>

nnoremap <silent><script> <Plug>(mayhem_colcol_align_right_to_next)
    \ <Cmd>call colcol#padOnColumn()<CR>
nnoremap <silent><script> <Plug>(mayhem_colcol_align_right_on_next)
    \ <Cmd>call colcol#padToColumn()<CR>
" nnoremap <silent><script> <Plug>(mayhem_colcol_align_left_to_next)
" nnoremap <silent><script> <Plug>(mayhem_colcol_align_left_on_next)


" 
