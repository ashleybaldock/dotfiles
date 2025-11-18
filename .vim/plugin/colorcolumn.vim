if exists("g:mayhem_loaded_colorcolumn")
  finish
endif
let g:mayhem_loaded_colorcolumn = 1

" ╭── Column Guides ─────────────────────────────────────
" │ 
" ├─▻ AddColGuide                 ┊+┊      Add column guide at cursor
" ├─▻ LeftToColGuide  ⎛ A̲bc ▬▶︎ A̲bc┃▒┃    ⎞ Align selection To.. Left
" ├─▻ RightToColGuide ⎝ A̲bc ▬▶︎    ┃▒┃A̲bc ⎠                      Right 
" ├─▻ LeftOnColGuide  ⎛ A̲bc ▬▶︎  A̲b┃c┃    ⎞ Align selection On.. Left
" ├─▻ RightOnColGuide ⎝ A̲bc ▬▶︎    ┃A̲┃bc  ⎠                      Right
" ╰─▻ RemoveColGuide              ┊✕┊      Remove the column guide nearest to
"                                          the cursor, if two are equally close, 
"                                          remove the leftmost first.


command! AddColumnGuide :silent exec 'setlocal colorcolumn+=' .. virtcol('.')
command! RemoveColumnGuide :silent exec 'setlocal colorcolumn+=' .. virtcol('.')

nnoremap <silent><script> <Plug>(mayhem_colorcolumn_add)
nnoremap <silent><script> <Plug>(mayhem_colorcolumn_delete)
nnoremap <silent><script> <Plug>(mayhem_colorcolumn_next)
nnoremap <silent><script> <Plug>(mayhem_colorcolumn_prev)



nnoremap <plug>(CC#CursorNext) <ScriptCmd>CursorNextCC()<CR>
nnoremap <plug>(CC#CursorPrev) <ScriptCmd>CursorPrevCC()<CR>
" ColorColumn guides TODO
command! AlignRightToColorColumn :call <SID>PadToColumn()
command! AlignRightOnColorColumn :call <SID>PadOnColumn()
command! AlignLeftToColorColumn :
command! AlignLeftOnColorColumn :

command! AlignCenteredOn :
command! AlignCenteredBetween :

" nnoremap §\ 
" Add a horizontal row guide at cursor position
" TODO
" Clear guides at the cursor position (horizontal first, then vertical)
" TODO
" 
nnoremap §<S-\> :setlocal colorcolumn=<CR>
