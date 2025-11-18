if exists("g:mayhem_loaded_colorcolumn")
  finish
endif
let g:mayhem_loaded_colorcolumn = 1

"
" See: ../autoload/colcols.vim
"

" command! AddColumnGuide :silent exec 'setlocal colorcolumn+=' .. virtcol('.')
" command! RemoveColumnGuide :silent exec 'setlocal colorcolumn+=' .. virtcol('.')

nnoremap <silent><script> <Plug>(mayhem_colcol_add)
    \ <Cmd>call colcols#add()<CR>
nnoremap <silent><script> <Plug>(mayhem_colcol_delete)
    \ <Cmd>call colcols#delete()<CR>
nnoremap <silent><script> <Plug>(mayhem_colcol_next)
    \ <Cmd>call colcols#next()<CR>
nnoremap <silent><script> <Plug>(mayhem_colcol_prev)
    \ <Cmd>call colcols#prev()<CR>
nnoremap <silent><script> <Plug>(mayhem_colcol_cursor_next)
    \ <Cmd>call colcols#cursorNext()<CR>
nnoremap <silent><script> <Plug>(mayhem_colcol_cursor_prev)
    \ <Cmd>call colcols#cursorPrev()<CR>



" nnoremap <plug>(CC#CursorNext) <ScriptCmd>CursorNextCC()<CR>
" nnoremap <plug>(CC#CursorPrev) <ScriptCmd>CursorPrevCC()<CR>
" ColorColumn guides TODO
" command! AlignRightToColorColumn :call <SID>PadToColumn()
" command! AlignRightOnColorColumn :call <SID>PadOnColumn()
" command! AlignLeftToColorColumn :
" command! AlignLeftOnColorColumn :

" command! AlignCenteredOn :
" command! AlignCenteredBetween :

" nnoremap §\ 
" Add a horizontal row guide at cursor position
" TODO
" Clear guides at the cursor position (horizontal first, then vertical)
" TODO
" 
nnoremap §<S-\> :setlocal colorcolumn=<CR>
