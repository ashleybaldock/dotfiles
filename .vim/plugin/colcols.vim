if exists("g:mayhem_loaded_colcols")
  finish
endif
let g:mayhem_loaded_colcols = 1

"
" See: ../autoload/colcols.vim
"

" Add a horizontal row guide at cursor position
" TODO
" Clear guides at the cursor position (horizontal first, then vertical)
" TODO
" command! AddColumnGuide :silent exec 'setlocal colorcolumn+=' .. virtcol('.')
" command! RemoveColumnGuide :silent exec 'setlocal colorcolumn+=' .. virtcol('.')

nnoremap <silent><script> <Plug>(mayhem_colcol_add)
    \ <Cmd>call colcols#add()<CR>
nnoremap <silent><script> <Plug>(mayhem_colcol_delete)
    \ <Cmd>call colcols#delete()<CR>
nnoremap <silent><script> <Plug>(mayhem_colcol_clear)
    \ <Cmd>call colcols#clear()<CR>
nnoremap <silent><script> <Plug>(mayhem_colcol_next)
    \ <Cmd>call colcols#next()<CR>
nnoremap <silent><script> <Plug>(mayhem_colcol_prev)
    \ <Cmd>call colcols#prev()<CR>
nnoremap <silent><script> <Plug>(mayhem_colcol_cursor_next)
    \ <Cmd>call colcols#cursorNext()<CR>
nnoremap <silent><script> <Plug>(mayhem_colcol_cursor_prev)
    \ <Cmd>call colcols#cursorPrev()<CR>

nnoremap <silent><script> <Plug>(mayhem_colorcolumn_align_right_to_next)
    \ <Cmd>call colcols#padOnColumn()<CR>
nnoremap <silent><script> <Plug>(mayhem_colorcolumn_align_right_on_next)
    \ <Cmd>call colcols#padToColumn()<CR>
" nnoremap <silent><script> <Plug>(mayhem_colorcolumn_align_left_to_next)
" nnoremap <silent><script> <Plug>(mayhem_colorcolumn_align_left_on_next)


" 
